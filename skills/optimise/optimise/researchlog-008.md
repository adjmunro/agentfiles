<!-- SUMMARY-START -->
## Run 8 Summary

**Date:** 2026-03-27
**Target:** `skills/optimise`
**Composite:** 87.1% → 98.1% (+11.0 pp)

### Hypotheses

| ID | Description | Outcome |
|----|-------------|---------|
| H1 | Embed metric weights in p2-baseline.md | Confirmed |
| H2 | Define orphaned output metrics (HCU, RPC, PEV, EIS) in p2-baseline.md | Confirmed |
| H3 | Add Pulse to Phase 1 [persona experiment] | Confirmed |
| H4 | Add MX-OQ metrics to help.md | Confirmed |
| H5 | Add archive filename collision rule to p5-report.md | Confirmed |

### Metric Snapshot

| Metric | Baseline | Post |
|--------|----------|------|
| Persona-Phase Fit Score (M14) | 80 | 100 |
| Help/Reference Synchronisation Rate (MX1) | 86 | 100 |
| Escape Hatch Completeness (MX2) | 90 | 95 |
| Metric Weight Discoverability (MX3) | 0 | 100 |
| Orphaned Output Metric Coverage (MX4) | 0 | 100 |
| Self-Application Coherence (MX5) | 92 | 92 |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

## Audit — 2026-03-27 (run 1, target: skills/optimise)

**Target:** `skills/optimise`
**Files:** 15 total (7 command, 5 support, 3 logs/archives)
**Token estimate:** ~23,000 tokens (command files ~21,300; support files ~1,700)

> Tier A applied — prior research-log.md targeted `skills/closeout`, not `skills/optimise`. Those runs were archived to `skills/closeout/optimise/research-log-archive-2026-03-27.md`. Starting fresh.

### Feature Inventory
- Multi-phase pipeline: yes (5 phases: Audit, Baseline, Hypothesize, Experiments, Report)
- Persona system: yes (Pulse/Analytics P2, Keeper/Strategist P3, Arden/Critic P4, Ink/Commit Curator P4)
- Subagent invocations: no (Agent tool listed in allowed-tools but no explicit spawn directives in phase logic)
- Multi-session orchestration: no (all 5 phases run in one continuous session; no STOP/PAUSE for a new agent session)
- Parallel execution: no
- Cached artifacts: yes (research-log.md written in P1–P4 and read throughout; persona staleness check in P1 covers persona files)

### Files
**Command files (7):**
- `commands/optimise.md` — orchestrator/entry point (~775 tokens)
- `commands/help.md` — documentation reference (~11,979 tokens) [documentation file — excluded from M2/M13]
- `commands/phases/p1-audit.md` — Phase 1 (~600 tokens)
- `commands/phases/p2-baseline.md` — Phase 2 (~3,500 tokens)
- `commands/phases/p3-hypothesize.md` — Phase 3 (~2,175 tokens)
- `commands/phases/p4-experiments.md` — Phase 4 (~1,275 tokens)
- `commands/phases/p5-report.md` — Phase 5 (~810 tokens)

**Support files (5):**
- `AGENTS.md` (~525 tokens), `SKILL.md` (~275 tokens), `VERSION.md` (~5 tokens), `CHANGELOG.md` (~medium), `TESTING.md` (~medium)

**Logs/archives (3):**
- `research-log.md` (active), `research-log-archive-2026-03-22.md`, `research-log-archive-2026-03-27.md` (prior self-run)

### Persona Staleness Check
- `../../../personas/analytics/persona.md` → `skills/personas/analytics/persona.md` ✓ (Pulse) — soul.md ✓; no speciation noted
- `../../../personas/strategist/persona.md` → `skills/personas/strategist/persona.md` ✓ (Keeper) — soul.md ✓; no speciation
- `../../../personas/critic/persona.md` → `skills/personas/critic/persona.md` ✓ (Arden) — soul.md ✓; no speciation
- `../../../personas/ink/persona.md` → `skills/personas/ink/persona.md` ✓ (Ink) — soul.md ✓; no speciation
- All 4 persona references valid. No broken references.

---

## Phase 2 — Baseline

## Baseline — 2026-03-27 (Pulse active)

*Pulse (Analytics) is active for this phase.*

**Instruction file corpus (M2/M13 scope):** optimise.md, p1-audit.md, p2-baseline.md, p3-hypothesize.md, p4-experiments.md, p5-report.md
**Excluded (documentation):** help.md, AGENTS.md, SKILL.md, VERSION.md, CHANGELOG.md, TESTING.md

**Token estimates — instruction files only:**
- optimise.md: ~775t; p1-audit.md: ~600t; p2-baseline.md: ~3,500t; p3-hypothesize.md: ~2,175t; p4-experiments.md: ~1,275t; p5-report.md: ~810t
- **Total instruction tokens: ~9,135t**

