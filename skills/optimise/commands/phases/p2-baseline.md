## Phase 2 — Baseline Measurement

**Persona: Pulse (Analytics)** — load `../../../personas/analytics/persona.md` now. If the file is not found, proceed without the persona and note its absence at the start of Phase 2 output. Identify as Pulse in all Phase 2 output when the persona is loaded.

Re-read `research-log.md` (Intent Anchor).

For each metric below, state the methodology, run the measurement, and record the
result. For metrics that do not apply based on the Phase 1 feature inventory, write
"SKIP — <reason>" and do not score them.

### M1 — Intent-to-Output Traceability (IOT) [applies: multi-phase pipeline]
**Apply if:** Does the workflow define two or more sequential phases where each phase produces an artifact consumed by the next? (yes = apply, no = skip)
Methodology: For each phase in each command file, count whether the phase explicitly
re-reads or references an artifact produced by a prior phase (plan file, input file,
log entry, etc.). IOT = phases_with_explicit_prior_artifact_read / total_phases.

### M2 — Directive Density (DD) [universal]
Methodology: Before scoring, classify each command file by role:
- **Instruction file**: primary purpose is to direct the agent — contains imperative verbs,
  numbered steps, DO/DO NOT lists, phase logic (e.g. `p1-audit.md`, `optimise.md`)
- **Documentation file**: primary purpose is to inform a human reader — contains reference
  tables, explanatory prose, metric definitions, or index content without agent directives
  (e.g. `help.md`, `CHANGELOG.md`, `VERSION.md`)
Score only instruction files. Skip documentation files and note them as "excluded (documentation)".
Count DO/DO NOT items and other imperative directives across all instruction command files.
Divide by total tokens in those files / 100. DD = directives / (tokens / 100).
Normalise: (DD / 2.0) × 100, cap at 100.

### M3 — Instruction Ambiguity Rate (IAR) [universal]
Methodology: Scan all instructions for weak modal verbs with no scope qualifier:
"should", "may", "might", "consider", "try to" (without an "if X" condition). Count
these as ambiguous. IAR = ambiguous_instructions / total_instructions.
A **scope qualifier** is an `if X` condition, a domain restriction, or a specific
named target. Scoped (not ambiguous): *"should be recorded if the target is inside a
git repo"*. Unscoped (ambiguous): *"should be recorded"*. Descriptive uses of
"may/can" (stating a possibility, not an instruction) do not count.
Normalise: 100 − IAR%.

### M4 — Wiring Completeness Score (WCS) [applies: persona system]
**Apply if:** Does the workflow reference or load any persona.md files? (yes = apply, no = skip)
Methodology: List all persona files that exist. For each persona, check whether it is
explicitly loaded in at least one command that performs the work it is suited for.
WCS = wired_personas / total_personas.

### M5 — Redundancy Index (RI) [universal]
Methodology: Identify instructions or rules that appear in more than one file with
substantially the same meaning. RI = redundant_instruction_instances / total_instructions.
Normalise: 100 − RI%.

### M6 — AC Concreteness (ACC) [universal]
Methodology: Find all acceptance criteria, stop conditions, or "done when" statements.
For each, assess: is it measurable without interpretation (concrete), or does it
require subjective judgment (vague)? ACC = concrete_ACs / total_ACs.
Concrete: *"normalised score improved by ≥3 points"*, *"file count is 6"*, *"exit code
is 0"*. Vague: *"the output quality is acceptable"*, *"improvement is meaningful"*,
*"the result looks right"*.

### M7 — Subagent Alignment Score (SAS) [applies: subagent invocations]
**Apply if:** Does any command file contain an explicit `Agent` tool call or a "spawn subagent" directive? (yes = apply, no = skip)
Methodology: For each subagent invocation, check whether the task delegated is
appropriate for a subagent (isolated, parallelisable, no shared mutable state without
explicit guards). SAS = appropriate_invocations / total_invocations.

### M8 — Human Touchpoint Count (HTC) [universal]
Methodology: Count every point in a full end-to-end run where a human must provide
input or approval (not counting the initial invocation). HTC = count of touchpoints.
Normalise: max(0, 100 − (HTC / 20) × 100).

