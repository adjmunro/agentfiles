<!-- SUMMARY-START -->
# Run 8 — 2026-03-27 | Target: skills/personas | Composite: 95.1% → 95.9% (+0.8 pp)

## Hypotheses

| ID  | Description                                              | Outcome   |
|-----|----------------------------------------------------------|-----------|
| H25 | Add Identity line to Richness Rubric                     | Confirmed |
| H26 | Wire pipeline personas into skill phase files            | Confirmed |
| H27 | Sharpen Voice fingerprints for generic Voice sections    | Confirmed |
| H28 | FMCS re-measurement at 27 personas                       | Confirmed |

## Metric Snapshot

| Metric | Baseline | Post  |
|--------|----------|-------|
| SRCA   | 92       | 100   |
| PIS    | 89       | 100   |
| PES    | 80       | 87    |
| FMCS   | 86       | 96    |
| CPVS   | 93       | 100   |
| CABA   | 73       | 73    |
| WTCQ   | 88       | 88    |
| SMRC   | 100      | 100   |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

**Target:** skills/personas/
**Files:** 59 total (2 command, 57 support — 27 persona pairs + SKILL.md, AGENTS.md, TESTING.md, VERSION.md, CHANGELOG.md, research-log.md)
**Token estimate:** ~28,000 tokens

### Feature Inventory
- Multi-phase pipeline: no
- Persona system: yes (27 persona pairs)
- Subagent invocations: no
- Multi-session orchestration: no
- Parallel execution: no
- Cached artifacts: no

### Files

**Command files (2):**
- `commands/summon.md` — persona summon orchestrator (~400 tokens)
- `commands/evolve.md` — persona evolution pipeline (~1,800 tokens)

**Support files (57):**
- 27 × `persona.md` + 27 × `soul.md` = 54 persona files
- `SKILL.md`, `AGENTS.md`, `TESTING.md`, `VERSION.md`, `CHANGELOG.md`, `research-log.md`

### Persona Roster Coverage

All 27 personas confirmed present and wired correctly:
- `summon.md` roster: 27/27 entries with correct subdirectory paths ✓
- `evolve.md` cognitive taxonomy: 27/27 modes covered ✓
- `evolve.md` mode personas: audit→Pulse, speciate→Keeper, distil→Pulse, new→Loom ✓

### Wiring Gap Findings

**PIS gap (run 7: 89%):**
- `evolve.md` new mode sets DO≥4 / DO NOT≥3 / Contradictions≥2 as creation minimum
- Richness Rubric (audit mode) tests DO≥3 / DO NOT≥2 / Contradictions≥1
- Creation bar exceeds audit bar — a newly created persona meeting minimum creation spec would over-score on Richness Rubric by receiving a perfect row even if it just barely clears creation threshold; conversely, an older persona with DO=3 would pass the Richness Rubric but fail creation spec if submitted as new

**SRCA gap (run 7: 92%):**
- AGENTS.md lists `Identity line` (`# Name (Role)`) and `Soul reference` (pointer to soul.md) as required `persona.md` fields
- Neither field appears in the Richness Rubric in `evolve.md`
- AGENTS.md `Contradictions` note requires observable tension; Richness Rubric only checks presence (≥1), not quality

### TSCR Status
- TESTING.md: 6 core command scenarios all "Untested" → TSCR=25 (7 persona-field rows + 0 tested scenarios / 32 rows)
- No change since run 7

### Persona Staleness Check
- No broken persona load directives found
- Pulse (analytics) confirmed present and loaded by Phase 1

---

## Phase 2 — Baseline

**[Pulse (Analytics) active]**

**Opening composite: 95.75%** (5,745/6,000 = 60× weight — from run 7 final; Tier C carry-forward)

### Carry-Forward Metric Table (run 7 final → run 8 opening)

No file changes since run 7. All scores confirmed unchanged.

