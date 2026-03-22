---
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch, Agent
model: claude-opus-4-6
argument-hint: "<path-to-target-workflow-directory> | help"
---

<!-- ORCHESTRATOR: This file contains global rules and the phase manifest only.
     For each phase, read the corresponding file from commands/phases/.
     Never read ahead to a later phase file — each phase's inputs are produced
     by the previous phase, and loading them early defeats progressive disclosure. -->

---

## Entry Point

1. If `$ARGUMENTS` is exactly `help` (case-insensitive) — read `commands/help.md`
   and display the **summary table** (Mode: Summary). Stop.

2. If `$ARGUMENTS` starts with `help ` followed by any text — read `commands/help.md`
   and display the **detail section** (Mode: Detail) that best matches the remainder
   of the argument. Stop.

3. Otherwise — check whether `$ARGUMENTS` begins with a loop specifier:
   - If the first token is a positive integer (e.g. `5`): set **loop mode = count(5)**; strip the token from `$ARGUMENTS` to obtain the target path.
   - If the first token is `auto` (case-insensitive): set **loop mode = auto**; strip the token.
   - Otherwise: **loop mode = count(1)** (single run, default).

   Proceed to the DO rules and phase manifest below.

---

## DO

- Derive the target directory from `$ARGUMENTS`; fail explicitly if not provided or not found
- Apply only the metrics that are applicable to the target workflow; skip others with an explicit reason
- Compute the composite using only applied metrics in both numerator and denominator
- Write all measurement and experiment data to `research-log.md` in the target directory

- Create a git branch before making any changes if the target is inside a git repo
- Commit each confirmed change separately with a conventional commit message
- Re-read `research-log.md` at the start of each phase (Intent Anchor — pattern P1)
- When addressing the user directly — in progress updates, the Recommendation Brief, and the final terminal summary — spell out metric and pattern names in full; never use abbreviations or shorthand identifiers alone (e.g., say "Directive Density" not just "DD", "Intent-to-Output Traceability" not just "IOT", "Intent Anchor Blocks" not just "P1"). Metric IDs such as M1, MX2, and H5 may appear in `research-log.md` entries as internal references, but must not appear in messages shown to the user without their full names alongside them.

## DO NOT

- Modify files outside the target workflow directory (except to update `research-log.md`)
- Apply a hypothesis that was rejected or not listed in the approved brief
- Skip the pre-change and post-change metric recordings for any experiment
- Conflate multiple hypotheses into a single change — one hypothesis, one change, one commit
- Treat a partial improvement as confirmed — record it as "partial" and note the delta
- Run destructive git operations (force push, reset --hard) under any circumstances
- Preload multiple phase files — read each phase file only when entering that phase

---

## Phase Manifest

Execute phases in order by reading the corresponding file. Read each file only on entry to that phase.

1. **Phase 1 — Audit Target**: read `commands/phases/p1-audit.md`
2. **Phase 2 — Baseline Measurement**: read `commands/phases/p2-baseline.md`
3. **Phase 3 — Hypothesis Formation**: read `commands/phases/p3-hypothesize.md`
4. **Phase 4 — Experiment Loop**: read `commands/phases/p4-experiments.md`
5. **Phase 5 — Report**: read `commands/phases/p5-report.md`

---

## Loop Control

After Phase 5 completes, apply the loop control rule:

- **count(n) mode**: decrement the remaining count. If count > 0, begin the next iteration from Phase 1 (re-audit the target in its updated state). If count = 0, stop.
- **auto mode**: compute the composite score using the formula `(confirmed + 0.5 × partial) / total_hypotheses × 100`. If the score is **> 95**, stop — the threshold is satisfied. Otherwise begin the next iteration from Phase 1. If Phase 3 produces zero hypotheses (no improvements found), stop regardless of score and note "No further hypotheses — auto loop complete."
- **count(1) / single run**: stop after Phase 5. No looping.

On each subsequent iteration, re-read `research-log.md` as the Intent Anchor before Phase 1. Hypotheses confirmed in a previous iteration must not be re-applied. Each iteration's experiments are numbered sequentially (H1–HN across all iterations — do not reset to H1).
