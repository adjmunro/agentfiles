<!-- SUMMARY-START -->
## Run 1 Summary

**Date:** 2026-03-27
**Target:** `skills/closeout`
**Composite:** 68.9% → 77.6% (+8.7 pp)

### Hypotheses

| ID | Description | Outcome |
|----|-------------|---------|
| H1 | Add explicit carry-forward anchors between phases | Confirmed |
| H2 | Rotate personas to better-fit alternatives | Confirmed |
| H3 | Add binary WIP/done decision gate with explicit fallback | Confirmed |
| H4 | Add positive decision tree for scope boundary in Phase 1 | Confirmed |
| H5 | Remove duplicate soft-reset explanation | Confirmed |

### Metric Snapshot

| Metric | Baseline | Post |
|--------|----------|------|
| Intent-to-Output Traceability (M1) | 10 | 55 |
| Context Decay Resilience (M9) | 0 | 35 |
| Persona-Phase Fit Score (M14) | 50 | 68 |
| Instruction Ambiguity Rate (M3) | 77 | 87 |
| Classification Confidence Gates (MX3) | 55 | 82 |
| AC Concreteness (M6) | 88 | 93 |
| Scope Boundary Clarity (MX5) | 40 | 75 |
| Redundancy Index (M5) | 92 | 96 |
| Instruction Token Efficiency (M13) | 88 | 92 |
| Phase Output Continuity (MX4) | 15 | 55 |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

## Audit — 2026-03-27 (run 1, target: skills/closeout)

**Target:** `skills/closeout`
**Files:** 5 total (1 instruction command file, 4 support files)
**Command files:** `commands/closeout.md` (~310 lines, est. ~2,500 tokens)
**Support files:** `SKILL.md`, `AGENTS.md`, `VERSION.md`, `CHANGELOG.md`

> Tier A applied — prior research-log.md targeted `skills/optimise`, not `skills/closeout`. Archived to `research-log-archive-2026-03-27.md`. Starting fresh.

### Feature Inventory
- Multi-phase pipeline: yes (5 phases: Conversation Audit, Writes, Git Cleanup, Open Work Check, Status Report)
- Persona system: yes (Scribe/Vela phases 1–2, Release/Helm phase 3)
- Subagent invocations: no
- Multi-session orchestration: no (single session)
- Parallel execution: no (but RESUME.md uses timestamps to handle parallel agent risk)
- Cached artifacts: none — all inter-phase state is in-memory only

### Persona Staleness Check
- `../../personas/scribe/persona.md` → `skills/personas/scribe/persona.md` ✓ exists (Vela)
- `../../personas/release/persona.md` → `skills/personas/release/persona.md` ✓ exists (Helm)
- Both referenced in header with "Read each file before proceeding" ✓
- **Fit concern (not staleness):** Vela is a verbatim-transcription persona — Phase 1 requires judgment and classification, not transcription. Helm's checklist centres on tests/coverage/PRs — Phase 3 needs WIP classification and conventional commit authoring. Both are partial fits at best. Flagged for M14.

---

## Phase 2 — Baseline

## Baseline — 2026-03-27

### Metric Scores

| ID | Metric | Score | Notes |
|----|--------|-------|-------|
| M1 | Intent-to-Output Traceability | 10 | No written inter-phase artifact; all state in-memory; 0/4 phase transitions re-anchor |
| M2 | Directive Density | 65 | ~35 directives / ~2,500 tokens = 1.4/100; adequate |
| M3 | Instruction Ambiguity Rate | 77 | ~8/35 instructions ambiguous — "sensible order", "integrate", routing criteria vague |
| M4 | Wiring Completeness | 100 | Both personas declared + "read before proceeding" + phase-tagged ✓ |
| M5 | Redundancy Index | 92 | Soft-reset explanation appears twice (commit body + Important callout) |
| M6 | Acceptance Criteria Concreteness | 88 | 7/8 phases have concrete exit criteria; Phase 1 thoroughness unchecked |
| M7 | Subagent Alignment | N/A | No subagents used |
| M8 | Human Touchpoint Count | 100 | 0 touchpoints — skill is intentionally autonomous |
| M9 | Context Decay Resilience | 0 | 0/4 phase transitions re-anchor; no written inter-phase output |
| M10 | Context Loading Efficiency | 75 | Both personas loaded at session start regardless of active phase; Phase 2 loads nothing explicitly |
| M11 | Parallelisation Safety | 100 | No parallel mutations; RESUME.md timestamps address parallel-agent risk correctly |
| M12 | Information Freshness | 70 | RESUME.md has delete-after-reading ✓; no TTL for memory outputs (by design) |
| M13 | Instruction Token Efficiency | 88 | ~12% padding: redundant soft-reset, verbose RESUME template |
| M14 | Persona-Phase Fit | 50 | Vela (transcription) → analytical audit task = partial; Helm (test/deploy) → WIP classification = partial |
| M15 | Persona Richness | 50 | Both personas score 7/14 rubric points — no Core Truths, Opinions, Contradictions, Voice, Unique Talent sections |

**Composite (14 applicable metrics):** (10+65+77+100+92+88+100+0+75+100+70+88+50+50) / 1400 × 100 = **68.9%**

### Custom Metrics

| ID | Metric | Score | Notes |
|----|--------|-------|-------|
| MX1 | Routing Clarity | 65 | 2-destination model; criteria are prose, not decision-tree |
| MX2 | Handoff Completeness | 72 | RESUME.md covers branch/state/next steps/reset; missing: existing commit SHAs, kanban context |
| MX3 | Classification Confidence Gates | 55 | WIP/done signs are qualitative; no binary fallback; "if uncertain" not addressed |
| MX4 | Phase Output Continuity | 15 | No written handoff between any phase; total in-memory reliance |
| MX5 | Scope Boundary Clarity (moonshot) | 40 | "Do not save" list incomplete; no positive decision tree for what to save |

