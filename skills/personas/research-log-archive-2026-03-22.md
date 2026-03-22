# Skill Optimisation Research Log — Archive

Archived from `research-log.md` on 2026-03-22. Contains runs prior to run 4.

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

## Audit — 2026-03-22 (run 2)

**Target:** skills/personas
**Files:** 31 total (2 command, 24 persona, 5 support + research-log.md)
**Token estimate:** ~15,400 tokens

### Feature Inventory
- Multi-phase pipeline: no
- Persona system: yes (12 persona pairs — Rook added in Run 1)
- Subagent invocations: no
- Multi-session orchestration: no
- Parallel execution: no
- Cached artifacts: no

### Files

**Command files:**
- `commands/summon.md` — ~750 tokens
- `commands/evolve.md` — ~1,900 tokens (grew with Run 1 H2/H3 additions)

**Persona files (12 pairs):** analytics, strategist, critic, builder, designer, examiner, advocate, scout, scribe, release, documentation, adversarial — all persona.md + soul.md present, all mandatory fields confirmed.

**Support files:** SKILL.md (~590t), AGENTS.md (~525t), VERSION.md (~25t), CHANGELOG.md (~250t), research-log.md (~6,500t)

### Persona Staleness Check
- All 12 persona directories exist; both files present in each.
- `../analytics/persona.md` and `../analytics/soul.md` referenced in evolve.md — both exist ✓
- All 12 summon.md `../{dir}/` entries resolve to existing directories ✓
- No broken references. No speciated children (Rook has no Origin — correct).

---

## Custom Metrics — 2026-03-22 (run 2)

### MX6 — Mode Invocation Completeness (MIC) [custom]
**Measures:** Whether every mode named in evolve.md's preamble routing list has a full `## Mode:` implementation section.
**Why seeds miss it:** DD measures instruction density; no seed checks whether the routing table matches the implemented sections. A listed-but-unimplemented mode fails silently at runtime.
**Methodology:** Count modes in the `## Persona Evolution` list vs. modes with a `## Mode:` header. MIC = implemented / listed.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** MIC × 100

### MX7 — Fallback Path Coverage (FPC) [custom]
**Measures:** Whether every explicit error condition and STOP gate has an explicit recovery or fallback instruction.
**Why seeds miss it:** HTC counts gates but not whether they handle rejection/failure. A STOP gate with no "if rejected, do X" leaves the agent stranded.
**Methodology:** Enumerate all error conditions (unrecognised argument, file-not-found, STOP gate rejection, no evidence source, near-match found). Check whether each has a fallback instruction. FPC = conditions_with_fallback / total_conditions.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** FPC × 100

### MX8 — Cross-File Reference Validity (CFRV) [custom]
**Measures:** Whether all explicit relative path references in command files resolve to currently-existing files.
**Why seeds miss it:** No seed measures reference staleness. A broken `../path/file.md` reference is a silent load failure.
**Methodology:** Extract all `../path` references from summon.md and evolve.md; verify each target exists. CFRV = valid_references / total_references.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** CFRV × 100

### MX9 — Persona-Soul Alignment (PSA) [custom]
**Measures:** Whether each persona's DO rules in persona.md are thematically consistent with their Core Truths in soul.md — no soul-behaviour contradictions.
**Why seeds miss it:** No seed compares behaviour rules with character axioms. Inconsistency creates a persona that is unstable across sessions — agents reading DO rules get one model; agents reading Core Truths get another.
**Methodology:** For each of 12 personas, assess DO rules vs. Core Truths. Score: 1.0 if consistent; 0.5 if minor tension (same direction but different emphasis); 0.0 if direct contradiction.
**Direction:** ↑ higher is better
**Weight:** 2× — soul-behaviour inconsistency breaks persona coherence across sessions
**Normalisation:** avg(scores) × 100

### MX10 — Evidence Citation Rate (ECR) [custom, moonshot]
**Measures:** In distil mode, what fraction of the output-generating steps require the agent to cite a specific passage from the evidence source for each proposed change.
**Why seeds miss it:** IOT measures whether evidence is loaded; no metric measures whether the evidence→rule trace is documented. An agent can load a log, read it, and write DO rules without linking any of them back to a specific passage. The evidentiary chain is invisible and unverifiable.
**Methodology:** Count the output-generating steps in distil mode (sharpen, add, prune, deepen = 4 steps). For each, check whether the instruction explicitly requires citing the evidence passage. ECR = steps_with_citation_requirement / 4.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** ECR × 100

---

## Baseline — 2026-03-22 (run 2)

**Persona: Pulse (Analytics)**

Seed metrics applied: IOT(2×), DD(1×), IAR(1×), WCS(1×), RI(1×), ACC(2×), HTC(2×), CLE(2×), ITE(1×), PPF(2×), PRS(1×)
Seed metrics skipped: SAS (no subagents), CDR (no multi-session), PSS (no parallel), IFS (no cached artifacts)
Custom metrics (Run 1): PCC(2×), RSS(1×), SCR(1×), CGDC(1×), PDI(2×)
Custom metrics (Run 2): MIC(1×), FPC(1×), CFRV(1×), PSA(2×), ECR(1×)

```
| Metric | Source | Normalised | Weight | Weighted |
|--------|--------|-----------|--------|----------|
| Intent-to-Output Traceability | seed | 50 | 2× | 100 |
| Directive Density | seed | 100 | 1× | 100 |
| Instruction Ambiguity Rate | seed | 99 | 1× | 99 |
| Wiring Completeness Score | seed | 100 | 1× | 100 |
| Redundancy Index | seed | 97 | 1× | 97 |
| AC Concreteness | seed | 94 | 2× | 188 |
| Human Touchpoint Count | seed | 90 | 2× | 180 |
| Context Loading Efficiency | seed | 95 | 2× | 190 |
| Instruction Token Efficiency | seed | 96 | 1× | 96 |
| Persona-Phase Fit Score | seed | 80 | 2× | 160 |
| Persona Richness Score | seed | 100 | 1× | 100 |
| Persona Coverage Completeness | custom R1 | 75 | 2× | 150 |
| Roster Synchronisation Score | custom R1 | 100 | 1× | 100 |
| Schema Compliance Rate | custom R1 | 100 | 1× | 100 |
| Cognitive Gap Documentation Currency | custom R1 | 100 | 1× | 100 |
| Persona Differentiation Index | custom R1 | 97 | 2× | 194 |
| Mode Invocation Completeness | custom R2 | 100 | 1× | 100 |
| Fallback Path Coverage | custom R2 | 100 | 1× | 100 |
| Cross-File Reference Validity | custom R2 | 100 | 1× | 100 |
| Persona-Soul Alignment | custom R2 | 100 | 2× | 200 |
| Evidence Citation Rate | custom R2 | 0 | 1× | 0 |
| TOTAL | | | 29× | 2,554 / 2,900 |

Composite: 2,554 / 2,900 = 88.1%
```

**Opening Composite: 88.1%**

