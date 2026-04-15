<!-- SUMMARY-START -->
## Run 009 — 2026-03-25 | Target: skills/ideation/
Composite: 89.1% → 91.5% (+2.4 pp)

### Hypotheses
| ID  | Description                                                                          | Outcome   |
|-----|--------------------------------------------------------------------------------------|-----------|
| H41 | Fix TESTING.md Command Coverage table — 4 stale file references                     | Confirmed |
| H42 | Add Low-confidence explicit naming to research.md Phase 6 report spec               | Confirmed |
| H43 | Add absent-section fallback to interview.md Research Confidence override rule       | Confirmed |
| H44 | Add WHY comments to 3 remaining unannotated blocks (capture, research, p5-commit)   | Confirmed |
| H45 | Correct tickets.md Phase Dispatch Table Phase 4 "Active when" description           | Confirmed |

### Metric Snapshot
| Metric            | Baseline | Post  |
|-------------------|----------|-------|
| MX41 TCFRA        | 69       | 100   |
| MX42 RPRSC        | 83       | 100   |
| MX43 RCOR         | 0        | 100   |
| MX26 WHY-CC       | 91       | 100   |
| MX44 TOPDTA       | 80       | 100   |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

TTL tier: **Tier C** — same-day research log, target matches, age ≤ 7 days. Proceed without staleness warning.

Ran a structural audit of all 12 ideation skill files. Focus: gaps introduced by the 4 new metrics from run 8 (MX37–MX40) and any patterns that escaped prior runs.

Observations:
- `TESTING.md` Command Coverage table: 4 entries still referenced old file locations (`commands/plan.md` step 6 and `commands/tickets.md` step 9) — corrected to `ideate.md` in H21/run 5 but TESTING.md was only partially updated in H23/run 5.
- `commands/research.md` Phase 6 report spec: 5 items listed; Low-confidence flag requirement absent — the `## Research Confidence` section data was being written (H28) and consumed by interview (H36) but the Phase 6 report handoff to interview was not mandating explicit Low-confidence naming.
- `commands/interview.md` Research Confidence override (H36/run 8): no fallback specified for snapshots missing the `## Research Confidence` section entirely — snapshots from before H28/run 6 would trigger undefined behaviour.
- `commands/capture.md` slug uniqueness guard: non-obvious decision block, no WHY annotation.
- `commands/research.md` Phase 4 overwrite-on-loop-back: non-obvious (why overwrite rather than append?), no WHY annotation.
- `commands/tickets/p5-commit.md` commit gate below 95%: non-obvious consequence (partial ticket set appears complete from git history), no WHY annotation.
- `commands/tickets.md` Phase Dispatch Table Phase 4 "Active when": said "all ticket files drafted and committed" — commit is Phase 5's responsibility; this was inaccurate.

---

## Phase 2 — Baseline

Post-run-8 composite: 6,181 / 6,800 = **90.9%**

Run 9 introduces 4 new metrics (MX41–MX44). Baseline numerator after adding new metrics at observed values:

| Metric | ID | Weight | Score | Weighted |
|--------|-----|--------|-------|----------|
| TESTING.md Command Coverage File Reference Accuracy | MX41 | 1× | 69% | 69 |
| Research Phase Report Signal Completeness | MX42 | 1× | 83% | 83 |
| Research Confidence Override Robustness | MX43 | 1× | 0% | 0 |
| Tickets Orchestrator Phase Dispatch Table Accuracy | MX44 | 1× | 80% | 80 |

New metrics sum: 232 weighted. Denominator increases by 400.

**Run 9 pre-experiment baseline**: (6,181 + 232) / (6,800 + 400) = 6,413 / 7,200 = **89.1%**

(Composite dips from 90.9% to 89.1% due to 4 new metrics averaging 58% at baseline — same metric-dilution pattern as all prior runs.)

### New Custom Metric Definitions (run 9)

#### MX41 — TESTING.md Command Coverage File Reference Accuracy (TCFRA) [custom]
**Measures:** What fraction of file references in the TESTING.md Command Coverage table point to the correct current implementing file.
**Why seeds miss it:** MX12 (SMFC) measures state machine fidelity; MX36 (SSRA) measures SKILL.md step table accuracy. Neither measures accuracy of the TESTING.md table, which is the primary test coverage map. Stale references cause testers to execute tests against the wrong entry points.
**Methodology:** Enumerate all file references in the Command Coverage table. Verify each points to the current implementing file. Score = correct_references / total_references.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