### M9 — Context Decay Resilience (CDR) [applies: multi-session orchestration]
**Apply if:** Does any phase block include a `STOP`, `PAUSE`, or session-boundary instruction where a new agent session may begin? (yes = apply, no = skip)
Methodology: For each session boundary (points where a new agent session begins),
check whether the command explicitly re-reads the original intent artifact before
proceeding. CDR = session_transitions_with_reanchor / total_session_transitions.

### M10 — Context Loading Efficiency (CLE) [universal]
Methodology: For each phase in each command file, identify what files are loaded and
estimate what percentage of those tokens are actually relevant to the work of that
phase. CLE = relevant_tokens_loaded / total_tokens_loaded (averaged across phases).

### M11 — Parallelisation Safety Score (PSS) [applies: parallel execution]
**Apply if:** Does any command file instruct the agent to run two or more tasks concurrently, or does it use worktree/parallel phase blocks? (yes = apply, no = skip)
Methodology: For each mutation (write, move, delete) that could occur in a parallel
context, check whether it has: (a) explicit guard against concurrent access, and
(b) a defined release mechanism. Full credit = both guards; partial = one guard.
PSS = (full_credit + 0.5 × partial_credit) / total_parallel_mutations.

### M12 — Information Freshness Score (IFS) [applies: cached artifacts]
**Apply if:** Does the workflow write an artifact in one phase and read it again in a later phase (or later session)? (yes = apply, no = skip)
Methodology: For each artifact that is read after being written in a prior session,
check whether there is an explicit TTL policy or freshness check before use.
IFS = artifacts_with_freshness_policy / total_inter-session_artifacts.

### M13 — Instruction Token Efficiency (ITE) [universal]
Methodology: Apply the same file role classification used in M2 (instruction vs.
documentation files). Score only instruction files — documentation files are excluded
because reference prose and explanatory content are not padding in that context.
For each instruction command file, scan for padding tokens — filler phrases that
consume tokens without adding constraint or information. Filler categories:
- **Throat-clearing preamble**: "Please make sure to", "It is important that",
  "You should always remember to", "Note that", "Be aware that"
- **Redundant intensifiers**: "very", "really", "quite", "always" (where already implied)
- **Decorative structure**: divider lines (---) used more than once per logical section,
  duplicate headers that restate the section title in the first sentence
- **Narrative restatement**: prose that describes what the workflow does rather than
  constraining how (detectable as sentences with no imperative verb and no condition)
Count padding_tokens and total_tokens per file (estimate tokens as characters / 4).
ITE = 1 − (padding_tokens / total_tokens), averaged across all instruction command files.
Direction: ↑ higher is better (less padding = higher efficiency).
Normalise: ITE × 100.

### M14 — Persona-Phase Fit Score (PPF) [applies: persona system]
**Apply if:** Does the workflow reference or load any persona files, or does any phase include a persona load directive? (yes = apply, no = skip)
Methodology:
1. List all phases in the workflow and identify each phase's primary cognitive demand:
   - **Analysis / measurement**: systematic enumeration, quantitative scoring, pattern detection → ideal fit: analytics-style persona
   - **Strategy / planning**: prioritisation, synthesis, forward-projection → ideal fit: strategist-style persona
   - **Critique / adversarial review**: fault-finding, challenge, stress-testing → ideal fit: critic-style persona
   - **Reporting / documentation**: neutrality, comprehensiveness, clarity → neutral observer is appropriate; loading any persona here risks bias
   - **Creative generation**: divergent thinking, novelty-seeking → needs a creative or expansive persona; a critic or analyst here is a mismatch
2. Before scoring, apply the persona staleness check:
   - **Missing file**: if the phase's load directive references a `persona.md` that does not exist at the stated path, score that phase as mismatch (0.0) and record: "Broken reference — persona file not found." Do not attempt to infer what the persona would have been.
   - **Speciated parent**: if the loaded persona's `soul.md` has no `## Origin` section but sibling directories contain personas whose Origin names this one as parent, note it as a staleness flag: "Possible superseded parent — more specific variants exist." Score the phase as partial (0.5) even if the cognitive fit is otherwise good, because the parent is likely less potent than the available specialization.
