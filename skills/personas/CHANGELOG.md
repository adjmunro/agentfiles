# Personas Changelog

## v1.10.0 - 2026-03-27 - Optimise Run 8

**Opening composite: 95.1% (corrected) → final: 95.9% (+0.8pp). All 4 hypotheses confirmed. Auto loop complete (>95% threshold).**

Note: opening composite corrected from 94.8% to 95.1% after full CPVS measurement revealed the directional baseline was too pessimistic (78 estimated vs 93 actual).

- Added Identity line (`# Name (Role)` format) as first row in Richness Rubric in `commands/evolve.md`; updated maximum from 14→15 and formula accordingly — SRCA 92→100 [H25]; also propagated to `skills/optimise/commands/phases/p2-baseline.md` M15 rubric
- Wired Quill into `skills/implement/commands/work/p3-implementation.md` with explicit `Read` directive — the only pipeline persona in that file lacking one [H26]
- Added Vigil-governed Step C.5 (Regression Check) to `skills/implement/commands/review/p2a-examiner.md` — PIS 89→100, PES 80→87 [H26]
- Reordered Hone's Voice section in `hone/soul.md` to lead with its distinctive output descriptor, removing structural overlap with Amp — CPVS 93→100 [H27]
- Re-measured FMCS at all 27 personas: converted 3 partial pairs (Echo/Hone, Helm/Poise, Trace/Sable) to full complements — FMCS 86→96 [H28]; measurement only, no file changes
- 5 new custom metrics defined: CABA, PES, SMRC, WTCQ, CPVS
- Novel patterns documented: NP8 (Pipeline Persona Phase Wiring Audit), NP9 (Cross-Library Voice Fingerprinting Audit)
- Research log archived: runs 6–7 moved to `research-log-archive-2026-03-27b.md`; live log retains run 8 only

---

## v1.9.0 - 2026-03-27 - Optimise Run 7

**Opening composite: 92.9% → final: 95.75% (+2.9pp). All 4 hypotheses confirmed. Auto loop complete (>95% threshold).**

Note: composite opened lower than run 6 final (96.3%) due to 7 new personas introducing metric drops in WCS, WTTS, LCMU, SQS, NPQP, and PVD.

- Added 6 new personas (Ink, Quill, Vigil, Folio, Hone, Amp) to `commands/summon.md` Persona Roster — WCS 78→100 [H21]
- Added 6 new personas to `TESTING.md` per-persona table; fixed stale "18 personas" header references to "27" — WTTS 78→100 [H22]
- Added 6 pipeline-persona cognitive modes to `commands/evolve.md` taxonomy (commit curation, intent annotation, regression detection, API documentation accuracy, editorial tightening, constraint strengthening) — LCMU 70→100, CTC 78→100 [H23]
- Sharpened Opinion 1 for 5 personas (Ink, Quill, Vigil, Folio, Hone) to counter-intuitive non-obvious positions — SQS 98→100, NPQP 29→100 [H24]; 5 files updated
- 5 new custom metrics defined: PIS (2×), CTC, SIC, PDR, FMCAL

---

## v1.8.0 - 2026-03-27 - Flint (Dialectician)

**New persona. Fills the argument analysis cognitive gap — 21 personas, 21 distinct taxonomy modes.**

- Added **Flint (Dialectician)** (`dialectician/persona.md` + `dialectician/soul.md`) — applies a formal fallacy taxonomy (formal + informal, by category) to any input regardless of artefact type; unique cognitive function is treating reasoning structure as the primary object of analysis rather than content gaps or specification loopholes
- Registered in SKILL.md roster, summon.md persona table, evolve.md taxonomy, and TESTING.md per-persona table

---

## v1.7.0 - 2026-03-27 - Optimise Run 6

**Opening composite: 95.0% → final: 96.3% (+1.3pp). All 2 hypotheses confirmed. Auto loop complete (>95% threshold).**

Note: composite opened lower than run 5 final (95.9%) due to 4 new metrics added this run — NPQP=50 and PPCC=89 revealed previously unmeasured gaps.

