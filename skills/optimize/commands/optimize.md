---
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch, Agent
model: claude-opus-4-6
argument-hint: "<path-to-target-workflow-directory>"
---

<!-- PROGRESSIVE DISCLOSURE: Load and execute only the phase block you are currently in.
     Do not read ahead into later phases. Each phase's inputs are produced by the previous
     phase — loading them early defeats progressive disclosure and inflates context. -->

## Personas

Before beginning Phase 1, load the following personas. Each is active during specific
phases as indicated below.

- **Pulse (Analytics)** — `../../personas/analytics/persona.md` — active in Phase 2 (measurement)
- **Keeper (Strategist)** — `../../personas/strategist/persona.md` — active in Phase 3 (hypothesis)
- **Arden (Critic)** — `../../personas/critic/persona.md` — active in Phase 4 (validation)

Identify by persona name in all output during the phase where that persona is active.

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

Re-read `research-log.md` in the target directory if it exists (Intent Anchor).

Derive the target directory path from `$ARGUMENTS`. If `$ARGUMENTS` is empty or the
path does not exist, stop and print:

> No target directory provided. Usage: /optimize <path-to-workflow-directory>

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

**Persona: Pulse (Analytics)**

Re-read `research-log.md` (Intent Anchor).

For each metric below, state the methodology, run the measurement, and record the
result. For metrics that do not apply based on the Phase 1 feature inventory, write
"SKIP — <reason>" and do not score them.

### M1 — Intent-to-Output Traceability (IOT) [applies: multi-phase pipeline]
Methodology: For each phase in each command file, count whether the phase explicitly
re-reads or references an artifact produced by a prior phase (plan file, input file,
log entry, etc.). IOT = phases_with_explicit_prior_artifact_read / total_phases.

### M2 — Directive Density (DD) [universal]
Methodology: Count DO/DO NOT items and other imperative directives across all command
files. Divide by total tokens / 100. DD = directives / (tokens / 100).
Normalize: (DD / 2.0) × 100, cap at 100.

### M3 — Instruction Ambiguity Rate (IAR) [universal]
Methodology: Scan all instructions for weak modal verbs with no scope qualifier:
"should", "may", "might", "consider", "try to" (without an "if X" condition). Count
these as ambiguous. IAR = ambiguous_instructions / total_instructions.
Normalize: 100 − IAR%.

### M4 — Wiring Completeness Score (WCS) [applies: persona system]
Methodology: List all persona files that exist. For each persona, check whether it is
explicitly loaded in at least one command that performs the work it is suited for.
WCS = wired_personas / total_personas.

### M5 — Redundancy Index (RI) [universal]
Methodology: Identify instructions or rules that appear in more than one file with
substantially the same meaning. RI = redundant_instruction_instances / total_instructions.
Normalize: 100 − RI%.

### M6 — AC Concreteness (ACC) [universal]
Methodology: Find all acceptance criteria, stop conditions, or "done when" statements.
For each, assess: is it measurable without interpretation (concrete), or does it
require subjective judgment (vague)? ACC = concrete_ACs / total_ACs.

### M7 — Subagent Alignment Score (SAS) [applies: subagent invocations]
Methodology: For each subagent invocation, check whether the task delegated is
appropriate for a subagent (isolated, parallelizable, no shared mutable state without
explicit guards). SAS = appropriate_invocations / total_invocations.

### M8 — Human Touchpoint Count (HTC) [universal]
Methodology: Count every point in a full end-to-end run where a human must provide
input or approval (not counting the initial invocation). HTC = count of touchpoints.
Normalize: max(0, 100 − (HTC / 20) × 100).

### M9 — Context Decay Resilience (CDR) [applies: multi-session orchestration]
Methodology: For each session boundary (points where a new agent session begins),
check whether the command explicitly re-reads the original intent artifact before
proceeding. CDR = session_transitions_with_reanchor / total_session_transitions.

### M10 — Context Loading Efficiency (CLE) [universal]
Methodology: For each phase in each command file, identify what files are loaded and
estimate what percentage of those tokens are actually relevant to the work of that
phase. CLE = relevant_tokens_loaded / total_tokens_loaded (averaged across phases).

### M11 — Parallelization Safety Score (PSS) [applies: parallel execution]
Methodology: For each mutation (write, move, delete) that could occur in a parallel
context, check whether it has: (a) explicit guard against concurrent access, and
(b) a defined release mechanism. Full credit = both guards; partial = one guard.
PSS = (full_credit + 0.5 × partial_credit) / total_parallel_mutations.

### M12 — Information Freshness Score (IFS) [applies: cached artifacts]
Methodology: For each artifact that is read after being written in a prior session,
check whether there is an explicit TTL policy or freshness check before use.
IFS = artifacts_with_freshness_policy / total_inter-session_artifacts.

### Composite Calculation

```
Applied metrics: <list>
Skipped metrics: <list with reasons>

| Metric | Raw | Normalized | Weight | Weighted |
|--------|-----|-----------|--------|----------|
| ...    |     |           |        |          |
| TOTAL  |     |           | <N>×   | <sum> / (<N>×100) |

Composite: <sum> / (<N> × 100) × 100 = <X>%
```

Write the full baseline table to `research-log.md` under `## Baseline — <date>`.
Also note the 3 weakest metrics and the 3 strongest.

---

## Phase 3 — Hypothesis Formation

**Persona: Keeper (Strategist)**

Re-read `research-log.md` (Intent Anchor). Focus on the baseline section.

Based on the 3 weakest metrics, form 3–5 hypotheses. For each:

```
### H<N> — <short name>
**Problem observed:** <what the metric score reveals about the workflow>
**Change proposed:** <specific, actionable change to one or more files>
**Targets:** <metric IDs and predicted direction>
**Predicted improvement:** <estimated delta in normalized score>
**Pattern applied:** <P1–P5 if applicable, or "novel">
**Risk level:** low / medium / high
**Risk note:** <what could go wrong>
```

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

**Persona: Arden (Critic)**

Re-read `research-log.md` (Intent Anchor). Confirm which hypotheses were approved.

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
- **Confirmed**: normalized score improved by ≥3 points on at least one target metric
  with no other metric degraded by more than 2 points
- **Partial**: improvement present but below threshold, or mixed (some metrics up, some down)
- **Disconfirmed**: no meaningful improvement, or net negative

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
- **Confirmed**: commit with `feat(optimize): <description of change> [H<N>]`
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

Append the full report to `research-log.md` under `## Final Results — <date>`.

Print a terminal summary:

```
Optimization complete.
Baseline: X%  →  Post: Y%  (+Z pp composite)

Confirmed: <count> hypotheses
Partial:   <count>
Dropped:   <count>

Full report written to: <path>/research-log.md
```
