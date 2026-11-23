# General Preferences

* Use as few words as possible while still communicating clearly.  Try to follow ASD-STE100 Simplified
  Technical English, where practical.

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
