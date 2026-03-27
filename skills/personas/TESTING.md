# Testing — Personas

## Strategy

Test the two commands (`summon` and `evolve`) separately: summon is verified by loading a persona and checking that its DO rules shape the output of a defined task; evolve is verified in each mode (audit, distil, speciate, new) using the live persona library. Mandatory-field coverage is checked with a structural scan of all 27 personas before any command is run.

## Environment Setup

1. The live persona library is at `/Users/adjmunro/Developer/agentfiles/skills/personas/`.
2. For `evolve distil` testing, use `skills/personas/research-log.md` as the evidence source — it should contain traces of persona activity from prior runs.
3. For `evolve new` testing, identify a cognitive mode from the taxonomy in `evolve.md` that is currently marked as `*(gap)*`. Note: as of run 5 (2026-03-26), the Pedagogical explanation and Negotiation / trade-off gaps have been filled — check the current taxonomy for any remaining gaps before testing.
4. For `evolve speciate` testing, choose a persona whose Purpose spans more than one cognitive mode — review the audit results to identify a suitable candidate rather than picking arbitrarily.
5. No temporary directories are required — all evolve scenarios operate on the live library, so use a git branch or ensure you can revert any writes made during testing.

## Core Scenarios

| Scenario | Input | Expected Outcome | Status |
|----------|-------|-----------------|--------|
| `summon` — persona applied to task | `/personas summon Arden` with a test task: "review this plan for gaps" | Arden (Critic)'s DO rules visibly shape the response; gap-finding language and structured critique present | Untested |
| `summon` — soul depth active | `/personas summon Finn` with a task requiring research framing | Finn (Scout)'s voice, opinions, and contradictions are detectable in output; not just role-label compliance | Untested |
| `evolve audit` — scores all personas | `/personas evolve audit` | All 18 personas scored against Richness Rubric (max 14) and SQS (max 10); Recommendation Brief produced; skill stops and waits for approval | Untested |
| `evolve distil` — sharpens a persona | `/personas evolve distil Pulse from skills/personas/research-log.md` | Distillation candidates identified with evidence citations; Recommendation Brief produced; skill stops before writing any files | Untested |
| `evolve new` — creates a new persona | `/personas evolve new <description of gap cognitive mode>` | Existing library checked for near-matches; if genuinely unmet, sketch produced (name, essence, unique talent, failure mode); stops for approval before writing | Untested |
| `evolve speciate` — forks a persona | `/personas evolve speciate <candidate identified in audit>` | 2–3 variants proposed with distinct niches, new names, differing Failure Modes; stops for approval before writing | Untested |
| Mandatory fields check — Unique Talent | Structural scan of all 27 `soul.md` files | Every `soul.md` contains a `Unique Talent` section | Pass — verified by PRS=100 across runs 3–7 (optimise run 7, 2026-03-27) |
| Mandatory fields check — Failure Mode | Structural scan of all 27 `persona.md` files | Every `persona.md` contains a `Failure Mode` section | Pass — verified by PRS=100 across runs 3–7 (optimise run 7, 2026-03-27) |

## Command Coverage

| Command file | Covered by scenario |
|--------------|---------------------|
| `commands/summon.md` | `summon` persona applied, `summon` soul depth |
| `commands/evolve.md` — audit mode | `evolve audit` |
| `commands/evolve.md` — distil mode | `evolve distil` |
| `commands/evolve.md` — new mode | `evolve new` |
| `commands/evolve.md` — speciate mode | `evolve speciate` |

## Per-Persona Notes

One row per persona. The "Distil priority" column is filled in after running `evolve audit` — use the audit's Richness and SQS scores to rank.

| Persona | Directory | Mandatory fields present | Distil priority | Notes |
|---------|-----------|--------------------------|-----------------|-------|
| Vela (Scribe) | `scribe/` | Untested | — | — |
| Arden (Critic) | `critic/` | Untested | — | — |
| Finn (Scout) | `scout/` | Untested | — | — |
| Kira (Builder) | `builder/` | Untested | — | — |
| Echo (Examiner) | `examiner/` | Untested | — | — |
| Vale (Advocate) | `advocate/` | Untested | — | — |
| Keeper (Strategist) | `strategist/` | Untested | — | — |
| Artisan (Designer) | `designer/` | Untested | — | — |
| Helm (Release) | `release/` | Untested | — | — |
| Ward (Documentation) | `documentation/` | Untested | — | — |
| Pulse (Analytics) | `analytics/` | Untested | — | — |
| Rook (Adversary) | `adversarial/` | Untested | — | — |
| Loom (Synthesist) | `synthesis/` | Untested | — | — |
| Arc (Sequencer) | `temporal/` | Untested | — | — |
| Sable (Interrogator) | `interrogator/` | Untested | — | — |
| Trace (Debugger) | `debugger/` | Untested | — | — |
| Vault (Architect) | `architect/` | Untested | — | — |
| Lens (Verifier) | `verifier/` | Untested | — | — |
| Sage (Pedagogue) | `pedagogical/` | Untested | — | Added run 5 (2026-03-26) |
| Poise (Arbiter) | `negotiation/` | Untested | — | Added run 5 (2026-03-26) |
| Flint (Dialectician) | `dialectician/` | Untested | — | Added 2026-03-27 |
| Ink (Commit Curator) | `ink/` | Untested | — | Added 2026-03-27 |
| Quill (Intent Annotator) | `quill/` | Untested | — | Added 2026-03-27 |
| Vigil (Regression Sentinel) | `vigil/` | Untested | — | Added 2026-03-27 |
| Folio (API Documenter) | `folio/` | Untested | — | Added 2026-03-27 |
| Hone (Comment Editor) | `hone/` | Untested | — | Added 2026-03-27 |
| Amp (Signal Sharpener) | `amp/` | Untested | — | Added 2026-03-27 |

## Known Issues

_(None recorded yet — append as issues are found and fixed.)_

## Refinement Log

_(Empty — append after each test run with what was learned, what changed, and the date.)_
