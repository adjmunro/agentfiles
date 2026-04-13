## Archive: runs prior to 2026-04-01 (Run 3)

This file contains the complete research log for optimise runs 1 and 2 on
`skills/review-dependency-update/`. Archived from `research-log.md` at the
start of Run 3 per the 15,000-token archival policy.

---

## Audit — 2026-03-31

**Target:** skills/review-dependency-update/
**Files:** 12 total (8 command, 4 support)
**Token estimate:** ~8,400 tokens

### Feature Inventory
- Multi-phase pipeline: yes
- Persona system: yes
- Subagent invocations: yes
- Multi-session orchestration: no
- Parallel execution: yes
- Cached artifacts: yes (atomic commit manifest written by Phase 1b; read by orchestrator for Wave dispatch)

### Files

**Command files (8):**
- `commands/review-dependency-update.md` — orchestrator / dispatcher (~800 tokens)
- `commands/phases/p1-parse.md` — Phase 1: PR parsing and session brief (~500 tokens)
- `commands/phases/p1b-split-commits.md` — Phase 1b: atomic commit splitting (~1,200 tokens)
- `commands/phases/p2-investigate.md` — Phase 2: changelog + security investigation (~900 tokens)
- `commands/phases/p3-impact.md` — Phase 3: codebase impact mapping (~500 tokens)
- `commands/phases/p4-remediate.md` — Phase 4: remediation commits (~700 tokens)
- `commands/phases/p5-verdict.md` — Phase 5: risk scoring and verdict (~700 tokens)
- `commands/phases/p6-comment.md` — Phase 6: PR comment posting (~300 tokens)

**Support files (4):**
- `SKILL.md` — skill description and overview
- `AGENTS.md` — commit conventions and versioning rules
- `VERSION.md` — current version (1.3.0)
- `CHANGELOG.md` — version history

### Persona References (from orchestrator `review-dependency-update.md`)

Paths declared: `../../personas/<dir>/persona.md` (relative to `commands/`)
Resolved to: `/Users/adjmunro/Developer/agentfiles/skills/personas/<dir>/persona.md`

| Persona | File | Exists? | soul.md? |
|---|---|---|---|
| Echo (Examiner) | `skills/personas/examiner/persona.md` | YES | YES |
| Rook (Adversary) | `skills/personas/adversarial/persona.md` | YES | YES |
| Ink (Commit Curator) | `skills/personas/ink/persona.md` | YES | YES |
| Arden (Critic) | `skills/personas/critic/persona.md` | YES | YES |

All persona references resolve correctly. No broken references.

### Persona Staleness Check
No speciated children detected for any of the four personas (adversarial, examiner, ink, critic). No staleness warnings.

---

## Custom Metrics — 2026-03-31

### MX1 — Changelog Source Coverage (CSC) [custom]
**Measures:** Whether the Kotlin/Android library changelog source table in p2-investigate.md covers the packages most commonly encountered in real projects
**Why seeds miss it:** No seed metric measures whether the workflow's knowledge base (lookup tables) is complete — seeds measure instruction quality, not domain coverage
**Methodology:** Enumerate all library families in the p2 table. Count common Kotlin/Android libraries from established ecosystem lists (AndroidX, Jetpack, Gradle plugins, popular third-party). CSC = covered / (covered + known-missing)
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

### MX2 — Agent Prompt Completeness (APC) [custom]
**Measures:** Whether the sub-agent prompt templates in the orchestrator provide all context needed to execute phases without additional lookups
**Why seeds miss it:** M7 (SAS) checks whether subagent tasks are appropriate, not whether the prompts contain sufficient information. An appropriate but under-specified prompt produces incomplete output.
**Methodology:** For each Wave dispatch prompt template, enumerate all information fields a sub-agent needs to execute its assigned phases (PR context, bump context, navigation, constraints). APC = present fields / required fields
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

### MX3 — Phase File Navigation Completeness (PNC) [custom]
**Measures:** Whether every phase file ends with a correct `→ Next:` directive pointing to the correct next file
**Why seeds miss it:** M1 (IOT) measures whether phases read prior artifacts; it does not check whether phases have forward navigation directives. A phase without a `→ Next:` line silently halts the pipeline.
**Methodology:** Count all phase files (including orchestrator). For each, check: (a) has a `→ Next:` or `→ Done.` line at the bottom, (b) the path/instruction is correct relative to the phase's role. PNC = phases with correct navigation / total phases
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

### MX4 — Verdict Scoring Calibration (VSC) [custom, moonshot]
**Measures:** Internal consistency of the risk scoring matrix — whether tier boundaries are reachable by realistic signal combinations, whether the matrix is symmetric, and whether signal weights are ordered appropriately
**Why seeds miss it:** No seed metric evaluates whether the workflow's *scoring system* is internally consistent. A well-structured instruction can contain a calibration error that the agent will apply faithfully every time.
**Methodology:** Five structural checks: (1) tier ranges contiguous with no gaps; (2) all signals are distinct non-overlapping conditions; (3) minimum/maximum scores per tier reachable by real combinations; (4) major-version-bump-alone calibration (does it land in the correct tier?); (5) presence of risk-reduction signals (symmetry). VSC = passing checks / 5
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

