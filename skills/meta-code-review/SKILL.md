---
name: meta-code-review
description: Review a GitLab merge request by triaging changed file paths to select which component reviews apply (code-review-jack, security-review, pnm-code-review, pnm-perf-review), running them in parallel as read-only subagents, and merging results into a proposed list of Conventional Comments MR feedback. Critical issues (correctness, security, money-movement, release-safety) lead; maintainability is ranked by how well Claude can maintain the code for the next 5 years. Use when asked to review an MR, or to run a full or meta code review. Never posts comments.
tools: Read, Grep, Glob, Bash, Agent, Skill
---

# Meta Code Review

Input: optional branch name or MR number/URL. Default: the current branch.

## Constraints

- **Read-only.** Never edit files in the repo, post MR comments, push, commit, or run any component skill in a mode that posts or fixes (no `--comment`, no `--fix`). The only writes allowed are temp files in the scratchpad directory.
- The output is a **proposed** comment list. The user decides what gets posted.
- Report only findings with a concrete basis in the code. Preferences, style nits, and "could be cleaner" remarks are dropped unless they affect the 5-year maintainability criteria below.
- Use `gl` (alias for `glab`) for GitLab calls; fall back to `glab` when the alias is unavailable.

## Step 1: Resolve the MR (always first)

1. Determine the branch: the argument if given (MR number/URL resolves directly), otherwise `git branch --show-current`.
2. Find the MR: `gl mr view <branch-or-number> -F json`, or `gl mr list --source-branch <branch>` when only a branch is known.
3. **If no MR exists, stop.** Print `No merge request found for <branch>.` and exit. Do not fall back to a local diff.
4. Collect, into the scratchpad directory:
   - MR metadata (title, description, source/target branch, Jira key from the branch or title).
   - The MR diff (`gl mr diff <iid>`) and the list of changed paths.
   - All discussion threads (open and resolved) with file/line anchors and bodies.
5. If the resolved branch is not the checked-out branch, tell component subagents that local files may not match the MR and to rely on the saved diff.

## Step 1b: Ticket and branch checks (always run)

Run in the main session, independent of triage (they apply even when Step 2 selects no reviews).

1. **Jira key.** Extract it from the source branch name (pattern `[A-Z][A-Z0-9]+-\d+`, e.g. `MCE-1234`, `CLOUDENG-2345`). If the branch has no key, fall back to the MR title; record that the branch did not carry it.
2. **Branch name.** The source branch must equal the Jira key exactly, with no prefix or suffix (`MCE-1234`, not `feature/MCE-1234`, `MCE-1234-fix-foo`, or `mce-1234`). Any other form is a **critical** finding (Tier 1, `issue(blocking):`). If the key came only from the MR title, the finding is that the branch does not match any ticket. Release-train branches (`RELEASE-*`) and the target branch are exempt.
3. **Fetch the ticket.** Via the Atlassian MCP (`getAccessibleAtlassianResources` once for the cloudId, then `getJiraIssue` with description, labels, and comments). Fetch only this one ticket; do not follow its links. Disclose the fetch in the report. If the ticket cannot be fetched, report that and skip checks 4 and 5 rather than guessing.
4. **Description vs delivered code.** Compare the ticket description (goal, scope, acceptance criteria, requirements) against the MR diff and description. Report each difference as **High severity**:
   - described behavior absent from the diff (missing requirement);
   - behavior in the diff the ticket does not describe (scope creep, unrelated changes);
   - behavior that contradicts the description.
   Each difference needs a concrete reference: the quoted ticket requirement and the `path:line` (or the absence) in the diff. Do not report wording differences or implementation-detail differences that preserve the described behavior. If the ticket has no usable description, report that as one finding instead.
5. **Testing notes.** If the ticket's Global Labels do **not** include `Trust Me`, the ticket must include testing notes (a "Testing Notes" section in the description, a dedicated field, or a comment titled Testing Notes). A missing or empty section is a finding. If the label is present, skip this check and record `Trust Me label: testing notes not required`.

Checks 4 and 5 results feed Step 5 (see Tier 1 and "Ticket & branch checks").

## Step 2: Triage by changed paths

Classify every changed path into one group below, then take the **union** of the reviews selected for the groups present. Use only paths and file types; do not read diff content to decide.

| Path group (changed paths) | Reviews selected |
|---|---|
| Only `*.md`, `doc/**`, lockfiles (`Gemfile.lock`, `yarn.lock`, ...), generated files | none |
| Only `spec/**` | code-review-jack, pnm-code-review |
| `app/**` or `lib/**` Ruby (`*.rb`) | all four |
| `db/migrate/**`, `db/migrate-future/**`, `*.rake` | all four |
| Only `app/views/**`, `*.haml`, `*.erb`, `*.js`, `*.css`, `*.scss` | code-review-jack, pnm-code-review, security-review |
| Only `config/**` | code-review-jack, security-review |
| Any path matching no row (`bin/**`, `.rwx/**`, `Gemfile`, `public/**`, ...) | all four |

