---
name: tidy-first
description: Tidying procedure for code changes. Use before any change to existing code, to evaluate whether a structure change would make the next change easier: before the first Edit or Write to a code file, and when planning a behavior change. Load tactics-guide with it.
---

# Tidy First

Load `tactics-guide` with this skill. Load `strategy-guide` when choosing which tidyings to make.

When implementing code in a particular file, create a sub-agent to consider making "tidying"
improvements to the code being modified.

* Before the first Edit/Write to a file, spawn a sub-agent to review the code you will change.  Do
    not edit until it reports.  Quote its findings in your reply under a `Tidy:` heading.
    * This applies to every edit, including one-line deletions and dead-code removal.
    * "Tidy: none found" is valid only after the sub-agent ran.  State which methods it read and
        which tidy types it checked (dead code, guard clauses, explaining variables, grouping).
    * Always look for candidates.  Defaulting to "do not tidy" applies to making the change, never
        to the search.
    * Do not put tidy changes in the behavior commit.  Make each tidy its own commit, made before the
        behavior commit, or ask the user whether to do it.
    * This does not override a project scope rule.  It only makes you look.
* Improvements must be user-approved.
* Tidyings must be provably covered by a test, unless the change is to a test file.
* Consider strategic, tactical, testing, or architectural improvements using the guide skills (strategy-guide, architecture-guide, tactics-guide, testing-guide).
* Tidy only when it makes the very next behavior change cheaper or clearer.
    * Make the change easy, then make the easy change.
* Keep tidyings (small, behavior-preserving structure changes like guard clauses, deleting dead
    code, explaining variables, and grouping related code) strictly separate from behavior changes,
    ideally in their own commits or PRs.
* Make each tidying tiny and easy to review or revert, and run tests before and after.
* Decide per situation whether to tidy first (the usual choice when the mess is directly in your
    path and the payoff is immediate), after, later, or never, defaulting to not tidying unless
    there’s a concrete, near-term benefit.
* Stop as soon as the intended change is easy rather than chasing perfection, favor reducing
    coupling and increasing cohesion/locality.
* In your summary to the user, say what was structure versus behavior and flag any "tidy later"
    candidates instead of doing them unprompted.
* Tag each commit with the `tidy:` label in the commit message (e.g. `APPS-123 tidy: refactor ...`).