3. For each phase where the persona file exists, determine fit:
   - **Full fit (1.0)**: assigned persona's core trait directly matches the cognitive demand, OR the phase is a reporting/neutral phase and no persona is assigned
   - **Partial fit (0.5)**: persona's traits are adjacent but not optimal (e.g., strategist on a measurement phase), OR a persona is assigned to a neutral phase but does not obviously conflict, OR the phase uses a speciated parent when a more specific variant exists
   - **Mismatch (0.0)**: persona's traits actively work against the phase's purpose (e.g., critic on a generative brainstorm), OR a high-value phase has no persona and a clear one exists, OR the persona file is missing
4. Also check persona depth using the M15 Richness Rubric: a persona scoring <71% (i.e., missing both Unique Talent and Failure Mode) is functionally decorative regardless of its other fields — its phase assignment scores partial regardless of cognitive alignment.
PPF = sum(per_phase_scores) / total_phases_assessed
Direction: ↑ higher is better (full cognitive fit for all phases = 100).
Normalise: PPF × 100.

### M15 — Persona Richness Score (PRS) [applies: persona system]
**Apply if:** Does the workflow reference or load any persona files? (yes = apply, no = skip)
Methodology: For each persona used by the workflow, locate its `persona.md` and
`soul.md` files and score against the Richness Rubric:

| Field | File | Points |
|-------|------|--------|
| Purpose defined (1–2 sentences) | persona.md | 1 |
| DO list with ≥3 concrete, actionable rules | persona.md | 1 |
| DO NOT list with ≥2 concrete rules | persona.md | 1 |
| When to summon defined | persona.md | 1 |
| Failure Mode section present | persona.md | 2 |
| soul.md present | soul.md | 1 |
| Essence (1–2 sentence distillation) | soul.md | 1 |
| Core Truths ≥3 | soul.md | 1 |
| Opinions ≥2 | soul.md | 1 |
| Contradictions ≥1 | soul.md | 1 |
| Voice description present | soul.md | 1 |
| Unique Talent section present | soul.md | 2 |

Maximum: 14 points per persona.
PRS = average(points / 14) across all personas loaded by this workflow.
Direction: ↑ higher is better (all rubric fields filled = 100; missing Unique Talent + Failure Mode = ≤71).
Normalise: PRS × 100.

A persona missing Failure Mode or Unique Talent scores at most 10/14 (71%) regardless of
how well other fields are filled. These are the fields that determine whether a persona
actually shifts behaviour or is merely decorative.

### Custom Metric Discovery

**This step is mandatory.** After scoring M1–M15, Pulse examines the workflow for
quality dimensions not captured by any seed metric.

Ask: *What could go wrong in this specific workflow that no seed metric would catch?*

For each gap found, define a custom metric:

```markdown
### MX<N> — <Name> [custom]
**Measures:** <what quality dimension>
**Why seeds miss it:** <which M1-M13 gap this fills>
**Methodology:** <exact counting or scoring method>
**Direction:** ↑ higher / ↓ lower is better
**Weight:** <1× or 2× — use 2× if this dimension is critical to the workflow's purpose>
**Normalisation:** <formula>
```

Heuristics for finding custom metrics — work through all of these before stopping:
- What does this workflow *produce*? Does any seed measure output quality? If not, define one.
- What is the most common failure mode for this *type* of workflow? Is it measured?
- Are there cross-file consistency requirements (naming, schema, version alignment)? Measure them.
- Is there a "trust chain" — files that depend on other files being correct? Measure completeness.
- Does the workflow have escape hatches / fallback paths? Are they tested?
- What would a user of this workflow complain about that no metric here would detect?
- Is there a concept of "completeness" specific to this domain (e.g., all cases handled, all roles covered, all states reachable)?
- What would an expert reviewer flag on first read that isn't currently measured?

**Minimum:** propose at least 5 new custom metrics per run. Casting a wide net costs nothing —
a metric that turns out to score well is still useful evidence. If you genuinely cannot reach 5,
state explicitly why each remaining gap is not measurable.