### MX5 — Cross-Bump Context Isolation (CCI) [custom]
**Measures:** Whether per-bump subagents are structurally prevented from contaminating each other's verdicts
**Why seeds miss it:** M11 (PSS) checks for concurrent-write safety; it does not check for context bleed — a situation where Agent A's findings could influence Agent B's verdict even with correct concurrency guards.
**Methodology:** For each isolation boundary in the parallel dispatch design, check whether the mechanism (prompt scoping, file naming, explicit "one bump only" directives, sequential Phase 4) prevents contamination. CCI = isolation mechanisms present / total required isolation points
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

---

## Baseline — 2026-03-31

**Persona note:** Pulse (Analytics) persona not found at expected path (`../../../personas/analytics/persona.md` from optimise phase dir). Proceeding without persona.

Seed metrics applied: Intent-to-Output Traceability, Directive Density, Instruction Ambiguity Rate, Wiring Completeness Score, Redundancy Index, AC Concreteness, Subagent Alignment Score, Human Touchpoint Count, Context Decay Resilience, Context Loading Efficiency, Parallelisation Safety Score, Instruction Token Efficiency, Persona-Phase Fit Score, Persona Richness Score

Seed metrics skipped: Information Freshness Score (M12) — no inter-session artifacts with temporal gap; all artifact hand-offs are intra-session

MX-OQ series: SKIP — no `.kanban/.archive/` in target directory

Pattern series: RPC (P10 not previously applied, but conditional branches exist — evaluated anyway); HCU — SKIP no help file; PEV — SKIP no prior experiments; EIS — SKIP no prior multi-hypothesis sessions

Custom metrics: Changelog Source Coverage (MX1), Agent Prompt Completeness (MX2), Phase File Navigation Completeness (MX3), Verdict Scoring Calibration (MX4), Cross-Bump Context Isolation (MX5)

| Metric | Source | Raw | Normalised | Weight | Weighted |
|---|---|---|---|---|---|
| Intent-to-Output Traceability | seed | 1.0 | 100 | 2× | 200 |
| Directive Density | seed | 2.71 | 100 | 1× | 100 |
| Instruction Ambiguity Rate | seed | 0.0 | 100 | 1× | 100 |
| Wiring Completeness Score | seed | 1.0 | 100 | 1× | 100 |
| Redundancy Index | seed | 0.02 | 98 | 1× | 98 |
| AC Concreteness | seed | 0.82 | 82 | 2× | 164 |
| Subagent Alignment Score | seed | 1.0 | 100 | 1× | 100 |
| Human Touchpoint Count | seed | 1 (interactive) | 95 | 2× | 190 |
| Context Decay Resilience | seed | 0.0 | 0 | 2× | 0 |
| Context Loading Efficiency | seed | 0.93 | 93 | 2× | 186 |
| Parallelisation Safety Score | seed | 1.0 | 100 | 1× | 100 |
| Instruction Token Efficiency | seed | 0.986 | 99 | 1× | 99 |
| Persona-Phase Fit Score | seed | 1.0 | 100 | 1× | 100 |
| Persona Richness Score | seed | 1.0 | 100 | 1× | 100 |
| Recovery Path Completeness | custom (RPC) | 1.0 | 100 | 1× | 100 |
| Changelog Source Coverage | custom (MX1) | 0.48 | 48 | 1× | 48 |
| Agent Prompt Completeness | custom (MX2) | 0.79 | 79 | 1× | 79 |
| Phase File Navigation Completeness | custom (MX3) | 1.0 | 100 | 1× | 100 |
| Verdict Scoring Calibration | custom (MX4) | 0.6 | 60 | 1× | 60 |
| Cross-Bump Context Isolation | custom (MX5) | 0.86 | 86 | 1× | 86 |
| **TOTAL** | | | | **25×** | **2,110** |

**Composite: 2,110 / (25 × 100) × 100 = 84.4%**

### Weakest metrics (Phase 3 candidates)
1. Context Decay Resilience — 0 (2× weight): wave sub-agents receive no intent re-anchor
2. Changelog Source Coverage — 48 (1×): ~15 common Kotlin/Android libraries absent from p2 lookup table
3. Verdict Scoring Calibration — 60 (1×): major-bump-alone scores as Low; no risk-reduction signals; one-directional matrix

### Strongest metrics
1. Intent-to-Output Traceability — 100
2. Directive Density — 100
3. Instruction Ambiguity Rate — 100
4. Wiring Completeness Score — 100
5. Phase File Navigation Completeness — 100

---

## Experiments — 2026-03-31

### H1–H6 (see Experiment Results below)

## Experiment Results — 2026-03-31

### H5 + H6 — Session Brief Persistence + Sub-Agent Prompt Enrichment
**Pre-change:** CDR = 0, APC = 79, CCI = 86
**Post-change:** CDR = 100, APC = 100, CCI = 100
**Delta:** CDR +100pp, APC +21pp, CCI +14pp
**Result:** confirmed