#### MX42 — Research Phase Report Signal Completeness (RPRSC) [custom]
**Measures:** Whether research.md's Phase 6 report specification explicitly requires listing Low-confidence sections by name so that interview.md's override rule (H36/run 8) has the information it needs.
**Why seeds miss it:** MX30 (RSCS) measures whether the Research Confidence section is produced. MX38 (RCSCR) measures whether the consumer reads it. Neither measures whether the report handoff explicitly surfaces Low-confidence findings in a named, actionable form. The override rule requires named sections — if the report just says "some sections had Low confidence" without naming them, the override cannot be applied.
**Methodology:** Score = 1 if Phase 6 report spec requires explicit naming of Low-confidence sections; 0 otherwise. Also counts non-Low items: each of 5 report items scored independently, with Low-confidence naming as item 6.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** items_present / total_items × 100

#### MX43 — Research Confidence Override Robustness (RCOR) [custom]
**Measures:** Whether interview.md's Research Confidence override rule (H36/run 8) handles the edge case where the `## Research Confidence` section is absent from the research snapshot (i.e., snapshot was created before H28/run 6).
**Why seeds miss it:** M6 (ACC) measures stop conditions. MX38 (RCSCR) measures whether the consumption rule exists. Neither measures whether the consumption rule is robust to absent inputs. An override rule with no fallback for missing input triggers undefined behaviour on older snapshots.
**Methodology:** Score 1 if the override rule contains an explicit fallback for absent `## Research Confidence` section. Score 0 otherwise.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** binary × 100

#### MX44 — Tickets Orchestrator Phase Dispatch Table Accuracy (TOPDTA) [custom]
**Measures:** What fraction of "Active when" conditions in tickets.md's Phase Dispatch Table accurately describe the prerequisite state for each phase.
**Why seeds miss it:** MX12 (SMFC) measures the entry routing table in SKILL.md. No metric measures the internal phase-dispatch table accuracy within the tickets orchestrator itself. An inaccurate "Active when" condition causes the orchestrator to dispatch phases before their prerequisites are met.
**Methodology:** Enumerate all 5 Phase Dispatch Table entries. For each, verify "Active when" matches the actual phase prerequisite. Score = accurate_entries / 5.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

---

## Phase 3 — Hypotheses

| ID | Metric | Target | Pre | Post | Δ (weighted) |
|----|--------|--------|-----|------|--------------|
| H41 | MX41 TCFRA | TESTING.md Command Coverage table — fix 4 stale file references | 69% | 100% | +31 |
| H42 | MX42 RPRSC | research.md Phase 6 — add Low-confidence explicit naming requirement | 83% | 100% | +17 |
| H43 | MX43 RCOR | interview.md — add absent-section fallback to override rule | 0% | 100% | +100 |
| H44 | MX26 WHY-CC | capture.md, research.md, p5-commit.md — 3 remaining unannotated blocks | 91% | 100% | +9 (×1=+9) |
| H45 | MX44 TOPDTA | tickets.md Phase Dispatch Table Phase 4 "Active when" correction | 80% | 100% | +20 |

**Projected post-experiment**: (6,413 + 177) / 7,200 = 6,590 / 7,200 = **91.5%**

---

## Phase 4 — Experiments

All 5 hypotheses executed and confirmed.

**H41 — TESTING.md Command Coverage File Reference Accuracy (69% → 100%)**
- File: `TESTING.md` Command Coverage table
- 4 entries corrected: `commands/plan.md — validation (step 6, continue/abandon)` split into `commands/ideate.md — step 6 validation (Satisfied / Add more)` and `commands/ideate.md — step 6 validation (Abandon)`; `commands/tickets.md — promotion (step 9, backlog/abandon)` split into `commands/ideate.md — Phase 8 step 9 (Add to backlog)` and `commands/ideate.md — Phase 8 step 9 (Abandon)`.
- MX41: 69% → 100% (+31)

