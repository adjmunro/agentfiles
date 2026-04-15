<!-- SUMMARY-START -->
## Run 001 — 2026-03-22 | Target: skills/optimise
Composite: 74.9% → 94.7% (+19.8 pp)

### Hypotheses
| ID  | Description                                    | Outcome   |
|-----|------------------------------------------------|-----------|
| H1  | Strip SKILL.md Duplication                     | Confirmed |
| H2  | Phase-Scoped Persona Loading                   | Confirmed |
| H3  | TTL Policy for research-log.md                 | Confirmed |
| H4  | Symmetrical Experiment Outcome Thresholds      | Confirmed |
| H5  | Binary Applicability Tests for Workflow-Specific Metrics | Confirmed |

### Metric Snapshot
| Metric  | Baseline | Post |
|---------|---------|------|
| M1 IOT  | 100     | 100  |
| M2 DD   | 100     | 100  |
| M3 IAR  | 88      | 93   |
| M4 WCS  | 100     | 100  |
| M5 RI   | 66      | 90   |
| M6 ACC  | 75      | 94   |
| M8 HTC  | 95      | 95   |
| M9 CDR  | 100     | 100  |
| M10 CLE | 48      | 74   |
| M12 IFS | 0       | 100  |
| MX1 SAF | 75      | 100  |
| MX2 MMC | 83      | 91   |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

**Target:** `/Users/adjmunro/Developer/agentfiles/.claude/skills/optimise`
**Files:** 6 total (1 command, 5 support)
**Token estimate:** ~4,800 tokens

### Feature Inventory
- Multi-phase pipeline: yes
- Persona system: yes (Pulse, Keeper, Arden)
- Subagent invocations: no
- Multi-session orchestration: partial (Phase 3 STOP creates session boundary)
- Parallel execution: no
- Cached artifacts: yes (research-log.md written phases 1-3, read phases 4-5)

### Files
- `commands/optimise.md` — command file (~1,600 tokens)
- `SKILL.md` — support: skill definition, full metrics/patterns copy (~900 tokens)
- `research-log.md` — prior run log (~2,000 tokens)
- `AGENTS.md` — support (~250 tokens)
- `CHANGELOG.md` — support (~100 tokens)
- `VERSION.md` — support (~5 tokens)

---

## Phase 2 — Baseline

### MX1 — Self-Application Fidelity (SAF) [custom]
**Measures:** How well the optimise skill follows its own prescribed patterns (P1–P5) in its own implementation.
**Why seeds miss it:** No seed metric checks whether a meta-skill practices what it preaches.
**Methodology:** For each of P1–P5, determine if it's applicable to the optimise skill. For each applicable pattern, check whether the skill's implementation uses it. SAF = patterns_applied / patterns_applicable.
**Direction:** ↑ higher
**Weight:** 2×
**Normalisation:** raw %

### MX2 — Metric Methodology Completeness (MMC) [custom]
**Measures:** % of defined metrics that include all 4 required fields: counting method, normalisation formula, direction, applicability condition.
**Why seeds miss it:** No seed measures internal consistency of the metric library itself.
**Methodology:** For each metric defined in commands/optimise.md (M1–M12 plus any custom metrics), check for presence of: (a) specific counting method, (b) normalisation formula, (c) direction, (d) when-to-apply condition. Complete = all 4. Partial = 3. MMC = complete_metrics / total_metrics.
**Direction:** ↑ higher
**Weight:** 1×
**Normalisation:** raw %

---

Seed metrics skipped: M7 SAS (no subagent invocations), M11 PSS (no parallel execution)

| Metric | Source | Raw | Normalised | Weight | Weighted |
|--------|--------|-----|-----------|--------|---------|
| M1 IOT | seed | 100% | 100 | 2× | 200 |
| M2 DD | seed | 2.9/100t | 100 | 1× | 100 |
| M3 IAR | seed | 11.9% | 88 | 1× | 88 |
| M4 WCS | seed | 100% | 100 | 1× | 100 |
| M5 RI | seed | 33.7% | 66 | 1× | 66 |
| M6 ACC | seed | 75% | 75 | 2× | 150 |
| M8 HTC | seed | 1 pt | 95 | 2× | 190 |
| M9 CDR | seed | 100% | 100 | 2× | 200 |
| M10 CLE | seed | 48% | 48 | 2× | 96 |
| M12 IFS | seed | 0% | 0 | 2× | 0 |
| MX1 SAF | custom | 75% | 75 | 2× | 150 |
| MX2 MMC | custom | 83% | 83 | 1× | 83 |
| **TOTAL** | | | | **19×** | **1423 / 1900** |

