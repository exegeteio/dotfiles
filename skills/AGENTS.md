# General Preferencee

* Use as few words as possible while still communicating clearly.  Try to follow ASD-STE100 Simplified
  Technical English, where practical.
    * Use this as often as practical, including recapping actions, creating issues/tickets, writing
        merge requests, and asking for input from the user.
* Communicate exclusively in a neutral technical register.
    * Avoid being obsequious.
        * Wrong: You're absolute right! I think we need to research this topic first...
            * Correct: Researching this topic is necessary. Doing so now.
        * Wrong: "Want any of these applied as edits?"
            * Correct: Awaiting instructions on whether to apply the changes.
        * Wrong: "Good catch — the docs confirm X."
            * Correct: "The docs confirm X."

# Guides

The `guides/` directory contains guides for various tasks files:

* Read `guides/STRATEGY.md` when you design a new module or change the boundary of a module.
* Read `guides/ARCHITECTURE.md` when you need help identifying where in an application a particular
    module should live.
* Read `guides/TACTICS.md` when you write or change code.
* Read `guides/TESTING.md` when you write or change tests.
* Read `guides/RETRO.md` when the user asks for a retrospective or asks you to evaluate the process after an implementation.

## How to apply the guides

1. Identify the kind of task that the user asked for.
2. Read each guide that matches the task.
3. Follow the rules in the guide.
4. If two sources give different rules, follow the user instructions first, then the project files, then the guides. State the conflict in your reply.

Do not copy guide rules into other files. Refer to the guide file instead.

# Values

As a developer I value certain traits of code:

* Code which is human readable, exhibiting locality, cohesion, and following idiomatic patterns.
    * Code comments are a smell, and should only communicate information not available by reading
        the code itself.
    * Idiomatic code patterns are preferred over patterns already found in the current code base.
* Code which is easily testable via a well defined public interface.
    * Testable code also means that each test is written to be easily traceable back to the code it
        is testing.
    * Test suites should run fast; less than 2 minutes for the entire suite.  If a change degrades
        this performance, re-assess the change.
    * Deep modules should be testable without inter-deep-module setup, except where a module is
       declared a dependency.
* Code which promotes system stability.
    * Reviews should always include a report of how the changes may effect stability.

# Tools

* Use `jq` when attempting to parse JSON.
* Use RipGrep (`rg`) instead of `grep`.
* Use `fd` instead of `find`.

# Tidy First

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
* Consider strategic, tactical, testing, or architectural improvements using my guides.
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

