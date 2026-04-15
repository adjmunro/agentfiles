<!-- SUMMARY-START -->
## Run 004 — 2026-03-25 | Target: skills/ideation/
Composite: 84.0% → 88.0% (+4.0 pp)

### Hypotheses
| ID  | Description                                                  | Outcome   |
|-----|--------------------------------------------------------------|-----------|
| H16 | Restore capture.md Phase 5 gap-scan categories               | Confirmed |
| H17 | Fix SKILL.md version field from 1.2.0 to 1.3.0              | Confirmed |
| H18 | Add 3 missing resume-state scenarios to TESTING.md           | Confirmed |
| H19 | Add explicit "next command" instruction to research.md       | Confirmed |
| H20 | Add WHY/rationale inline comments to 5 key instructions      | Confirmed |

### Metric Snapshot
| Metric                              | Baseline | Post  |
|-------------------------------------|---------|-------|
| Intent-to-Output Traceability       | 98.0    | 100.0 |
| Instruction Ambiguity Rate          | 97.0    | 98.6  |
| Redundancy Index                    | 95.0    | 97.0  |
| Human Touchpoint Count              | 80.0    | 88.0  |
| TESTING.md Scenario Coverage        | 85.0    | 100.0 |
| SKILL.md State Machine Fidelity     | 90.0    | 95.0  |
| Critic Pass Criteria Completeness   | 75.0    | 100.0 |
| Documentation Version Accuracy      | 67.0    | 100.0 |
| TESTING.md Resume Path Coverage     | 40.0    | 100.0 |
| Phase Exit Next-Step Coverage       | 80.0    | 100.0 |
| Commit Body Item Count Adequacy     | 86.0    | 86.0  |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

**Target:** skills/ideation/
**TTL check:** research-log.md exists. Target matches. Date 2026-03-25 ≤ 7 days (today) → Tier C — Use as-is.

**File inventory (post-run-3):**

| File | Type | Lines |
|------|------|-------|
| `SKILL.md` | doc | ~209 |
| `VERSION.md` | doc | ~11 |
| `CHANGELOG.md` | doc | ~63 |
| `TESTING.md` | test | ~58 |
| `commands/ideate.md` | orchestrator | ~180 |
| `commands/capture.md` | command | ~175 |
| `commands/research.md` | command | ~172 |
| `commands/interview.md` | command | ~278 |
| `commands/plan.md` | command | ~221 |
| `commands/tickets.md` | orchestrator | ~52 |
| `commands/tickets/p1-load-plan.md` | phase | ~35 |
| `commands/tickets/p2-scout-research.md` | phase | ~80 |
| `commands/tickets/p3-draft-tickets.md` | phase | ~127 |
| `commands/tickets/p4-critic-audit.md` | phase | ~94 |
| `commands/tickets/p5-commit.md` | phase | ~44 |

15 files. No broken persona references (all persona reads use `../../personas/` relative paths).

**Key findings from file reads:**
1. **`capture.md` Phase 5 — broken instruction**: "Then silently scan the captured material for:" is followed immediately by "If meaningful gaps are found, ask one final targeted question round" — the list of gap categories is completely absent. This is a critical operational defect.
2. **`SKILL.md` version field**: Line 205 reads "**Current version**: 1.2.0 (See `VERSION.md`)" — contradicts `VERSION.md` which shows 1.3.0 and `CHANGELOG.md` which records v1.3.0 as the latest.
3. **`TESTING.md` resume coverage**: 11 scenarios present. Entry Routing table in SKILL.md defines 6 routing conditions (5 non-fresh). Scenarios 9 ("resume after research") and 10 ("resume after interview") cover 2 states. States 1 (tickets→Step 9), 2 (plan→Step 6), and 5 (input only→loop-back) are unscenarioed.
4. **`research.md` Phase 6**: Report instructions describe what to confirm but never name the next command to run.
5. **All commit body specs**: Now present in all 7 commits (H11 confirmed). tickets/p5 promote body specifies only ticket IDs (1 item); all others specify 2–3 items.
6. **`interview.md` Phase 5**: Has 5 explicit, well-defined Critic criteria. In contrast, capture.md Phase 5 has zero criteria.

---

## Phase 2 — Baseline

**Re-scored seed metrics (M1–M14):**

| Metric | Run 3 | Run 4 baseline | Change | Reason |
|--------|-------|----------------|--------|--------|
| IOT | 100 | 98 | -2 | capture.md Phase 5 broken instruction (non-executable) |
| DD | 99.5 | 99.5 | — | No new undefined forks |
| IAR | 98.6 | 97 | -1.6 | capture.md Phase 5 requires interpretation |
| WCS | 100 | 100 | — | |
| RI | 95 | 95 | — | Resume routing logic intact; 3 test scenarios still missing |
| ACC | 97 | 97 | — | |
| SAS | 100 | 100 | — | |
| HTC | 80 | 80 | — | No new WHY comments added since run 3 |
| CDR | 100 | 100 | — | |
| CLE | 96 | 96 | — | |
| IFS | 100 | 100 | — | |
| ITE | 98.9 | 98.9 | — | |
| PPF | 100 | 100 | — | |
| PRS | 100 | 100 | — | |

