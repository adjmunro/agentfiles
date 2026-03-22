# Skill Optimisation Research Log

---

## Audit — 2026-03-22

**Target:** skills/personas
**Files:** 28 total (2 command, 26 support)
**Token estimate:** ~10,300 tokens (~41,200 characters ÷ 4)

### Feature Inventory
- Multi-phase pipeline: no (summon.md is single-session; evolve.md has multi-step workflow within one session)
- Persona system: yes (11 persona pairs; personas ARE the primary artefact of this skill)
- Subagent invocations: no
- Multi-session orchestration: no
- Parallel execution: no
- Cached artifacts: no (all persona files loaded fresh per-session)

### Files

**Command files (instruction audience: agent)**
- `commands/summon.md` — ~725 tokens — summon one or more personas for freeform conversation
- `commands/evolve.md` — ~1,725 tokens — four-mode evolution: audit, speciate, distil, new

**Persona files (instruction audience: agent — contain DO/DO NOT rules loaded per-session)**
- `analytics/persona.md` (Pulse) — ~300 tokens
- `analytics/soul.md` (Pulse) — ~275 tokens
- `strategist/persona.md` (Keeper) — ~325 tokens
- `strategist/soul.md` (Keeper) — ~275 tokens
- `critic/persona.md` (Arden) — ~350 tokens
- `critic/soul.md` (Arden) — ~275 tokens
- `builder/persona.md` (Kira) — ~325 tokens
- `builder/soul.md` (Kira) — ~225 tokens
- `designer/persona.md` (Artisan) — ~250 tokens
- `designer/soul.md` (Artisan) — ~225 tokens
- `examiner/persona.md` (Echo) — ~300 tokens
- `examiner/soul.md` (Echo) — ~250 tokens
- `advocate/persona.md` (Vale) — ~300 tokens
- `advocate/soul.md` (Vale) — ~263 tokens
- `scout/persona.md` (Finn) — ~250 tokens
- `scout/soul.md` (Finn) — ~263 tokens
- `scribe/persona.md` (Vela) — ~263 tokens
- `scribe/soul.md` (Vela) — ~250 tokens
- `release/persona.md` (Helm) — ~300 tokens
- `release/soul.md` (Helm) — ~263 tokens
- `documentation/persona.md` (Ward) — ~300 tokens
- `documentation/soul.md` (Ward) — ~263 tokens

**Support files (documentation audience: human)**
- `SKILL.md` — ~550 tokens — overview and persona roster
- `AGENTS.md` — ~525 tokens — schema requirements and commit conventions
- `VERSION.md` — ~25 tokens
- `CHANGELOG.md` — ~88 tokens

### Persona Staleness Check
- All 11 persona directories exist and both `persona.md` and `soul.md` are present in each.
- No broken persona load directive references found in `summon.md` or `evolve.md`.
- No speciation history detected (no Origin sections referencing parent personas). No speciated children exist. All personas are originals.

### Unique Talent Audit (preliminary)
AGENTS.md marks Unique Talent as a required field in soul.md. Spot-check reveals:
- **Pulse (analytics)**, **Keeper (strategist)**, **Arden (critic)**: explicit `## Unique Talent` sections present — distilled in prior runs.
- **Kira, Artisan, Echo, Vale, Finn, Vela, Helm, Ward** (8 of 11): Unique Talent field absent or implied but unlabelled. This is the primary structural gap.

### File Role Stratification
For DD/ITE scoring: classify persona.md and soul.md files as instruction files (primary audience is the agent, loaded per-session, contain DO/DO NOT rules). Command files (summon.md, evolve.md) and AGENTS.md are also instruction files. SKILL.md, VERSION.md, CHANGELOG.md are documentation files — excluded from DD/ITE.

---

## Custom Metrics — 2026-03-22

