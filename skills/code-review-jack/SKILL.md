---
name: code-review-jack
description: Review code for quality, correctness, and maintainability by analyzing diffs across multiple phases (linting, code smells, design-quality scoring via flog/reek/flay, cohesion, readability, test coverage, defect detection). Use when reviewing pull requests, examining code changes, or before committing changes.
tools: Read, Grep, Glob, Bash
---

# Code Review

## When to Use

- When performing code review.
- Before committing my changes.

## Constraints

- **NEVER modify, create, or delete any files.** This is a read-only skill — do not invoke Edit, Write, or NotebookEdit.
- Do not invoke Bash-tool commands with side effects (no `git commit`, `git push`, `gh pr edit`, file writes, package installs, etc.). Read-only commands like `git diff`, `git log`, `gh pr view`, and linters in check-only mode are fine.
- Present all feedback as commentary — never apply fixes directly.
- Only review changed lines unless checking for defects that span surrounding code.

## Instructions

Your job is to identify issues in the code which has been changed, which may affect stability of the system or mid-term maintainability.  You also should assess that the code achieves the goals outlined for the branch.

The code being changed will often be contained in other code which has not changed.  While you should use surrounding code for context and defect checking, please do not attempt to correct code style, or code smell, of surrounding code.  Do ensure that the surrounding code does not contain defects.

If available, read additional information about code reviews from files in the @prompts/ directory.

Execute each phase in order.  Present findings per-phase in the final report.

### Phase 1: Scope & Context

- If the branch name matches a Jira ticket format, read ticket details using the Atlassian MCP tools (`mcp__claude_ai_Atlassian__getJiraIssue` and related). Fall back to the `j` CLI via the Bash tool if MCP tools are unavailable.
  - Check related tickets, especially on feature or release branches.
  - If clear goals for the branch are not outlined, immediately stop and ask for a description of the problem being solved.
- Determine the base branch and collect the diff.
  - Use the git remote locations to determine where to check for more information.
    - When using Gitlab, use the `glab` CLI tool via the Bash tool to check for existing Merge Requests.
    - When using Github, use the `gh` CLI tool via the Bash tool to check for existing Pull Requests and Issues.
  - If you cannot determine the base branch, stop and ask which branch to compare to.

### Phase 2: Linting

Only lint changed lines, not surrounding code.

- In Ruby:
  - If Rubocop or StandardRB are used in the project, use those tools as a guide for detecting linting errors.
    - If neither is explicitly enabled, attempt to use `standardrb` in standalone mode for guidance.
  - Only advise on medium and high priority rules.

### Phase 3: Code Smells

Only report smells in changed code; ignore surrounding code smells.

- In Ruby:
  - If `rubycritic` is available, use it to detect code smells.
  - Only advise on medium and high priority smells.

### Phase 4: Design Quality (flog / reek / flay)

Where Phase 3 leans on judgment (aided by `rubycritic` when available), this phase runs three deterministic tools against the same diff to score the *design* of new and changed Ruby code specifically — never the surrounding legacy file or method as a whole. Target new code first, modified code second.

- **Availability.** Check `flog`, `reek`, and `flay` are on `PATH` (e.g. `command -v flog reek flay`). If any is missing, note its absence in the report and skip it — do not install gems or touch the Gemfile on the reviewer's behalf; these tools normally live outside the bundle (`gem install reek flog flay`). If the repo already ships its own wrapper for this kind of check (a script under `bin/`, `script/`, or `commands/` — look for something like `design_quality`, `quality`, or similar), prefer running that over the raw commands below: it already encodes that repo's own thresholds and exclusions. `rubycritic --no-browser <files>` is an optional HTML rollup of the same three tools' findings for a human reader; it adds no signal beyond running them directly.
- **Scope.**

  | Change | In scope | Out of scope |
  |---|---|---|
  | New file | every method, plus the class total | — |
  | Modified file | each method/block containing a changed line (the enclosing method) | every other finding in the file — leave it alone |

  Run the tools against the diff's Ruby files (reuse the file list and base branch from Phase 1). Before running, exclude non-design targets: spec/test directories, `db/migrate`, `vendor`, `tmp`, `log`, generated or vendored code, and anything the repo's own `.reek.yml` already excludes (reek picks that file up automatically from the repo root — flog and flay do not, so apply the same exclusion list to them by hand). Map every finding back to `git diff -U0` and drop anything outside the changed lines.