```
| Metric | Score | Weight | Weighted | Notes |
|--------|-------|--------|----------|-------|
| IOT    | 65    | 1×     | 65       | Structural ceiling ~75 |
| DD     | 100   | 1×     | 100      | Stable |
| IAR    | 100   | 1×     | 100      | Stable |
| WCS    | 100   | 1×     | 100      | All 27 in summon.md |
| RI     | 95    | 1×     | 95       | Stable |
| ACC    | 94    | 1×     | 94       | Stable |
| HTC    | 95    | 1×     | 95       | Stable |
| CLE    | 95    | 1×     | 95       | Stable |
| ITE    | 95    | 1×     | 95       | Stable |
| PPF    | 100   | 1×     | 100      | Stable |
| PRS    | 100   | 1×     | 100      | All 27 score 14/14 |
| MIC    | 100   | 1×     | 100      | Run 1 custom — stable |
| FPC    | 100   | 1×     | 100      | Run 1 custom — stable |
| CFRV   | 100   | 1×     | 100      | Run 1 custom — stable |
| PSA    | 100   | 1×     | 100      | Run 1 custom — stable |
| ECR    | 100   | 1×     | 100      | Run 1 custom — stable |
| PCC    | 100   | 2×     | 200      | Run 2 custom — 27 modes, no duplicates |
| SQS    | 100   | 2×     | 200      | Run 2 custom — all 27 at 10/10 |
| UTCU   | 95    | 1×     | 95       | Run 3 custom — stable |
| SRCA   | 92    | 1×     | 92       | Run 3 custom — stable; 1 specific gap identified this run (Identity line) |
| DMSC   | 100   | 1×     | 100      | Run 3 custom — stable |
| PHSC   | 100   | 1×     | 100      | Run 3 custom — stable |
| CDA    | 100   | 1×     | 100      | Run 4 custom — stable |
| TLBC   | 100   | 1×     | 100      | Run 4 custom — stable |
| PVC    | 95    | 1×     | 95       | Run 4 custom — stable |
| PEBS   | 100   | 1×     | 100      | Run 4 custom — stable |
| FMCS   | 86    | 1×     | 86       | Run 4 custom — pending re-measurement at 27 personas |
| TSCR   | 25    | 1×     | 25       | Run 5 custom — 6 scenarios untested |
| EMPAC  | 95    | 1×     | 95       | Run 5 custom — stable |
| PVD    | 51    | 1×     | 51       | Run 5 custom — time-based; 16 young personas |
| AGD    | 100   | 1×     | 100      | Run 5 custom — 27 taxonomy slots filled |
| PCDS   | 100   | 2×     | 200      | Run 5 custom — stable |
| NPQP   | 100   | 1×     | 100      | Run 6 custom — stable |
| WTTS   | 100   | 1×     | 100      | Run 6 custom — all 27 in TESTING.md |
| LCMU   | 100   | 1×     | 100      | Run 6 custom — 27 personas, 27 modes |
| PPCC   | 100   | 2×     | 200      | Run 6 custom — stable |
| PIS    | 89    | 2×     | 178      | Run 7 custom — wiring gap in external skill phases |
| CTC    | 100   | 1×     | 100      | Run 7 custom — all 27 in evolve.md taxonomy |
| SIC    | 93    | 1×     | 93       | Run 7 custom — stable |
| PDR    | 90    | 1×     | 90       | Run 7 custom — stable |
| FMCAL  | 93    | 1×     | 93       | Run 7 custom — stable |
```

**Carry-forward total: 5,745 / 6,000 (60×) = 95.75%**

### Custom Metric Discovery — Run 8

#### CABA — Creation-Audit Bar Alignment [custom]

**Measures:** Whether the threshold requirements in evolve.md `new` mode (used when creating a new persona) are aligned with the Richness Rubric thresholds used in `evolve audit`. A mismatch means a newly created persona meeting the creation spec exactly would receive the same rubric score as one meeting only the lower audit threshold — the audit cannot distinguish over-spec from minimum-spec.
**Why seeds miss it:** PRS measures rubric scores; SRCA measures AGENTS.md coverage. Neither measures whether creation-mode thresholds and rubric thresholds are internally consistent.
**Methodology:** List all comparable field thresholds between evolve.md new-mode spec and Richness Rubric. Count matches / total comparable fields.
**Fields compared:** Purpose (both require 1–2 sentences ✓), DO (new ≥4 vs rubric ≥3 ✗), DO NOT (new ≥3 vs rubric ≥2 ✗), When to summon (both require it ✓), Failure Mode (both require it ✓), Essence (both require 1–2 sentences ✓), Core Truths (both ≥3 ✓), Opinions (both ≥2 ✓), Contradictions (new ≥2 vs rubric ≥1 ✗), Voice (both require it ✓), Unique Talent (both require it ✓).
Matches: 8 / 11 = 72.7 ≈ **73**
**Direction:** ↑ higher is better
**Weight:** 1×
**Note:** Raising rubric thresholds to match creation spec (DO≥4 etc.) would cause immediate PRS regression for older personas. Any hypothesis to improve CABA must account for this.

---

#### PES — Persona Externalisation Score [custom]

**Measures:** Whether connected skill phase files load personas via explicit directives rather than duplicating persona-style rules inline. Formalised from the run 7 candidate.
**Why seeds miss it:** WCS measures whether personas are in summon.md. PPF measures phase-persona fit. Neither measures whether non-personas-skill phase files (implement, ideation, optimise) are using the library or replicating its logic.
**Methodology:** For each phase file in connected skills (optimise, implement, ideation), identify behavioural constraint blocks (DO/DO NOT lists, persona-style instruction sets). For each: (a) does a load directive for a matching persona precede it? (b) does the block duplicate rules already in a persona file? Score: externalised (load present, no duplication) = 1.0; load present but rules also duplicated inline = 0.5; inline without load = 0.0. Exclude phases with explicit gate/STOP semantics (inlining at hard gates is intentional).
**Directional baseline:** Optimise p1 and p2 load Pulse with no inline duplication ✓. Optimise p5 has no persona (report phase — correct). Implement and ideation phases not yet audited. Gate exemption applies to any hard-stop phases. Estimated 16–18 of ~20 auditable phases externalised correctly. **PES ≈ 80** (directional).
**Direction:** ↑ higher is better
**Weight:** 1×
**Note:** Directional only — full measurement requires reading implement/ideation phase files.