**Baseline Composite: 74.9%**

Weakest: M12 IFS (0), M10 CLE (48), M5 RI (66)
Strongest: M1 IOT (100), M9 CDR (100), M8 HTC (95)

---

## Phase 3 — Hypotheses

### H1 — Strip SKILL.md Duplication
**Problem:** SKILL.md duplicates M1-M12 table, composite formula, and P1-P5 patterns from commands/optimise.md (~30% redundancy).
**Change:** Trim SKILL.md to overview + 5-phase diagram + versioning only. Add pointer to command file.
**Targets:** M5 RI 66 → 88+, M10 CLE 48 → 60+
**Status:** pending

### H2 — Phase-Scoped Persona Loading
**Problem:** All 3 personas loaded before Phase 1; none needed until Phase 2+. ~67% of persona tokens irrelevant at any given phase.
**Change:** Move persona loads inside each phase block. Phase 2→Pulse, Phase 3→Keeper, Phase 4→Arden. Phases 1/5 load none.
**Targets:** M10 CLE 48 → 72+, MX1 SAF 75 → 83+
**Status:** pending

### H3 — TTL Policy for research-log.md
**Problem:** research-log.md re-read at each phase but no target-validation or freshness check. Mismatched target logs used silently.
**Change:** Add target-path validation and 3-tier TTL in Phase 1 and Phase 4 intent anchors.
**Targets:** M12 IFS 0 → 90+, MX1 SAF 75 → 83+
**Status:** pending

### H4 — Symmetrical Experiment Outcome Thresholds
**Problem:** "Confirmed" is concrete (≥3 pp); "Disconfirmed" uses vague "no meaningful improvement".
**Change:** Add numeric boundaries for Partial (≥1 pp but <3 pp) and Disconfirmed (<1 pp on all targets AND composite ≤0).
**Targets:** M6 ACC 75 → 88+
**Status:** pending

### H5 — Binary Applicability Tests for Workflow-Specific Metrics
**Problem:** Applicability conditions like "multi-session orchestration: yes/no" require judgment; different agents may decide differently.
**Change:** Add a binary test question for each of M1, M4, M7, M9, M11, M12.
**Targets:** M3 IAR 88 → 93+, M6 ACC 75 → 85+
**Status:** pending

---

## Phase 4 — Experiments

### H1 — Strip SKILL.md Duplication
**Pre-change:** M5 RI 66, M10 CLE 48
**Post-change:** M5 RI 90, M10 CLE 57
**Delta:** M5 +24pp, M10 +9pp
**Result:** confirmed
**Notes:** ~700 tokens of duplicated metric tables, formula, and pattern descriptions removed from SKILL.md. Replaced with a single pointer to commands/optimise.md.

### H2 — Phase-Scoped Persona Loading
**Pre-change:** M10 CLE 57, MX1 SAF 75
**Post-change:** M10 CLE 74, MX1 SAF 100
**Delta:** M10 +17pp, MX1 +25pp
**Result:** confirmed
**Notes:** Top-level preload block removed. Persona loads moved inside Phase 2, 3, 4 headers respectively. P3 Progressive Disclosure now self-applied by the skill.

### H3 — TTL Policy for research-log.md
**Pre-change:** M12 IFS 0
**Post-change:** M12 IFS 100
**Delta:** M12 +100pp
**Result:** confirmed
**Notes:** 3-tier policy (Tier A: mismatched target → archive; Tier B: >7 days → caveat; Tier C: fresh → use as-is) added to Phase 1 intent anchor. Phase 4 re-read updated with a stop-guard for stale/mismatched logs.

### H4 — Symmetrical Experiment Outcome Thresholds
**Pre-change:** M6 ACC 75
**Post-change:** M6 ACC 88
**Delta:** M6 +13pp
**Result:** confirmed
**Notes:** Replaced vague "no meaningful improvement" with concrete floor: <1pp on all targets AND composite ≤0. Partial threshold: ≥1pp but <3pp on ≥1 metric, or net-positive composite below confirmed floor.

### H5 — Binary Applicability Tests
**Pre-change:** M3 IAR 88, M6 ACC 88
**Post-change:** M3 IAR 93, M6 ACC 94
**Delta:** M3 +5pp, M6 +6pp
**Result:** confirmed
**Notes:** One binary yes/no test question added before each of M1, M4, M7, M9, M11, M12. Eliminates interpretive variance in skip/apply decisions.

