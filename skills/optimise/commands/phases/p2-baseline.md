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
2. For each phase, determine fit:
   - **Full fit (1.0)**: assigned persona's core trait directly matches the cognitive demand, OR the phase is a reporting/neutral phase and no persona is assigned
   - **Partial fit (0.5)**: persona's traits are adjacent but not optimal (e.g., strategist on a measurement phase), OR a persona is assigned to a neutral phase but does not obviously conflict
   - **Mismatch (0.0)**: persona's traits actively work against the phase's purpose (e.g., critic on a generative brainstorm), OR a high-value phase has no persona and a clear one exists
3. Also check persona depth: for each persona file that is loaded, does it define at minimum — name, core trait/cognitive style, what it emphasises, what it de-emphasises, tone? A persona file missing two or more of these fields is functionally decorative and scores partial.
PPF = sum(per_phase_scores) / total_phases_assessed
Normalise: PPF × 100.

### Custom Metric Discovery

**This step is mandatory.** After scoring M1–M14, Pulse examines the workflow for
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