### MX1 — Persona Coverage Completeness (PCC) [custom]
**Measures:** What fraction of the 16 cognitive demand taxonomy slots in `evolve.md` have a dedicated persona in the library.
**Why seeds miss it:** PRS and PPF measure persona quality and fit, not library completeness. You can have 11 perfectly rich personas and still be missing critical cognitive modes. This metric captures structural gaps at the library level.
**Methodology:** Count the number of cognitive modes in the evolve.md taxonomy table marked with a dedicated persona vs. marked as `*(gap)*`. PCC = covered_modes / total_modes.
**Direction:** ↑ higher is better (all cognitive modes covered = 100)
**Weight:** 2× — critical to the library's purpose; uncovered modes mean entire classes of agent tasks have no persona support
**Normalisation:** PCC × 100

### MX2 — Roster Synchronisation Score (RSS) [custom]
**Measures:** Whether SKILL.md roster, summon.md roster, and actual persona directories are fully in sync — no phantom entries, no undocumented directories.
**Why seeds miss it:** RI measures content redundancy; no seed measures structural alignment between the three roster locations.
**Methodology:** For each roster (SKILL.md table, summon.md table, actual directories): list all entries. Count cases where an entry appears in all three locations vs. cases where it appears in some but not all. RSS = entries_in_all_three / total_unique_entries.
**Direction:** ↑ higher is better (all entries consistent = 100)
**Weight:** 1×
**Normalisation:** RSS × 100

### MX3 — Schema Compliance Rate (SCR) [custom]
**Measures:** Average field-level compliance with AGENTS.md required schema across all persona pairs (persona.md + soul.md).
**Why seeds miss it:** PRS scores richness quality but uses a rubric with partial credit. SCR measures raw structural compliance — how many of the 13 required fields (7 persona.md + 6 soul.md) are actually present per persona.
**Methodology:** For each persona, count required fields present / required fields total (13 per non-speciated persona). Average across all 11 personas. SCR = avg(fields_present / 13) per persona.
**Direction:** ↑ higher is better (all fields present = 100)
**Weight:** 1×
**Normalisation:** SCR × 100

### MX4 — Cognitive Gap Documentation Currency (CGDC) [custom]
**Measures:** Whether the cognitive demand taxonomy table in `evolve.md` accurately reflects the current library state — i.e., all covered modes are annotated as covered and all gaps are listed.
**Why seeds miss it:** No seed measures whether the skill's own reference data is accurate. The taxonomy table is the canonical source for which modes need coverage. If it drifts from reality, the evolve audit mode will produce incorrect recommendations.
**Methodology:** For each of the 16 taxonomy entries, verify whether the coverage annotation (persona name or `*(gap)*`) matches the actual persona directories. CGDC = correct_annotations / total_annotations.
**Direction:** ↑ higher is better (all annotations accurate = 100)
**Weight:** 1×
**Normalisation:** CGDC × 100

### MX5 — Persona Differentiation Index (PDI) [custom, moonshot]
**Measures:** Pairwise uniqueness of personas — whether any two personas have substantially overlapping Purpose definitions or DO rule sets that would make one a redundant variant of the other.
**Why seeds miss it:** No seed measures intra-library redundancy at the semantic level. A persona library can grow to contain near-duplicates that dilute the signal when users choose between them. Borrowed from information-theoretic diversity metrics applied to character libraries.
**Methodology:** For each of the 55 pairs of personas (11×10÷2): assess Purpose overlap (>50% semantic similarity?) and DO rule overlap (3+ rules describing the same behavior?). Score per pair: 1.0 if neither condition (well-differentiated); 0.5 if one condition (moderate overlap); 0.0 if both conditions (near-duplicate). PDI = average score across all 55 pairs.
**Direction:** ↑ higher is better (fully differentiated library = 100)
**Weight:** 2× — a poorly differentiated library erodes user trust in persona selection
**Normalisation:** PDI × 100

---

## Baseline — 2026-03-22

**Persona: Pulse (Analytics)**

Seed metrics applied: Intent-to-Output Traceability, Directive Density, Instruction Ambiguity Rate, Wiring Completeness Score, Redundancy Index, AC Concreteness, Human Touchpoint Count, Context Loading Efficiency, Instruction Token Efficiency, Persona-Phase Fit Score, Persona Richness Score
Seed metrics skipped: Subagent Alignment Score (no subagent invocations), Context Decay Resilience (no multi-session orchestration), Parallelisation Safety Score (no parallel execution), Information Freshness Score (no cached artifacts)
Custom metrics: MX1–MX5