### M1 — Intent-to-Output Traceability (2×)
**Apply if:** Multi-phase pipeline? YES.
**Methodology:** Count phases that explicitly re-read a prior phase's artifact before doing work.
- P1: No prior artifact — first phase (N/A to count)
- P2: "Re-read research-log.md (Intent Anchor)." ✓
- P3: "Re-read research-log.md (Intent Anchor). Focus on the baseline section." ✓
- P4: "Re-read research-log.md (Intent Anchor — Tier C only…)" ✓
- P5: "Re-read research-log.md (Intent Anchor)." ✓

IOT = 4/4 = 100%. **Score: 100**

---

### M2 — Directive Density (1×)
**Instruction files only.**
**Directive count (estimated):**
- optimise.md: ~26 directives (DO list ×7, DO NOT ×6, entry-point logic ×5, phase manifest ×5, loop control ×3)
- p1-audit.md: ~19 directives (inventory steps, TTL tiers, persona staleness checks, audit write instruction)
- p2-baseline.md: ~50 directives (apply-if checks ×15, custom discovery heuristics ×8, MX-OQ methodology steps, composite write ×2, navigation ×1)
- p3-hypothesize.md: ~24 directives (hypothesis formation, self-audit steps ×3 with sub-bullets, novel-hypothesis probes ×6, brief format, navigation)
- p4-experiments.md: ~45 directives (steps 0–e with sub-rules, persona experiment protocol ×10, failure modes/recovery ×6, summary write)
- p5-report.md: ~17 directives (report tables ×3, novel-pattern block, archival steps ×3, terminal summary)
**Total directives: ~181**

DD = 181 / (9135/100) = 181 / 91.35 ≈ 1.98
Normalised: (1.98 / 2.0) × 100 = **99** (cap 100). **Score: 99**

---

### M3 — Instruction Ambiguity Rate (1×)
**Unscoped weak modals identified:**
1. p4-experiments.md: "commit with a note or revert at your discretion" — no criteria for which to choose
2. p4-experiments.md: "Scope the task to complete in a single response (e.g., audit 2–3 items)" — "representative" is semi-vague; examples help
3. p1-audit.md: "rough token estimate" — appropriate for estimation context; arguably not an instruction ambiguity
4. p4-experiments.md: "If possible, also score the same task under the old persona" — scoped by following sentence ("if prior run output exists"); counts as scoped

Genuine unscoped: ~2 clear, ~3 borderline. Counting conservatively at 5 ambiguous out of ~181 total.
IAR = 5/181 = 2.8%
Normalised: 100 − 2.8 = **97.2** → **Score: 97**

---

### M4 — Wiring Completeness (1×)
**Apply if:** Persona system? YES.
- Pulse → p2-baseline.md: explicit load directive ✓
- Keeper → p3-hypothesize.md: explicit load directive ✓
- Arden → p4-experiments.md: explicit load directive ✓
- Ink → p4-experiments.md: explicit load directive for Step e ✓

WCS = 4/4 = 100%. **Score: 100**

---

### M5 — Redundancy Index (1×)
**Cross-instruction-file redundancy scan:**
- "Re-read research-log.md (Intent Anchor)" appears in P2, P3, P4, P5 — intentional P1 pattern; not counted as maintenance-hazard redundancy
- "When Phase N is complete, read…" navigation line at end of P1, P2, P3, P4 — different content each time; not redundant
- optimise.md DO item "Create a git branch before making any changes" and p4-experiments.md "check out a new branch" overlap slightly (~2 instructions) — minor
- Ink loading mentioned in p4 header and again in Step e instructions — justified (progressive reminder for the step); borderline

Genuine maintenance-hazard redundancy: ~3 instruction pairs (optimise.md/p4 git branch, Ink double-mention, P4 TTL check duplicates P1 TTL rules in condensed form) = ~3 of ~181 instructions.
RI = 3/181 = 1.7%
Normalised: 100 − 1.7 = **98.3** → **Score: 98**

---

### M6 — AC Concreteness (2×)
**Acceptance criteria / stop conditions found:**
- P3 self-audit: "If this projection clears > 95, the list is sufficient" ✓ numeric
- P3: "Add one now" for any metric still below 80 with no hypothesis ✓ numeric threshold
- P4 confirmed: "normalised score improved by ≥3 points… no other metric degraded by more than 2 points" ✓
- P4 partial: "≥1 point but <3 points" ✓
- P4 disconfirmed: "<1 point delta on all target metrics AND composite delta ≤0" ✓
- P5 archival: "If the log exceeds 15,000 tokens" ✓ numeric
- Loop auto mode: "If the score is > 95, stop" ✓ numeric
- Loop auto mode: "two consecutive iterations produce only Partial results" ✓
- Loop auto mode: "Phase 3 produces zero hypotheses, stop" ✓ numeric (zero)
- Persona experiment: "requires both structural improvement (M14 PPF or M15 PRS ≥+3pp) and a non-negative spot-check score" ✓