- **Bands** (a repo's own `.reek.yml` thresholds win when they differ from these defaults):

  | Tool | Finding | Action |
  |---|---|---|
  | flog | in-scope method **≥ 60** | Blocking — refactor when a clear path exists, otherwise escalate (below) |
  | flog | in-scope method **25–59** | Advisory — split it, or state in one line why it stays |
  | flog | new-file class `total` **> 100** | Advisory — consider splitting responsibilities |
  | flog | < 25 | Silent |
  | reek | any smell located inside in-scope code | Fix it, or state in one line why it stays |
  | flay | group (mass ≥ 40) with **all** locations in-scope | Blocking — extract the shared code, otherwise escalate (below) |
  | flay | group pairing in-scope code with untouched legacy | Advisory — name it; never refactor the legacy side |

  A touched legacy method already ≥ 60: only reduce it if the reduction stays inside that method; otherwise the edit must not push any touched method across the 25 or 60 line, and the report says so.
- **Fixing, not gaming.**
  - Lower flog by removing branching/call density: extract an intention-revealing method, replace an `if`/`case` chain with a lookup table or polymorphism, introduce a value/parameter object for a data clump, move an envious method to the class whose data it reads. Splitting into `part_1`/`part_2` helpers is not a fix — same design, lower number.
  - No `# :reek:` suppression comments, and no edits to the repo's `.reek.yml` just to pass — state a deliberate trade-off in the report instead.
  - An advisory on a method that only orchestrates collaborators is often acceptable to leave as-is — say so explicitly rather than silently.
- **When to escalate instead of fixing.** Attempt a real fix first — reread "Fixing, not gaming" and try at least one non-cosmetic refactor. Two distinct reasons to stop and flag for the user instead of forcing a fix through:
  - **No clear fix** — every refactor attempted just relocates the smell (extraction shifts the flog score onto the caller; the same `FeatureEnvy` reappears on a different class).
  - **Out of scope** — the correct fix is known, but making it would expand the change well beyond what was asked: it touches callers/files/modules the task didn't name, or is a genuine architectural decision (a new abstraction, a public API change) rather than a local edit.

  Either way, stop attempting further fixes. In the report, name the finding, which of the two reasons applies, what was tried (or what the real fix would touch), and a recommendation.
- **Reporting.** Most reviewers do not know flog, reek, or flay. Gloss every named finding in plain language instead of reporting the bare tool label — name the tool term once, then explain it in ordinary words in the same clause (e.g. "flog 64 — the method is too complex: heavy branching and many calls"). One short clause per gloss; the bands above still decide blocking vs. advisory, the gloss only explains the finding.

### Phase 5: Cohesion & Placement

Only evaluate methods that are new or moved in this diff, and coupling introduced by changed lines. Do not relitigate the placement of pre-existing methods.

- For each new public method, ask whether its receiver owns the data and collaborators the method touches.
  - Flag methods that primarily orchestrate another object's internals — if nearly every line references one other class or namespace, the method is a candidate to live on that other object. (rubycritic's `FeatureEnvy` only fires on mechanical reference counts; apply this judgment even when it stays silent.)
- Flag duplicated concepts: a new method that reimplements a transformation, normalization, or rule that already exists elsewhere in the codebase, leaving two implementations that must stay in lockstep with nothing tying them together. Name both locations.
- Flag new inward coupling: core domain models reaching into lib/infrastructure namespaces for constants or logic (or the reverse) when a narrow method on the owning side would keep that knowledge in one place.
- Respect deliberate policy-vs-mechanism splits: a caller holding policy (fallback, degradation, gating) while the owning object holds the mechanism is a legitimate design. When the split is intentional and communicated, note it as verified rather than flagging it.
- Every finding must propose a specific new home (class and rough method shape) — placement critiques without a destination are not actionable.

### Phase 6: Idiomatic Patterns

Only flag non-idiomatic code in changed lines; ignore surrounding code.

- Flag code that re-invents a pattern already provided by Rails or the Ruby standard library.
  - Prefer the framework/language idiom when it expresses the same intent more clearly.
  - Only flag when the idiomatic replacement preserves behavior (including edge cases around nil, validation, and transactions).
- Examples of patterns to watch for (non-exhaustive):
  - `Model.find_by(...) || Model.create(...)` → `Model.find_or_create_by(...)`
  - `Model.where(...).first` → `Model.find_by(...)`
  - `collection.map(&:attr).compact.uniq` when a scope or `pluck` would be clearer
  - Manual nil checks (`obj && obj.foo`) → safe navigation (`obj&.foo`)
  - Procedural loops building a hash → `each_with_object`, `to_h`, or `index_by`
- Do not flag cases where the longer form is intentional (e.g., different semantics, explicit transaction control, or readability in a complex block).

### Phase 7: Readability & Intent

- Assess whether changed code communicates its intent clearly to future readers.
  - It is acceptable for code to be complex, as long as it communicates well.
- Flag comments that explain "what" instead of "why."
  - Code comments should explain why the code exists, while the code itself is responsible for explaining what the code is doing.
- Flag excessive complexity that isn't well communicated.
- Flag excessively defensive code which doesn't communicate why the defense is needed.

### Phase 8: Testability & Test Coverage

- Check that tests exist for changed code.
- Verify coverage of all branches, happy paths, and sad paths.
- Flag code that requires excessive mocks or factories to test.

### Phase 9: Test-to-Code Traceability

Phase 8 asks whether tests exist; this phase asks whether each test is paired with specific lines of production code. "Behavior" means those lines: in six months, a reader (human or agent) with only the test and the production file should be able to name the exact lines the test targets. Only evaluate tests added or modified in this diff.

