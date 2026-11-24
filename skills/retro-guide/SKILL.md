---
name: retro-guide
description: Retrospective process for evaluating an implementation and improving the system. Use when the user asks for a retrospective or asks you to evaluate the process after an implementation. Offer one when an implementation or epic completes.
---

# Retrospective

After implementation, evaluate the process to provide feedback back into the system.

## Data to evaluate

Find areas where the agent made mistakes, and suggest deterministic improvements to prevent the
agent from making those mistakes in the future.

* Assess the description of the request.
* Assess the implementation against various guides:
    * TESTING.md, STRATEGY.md, TACTICS.md, etc.
    * GLOSSARY.md, if one exists in the repository.
* Read feedback left in tracking systems (Github Issues and Pull Requests, Gitlab Issues and Merge
    Requests, Jira, etc.)
* Assess the settings of the AI used (Model, effort, context window size, etc).

## Steps to perform

* Suggest changes in the process used to describe the request.
* Suggest changes in the shared glossary used to describe the system, if one does not exist, suggest
    creating GLOSSARY.md.
* Suggest changes to skills used during implementation.
* Suggest changes to linting rules or test suite setup / execution.
* Suggest changes to the guides (e.g. TESTING, TACTICS, or STRATEGY, etc).