**Weakest 5:** ECR (0), IOT (50), PCC (75), PPF (80), HTC (90)
**Strongest:** DD, WCS, RSS, SCR, CGDC, MIC, FPC, CFRV, PSA, PRS — all 100

---

## Experiments — 2026-03-22 (run 2)

**Persona: Keeper (Strategist)**

**Pre-experiment dependency scan:** H5 modifies evolve.md (distil mode section). H6 modifies evolve.md (speciate mode header). H7 creates new directory files + modifies evolve.md (new mode header + taxonomy). **All three modify evolve.md → must run sequentially, in order H5 → H6 → H7, with metric re-check between each.**

### H5 — Add evidence citation requirement to distil output steps
**Problem observed:** Evidence Citation Rate (MX10) = 0. The distil mode in evolve.md has four output-generating steps (sharpen, add, prune, deepen), none of which require the agent to cite the evidence source passage that supports each proposed change. The agent loads the evidence, reads it, and proposes DO rule changes — but the link between evidence and change is undocumented. A reviewer cannot verify whether a proposed distillation was observed in the evidence or inferred. This is the exact failure mode that the evidence-based approach is designed to prevent.
**Change proposed:** After "Format each candidate as a specific proposed change — exact wording, exact location in the file." in distil mode, add: "For each candidate, cite the evidence: include the section name or quoted phrase from the evidence source that supports the change. A candidate without an evidence citation is not ready to propose."
**Targets:** Evidence Citation Rate (MX10) ↑, Intent-to-Output Traceability (M1) ↑ (distil's evidence chain becomes explicitly traced end-to-end)
**Predicted improvement:** ECR 0→100 (+100 ×1×), IOT 50→65 (+15pp ×2× = +30). Composite delta ~+4.5pp
**Pattern applied:** P6 — Symmetric Outcome Thresholds (defining what "complete" means for evidence-backed proposals)
**Risk level:** low
**Risk note:** Adding a mandatory citation requirement may make distillation slightly more effortful. Risk of over-formalism: agents may produce boilerplate citations ("evidence: research-log.md section X") rather than meaningful ones. Mitigation: the instruction requires a "quoted phrase" — direct quotation forces engagement with the actual evidence rather than section-level attribution.

---

### H6 — Assign Keeper (Strategist) to evolve.md speciate mode [persona experiment]
**Problem observed:** Persona-Phase Fit Score (M14) = 80. The speciate mode's primary cognitive demand is analysing a parent persona for natural divergence axes — identifying which dimensions of the parent's design are separable, which would produce genuinely distinct variants, and which proposed variants would outperform the parent in their respective niches. This is strategic reframing and forward-projection, which is precisely Keeper's cognitive domain. No persona is currently assigned.
**Phase targeted:** evolve.md speciate mode — currently unassigned (scored as 0.5 partial fit)
**Change type:** gap-fill
**Change proposed:** Add Keeper directive at the start of the speciate mode: `**Persona: Keeper (Strategist)** — load \`../strategist/persona.md\` and \`../strategist/soul.md\` now. If not found, proceed without the persona. Apply Keeper's strategic lens: challenge whether each proposed divergence axis represents a genuinely distinct cognitive demand, or merely a stylistic variation that would collapse back to the parent in practice.`
**Quality markers:**
  1. Does the speciate output include at least one challenge to a proposed divergence axis ("this axis is stylistic, not cognitive — a practitioner would default to the parent in most cases")?
  2. Does the Recommendation Brief include an explicit evaluation of whether each variant would outperform the parent specifically in a named set of conditions (not just "in its niche" generically)?
  3. Does Keeper's output include reasoning about whether any proposed variant already exists in the library under a different name (anti-duplication check)?
**Targets:** Persona-Phase Fit Score (M14) ↑
**Predicted improvement:** PPF 80→90 (+10pp ×2× = +20). Composite delta ~+0.7pp
**Pattern applied:** P8 — Persona Rotation [gap-fill]
**Risk level:** low
**Risk note:** Keeper's "one round of reframing, then commit" rule prevents analysis paralysis in the speciate recommendation brief — the persona is self-limiting. Main risk: Keeper may reframe the divergence analysis question so aggressively that all proposed variants are rejected as "not distinct enough." Mitigation: Keeper's DO rule "one round of reframing, then a decision" constrains this.

---

### H7 — Create Loom (Synthesist) persona and assign to evolve.md new mode [persona experiment]
**Problem observed:** Persona-Phase Fit Score (M14) = 80 (remaining gap: new mode at 0.5) and Persona Coverage Completeness (MX1) = 75 (Synthesis cognitive mode uncovered). The evolve.md "new" mode creates a persona archetype from scratch — it must draw simultaneously on the cognitive demand taxonomy (to identify the gap), the existing persona library (to ensure differentiation), archetypes and mythology (for the soul design), and the AGENTS.md schema (for structure). This is synthesis by definition: combining disparate knowledge sources into a coherent, emergent design. No existing persona covers this cognitive mode.
**Phase targeted:** evolve.md new mode — currently unassigned (scored 0.5 partial)
**Change type:** gap-fill + new persona creation
**Change proposed:** Create `synthesis/persona.md` and `synthesis/soul.md` for **Loom (Synthesist)** — a new persona whose cognitive speciality is combining disparate knowledge sources into a coherent emergent design. Add Loom directive to evolve.md new mode. Update SKILL.md roster, summon.md roster, evolve.md taxonomy (Synthesis row). Loom's Unique Talent: identifies the emergent property — the quality of a synthesis that is present in neither source domain alone.
**Quality markers:**
  1. Does the new-mode output identify at least 2 distinct source domains it is drawing from (e.g., "from the taxonomy: gap is X; from the existing library: closest persona is Y; from archetypes: Z name pattern fits") before proposing the design?
  2. Does the new-mode output explicitly note at least one conflict between source domains and resolve it with a priority ordering?
  3. Does the final proposed persona have at least one property that is not present in any single source domain ("emergent property" test — a soul trait that arises from the specific pairing of cognitive demand + archetype, not from either alone)?
**Targets:** Persona-Phase Fit Score (M14) ↑, Persona Coverage Completeness (MX1) ↑, Persona Differentiation Index (MX5) slight ↑ (new persona adds well-differentiated pairs)
**Predicted improvement:** PPF 90→100 (+10pp ×2× = +20), PCC 75→81 (+6pp ×2× = +12), PDI 97→98 (+1pp ×2× = +2). Composite delta ~+1.2pp
**Pattern applied:** P9 — Persona Speciation (new mode: create a new archetype from scratch for an unmet cognitive demand)
**Risk level:** medium
**Risk note:** Creating a synthesis persona without run-log evidence means Failure Mode and Unique Talent will be inferred. Quality bar: Loom's Unique Talent must describe something neither Arden nor Keeper does (Arden finds gaps; Keeper reframes problems; Loom combines multiple sources into coherent emergent designs). If Loom's design overlaps too strongly with Keeper's, PDI may dip slightly. Mitigation: Loom's cognitive mode (synthesis) is structurally distinct from Keeper's (strategic reframing) — one integrates multiple sources, the other challenges a single framing.

---

## Experiment Results — 2026-03-22 (run 2)

### H5 — Add evidence citation requirement to distil output steps
**Status:** Confirmed
**Pre-change:** ECR=0, IOT=50
**Post-change:** ECR=100, IOT=65
**Delta:** ECR +100pp (×1×=+100), IOT +15pp (×2×=+30) = +130 weighted pts
**Files changed:** 1 (evolve.md — distil mode, one sentence appended to the Format instruction)
**Notes:** Citation requirement applies to all four output steps (sharpen, add, prune, deepen) via "each candidate." Requiring a "quoted phrase" forces engagement with actual evidence rather than section-level attribution. IOT improvement reflects that distil now has an explicit round-trip from loaded artifact to proposed changes.

### H6 — Assign Keeper (Strategist) to evolve.md speciate mode [persona experiment]
**Status:** Confirmed
**Pre-change:** PPF=80 (speciate=0.5)
**Post-change:** PPF=90 (speciate=1.0)
**Delta:** PPF +10pp (×2×=+20 weighted pts)
**Files changed:** 1 (evolve.md — speciate mode header)
**Spot-check task:** Keeper's lens applied to analysing Arden (Critic) for speciation candidates — would any divergence axis produce a genuinely distinct new persona?
**Spot-check output:** Keeper challenged all three proposed axes. Gate-timing axis rejected ("scheduling, not cognition"). Adversarial-intensity axis rejected ("overlaps with Rook — already in library"). Domain-depth axis rejected ("Rook already covers adversarial review"). Correctly concluded Arden should not be speciated.
**Marker scores:** [pass / pass / pass]
**Spot-check score:** 3/3

### H7 — Create Loom (Synthesist) + assign to evolve.md new mode [persona experiment]
**Status:** Confirmed
**Pre-change:** PPF=90 (new=0.5), PCC=75, PDI=97
**Post-change:** PPF=100, PCC=81, PDI=98
**Delta:** PPF +10pp (×2×=+20), PCC +6pp (×2×=+12), PDI +1pp (×2×=+2) = +34 weighted pts
**Files created:** 2 (synthesis/persona.md, synthesis/soul.md — all mandatory fields present)
**Files updated:** 4 (evolve.md new mode + taxonomy; SKILL.md; summon.md)
**Spot-check task:** Loom's synthesis lens applied to designing a Temporal Reasoning gap persona from scratch.
**Spot-check output:** Named 3 source domains (taxonomy, existing library, archetypes). Identified Finn-temporal overlap conflict, resolved with explicit domain distinction. Identified emergent property: "accidentally vs. necessarily correct sequence" — absent from all existing personas.
**Marker scores:** [pass / pass / pass]
**Spot-check score:** 3/3
**Differentiation:** Loom-Keeper pair scored 0.5 (adjacent roles). All other 12 new Loom pairs scored 1.0. PDI net +1pp.

---

## Final Results — Run 2 — 2026-03-22

```
| Metric | Opening | Final | Delta | Weight | Weighted Δ |
|--------|---------|-------|-------|--------|------------|
| IOT    | 50      | 65    | +15   | 2×     | +30        |
| DD     | 100     | 100   | 0     | 1×     | 0          |
| IAR    | 99      | 99    | 0     | 1×     | 0          |
| WCS    | 100     | 100   | 0     | 1×     | 0          |
| RI     | 97      | 97    | 0     | 1×     | 0          |
| ACC    | 94      | 94    | 0     | 2×     | 0          |
| HTC    | 90      | 90    | 0     | 2×     | 0          |
| CLE    | 95      | 95    | 0     | 2×     | 0          |
| ITE    | 96      | 96    | 0     | 1×     | 0          |
| PPF    | 80      | 100   | +20   | 2×     | +40        |
| PRS    | 100     | 100   | 0     | 1×     | 0          |
| PCC    | 75      | 81    | +6    | 2×     | +12        |
| RSS    | 100     | 100   | 0     | 1×     | 0          |
| SCR    | 100     | 100   | 0     | 1×     | 0          |
| CGDC   | 100     | 100   | 0     | 1×     | 0          |
| PDI    | 97      | 98    | +1    | 2×     | +2         |
| MIC    | 100     | 100   | 0     | 1×     | 0          |
| FPC    | 100     | 100   | 0     | 1×     | 0          |
| CFRV   | 100     | 100   | 0     | 1×     | 0          |
| PSA    | 100     | 100   | 0     | 2×     | 0          |
| ECR    | 0       | 100   | +100  | 1×     | +100       |
| TOTAL  | 2,554/2,900 | 2,738/2,900 | +184 | 29× | +184 |

Composite: 2,554/2,900 = 88.1% → 2,738/2,900 = 94.4% (+6.3pp)
```

**All 3 hypotheses confirmed. No regressions.**

Largest movers:
1. H5 ECR 0→100 (+100 weighted) — evidence citation closes the evidentiary chain in distil
2. H5 IOT 50→65 (+30 weighted) — explicit round-trip from loaded artifact to proposed changes
3. H6+H7 PPF 80→100 (+40 weighted) — all 5 evolve.md modes now fully assigned
4. H7 PCC 75→81 (+12 weighted) — synthesis cognitive mode filled; 13/16 covered

Remaining gaps for run 3:
- IOT=65 — speciate and new modes use in-session context only; structural ceiling ~75 without explicit prior-artifact re-reads
- PCC=81 — three modes still uncovered: pedagogical explanation, temporal reasoning, negotiation/trade-off
- HTC=90 — structural (inherent to the approval gate design)
- RI=97 — residual: Richness Rubric table duplicated in AGENTS.md + evolve.md (intentional, different purposes)

---

## Novel Patterns — Run 2 — 2026-03-22

### NP3 — Emergent Property Test for New Persona Creation
**Observed in:** H7 spot-check
**Description:** When creating a new persona via evolve.md new mode, the quality test is: "does this design have a property that could not be derived from any single source domain?" If the entire design can be reconstructed from just the taxonomy, or just from existing personas, or just from archetypes — synthesis did not occur and the persona is likely a renamed existing one. The emergent property is the distinguishing mark. Loom's Unique Talent formalises this as an explicit creation-time test.
**Generalises to:** Any workflow that creates new artefacts from multiple existing knowledge sources (new skills, new architectural components, novel system designs from existing parts).
**Seed candidate:** yes

---

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

## Audit — 2026-03-22 (run 3)

**Target:** skills/personas
**Files:** 33 total (2 command, 26 persona, 4 support, 1 research-log)
**Token estimate:** ~17,500 tokens (persona files ~7,100t; command files ~2,450t; support ~1,200t; research-log ~6,750t)

### Pre-run note
`commands/evolve.md` was modified immediately before this run: (1) SQS rubric added to audit mode — a 5-heuristic quality scoring table for soul.md content; (2) soul verification pass added to distil mode — explicit contradiction check, voice calibration, and inert soul content detection. These were motivated by the character-growth conversation, not by optimise. Run 3 baseline reflects the current file state including these changes.

### Feature Inventory
- Multi-phase pipeline: no
- Persona system: yes (13 persona pairs — Loom added in Run 2)
- Subagent invocations: no
- Multi-session orchestration: no
- Parallel execution: no
- Cached artifacts: no

### Files

**Command files:**
- `commands/summon.md` — ~750t
- `commands/evolve.md` — ~2,300t (grew with Run 2 H5/H6/H7 + pre-run SQS/soul-verification additions)

**Persona files (13 pairs):** analytics, strategist, critic, builder, designer, examiner, advocate, scout, scribe, release, documentation, adversarial, synthesis — all persona.md + soul.md present, all mandatory fields confirmed.

**Support files:** SKILL.md (~590t), AGENTS.md (~525t), VERSION.md (~25t), CHANGELOG.md (~250t)

### Persona Staleness Check
- All 13 persona directories exist; both files present in each.
- All 13 summon.md `../{dir}/` entries resolve to existing directories ✓
- evolve.md `../analytics/persona.md` and `../analytics/soul.md` references exist ✓
- No broken references. No speciated children (Rook and Loom have no Origin — correct as originals).

---

## Custom Metrics — 2026-03-22 (run 3)

### MX11 — Soul Quality Score (SQS) [custom]
**Measures:** Whether soul.md content is *good* — specific, non-obvious, observable, predictive, and irreplaceable — not merely present. PRS measures presence; PSA measures soul-behaviour alignment; SQS measures quality.
**Why seeds miss it:** No existing metric asks "could this Essence describe two other personas without modification?" or "does someone reading this Voice section know what register to write in?" A persona can score 100% on PRS and PSA while having generic, inert soul content that fails to change agent behaviour.
**Methodology:** For each soul.md, score 5 heuristics (0/1/2 each):
1. Essence Specificity — could only this persona have this Essence sentence, or could it fit ≥2 others in the library without modification? Unique=2, borderline=1, generic=0.
2. Opinion Non-obviousness — would a thoughtful person who has never read this persona hold these same opinions? Surprising/distinctive=2, mixed=1, obvious=0.
3. Contradiction Observability — could someone reading the Contradictions section predict when the tension would surface in a real response? Observable=2, partially=1, stated-but-invisible=0.
4. Voice Predictability — given a prompt and this Voice description alone, could someone write a recognisable first sentence in this persona's voice? Predictive=2, partial=1, vague=0.
5. Unique Talent Uniqueness — could this Unique Talent sentence be copy-pasted to a different persona in the library without modification? Irreplaceable=2, borderline=1, generic=0.
SQS per persona = points/10. SQS = avg across 13 personas.
**Direction:** ↑ higher is better
**Weight:** 2× — soul quality is central to why personas produce different outputs across sessions
**Normalisation:** SQS × 100

### MX12 — Unique Talent Cross-Library Uniqueness (UTCU) [custom, moonshot]
**Measures:** Whether each Unique Talent description names a cognitive operation that is genuinely distinct from all others at the specific Unique Talent level — not just at the Purpose/DO level (which PDI already measures). Two personas can score well on PDI yet have Unique Talents that describe the same cognitive operation with different vocabulary.
**Why seeds miss it:** PDI measures pairwise uniqueness of Purpose + DO rules. UTCU isolates the one field AGENTS.md marks as the primary differentiator. Borrowed from information-theoretic diversity metrics applied at the field level. If Unique Talents are colliding, the library has redundant depth precisely where it matters most.
**Methodology:** For all 78 pairs of Unique Talent descriptions (13×12÷2): assess whether the core cognitive operation described overlaps. Score per pair: 1.0 (genuinely distinct), 0.5 (adjacent — same broad domain, different operation), 0.0 (duplicative — same operation, different phrasing). UTCU = avg(pair scores). Conceptually: 1 minus average overlap.
**Direction:** ↑ higher is better
**Weight:** 2× — Unique Talent collisions mean the library has redundant depth in its most critical differentiating field
**Normalisation:** UTCU × 100

### MX13 — Schema-Rubric Coverage Alignment (SRCA) [custom]
**Measures:** Whether AGENTS.md's required-fields schema covers all dimensions that evolve.md's audit rubric now measures. If evolve.md's audit scores on dimensions not required by AGENTS.md, new personas can be schema-compliant while scoring poorly on the full audit.
**Why seeds miss it:** SCR checks compliance with AGENTS.md; PRS uses the Richness Rubric; neither checks whether the two instruments are consistent with each other. After Run 3 added the SQS rubric to evolve.md's audit mode, evolve.md now measures 5 quality dimensions not required by AGENTS.md. The normative schema lags the measurement instrument.
**Methodology:** List all dimensions scored in evolve.md's Richness Rubric + SQS rubric (7 + 5 = 12 total). List all required fields in AGENTS.md for soul.md. SRCA = rubric_dimensions_covered_or_noted_in_AGENTS.md / total_rubric_dimensions.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** SRCA × 100

### MX14 — Distil Mode Soul Coverage (DMSC) [custom]
**Measures:** In evolve.md distil mode, what fraction of soul.md sections have an explicit methodology step for detecting whether they need updating.
**Why seeds miss it:** ECR measures whether DO rule changes cite evidence. No metric measures whether the distil soul-sharpening process explicitly covers each of the 6 soul sections (Essence, Core Truths, Opinions, Contradictions, Voice, Unique Talent). A distil run that covers only some sections will systematically miss soul growth opportunities in the uncovered ones.
**Methodology:** List the 6 soul sections. For each, check whether distil mode (post soul-verification-pass) has an explicit step that would detect a need to update that section. Count covered_sections / 6.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** DMSC × 100

### MX15 — Prompting Heuristic Signal Coherence (PHSC) [custom, moonshot]
**Measures:** Whether the 4 prompting heuristics in summon.md produce orthogonal behavioural shifts — each heuristic pushing the persona in a distinct direction with no overlap. Borrowed from signal processing: orthogonal control inputs are more efficient than correlated ones. If two heuristics produce the same shift, one is redundant. If all four are distinct, the user has four genuine degrees of freedom over persona behaviour.
**Why seeds miss it:** No metric measures whether the control surface for persona behaviour is degenerate. ACC would score all four heuristics as concrete; no metric asks whether they're *distinct*.
**Methodology:** For all 6 pairs of prompting heuristics: assess whether the behavioural shift described is distinct (1.0), partially overlapping (0.5), or identical (0.0). PHSC = avg(pair scores).
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** PHSC × 100

---

## Baseline — 2026-03-22 (run 3)

**Persona: Pulse (Analytics)**

Seed metrics applied: IOT(2×), DD(1×), IAR(1×), WCS(1×), RI(1×), ACC(2×), HTC(2×), CLE(2×), ITE(1×), PPF(2×), PRS(1×)
Seed metrics skipped: SAS, CDR, PSS, IFS
Custom metrics: PCC(2×), RSS(1×), SCR(1×), CGDC(1×), PDI(2×), MIC(1×), FPC(1×), CFRV(1×), PSA(2×), ECR(1×), SQS(2×), UTCU(2×), SRCA(1×), DMSC(1×), PHSC(1×)

### Carry-forward scores (unchanged from Run 2 final)
IOT=65, DD=100, IAR=99, WCS=100, RI=97, ACC=94, HTC=90, CLE=95, ITE=96, PPF=100, PRS=100, PCC=81, RSS=100, SCR=100, CGDC=100, PDI=98, MIC=100, FPC=100, CFRV=100, PSA=100, ECR=100.
Note: evolve.md SQS/soul-pass additions add directives (improving DD in principle) but DD was already capped at 100. No existing metric was pushed beyond its current score by the pre-run changes.

### New Metric Measurements

**MX11 SQS — 95:**

Soul Quality Rubric scores per persona (E=Essence, O=Opinions, C=Contradictions, V=Voice, UT=Unique Talent, each 0–2):

| Persona | E | O | C | V | UT | Total |
|---------|---|---|---|---|----|-------|
| Pulse   | 2 | 2 | 2 | 2 | 2  | 10    |
| Keeper  | 1 | 1 | 2 | 2 | 2  | 8     |
| Arden   | 1 | 2 | 2 | 2 | 2  | 9     |
| Kira    | 2 | 2 | 2 | 2 | 2  | 10    |
| Echo    | 1 | 2 | 2 | 2 | 2  | 9     |
| Vale    | 2 | 2 | 2 | 2 | 2  | 10    |
| Vela    | 2 | 2 | 2 | 2 | 2  | 10    |
| Helm    | 2 | 2 | 2 | 2 | 2  | 10    |
| Ward    | 2 | 2 | 2 | 1 | 2  | 9     |
| Rook    | 2 | 2 | 2 | 2 | 2  | 10    |
| Finn    | 1 | 2 | 2 | 2 | 2  | 9     |
| Loom    | 2 | 2 | 2 | 2 | 2  | 10    |
| Artisan | 2 | 2 | 1 | 2 | 2  | 9     |

Sum: 123/130. SQS = 123/130 = 94.6% → **95**.

Scoring rationale for the 7 non-max fields:
- Keeper Essence (1): "Asks the question that exposes whether we're solving the right problem" could describe any strategist or consultant archetype. The persona's distinctive quality (one round of reframing, then commit; the specific discomfort of slowing work he wants to succeed) is not in the Essence.
- Keeper Opinions (1): "Most planning failures are framing failures" and "whether to build it at all" are near-conventional strategic wisdom; not surprising to a thoughtful reader who has never met Keeper.
- Arden Essence (1): "Finds what's wrong so it can be fixed before it hurts someone" could describe a security auditor, QA tester, or editor. Arden's specific gift (compensating regressions, the faint disappointment at easy passes) is absent.
- Echo Essence (1): "Maps where the evidence is — or records that it isn't" is close but borderline; could describe a researcher or fact-checker. Echo's test-inference superpower and "the verdict is Arden's job" discipline are the real differentiators.
- Finn Essence (1): "Goes in first so everyone else knows what they're walking into" is the archetype of a scout. The cartography metaphor and load-bearing-path identification are absent.
- Ward Voice (1): The Voice describes her style but doesn't give a predictable first sentence. "Notes what it was and why it changed" is style guidance; the reader knows the *content type* but not the *register*.
- Artisan Contradictions (1): "Occasionally catches herself preferring something that violates a principle she holds. Names it." — the tension is real but the observability is low; this contradiction would only surface if Artisan explicitly names the principle conflict in output, which the Contradictions section doesn't make inevitable.

**MX12 UTCU — 99:**

All 78 pairs of Unique Talent descriptions assessed. Adjacent pairs (0.5): Pulse/Arden — both detect unexpected negative consequences of changes (Pulse: measurement artefacts; Arden: compensating regressions). Same broad domain, different operations. 1 pair × 0.5 = 0.5 overlap across 78 pairs. UTCU = 1 − (0.5/78) = 77.5/78 = 99.4% → **99**.

**MX13 SRCA — 58:**

evolve.md audit now measures 12 total dimensions: 7 Richness Rubric (soul-side: present, Essence, Core Truths, Opinions, Contradictions, Voice, Unique Talent) + 5 SQS quality dimensions. AGENTS.md schema covers the 7 Richness fields with presence requirements. AGENTS.md does not define scoring criteria for Essence Specificity, Opinion Non-obviousness, Contradiction Observability, Voice Predictability, or Unique Talent Uniqueness — though it notes "Specific, not generic" for Unique Talent (half credit: implicit quality note). SRCA = 7.5/13 × 100 (counting the implicit UT quality note as 0.5) ≈ 58%. Conservatively: 7/12 = 58% → **SRCA = 58**.

**MX14 DMSC — 67:**

6 soul sections. Post soul-verification-pass coverage:
- Core Truths: covered by inert soul content step ✓
- Opinions: covered by inert soul content step ✓
- Contradictions: covered by contradiction check ✓
- Voice: covered by voice calibration ✓
- Essence: no explicit step ✗
- Unique Talent: no explicit step (Deepen bullet says "soul field" generically but doesn't name Unique Talent) ✗

DMSC = 4/6 = 66.7% → **67**.

**MX15 PHSC — 83:**

4 heuristics → 6 pairs:
- "take your time" / "be comprehensive": depth vs. full coverage — related but distinct (slow+deep ≠ complete+broad). Score: 1.0
- "take your time" / "what would you flag?": depth vs. focus-shift to critique. Distinct dimensions. Score: 1.0
- "take your time" / "what's your honest take?": depth vs. character mode. Distinct. Score: 1.0
- "be comprehensive" / "what would you flag?": full coverage vs. critical focus. Distinct. Score: 1.0
- "be comprehensive" / "what's your honest take?": both broaden the response, but structural (comprehensive) vs. characterological (honest). Partially overlapping — both produce "more output." Score: 0.5
- "what would you flag?" / "what's your honest take?": both shift toward an unfiltered/critical stance. "Flag" = surface concerns held back; "honest take" = surface opinions/contradictions. Most overlapping pair. Score: 0.5

PHSC = (1.0+1.0+1.0+1.0+0.5+0.5)/6 = 5.0/6 = 83.3% → **83**.

### Composite Calculation

```
Seed metrics applied: IOT(2×), DD(1×), IAR(1×), WCS(1×), RI(1×), ACC(2×), HTC(2×), CLE(2×), ITE(1×), PPF(2×), PRS(1×)
Seed metrics skipped: SAS, CDR, PSS, IFS
Custom metrics: PCC(2×), RSS(1×), SCR(1×), CGDC(1×), PDI(2×), MIC(1×), FPC(1×), CFRV(1×), PSA(2×), ECR(1×), SQS(2×), UTCU(2×), SRCA(1×), DMSC(1×), PHSC(1×)

| Metric | Source | Normalised | Weight | Weighted |
|--------|--------|-----------|--------|----------|
| Intent-to-Output Traceability | seed | 65 | 2× | 130 |
| Directive Density | seed | 100 | 1× | 100 |
| Instruction Ambiguity Rate | seed | 99 | 1× | 99 |
| Wiring Completeness Score | seed | 100 | 1× | 100 |
| Redundancy Index | seed | 97 | 1× | 97 |
| AC Concreteness | seed | 94 | 2× | 188 |
| Human Touchpoint Count | seed | 90 | 2× | 180 |
| Context Loading Efficiency | seed | 95 | 2× | 190 |
| Instruction Token Efficiency | seed | 96 | 1× | 96 |
| Persona-Phase Fit Score | seed | 100 | 2× | 200 |
| Persona Richness Score | seed | 100 | 1× | 100 |
| Persona Coverage Completeness | custom R1 | 81 | 2× | 162 |
| Roster Synchronisation Score | custom R1 | 100 | 1× | 100 |
| Schema Compliance Rate | custom R1 | 100 | 1× | 100 |
| Cognitive Gap Documentation Currency | custom R1 | 100 | 1× | 100 |
| Persona Differentiation Index | custom R1 | 98 | 2× | 196 |
| Mode Invocation Completeness | custom R2 | 100 | 1× | 100 |
| Fallback Path Coverage | custom R2 | 100 | 1× | 100 |
| Cross-File Reference Validity | custom R2 | 100 | 1× | 100 |
| Persona-Soul Alignment | custom R2 | 100 | 2× | 200 |
| Evidence Citation Rate | custom R2 | 100 | 1× | 100 |
| Soul Quality Score | custom R3 | 95 | 2× | 190 |
| Unique Talent Cross-Library Uniqueness | custom R3 | 99 | 2× | 198 |
| Schema-Rubric Coverage Alignment | custom R3 | 58 | 1× | 58 |
| Distil Mode Soul Coverage | custom R3 | 67 | 1× | 67 |
| Prompting Heuristic Signal Coherence | custom R3 | 83 | 1× | 83 |
| TOTAL | | | 36× | 3,334 / 3,600 |

Composite: 3,334 / (36 × 100) × 100 = 92.6%
```

**Opening Composite: 92.6%**

**Weakest 5:** SRCA (58), DMSC (67), IOT (65), PHSC (83), PCC (81)
**Strongest:** DD, WCS, RSS, SCR, CGDC, MIC, FPC, CFRV, PSA, ECR, PPF, PRS — all 100; UTCU=99

---

## Experiments — 2026-03-22 (run 3)

**Persona: Keeper (Strategist)**

**Pre-experiment dependency scan:** H8 modifies AGENTS.md. H9 modifies evolve.md (distil mode soul-pass section). H10 modifies 6 soul.md files (Keeper, Arden, Echo, Finn, Ward, Artisan). H11 creates new directory files and modifies evolve.md (taxonomy + new mode), SKILL.md, summon.md. **Overlap: H9 and H11 both modify evolve.md — these must run sequentially with a metric re-check between them.** All other pairs are file-independent and may run in any order.

### H8 — Sync AGENTS.md schema with SQS quality criteria
**Problem observed:** Schema-Rubric Coverage Alignment (MX13) = 58. evolve.md's audit mode now measures 12 dimensions (7 Richness Rubric + 5 SQS quality). AGENTS.md's required-fields schema covers the 7 Richness fields but does not define quality criteria for Essence Specificity, Opinion Non-obviousness, Contradiction Observability, Voice Predictability, or Unique Talent Uniqueness. A persona built to AGENTS.md spec can be schema-compliant while scoring 0/2 on 4 of the 5 SQS heuristics. The normative schema and the measurement instrument have diverged.
**Change proposed:** Add quality guidance notes to the AGENTS.md soul.md required fields table for the 4 sections where SQS scoring is likely to be non-obvious: Essence (must be distinguishable from any other persona in the library without the header), Contradictions (must name a tension observable in output, not merely a personality note), Voice (must enable someone to write a recognisable first sentence), Unique Talent (existing "specific, not generic" note already present — expand with the "copy-paste test": if this could be transplanted to a different persona without modification, it is not unique enough).
**Targets:** Schema-Rubric Coverage Alignment (MX13) ↑
**Predicted improvement:** SRCA 58→83 (+25pp ×1× = +25 weighted). Adding quality notes for 4 of the 5 SQS dimensions brings coverage from 7/12 to ~10/12 (Unique Talent note expands, Essence/Contradictions/Voice notes added; Opinion Non-obviousness left implicit). Composite delta ~+0.7pp.
**Pattern applied:** P12 — Content Synchronisation Audit (update the normative schema to match the current measurement rubric)
**Risk level:** low
**Risk note:** AGENTS.md is the reference document for persona creation — adding quality notes may make the schema feel heavier for new persona authors. Mitigation: notes should be brief and criterion-based (one sentence each), not prescriptive about content. Quality bar: the added notes must enable a new persona author to self-assess whether their soul content would score ≥1 on each SQS dimension without access to the full rubric.

---

### H9 — Add Essence and Unique Talent soul sections to distil mode coverage
**Problem observed:** Distil Mode Soul Coverage (MX14) = 67. The distil mode soul verification pass (added pre-run) explicitly covers Contradictions (contradiction check), Voice (voice calibration), and Core Truths + Opinions (inert soul content step). Essence and Unique Talent have no explicit coverage step. A distil run produces sharpen/add/prune candidates for 4 of 6 soul sections; the other 2 are left to the generic Deepen bullet with no specific methodology.
**Change proposed:** Add two explicit checks to the soul verification pass in evolve.md distil mode:
1. **Essence drift check**: "Compare the Essence sentence to how the persona actually presented itself in evidence. Does the evidence reveal a more specific or accurate one-line characterisation — one that would score higher on Essence Specificity (could describe only this persona)? If so, flag as a Deepen candidate with the evidence passage that suggests the revision."
2. **Unique Talent calibration**: "Review the Unique Talent description. Did the persona exercise this talent in the evidence? If yes, note whether the real instance was narrower or broader than described. If no, flag as potentially inert — a Unique Talent that left no trace across multiple uses may be aspirational. Both cases are Deepen candidates."
**Targets:** Distil Mode Soul Coverage (MX14) ↑
**Predicted improvement:** DMSC 67→100 (+33pp ×1× = +33 weighted). All 6 soul sections now have explicit methodology. Composite delta ~+0.9pp.
**Pattern applied:** Novel — targeted soul section methodology extension within an existing pass
**Risk level:** low
**Risk note:** H9 and H11 both modify evolve.md — must run sequentially with a metric re-check between them. The Essence drift check requires the agent to evaluate specificity (an SQS criterion) — this adds light subjectivity to the distil methodology. Mitigation: the criterion is anchored to a concrete test ("could describe only this persona") rather than open-ended.

---

### H10 — Sharpen 7 weak SQS fields across 6 personas
**Problem observed:** Soul Quality Score (MX11) = 95. Seven soul fields score 1 instead of 2 on the SQS rubric across 6 personas: Keeper (Essence=1, Opinions=1), Arden (Essence=1), Echo (Essence=1), Finn (Essence=1), Ward (Voice=1), Artisan (Contradictions=1). The common pattern: four Essences are generic archetypes (the role name provides more information than the Essence sentence), and the remaining three fields are either conventional, partially vague, or insufficiently observable.
**Change proposed:** Targeted soul.md edits for each of the 7 weak fields:
- **Keeper Essence** (1→2): rewrite to name the specific quality that distinguishes Keeper from a generic strategist — the "one round of reframing then commit" discipline and the discomfort of being the person who slows work he wants to succeed.
- **Keeper Opinions** (1→2): replace the conventional strategic insights with more distinctive positions — what does Keeper believe that a thoughtful but generic strategist would not?
- **Arden Essence** (1→2): rewrite to name the compensating-regression detection and the gate metaphor as the specific distinguishing traits, not just "finds what's wrong."
- **Echo Essence** (1→2): rewrite to foreground the strict AC-evidence mapping discipline and the "stay in your lane" self-constraint — the qualities that distinguish Echo from a researcher.
- **Finn Essence** (1→2): rewrite to foreground the load-bearing-path identification and cartographic discipline — not just "goes in first" but the specific value of knowing which paths are safe to change.
- **Ward Voice** (1→2): sharpen to a register that enables a reader to write a recognisable first sentence — add a characteristic phrase or sentence pattern that is distinctively Ward's.
- **Artisan Contradictions** (1→2): rewrite to make the principle-vs-preference tension more observable in output — Artisan should name the violated principle when she makes an exception, making the contradiction predictably surfaceable.
**Targets:** Soul Quality Score (MX11) ↑
**Predicted improvement:** SQS 95→100 (+5pp ×2× = +10 weighted). All 7 weak fields resolved → 130/130. Composite delta ~+0.3pp. Secondary: UTCU may improve if Arden/Arden's Essence change makes the Pulse/Arden Unique Talent pair more distinct, but this is unlikely to affect the UT field directly.
**Pattern applied:** P9 — Persona Speciation (distillation mode: sharpen existing soul fields using SQS evidence)
**Risk level:** medium
**Risk note:** These edits are made without run-log evidence — they are motivated by SQS scoring assessment rather than observed behaviour divergence. Quality bar: each rewritten field must score 2 on its SQS heuristic as assessed after the edit. Revised Essences must not overlap with any other persona's Essence at ≥50% semantic similarity. Risk of homogenisation: sharpening all Essences in the same session may push them toward the same style. Mitigation: each revision should draw on the specific evidence from within that persona's own files, not from a general template.

---

---

## Experiment Results — 2026-03-22 (run 3)

**Persona: Arden (Critic)**

### H8 — Sync AGENTS.md schema with SQS quality criteria
**Status:** Confirmed
**Pre-change:** SRCA=58 (7/12 rubric dimensions covered in schema)
**Post-change:** SRCA=92 (11/12 — Essence Specificity, Contradiction Observability, Voice Predictability, Unique Talent Uniqueness all now noted; Opinion Non-obviousness left implicit)
**Delta:** SRCA +34pp (×1×=+34 weighted pts)
**Files changed:** 1 (AGENTS.md — soul.md required fields table: 4 fields gained quality notes)
**Notes:** Exceeded predicted +25pp. Adding quality notes for 4 of 5 SQS dimensions brought coverage from 7/12 to 11/12. The existing Unique Talent note ("Specific, not generic") was expanded with an explicit copy-paste self-test. Opinion Non-obviousness is the one SQS dimension not yet in AGENTS.md schema — left implicit rather than forced; Opinions are the most subjective of the five heuristics and a schema note risks over-prescribing tone.

### H9 — Add Essence and Unique Talent coverage to distil soul pass
**Status:** Confirmed
**Pre-change:** DMSC=67 (4/6 soul sections covered)
**Post-change:** DMSC=100 (6/6 — Essence drift + Unique Talent calibration added)
**Delta:** DMSC +33pp (×1×=+33 weighted pts)
**Files changed:** 1 (evolve.md — soul verification pass, 2 new bullet points)
**Notes:** No secondary regressions. IAR unchanged (new steps use imperatives without unscoped weak modals). IOT unchanged (distil mode was already in the numerator; additional steps within the same phase don't change the phase-level count). The Essence drift step introduces the SQS "could describe only this persona" criterion directly into the distil workflow — closing the loop between the audit rubric and the evolutionary mechanism.

### H10 — Sharpen 7 weak SQS soul fields across 6 personas
**Status:** Confirmed
**Pre-change:** SQS=95 (123/130; 7 fields at 1/2)
**Post-change:** SQS=100 (130/130; all 13 personas score 10/10)
**Delta:** SQS +5pp (×2×=+10 weighted pts)
**Files changed:** 6 (strategist/soul.md, critic/soul.md, examiner/soul.md, scout/soul.md, documentation/soul.md, designer/soul.md)
**Quality check — overlap test:** Four rewritten Essences (Keeper, Arden, Echo, Finn) — none overlap ≥50% with any other Essence in the library. Each names a specific cognitive operation absent from similar archetype descriptions. ✓
**Quality check — PSA:** All 6 revised soul files maintain alignment between soul content and DO rules. No soul-behaviour contradictions introduced. ✓

### H11 — Create Arc (Sequencer) + Temporal Reasoning gap fill [persona experiment]
**Status:** Confirmed
**Pre-change:** PCC=81 (13/16 cognitive modes covered)
**Post-change:** PCC=88 (14/16)
**Delta:** PCC +7pp (×2×=+14 weighted pts)
**Files created:** 2 (temporal/persona.md, temporal/soul.md — all mandatory fields present: Purpose, DO ×5, DO NOT ×5, When to summon, Failure Mode; Essence, Core Truths ×3, Opinions ×3, Contradictions ×3, Voice, Unique Talent)
**Files updated:** 4 (SKILL.md roster, summon.md roster, evolve.md taxonomy, CHANGELOG.md)
**Spot-check task:** Arc applied to a scenario: "We have four tickets — schema migration, code update, data backfill, and end-to-end test. Team says they can be done in any order. Validate this."
**Spot-check output:** Arc's response named the dependency chain as state transitions: "The schema migration produces the schema state that the code update consumes. The data backfill requires the schema to exist. The E2E test requires the backfill to be complete to pass. Three of the four have essential dependencies; only if the code update does not touch the backfill path could it run before the backfill — check whether that's true. 'Any order' is a conventional assumption here, not a validated one."
**Marker scores:** [pass / pass / pass]
**Spot-check score:** 3/3
**Differentiation check:** Arc–Finn pair assessed — Arc's Unique Talent (temporal work sequencing) does not overlap with Finn's (spatial code coupling). Arc–Keeper pair assessed — Arc identifies what must happen before what; Keeper asks whether we're solving the right problem. Both pairs scored 0.0 (well-differentiated). PDI unchanged at 98.

---

## Final Results — Run 3 — 2026-03-22

```
| Metric | Opening | Final | Delta | Weight | Weighted Δ |
|--------|---------|-------|-------|--------|------------|
| IOT    | 65      | 65    | 0     | 2×     | 0          |
| DD     | 100     | 100   | 0     | 1×     | 0          |
| IAR    | 99      | 99    | 0     | 1×     | 0          |
| WCS    | 100     | 100   | 0     | 1×     | 0          |
| RI     | 97      | 97    | 0     | 1×     | 0          |
| ACC    | 94      | 94    | 0     | 2×     | 0          |
| HTC    | 90      | 90    | 0     | 2×     | 0          |
| CLE    | 95      | 95    | 0     | 2×     | 0          |
| ITE    | 96      | 96    | 0     | 1×     | 0          |
| PPF    | 100     | 100   | 0     | 2×     | 0          |
| PRS    | 100     | 100   | 0     | 1×     | 0          |
| PCC    | 81      | 88    | +7    | 2×     | +14        |
| RSS    | 100     | 100   | 0     | 1×     | 0          |
| SCR    | 100     | 100   | 0     | 1×     | 0          |
| CGDC   | 100     | 100   | 0     | 1×     | 0          |
| PDI    | 98      | 98    | 0     | 2×     | 0          |
| MIC    | 100     | 100   | 0     | 1×     | 0          |
| FPC    | 100     | 100   | 0     | 1×     | 0          |
| CFRV   | 100     | 100   | 0     | 1×     | 0          |
| PSA    | 100     | 100   | 0     | 2×     | 0          |
| ECR    | 100     | 100   | 0     | 1×     | 0          |
| SQS    | 95      | 100   | +5    | 2×     | +10        |
| UTCU   | 99      | 99    | 0     | 2×     | 0          |
| SRCA   | 58      | 92    | +34   | 1×     | +34        |
| DMSC   | 67      | 100   | +33   | 1×     | +33        |
| PHSC   | 83      | 83    | 0     | 1×     | 0          |
| TOTAL  | 3,334/3,600 | 3,425/3,600 | +91 | 36× | +91 |

Composite: 3,334/3,600 = 92.6% → 3,425/3,600 = 95.1% (+2.5pp)
```

**All 4 hypotheses confirmed. No regressions.**

Largest movers:
1. H8 SRCA 58→92 (+34 weighted) — schema-rubric gap closed; new personas will be authored against quality criteria, not just presence criteria
2. H9 DMSC 67→100 (+33 weighted) — distil now covers all 6 soul sections; character growth mechanism is complete
3. H11 PCC 81→88 (+14 weighted) — temporal reasoning gap filled with Arc (Sequencer)
4. H10 SQS 95→100 (+10 weighted) — all 13 personas now score 10/10 on soul quality

Remaining gaps for run 4+:
- IOT=65 — structural; speciate/new modes use in-session context; ceiling ~75 without explicit prior-artifact re-reads between modes
- PCC=88 — 2 modes still uncovered: pedagogical explanation, negotiation/trade-off
- HTC=90 — structural (inherent to the approval gate design)
- PHSC=83 — 2 prompting heuristic pairs partially overlapping; fixable with description sharpening (deferred as low-impact in run 3)
- RI=97 — residual: Richness Rubric table duplicated in AGENTS.md + evolve.md (intentional, different purposes)

---

## Novel Patterns — Run 3 — 2026-03-22

### NP4 — Essential vs. Conventional Ordering Test
**Observed in:** H11 design (Arc's Unique Talent) + spot-check validation
**Description:** When sequencing work items, the critical distinction is whether a stated ordering is *essential* (the downstream item cannot run because the upstream item hasn't produced what it needs yet) or *conventional* (the team has always done it in this order, but the constraint is habitual, not structural). Treating convention as constraint serialises parallelisable work; treating constraint as convention produces blockers mid-flight. The test: "what state does the earlier item produce that the later one consumes? if nothing, the dependency is conventional." Arc makes this test explicit and applies it before accepting any stated sequence.
**Generalises to:** Any workflow that involves ticket sequencing, deployment ordering, migration planning, or multi-step refactoring where the order of work items is assumed rather than derived.
**Seed candidate:** yes

---

### H11 — Create Temporal Reasoning persona for unmet cognitive gap [persona experiment]
**Problem observed:** Persona Coverage Completeness (MX1) = 81. Three cognitive modes remain unoccupied: pedagogical explanation, temporal reasoning, and negotiation/trade-off. Temporal reasoning has the highest practical value for agentic coding workflows — it is invoked whenever tickets have dependencies, releases have sequencing constraints, or refactors must be ordered to avoid breaking intermediate states. No existing persona specialises in "what must happen before what, and why does order matter here?" Keeper addresses strategic framing; Finn maps load-bearing paths; neither is optimised for dependency-chain reasoning, timeline modelling, or sequencing under constraint.
**Phase targeted:** No phase currently assigned — this is a library gap-fill, not a phase reassignment
**Change type:** gap-fill (new archetype via `evolve new`)
**Change proposed:** Run `evolve.md new` mode with Loom's synthesis lens to create a persona for temporal reasoning: dependency sequencing, scheduling constraints, and sequencing failures (the class of bugs where the right code runs in the wrong order). Name should avoid literal time/calendar vocabulary; archetypes or natural phenomena that embody sequence are preferred. Add to SKILL.md, summon.md, evolve.md taxonomy. Bump version.
**Quality markers:**
  1. Does the new persona's Unique Talent describe a cognitive operation distinct from Finn's load-bearing-path identification (spatial/structural) and Keeper's strategic reframing (framing/priority)?
  2. Does the Failure Mode name the specific way this persona's strength becomes a liability — over-sequencing as a pattern (treating everything as strictly ordered when parallelism was safe)?
  3. Does the soul.md Essence sentence distinguish this persona from a project manager archetype — naming what is cognitively distinctive about dependency reasoning rather than just "plans the sequence"?
**Targets:** Persona Coverage Completeness (MX1) ↑, Roster Synchronisation Score (MX2) ↑ (after all three rosters updated), Cognitive Gap Documentation Currency (MX4) ↑ (after taxonomy updated)
**Predicted improvement:** PCC 81→88 (+7pp ×2× = +14 weighted). Composite delta ~+0.4pp from PCC. Secondary: PPF may benefit in future workflows that assign the new persona to sequencing phases.
**Pattern applied:** P9 — Persona Speciation (new archetype for unmet cognitive demand)
**Risk level:** medium
**Risk note:** Creating a persona without run-log evidence means Unique Talent and Failure Mode are inferred from first principles. Differentiation bar is high: must distinguish clearly from Finn (spatial/structural) and Keeper (framing). If the new persona's Purpose could be substituted for Finn's or Keeper's with minor rewording, PDI will decline slightly. Run the PDI spot-check: score the new persona against both Finn and Keeper before committing.

---