- For each new or changed example, identify the production lines it targets: the branch, condition, side effect, or return path it exists to exercise. Report the file and line range you matched it to.
- Flag a test when that pairing is not identifiable:
  - The description is vague ("works", "handles it", "returns correct result") and does not name the condition and outcome of a specific branch or statement.
  - It exercises many branches or unrelated behaviors at once, so no single set of lines is its target. Prefer one example per behavior.
  - It reaches the target only through a long chain of unrelated code (large setup, broad integration path) where the targeted lines are not apparent.
  - Its assertion is not tied to the targeted lines' outcome (no assertion, or a loose one like `be_truthy`, `be_present`, `not_to raise_error` where a specific value is knowable).
- Flag changed production lines that no example pairs with: each new or modified branch, condition, and side effect should have at least one test whose target is exactly those lines.
- Verify the pairing holds: mentally mutate the targeted lines (invert the condition, drop the branch, return a constant, skip the side effect). If the test would still pass, it is not paired with those lines. Common causes: setup that already satisfies the expectation, values that coincide so a wrong argument still passes, mocks that restate their own stubs, and expectations on internal calls instead of the observable result.
- When flagging, say what is missing: which lines the test should target, and the description or assertion that would make the pairing explicit.

### Phase 10: Defect Detection

- Check changed code for logical errors, off-by-ones, race conditions, nil safety issues, etc.
- Use surrounding code as context for defect checking.
- Ensure that new code only calls methods which actually exist.
  - Be extra careful when a methos is an instance method on the current object.
  - Also take special care when dealing with an `Order`, `Payment`, or `Site` object.
- **Runtime-editable config as untrusted input.** Site resources, classic `R.*` resources, and `Settings` values are staff-editable at runtime, not code — they don't go through code review when they change. Flag any such value flowing into a method selector (`send`/`public_send`/`try`), a constant lookup (`constantize`/`safe_constantize`), a SQL or ERB fragment, a file path, a URL fetch, or a shell argument, unless an allowlist sits between the read and the sink. Being gated behind a feature flag or resource is a rollout mechanism, not a trust grant — the same scrutiny still applies once the value reaches one of those sinks.

### Phase 11: Optionality & Future Change

Assess what the change makes easier or harder later, beyond whether it is correct today. Evaluate only decisions introduced or reinforced by changed lines.

- Identify which optionality the change affects: the kinds of future change that stay cheap, become cheaper, or become more expensive. Examples:
  - Hard-coding a value, enum, or type list that is likely to vary (per site, per client, per payment method).
  - Choosing a data model, schema, column type, or uniqueness constraint that bakes in a cardinality (one-to-one vs. one-to-many).
  - Changing a public interface, API contract, event payload, or job signature that other callers or consumers depend on.
  - Coupling two concerns so that one cannot change or be replaced without the other.
  - Adding a branch or special case where a general rule would let new cases arrive as data instead of code.
  - Migrations or data backfills that are hard to reverse.
- For each effect, state concretely which future change gets harder or easier (e.g. "adding a third payment method now requires editing this case statement and the schema"), and why.
- Distinguish speculative flexibility from real optionality. Do not recommend generality for hypothetical needs; flag only reductions in options that plausibly matter given the ticket, adjacent tickets, or the code's history.
- If the change **reduces** optionality for new features, do not just list it. Stop and ask the user to confirm the trade-off before finishing the review: name the option lost, what was gained in exchange, and the cheaper alternative (if any) that preserves the option. Treat the review as incomplete until the user answers.
- If the change preserves or increases optionality, note that in one line as verified.

### Phase 12: Domain-specific guidance

Apply the matching domain skill as a checklist for changed files. Invoke each relevant skill rather than trying to recall its rules from memory.

- Files under `app/sidekiq/` or `spec/sidekiq/` → `/sidekiq-jobs` (queue concerns, service-object boundary, injected logger, idempotency, retry behavior).
- Other domain skills available in this repo: `/rails-models`, `/rails-controllers`, `/api-controllers`, `/rails-helpers`, `/rspec-conventions`, `/resource-rake-tasks`, `/secure-ruby-rails`. Invoke whichever apply to the changed paths.

## Output Format

Present findings in a succinct list, grouped by phase, calling out the areas of the code which I should review manually and why.  Include the file and line number where I should begin my review, formatted as `file_path:line_number` so the editor can jump to it.

```
## Review: [branch-name]

### Linting
- [file:line] description

### Code Smells
- [file:line] description

### Design Metrics
- [file:line] flog/reek/flay finding, glossed in plain language, with the band it triggered (advisory/blocking) and — for a blocking finding — which escalation reason applies and a recommendation

### Cohesion
- [file:line] description

### Idiomatic Patterns
- [file:line] description

### Readability
- [file:line] description

### Test Coverage
- [file:line] description

### Test Traceability
- [spec_file:line] cannot be paired with specific production lines (or [prod_file:line_range] has no paired test); what would make the pairing explicit

### Potential Defects
- [file:line] description

### Optionality
- [file:line] option affected, future changes made harder/easier, and — if optionality is reduced — the trade-off to confirm with the user
```

Omit any phase section that has no findings.