### File Role Stratification

Instruction files (scored for DD/ITE): `commands/summon.md` (~725t), `commands/evolve.md` (~1,725t), `AGENTS.md` (~525t), 11 × `persona.md` (~3,100t total) = ~6,075t instruction tokens.
Documentation files (excluded from DD/ITE): `SKILL.md` (~550t), `VERSION.md` (~25t), `CHANGELOG.md` (~88t), 11 × `soul.md` (~2,750t total).
Rationale for excluding soul.md: soul files are descriptive character prose (essence, opinions, contradictions, voice) — primarily human-readable character reference, not agent workflow directives.

### Metric Measurements

**M1 IOT — 50:** evolve.md has one meaningful sequential phase transition: audit phase produces a recommendation brief → execution modes proceed. The execution modes do not explicitly re-read the recommendation brief (the brief is in-session context only). Distil mode explicitly loads an evidence source (cross-session prior artifact). Score: 50. No session boundary, so partial credit for in-session context continuity; distil's evidence load is the one strong IOT case.

**M2 DD — 100:** Instruction files: ~6,075 tokens. Directives counted: summon.md (~19), evolve.md (~52), AGENTS.md (~23), 11 × persona.md (~165 total, ~15 per persona). Total: ~259 directives. DD = 259/(6,075/100) = 4.26. Normalise: (4.26/2.0)×100 = 213 → cap at 100. **DD = 100**.

**M3 IAR — 99:** One unscoped weak modal found: evolve.md new mode line "The name should suggest the role obliquely, not literally" — unscoped "should". All other directives use imperative verbs, "must", "never", or scoped conditionals. IAR = 1/259 = 0.4% → score = 100 − 0.4 = **99**.

**M4 WCS — 100:** All 11 personas listed in summon.md roster with subdirectory paths; evolve.md applies to all personas by default. WCS = 11/11 = **100**.

**M5 RI — 97:** Primary redundancy: Richness Rubric table appears in both AGENTS.md (required fields schema) and evolve.md (scoring instrument) — ~150 duplicate tokens. RI = 1 − (150/6,075) = 97.5% → **97**. Recommend leave-as-is: the two tables serve distinct purposes (normative schema vs. measurement rubric).

**M6 ACC — 72:** 18 acceptance criteria/completion conditions identified. Concrete (N=13): all STOP gate conditions, numeric thresholds (≥80% coverage check, Richness < 85, DO ≥3, DO NOT ≥2, etc.). Vague (N=5): "signals they're done", "demonstrably better than the parent", "clearly narrower niche", "measurably better outputs", "suggest the role obliquely". ACC = 13/18 = **72**.

**M8 HTC — 90:** 1 structured STOP/approval gate per evolve run (minimum). Normalise: max(0, 100 − (1/20)×100) = **90**. STOP gates are intentional safety mechanisms; this score reflects design choice not quality gap.

**M10 CLE — 95:** Per mode: summon (100%), audit (100%), speciate (100%), distil (~80% — evidence source may contain off-topic content), new (~95%). Average: (100+100+100+80+95)/5 = **95**.

**M13 ITE — 96:** Padding tokens: ~90t out of ~6,075t instruction tokens (~1.5%). Sources: summon.md narrative asides (~10t), evolve.md mode intro sentences (~20t), AGENTS.md explanatory note (~20t), minor narrative across persona.md files (~40t). ITE = 1 − (90/6,075) = 98.5% → conservatively **96**.

**M14 PPF — 40:** Five phases assessed: (1) summon.md — neutral facilitation, no persona needed → 1.0; (2) evolve audit — analytical measurement, Pulse clearly fits, none assigned → 0.0; (3) evolve speciate — creative divergence, no creative persona in library → 0.5; (4) evolve distil — analytical evidence extraction, Pulse fits, none assigned → 0.0; (5) evolve new — creative synthesis, no creative persona → 0.5. PPF = (1.0+0.0+0.5+0.0+0.5)/5 = **40**.