All found criteria are numeric or binary. No vague "looks good" criteria identified.
ACC = 10/10 = 100%. **Score: 100**

---

### M7 — Subagent Alignment Score (1×)
**Apply if:** Explicit Agent tool call or spawn directive? NO.
Agent listed in allowed-tools, but phase logic contains no "spawn subagent" directive.
**SKIP — no subagent invocations.**

---

### M8 — Human Touchpoint Count (2×)
**Touchpoints (post-invocation):** Phase 3 produces a Recommendation Brief but proceeds automatically to Phase 4 — no STOP. Phase 4 proceeds to Phase 5 automatically. Zero explicit human touchpoints per run.
HTC = 0.
Normalised: max(0, 100 − (0/20)×100) = **100**. **Score: 100**

---

### M9 — Context Decay Resilience (2×)
**Apply if:** Any phase block includes a STOP, PAUSE, or session-boundary instruction? NO. The TTL check in P1 is about artifact freshness, not a session boundary. The conditional "stop and alert" in P4 is an error escape, not a routine boundary.
**SKIP — no session boundaries.**

---

### M10 — Context Loading Efficiency (2×)
**Apply:** YES (universal).
**Per-phase analysis:**
- P1: Loads research-log.md (if present) — fully relevant. No persona. ~90% efficient.
- P2: Loads Pulse persona.md + research-log.md — both fully relevant to P2 work. ~92% efficient.
- P3: Loads Keeper persona.md + research-log.md — both relevant. The baseline section of the log is directly needed; the audit section is useful context. ~90% efficient.
- P4: Loads Arden persona.md + Ink persona.md + research-log.md — all relevant. Full log re-read includes prior phases' content, slightly more than strictly needed (approved hypotheses section is the primary need), but the secondary-delta check requires full prior scores context. ~85% efficient.
- P5: Loads research-log.md in full — all sections relevant for the final report. ~92% efficient.

Average CLE = (90+92+90+85+92) / 5 = 449/5 = **89.8** → **Score: 90**

---

### M11 — Parallelisation Safety Score (1×)
**Apply if:** Parallel execution? NO.
**SKIP — no parallel execution.**

---

### M12 — Information Freshness Score (2×)
**Apply if:** Cached artifacts? YES.
**Artifacts with TTL policies:**
1. research-log.md: 3-tier TTL (Tier A regenerate/Tier B caveat/Tier C use-as-is) ✓ — explicitly checked in P1
2. Persona files: P1 checks for broken references and speciation notes — a freshness/staleness check ✓
3. research-log-archive-*.md: treated as canonical (Tier C — canonical, never expires); no TTL needed ✓

IFS = 3/3 = 100%. **Score: 100**

---

### M13 — Instruction Token Efficiency (1×)
**Instruction files only.**
**Padding scan:**

Throat-clearing preamble: none identified in phase files. optimise.md has one HTML comment block (`<!-- ORCHESTRATOR: This file contains global rules... -->`) explaining the file structure — ~60 words. Borderline: it orients the orchestrator but is semi-narrative.

HTML rationale comments in p2-baseline.md (MX-OQ section): 5 comment blocks, each ~40–60 words. These explain *why* the metrics exist — narrative restatement in an instruction file: ~200 words = ~300 tokens.

Other narrative restatement: minimal. Phase files use direct imperatives throughout.

Padding estimate: ~360 tokens / 9,135 = 3.9%.
ITE = 1 − 0.039 = 0.961.
Normalised: **96**. **Score: 96**

---

### M14 — Persona-Phase Fit Score (1×)
**Apply if:** Persona system? YES.
**Phase-by-phase assessment:**
- P1 (Audit — no persona): Cognitive demand = analytical inventory (file classification, feature detection, persona staleness assessment). Pulse (Analytics) exists and would full-fit this phase. High-value phase with no persona and a clear match available = **mismatch (0.0)**.
- P2 (Baseline — Pulse/Analytics): Cognitive demand = systematic measurement, quantitative scoring, pattern detection. Pulse's DO rules ("Surface actionable improvement recommendations", "Measure against prior cycles") directly match. = **full fit (1.0)**.
- P3 (Hypothesize — Keeper/Strategist): Cognitive demand = prioritisation, synthesis, forward-projection. Keeper's purpose is "Reframe problems before implementation begins." = **full fit (1.0)**.
- P4 (Experiments — Arden/Critic): Cognitive demand = gap-finding, verification, coverage audits. Arden's purpose is "gap-finding — surfaces what's missing, incomplete, or unverifiable." = **full fit (1.0)**. Ink for Step e: commit curation = full fit (1.0).
- P5 (Report — no persona): Cognitive demand = reporting/documentation, neutrality, comprehensiveness. Reporting phase with no persona = **full fit (1.0)**.