Seed metric sum: 3,264.4 (was 3,271; -6.6 from IOT and IAR regressions caused by capture.md Phase 5 defect)

**Re-scored custom metrics (MX1–MX15):** All unchanged from run 3.

**New custom metrics (MX16–MX20):**

| # | Name | Abbrev | Definition | Score |
|---|------|--------|-----------|-------|
| MX16 | Critic Pass Criteria Completeness | CPCC | For each quality-gate Critic pass, does the file enumerate the specific criteria being checked? (0% capture.md, 100% interview.md, plan.md, tickets/p4) | **75%** |
| MX17 | Documentation Version Accuracy | DVA | Are all version-bearing doc files consistent with the canonical version in `VERSION.md`? (SKILL.md=1.2.0 vs canonical 1.3.0) | **67%** |
| MX18 | TESTING.md Resume Path Coverage | TRPC | Are all 5 non-fresh resume routing states from the Entry Routing table covered by ≥1 TESTING.md scenario? (states 3 & 4 covered; states 1, 2, 5 missing) | **40%** |
| MX19 | Phase Exit Next-Step Coverage | PENSIC | Does each command's final Report phase explicitly name the next command to run? (research.md missing) | **80%** |
| MX20 | Commit Body Item Count Adequacy | CBICA | Does each commit body spec require ≥2 distinct pieces of information? (tickets/p5 promote specifies only ticket IDs = 1 item) | **86%** |

New metrics sum: 75 + 67 + 40 + 80 + 86 = 348

**Composite score — pre-experiment:**

```
Total weight: 38 (runs 1–3) + 5 (run 4 new) = 43 metrics
Total max: 4,300
Numerator: 3,271 (run 3 final) - 6.6 (IOT/IAR regressions) + 348 (MX16–MX20) = 3,612.4
Composite: 3,612.4 / 4,300 = 84.0%
```

---

## Phase 3 — Hypotheses

Targeting the 5 weakest metrics (TRPC 40%, DVA 67%, CPCC 75%, PENSIC 80%, HTC 80%):

| # | Hypothesis | Target metric | Predicted improvement |
|---|-----------|---------------|----------------------|
| H16 | Restore the list of gap-scan categories in `capture.md` Phase 5 Critic Pass | CPCC 75→100, IOT 98→100, IAR 97→98.6 | +34pp on CPCC (+1 seed metric correction) |
| H17 | Fix `SKILL.md` version field from 1.2.0 to 1.3.0 | DVA 67→100, SMF 90→95 | +38pp composite |
| H18 | Add 3 missing resume-state scenarios to `TESTING.md` | TRPC 40→100, TSC 85→100, RI 95→97 | +77pp composite |
| H19 | Add explicit "next command" instruction to `research.md` Phase 6 Report | PENSIC 80→100 | +20pp composite |
| H20 | Add WHY/rationale inline comments to 5 key non-annotated instructions across command files | HTC 80→88 | +8pp composite |

Predicted post-experiment composite: (3,612.4 + 25 + 33 + 5 + 60 + 15 + 2 + 20 + 8) / 4,300 = 3,780.4 / 4,300 ≈ **87.9%**

---

## Phase 4 — Experiments

| Hypothesis | Files changed | Confirmed? | Notes |
|-----------|---------------|-----------|-------|
| H16: Restore capture.md Phase 5 gap-scan categories | `commands/capture.md` | ✓ | Five gap categories (unstated assumptions, missing constraints, acceptance signals, contradictions, ambiguous terms) restored; WHY comment added |
| H17: Fix SKILL.md version field 1.2.0→1.3.0 | `SKILL.md` | ✓ | One-line fix; all version-bearing files now consistent |
| H18: Add 3 missing resume-state scenarios to TESTING.md | `TESTING.md` | ✓ | Added scenarios for plan→Step 6, tickets→Step 9, and input-only→loop-back; 14 total scenarios, all 5 resume states now explicitly covered |
| H19: Add next-step instruction to research.md Phase 6 | `commands/research.md` | ✓ | "→ Next: Run `ideation/commands/interview.md`" appended to Phase 6 report |
| H20: Add WHY comments to 5 key non-annotated instructions | `capture.md`, `plan.md`, `interview.md`, `tickets/p4-critic-audit.md`, `tickets/p2-scout-research.md` | ✓ | 5 `<!-- WHY ... H{N} (run {N}) ... -->` comments added; each cites the hypothesis and the problem it solved |