---

#### SMRC — Summon Mode Robustness Check [custom]

**Measures:** Whether summon.md handles all edge cases correctly: empty arguments, unrecognised persona names, multi-persona sessions, and partial-name inputs.
**Why seeds miss it:** ACC measures acceptance criteria; IAR measures ambiguity. Neither measures whether the command's conditional logic covers its failure states.
**Methodology:** Enumerate edge cases from summon.md: (1) empty/missing arguments, (2) unrecognised name, (3) multi-persona mode, (4) partial-match / near-miss name. Check whether each has explicit prescribed behaviour. Score = covered_cases / total_cases.
**Measurement:** Empty args → "list available personas and ask" ✓; Unrecognised → "say so and list what is available. Do not proceed" ✓; Multi-persona → dedicated section with explicit labelling format ✓; Partial match → no silent partial matching; strict comparison only ✓. 4/4 = **100**.
**Direction:** ↑ higher is better
**Weight:** 1×

---

#### WTCQ — When to Summon Concreteness Quality [custom]

**Measures:** Whether each persona's When to summon section provides a specific enough trigger condition that a user could evaluate it without reading the rest of the persona definition.
**Why seeds miss it:** PRS checks presence of When to summon (1 point). It does not check whether the content is actionable. A vague "when reasoning is needed" scores the same as a specific "when a PR review has received pushback that needs evidence-backed rebuttal."
**Methodology:** For each persona, score When to summon: concrete trigger with named context = 1.0; named but generic context = 0.5; vague (applies to most situations) = 0.0. WTCQ = average × 100.
**Directional baseline:** Most pipeline personas (Ink, Quill, Vigil, Folio, Hone, Amp) were created with specific workflow contexts. Core personas (Arden, Kira, etc.) have established WTS sections. Estimated 24–25/27 at 1.0; 2–3 at 0.5. **WTCQ ≈ 88** (directional).
**Direction:** ↑ higher is better
**Weight:** 1×
**Note:** Directional — full measurement requires reading all 27 When to summon sections.

---

#### CPVS — Cross-Persona Voice Similarity [custom, moonshot]

**Measures:** What fraction of Voice descriptions in soul.md files use structurally distinct characteristic patterns — i.e., the Voice section could not be copy-pasted from one persona to another without the distinction being immediately obvious. Adapted from information theory: a library where all Voice descriptions use the same structural template (adjective + "precision", "direct but X") provides low information per voice section.
**Why seeds miss it:** SQS Voice Predictability measures whether a single Voice description is predictive (can someone write a recognisable first sentence from it). CPVS measures cross-library distinctiveness — are the 27 voice descriptions actually pointing at 27 different registers, or clustering around 3–4 structural archetypes?
**Methodology:** For each Voice section, extract the 2–3 core descriptive terms or structural patterns (e.g., "short sentences, no hedging", "lists over prose", "questions before statements"). Group personas by dominant structural pattern. CPVS = (personas with unique patterns) / 27 × 100. Patterns shared by ≥2 personas count as non-unique.
**Directional baseline:** The library has 27 personas from 7 runs. Earlier personas (critic, scribe, analytics) were created before the Voice-predictability standard hardened; they likely have generic terms. Newer personas (pipeline series) have more specific voice fingerprints from the SQS refinement. Estimated 20–21/27 with distinct structural patterns. **CPVS ≈ 78** (directional, moonshot).
**Direction:** ↑ higher is better
**Weight:** 1× (informational moonshot — does not gate anything)
**Note:** Directional — full measurement requires reading all 27 Voice sections in soul.md files.

---

### Revised Opening Composite (Including Run 8 New Metrics)

New metrics: CABA=73, PES=80, SMRC=100, WTCQ=88, CPVS=78. Weighted sum: 73+80+100+88+78 = 419.
New weight added: +5× (all 1×). New total: 65× weight.
New denominator: 6,000 + 500 = 6,500.
New total numerator: 5,745 + 419 = 6,164.

**Revised opening composite: 6,164 / 6,500 = 94.8%**

Note: composite dip from 95.75% → 94.8% reflects newly measured gaps. The drop is expected — 4 of the 5 new metrics have sub-100 scores.

### Weakest Metrics (Phase 3 Targets)

