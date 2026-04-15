## Phase 3 — Hypothesis Formation

**Persona: Keeper (Strategist)** — load `../../../personas/strategist/persona.md` now. If the file is not found, proceed without the persona and note its absence at the start of Phase 3 output. Identify as Keeper in all Phase 3 output when the persona is loaded.

Re-read the run log (Intent Anchor). Navigate to `## Phase 2 — Baseline` and focus on the metric scores and weakest candidates.

Based on the weakest metrics (seed and custom), form 3–5 hypotheses.

**The seed patterns (P1–P18) are starting points, not constraints.** If the workflow
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

#### P8 — Persona Rotation [corrective — applies when PPF < 100]
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

#### P10 — Failure Mode Registry
For any workflow with multiple conditional branches or error states: enumerate all
failure modes, verify each has an explicit recovery instruction in the command files,
and add recovery paths where missing. A failure mode without a recovery instruction
leaves the agent with no prescribed next action — it will improvise or halt.
Applicable to: multi-phase pipelines, data ingestion workflows, deployment scripts,
any workflow where phases can produce distinct error states.
Targets: RPC (↑)

#### P11 — File Role Stratification
For workflow directories that mix agent-instruction files with human-reference files:
add a classification step before scoring Directive Density and Instruction Token
Efficiency. Separate instruction files (primary audience: agent — contains imperative
verbs, phase logic, DO/DO NOT rules) from documentation files (primary audience:
human — contains reference tables, explanatory prose, help content). Score only
instruction files. Documentation token counts dilute both metrics and mask genuine
instruction quality.
Targets: DD (↑), ITE (↑)

#### P12 — Content Synchronisation Audit
Whenever an instruction file is updated with new named entries (new metrics, new
patterns, new phases, new steps), check and update every corresponding reference
or help file in the same session. Named entries in instruction files that lack a
matching help entry are invisible to users of the skill's help command and degrade
the trust chain between what the system does and what is documented.
Applicable to: any skill that maintains a parallel help/reference file alongside
its command files.
Targets: HCU (↑)

#### P13 — Corrective-Pattern Applicability Classification
In any pattern or rule library that distinguishes proactive patterns (apply to
improve things that are already working) from corrective patterns (apply only when
a specific measured condition is met), mark corrective patterns explicitly with
their trigger condition. When measuring pattern validation rate, exclude corrective
patterns from the denominator if their trigger condition has never been true.
A pattern that has never been applicable is not unvalidated — it is correctly
dormant. Conflating the two inflates perceived validation debt.
Applicable to: any workflow with a library of rules or patterns that grows over time.
Targets: PEV (↑)

#### P14 — Pre-Experiment Dependency Scan
Before applying the first experiment in any multi-hypothesis session, read all
pending (approved, not yet run) hypotheses and check whether any two modify the
same file. If overlap is found, note it in the log and run the overlapping
hypotheses sequentially with a metric re-check between them rather than applying
both at once. Without this scan, two simultaneous changes to the same file produce
non-attributable metric deltas — it becomes impossible to assign credit or blame
to either hypothesis.
Applicable to: any multi-hypothesis experiment session; any workflow optimisation
context where ≥2 changes are queued for concurrent application.
Targets: EIS (↑)

#### P16 — Generated Batch Script
For workflows that need to collect data for N items (version lookups, file reads,
checksums, local parsing, API calls, or any repeatable per-item operation): instead
of N sequential agent tool calls, generate a single script from the item list that
processes all N in one execution — parallelising where safe — and emits structured
output (e.g. a tab-separated table). The agent reads the table once rather than
issuing N individual actions. Reduces round trips, keeps intermediate results out of
the main context window, and makes the full item list auditable as generated code.
Applicable to: any phase that iterates over a manifest of items to collect external
or local data. Particularly effective when N > 5 or when intermediate results are
large and not needed for reasoning — only the final structured output is.
Targets: CLE (↑), ITE (↑)

