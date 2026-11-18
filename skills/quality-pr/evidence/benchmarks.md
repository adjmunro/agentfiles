# Benchmarks

Only for a metric the change is expected to move by enough to matter:
- **On purpose:** the change exists to improve it (faster builds, smaller binary, fewer exported symbols).
- **As a side effect:** something in the diff predicts it gets worse (much more generated code, a new dependency, a new build step, an extra plugin or annotation processor). Measure it so the cost is visible, not discovered later.

Don't benchmark changes that can't plausibly move a metric. A table of "no change" rows is noise.

## Picking metrics

Measure what the change claims or risks, plus the one most likely to move with it. Typical pairs:
- generated code: build time, binary size, method/symbol count;
- dependency added or removed: binary size, build time, method count;
- build config or caching: clean build, cached or incremental build;
- runtime work moved or removed: cold start time, memory, the hot path's own timing.

Say whether lower or higher is better for each.

## Measuring cheaply

A local machine is shared with the developer, and builds are slow. Gather the evidence with as few runs as possible.

- **Plan first, piggyback on runs you'd do anyway.** Before pre-flight, list the builds the PR needs (pre-flight, the evidence build, the base build) and time each of them (Gradle's `BUILD SUCCESSFUL in …`, `--profile`; Xcode's `-showBuildTimingSummary`, or `time`). A clean release build for the size check also gives you the clean build time. Only add a run when no planned one can answer the question.
- **The smallest set that shows the difference.** Usually one run per side: one cached build, or one clean plus one cached when the change targets clean builds. Sizes and counts are deterministic, so one build of each side is enough. Never repeat runs to average them.
- **Before vs after.** "Before" is the PR's base at the merge-base (`git merge-base HEAD <base>`), built in a throwaway `git worktree`, never by moving the developer's checkout. "After" is HEAD on a clean tree. Use the release/shipping variant for sizes, unless the change only affects debug.
- **Same conditions for both sides.** Same machine, same power state, same cache state (clean: `--no-build-cache --rerun-tasks` or a fresh `-derivedDataPath <scratchpad>/dd-<n>`; cached: the second build of an unchanged tree), same daemon state, same `--max-workers`.
- **One heavy job at a time.** Never run the base and head builds together, or a benchmark build alongside tests, an emulator boot or another build. Competing for CPU and memory, or a hot machine throttling, skews the numbers more than the change does. Run each side back to back, in the background, and keep raw output in the scratchpad.

## Judging the result

A single timing run can be off by roughly ±10%. Treat a timing difference inside that as no change. Size and count differences are exact.

| Marker | Meaning |
|---|---|
| 🟢 | Better, beyond noise |
| ⚪ | Within noise |
| 🟡 | Worse, beyond noise but small |
| 🔴 | Worse, and big enough that a reviewer should weigh it, or any regression the change was meant to avoid |

Set the thresholds to the metric (1% of a 60 MB binary may matter; 10% of a 5-second build may not) and say which you used. If a timing result sits on the edge and decides whether the PR's claim holds, one more run of each side is worth it; otherwise report it as is.

Any 🔴, or 🟡 on a metric the change was meant to improve:
- put a `> [!WARNING]` callout above the table saying what got worse, by how much, and why (or that the cause is unknown);
- name it in the intro's **Review focus**;
- tell the user in the session. Don't bury it.

If the expected improvement didn't show up (⚪ where 🟢 was the point), say that plainly too.

## Reporting

In the body's "Benchmarks" section (`templates/pr-body.md`):
- one line of provenance: machine (model, chip, RAM), OS, tool versions (JDK, Gradle/AGP or Xcode), runs per side, cache state;
- the base and head commits with tree hashes;
- the exact command per metric, in a collapsed `<details>` block;
- the table: real values with units, absolute and relative difference, marker. Relative difference is (after − before) / before.

If a metric couldn't be measured locally (needs CI hardware, a release signing key, a device farm), list it under "Not covered" with how to measure it.