**M15 PRS — 79:** Distilled (Pulse, Keeper, Arden): 14/14 = 100% each. Non-distilled (Kira, Artisan, Echo, Vale, Finn, Vela, Helm, Ward): 10/14 = 71.4% each (missing Failure Mode 2pts + Unique Talent 2pts). PRS = (3×100 + 8×71.4)/11 = 871.2/11 = **79**.

**MX1 PCC — 69:** 16 cognitive modes in evolve.md taxonomy. 11 covered, 5 gaps (synthesis, adversarial red-team, pedagogical explanation, temporal reasoning, negotiation/trade-off). PCC = 11/16 = **69**.

**MX2 RSS — 100:** All 11 personas in SKILL.md roster, summon.md roster, and actual directories. All three in sync. RSS = 11/11 = **100**.

**MX3 SCR — 89:** Required fields: 13 per persona. Distilled × 3: 13/13. Non-distilled × 8: 11/13. Average: 127/143 = 88.8 → **89**.

**MX4 CGDC — 100:** All 16 taxonomy annotations verified against actual directories. 16/16 correct. **CGDC = 100**.

**MX5 PDI — 97:** 55 pairs assessed. Pairs with moderate overlap (0.5): Arden/Echo (same review phase, different jobs — explicitly coordinated), Finn/Echo (both "find and map" roles but different workflow stages). All other 53 pairs well-differentiated (1.0). PDI = (53×1.0 + 2×0.5)/55 = 54/55 = **97**.

### Composite Calculation

```
Seed metrics applied: IOT(2×), DD(1×), IAR(1×), WCS(1×), RI(1×), ACC(2×), HTC(2×), CLE(2×), ITE(1×), PPF(2×), PRS(1×)
Seed metrics skipped: SAS (no subagents), CDR (no multi-session), PSS (no parallel), IFS (no cached artifacts)
Custom metrics: PCC(2×), RSS(1×), SCR(1×), CGDC(1×), PDI(2×)

| Metric | Source | Raw | Normalised | Weight | Weighted |
|--------|--------|-----|------------|--------|----------|
| Intent-to-Output Traceability | seed | 1 explicit load | 50 | 2× | 100 |
| Directive Density | seed | 4.26 directives/100t | 100 | 1× | 100 |
| Instruction Ambiguity Rate | seed | 0.4% | 99 | 1× | 99 |
| Wiring Completeness Score | seed | 11/11 | 100 | 1× | 100 |
| Redundancy Index | seed | 2.5% | 97 | 1× | 97 |
| AC Concreteness | seed | 13/18 | 72 | 2× | 144 |
| Human Touchpoint Count | seed | 1 gate | 90 | 2× | 180 |
| Context Loading Efficiency | seed | avg 95% | 95 | 2× | 190 |
| Instruction Token Efficiency | seed | 1.5% padding | 96 | 1× | 96 |
| Persona-Phase Fit Score | seed | 2.0/5 | 40 | 2× | 80 |
| Persona Richness Score | seed | 79.2% | 79 | 1× | 79 |
| Persona Coverage Completeness | custom | 11/16 | 69 | 2× | 138 |
| Roster Synchronisation Score | custom | 11/11 | 100 | 1× | 100 |
| Schema Compliance Rate | custom | 127/143 | 89 | 1× | 89 |
| Cognitive Gap Documentation Currency | custom | 16/16 | 100 | 1× | 100 |
| Persona Differentiation Index | custom | 54/55 | 97 | 2× | 194 |
| TOTAL | | | | 23× | 1,886 / 2,300 |

Composite: 1,886 / (23 × 100) × 100 = 82.0%
```

**Baseline Composite: 82.0%**

**Weakest 5:** PPF (40), PCC (69), ACC (72), PRS (79), SCR (89)
**Strongest 5:** DD (100), WCS (100), RSS (100), CGDC (100), IAR (99)

---

## Experiments — 2026-03-22 (run 1)

**Persona: Keeper (Strategist)**

**Pre-experiment dependency scan:** H1 modifies 16 persona files (persona.md + soul.md × 8). H2 modifies evolve.md. H3 creates new files in a new directory. H4 modifies evolve.md. **Overlap: H2 and H4 both modify evolve.md — these must run sequentially with a metric re-check between them.** H1 and H3 are independent of each other and of H2/H4.

