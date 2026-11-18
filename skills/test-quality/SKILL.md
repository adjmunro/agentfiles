---
name: test-quality
description: Judge automated tests in any language or framework and give an implementing agent concrete instructions. Sorts each test into keep, improve (with the changes that make it good), or remove, flags test cheating (tests weakened, skipped, or rewritten to pass instead of fixing the code), and lists missing tests when changed behaviour has none. Use on top of every adversarial review or code review, and whenever reviewing, auditing, or writing tests, or asked whether tests are any good, flaky, or worth keeping.
argument-hint: <diff range or files> [task, ticket, or intent of the change]
context: fork
model: claude-opus-5-5
effort: high
background: false
---

# Test quality

Begin your first message or report after loading this skill with `🧪 test-quality`, so the user can see it's running.

Scope from the caller: $ARGUMENTS

You run in a fresh subagent without the caller's conversation. If the scope above is empty, review the current branch's diff against its base branch plus uncommitted changes, and say so in the report.

A test earns its place by failing when the behaviour it covers breaks, and only then. Judge every test against that, in the idioms of its own language, framework, and repository.

The output is instructions for another agent. Each finding names the test, the problem, the evidence, the exact change, and how to tell it's done.

## 1. Scope

| Invoked | Tests in scope |
|---|---|
| As part of a review | Test code added or changed in the diff (tests, helpers, fixtures, fakes, and runner config), plus existing tests of the changed production code and of its direct callers whose behaviour changes |
| Directly | What the user names, otherwise the tests for the code they're working on |

A changed helper or fixture brings into scope the tests that use it. Read enough of them to judge the effect, and give verdicts only for those it changes.

Find tests by searching test sources for the changed symbols, files, and modules. Before judging, note the project's conventions: runner, layout, naming, shared fakes, builders, fixtures, and assertion style. Every recommendation reuses them. A new helper is only justified when nothing existing fits. Where a convention itself makes tests brittle (asserting full UI copy, say), follow it and mention the cost once in the report, not per test.

If changed behaviour has no tests, still do step 4.

## 2. Cheating check

Whenever there is a diff, do this first. Read `references/cheating.md`. Any change to an existing test (edited, moved, skipped, or deleted) gets extra scrutiny, whether or not production code changed with it. New tests can only add protection; changed ones can quietly remove it. Each changed test is a suspect until its change traces to an intended behaviour change in the task, ticket, commit message, or spec. New tests go straight to step 3. Cheating findings block the review whatever else is true.

## 3. Verdict per test

Read `references/criteria.md`. For each test, helper, or fixture in scope, answer:

1. **What bug does it catch?** Name a plausible defect in the code under test that makes this test fail. If you can't, it protects nothing.
2. **What harmless change breaks it?** A refactor, reorder, rename, or timing shift that fails the test without changing behaviour makes it brittle.
3. **Does its failure explain itself?** The name and failure message say which behaviour broke, without reading the body.
4. **Is it reliable and cheap?** Deterministic, isolated, and fast for its level.

Then give one verdict.

| Verdict | When |
|---|---|
| Keep | Catches a named bug, survives harmless change, and diagnoses itself. |
| Improve | Covers behaviour worth protecting but fails a question in a fixable way. |
| Remove | Q1 has no answer, bloated, a stronger test already covers it, or it costs more than it protects and can't be fixed cheaply. Say what replaces it, if anything. |

Prefer Improve to Remove when the behaviour matters. Remove is a recommendation for low quality, value, and/or signal tests. The implementing agent confirms with the user before deleting anything.

## 4. Missing tests

Each path the change adds or alters that no test covers is an Add finding: the main path, each error and boundary branch, and any new state. Its Change steps give the level (unit, integration, or UI), the existing helpers to build it with, the inputs, and the assertion that proves it. If the code can't be tested without a seam, the first step adds the smallest one. Generated code, pure renames, and logic-free config need no tests. List them under "No tests needed" with the reason, rather than inventing some.

## 5. Prove what you can

Where the review may run code:
- Run the tests in scope. Run anything timing-dependent at least twice. A test that passes and fails on the same code, or that history shows being retried or rerun, is flaky. Make it an Improve finding whose change is to run the `flaky-test` skill on it.
- Mutation check: break the production line a test claims to cover (flip a condition, drop a call, change a constant), run the test, and restore the line. A test that still passes protects nothing. Only mutate files with no uncommitted changes, or work in a separate worktree. Confirm `git status` and `git diff` are identical before and after.

Tag every verdict Proven (command and result) or Reasoned.

## 6. Report

Write one report per diff. If the caller hands over several commits or branches, give each its own section.

Each section starts with two lines that are always present, so the implementing agent can tell checked-and-clean from skipped:
- `Cheating check:` the findings, or "none found" and what was checked.
- `No tests needed:` the changed files that need no tests and why, or "none".

Then a table in the order cheating, add, remove, improve, keep, one row per test: verdict, location, and a one-line reason tagged Proven or Reasoned. A Keep reason names the bug the test catches. Keep rows need nothing more; they tell the implementing agent what to leave alone.

Locations are repo-relative `path:line`, pointing at the test's declaration, plus the test name. An Add row points at where the new test goes.

Every row other than Keep gets a block:

```
### <Verdict>: `path/to/test_file:42` `test name`
Problem: <what's wrong, one or two sentences>
Evidence: <Proven: command and result | Reasoned: the bug it misses, or the diff hunk>
Change:
1. <imperative step in the project's idiom, naming the existing helpers to use>
Done when: <the check that proves it, e.g. "fails when `applyDiscount` drops the 50% cap", or the end state when no behaviour is involved>
```

When part of a review, add this as a "Test quality" section after the review's own findings. If the review reports through a structured findings tool, put these findings in that same call (categories `test-cheating`, `missing-test`, `test-quality`) instead of printing them separately.