**H42 — Research Phase Report Signal Completeness (83% → 100%)**
- File: `commands/research.md` Phase 6 Report
- Added explicit instruction: "If any section was rated **Low** confidence in the Research Confidence section, list those sections explicitly: 'Low-confidence sections: [names] — treat as reference only; assign UNCERTAIN confidence to any interview recommendation derived primarily from these sections.'"
- MX42: 83% → 100% (+17)

**H43 — Research Confidence Override Robustness (0% → 100%)**
- File: `commands/interview.md` Phase 2, Research Confidence override rule
- Appended to existing override text: "If the `## Research Confidence` section is absent (e.g., a snapshot created before this section was added), proceed with standard HIGH / UNCERTAIN rules only — the override does not apply."
- MX43: 0% → 100% (+100)

**H44 — WHY Comment Coverage Rate (91% → 100%)**
- 3 blocks annotated:
  1. `commands/capture.md` slug uniqueness guard — WHY: guards against silently targeting the wrong subject directory when same date+name slug exists.
  2. `commands/research.md` Phase 4 overwrite-on-loop-back — WHY: stale snapshot from previous loop-back would contain outdated paths, patterns, or dependencies leading to incorrect recommendations.
  3. `commands/tickets/p5-commit.md` commit gate below 95% — WHY: committed-but-incomplete ticket set appears complete from git history, making the gap invisible to future audits.
- MX26: 91% → 100% (+9)

**H45 — Tickets Orchestrator Phase Dispatch Table Accuracy (80% → 100%)**
- File: `commands/tickets.md` Phase Dispatch Table
- Phase 4 "Active when" corrected from "all ticket files drafted and committed" to "all ticket files drafted (commit deferred to Phase 5)".
- MX44: 80% → 100% (+20)

---

## Phase 5 — Report

**Total improvement**: +31 + 17 + 100 + 9 + 20 = +177 weighted points

**Post-experiment composite**: 6,590 / 7,200 = **91.5%**

| Hypothesis | Metric | Pre | Post | Δ |
|------------|--------|-----|------|---|
| H41 | MX41 TCFRA | 69 | 100 | +31 |
| H42 | MX42 RPRSC | 83 | 100 | +17 |
| H43 | MX43 RCOR | 0 | 100 | +100 |
| H44 | MX26 WHY-CC | 91 | 100 | +9 |
| H45 | MX44 TOPDTA | 80 | 100 | +20 |

All 5 hypotheses confirmed.

No novel patterns identified in run 9. All 5 hypotheses were straightforward gap-closes rather than structural discoveries.

### What improved and why

- **Research Confidence override now robust to absent input**: MX43 +100pp (0→100) — the H36/run 8 override rule had no fallback for snapshots created before H28/run 6 added the Research Confidence section; undefined behaviour on older snapshots is now prevented. H43.
- **TESTING.md Command Coverage table fully accurate**: MX41 +31pp (69→100) — 4 entries still referenced pre-H21 file locations; corrected and split to reflect the ideate.md Phase 6/8 locations. H41.
- **Tickets dispatch table Phase 4 condition corrected**: MX44 +20pp (80→100) — "drafted and committed" was premature; Phase 4 activates before Phase 5 commits. H45.
- **research.md report explicitly surfaces Low-confidence sections**: MX42 +17pp (83→100) — the Phase 6 report now mandates naming Low-confidence sections so interview.md's override rule (H36) can be applied without additional inference. H42.
- **WHY comment coverage reaches 100%**: MX26 +9pp (91→100) — the 3 remaining unannotated blocks (capture.md slug guard, research.md overwrite-on-loop-back, p5-commit.md commit gate) are now annotated, closing the WHY comment effort that began in run 4 (H20). H44.

### What remains to improve

- **MX21 OSCC**: 90% — residual init.md reference in ideate.md remains unresolvable without kanban skill access.
- **MX24 CFRA**: 89% — same init.md ambiguity.
- **MX28 TSSF**: 0% — structural constraint; requires actual test execution, non-actionable through instruction changes alone.

Files modified: `TESTING.md`, `commands/research.md`, `commands/interview.md`, `commands/capture.md`, `commands/tickets/p5-commit.md`, `commands/tickets.md`, `CHANGELOG.md`, `VERSION.md`, `SKILL.md`, `research-log.md`.