### H1 — Add Failure Mode and Unique Talent to 8 non-distilled personas
**Problem observed:** Persona Richness Score (M15) = 79 and Schema Compliance Rate (MX3) = 89. Eight of 11 personas (Kira, Artisan, Echo, Vale, Finn, Vela, Helm, Ward) are missing Failure Mode (persona.md, 2 rubric pts) and Unique Talent (soul.md, 2 rubric pts). SKILL.md and AGENTS.md both flag these as mandatory fields, explicitly noting "Unique Talent and Failure Mode are what distinguish a persona that changes behaviour from one that is merely decorative." All 8 score exactly 71% on the richness rubric — the declared floor for functionally decorative personas.
**Change proposed:** For each of the 8 non-distilled personas, add a `## Failure Mode` section to `persona.md` and a `## Unique Talent` section to `soul.md`. Derive content from each persona's existing DO/DO NOT rules and Purpose (gap-fill using persona content as primary evidence — no external run log required since the persona's own design reveals its characteristic failure pattern and cognitive superpower).
**Targets:** Persona Richness Score (M15) ↑, Schema Compliance Rate (MX3) ↑
**Predicted improvement:** PRS 79→100 (+21pp ×1×), SCR 89→100 (+11pp ×1×); secondary: Persona-Phase Fit Score (PPF) partial improvement — richer personas score higher on the M14 richness depth check (personas <71% score partial regardless of cognitive alignment). Composite delta ~+0.7pp
**Pattern applied:** P9 — Persona Speciation (gap-fill distillation: add missing required fields by reasoning from each persona's existing design content)
**Risk level:** medium
**Risk note:** Without external run-log evidence, the Failure Mode and Unique Talent entries will be inferred rather than observed. Inferred entries may be generic ("can be too thorough") rather than specific ("identifies 14 minor gaps before naming the one critical finding"). Quality check: does each entry name a *specific* failure mechanism the persona's DO rules create, rather than a general trait? Does each Unique Talent name something no other persona does in the same way?

---

### H2 — Add Pulse directive to evolve.md audit and distil modes [persona experiment]
**Problem observed:** Persona-Phase Fit Score (M14) = 40. The two most analytically demanding modes in evolve.md — audit (systematic measurement of 11 personas on a 14-point rubric) and distil (evidence extraction and rule-writing from run logs) — have no persona directive. Pulse (Analytics) is explicitly designed for "systematic measurement, quantitative scoring, pattern detection" — precisely the cognitive demand of these modes. Without Pulse, the audit mode risks: producing inconsistent rubric scores, treating qualitative judgment as quantitative measurement, and missing pattern-level observations (e.g., "7 of 11 personas are missing the same 2 fields" as a library-level pattern rather than 8 independent observations).
**Phase targeted:** evolve.md audit mode and distil mode; currently unassigned
**Change type:** gap-fill
**Change proposed:** Add persona load directive to evolve.md at the start of audit mode: `**Persona: Pulse (Analytics)** — load analytics/persona.md and analytics/soul.md now. If not found, proceed without persona.` Add equivalent directive to the distil mode start.
**Quality markers:**
  1. Does the audit mode's output show a library-level pattern observation (e.g., noting that N of 11 personas share the same missing field) rather than scoring each persona in isolation?
  2. Does the distil mode's evidence extraction distinguish measurement artefacts (a DO rule that appeared in output but wasn't actually persona-driven) from genuine emergent behaviors?
  3. Does the audit output include a composite richness score across all personas, not just per-persona scores?
**Targets:** Persona-Phase Fit Score (M14) ↑
**Predicted improvement:** PPF 40→68 (+28pp ×2×); audit (0→1.0) + distil (0→1.0) + unchanged speciate (0.5) + new (0.5) + summon (1.0) = 4.0/5 = 80%, but partial credit for Pulse's depth check → PPF = (1.0+1.0+0.5+0.5+1.0)/5 = 4.0/5 = 80. Composite delta ~+1.1pp
**Pattern applied:** P8 — Persona Rotation [gap-fill: phases currently unassigned with clear analytical demand]
**Risk level:** low
**Risk note:** Since evolve.md IS the persona management tool, loading Pulse to execute the audit creates a slight meta-circularity (a persona scores all the other personas). This is intentional and appropriate — Pulse's measurement mindset is exactly what's needed. Risk: if the Pulse persona file is not found at load time, the audit falls back to no-persona (current state), so no regression.

