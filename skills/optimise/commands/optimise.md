---
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch, Agent
model: claude-opus-4-6
argument-hint: "<path-to-target-workflow-directory>"
---

<!-- PROGRESSIVE DISCLOSURE: Load and execute only the phase block you are currently in.
     Do not read ahead into later phases. Each phase's inputs are produced by the previous
     phase — loading them early defeats progressive disclosure and inflates context.
     Personas follow the same rule — load only the persona for the current phase. -->

---

## DO

- Derive the target directory from `$ARGUMENTS`; fail explicitly if not provided or not found
- Apply only the metrics that are applicable to the target workflow; skip others with an explicit reason
- Compute the composite using only applied metrics in both numerator and denominator
- Write all measurement and experiment data to `research-log.md` in the target directory

- Create a git branch before making any changes if the target is inside a git repo
- Commit each confirmed change separately with a conventional commit message
- Present the Recommendation Brief and wait for human approval before beginning experiments
- Re-read `research-log.md` at the start of each phase (Intent Anchor — pattern P1)

## DO NOT

- Begin Phase 4 without explicit human approval of the hypothesis brief from Phase 3
- Modify files outside the target workflow directory (except to update `research-log.md`)
- Apply a hypothesis that was rejected or not listed in the approved brief
- Skip the pre-change and post-change metric recordings for any experiment
- Conflate multiple hypotheses into a single change — one hypothesis, one change, one commit
- Treat a partial improvement as confirmed — record it as "partial" and note the delta
- Run destructive git operations (force push, reset --hard) under any circumstances
- Load the full corpus of target files in a single phase — use progressive disclosure

---

## Phase 1 — Audit Target

**Persona: none (neutral observer)**

If `research-log.md` exists in the target directory, apply the 3-tier TTL policy before reading it (Intent Anchor):
- **Tier A — Regenerate**: the log's `**Target:**` header does not match `$ARGUMENTS` path → archive the existing log to `research-log-archived-<date>.md`, start a fresh log.
- **Tier B — Load-with-caveat**: target matches AND log date is >7 days old → load but flag to the user: "Warning: research-log.md is from <date> — scores may be stale."
- **Tier C — Use as-is**: target matches AND log is ≤7 days old → read and proceed.
If `research-log.md` does not exist, proceed without reading.

Derive the target directory path from `$ARGUMENTS`. If `$ARGUMENTS` is empty or the
path does not exist, stop and print:

> No target directory provided. Usage: /optimise <path-to-workflow-directory>

Then exit without touching any files.

Inventory the target directory:

1. List all files with `Glob` — record the full file list
2. For each file, note: filename, rough token estimate (characters / 4), role classification
   - **Command files**: files under a `commands/` subdirectory or named as imperative verbs
   - **Support files**: SKILL.md, AGENTS.md, VERSION.md, CHANGELOG.md, persona files, logs
3. Identify whether the workflow has:
   - A multi-phase pipeline (sequential phases across multiple command files)
   - A persona system (persona.md files or persona references in commands)
   - Subagent invocations (Agent tool calls or spawn directives)
   - Multi-session orchestration (explicit session boundaries or handoff files)
   - Parallel or concurrent execution (parallel phase blocks, worktree patterns)
   - Cached or persisted artifacts (files written in one session and read in another)
4. Record the feature presence/absence — this determines which metrics apply in Phase 2

Write a brief audit summary to `research-log.md`:

```markdown
## Audit — <date>

**Target:** <path>
**Files:** <count> total (<command count> command, <support count> support)
**Token estimate:** ~<total> tokens

### Feature Inventory
- Multi-phase pipeline: yes/no
- Persona system: yes/no
- Subagent invocations: yes/no
- Multi-session orchestration: yes/no
- Parallel execution: yes/no
- Cached artifacts: yes/no

### Files
<list>
```

---

## Phase 2 — Baseline Measurement

