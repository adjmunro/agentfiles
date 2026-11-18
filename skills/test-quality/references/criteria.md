# Test criteria

Language-neutral. Translate each point into the framework's own tools: its clock and scheduler controls, parameterised tests, matchers, fakes, and fixtures.

## A good test

| Trait | Check |
|---|---|
| Tests behaviour | Goes through the interface callers use. Doesn't reach into private state, use reflection, or assert call order that callers don't rely on. |
| One behaviour | One reason to fail. Several assertions are fine if they describe the same outcome. |
| No logic | No loops, conditionals, or try/catch in the body that could skip an assertion. Use parameterised tests for input tables. |
| Independent oracle | Expected values are literals or come from a source other than the code under test. Recomputing them with the production algorithm is a tautology. |
| Specific assertions | Exact values. "Not null", "truthy", "contains", and "doesn't throw" only when that is the whole contract. Error cases assert the error type and the detail that matters. |
| Covers the edges | Boundaries, empty, absent, invalid, error, and concurrent cases where the code handles them. |
| Deterministic | Controls time, randomness, ordering, locale, timezone, network, and filesystem. Waits on the framework's synchronisation, never on sleeps. |
| Isolated | No shared mutable state. Passes alone, in any order, and in parallel. |
| Doubles at boundaries | Fakes or stubs for what the unit doesn't own (network, storage, clock). Real objects for value types and owned collaborators. Verify an interaction only when the call is the behaviour, such as sending a message or publishing an event. |
| Right level | The cheapest level that can catch the bug. Logic in unit tests, wiring in integration tests, UI tests only for what needs a UI. |
| Says what broke | The name states behaviour and condition ("returns zero for an empty cart"). Assertions use rich matchers so the failure shows expected and actual. |
| Relevant data | Builders or defaults hide the fields that don't matter, so the values that do stand out. Unexplained magic numbers get names. |

## Smells

| Smell | Usual verdict | Fix |
|---|---|---|
| No assertion, or only "doesn't throw" when more is observable | Improve, or Remove if nothing is observable | Assert the outcome |
| Tautology: asserts a mock returns what it was told, or recomputes the expected value with the code under test | Remove | Replace with a test of real logic, if any exists |
| Tests the language, framework, or compiler: getters, setters, generated equality, wiring the type system already checks | Remove | |
| Over-mocking: every collaborator mocked, call sequences verified | Improve | Assert outcomes, use fakes, keep only interactions that are the behaviour |
| Coupled to implementation: private access, internal state, exact call counts | Improve | Test through the public interface |
| Assertion roulette or eager test: unrelated assertions, several behaviours | Improve | Split into one test per behaviour |
| Conditional logic in the test | Improve | Split, or parameterise |
| Swallowed exceptions in the test | Improve | Assert the failure explicitly |
| Sleeps, real clocks, wall-time timeouts | Improve | Inject or control the clock and scheduler. A bounded wait is fine (Keep) when it waits out an intended real-time window the test can't control, such as one inside a dependency the project doesn't change, and is calculated from the production constant. |
| Order dependence, shared state, leaked global config | Improve | Fresh state per test, reset in teardown |
| Mystery guest: depends on data or files the reader can't see | Improve | Inline it, or build it in the test |
| Hard-coded environment: paths, timezone, locale, network | Improve | Inject or pin it |
| Snapshot or golden file of a whole object when one field matters | Improve | Assert the relevant fields. Whole-screen UI snapshots are fine when reviewed. |
| Duplicates a stronger test | Remove the weaker one, or merge into a parameterised test | |
| Coverage padding: runs code without checking results | Improve if the behaviour matters, otherwise Remove | |
| Commented out, or skipped with no reason or ticket | Remove, or fix and re-enable | |
| Asserts current buggy behaviour, with a comment admitting it | Improve | Assert the correct behaviour and fix the code, or track it as a known failure with a ticket |