---

### H3 — Add concrete completion criteria to evolve.md vague thresholds
**Problem observed:** AC Concreteness (M6) = 72. Five of 18 acceptance criteria in evolve.md are vague — they require subjective judgment to apply. The most consequential vague criteria govern speciation (what makes a variant "demonstrably better" and "clearly narrower") and distillation (what makes an output "measurably better"). These criteria are used at decision points where agents must determine whether work is complete. Vague criteria at decision points produce inconsistent outcomes across runs and agents.
**Change proposed:** Replace the 4 actionable vague criteria in evolve.md with concrete alternatives:
1. "demonstrably better than the parent in its niche" → "outperforms the parent on ≥2 of the 3 quality markers defined at hypothesis time, OR covers a cognitive mode the parent explicitly does not"
2. "clearly narrower niche" → "targets a specific cognitive demand from the taxonomy table; the parent persona's Purpose sentence must span ≥2 distinct cognitive modes for this to apply"
3. "behaviors that consistently produced measurably better outputs" → "appears in the evidence source at least twice, associated with outputs that scored confirmed (≥3pp improvement) or received explicit positive attribution"
4. "The name should suggest the role obliquely, not literally" → "the persona name must not contain the role word verbatim (e.g., 'Audit-Bot' is disallowed if the role is 'auditor'); names drawn from archetypes, mythology, or nature are preferred"
(The 5th vague criterion — "session continues until the user signals done" in summon.md — is intentionally open-ended for a conversation interface; leave as-is.)
**Targets:** AC Concreteness (M6) ↑
**Predicted improvement:** ACC 72→94 (+22pp ×2×). Four of the five vague criteria are resolved; the fifth (summon.md exit condition) is kept intentionally vague. Composite delta ~+1.9pp
**Pattern applied:** P6 — Symmetric Outcome Thresholds (define concrete numeric or structural boundaries for what counts as meeting the criterion)
**Risk level:** low
**Risk note:** H2 and H3 both modify `evolve.md` — must run sequentially with a metric re-check between them per the pre-experiment dependency scan. The new criteria for speciation quality markers must not conflict with the existing recommendation brief format. Verify that the new wording for criterion 1 doesn't make speciation impossible (all existing/future speciation attempts should still be able to satisfy ≥2 of 3 quality markers).

---

### H4 — Create a new persona for the adversarial red-team cognitive gap
**Problem observed:** Persona Coverage Completeness (MX1) = 69. Five cognitive demand slots are unoccupied. The most critical unmet demand — adversarial red-team — has no analog in the current library. The existing critic persona (Arden) finds gaps in *requirements*; no persona stress-tests whether a *system* fails under adversarial conditions (unexpected inputs, attacker models, edge-case assumptions). This gap means any agent workflow involving security review, fault injection, or worst-case path analysis has no persona with the right cognitive mode.
**Change proposed:** Create a new persona for adversarial/red-team thinking. The persona should: assume everything is operating normally until proven otherwise, actively seek failure paths the "happy path" design misses, hold the attacker's mental model. Create `{new-dir}/persona.md` and `{new-dir}/soul.md` per AGENTS.md spec (with all required fields including Failure Mode and Unique Talent). Add to SKILL.md roster, summon.md roster, and evolve.md taxonomy. Bump version.
**Targets:** Persona Coverage Completeness (MX1) ↑, Cognitive Gap Documentation Currency (MX4) ↑ (after taxonomy updated), Roster Synchronisation Score (MX2) ↑ (after all three roster locations updated)
**Predicted improvement:** PCC 69→75 (+6pp ×2×); CGDC 100→100 (remains accurate after update); RSS 100→100 (remains in sync). Composite delta ~+0.5pp from PCC alone. Secondary: PPF slight improvement if any existing or future phase assigns the new persona to an adversarial review phase.
**Pattern applied:** P9 — Persona Speciation (new mode: create a new archetype from scratch for an unmet cognitive demand)
**Risk level:** medium
**Risk note:** Creating a new persona without prior run evidence means the Failure Mode and Unique Talent will be inferred from first principles. Quality bar: the new persona should be clearly differentiated from Arden (Critic) — its Unique Talent must describe something Arden cannot do, and its Failure Mode must describe a pattern distinct from Arden's "gap enumeration without priority." If the two personas are too similar, PDI (Persona Differentiation Index) may decline slightly.