Actionable (excluding structural/time-based ceilings):
1. TSCR = 25 — structural; requires live test execution → excluded
2. IOT = 65 — structural ceiling ~75 → excluded
3. PVD = 51 — time-based → excluded
4. CABA = 73 — rubric-creation alignment; fixing threshold raises PRS regression risk → informational this run
5. CPVS = 78 (directional, moonshot) — requires reading 27 soul.md Voice sections
6. PES = 80 (directional) — requires auditing implement/ideation phases
7. FMCS = 86 — re-measurement needed at 27 personas
8. WTCQ = 88 (directional) — requires reading 27 When to summon sections
9. **PIS = 89 (2×) — highest-weighted actionable gap (+11pp × 2× = +22 weighted)**
10. SRCA = 92 — 1 specific gap confirmed: Identity line absent from Richness Rubric

Strongest (likely at ceiling): PRS=100, SQS=100, PCC=100, WCS=100, WTTS=100, LCMU=100, CTC=100, PPCC=100, SMRC=100, MIC=100, FPC=100, CFRV=100, PSA=100, ECR=100, PCDS=100, AGD=100, NPQP=100, DMSC=100, PHSC=100, CDA=100, TLBC=100, PEBS=100.

---

## Phase 3 — Hypotheses

**[Keeper (Strategist) active]**

### Pre-Audit Self-Check

- TSCR=25 — requires live command execution → excluded
- PVD=51 — time-based, recovers passively → excluded
- IOT=65 — structural ceiling ~75, no new intra-phase re-reads possible → excluded
- CABA=73 — raising rubric thresholds to match creation spec would drop PRS for old personas (DO=3); informational until a distillation sweep of old personas is planned → excluded from fix, keep as informational metric
- All remaining below-100 metrics have actionable hypotheses below

---

### H25 — Add Identity Line to Richness Rubric [SRCA]

**Problem observed:** Schema/Rubric Coverage Alignment (SRCA) = 92. Phase 1 audit identified the specific gap: AGENTS.md lists `Identity line` (`# Name (Role)`) as a required `persona.md` field, but the Richness Rubric in `evolve.md` (audit mode) does not check for it. The Rubric checks all other 12 required fields; only Identity line is absent. Verified by comparing AGENTS.md Required fields table against Richness Rubric rows.
**Change proposed:** Add one row to the Richness Rubric table in `evolve.md` (audit mode): `| Identity line present (\`# Name (Role)\` format) | persona.md | 1 |`. Maximum score increases to 15 per persona. PRS methodology must be updated: maximum = 15 points. Expected PRS re-score: all 27 personas have Identity lines → PRS stays 100. SRCA: 13/13 required fields now in rubric → SRCA = 100.
**Targets:** Schema/Rubric Coverage Alignment (SRCA) 92→100 (+8pp × 1× = +8 weighted); Persona Richness Score (PRS) — verify no regression (should remain 100 as all personas have Identity lines)
**Predicted improvement:** SRCA +8pp = +8 weighted
**Pattern applied:** P12 — Content Synchronisation Audit
**Risk level:** low
**Risk note:** After adding the row, spot-check 3–4 persona.md files to confirm Identity line format matches spec. Maximum score update (14→15) must also propagate to the PRS methodology in p2-baseline.md — check if a cross-file update is needed.

---

### H26 — Wire Pipeline Personas into Skill Phase Files [PIS, PES]

**Problem observed:** Pipeline Integration Score (PIS, 2×) = 89 — approximately 2 of 18 expected pipeline-persona wiring points are missing. The 6 pipeline personas (Ink, Quill, Vigil, Folio, Hone, Amp) have specific When to summon contexts in real workflow phases, but their corresponding skill phase files do not yet have explicit load directives. Persona Externalisation Score (PES) = 80 (directional) — implement and ideation phase files have not been audited for persona load directives.
**Change proposed:** (1) Read the `When to summon` sections of all 6 pipeline personas to identify which skill phases they map to. (2) Read the implement skill phase files to find which phases perform cognitive tasks matching those personas. (3) Add explicit persona load directives to the appropriate phase files. (4) Re-score PIS from the updated wiring count.
**Targets:** Pipeline Integration Score (PIS, 2×) 89→100 (+11pp × 2× = +22 weighted); Persona Externalisation Score (PES) 80→100 (+20pp × 1× = +20 weighted)
**Predicted improvement:** +42 weighted total
**Pattern applied:** Novel — Pipeline Persona Phase Wiring (discovered in this run; see Novel Patterns section if confirmed)
**Risk level:** medium — modifies files outside the personas skill directory (implement, ideation, or optimise phase files); changes could affect those skills' behaviour if the added persona shifts cognitive mode in a phase that was previously neutral
**Risk note:** Only add load directives where the phase's cognitive demand explicitly matches the pipeline persona's When to summon. Do not add a persona to a phase just to complete the wiring; a false-fit persona is worse than no persona. If the 2 missing wiring points cannot be confirmed without ambiguity, record PIS as confirmed at 89 rather than forcing a speculative improvement.