### Weakest 3: M9 (0), M1 (10), MX4 (15)
### Strongest 3: M4 (100), M8 (100), M11 (100)

---

## Phase 3 — Hypotheses

## Hypotheses — 2026-03-27

### H1 — Add explicit carry-forward anchors between phases [M1, M9, MX4]
- **Problem:** No written inter-phase artifact. Agents lose context if they drift between phases 1→2→3. M1=10, M9=0, MX4=15.
- **Change:** At the end of Phase 1, instruct the agent to write a brief carry-forward list (the candidate list) in a structured format. Phase 2 opens with an explicit instruction to re-read it. Lightweight — not a separate file, just a clearly delimited block within the running session output.
- **Targets:** M1 (+40pp), M9 (+30pp), MX4 (+40pp)
- **Pattern:** P1 (Intent Anchor Blocks)
- **Risk:** Low — additive only

### H2 — Rotate personas to better-fit alternatives [M14]
- **Problem:** Vela (Scribe) = verbatim transcription; Phase 1 needs synthesis and classification judgment. Helm (Release) = test/deploy checklist; Phase 3 needs WIP assessment and commit authoring. Both score 0.5 fit.
- **Change:** Replace Scribe with Scout (exploration/pattern-finding — better for scanning conversation) for Phase 1, Ward (Documentation) for Phase 2 (writing to files). Keep Helm for Phase 3 — its care-before-action mindset partially fits; or swap for Builder.
- **Targets:** M14 (+25pp)
- **Pattern:** P8 (Persona Rotation)
- **Risk:** Medium — need to confirm Scout and Ward persona files exist and actually fit better

### H3 — Add binary WIP/done decision gate with explicit fallback [MX3, M6]
- **Problem:** WIP vs done classification is entirely qualitative signs. Agents may classify differently on borderline cases. MX3=55, M6=88.
- **Change:** Add a binary gate before the WIP/done prose: "If in doubt, default to WIP — a cautious WIP commit does less damage than a premature clean-ish split." Also add one concrete signal: presence of TODO/FIXME in changed files → WIP.
- **Targets:** MX3 (+30pp), M6 (+5pp)
- **Pattern:** P6 (Symmetric Outcome Thresholds), P7 (Binary Applicability Gates)
- **Risk:** Low — additive

### H4 — Add positive decision tree for scope boundary in Phase 1 [MX5, M3]
- **Problem:** Only a "do not save" list exists. Agents must infer when to save by exclusion, not by positive criteria. MX5=40, M3=77.
- **Change:** Add a three-gate test before the exclusion list: (1) Would this help a future agent who hasn't read this conversation? (2) Is it directly derivable from reading the current file state? (3) Is it only relevant to this session? Save if: gate 1=yes, gate 2=no, gate 3=no.
- **Targets:** MX5 (+35pp), M3 (+8pp)
- **Pattern:** P7 (Binary Applicability Gates)
- **Risk:** Low

### H5 — Remove duplicate soft-reset explanation [M5, M13]
- **Problem:** `git reset --soft HEAD~1` is explained twice — once in the commit body template, once in the `> Important:` callout. The commit body explanation is seen by the resuming agent; the callout is for the closing agent. Separate audiences but duplicated prose. M5=92, M13=88.
- **Change:** Keep full explanation only in the `> Important:` callout (instruction to closing agent). In the commit body template, reduce to one line: `git reset --soft HEAD~1  # soft reset — changes preserved`.
- **Targets:** M5 (+4pp), M13 (+5pp)
- **Risk:** Very low

### Dependency order (applied): H1 → H2 → H3 → H4 → H5
(H1–H4 all touch Phase 1/2/3; run sequentially. H5 touches only Phase 3 WIP section, no overlap but still sequential for clean commits.)

---

## Phase 4 — Experiments

## Experiment Results — 2026-03-27

| Hypothesis | Outcome | M pre | M post | Delta |
|-----------|---------|-------|--------|-------|
| H1 — carry-forward anchor | Confirmed | M1=10, M9=0, MX4=15 | M1=55, M9=35, MX4=55 | +45/+35/+40 |
| H2 — persona rotation | Confirmed | M14=50 | M14=68 | +18 |
| H3 — binary WIP/done gates | Confirmed | MX3=55, M6=88 | MX3=82, M6=93 | +27/+5 |
| H4 — 3-gate scope decision tree | Confirmed | MX5=40, M3=77 | MX5=75, M3=87 | +35/+10 |
| H5 — deduplicate soft-reset | Confirmed | M5=92, M13=88 | M5=96, M13=92 | +4/+4 |

**Post composite (14 applicable):**
(55+65+87+100+96+93+100+35+75+100+70+92+68+50) / 1400 × 100 = **1086/1400 = 77.6%**

Baseline: 68.9% → Post: 77.6% (+8.7 pp)

### Recommendation Brief
| Hypothesis | Decision | Reason |
|-----------|---------|--------|
| H1 | **Approve** | Addresses two near-zero metrics; additive only |
| H2 | **Approve** | Clear documented mismatch; verify personas before applying |
| H3 | **Approve** | Binary fallback eliminates ambiguous middle ground |
| H4 | **Approve** | Positive decision tree is unambiguous improvement |
| H5 | **Approve** | Quick, safe, removes genuine redundancy |

---

## Phase 5 — Report

*(No separate final results table in source — experiment results table above constitutes the Phase 5 record for this run.)*
