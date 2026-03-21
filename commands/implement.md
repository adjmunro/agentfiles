Implement $ARGUMENTS. Commit often.

## PRD Lifecycle

- Move the PRD to `docs/in-progress/` before starting work — commit the move
- Move the PRD to `docs/review/` when implementation is complete — commit the move
- Never move directly to `docs/done/` — review comes after implementation

## Inline Comments

Use inline comments extensively to preserve the intentions and reasoning from the original spec and PRD. Future parses and edits depend on understanding *why* design and implementation decisions were made — not just what they do.

- Comment non-obvious design choices with the reasoning behind them (e.g. why a particular data structure, algorithm, or API shape was chosen)
- Reference spec/PRD requirements by name or section where a piece of code directly satisfies a requirement
- Note constraints or trade-offs that shaped the implementation (e.g. "must be serialisable for persistence", "plugin SDK boundary — no internal types")
- Prefer comments that explain intent over comments that restate the code

## Commit discipline

- Commit after every meaningful unit of work: a model type, a view, a test, a protocol
- Commit after every PRD update (appending a log section, adding tasks, moving the file)
- Commit after every implementation step before moving to the next
- Every review pass or failure appended to the PRD must be committed before proceeding

## Request Files as Living Logs

**Each request file becomes a complete historical record of the work performed.** As you process a request, you append sections documenting each phase:

1. **Triage** - Complexity assessment and route label
2. **Plan** - Implementation plan (depth scales to complexity)
3. **Plan Verification** - Coverage analysis of plan against requirements
4. **Exploration** - Codebase findings (when plan indicates)
5. **Implementation Summary** - What was changed
6. **Testing** - Test results and coverage

This traceability ensures:
- You can review what was planned vs what was done
- Failed requests show exactly where things went wrong
- Triage accuracy can be evaluated over time
- The full context is preserved for future reference