"all four" = code-review-jack, security-review, pnm-code-review, pnm-perf-review.

Record for every review not selected the reason (the path group that excluded it). If the union is empty, print `No review needed` for the component reviews and list each path group with the rule that applied, skip Steps 3-4, and still print the Step 1b results in Step 5.

## Step 3: Run selected reviews in parallel

Spawn one `general-purpose` subagent per selected review, **all in a single message** so they run concurrently. Each subagent:

- Invokes its skill via the Skill tool: `code-review-jack`, `security-review`, `pnm-skills:pnm-code-review`, or `pnm-skills:pnm-perf-review`.
- Receives the saved diff path, MR metadata path, branch/Jira context, and the read-only constraints above (no posting, no fixes, no file edits).
- If its skill would stop to ask the user a question (for example `code-review-jack` when the branch goal is unclear), it does not ask: it returns the question as a finding of type `question` and continues with the MR description as the stated goal.
- Returns findings in this structure, one per finding:
  - `file`, `line` (as on the MR diff's new side)
  - `summary`: one sentence
  - `scenario`: concrete failing inputs/state and wrong outcome (empty only for non-critical items)
  - `category`: one of `correctness`, `security`, `money-movement`, `release-safety`, `test-gap`, `doc-gap`, `other`
  - `severity_claimed`: `critical` or `non-critical`

## Step 4: Merge

1. **Dedupe.** Findings on the same file/line (or the same root cause) from different reviews merge into one. Keep the clearest wording; list every contributing skill.
2. **Classify.**
   - **Critical** = category is `correctness`, `security`, `money-movement`, or `release-safety`, backed by a concrete scenario. Not preference-based.
   - Money-movement paths (payment routing, settlement, ledger) lacking guards, feature flags, or idempotency are critical.
   - Release-safety includes backward-incompatible migrations (column drop/rename in the same release), Rails 7.2 silent-failure idioms, deprecation-toolkit breakage, and perf regressions on hot paths.
   - **Highest severity wins:** if any review rates a finding critical with a concrete scenario, it is critical. Record which reviews rated it lower under `dissent`.
   - A critical claim with no concrete scenario drops to Maintainability if it fits the criteria below, otherwise is discarded.
3. **Maintainability tier.** Keep only findings that reduce Claude's ability to maintain this code over the next 5 years, judged on exactly two signals:
   - **Test safety net:** behavior not pinned by tests tightly enough that a future edit cannot be verified without a human oracle.
   - **Documentation and intent capture:** the why is not recorded (non-obvious invariants, cross-file couplings, deliberate asymmetries, matching `doc/` page, ticket key) so a future session would have to re-derive it.

   Order the list from most to least harmful to future maintenance. Each item carries a one-line rationale naming the specific loss, e.g. "no test pins the retry branch, so a future edit cannot be verified". Do not rank by design metrics or style.
4. **Suppress existing threads.** Drop any proposal that restates an open or resolved thread on the MR (same file region and substance). Count the suppressed items.

## Step 5: Output

Print the report in this order. Nothing is posted.

1. **Header:** MR reference, branch, target, Jira key, tickets fetched (per Step 1b).
2. **Reviews run / skipped:** each of the four with `ran` or `skipped: <reason>`.
3. **Tier 1: Critical.** Each item:
   - Label: always `issue(blocking):`
   - Anchor: `path:line` (for ticket-description differences, the diff location or `MR description` / `Jira <KEY>` when the gap is an absence)
   - Tag: category, e.g. `[critical/security]`; ticket-description differences use `[high/ticket-mismatch]` and are listed first within the tier; a branch name that does not equal the Jira key uses `[critical/branch-name]` and is listed after them, with the actual and expected names in the body
   - Ready-to-post comment body (what the MR comment would say, including the failing scenario)
   - Sources: contributing skills; `dissent:` skills that rated it lower, if any
4. **Tier 2: Maintainability** (ordered most to least harmful). Each item:
   - Label: `issue(non-blocking):` for a concrete test or doc gap; `suggestion(non-blocking):` for an improvement; `question:` when intent is unclear
   - Anchor, tag `[maintainability/test-gap]` or `[maintainability/doc-gap]`, ready-to-post body, one-line rationale, sources
5. **Ticket & branch checks** (from Step 1b). One line each, `pass` or a finding:
   - Branch name vs Jira key: `pass`, or a pointer to the Tier 1 item.
   - Testing notes: `issue(non-blocking):` when missing and no `Trust Me` label; otherwise `pass` or `not required (Trust Me)`.
   - Description vs code: `pass`, or a pointer to the Tier 1 items.
6. **Counts:** critical (with the high/ticket-mismatch and branch-name subsets), maintainability, ticket/branch findings, suppressed duplicates of existing threads, skipped reviews.

If Tiers 1 and 2 and the ticket/branch findings are all empty, state `No findings` with the counts.