---

## Phase 5 — Report

**Post-experiment metric scores:**

| Metric | Pre-exp | Post-exp | Δ | How |
|--------|---------|---------|---|-----|
| IOT | 98 | 100 | +2 | H16 restored broken capture.md instruction |
| IAR | 97 | 98.6 | +1.6 | H16: Critic scan no longer requires interpretation |
| RI | 95 | 97 | +2 | H18: all 5 resume paths now have explicit test scenarios |
| HTC | 80 | 88 | +8 | H20: 5 WHY comments added with H-number citations |
| MX11 TSC | 85 | 100 | +15 | H18: 3 new scenarios, 14/14 expected paths covered |
| MX12 SMF | 90 | 95 | +5 | H17: SKILL.md version field corrected |
| MX16 CPCC | 75 | 100 | +25 | H16: capture.md Phase 5 now has explicit 5-category list |
| MX17 DVA | 67 | 100 | +33 | H17: all version-bearing docs consistent at 1.3.0 |
| MX18 TRPC | 40 | 100 | +60 | H18: 3/3 missing scenarios added |
| MX19 PENSIC | 80 | 100 | +20 | H19: research.md Phase 6 now names next command |
| MX20 CBICA | 86 | 86 | 0 | tickets/p5 promote body still specifies only 1 item |

All others: unchanged.

**Composite score:**

```
Pre-experiment:  3,612.4 / 4,300 = 84.0%
Improvements:    +28.6 (H16) + 38.0 (H17) + 77.0 (H18) + 20.0 (H19) + 8.0 (H20) = +171.6
Post-experiment: 3,784.0 / 4,300 = 88.0%
```

**Run improvement: 84.0% → 88.0% (+4.0pp within run 4)**
**Net vs. run 3: 86.1% → 88.0% (+1.9pp after metric dilution from 5 new metrics averaging 69.6%)**

All 5 hypotheses confirmed.

Nothing dropped. All target metrics improved or held.

### What remains to improve

- **HTC** 88% — 5 WHY comments added this run; a further audit could add comments to the remaining H1–H3 additions (resume routing, active intent anchors, inline ticket schema)
- **SDDS** 88% — Scout Dependency Detection Strength; H12 improved it significantly; the remaining 12% likely reflects edge cases in circular or implicit infrastructure dependencies
- **CMBC** 86% — capture.md commit body is minimal (1 line); tickets/p5 promote body specifies only ticket IDs. Both are arguably sufficient for their context
- **CBICA** 86% — same gap as CMBC for promote; borderline at the ≥2-item threshold
- **CLE** 96% — near ceiling; minor exit path cases remain implicit

### Novel Pattern Candidates

### NP7 (run 4) — State-Machine-to-Test Bijection
**Discovered in:** H18 — ideation skill
**Problem it solved:** Resume routing states were defined in the Entry Routing table (SKILL.md) but there was no systematic check ensuring each state had a corresponding test scenario. Three of five states had no test coverage.
**Implementation:** Use the skill's own state machine (Entry Routing table or equivalent) as an authoritative index. For each state, verify that at least one TESTING.md scenario starts from that exact artifact configuration. Add scenarios for any states without explicit coverage.
**Metrics it improved:** TESTING.md Resume Path Coverage (+60pp), TESTING.md Scenario Coverage (+15pp)
**Generalises to:** Any skill with a state machine, resume routing table, or branching flow. The state machine is the test coverage specification — if a state has no test, the test suite is incomplete by definition.
**Seed candidate:** yes — applies to all skills with documented state machines.

### NP8 (run 4) — WHY Comment Traceability Anchors
**Discovered in:** H20 — ideation skill
**Problem it solved:** Non-obvious guards, idempotency checks, and detection rules accumulated across runs without inline rationale. Maintaining agents could not determine whether a guard was intentional defensive coding or a forgotten stub. HTC (Hypothesis Traceability Coverage) remained at 80% despite CHANGELOG documenting every change.
**Implementation:** For each instruction added by a non-obvious hypothesis (guards, detection rules, recovery flows), add a `<!-- WHY: [problem it solved]. H{N} (run {N}). -->` comment immediately before the instruction. The comment cites the hypothesis number so the CHANGELOG provides full context. Both directions are navigable: CHANGELOG→file (hypothesis number) and file→CHANGELOG (inline WHY).
**Metrics it improved:** HTC (+8pp)
**Generalises to:** Any workflow where instructions accumulate over multiple optimise runs. The WHY comment pattern converts the CHANGELOG from a summary document into a queryable annotation system.
**Seed candidate:** yes — applies to all optimise-maintained workflow directories.