**Persona: Pulse (Analytics)** — load `../../personas/analytics/persona.md` now. If the file is not found, proceed without the persona and note its absence at the start of Phase 2 output. Identify as Pulse in all Phase 2 output when the persona is loaded.

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
Methodology: Count DO/DO NOT items and other imperative directives across all command
files. Divide by total tokens / 100. DD = directives / (tokens / 100).
Normalise: (DD / 2.0) × 100, cap at 100.

### M3 — Instruction Ambiguity Rate (IAR) [universal]
Methodology: Scan all instructions for weak modal verbs with no scope qualifier:
"should", "may", "might", "consider", "try to" (without an "if X" condition). Count
these as ambiguous. IAR = ambiguous_instructions / total_instructions.
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

### Custom Metric Discovery

**This step is mandatory.** After scoring M1–M12, Pulse examines the workflow for
quality dimensions not captured by any seed metric.

Ask: *What could go wrong in this specific workflow that no seed metric would catch?*

For each gap found, define a custom metric:

```markdown
### MX<N> — <Name> [custom]
**Measures:** <what quality dimension>
**Why seeds miss it:** <which M1-M12 gap this fills>
**Methodology:** <exact counting or scoring method>
**Direction:** ↑ higher / ↓ lower is better
**Weight:** <1× or 2× — use 2× if this dimension is critical to the workflow's purpose>
**Normalisation:** <formula>
```

Heuristics for finding custom metrics:
- What does this workflow *produce*? Does any seed measure output quality? If not, define one.
- What is the most common failure mode for this *type* of workflow? Is it measured?
- Are there cross-file consistency requirements (naming, schema, version alignment)? Measure them.
- Is there a "trust chain" — files that depend on other files being correct? Measure completeness.
- Does the workflow have escape hatches / fallback paths? Are they tested?

**Minimum:** propose at least 1 custom metric per run. If you genuinely cannot find a gap,
state why explicitly — do not silently skip.

Write custom metric definitions to `research-log.md` under `## Custom Metrics — <date>`.
Custom metrics persist and are re-applied on future runs of `/optimise` on the same target.

### Composite Calculation

```
Seed metrics applied: <list>
Seed metrics skipped: <list with reasons>
Custom metrics: <list>

| Metric | Source | Raw | Normalised | Weight | Weighted |
|--------|--------|-----|-----------|--------|----------|
| ...    | seed / custom |  |  |  |  |
| TOTAL  |        |     |           | <N>×   | <sum> / (<N>×100) |

Composite: <sum> / (<N> × 100) × 100 = <X>%
```

Write the full baseline table to `research-log.md` under `## Baseline — <date>`.
Note the 3 weakest metrics (candidates for Phase 3 hypotheses) and the 3 strongest.

---

## Phase 3 — Hypothesis Formation

**Persona: Keeper (Strategist)** — load `../../personas/strategist/persona.md` now. If the file is not found, proceed without the persona and note its absence at the start of Phase 3 output. Identify as Keeper in all Phase 3 output when the persona is loaded.

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

For each hypothesis:

```
### H<N> — <short name>
**Problem observed:** <what the metric score reveals about the workflow>
**Change proposed:** <specific, actionable change to one or more files>
**Targets:** <metric IDs and predicted direction — include custom metrics>
**Predicted improvement:** <estimated delta in normalised score>
**Pattern applied:** <P1–P7 if applicable, or "novel — <name the new pattern>">
**Risk level:** low / medium / high
**Risk note:** <what could go wrong; what to check if disconfirmed>
```

When forming novel hypotheses, ask:
- Is there a structural change (split, merge, reorder) that would improve a custom metric?
- Is there a workflow assumption that is never validated? Add a validation step.
- Is there output that is produced but never verified? Add a verification gate.
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

H1 — <name>: [approve / skip]
H2 — <name>: [approve / skip]
...

