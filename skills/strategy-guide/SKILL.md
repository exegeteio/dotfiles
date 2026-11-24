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
* Follow John Ousterhout's deep module design (*A Philosophy of Software Design*): a small public
    interface hiding substantial functionality.
    * Test depth: a caller can use the module correctly without reading its implementation.
    * Avoid shallow modules: pass-through wrappers, and layers whose interface is as complex as
        their implementation.
    * Pull complexity downward: the module absorbs defaults, caching, error handling, and format
        knowledge. Callers do not.
    * Define errors out of existence where the interface allows it.
    * Prefer one cohesive module over several thin ones that share a design decision
        (avoid classitis).
    * Do not split a method or class only to shorten it; split on a separate decision.
