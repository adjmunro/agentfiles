---
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch, Agent
model: claude-opus-4-6
argument-hint: "<path-to-target-workflow-directory>"
---

<!-- ORCHESTRATOR: This file contains global rules and the phase manifest only.
     For each phase, read the corresponding file from commands/phases/.
     Never read ahead to a later phase file — each phase's inputs are produced
     by the previous phase, and loading them early defeats progressive disclosure. -->

---

## DO

- Derive the target directory from `$ARGUMENTS`; fail explicitly if not provided or not found
- Apply only the metrics that are applicable to the target workflow; skip others with an explicit reason
- Compute the composite using only applied metrics in both numerator and denominator
- Write all measurement and experiment data to `research-log.md` in the target directory

- Create a git branch before making any changes if the target is inside a git repo
- Commit each confirmed change separately with a conventional commit message
- Present the Recommendation Brief and wait for human approval before beginning experiments
- Re-read `research-log.md` at the start of each phase (Intent Anchor — pattern P1)
- When addressing the user directly — in progress updates, the Recommendation Brief, and the final terminal summary — spell out metric and pattern names in full; never use abbreviations or shorthand identifiers alone (e.g., say "Directive Density" not just "DD", "Intent-to-Output Traceability" not just "IOT", "Intent Anchor Blocks" not just "P1"). Metric IDs such as M1, MX2, and H5 may appear in `research-log.md` entries as internal references, but must not appear in messages shown to the user without their full names alongside them.

## DO NOT

- Begin Phase 4 without explicit human approval of the hypothesis brief from Phase 3
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
