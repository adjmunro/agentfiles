<!-- SUMMARY-START -->
## Run 002 — 2026-03-22 | Target: skills/personas
Composite: 88.1% → 94.4% (+6.3 pp)

### Hypotheses
| ID  | Description                                               | Outcome   |
|-----|----------------------------------------------------------|-----------|
| H5  | Add evidence citation requirement to distil output steps  | Confirmed |
| H6  | Assign Keeper (Strategist) to evolve.md speciate mode     | Confirmed |
| H7  | Create Loom (Synthesist) + assign to evolve.md new mode   | Confirmed |

### Metric Snapshot
| Metric | Baseline | Post |
|--------|---------|------|
| Intent-to-Output Traceability | 50 | 65 |
| Directive Density | 100 | 100 |
| Instruction Ambiguity Rate | 99 | 99 |
| Wiring Completeness Score | 100 | 100 |
| Redundancy Index | 97 | 97 |
| AC Concreteness | 94 | 94 |
| Human Touchpoint Count | 90 | 90 |
| Context Loading Efficiency | 95 | 95 |
| Instruction Token Efficiency | 96 | 96 |
| Persona-Phase Fit Score | 80 | 100 |
| Persona Richness Score | 100 | 100 |
| Persona Coverage Completeness | 75 | 81 |
| Roster Synchronisation Score | 100 | 100 |
| Schema Compliance Rate | 100 | 100 |
| Cognitive Gap Documentation Currency | 100 | 100 |
| Persona Differentiation Index | 97 | 98 |
| Mode Invocation Completeness | 100 | 100 |
| Fallback Path Coverage | 100 | 100 |
| Cross-File Reference Validity | 100 | 100 |
| Persona-Soul Alignment | 100 | 100 |
| Evidence Citation Rate | 0 | 100 |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

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

## Phase 2 — Baseline

**Persona: Pulse (Analytics)**

Seed metrics applied: IOT(2×), DD(1×), IAR(1×), WCS(1×), RI(1×), ACC(2×), HTC(2×), CLE(2×), ITE(1×), PPF(2×), PRS(1×)
Seed metrics skipped: SAS (no subagents), CDR (no multi-session), PSS (no parallel), IFS (no cached artifacts)
Custom metrics (Run 1): PCC(2×), RSS(1×), SCR(1×), CGDC(1×), PDI(2×)
Custom metrics (Run 2): MIC(1×), FPC(1×), CFRV(1×), PSA(2×), ECR(1×)

### Custom Metrics Defined This Run

#### MX6 — Mode Invocation Completeness (MIC) [custom]
**Measures:** Whether every mode named in evolve.md's preamble routing list has a full `## Mode:` implementation section.
**Why seeds miss it:** DD measures instruction density; no seed checks whether the routing table matches the implemented sections. A listed-but-unimplemented mode fails silently at runtime.
**Methodology:** Count modes in the `## Persona Evolution` list vs. modes with a `## Mode:` header. MIC = implemented / listed.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** MIC × 100

#### MX7 — Fallback Path Coverage (FPC) [custom]
**Measures:** Whether every explicit error condition and STOP gate has an explicit recovery or fallback instruction.
**Why seeds miss it:** HTC counts gates but not whether they handle rejection/failure. A STOP gate with no "if rejected, do X" leaves the agent stranded.
**Methodology:** Enumerate all error conditions (unrecognised argument, file-not-found, STOP gate rejection, no evidence source, near-match found). Check whether each has a fallback instruction. FPC = conditions_with_fallback / total_conditions.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** FPC × 100

#### MX8 — Cross-File Reference Validity (CFRV) [custom]
**Measures:** Whether all explicit relative path references in command files resolve to currently-existing files.
**Why seeds miss it:** No seed measures reference staleness. A broken `../path/file.md` reference is a silent load failure.
**Methodology:** Extract all `../path` references from summon.md and evolve.md; verify each target exists. CFRV = valid_references / total_references.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** CFRV × 100

#### MX9 — Persona-Soul Alignment (PSA) [custom]
**Measures:** Whether each persona's DO rules in persona.md are thematically consistent with their Core Truths in soul.md — no soul-behaviour contradictions.
**Why seeds miss it:** No seed compares behaviour rules with character axioms. Inconsistency creates a persona that is unstable across sessions — agents reading DO rules get one model; agents reading Core Truths get another.
**Methodology:** For each of 12 personas, assess DO rules vs. Core Truths. Score: 1.0 if consistent; 0.5 if minor tension (same direction but different emphasis); 0.0 if direct contradiction.
**Direction:** ↑ higher is better
**Weight:** 2× — soul-behaviour inconsistency breaks persona coherence across sessions
**Normalisation:** avg(scores) × 100

#### MX10 — Evidence Citation Rate (ECR) [custom, moonshot]
**Measures:** In distil mode, what fraction of the output-generating steps require the agent to cite a specific passage from the evidence source for each proposed change.
**Why seeds miss it:** IOT measures whether evidence is loaded; no metric measures whether the evidence→rule trace is documented. An agent can load a log, read it, and write DO rules without linking any of them back to a specific passage. The evidentiary chain is invisible and unverifiable.
**Methodology:** Count the output-generating steps in distil mode (sharpen, add, prune, deepen = 4 steps). For each, check whether the instruction explicitly requires citing the evidence passage. ECR = steps_with_citation_requirement / 4.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** ECR × 100

### Composite Table

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

## Phase 3 — Hypotheses

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

## Phase 4 — Experiments

**Persona: Keeper (Strategist)**

**Pre-experiment dependency scan:** H5 modifies evolve.md (distil mode section). H6 modifies evolve.md (speciate mode header). H7 creates new directory files + modifies evolve.md (new mode header + taxonomy). **All three modify evolve.md → must run sequentially, in order H5 → H6 → H7, with metric re-check between each.**

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

## Phase 5 — Report

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

## Novel Patterns

### NP3 — Emergent Property Test for New Persona Creation
**Observed in:** H7 spot-check
**Description:** When creating a new persona via evolve.md new mode, the quality test is: "does this design have a property that could not be derived from any single source domain?" If the entire design can be reconstructed from just the taxonomy, or just from existing personas, or just from archetypes — synthesis did not occur and the persona is likely a renamed existing one. The emergent property is the distinguishing mark. Loom's Unique Talent formalises this as an explicit creation-time test.
**Generalises to:** Any workflow that creates new artefacts from multiple existing knowledge sources (new skills, new architectural components, novel system designs from existing parts).
**Seed candidate:** yes