**Moonshot requirement:** at least one of your custom metrics must be a *moonshot* — an
unconventional or ambitious idea that might not obviously apply but could reveal a surprising
insight if it does. Push past the obvious. Examples of moonshot thinking:
- Measuring something that has never been measured in this type of workflow before
- Treating an implicit assumption in the workflow as an explicit, scorable property
- Borrowing a measurement concept from a completely different domain (e.g., applying a
  reliability-engineering concept to a documentation workflow, or a usability heuristic to
  a data pipeline)
- Quantifying something qualitative that the workflow currently treats as unmeasurable

Label the moonshot metric `[custom, moonshot]` so it is easy to identify.

Write custom metric definitions to `research-log.md` under `## Custom Metrics — <date>`.
Custom metrics persist and are re-applied on future runs of `/optimise` on the same target.

### Pre-Defined MX Outcome Metrics (MX-OQ series)

<!-- WHY these metrics exist: M1–M15 measure workflow instruction quality (coverage, clarity,
     persona fit) but none measure whether the workflow produces good outcomes. The MX-OQ
     series adds an outcome-signal layer by reading quality envelopes accumulated across
     archived subjects. They feed the Phase 3 hypothesis step for causal attribution.
     Satisfies plan §6 (Req 6.1–6.8) and TASK-006. -->

The following MX-OQ metrics are pre-defined and must be evaluated during custom metric
discovery for any workflow that produces `.kanban/` subjects. They read from quality
envelope files at `.kanban/.archive/*/00-quality-*.md`. Each metric:

- Skips with an explicit reason if the applicable data does not exist
- Notes "insufficient sample — treat as directional only" if fewer than 3 archived subjects
  have relevant data
- Is advisory only — these metrics inform optimise hypotheses but do not gate anything

These metrics are designed to feed the hypothesis phase (Phase 3) for causal attribution.
When reviewing MX-OQ results alongside M1–M15, form hypotheses about which structural
factors correlate with outcome degradation — e.g. whether a particular persona produces
lower acceptance rates, or whether plan instability correlates with poor session
satisfaction. No automated attribution is required; the causal analysis is the
responsibility of the optimise hypothesis phase.

#### MX-OQ1 — Interview Acceptance Rate [custom]

<!-- WHY weight 2×: directly measures whether the workflow's recommendations are trusted by
     users; low acceptance signals a calibration or communication failure in the interview
     phase that no structural metric would catch. -->

**Applies when:** `.kanban/.archive/` contains at least one `00-quality-*.md` file with
an `## Interview Signals` section.
**Skip condition:** If no such files exist, write "SKIP — no Interview Signals data in
`.kanban/.archive/*/00-quality-*.md`."
**Methodology:** Across all archived quality envelopes, sum approved, overridden, and
rejected counts from each `## Interview Signals` block. Acceptance Rate = approved /
(approved + rejected). Overrides are excluded from the ratio — they represent valid
alternatives, not failures.
**Direction:** ↑ higher is better
**Normalisation:** rate × 100
**Weight:** 2×

#### MX-OQ2 — First-Pass Review Rate [custom]

<!-- WHY weight 2×: directly measures implementation quality at review time; a low
     first-pass rate means rework cycles are the norm, which compounds across the
     subject's lifetime. No seed metric captures this. -->

**Applies when:** `.kanban/.archive/` contains at least one archived subject with ticket
files in `08-done/` that have `consecutive_failures` frontmatter.
**Skip condition:** If no archived `08-done/` tickets with `consecutive_failures` exist,
write "SKIP — no archived done-tickets with consecutive_failures data found."
**Methodology:** Across all archived tickets in `.kanban/.archive/*/08-done/`, count
tickets where `consecutive_failures = 0` (passed first review). Rate = zero-failure
tickets / total archived tickets.
**Direction:** ↑ higher is better
**Normalisation:** rate × 100
**Weight:** 2×

#### MX-OQ3 — Plan Stability Rate [custom]

<!-- WHY weight 1×: plan stability is a leading indicator of requirement clarity and
     interview quality; frequent moderate/significant drift suggests the plan phase is
     under-constrained, but the causal chain is indirect enough that this carries less
     weight than direct outcome signals. -->