#### P17 — Lookup Subagent Isolation
For workflows where a phase needs rich external or local data — web fetches, large
file reads, multi-source research — but the orchestrator only needs a compact
structured summary: route the lookup work into a disposable subagent. The subagent
fetches, reads, and processes; returns only a structured result table or brief. The
orchestrator context receives one tool result instead of N voluminous ones.
Distinct from P16 (Generated Batch Script): P16 eliminates round trips; P17
eliminates context pollution. The two compose — a subagent can execute a generated
batch script internally. Apply P17 when the raw lookup outputs are noisy, large, or
irrelevant to the orchestrator's reasoning (only the derived result matters).
Applicable to: web research phases, version-lookup phases, multi-source document
synthesis, any phase whose data-collection output would dominate the context window.
Targets: CLE (↑), ITE (↑)

#### P18 — Cross-File Structural Anchor
For workflows where one instruction file references a named section in another file
(e.g. "navigate to the `### Kotlin/Android primary sources` section heading in Phase 2"):
use the exact section heading name as the reference anchor rather than a content
description. Section headings are stable, searchable, and survive minor prose edits.
Content descriptions ("see the sources table in Phase 2") drift as files are updated
and become ambiguous when a file has multiple similar sections.
Applicable to: any multi-file workflow where phases cross-reference named sections
in other phase files, reference tables, or help documents.
Targets: HCU (↑), IAR (↓)

#### P15 — Measurement Accuracy Retrospective
When a metric has been estimated (rather than precisely counted) for two or more
consecutive runs at the same value, conduct a targeted re-audit to either confirm
the estimate or correct it. Estimated scores tend to accumulate hidden errors over
time: the scope may silently drift to include out-of-scope files, or the counting
method may differ from the metric's definition. A precise re-audit converts a
stable-but-unverified score into a ground-truth measurement.
Applicable to: any workflow where one or more metrics have not been directly
counted or measured from source files for ≥2 consecutive runs.
Targets: RI (↑, if scope correction reveals lower redundancy), any metric where
  persistent estimate diverges from the actual state

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
**Change proposed:** <specific: swap to [existing persona], or run `/personas evolve speciate <name>`, or run `/personas evolve distil <name> from <run-log>`, or run `/personas evolve new <description>`>
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
type), note it in the run log under `## Novel Patterns Discovered`. These
candidates can be proposed for inclusion in the seed library.

Format these as a **Recommendation Brief** — do not ask open-ended questions. State
each recommendation with its evidence and predicted outcome.

```
## Recommendation Brief

Based on baseline measurement, the following experiments are queued.

1. <name> — <one-sentence summary of problem and proposed change>
2. <name> — <one-sentence summary>
...
```

Do not use metric abbreviations or hypothesis IDs in the brief. Refer to metrics by full name (e.g., "Directive Density", "Context Loading Efficiency") and describe each experiment in plain language.

### Self-Audit

Before proceeding to experiments, audit the hypothesis list for intent and accuracy:

1. **Intent check** — does each hypothesis target a metric that scored below 100 in the current baseline? Remove any hypothesis targeting a metric already at 100 (no measurable gap to address). Note removals in the run log.
2. **Coverage check** — compute the projected composite score: `(baseline_weighted_sum + sum_of_predicted_improvements) / (total_weight_units × 100) × 100`. If this projection clears **> 95**, the list is sufficient. If below 95 and the audit reveals uncovered gaps, add further hypotheses to close them. The `baseline_weighted_sum` and `total_weight_units` are in the `## Phase 2 — Baseline` section of the run log.
3. **Gap fill** — for any measured metric still below 80 with no hypothesis targeting it, add one now. Prefer patterns from the seed library; invent novel ones where none fit.

Write the final hypothesis list (post-audit) to the run log under `## Phase 3 — Hypotheses`.
Then update the `### Hypotheses` table in the SUMMARY block with the IDs and descriptions (outcomes left as "pending").

If zero hypotheses remain after the audit, write: "No hypotheses survived audit — no experiments to run. Proceeding to report." Read `commands/phases/p5-report.md` to continue.

Otherwise, read `commands/phases/p4-experiments.md` to continue.
