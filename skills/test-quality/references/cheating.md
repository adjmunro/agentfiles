# Test cheating

Test cheating makes a failing test pass without making the code correct. The question for every changed test: did it change because the required behaviour changed, or because the code failed it? Only the first is legitimate, and it needs a source: the task, a ticket, the spec, a commit message, or the user's instruction.

## Gather the evidence

- Diff the tests against the base: `git diff <base>...HEAD -- <test paths>`. For a single test's history, `git log -p -- <file>`.
- List every existing test the diff edits, moves, skips, or deletes, and check each one. A diff that changes only tests still gets this check.
- Read the production diff alongside, hunk by hunk. A test edit with no matching intended behaviour change is the signal.
- Commit messages such as "fix tests", "update tests", or "make tests pass" are a prompt to look closer, not proof.
- An odd new expected value (an error string, an off-by-one number, an empty list) that looks like whatever the code happens to return is likely copied from the output.

## In tests

- Test deleted, commented out, or renamed so the runner no longer picks it up.
- Skip, ignore, disable, pending, or expected-failure markers added, or the test filtered out in runner config.
- Expected value changed to match new output with no stated requirement change.
- Assertion weakened: equality to contains, not-null, truthy, or an any-matcher; exact to range; a wider tolerance; ordered to unordered; a specific error to any error.
- Assertion removed while the act stays.
- Scenario narrowed: failing inputs dropped from a parameter table, an edge case removed.
- A mock changed to return the expected value, bypassing the logic under test.
- The act or assertion wrapped in try/catch, or an expected-error annotation broadened.
- Retries, longer timeouts, or sleeps added to mask a race instead of fixing it.
- Snapshots or golden files regenerated in the same change as the production code, with no review of the delta.
- Test moved to a suite or target that CI doesn't run.

## In production code

- Branches that detect a test: environment checks, debug flags, magic inputs.
- Hard-coded returns of the value a test expects.
- Errors swallowed or downgraded to a default, so the test passes with wrong behaviour.
- Validation removed or loosened to accept test data.
- Test-only hooks that replace the logic under test rather than inject a dependency.

## In tooling

- CI steps removed, marked allow-failure or continue-on-error, or given retry-on-failure.
- Coverage thresholds lowered, or files excluded from coverage.
- Lint, type, or warning suppressions added at the failure site.
- Hooks bypassed, e.g. `--no-verify`.

## Legitimate changes

- Behaviour changed on purpose and a source says so. The old expectation is now wrong.
- The old test asserted a bug. The change explains why the old expected value was wrong.
- Flakiness fixed by controlling its cause (clock, ordering, shared state), not by retrying.
- A skip with a reason and a linked ticket, for a known breakage outside the change.

If none of these applies and there is no source, treat it as cheating. If a source might exist but you can't find it, report it as a question for the author, not a verdict.

## Report

Each finding gives the hunk, what the test protected before, and what it protects now. The instruction is one of:
1. Revert the test change and fix the production code so the original test passes.
2. Keep the change and record the requirement that justifies it, in the commit message or the test name.

Cheating findings are blocking.