**Applies when:** `.kanban/.archive/` contains at least one `00-quality-*.md` with a
`## Plan Drift` section.
**Skip condition:** If no `## Plan Drift` data exists, write "SKIP — no Plan Drift
sections found in `.kanban/.archive/*/00-quality-*.md`."
**Methodology:** Across all archived quality envelopes with drift data, count subjects
where drift magnitude is "None" or "Minor". Rate = stable subjects / total subjects
with drift data.
**Direction:** ↑ higher is better
**Normalisation:** rate × 100
**Weight:** 1×

#### MX-OQ4 — Session Satisfaction Rate [custom]

<!-- WHY weight 1×: session ratings are self-reported and subjective, making this a
     softer signal than review or acceptance data, but still useful for surfacing
     systemic friction that no structural metric captures. -->

**Applies when:** `.kanban/.archive/` contains at least one `00-quality-*.md` with a
`## Work Sessions` section containing at least one rated session entry.
**Skip condition:** If no rated session data exists, write "SKIP — no rated Work
Sessions found in `.kanban/.archive/*/00-quality-*.md`."
**Methodology:** Across all rated sessions in all archived quality envelopes, count
"yes" ratings. Rate = yes / (yes + partially + no). Skipped sessions (entries absent
or recorded as skip) are excluded entirely.
**Direction:** ↑ higher is better
**Normalisation:** rate × 100
**Weight:** 1×

#### MX-OQ5 — PR Critique Rate [custom]

<!-- WHY weight 2×: rework cycles are a direct cost — each PR rejection adds latency
     and re-implementation effort. Weight 2× because this is as close to a measurable
     quality failure as this workflow produces. Inverted for composite because lower
     rework is better. -->

**Applies when:** `.kanban/.archive/` contains at least one `00-quality-*.md` with a
`## PR Responses` section.
**Skip condition:** If no `## PR Responses` data exists, write "SKIP — no PR Responses
sections found in `.kanban/.archive/*/00-quality-*.md`."
**Methodology:** Across all archived quality envelopes, sum total PR response events
(count of `### Response` entries in all `## PR Responses` sections). Divide by the
total number of archived tickets (from `.kanban/.archive/*/08-done/`) to get average
rework cycles per ticket.
**Direction:** ↓ lower is better (fewer rework cycles = cleaner initial implementation)
**Normalisation (for composite):** score = max(0, 100 − (rate × 50)), where rate is
average rework cycles per ticket. Cap at 2 cycles for normalisation — a rate of 2+
cycles per ticket maps to 0%.
**Weight:** 2×

### Pre-Defined Custom Metrics (Pattern Target Series)

<!-- WHY these metrics exist: Patterns P10, P12, P13, and P14 each name a target metric
     that is not in M1-M15 or the MX-OQ series. Without definitions, these targets are
     unverifiable — pattern application cannot be attributed to a measured improvement.
     These definitions close that attribution gap. -->

The following metrics are pre-defined and must be evaluated when the corresponding
pattern has been applied to the workflow in any prior run. They read from the
research-log.md for prior run data. If the corresponding pattern has never been applied:
write "SKIP — pattern <P-number> has not been applied to this target."

#### HCU — Help Content Currency [custom, target of P12]

<!-- WHY weight 1×: measures documentation trust chain completeness; important but
     indirectly affects run quality compared to outcome signals. -->

**Applies when:** The workflow has a parallel help or reference file (e.g., `help.md`)
alongside its instruction command files.
**Skip condition:** If no help/reference file exists, write "SKIP — no parallel help
file found."
**Methodology:** Enumerate all named entries in instruction files: metrics (M1–M15 plus
any custom metrics defined in `research-log.md`), design patterns (P1–P-max), and any
other named rules or phases. Count how many have a corresponding detail entry in the
help/reference file. Rate = documented / total named entries.
**Direction:** ↑ higher is better
**Normalisation:** rate × 100
**Weight:** 1×

---

#### RPC — Recovery Path Completeness [custom, target of P10]

<!-- WHY weight 1×: measures whether failure states have prescribed recovery paths;
     important for robustness but narrower in impact than outcome signals. -->

