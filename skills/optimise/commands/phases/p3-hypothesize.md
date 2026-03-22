## Phase 3 — Hypothesis Formation

**Persona: Keeper (Strategist)** — load `../../../personas/strategist/persona.md` now. If the file is not found, proceed without the persona and note its absence at the start of Phase 3 output. Identify as Keeper in all Phase 3 output when the persona is loaded.

Re-read `research-log.md` (Intent Anchor). Focus on the baseline section.

Based on the weakest metrics (seed and custom), form 3–5 hypotheses.

**The seed patterns (P1–P7) are starting points, not constraints.** If the workflow
has a problem that no seed pattern addresses, invent the fix. Novel hypotheses are
expected and valuable — they may become patterns for future runs.

### Design Patterns

#### P1 — Intent Anchor Blocks
At every phase transition, the orchestrator re-reads the original intent artifact
before proceeding. Prevents context drift across long sessions.
Targets: CDR (↑), IOT (↑)

#### P2 — Staleness TTL Policies (3-tier)
Every artifact that can go stale carries an explicit TTL policy:
- **Tier A — Regenerate**: artifact must be rebuilt before use if older than threshold
- **Tier B — Load-with-caveat**: artifact is usable but model must flag staleness to user
- **Tier C — No-TTL**: artifact is canonical and does not expire (e.g. original input)
Targets: IFS (↑)

#### P3 — Progressive Disclosure
Phase-scoped context loading: each phase block lists only the files it needs. No
phase loads the full workflow corpus. Context is loaded on demand, not preloaded.
Targets: CLE (↑), HTC (↓)

#### P4 — Recommendation Brief
Replace open-ended human Q&A interviews with a model-formed recommendation brief.
The model assembles evidence, states a recommended action per item, and asks the
human to approve/reject per item rather than answer open questions.
Targets: HTC (↓), IAR (↓)

#### P5 — Claim Registry
For workflows with parallel or concurrent execution: a shared registry file records
which agent/phase currently holds a write lock on each artifact. All mutations check
the registry before writing and release the lock on completion.
Targets: PSS (↑)

#### P6 — Symmetric Outcome Thresholds
For workflows with multi-tier outcome classification (pass/warn/fail, etc.): define
concrete numeric boundaries for every tier, not just the passing case. Use the
confirmed/pass threshold as the anchor; define lower tiers relative to it.
Targets: ACC (↑)

#### P7 — Binary Applicability Gates
For workflows with conditional instructions or optional steps: replace vague
feature-presence conditions ("X present") with a single yes/no question whose answer
is deterministically derivable from an earlier phase's output.
Targets: IAR (↓), ACC (↑)

#### P8 — Persona Rotation
For workflows with a persona system where any phase scores below full fit on
Persona-Phase Fit: try an alternative persona on that phase (drawn from existing
persona files or newly invented) and compare output quality markers — concreteness,
coverage, and appropriate challenge level. When no existing persona fits the cognitive
demand of a phase, invent one: define name, core trait, cognitive style, what it
emphasises, what it de-emphasises, and tone. Store it in the workflow's personas
directory alongside existing personas. This pattern applies both to improving fit
on existing assignments and to adding personas to phases that are currently unassigned
but would benefit from a specific cognitive style.
Targets: PPF (↑)

#### P9 — Persona Speciation
For workflows where personas score below 85 on Persona Richness (missing Unique
Talent, Failure Mode, or other rubric fields), or where the Phase-Phase Fit audit
reveals a cognitive demand no existing persona covers: run `/personas evolve` to
create differentiated variants or fill the gap. Speciation produces new, named
personas that are narrower and more potent than their parents — not renamed versions
of existing archetypes. Distillation sharpens existing personas using evidence from
real runs: observed behaviors that consistently produced better outputs are crystallized
as new DO rules; thin soul fields are deepened using patterns the run revealed.
Targets: PRS (↑), PPF (↑)

For each hypothesis, use the appropriate template:

**Standard hypothesis:**
```
### H<N> — <short name>
**Problem observed:** <what the metric score reveals about the workflow>
**Change proposed:** <specific, actionable change to one or more files>
**Targets:** <full metric names and predicted direction — include custom metrics>
**Predicted improvement:** <estimated delta in normalised score>
**Pattern applied:** <full pattern name, or "novel — <name>">
**Risk level:** low / medium / high
**Risk note:** <what could go wrong; what to check if disconfirmed>
```

**Persona experiment** (use when pattern is Persona Rotation or Persona Speciation):
```
### H<N> — <short name> [persona experiment]
**Problem observed:** <what Persona-Phase Fit or Persona Richness score reveals>
**Phase targeted:** <which phase, and its current persona or lack thereof>
**Change type:** rotation / speciation / distillation / gap-fill
**Change proposed:** <specific: swap to [existing persona], or run `/personas evolve speciate <name>`, or run `/personas evolve distil <name> from research-log.md`, or run `/personas evolve new <description>`>
**Quality markers:** <define exactly 3 observable outputs to check in the spot-check:
  1. <e.g. "does the new persona catch gaps that the old one would accept?">
  2. <e.g. "does output include concrete file:line citations rather than vague references?">
  3. <e.g. "are all N items in the phase scope addressed, or does the persona sample selectively?">
>
**Targets:** <full metric names and predicted direction>
**Predicted improvement:** <estimated delta>
**Pattern applied:** Persona Rotation / Persona Speciation
**Risk level:** low / medium / high
**Risk note:** <e.g. "new persona may suppress output the downstream phase depends on">
```

Quality markers must be defined at hypothesis time — not left open-ended. They are what Phase 4 uses to score the spot-check. Choose markers that would be observable in a single-response task sample.

When forming novel hypotheses, ask:
- Is there a structural change (split, merge, reorder) that would improve a custom metric?
- Is there a workflow assumption that is never validated? Add a validation step.
- Is there output that is produced but never verified? Add a verification gate.
- Are all phases with meaningful cognitive demands assigned a persona? Would adding one improve output consistency or depth?
- Is any assigned persona a poor fit for its phase's cognitive demands? Would a different existing persona, or a newly invented one, produce more grounded outputs?
- Is there a pattern in *what fails* vs. *what succeeds* in this workflow?

If a confirmed novel hypothesis generalises (would help other workflows of the same
type), note it in `research-log.md` under `## Novel Patterns Discovered`. These
candidates can be proposed for inclusion in the seed library.

Format these as a **Recommendation Brief** — do not ask open-ended questions. State
each recommendation with its evidence and predicted outcome, then ask for a binary
approve/skip decision per hypothesis.

Present the brief to the human:

```
## Recommendation Brief

Based on baseline measurement, I recommend the following experiments.
Please approve or skip each one.

1. <name> — <one-sentence summary of problem and proposed change>: [approve / skip]
2. <name> — <one-sentence summary>: [approve / skip]
...

Reply with your decisions to proceed.
```

Do not use metric abbreviations or hypothesis IDs in the brief shown to the user. Refer to metrics by full name (e.g., "Directive Density", "Context Loading Efficiency") and describe each experiment in plain language.

**STOP. Wait for human approval. Do not proceed to Phase 4 until decisions are received.**

If the human skips all hypotheses, proceed directly to Phase 5. Write a note to
`research-log.md`: "All hypotheses skipped — no experiments run. Proceeding to report."
Read `commands/phases/p5-report.md` to continue. Phase 5 should reflect zero experiments.

Write the full hypothesis list to `research-log.md` under `## Experiments — <date>`.

When human approval is received, read `commands/phases/p4-experiments.md` to continue.
