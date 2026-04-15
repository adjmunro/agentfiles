<!-- SUMMARY-START -->
## Run 003 — 2026-03-22 | Target: skills/personas
Composite: 92.6% → 95.1% (+2.5 pp)

### Hypotheses
| ID  | Description                                                        | Outcome   |
|-----|--------------------------------------------------------------------|-----------|
| H8  | Sync AGENTS.md schema with SQS quality criteria                    | Confirmed |
| H9  | Add Essence and Unique Talent coverage to distil soul pass         | Confirmed |
| H10 | Sharpen 7 weak SQS fields across 6 personas                        | Confirmed |
| H11 | Create Arc (Sequencer) persona for temporal reasoning gap          | Confirmed |

### Metric Snapshot
| Metric | Baseline | Post |
|--------|---------|------|
| Intent-to-Output Traceability | 65 | 65 |
| Directive Density | 100 | 100 |
| Instruction Ambiguity Rate | 99 | 99 |
| Wiring Completeness Score | 100 | 100 |
| Redundancy Index | 97 | 97 |
| AC Concreteness | 94 | 94 |
| Human Touchpoint Count | 90 | 90 |
| Context Loading Efficiency | 95 | 95 |
| Instruction Token Efficiency | 96 | 96 |
| Persona-Phase Fit Score | 100 | 100 |
| Persona Richness Score | 100 | 100 |
| Persona Coverage Completeness | 81 | 88 |
| Roster Synchronisation Score | 100 | 100 |
| Schema Compliance Rate | 100 | 100 |
| Cognitive Gap Documentation Currency | 100 | 100 |
| Persona Differentiation Index | 98 | 98 |
| Mode Invocation Completeness | 100 | 100 |
| Fallback Path Coverage | 100 | 100 |
| Cross-File Reference Validity | 100 | 100 |
| Persona-Soul Alignment | 100 | 100 |
| Evidence Citation Rate | 100 | 100 |
| Soul Quality Score | 95 | 100 |
| Unique Talent Cross-Library Uniqueness | 99 | 99 |
| Schema-Rubric Coverage Alignment | 58 | 92 |
| Distil Mode Soul Coverage | 67 | 100 |
| Prompting Heuristic Signal Coherence | 83 | 83 |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

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

## Phase 2 — Baseline

**Persona: Pulse (Analytics)**

Seed metrics applied: IOT(2×), DD(1×), IAR(1×), WCS(1×), RI(1×), ACC(2×), HTC(2×), CLE(2×), ITE(1×), PPF(2×), PRS(1×)
Seed metrics skipped: SAS, CDR, PSS, IFS
Custom metrics: PCC(2×), RSS(1×), SCR(1×), CGDC(1×), PDI(2×), MIC(1×), FPC(1×), CFRV(1×), PSA(2×), ECR(1×), SQS(2×), UTCU(2×), SRCA(1×), DMSC(1×), PHSC(1×)

### Carry-forward scores (unchanged from Run 2 final)
IOT=65, DD=100, IAR=99, WCS=100, RI=97, ACC=94, HTC=90, CLE=95, ITE=96, PPF=100, PRS=100, PCC=81, RSS=100, SCR=100, CGDC=100, PDI=98, MIC=100, FPC=100, CFRV=100, PSA=100, ECR=100.
Note: evolve.md SQS/soul-pass additions add directives (improving DD in principle) but DD was already capped at 100. No existing metric was pushed beyond its current score by the pre-run changes.

### Custom Metrics Defined This Run

#### MX11 — Soul Quality Score (SQS) [custom]
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