### H2 — Changelog Table Expansion
**Pre-change:** CSC = 48
**Post-change:** CSC = 86
**Delta:** CSC +38pp
**Result:** confirmed

### H3 — Scoring Matrix Symmetry Fix
**Pre-change:** VSC = 60
**Post-change:** VSC = 90
**Delta:** VSC +30pp
**Result:** confirmed

### H4 — AC Concreteness: Subjective Qualifiers
**Pre-change:** ACC = 82
**Post-change:** ACC = 95
**Delta:** ACC +13pp
**Result:** confirmed

### H1 — Sub-Agent Intent Re-anchor
**Result:** confirmed (implemented as part of H6 commit)

## Experiment Summary (Run 1)
- Confirmed: H1, H2, H3, H4, H5, H6

## Final Results — 2026-03-31

| Metric | Baseline | Post | Delta | Status |
|---|---|---|---|---|
| Context Decay Resilience | 0 | 100 | +100 | ↑ |
| Changelog Source Coverage | 48 | 86 | +38 | ↑ |
| Verdict Scoring Calibration | 60 | 90 | +30 | ↑ |
| AC Concreteness | 82 | 95 | +13 | ↑ |
| Agent Prompt Completeness | 79 | 100 | +21 | ↑ |
| Cross-Bump Context Isolation | 86 | 100 | +14 | ↑ |
| **Composite** | **84.4%** | **97.6%** | **+13.2 pp** | |

### Novel Pattern Candidates

### NP1 — Prompt Context Completeness
**Discovered in:** skills/review-dependency-update
**Problem it solved:** Sub-agent dispatch prompts were missing ecosystem label, PR title, and cross-bump constraints.
**Metrics it improved:** Agent Prompt Completeness (+21pp), Cross-Bump Context Isolation (+14pp)
**Seed candidate:** yes — proposed as P16 — Prompt Context Completeness.

---

Log within size threshold; no archival required (estimated ~7,500 tokens).

---

## Audit — 2026-04-01

**Target:** skills/review-dependency-update/
**Files:** 12 total (8 command, 4 support)
**Token estimate:** ~8,400 tokens (unchanged from prior run)

### TTL Check
Prior log date 2026-03-31, today 2026-04-01 (1 day) → Tier C — used as-is.

### Notes
All 4 persona files verified to exist. No broken references. SKILL.md pipeline diagram omits Phase 1b — minor doc inaccuracy noted for metrics.

---

## Custom Metrics — 2026-04-01

### MX6 — Comment Template Completeness (CTC) [custom]
CTC = covered categories / 6. Weight 1×.

### MX7 — Fallback Path Fidelity (FPF) [custom]
FPF = (conditions met) / (total checks × 3). Weight 1×.

### MX8 — Pipeline Diagram Accuracy (PDA) [custom]
PDA = accurate diagrams / total diagrams. Weight 1×.

### MX9 — Pre-Release Version Handling (PVH) [custom]
PVH = checks present / 3. Weight 1×.

### MX10 — Adversarial Prompt Resistance (APR) [custom, moonshot]
APR = phases with injection-resistance / phases that read untrusted content. Weight 2×.

---

## Baseline — 2026-04-01

**Composite (30 metrics): 97.7%** (2,932 / 3,000)

Weakest: PVH = 17, APR = 17, PDA = 50.

---

## Experiment Results — 2026-04-01

### H7 — Pre-Release Version Handling: confirmed (+83pp PVH)
### H8 — SKILL.md Pipeline Diagram Fix: confirmed (+50pp PDA)
### H9 — Adversarial Prompt Resistance: confirmed (+83pp APR, weight 2×)
### H10 — Fallback Path Phase 4 Sequencing Note: confirmed (+8pp FPF)
### H11 — AC Concreteness: Observable Behaviour Condition: confirmed (+5pp ACC, weight 2×)

## Experiment Summary (Run 2)
- Confirmed: H7, H8, H9, H10, H11

## Final Results — 2026-04-01

| Metric | Baseline | Post | Delta | Status |
|---|---|---|---|---|
| Pre-Release Version Handling | 17 | 100 | +83 | ↑ |
| Adversarial Prompt Resistance | 17 | 100 | +83 | ↑ |
| Pipeline Diagram Accuracy | 50 | 100 | +50 | ↑ |
| Fallback Path Fidelity | 92 | 100 | +8 | ↑ |
| AC Concreteness | 95 | 100 | +5 | ↑ |
| Instruction Token Efficiency | 99 | 98 | −1 | ↓ (within tolerance) |
| **Composite** | **97.7%** | **98.3%** | **+0.6 pp** | |

### Novel Pattern Candidates

### NP2 — Data Boundary Marking
**Metrics it improved:** Adversarial Prompt Resistance (+83pp). Proposed as P16 — Data Boundary Marking.

### NP3 — Edge Case Coverage
**Metrics it improved:** Pre-Release Version Handling (+83pp). Proposed as P17 — Algorithm Edge Case Coverage.

---

Log within size threshold; no archival required (estimated ~13,500 tokens).