**Applies when:** The workflow has one or more conditional branches (TTL tiers, skip
conditions, error states, loop termination cases).
**Skip condition:** If the workflow has no conditional branches, write "SKIP — no
conditional branches found."
**Methodology:** Enumerate all conditional branches across all phase files. For each,
check whether an explicit prescribed next action is stated (not "use judgment"). Count
branches with explicit recovery / total branches. Rate = covered / total.
**Direction:** ↑ higher is better
**Normalisation:** rate × 100
**Weight:** 1×

---

#### PEV — Pattern Experimental Validation Rate [custom, target of P13]

<!-- WHY weight 1×: measures whether the pattern library is evidence-backed; relevant to
     the workflow's own improvement loop but indirect compared to direct outcome data. -->

**Applies when:** The workflow has a design pattern library (P1–P-max) and at least one
confirmed experiment in `research-log.md`.
**Skip condition:** If no experiment results exist in `research-log.md`, write "SKIP —
no confirmed experiment data found."
**Methodology:** From `research-log.md`, count patterns that were used in at least one
confirmed hypothesis (i.e., listed in a confirmed "Pattern applied:" field). Count
applicable patterns: all patterns whose trigger condition has been true at least once
in the workflow's run history (corrective patterns whose condition has never fired are
excluded per P13). Rate = validated / applicable.
**Direction:** ↑ higher is better
**Normalisation:** rate × 100
**Weight:** 1×

---

#### EIS — Experiment Isolation Score [custom, target of P14]

<!-- WHY weight 1×: measures whether experiment results are attributable; affects
     measurement accuracy rather than directly affecting outcome quality. -->

**Applies when:** The workflow has ≥2 hypotheses in any Phase 4 session.
**Skip condition:** If no Phase 4 session has had ≥2 hypotheses, write "SKIP — no
multi-hypothesis sessions found."
**Methodology:** From `research-log.md`, count Phase 4 sessions with ≥2 approved
hypotheses. For each session, check: (a) was a pre-experiment dependency scan recorded
(Step 0 present in the log)? (b) were overlapping hypotheses noted and run sequentially
with a re-check? Rate = sessions with full isolation protocol / sessions with ≥2
hypotheses.
**Direction:** ↑ higher is better
**Normalisation:** rate × 100
**Weight:** 1×

---

### Seed Metric Weights Reference

Use this table when building the composite. All weights are fixed; do not adjust them.

| Metric | Weight |
|--------|--------|
| Intent-to-Output Traceability (M1) | 2× |
| Directive Density (M2) | 1× |
| Instruction Ambiguity Rate (M3) | 1× |
| Wiring Completeness Score (M4) | 1× |
| Redundancy Index (M5) | 1× |
| AC Concreteness (M6) | 2× |
| Subagent Alignment Score (M7) | 1× |
| Human Touchpoint Count (M8) | 2× |
| Context Decay Resilience (M9) | 2× |
| Context Loading Efficiency (M10) | 2× |
| Parallelisation Safety Score (M11) | 1× |
| Information Freshness Score (M12) | 2× |
| Instruction Token Efficiency (M13) | 1× |
| Persona-Phase Fit Score (M14) | 1× |
| Persona Richness Score (M15) | 1× |

Custom metrics define their own weights in their `**Weight:**` annotation. MX-OQ series weights are already annotated in their definitions above.

### Composite Calculation

```
Seed metrics applied: <list using full names>
Seed metrics skipped: <list with reasons>
Custom metrics: <list using full names>

| Metric | Source | Raw | Normalised | Weight | Weighted |
|--------|--------|-----|-----------|--------|----------|
| <Full Metric Name> | seed / custom |  |  |  |  |
| TOTAL  |        |     |           | <N>×   | <sum> / (<N>×100) |

Composite: <sum> / (<N> × 100) × 100 = <X>%
```

Write the full baseline table to `research-log.md` under `## Baseline — <date>`.
Note the 3 weakest metrics (candidates for Phase 3 hypotheses) and the 3 strongest.

When Phase 2 is complete, read `commands/phases/p3-hypothesize.md` to continue.
