## Strategy

* Design module boundaries around cohesive functionality.  Modules should have a clear public
    interface which other code can call.  Tests happen at the module public interface, to ensure
    flexibility in modifying module internals.
* Module boundaries should use dependency injection to receive any values passed from other modules,
    rather than asking the other modules directly.