PPF = (0.0 + 1.0 + 1.0 + 1.0 + 1.0) / 5 = 4.0/5 = 80%.

Richness check (M14 rule: persona scoring <71% is decorative): All 4 personas score 14/14 = 100% — no decorative penalty.
**Score: 80**

---

### M15 — Persona Richness Score (1×)
**Apply if:** Persona system? YES.
**Rubric scores (14 points each):**
- Pulse (Analytics): 14/14 — all fields present including Unique Talent and Failure Mode ✓
- Keeper (Strategist): 14/14 ✓
- Arden (Critic): 14/14 ✓
- Ink (Commit Curator): 14/14 ✓

PRS = 4/4 × 100 = **100**. **Score: 100**

---

### Custom Metrics — 2026-03-27

*Pulse's custom metric discovery: What could go wrong in this specific workflow that no seed metric would catch?*

---

#### MX-OQ1–5 — Pre-Defined Outcome Metrics
**Apply if:** `.kanban/.archive/` contains relevant quality data.
**SKIP** — `skills/optimise/` is not a kanban workflow and produces no `.kanban/` subjects. No archived quality envelopes exist.

---

#### MX1 — Help/Reference Synchronisation Rate [custom, weight 2×]
**Measures:** Fraction of named entries in instruction files (seed metrics M1–M15, pre-defined MX-OQ1–5, design patterns P1–P15) that have corresponding detail entries in help.md.
**Why seeds miss it:** P12 is a pattern not a metric; no seed checks whether the documentation trust chain is intact.
**Methodology:** Count named entries in p2-baseline.md (M1–M15 = 15; MX-OQ1–5 = 5) and p3-hypothesize.md (P1–P15 = 15) = 35 total. Count entries present in help.md with a detail section. Rate = documented/35.
**Direction:** ↑ higher is better.
**Weight:** 2×.

**Score:**
- M1–M15 in help.md: 15/15 ✓ (each has a named detail section)
- P1–P15 in help.md: 15/15 ✓ (P8 present at line 460; all 15 patterns documented)
- MX-OQ1–5 in help.md: 0/5 ✗ (no entries for Interview Acceptance Rate, First-Pass Review Rate, Plan Stability Rate, Session Satisfaction Rate, PR Critique Rate)

Rate = 30/35 = 85.7%. **Score: 86**

---

#### MX2 — Escape Hatch Completeness [custom, weight 1×]
**Measures:** Fraction of conditional branches in all phase files (TTL tiers, skip conditions, loop termination cases, error states) that have an explicit recovery or continuation path stated.
**Why seeds miss it:** M6 measures acceptance criteria concreteness; P10 defines failure mode registry as a pattern but isn't scored.
**Methodology:** Enumerate conditional branches; for each, check whether a specific prescribed next action exists.

**Conditional branches:**
1. P1 Tier A → "archive, start fresh" ✓
2. P1 Tier B → "load with caveat" ✓
3. P1 Tier C → "read and proceed" ✓
4. P1 contamination check → "warn, continue" ✓
5. P1 missing target → "stop and print usage, exit" ✓
6. P1 broken persona reference → "flag, don't block" ✓
7. P1 speciated parent → "note it, don't block" ✓
8. P3 zero hypotheses → "write message, read p5" ✓
9. P4 not in git repo → "proceed without branching, note in log" ✓
10. P4 target mismatch re-read → "stop and alert user" ✓
11. P4 partial result → "commit or revert at your discretion" ✗ — no criteria for which to choose
12. P4 disconfirmed → "revert the change" ✓
13. P4 persona unavailable → "create manually" ✓
14. P4 malformed persona file → "use as-is, score partial, note gap" ✓
15. P4 ambiguous spot-check marker → "score as partial (0.5)" ✓
16. Loop count mode → "decrement, continue/stop" ✓
17. Loop auto mode >95% → "stop" ✓
18. Loop auto mode zero hypotheses → "stop" ✓
19. Loop auto mode two consecutive partial-only → "stop and report" ✓
20. P5 archive filename collision (e.g. same date used) → no explicit guidance ✗

Rate = 18/20 = 90%. **Score: 90**

---

#### MX3 — Metric Weight Discoverability [custom, weight 1×]
**Measures:** Fraction of applicable seed metrics (M1–M15) whose weight value is explicitly declared in p2-baseline.md, the instruction file that executes the measurement phase.
**Why seeds miss it:** M10 measures relevance of loaded tokens, not whether critical execution parameters are co-located with the instructions that use them. An agent running only Phase 2 without prior context has no explicit weight values available.
**Methodology:** Scan p2-baseline.md for explicit "**Weight:** N×" annotations per M1–M15 metric section. Count metrics with declared weights / total applicable metrics.