Reply with your decisions to proceed.
```

**STOP. Wait for human approval. Do not proceed to Phase 4 until decisions are received.**

Write the full hypothesis list to `research-log.md` under `## Experiments — <date>`.

---

## Phase 4 — Experiment Loop

**Persona: Arden (Critic)** — load `../../personas/critic/persona.md` now. If the file is not found, proceed without the persona and note its absence at the start of Phase 4 output. Identify as Arden in all Phase 4 output when the persona is loaded.

Re-read `research-log.md` (Intent Anchor — Tier C only: if target path mismatches or log is >7 days old, stop and alert the user before proceeding). Confirm which hypotheses were approved.

If inside a git repo, check out a new branch:

```bash
git checkout -b optimize/<target-dir-name>-<date>
```

For each approved hypothesis, in order:

### Step a — Record pre-change score
Measure the targeted metric(s) at their current state. Record as "pre-change" in
`research-log.md`.

### Step b — Make the change
Apply the specific change described in the hypothesis. Modify only the files
necessary. Follow progressive disclosure — do not load context not needed for this
change.

### Step c — Re-measure
Apply the same methodology used in Phase 2 to re-measure the targeted metric(s).

### Step d — Record result
Determine outcome:
- **Confirmed**: normalised score improved by ≥3 points on at least one target metric,
  with no other metric degraded by more than 2 points
- **Partial**: ≥1 point but <3 points improvement on at least one target metric, OR any
  net-positive composite delta that falls below the confirmed threshold
- **Disconfirmed**: <1 point delta on all target metrics AND composite delta ≤0

Update `research-log.md`:

```markdown
### H<N> — <name>
**Pre-change:** <metric scores>
**Post-change:** <metric scores>
**Delta:** <+/- points per metric>
**Result:** confirmed / partial / disconfirmed
**Notes:** <why it worked or didn't>
```

### Step e — Commit or revert
- **Confirmed**: commit with `feat(optimise): <description of change> [H<N>]`
- **Partial**: commit with a note or revert at your discretion — document the decision
- **Disconfirmed**: revert the change; document why in the log

After all hypotheses are processed, write a summary to `research-log.md`:

```markdown
## Experiment Summary
- Confirmed: H<list>
- Partial: H<list>
- Disconfirmed: H<list>
```

---

## Phase 5 — Report

**Persona: none (objective reporter)**

Re-read `research-log.md` (Intent Anchor). Compile all baseline and post-experiment scores.

Build the final comparison table for all applied metrics:

```markdown
## Final Results — <date>

| Metric | Baseline | Post | Delta | Status |
|--------|----------|------|-------|--------|
| M2 DD  | ...      | ...  | ...   | ↑ / ↓ / — |
| ...    |          |      |       |        |
| **Composite** | X% | Y% | +Z pp | |
```

Then write three lists:

**What improved and why:**
- <metric>: <delta> — <mechanism that caused the improvement>

**What was dropped and why:**
- <hypothesis>: <reason it was disconfirmed or reverted>

**What remains to improve:**
- <metric>: still at <score> — <suggested next hypothesis if any>

### Novel Pattern Candidates

If any confirmed hypothesis used a novel pattern (not P1–P7), document it:

```markdown
## Novel Patterns Discovered — <date>

### NP<N> — <Pattern Name>
**Discovered in:** <target workflow>
**Problem it solved:** <description>
**Implementation:** <brief description of the change>
**Metrics it improved:** <list>
**Generalises to:** <what other workflow types would benefit>
**Seed candidate:** yes / no / maybe — <reasoning>
```

Seed candidates should be noted for potential inclusion in `skills/optimise/SKILL.md`
Design Patterns section in a future version.

Append the full report to `research-log.md` under `## Final Results — <date>`.

Print a terminal summary:

```
Optimisation complete.
Baseline: X%  →  Post: Y%  (+Z pp composite)

Confirmed: <count> hypotheses
Partial:   <count>
Dropped:   <count>

Full report written to: <path>/research-log.md
```
