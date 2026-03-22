# Personas Changelog

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