**Result:** MX-OQ1–5 DO have "**Weight:** N×" annotations in p2-baseline.md. M1–M15 do NOT — weights for seed metrics are only in help.md (documentation file, not loaded in Phase 2).
Rate = 0/12 applicable seed metrics with weights in p2-baseline.md = 0%.
**Score: 0**

Note: In practice, the Intent Anchor (research-log from prior runs) often includes the weighted composite table, allowing weights to be inferred. But on a first run of any new target, there is no prior log — the agent must guess or assume 1× for all seed metrics.

---

#### MX4 — Orphaned Output Metric Coverage [custom, weight 1×]
**Measures:** Fraction of output/quality metrics named as pattern targets in p3-hypothesize.md that have complete scorable definitions in p2-baseline.md.
**Why seeds miss it:** Seeds measure instruction quality but not whether the scoring system is self-consistent. A pattern that claims to target "Help Content Currency (↑)" is unverifiable if HCU has no definition.
**Methodology:** Enumerate metrics named as targets in P1–P15 that are NOT in M1–M15 (i.e., custom output metrics implied by patterns). Check p2-baseline.md for scorable definitions.

**Orphaned metrics found:**
- PEV (Pattern Experimental Validation Rate) — target of P13
- HCU (Help Content Currency) — target of P12
- RPC (Recovery Path Completeness) — target of P10
- EIS (Experiment Isolation Score) — target of P14

None of the 4 have definitions in p2-baseline.md.
Rate = 0/4 = 0%. **Score: 0**

---