---

Experiment Summary
- Confirmed: H1, H2, H3, H4, H5
- Partial: none
- Disconfirmed: none

---

## Phase 5 — Report

| Metric | Baseline | Post | Delta | Status |
|--------|----------|------|-------|--------|
| M1 IOT | 100 | 100 | — | — |
| M2 DD | 100 | 100 | — | — |
| M3 IAR | 88 | 93 | +5pp | ↑ |
| M4 WCS | 100 | 100 | — | — |
| M5 RI | 66 | 90 | +24pp | ↑ |
| M6 ACC | 75 | 94 | +19pp | ↑ |
| M8 HTC | 95 | 95 | — | — |
| M9 CDR | 100 | 100 | — | — |
| M10 CLE | 48 | 74 | +26pp | ↑ |
| M12 IFS | 0 | 100 | +100pp | ↑ |
| MX1 SAF | 75 | 100 | +25pp | ↑ |
| MX2 MMC | 83 | 91 | +8pp | ↑ |
| **Composite** | **74.9%** | **94.7%** | **+19.8pp** | |

### What improved and why

- **M12 IFS**: +100pp — 3-tier TTL policy added to intent anchor; first metric to have target-path validation, preventing silent use of wrong-target logs (H3)
- **M10 CLE**: +26pp — SKILL.md deduplication (H1) removed ~700 redundant tokens; persona preload removal (H2) eliminated ~600 tokens loaded before any work. Combined: startup context reduced ~55%
- **MX1 SAF**: +25pp — Both P2 (TTL) and P3 (Progressive Disclosure) now applied by the skill itself; self-application fidelity went from 3/4 to 4/4 applicable patterns
- **M5 RI**: +24pp — Full metric library, composite formula, and design patterns no longer duplicated in SKILL.md; single-source truth in commands/optimise.md (H1)
- **M6 ACC**: +19pp — Combined effect of H4 (concrete Partial/Disconfirmed thresholds) and H5 (binary applicability tests)
- **M3 IAR**: +5pp — Binary applicability tests replaced 6 judgment-call conditions with unambiguous questions (H5)
- **MX2 MMC**: +8pp — Binary tests are themselves complete methodology statements; metric definitions are more fully specified post-H5

### What was dropped and why

Nothing dropped. All 5 hypotheses confirmed.

### What remains to improve

- **M6 ACC**: 94 — the remaining ~6% is one advisory note ("*can be* proposed for inclusion") that is intentionally non-mandatory; further concretisation would over-constrain the pattern discovery process
- **M10 CLE**: 74 — ceiling ~85%; remaining gap is DO/DO NOT rules loaded at startup which correctly apply to all phases; cannot be phase-scoped without restructuring the command entirely
- **MX2 MMC**: 91 — M6 ACC methodology itself has a subjective element ("measurable without interpretation") that could be tightened with concrete examples

---

### Novel Patterns Discovered — 2026-03-22

### NP1 — Symmetric Outcome Thresholds
**Discovered in:** optimise skill (self-run)
**Problem it solved:** Confirmed threshold was concrete (≥3pp) but Disconfirmed used "no meaningful improvement" — creating a gap where agents would classify ambiguous results inconsistently.
**Implementation:** Define numeric thresholds for all three outcomes, not just the positive case. Use the confirmed floor as the anchor and define partial/disconfirmed relative to it.
**Metrics it improved:** M6 ACC (+13pp)
**Generalises to:** Any workflow with multi-tier outcome classification (pass/warn/fail, high/medium/low, etc.)
**Seed candidate:** yes — complements P4 (Recommendation Brief) by ensuring the human approval gate has unambiguous result semantics

### NP2 — Binary Applicability Gates
**Discovered in:** optimise skill (self-run)
**Problem it solved:** Feature-presence conditions for conditional metrics ("applies when: X present") required interpretive judgment; different agents reached different skip/apply decisions for the same workflow.
**Implementation:** For each conditional item, replace the vague feature label with a single yes/no question whose answer is deterministically derivable from an earlier phase's output.
**Metrics it improved:** M3 IAR (+5pp), M6 ACC (+6pp)
**Generalises to:** Any workflow with conditional instructions, optional phases, or branching logic based on detected features
**Seed candidate:** yes — widely applicable; proposed as P6 (Binary Decision Gates)
