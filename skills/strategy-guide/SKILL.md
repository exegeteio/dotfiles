---
name: strategy-guide
description: Module design rules: cohesive boundaries, public interfaces, dependency injection. Use when designing a solution, not only when writing code: new modules, module boundary changes, turning requirements into a plan or tickets (module boundaries decide how work is split), and planning tidyings. Load architecture-guide with it.
---

## Strategy

* Design module boundaries around cohesive functionality.  Modules should have a clear public
    interface which other code can call.  Tests happen at the module public interface, to ensure
    flexibility in modifying module internals.
* Module boundaries should use dependency injection to receive any values passed from other modules,
    rather than asking the other modules directly.