#### MX5 — Self-Application Coherence [custom, moonshot, weight 1×]
**Measures:** When the optimise workflow is applied to itself, the fraction of workflow assumptions that remain logically consistent (no circular contradictions, unreachable termination conditions, or unmeasurable metrics created by the workflow's own improvement loop).
**Why moonshot:** Applies the workflow's own quality criteria to itself as a meta-validation — borrowing inter-rater reliability methodology from psychometrics. An optimise skill that successfully improves itself but in doing so makes future measurement inconsistent is a structural liability.
**Methodology:** Check 6 coherence properties:
1. Can all applicable metrics (M1–M15) be measured on optimise itself without category errors? ✓ (12 apply, 3 skip with correct reasons)
2. Are all loop termination conditions reachable? ✓ (>95% achievable, zero hypotheses reachable, stalled-partials reachable)
3. If a confirmed experiment changes a scoring methodology, does it affect the scores used in the same run's composite? Partial — changes to p2-baseline.md metric definitions could shift mid-run scores; the pre/post Step a/c protocol handles this. ✓
4. Does the git branch naming work for self-application? ✓ (`optimize/optimise-<date>` — no naming conflict)
5. Does confirming M14 (adding Pulse to P1) affect the measurement of M14 in the same run? Yes — pre/post measurement in Step a/c handles this correctly. ✓
6. Does the P5 archival procedure handle archive filename collisions (same date, multiple runs)? ✗ — no explicit rule for collision (e.g., b-suffix convention not documented)

Coherence = 5.5/6 (property 3 is partial) = 91.7%. **Score: 92**

---

### Composite Calculation — 2026-03-27

| Metric | Source | Normalised | Weight | Weighted |
|--------|--------|-----------|--------|----------|
| Intent-to-Output Traceability (M1) | seed | 100 | 2× | 200 |
| Directive Density (M2) | seed | 99 | 1× | 99 |
| Instruction Ambiguity Rate (M3) | seed | 97 | 1× | 97 |
| Wiring Completeness Score (M4) | seed | 100 | 1× | 100 |
| Redundancy Index (M5) | seed | 98 | 1× | 98 |
| AC Concreteness (M6) | seed | 100 | 2× | 200 |
| Human Touchpoint Count (M8) | seed | 100 | 2× | 200 |
| Context Loading Efficiency (M10) | seed | 90 | 2× | 180 |
| Information Freshness Score (M12) | seed | 100 | 2× | 200 |
| Instruction Token Efficiency (M13) | seed | 96 | 1× | 96 |
| Persona-Phase Fit Score (M14) | seed | 80 | 1× | 80 |
| Persona Richness Score (M15) | seed | 100 | 1× | 100 |
| Help/Reference Synchronisation Rate (MX1) | custom | 86 | 2× | 172 |
| Escape Hatch Completeness (MX2) | custom | 90 | 1× | 90 |
| Metric Weight Discoverability (MX3) | custom | 0 | 1× | 0 |
| Orphaned Output Metric Coverage (MX4) | custom | 0 | 1× | 0 |
| Self-Application Coherence (MX5) | custom | 92 | 1× | 92 |
| **TOTAL** | | | **23×** | **2004 / 2300** |

**Skipped:** M7 (no subagents), M9 (no session boundaries), M11 (no parallel execution), MX-OQ1–5 (no kanban archive data)

**Composite: 2004 / 2300 × 100 = 87.1%**

**Weakest 5:** MX3 (0), MX4 (0), M14 (80), MX1 (86), M10 (90)
**Strongest:** M1 (100), M4 (100), M6 (100), M8 (100), M12 (100), M15 (100)

---

## Phase 3 — Hypotheses

## Hypotheses — 2026-03-27 (Keeper active)

*Keeper (Strategist) is active for this phase.*

Re-read research-log.md ✓ (Intent Anchor — same target, same session)

### H1 — Embed metric weights in p2-baseline.md [persona experiment: N/A — standard]
**Problem observed:** Metric Weight Discoverability (MX3) = 0. Weights for M1–M15 are only in help.md (a documentation file not loaded during Phase 2). A first-run agent executing Phase 2 has no explicit weight values in its instruction context. The composite calculation table in p2-baseline.md includes a Weight column with no source.
**Change proposed:** Add a "Seed Metric Weights" reference table in p2-baseline.md immediately above the Composite Calculation section, listing all 15 seed metrics with their weights (2× or 1×).
**Targets:** Metric Weight Discoverability (MX3): 0 → 100 (+100pp); Instruction Ambiguity Rate (M3): minor +2pp (removes one source of agent judgment in composite construction)
**Predicted improvement:** MX3 +100pp
**Pattern applied:** Progressive Disclosure (P3) — information should be in the file that uses it
**Risk level:** low
**Risk note:** Weight values are stable; additive only; no instruction logic modified

---

### H2 — Define orphaned output metrics in p2-baseline.md [standard]
**Problem observed:** Orphaned Output Metric Coverage (MX4) = 0. Four metrics named as pattern targets (PEV, HCU, RPC, EIS) have no scorable definitions anywhere. Patterns P10, P12, P13, P14 claim to improve unmeasurable outcomes — the feedback loop from pattern application to measured improvement is broken.
**Change proposed:** Add a "Pre-Defined Custom Metrics" section in p2-baseline.md (after the MX-OQ series) defining PEV (Pattern Experimental Validation Rate), HCU (Help Content Currency), RPC (Recovery Path Completeness), and EIS (Experiment Isolation Score). Each definition should follow the MX template: applicability condition, skip condition, methodology, direction, weight, normalisation.
**Targets:** Orphaned Output Metric Coverage (MX4): 0 → 100 (+100pp)
**Predicted improvement:** MX4 +100pp
**Pattern applied:** Novel — Orphaned Target Completion (patterns should target measurable metrics; unmeasurable targets break the causal attribution chain)
**Risk level:** medium
**Risk note:** Adds ~300 tokens to p2-baseline.md. Definitions must be precise enough to score consistently. Start with HCU (most concrete) as a template; risk is lowest for additive-only instruction content.

---

### H3 — Add Pulse to Phase 1 [persona experiment]
**Problem observed:** Persona-Phase Fit Score (M14) = 80. Phase 1 (Audit) is a high-value analytical inventory task — file classification, feature detection, persona staleness assessment — but has no persona assigned. Pulse (Analytics) exists, scores 14/14 on richness, and has DO rules directly matching Phase 1's cognitive demand: "Surface actionable improvement recommendations," "Measure against prior cycles," "Analyse… to identify patterns."
**Phase targeted:** Phase 1 (Audit) — currently no persona
**Change type:** gap-fill (unassigned phase with a non-trivial analytical cognitive demand)
**Change proposed:** Add "**Persona: Pulse (Analytics)**" load directive to p1-audit.md header, consistent with Phase 2's format. Include "If the file is not found, proceed without the persona and note its absence."
**Quality markers:**
1. Does Phase 1 output explicitly verify each persona's soul.md for an Origin section (speciation check), rather than only checking for file existence?
2. Does Phase 1 feature inventory include a confidence qualifier on borderline features (e.g., "Multi-session orchestration: uncertain — no explicit STOP but inter-run artifact use implies soft boundary")?
3. Does Phase 1 produce a structured file list with role classification tags (`[instruction]`, `[documentation]`, `[support]`) explicitly noted per file, rather than a flat list?
**Targets:** Persona-Phase Fit Score (M14): 80 → 100 (+20pp)
**Predicted improvement:** M14 +20pp
**Pattern applied:** Persona Rotation (P8)
**Risk level:** low
**Risk note:** Pulse's Failure Mode is "measurement depth without proportional stakes" — could produce an overly detailed audit. The fix is the existing constraint that P1 writes a *brief* audit summary; this is already specified.

---

### H4 — Add MX-OQ metrics to help.md [standard]
**Problem observed:** Help/Reference Synchronisation Rate (MX1) = 86. MX-OQ1–5 (Interview Acceptance Rate, First-Pass Review Rate, Plan Stability Rate, Session Satisfaction Rate, PR Critique Rate) are defined in p2-baseline.md with full methodology, but have zero documentation in help.md. Users running `/optimise help` on a kanban-workflow target cannot discover what these outcome metrics measure or when they apply.
**Change proposed:** Add 5 new detail sections in help.md's Mode: Detail section, one per MX-OQ metric, following the existing metric section format (Measures, Intent, Applies when, Weight, Skip condition, How to improve). Also add a summary note in the summary table's preamble: "For workflows producing `.kanban/` subjects, outcome metrics MX-OQ1–5 are also evaluated — see `/optimise help MX-OQ1` for the full series."
**Targets:** Help/Reference Synchronisation Rate (MX1): 86 → 100 (+14pp)
**Predicted improvement:** MX1 +14pp; weighted at 2× → +28 to composite
**Pattern applied:** Content Synchronisation Audit (P12)
**Risk level:** low
**Risk note:** Documentation-only change; no instruction logic modified

---

### H5 — Add archive filename collision rule to p5-report.md [standard]
**Problem observed:** Escape Hatch Completeness (MX2) = 90 (2 of 20 branches missing explicit guidance). The archive filename collision case — when `research-log-archive-<date>.md` already exists for the current date — is not handled (as encountered in this exact run, requiring ad-hoc `b` suffix). This is the most clearly recoverable gap.
**Change proposed:** In p5-report.md's Research Log Archival section, add: "If `research-log-archive-<date>.md` already exists, use `research-log-archive-<date>b.md` (then `c`, etc.) to avoid overwriting prior archives." The same rule should also be added to p1-audit.md's Tier A handling.
**Targets:** Escape Hatch Completeness (MX2): 90 → 95 (+5pp)
**Predicted improvement:** MX2 +5pp
**Pattern applied:** Failure Mode Registry (P10)
**Risk level:** very low
**Risk note:** Additive, self-describing rule; closes a real gap encountered in the current run

---

### Dependency order: H1 → H2 → H3 → H4 → H5
(H1 and H2 both modify p2-baseline.md — sequential with re-check between them. H3 modifies p1-audit.md. H4 modifies help.md. H5 modifies p5-report.md + p1-audit.md — overlaps with H3 on p1-audit.md, so H3 before H5 with re-check.)

### Self-Audit (Keeper)
1. **Intent check:** All 5 hypotheses target metrics below 100. ✓
2. **Coverage check:** Projected composite:
   - H1: MX3 +100pp × 1× = +100
   - H2: MX4 +100pp × 1× = +100 (conservative: ~90pp realistic)
   - H3: M14 +20pp × 1× = +20
   - H4: MX1 +14pp × 2× = +28
   - H5: MX2 +5pp × 1× = +5
   - Projected weighted sum: 2004 + 100 + 90 + 20 + 28 + 5 = 2247 / 2300 = 97.7% > 95% ✓
3. **Gap fill:** No metric below 80 with no hypothesis targeting it (MX3=0 ✓ H1, MX4=0 ✓ H2). M14=80 covered by H3. ✓

---

### Recommendation Brief

Based on baseline measurement, the following experiments are queued.

1. **Embed metric weights in the measurement instruction file** — weights for the 15 seed metrics are currently only in the documentation file (help.md), not in the Phase 2 instruction file (p2-baseline.md). An agent executing Phase 2 without prior run context has no explicit weights available. Add a weights reference table immediately above the composite calculation.

2. **Define the four pattern-target metrics that currently have no scorable definitions** — patterns P10 (Failure Mode Registry), P12 (Content Synchronisation Audit), P13 (Corrective-Pattern Applicability), and P14 (Pre-Experiment Dependency Scan) each claim to target a specific metric (Recovery Path Completeness, Help Content Currency, Pattern Experimental Validation Rate, Experiment Isolation Score respectively), but none of these metrics have definitions in p2-baseline.md. The feedback loop from pattern application to measured improvement is currently unverifiable.

3. **Assign Pulse (Analytics) to Phase 1 (Audit)** — the audit phase performs high-value analytical inventory work (file classification, feature detection, persona staleness assessment) but has no persona assigned. Pulse's core traits directly match this cognitive demand and all 4 quality markers can be spot-checked in a single-response audit of 2–3 files.

4. **Document the five pre-defined outcome metrics in help.md** — MX-OQ1–5 (outcome metrics for kanban-producing workflows) are fully defined in p2-baseline.md but entirely absent from help.md. Users running `/optimise help` on a kanban workflow target cannot discover what these metrics measure or when they apply.

5. **Add archive filename collision handling** — the P5 archival procedure does not handle the case where a same-date archive already exists (encountered in this run, requiring an ad-hoc `b` suffix). Add an explicit rule to p5-report.md and p1-audit.md.

---

## Phase 4 — Experiments

## Experiment Results — 2026-03-27 (run 1)

| Hypothesis | Outcome | Pre | Post | Delta |
|-----------|---------|-----|------|-------|
| H1 — embed metric weights in p2-baseline.md | Confirmed | MX3=0 | MX3=100 | +100pp |
| H2 — define HCU, RPC, PEV, EIS metrics | Confirmed | MX4=0 | MX4=100 | +100pp |
| H3 — add Pulse to Phase 1 [persona experiment] | Confirmed | M14=80 | M14=100 | +20pp; spot-check 3/3 |
| H4 — add MX-OQ metrics to help.md | Confirmed | MX1=86 | MX1=100 | +14pp |
| H5 — archive filename collision rule | Confirmed | MX2=90 | MX2=95 | +5pp |

**Post composite (23× weight):**
2257 / 2300 × 100 = **98.1%**

Baseline: 87.1% → Post: 98.1% (+11.0 pp)

---

## Phase 5 — Report

## Final Results — 2026-03-27

| Metric | Baseline | Post | Delta | Status |
|--------|----------|------|-------|--------|
| Intent-to-Output Traceability (M1) | 100 | 100 | — | — |
| Directive Density (M2) | 99 | 99 | — | — |
| Instruction Ambiguity Rate (M3) | 97 | 97 | — | — |
| Wiring Completeness Score (M4) | 100 | 100 | — | — |
| Redundancy Index (M5) | 98 | 98 | — | — |
| AC Concreteness (M6) | 100 | 100 | — | — |
| Human Touchpoint Count (M8) | 100 | 100 | — | — |
| Context Loading Efficiency (M10) | 90 | 90 | — | — |
| Information Freshness Score (M12) | 100 | 100 | — | — |
| Instruction Token Efficiency (M13) | 96 | 96 | — | — |
| Persona-Phase Fit Score (M14) | 80 | 100 | +20 | ↑ |
| Persona Richness Score (M15) | 100 | 100 | — | — |
| Help/Reference Synchronisation Rate (MX1) | 86 | 100 | +14 | ↑ |
| Escape Hatch Completeness (MX2) | 90 | 95 | +5 | ↑ |
| Metric Weight Discoverability (MX3) | 0 | 100 | +100 | ↑ |
| Orphaned Output Metric Coverage (MX4) | 0 | 100 | +100 | ↑ |
| Self-Application Coherence (MX5) | 92 | 92 | — | — |
| **Composite** | **87.1%** | **98.1%** | **+11.0 pp** | ↑ |

**What improved and why:**
- Metric Weight Discoverability (MX3): +100pp — weights for M1–M15 added directly to p2-baseline.md; no longer requires help.md to be loaded during Phase 2
- Orphaned Output Metric Coverage (MX4): +100pp — PEV, HCU, RPC, EIS now defined as pre-defined custom metrics in p2-baseline.md; pattern attribution is now verifiable
- Persona-Phase Fit Score (M14): +20pp — Pulse (Analytics) assigned to Phase 1 (Audit); analytical inventory phase now has a matching cognitive style
- Help/Reference Synchronisation Rate (MX1): +14pp — MX-OQ1–5 detail sections added to help.md; all 35 named entries in instruction files now documented
- Escape Hatch Completeness (MX2): +5pp — archive filename collision branch now handled with explicit b/c suffix convention

**What was dropped and why:**
- (none — all 5 hypotheses confirmed)

**What remains to improve:**
- Escape Hatch Completeness (MX2): 95% — partial-commit guidance (H5 did not address "commit or revert at your discretion" in p4-experiments.md); a future hypothesis could add "if the partial improvement is ≥2pp and the change is additive-only, commit; otherwise revert"
- Context Loading Efficiency (M10): 90% — primarily from full log re-reads in Phase 4 when only the approved-hypotheses section is needed; diminishing returns given the log's typical small size
- Self-Application Coherence (MX5): 92% — the partial credit (property 3: mid-run scoring changes) is by design; closing this gap would require locking baselines before experiments, which would prevent accurate pre/post measurement

**Log within size threshold; no archival required.** (~5,500 estimated tokens)

---

## Novel Patterns Discovered — 2026-03-27

### NP1 — Orphaned Target Completion
**Discovered in:** `skills/optimise`
**Problem it solved:** Patterns P10, P12, P13, P14 each named a target metric (PEV, HCU, RPC, EIS) that had no scorable definition in the instruction corpus. The claimed improvement loop was unverifiable — applying a pattern could not be attributed to a measured delta.
**Implementation:** Defined the 4 orphaned metrics as pre-defined custom metrics in p2-baseline.md, following the MX-OQ template (applicability, skip condition, methodology, direction, weight, normalisation).
**Metrics it improved:** Orphaned Output Metric Coverage (MX4) +100pp
**Generalises to:** Any workflow with a pattern library where pattern "Targets:" reference metrics that are not defined in the measurement file. Particularly relevant for workflows that have grown a pattern library over time without backfilling metric definitions.
**Seed candidate:** yes — any pattern library should be self-consistent; if a pattern claims to target a metric, that metric must be measurable. This is a structural property, not a quality of a specific workflow.