- Sharpened Opinion 1 in Sage (pedagogical/soul.md) and Poise (negotiation/soul.md) to score 2/2 on Non-obviousness — SQS 99→100, NPQP 50→100 [H19]; 2 files updated
- Fixed 4 imprecise WTS complement-references in Arden (critic/persona.md) and Keeper (strategist/persona.md) to accurately paraphrase cited personas' Failure Mode text — PPCC 89→100 [H20]; 2 files updated
- 4 new custom metrics defined: NPQP, WTTS, LCMU, PPCC (two at 100 at baseline; two revealed gaps)
- Research log archived: runs 4–5 moved to `research-log-archive-2026-03-27.md`; live log retains run 6 only

---

## v1.6.0 - 2026-03-26 - Optimise Run 5

**Opening composite: 93.1% → final: 95.9% (+2.8pp). All 4 hypotheses confirmed. Auto loop complete (>95% threshold).**

Note: composite opened lower than run 4 final (97.5%) due to 5 new metrics added this run — TSCR=0 and PCDS=53 revealed previously unmeasured gaps.

- Documented all 18 failure-mode complement pairs in persona "When to summon" sections — PCDS 53→100 (+94 weighted) [H15]; 7 files updated (Arden, Keeper, Vela, Trace, Vault, Echo, Kira)
- Created new personas **Sage (Pedagogue)** and **Poise (Arbiter)** to fill the two remaining taxonomy gaps — PCC 90→100 [H17]; all 20 cognitive modes now covered
- Sharpened Vault's Opinions to non-obvious architecture perspectives — SQS 99→100 [H18]
- Marked 2 structural test scenarios as verified by metric evidence — TSCR 0→25 [H16]
- 5 new custom metrics defined: TSCR, EMPAC, PVD, AGD, PCDS (two at 100; three revealed gaps)
- Novel patterns documented: NP6 (Failure Mode Guardrail Documentation), NP7 (Evidence-Anchored Test Status)

---

## v1.5.0 - 2026-03-22 - Optimise Run 4

**Opening composite: 94.7% → final: 97.5% (+2.8pp). All 3 hypotheses confirmed. Auto loop complete (>95% threshold).**

- Registered 4 new personas in SKILL.md and summon.md rosters: Sable (Interrogator), Trace (Debugger), Vault (Architect), Lens (Verifier) — WCS+RSS 78→100, PEBS 89→100 [H12]
- Added 4 new cognitive modes to evolve.md taxonomy: demand validation, root cause isolation, architecture review, live verification — CGDC+TLBC 80→100, PCC 88→90 [H13]
- Sharpened overlapping prompting heuristics: "what would you flag?" now explicitly a *filter shift*; "what's your honest take?" now explicitly a *character shift* — PHSC 83→100 [H14]
- 5 new custom metrics defined: CDA, TLBC, PVC, PEBS, FMCS (all ≥86 at baseline)
- Research log archived: runs 1–3 moved to `research-log-archive-2026-03-22.md`; live log retains run 4 only
- Novel pattern documented: NP5 (Library Registration Sweep — 3-location atomicity rule)

---

## v1.4.0 - 2026-03-22 - gstack Gap Fill

**4 new personas distilled from gstack specialist roles. Fills demand validation, systematic debugging, pre-implementation architecture review, and live verification cognitive gaps.**

- Added new persona **Sable (Interrogator)** (`interrogator/persona.md` + `interrogator/soul.md`) — fills demand validation gap: decides whether the problem is real before any planning begins. Unique cognitive function: distinguishes interest from demand by listening for behaviour verbs, not sentiment. No existing persona (including Keeper) addresses the "should we build this at all?" question with this specificity.
- Added new persona **Trace (Debugger)** (`debugger/persona.md` + `debugger/soul.md`) — fills systematic root-cause isolation gap: four-phase loop (reproduce → evidence → hypothesis → implement), iron law of no fix without confirmed root cause. Unique cognitive function: classifies failure by category (race condition, nil propagation, state corruption, etc.) before forming any hypothesis.
- Added new persona **Vault (Architect)** (`architect/persona.md` + `architect/soul.md`) — fills pre-implementation architecture lock-in gap: system design, failure modes per code path, scope smell detection, existing-code-leverage check. Distinct from Arden (general gap-finding) and Echo (AC evidence mapping): Vault locks the structure before implementation, not after.
- Added new persona **Lens (Verifier)** (`verifier/persona.md` + `verifier/soul.md`) — fills live verification gap: browser-based testing against a running application, severity classification before fixing, atomic commits per bug, before/after health scores. Distinct from Echo (read-only AC mapping): Lens tests the live surface and fixes what it finds.

