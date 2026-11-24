---
name: testing-guide
description: Rules for writing, changing, or reviewing tests and specs. Use before the first edit to any test, spec, or fixture file, and whenever you assert behavior in a test.
---

# Testing

Check new and adjacent tests for:

* Tests should focus on the public API of a module, testing behavior and side effects of code.
* Tests (or groups of tests) which resemble the implementation, are structure-sensitive, or are
    tautological in nature, may be causing deep coupling, and should be considered for
    restructuring.
* Tests should act as documentation, telling the story of the implementation.
* Reject test language or framework features.