---

## Experiment Results — 2026-03-22 (run 1)

### H1 — Add Failure Mode and Unique Talent to 8 non-distilled personas
**Status:** Confirmed
**Files changed:** 16 (persona.md × 8 + soul.md × 8: Kira, Artisan, Echo, Vale, Finn, Vela, Helm, Ward)
**Observed:** PRS 79→100 (+21pp ×1×). SCR 89→100 (+11pp ×1×). All 8 personas now score 14/14 on the richness rubric. Quality check: Failure Mode entries describe specific patterns each persona's DO rules create (not generic); Unique Talent entries name a capability no other persona covers in the same way. No secondary regressions.
**Spot-check quality:** 3/3 sampled personas (Scout, Scribe, Release) produced Failure Mode and Unique Talent content that is specific, non-generic, and differentiated from Arden's analogues.

### H2 — Add Pulse directive to evolve.md audit and distil modes
**Status:** Confirmed
**Files changed:** 1 (evolve.md — audit mode header, distil mode header)
**Observed:** PPF 40→80 (+40pp ×2×). Audit and distil modes now have explicit Pulse directive with graceful fallback. Spot-check: 2.5/3 quality markers met (audit now instructs library-level pattern observation; distil now instructs measurement-artefact vs. genuine emergent behaviour distinction; composite audit score instruction is implicit rather than explicit — minor shortfall). No secondary regressions.
**Note:** Spot-check marker 3 (explicit composite richness score instruction in audit output) was partially met; Pulse's measurement mindset will produce this naturally but the instruction doesn't mandate it directly. Accepted as confirmed given the other two markers are fully met.

### H3 — Replace 4 vague completion criteria with concrete alternatives
**Status:** Confirmed
**Files changed:** 1 (evolve.md — speciate criteria ×2, distil criteria ×1, new-mode criteria ×1)
**Observed:** ACC 72→94 (+22pp ×2×). Four of five vague criteria replaced with measurable alternatives. The fifth (summon.md exit condition) intentionally preserved. Quality check: the "preferred" hedge in the naming criterion (H3 replacement 4) is a softer modal, but it accompanies a concrete "must not" prohibition — the primary test is now binary, the style preference is secondary. ACC = 17/18 = 94. ✓
**Secondary:** IAR 99→99 (unchanged — "preferred" replaces removed "should"; net weak modal count stays at ~1).

### H4 — Create Rook (Adversary) persona
**Status:** Confirmed
**Files created:** 2 (adversarial/persona.md, adversarial/soul.md — all mandatory fields present: Purpose, DO ×5, DO NOT ×5, When to summon, Failure Mode; Essence, Core Truths ×3, Opinions ×3, Contradictions ×3, Voice, Unique Talent)
**Files updated:** 3 (SKILL.md roster, summon.md roster, evolve.md taxonomy)
**Observed:** PCC 69→75 (+6pp ×2×). Taxonomy updated: adversarial red-team row now shows Rook (Adversary). CGDC=100 (all 16 annotations accurate). RSS=100 (12/12 personas in all three roster locations). PDI=97 (Rook-Arden pair scored 0.5 — moderate overlap; all other 11 new Rook pairs scored 1.0; new PDI = 64.5/66 = 97, unchanged).
**Differentiation check:** Rook's Unique Talent — "compliant non-compliance" — is distinct from Arden's Unique Talent ("compensating regressions" — lateral metric scan). Rook's Failure Mode (over-attribution of adversarial intent) is distinct from Arden's (gap enumeration without priority). Rook-Arden overlap scored moderate (0.5) not redundant (0.0).