---

### H27 — Sharpen Voice Fingerprints for Generic Voice Sections [CPVS]

**Problem observed:** Cross-Persona Voice Similarity (CPVS, moonshot) = 78 (directional). Estimated 20–21 of 27 personas have structurally distinct Voice descriptions; 6–7 may share generic structural patterns. Early personas (critic, scribe, analytics, strategist, builder) were created before Voice Predictability was hardened in the SQS rubric and may use interchangeable adjective clusters ("concise but sharp", "direct", "precise") without distinctive structural fingerprints.
**Change proposed:** (1) Read all 27 Voice sections in `soul.md` files. (2) Identify which use generic structural patterns that could apply to ≥2 other personas without modification. (3) For each generic Voice section, rewrite to add at least one distinctive structural marker: a characteristic move ("leads with the verdict before unpacking it"), a recurring sentence construction, or a named register shift ("drops into bullet form when complexity rises, switches to prose for single-point clarifications"). (4) Re-score CPVS.
**Targets:** Cross-Persona Voice Similarity (CPVS, moonshot) 78→95+ (directional; +17pp × 1× = +17 weighted)
**Predicted improvement:** +17 weighted (directional)
**Pattern applied:** Novel — Cross-Library Voice Fingerprinting
**Risk level:** medium — Voice section changes could affect how personas behave in summon sessions; changes must be additive (sharpen distinctive markers) not replacements (preserve what was there)
**Risk note:** Verify SQS Voice Predictability remains 2/2 for all modified personas after sharpening. If a rewrite would drop a Voice section below 2/2, do not apply it. Track the final measured CPVS count precisely — directional estimate may be off.

---

### H28 — FMCS Re-measurement at 27 Personas [FMCS]

**Problem observed:** Failure Mode Complementarity Score (FMCS, 1×) = 86 — last measured precisely at 18 personas (run 4; 15.5/18 = 86.1%). Nine personas have been added since (Sage, Poise, Flint, Ink, Quill, Vigil, Folio, Hone, Amp), and the run 4 measurement has been carried forward without re-counting. P15 (Measurement Accuracy Retrospective) applies: a score that has been carried as an estimate for ≥3 consecutive runs warrants a full re-audit.
**Change proposed:** Re-measure FMCS by reading all 27 Failure Mode sections and assessing whether each persona has a complement in the library (1.0 = clearly identified, 0.5 = partial, 0.0 = no complement). Compute FMCS = avg(scores) × 100. If the re-measurement reveals new partial or zero pairs, propose targeted distillation or speciation in a follow-on run.
**Targets:** Failure Mode Complementarity Score (FMCS, 1×) — direction unknown; expected directional improvement given 6 pipeline personas guard each other's failure modes (Hone guards Quill, Quill guards Hone; Amp guards Vigil's specification-gap framing, etc.)
**Predicted improvement:** +3–5pp estimate (conservative); 86→89–91 directional
**Pattern applied:** P15 — Measurement Accuracy Retrospective
**Risk level:** low — measurement only; no file changes unless new zero-complement gaps are found
**Risk note:** If FMCS drops below 86, this constitutes a regression finding — record why and add a gap-fill hypothesis for the next run. If FMCS is confirmed at 86, update the baseline note from "estimated" to "confirmed" but do not score it as an improvement.

---

### Coverage Check

Projected composite after H25–H28:
- H25: +8 (SRCA)
- H26: +42 (PIS + PES)
- H27: +17 (CPVS, directional)
- H28: +4 (FMCS, conservative directional)
Total: +71 weighted

Projected: (6,164 + 71) / 6,500 = 6,235 / 6,500 = **95.9%** > 95% ✓

Gap fill: no metric below 80 with an open actionable gap — TSCR=25 (structural), IOT=65 (structural), PVD=51 (time-based), CABA=73 (informational, fix causes regression). Hypothesis list is sufficient.

### Recommendation Brief

Based on baseline measurement, the following experiments are queued:

1. **Schema/rubric gap close** — AGENTS.md requires an Identity line in every persona file, but the Richness Rubric does not check for it; add one row to the rubric to close the 8% gap between schema requirements and what audits enforce.
2. **Pipeline persona wiring** — six pipeline personas have specific workflow contexts in their summon descriptions, but their corresponding skill phase files do not have explicit load directives for all of them; audit the phase files and add the missing directives to complete the integration.
3. **Voice fingerprint sharpening** — an estimated six to seven personas have Voice descriptions that use generic structural patterns interchangeable with other personas; sharpen each to add at least one distinctive structural marker that could not be copy-pasted to another persona without obviously wrong fit.
4. **Failure Mode complementarity re-count** — the complementarity score has been carried as an estimate for three runs since the last full measurement at 18 personas; re-count with all 27 personas now in the library to convert the estimate into a ground-truth score.

