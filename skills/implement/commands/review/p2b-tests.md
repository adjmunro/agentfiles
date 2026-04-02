# Phase 2b — Test Execution
<!-- Part of: review.md orchestrator -->
<!-- Active when: Examiner evidence table is complete (Step D done) -->

**Vigil (Regression Sentinel) is active alongside Echo for this phase.** After running test suites, apply two lenses in sequence:

**Vigil lens — regression check:** Enumerate what the changed code previously promised. Confirm those promises are still kept. Flag any silent behavioural changes (changed error messages, widened return types, reordered output, shifted defaults) even if no test failed.

**Echo lens — test quality:** For each test suite that ran, spot-check the tests that cover the changed code. Flag:
- Tests with no meaningful assertions (only `assertNotNull`, `assertTrue(true)`, empty test bodies)
- Tests that verify implementation details rather than observable behaviour — these break on refactor without catching real regressions
- Changed behaviour with no new or updated test — the absence of a test is itself a finding: "this change has no coverage; regression is undetectable"

Record both sets of findings. A suite that is green but has hollow tests for the changed area is not a passing result — it is an unknown result.

Infer test framework(s) from project files. Check for each of the following — run ALL that match, not just the first:

| File present | Command to run |
|---|---|
| `Package.swift` | `swift test` |
| `build.gradle` or `build.gradle.kts` | `./gradlew test` |
| `package.json` | `npm test` |
| `Makefile` with a `test` target | `make test` |
| `pytest.ini` or `pyproject.toml` with `[tool.pytest*]` | `pytest` |
| `go.mod` | `go test ./...` |

**Override:** If the ticket frontmatter specifies a `test_command` field, run that instead of (or in addition to) the inferred commands.

Run unit, integration, and UI/instrumentation suites where applicable. Record per-suite results: `suite name → PASS | FAIL (N passed, N failed)`.

If no test framework is detected and no `test_command` is specified, record: "No test framework detected — skipping test execution."

→ Next: Check if any AC involves documentation. If yes, read `review/p2c-documentation.md` and execute it.
   Otherwise, skip directly to `review/p3-score.md`.