---

## Final Results — Run 1 — 2026-03-22

```
| Metric | Baseline | Final | Delta | Weight | Weighted Δ |
|--------|----------|-------|-------|--------|------------|
| IOT    | 50       | 50    | 0     | 2×     | 0          |
| DD     | 100      | 100   | 0     | 1×     | 0          |
| IAR    | 99       | 99    | 0     | 1×     | 0          |
| WCS    | 100      | 100   | 0     | 1×     | 0          |
| RI     | 97       | 97    | 0     | 1×     | 0          |
| ACC    | 72       | 94    | +22   | 2×     | +44        |
| HTC    | 90       | 90    | 0     | 2×     | 0          |
| CLE    | 95       | 95    | 0     | 2×     | 0          |
| ITE    | 96       | 96    | 0     | 1×     | 0          |
| PPF    | 40       | 80    | +40   | 2×     | +80        |
| PRS    | 79       | 100   | +21   | 1×     | +21        |
| PCC    | 69       | 75    | +6    | 2×     | +12        |
| RSS    | 100      | 100   | 0     | 1×     | 0          |
| SCR    | 89       | 100   | +11   | 1×     | +11        |
| CGDC   | 100      | 100   | 0     | 1×     | 0          |
| PDI    | 97       | 97    | 0     | 2×     | 0          |
| TOTAL  | 1,886/2,300 | 2,054/2,300 | +168 | 23× | +168 |

Composite: 1,886/2,300 = 82.0% → 2,054/2,300 = 89.3% (+7.3pp)
```

**All 4 hypotheses confirmed. No regressions.**

Largest movers:
1. H2 PPF 40→80 (+80 weighted pts) — Pulse directive added to highest-cognitive-demand modes; resolves structural under-assignment
2. H3 ACC 72→94 (+44 weighted pts) — 4 vague decision-point criteria now have measurable thresholds
3. H1 PRS 79→100 (+21), SCR 89→100 (+11) (+32 weighted pts) — all mandatory fields present across all personas
4. H4 PCC 69→75 (+12 weighted pts) — adversarial red-team cognitive gap filled

Remaining gaps:
- IOT=50 — evolve.md distil mode loads prior-run evidence but outputs are not explicitly traced back to the evidence source in a machine-readable way; improving this requires a structured output format change
- PPF=80 — two modes (speciate, new) still have no persona assigned; no existing persona precisely covers creative archetype generation; future speciation candidate
- PCC=75 — four cognitive modes still uncovered (synthesis, pedagogical explanation, temporal reasoning, negotiation/trade-off); each is a genuine new-persona candidate for future runs

---

## Novel Patterns — Run 1 — 2026-03-22

### NP1 — Persona Library as Instruction Target
**Observed in:** H1, H4
**Description:** When the optimise skill targets a persona library, the personas themselves are the primary instruction artefact (DO/DO NOT rules are agent directives loaded per-session). Soul files are character reference prose — not instruction files. The DD/ITE stratification must exclude soul.md from the instruction file set or scores will be artificially deflated by prose tokens with no directive density.
**Generalises to:** Any skill where the primary artefact type is character/persona definitions rather than workflow procedures.
**Seed candidate:** yes

### NP2 — Richness Rubric as Schema Compliance Proxy
**Observed in:** H1 baseline measurement
**Description:** When a skill has an explicit richness rubric (like the 14-point persona rubric in AGENTS.md), PRS effectively functions as a schema compliance rate (SCR). The two metrics were highly correlated at baseline (PRS=79, SCR=89 — both measuring "are required fields present?"). The divergence (10pp) was due to PRS using partial credit (Richness Rubric) while SCR used binary field presence. In future runs, if both metrics are available, the divergence between them reveals the quality of partial-credit fields — a library where PRS >> SCR has partially-filled required fields; where PRS ≈ SCR, fields are either fully present or fully absent.
**Generalises to:** Any skill with explicit schema requirements and a richness scoring instrument.
**Seed candidate:** yes

---
