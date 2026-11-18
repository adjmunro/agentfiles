---
name: flaky-test
description: Investigate a flaky test in any language or framework, one that passes and fails on the same code, and fix its cause instead of hiding it. Reproduces the failure, measures the failure rate, isolates the source of nondeterminism, decides whether the bug is in the test or the production code, fixes it, and proves the fix with enough reruns. Use when a test fails intermittently, passes on retry, fails only in CI, only in the full suite, or only on some machines, or when asked to deflake or quarantine a test.
---

# Flaky test

Begin your first message or report after loading this skill with `🎲 flaky-test`, so the user can see it's running.

A flaky test passes and fails on the same code. Something it depends on isn't controlled. Find that thing and control it. A flaky test can also be the only signal of a real race in production code, so never assume the test is at fault.

Retries, longer timeouts, added sleeps, and skips hide the cause. They are not fixes (see the `test-quality` skill's cheating rules). Quarantine needs the user's approval, a ticket, and an owner.

## 1. Reproduce

- Collect the failures first: CI logs, failure messages, stack traces, and which runs failed. With GitHub, `gh run list` and `gh run view --log-failed`. Look for what the failing runs share: machine, shard, time of day, neighbouring tests.
- Run the test alone in a loop, then with its suite, then with the suite in random order and in parallel. Use the runner's own repeat, shuffle, and seed options where it has them.
- If it won't fail locally, match CI: same parallelism, constrained CPU or memory, timezone, locale, and a clean environment.
- Record the command and the failure rate. If it fails k times in n runs, the rate is roughly k/n.

## 2. Isolate the cause

| Symptom | Likely cause | How to confirm |
|---|---|---|
| Fails only with other tests, or in some orders | Shared state: statics, singletons, DB rows, files, env vars, global config | Run it after each preceding test to find the polluter. Bisect the order. |
| Fails under load or in parallel | Timing: unawaited async work, sleeps, debounce, animations, polling | Slow the machine, or add a delay at the suspected point to widen the window |
| Fails at certain times or dates | Real clock: midnight, month end, DST, timezone, elapsed-time asserts | Run with a fixed clock or a shifted system time and timezone |
| Different output per run | Unseeded randomness, unordered collections, parallel iteration | Pin the seed, sort before asserting, log the actual value |
| Fails only in CI | Environment: network, ports, services, file paths, resources, device or emulator state | Diff the environments. Run in the CI image. |
| Intermittent wrong result from production code | A real race or ordering bug | Language race detectors and sanitizers (e.g. TSan, `go test -race`), stress loops, logging around shared state |

Change one variable at a time. A cause is confirmed when controlling it takes the failure rate to zero and releasing it brings the failure back.

## 3. Decide where the bug is

- **In the test:** it depends on something it should control. Fix the test.
- **In the production code:** the test exposed a real race or ordering bug. Fix the code. The test may already be correct.
- **In the infrastructure:** a shared device, service, or environment. Fix the setup, or isolate the test from it, and say which.

## 4. Fix the cause

Control the nondeterminism with the project's own tools: an injected or virtual clock, the framework's synchronisation or idling, seeded randomness, fresh state per test, hermetic fakes instead of real services, and order-independent assertions. Use what the project already has before adding new helpers.

## 5. Prove it

Rerun under the conditions that reproduced the failure. For a failure rate p, about 3/p clean runs give 95% confidence that the fix worked. A 1-in-20 flake needs about 60 clean runs. If you never reproduced the failure, say so: a fix you can't test against a reproduction is a hypothesis.

## Report

```
Test: `path:line` `test name`
Reproduction: <command>, failed k/n
Cause: <what was uncontrolled> | Evidence: <run that confirmed it>
Bug in: test | production code | infrastructure
Fix: <change made, or the instruction for the implementing agent>
Proof: <command>, 0/N failures (N ≥ 3/p)
```