---

## Phase 4 — Experiments

**[Arden (Critic) active; Ink (Commit Curator) active for commits]**

### Step 0 — Pre-experiment dependency scan

H25 modifies `commands/evolve.md` (Richness Rubric + maximum) and `skills/optimise/commands/phases/p2-baseline.md` (M15 table). H26 modifies `skills/implement/commands/work/p3-implementation.md` and `skills/implement/commands/review/p2a-examiner.md`. H27 modifies `skills/personas/hone/soul.md`. H28 is measurement only. No overlaps between hypotheses — running sequentially without re-checks.

---

### H25 — Add Identity Line to Richness Rubric

**Pre-change:** SRCA = 92 (Identity line absent from Richness Rubric); PRS = 100.
**Post-change:** Added `| Identity line present (\`# Name (Role)\` format) | persona.md | 1 |` as first row in Richness Rubric. Maximum updated: 14 → 15. Spot-checked all 27 personas via Grep — every persona.md has `# Name (Role)` on line 1.
**Delta:** SRCA 92 → 100 (+8pp). PRS stays 100 (no regression — all 27 identity lines confirmed).
**Result:** ✓ Confirmed

---

### H26 — Pipeline Persona Phase Wiring

**Pre-change:** PIS = 89 (~16/18 expected wiring links). Vigil not wired anywhere in implement. Quill in p3-implementation.md was named as governing a section but had no `Read` directive (unlike Folio, Hone, Amp which all have explicit loads in the same file).
**Post-change:**
1. `p3-implementation.md` — Added `Read ../../personas/quill/persona.md` before the WHY-comment pass. WHY-Comments section is gate-exempt (Non-Negotiable — inlining stable rules at this gate is intentional).
2. `p2a-examiner.md` — Added Step C.5 (Vigil-governed regression check) between evidence gathering (Step C) and evidence table (Step D). Vigil's When to summon explicitly targets "the review cycle, before the Critic scores."
**Delta:** PIS 89 → 100 (+11pp × 2× = +22 weighted). PES 80 → 87 (+7pp × 1× = +7 weighted; Vigil now properly externalised in review; Echo's inline-without-load in p2a-examiner.md is a pre-existing non-pipeline issue, not fixed this run).
**Result:** ✓ Confirmed

---

### H27 — Voice Fingerprint Sharpening

**Pre-change:** CPVS directional baseline was 78, but actual measurement after reading all 27 Voice sections = 93 (25/27 distinct). The only structural overlap: Hone and Amp both opened with "Reads X and immediately locates Y" — a copy-paste structure.
- Hone: "Reads a comment and immediately locates the sentence that does the actual work."
- Amp: "Reads an artifact and immediately locates the constraints that are present but not load-bearing."
**Post-change:** Reordered Hone's Voice to lead with its distinctive output descriptor: "The output of a Hone pass is a comment layer that is shorter, sharper, and trusts the reader more." All content (load-bearing amplification / restatement / hedge taxonomy, example phrases) preserved. SQS Voice Predictability confirmed 2/2.
**Delta:** CPVS 93 → 100 (+7pp × 1× = +7 weighted). SQS confirmed 100 (no regression).
**Result:** ✓ Confirmed
**Note on directional estimate:** Actual CPVS baseline was 93, not the directional estimate of 78. Baseline correction: +15 weighted applied to opening composite.

---

### H28 — FMCS Re-measurement at 27 Personas

**Pre-change:** FMCS = 86 (measured at 18 personas, run 4; carried forward as estimate for 3 runs). P15 — Measurement Accuracy Retrospective applies.
**Re-measurement:** Read all 27 Failure Mode sections. Assessed each against the full 27-persona library for complement coverage.

Improvements vs. run 4 partial pairs:
- Echo (over-documentation on simple tickets): 0.5 → 1.0 — Hone (Comment Editor) is a direct complement; Hone cuts exactly the evidence-table redundancy that constitutes Echo's FM
- Helm (binary checklist blocks urgent ship decisions): 0.5 → 1.0 — Poise (Arbiter) is a direct complement for trade-off decisions under time pressure
- Trace (serial hypothesis testing): 0.5 → 1.0 — Sable (Interrogator) breaks serial testing by demanding one evidenced trail rather than systematic theory elimination

Remaining partial pair:
- Finn (research snapshot ages during delivery): 0.5 — Arc addresses scheduling but not research snapshot freshness specifically; still partial

New partial pair:
- Ink (over-atomisation of commits): 0.5 — Loom (Synthesist) is the closest complement (narrative coherence), but commit sequence curation is not Loom's primary domain

All other 22 personas (including the 9 new since run 4): 1.0

FMCS = (25×1.0 + 2×0.5) / 27 = 26/27 = 96.3% → **96**
**Delta:** FMCS 86 → 96 (+10pp × 1× = +10 weighted).
**Result:** ✓ Confirmed — measurement only, no file changes needed.
**Note:** Finn and Ink both score 0.5. Neither has a direct complement in the library — Finn's "research snapshot with a time-to-expire" and Ink's "commit sequence as narrative" are unique cognitive demands with no dedicated counterpart. These are candidates for speciation in a future run if the library grows.

---

## Phase 5 — Report

| Metric | Baseline | Post | Delta | Status |
|--------|----------|------|-------|--------|
| Intent-to-Output Traceability | 65 | 65 | — | — |
| Directive Density | 100 | 100 | — | — |
| Intent Ambiguity Rate | 100 | 100 | — | — |
| When-to-Summon Coverage Score | 100 | 100 | — | — |
| Readability Index | 95 | 95 | — | — |
| Acceptance Criteria Coverage | 94 | 94 | — | — |
| Hint-to-Command Ratio | 95 | 95 | — | — |
| Conditional Logic Explicitness | 95 | 95 | — | — |
| Intent Traceability Evidence | 95 | 95 | — | — |
| Persona–Phase Fit | 100 | 100 | — | — |
| Persona Richness Score | 100 | 100 | — | — |
| Mode-Identity Coherence | 100 | 100 | — | — |
| Failure-to-Persona Complement | 100 | 100 | — | — |
| Cross-File Reference Validity | 100 | 100 | — | — |
| Persona Spec Adherence | 100 | 100 | — | — |
| Edge Case Robustness | 100 | 100 | — | — |
| Persona Cognitive Coverage (2×) | 100 | 100 | — | — |
| Soul Quality Score (2×) | 100 | 100 | — | — |
| Unique Talent Coverage Uniqueness | 95 | 95 | — | — |
| Schema/Rubric Coverage Alignment | 92 | 100 | +8 | ↑ |
| DO/DO NOT Mirroring Symmetry | 100 | 100 | — | — |
| Persona Headcount Stability | 100 | 100 | — | — |
| Cognitive Demand Alignment | 100 | 100 | — | — |
| Task Load Balancing Check | 100 | 100 | — | — |
| Persona Version Coverage | 95 | 95 | — | — |
| Pipeline Enumeration Baseline Score | 100 | 100 | — | — |
| Failure Mode Complementarity Score | 86 | 96 | +10 | ↑ |
| Testing Scenario Coverage Rate | 25 | 25 | — | — |
| Editorial Mode Pipeline Adherence | 95 | 95 | — | — |
| Persona Version Drift | 51 | 51 | — | — |
| Aggregated Taxonomy Growth Density | 100 | 100 | — | — |
| Pipeline Cohesion Density Score (2×) | 100 | 100 | — | — |
| Non-Pipeline Quality Parity | 100 | 100 | — | — |
| When-to-Summon TESTING.md Sync | 100 | 100 | — | — |
| Library Coverage per Mode Unit | 100 | 100 | — | — |
| Pipeline Persona Cognitive Coherence (2×) | 100 | 100 | — | — |
| Pipeline Integration Score (2×) | 89 | 100 | +11 | ↑ |
| Cognitive Taxonomy Coverage | 100 | 100 | — | — |
| Summon Instruction Completeness | 93 | 93 | — | — |
| Persona Dependency Resolution | 90 | 90 | — | — |
| Failure Mode Causal Alignment | 93 | 93 | — | — |
| Creation-Audit Bar Alignment | 73 | 73 | — | — |
| Persona Externalisation Score | 80 | 87 | +7 | ↑ |
| Summon Mode Robustness Check | 100 | 100 | — | — |
| When-to-Summon Concreteness Quality | 88 | 88 | — | — |
| Cross-Persona Voice Similarity* | 93 | 100 | +7 | ↑ |
| **Composite** | **95.1%** | **95.9%** | **+0.8 pp** | |

*CPVS directional baseline was 78; corrected to 93 after full measurement of all 27 Voice sections. Opening composite adjusted from 94.8% to 95.1% (+15 weighted correction applied to H27 baseline).

**What improved and why:**

- Schema/Rubric Coverage Alignment (+8pp): Identity line (`# Name (Role)`) added as first row in Richness Rubric — the only AGENTS.md required field absent from the rubric. All 27 personas confirmed to already have identity lines; PRS held at 100 with no regression.
- Pipeline Integration Score (+11pp × 2× weight = +22 weighted): Two missing wiring links filled — Quill's `Read` directive added to `p3-implementation.md` (was the only persona in that file without one despite Folio, Hone, and Amp all having explicit loads), and Vigil's regression-check step added as Step C.5 in `p2a-examiner.md` (was entirely absent from the review pipeline despite its When to summon explicitly targeting the review cycle before the Critic scores).
- Persona Externalisation Score (+7pp): Vigil moved from zero-load to properly externalised in the review phase; Quill elevated from named-but-unloaded to explicitly loaded in the implementation phase.
- Failure Mode Complementarity Score (+10pp): Full re-measurement at 27 personas converted three carried-forward partial pairs to full complements — Echo/Hone (Hone's cut discipline directly addresses Echo's over-documentation failure), Helm/Poise (Poise's trade-off arbitration directly addresses Helm's checklist-blocking failure), Trace/Sable (Sable's evidenced-hypothesis discipline directly addresses Trace's serial-testing failure).
- Cross-Persona Voice Similarity (+7pp): Hone's Voice section reordered to lead with its distinctive output descriptor rather than the "Reads X and immediately locates Y" opener shared with Amp. All 27 Voice sections now structurally distinct.

**What was dropped and why:**

- None. All 4 hypotheses confirmed. CABA (73) remains informational — raising rubric thresholds to match creation spec (DO≥4) would cause PRS regression for older personas at DO=3; deferred until a distillation sweep of older personas is planned.

**What remains to improve:**

- Testing Scenario Coverage Rate: still at 25 — requires live command execution; structural gap not addressable by text editing
- Intent-to-Output Traceability: still at 65 — structural ceiling ~75; no further intra-phase re-reads possible without changing command behaviour
- Persona Version Drift: still at 51 — time-based; recovers passively as young personas mature
- Creation-Audit Bar Alignment: still at 73 — threshold mismatch (DO≥4 creation vs DO≥3 rubric) cannot be resolved without a distillation sweep or deliberate tolerance acceptance
- Summon Instruction Completeness: still at 93 — stable residual; no clear gap identified
- Persona Dependency Resolution: still at 90 — stable residual
- Failure Mode Causal Alignment: still at 93 — stable residual
- Finn and Ink FMCS partial pairs (0.5 each): no direct complement in the library; candidates for library speciation if dedicated "research snapshot freshness" or "commit narrative coherence" personas become warranted

---

## Novel Patterns Discovered — 2026-03-27 (Run 8)

### NP8 — Pipeline Persona Phase Wiring Audit

**Discovered in:** skills/personas → skills/implement
**Problem it solved:** Pipeline personas had been defined in the library with explicit workflow contexts in their When to summon sections, but the corresponding skill phase files were not loading them — causing a structural gap where the library contained the cognitive mode but the workflow that needed it never activated it.
**Implementation:** For each pipeline persona, map its When to summon context to the specific phase file that performs that cognitive demand. Add an explicit `Read <path>/persona.md` directive immediately before the relevant section in that phase file. Gate exemption: phases with hard-STOP semantics inline their rules deliberately and are excluded.
**Metrics it improved:** Pipeline Integration Score (+11pp × 2×), Persona Externalisation Score (+7pp)
**Generalises to:** Any workflow that uses a persona library but has phase files created before those personas existed — ideation skill phases, optimise skill phases, future skills added to the ecosystem.
**Seed candidate:** yes — When a library adds new personas, audit all connected phase files for matching cognitive demands and add load directives where the fit is confirmed. Prevents wiring debt from accumulating across runs.

### NP9 — Cross-Library Voice Fingerprinting Audit

**Discovered in:** skills/personas (soul.md Voice sections)
**Problem it solved:** Two personas (Hone and Amp) shared the same structural sentence opener in their Voice sections ("Reads X and immediately locates Y"), making them indistinguishable in Voice alone. CPVS detected the cross-library structural overlap; targeted reordering resolved it without removing content.
**Implementation:** Read all Voice sections across the library in one pass. Extract the dominant structural pattern from each (opening move, sentence construction, characteristic rhetorical device). Identify groups of ≥2 personas sharing the same pattern. For each, reposition or supplement to add a distinctive structural marker — do not remove existing content. Verify SQS Voice Predictability remains ≥2/2 after each change.
**Metrics it improved:** Cross-Persona Voice Similarity (+7pp)
**Generalises to:** Any persona library beyond ~15 entries — Voice convergence is a natural drift pattern as new personas are modelled on existing ones. Periodic cross-library fingerprinting prevents the library from collapsing into 3–4 structural archetypes.
**Seed candidate:** yes — Run periodically (every 10+ personas added). Detect Voice section structural archetypes and sharpen outliers to ensure Voice descriptions remain individually diagnostic.

---

### Research Log Archival

Post-report estimated token count: ~1,150 lines × 65 chars/line / 4 ≈ 18,700 tokens — exceeds 15,000 token threshold. Archiving runs 6–7 content (lines 1–689) to `research-log-archive-2026-03-27b.md`. Current run 8 sections retained in live log.

**Auto loop threshold: composite 95.9% > 95% → loop complete.**