#### MX12 — Unique Talent Cross-Library Uniqueness (UTCU) [custom, moonshot]
**Measures:** Whether each Unique Talent description names a cognitive operation that is genuinely distinct from all others at the specific Unique Talent level — not just at the Purpose/DO level (which PDI already measures). Two personas can score well on PDI yet have Unique Talents that describe the same cognitive operation with different vocabulary.
**Why seeds miss it:** PDI measures pairwise uniqueness of Purpose + DO rules. UTCU isolates the one field AGENTS.md marks as the primary differentiator. Borrowed from information-theoretic diversity metrics applied at the field level. If Unique Talents are colliding, the library has redundant depth precisely where it matters most.
**Methodology:** For all 78 pairs of Unique Talent descriptions (13×12÷2): assess whether the core cognitive operation described overlaps. Score per pair: 1.0 (genuinely distinct), 0.5 (adjacent — same broad domain, different operation), 0.0 (duplicative — same operation, different phrasing). UTCU = avg(pair scores). Conceptually: 1 minus average overlap.
**Direction:** ↑ higher is better
**Weight:** 2× — Unique Talent collisions mean the library has redundant depth in its most critical differentiating field
**Normalisation:** UTCU × 100

#### MX13 — Schema-Rubric Coverage Alignment (SRCA) [custom]
**Measures:** Whether AGENTS.md's required-fields schema covers all dimensions that evolve.md's audit rubric now measures. If evolve.md's audit scores on dimensions not required by AGENTS.md, new personas can be schema-compliant while scoring poorly on the full audit.
**Why seeds miss it:** SCR checks compliance with AGENTS.md; PRS uses the Richness Rubric; neither checks whether the two instruments are consistent with each other. After Run 3 added the SQS rubric to evolve.md's audit mode, evolve.md now measures 5 quality dimensions not required by AGENTS.md. The normative schema lags the measurement instrument.
**Methodology:** List all dimensions scored in evolve.md's Richness Rubric + SQS rubric (7 + 5 = 12 total). List all required fields in AGENTS.md for soul.md. SRCA = rubric_dimensions_covered_or_noted_in_AGENTS.md / total_rubric_dimensions.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** SRCA × 100

#### MX14 — Distil Mode Soul Coverage (DMSC) [custom]
**Measures:** In evolve.md distil mode, what fraction of soul.md sections have an explicit methodology step for detecting whether they need updating.
**Why seeds miss it:** ECR measures whether DO rule changes cite evidence. No metric measures whether the distil soul-sharpening process explicitly covers each of the 6 soul sections (Essence, Core Truths, Opinions, Contradictions, Voice, Unique Talent). A distil run that covers only some sections will systematically miss soul growth opportunities in the uncovered ones.
**Methodology:** List the 6 soul sections. For each, check whether distil mode (post soul-verification-pass) has an explicit step that would detect a need to update that section. Count covered_sections / 6.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** DMSC × 100

#### MX15 — Prompting Heuristic Signal Coherence (PHSC) [custom, moonshot]
**Measures:** Whether the 4 prompting heuristics in summon.md produce orthogonal behavioural shifts — each heuristic pushing the persona in a distinct direction with no overlap. Borrowed from signal processing: orthogonal control inputs are more efficient than correlated ones. If two heuristics produce the same shift, one is redundant. If all four are distinct, the user has four genuine degrees of freedom over persona behaviour.
**Why seeds miss it:** No metric measures whether the control surface for persona behaviour is degenerate. ACC would score all four heuristics as concrete; no metric asks whether they're *distinct*.
**Methodology:** For all 6 pairs of prompting heuristics: assess whether the behavioural shift described is distinct (1.0), partially overlapping (0.5), or identical (0.0). PHSC = avg(pair scores).
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** PHSC × 100

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

## Phase 3 — Hypotheses

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

## Phase 4 — Experiments

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

## Phase 5 — Report

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

## Novel Patterns

### NP4 — Essential vs. Conventional Ordering Test
**Observed in:** H11 design (Arc's Unique Talent) + spot-check validation
**Description:** When sequencing work items, the critical distinction is whether a stated ordering is *essential* (the downstream item cannot run because the upstream item hasn't produced what it needs yet) or *conventional* (the team has always done it in this order, but the constraint is habitual, not structural). Treating convention as constraint serialises parallelisable work; treating constraint as convention produces blockers mid-flight. The test: "what state does the earlier item produce that the later one consumes? if nothing, the dependency is conventional." Arc makes this test explicit and applies it before accepting any stated sequence.
**Generalises to:** Any workflow that involves ticket sequencing, deployment ordering, migration planning, or multi-step refactoring where the order of work items is assumed rather than derived.
**Seed candidate:** yes