---

## v1.3.0 - 2026-03-22 - Optimise Run 3

**Opening composite: 92.6% → final: 95.1% (+2.5pp). All 4 hypotheses confirmed.**

- Synced AGENTS.md schema with SQS quality criteria: added observability notes for Essence (must be library-unique), Contradictions (must be predictable in output), Voice (must enable imitation), and expanded Unique Talent with copy-paste self-test — SRCA 58→92 [H8]
- Sharpened 7 weak soul fields across 6 personas (Keeper Essence+Opinions, Arden Essence, Echo Essence, Finn Essence, Ward Voice, Artisan Contradictions) to score 2/2 on SQS — SQS 95→100 [H10]
- Added Essence drift and Unique Talent calibration steps to `evolve.md` distil soul verification pass — DMSC 67→100 [H9]
- Added new persona **Arc (Sequencer)** (`temporal/persona.md` + `temporal/soul.md`) — fills temporal reasoning cognitive gap; PCC 81→88 [H11]
- Updated SKILL.md roster, `commands/summon.md`, and `commands/evolve.md` taxonomy to include Arc
- 5 new custom metrics defined: SQS, UTCU, SRCA, DMSC, PHSC
- Novel pattern documented: NP4 (Essential vs. Conventional Ordering Test)

---

## v1.2.0 - 2026-03-22 - Optimise Run 2

**Composite: 88.1% → 94.4% (+6.3pp). All 3 hypotheses confirmed.**

- Added mandatory evidence citation requirement to `evolve.md` distil mode: each candidate (sharpen/add/prune/deepen) must cite the section name or quoted phrase from the evidence source — ECR 0→100, IOT 50→65 [H5]
- Added Keeper (Strategist) persona directive to `evolve.md` speciate mode — PPF 80→90 [H6]
- Added new persona **Loom (Synthesist)** (`synthesis/persona.md` + `synthesis/soul.md`) — fills synthesis cognitive gap; assigned to `evolve.md` new mode — PPF 90→100, PCC 75→81 [H7]
- Updated SKILL.md roster, `commands/summon.md`, and `commands/evolve.md` taxonomy to include Loom
- 5 new custom metrics defined: MIC, FPC, CFRV, PSA (all 100 at baseline), ECR (0 at baseline — resolved by H5)
- Novel pattern documented: NP3 (Emergent Property Test for New Persona Creation)

---

## v1.1.0 - 2026-03-22 - Optimise Run 1

**Composite: 82.0% → 89.3% (+7.3pp). All 4 hypotheses confirmed.**

- Added `## Failure Mode` section to 8 non-distilled persona.md files (Kira, Artisan, Echo, Vale, Finn, Vela, Helm, Ward) — PRS 79→100, SCR 89→100 [H1]
- Added `## Unique Talent` section to the same 8 soul.md files [H1]
- Added Pulse (Analytics) persona directive to `evolve.md` audit and distil modes — PPF 40→80 [H2]
- Replaced 4 vague completion criteria in `evolve.md` with measurable alternatives (speciate quality markers, niche definition, distil evidence threshold, naming rule) — ACC 72→94 [H3]
- Added new persona **Rook (Adversary)** (`adversarial/persona.md` + `adversarial/soul.md`) — fills adversarial red-team cognitive gap; PCC 69→75 [H4]
- Updated SKILL.md roster, `commands/summon.md`, and `commands/evolve.md` taxonomy to include Rook
- Novel patterns documented: NP1 (Persona Library as Instruction Target), NP2 (Richness Rubric as Schema Compliance Proxy)

---

## v1.0.0 - 2026-03-22 - The First Faces

Personas extracted from the kanban skill into their own first-class skill. Skills now summon personas by path rather than borrowing from a sibling directory.

- 11 personas migrated: Vela, Arden, Finn, Kira, Echo, Vale, Keeper, Artisan, Helm, Ward, Pulse
- "Invoked By" sections replaced with skill-agnostic "When to summon" guidance
- Single source of truth: lens, voice, and behavioural contract live here only
