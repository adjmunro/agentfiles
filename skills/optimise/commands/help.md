---
argument-hint: "[optional: path to a research-log.md for live stats]"
---

# Optimise — Metric Library

This is the reference guide for all measurements used by the optimise skill. Read it when you want to understand what each metric means, why it exists, and when it's most useful.

Display this content to the user. After the static sections, read `research-log.md` in
the optimise skill directory (`skills/optimise/research-log.md`) and extract live usage
statistics. If `$ARGUMENTS` points to a directory containing a `research-log.md`, also
read that file for target-specific stats. Merge stats from all logs found.

---

## How to Read This Guide

Each metric entry shows:
- **Measures** — the quality dimension being scored
- **Intent** — the failure mode this metric guards against and why it matters
- **Applies when** — the workflow feature that must be present (skipped otherwise)
- **Weight** — how heavily it counts in the composite (2× metrics are critical path)
- **Healthy range** — what a well-designed workflow typically scores
- **Risk at low scores** — what goes wrong when this is neglected
- **Stats** — usage frequency, typical baseline, and largest gain seen across all runs

---

## Seed Metrics

These twelve metrics form the core measurement library. Metrics with an "Applies when"
condition are skipped (not scored as zero) when that condition is absent.

---

### Intent-to-Output Traceability
**Measures:** Whether each phase in a multi-phase pipeline explicitly re-reads the
artefact produced by the previous phase before doing its own work.

**Intent:** In a long pipeline, the context an agent has at phase 4 is not the same as
at phase 1. Without explicit re-anchoring, the agent works from memory rather than from
the actual recorded output — producing a "telephone game" effect where each phase drifts
slightly from the original intent. This metric catches that drift before it compounds.

**Applies when:** The workflow has two or more sequential phases where each phase produces
an artefact consumed by the next.

**Weight:** 2× (critical — drift compounds exponentially across phases)

**Healthy range:** 90–100. Any phase missing a re-read is a latent drift risk.

**Risk at low scores:** Phase 4 operates on a stale or reconstructed picture of the
intent. Experiments address the wrong problem. Results are not comparable across runs.

---

### Directive Density
**Measures:** How many actionable instructions (DO / DO NOT items, imperatives) the
workflow contains per 100 tokens of content.

**Intent:** A workflow that is mostly narrative or explanatory gives an agent too much
room to improvise. Directive density is a proxy for how much of the content is actually
constraining agent behaviour vs. filling space. Too low means the agent decides too
much on its own; too high can mean the workflow is brittle.

**Applies when:** All workflows (universal).

**Weight:** 1×

**Healthy range:** 60–100 after normalisation (target: ≥2 directives per 100 tokens).
Very high density is not a problem — it means the workflow is tightly specified.

**Risk at low scores:** The agent fills gaps with its own defaults, which may differ
between runs or model versions. Behaviour becomes unpredictable.

---

### Instruction Ambiguity Rate
**Measures:** The proportion of instructions that use unscoped modal verbs ("should",
"may", "might", "consider", "try to") with no qualifying condition.

**Intent:** An instruction like "should be recorded" gives no guidance on when or why —
two agents may interpret it differently. Adding a scope qualifier ("should be recorded
if the target is inside a git repo") makes the instruction deterministic. This metric
identifies instructions that rely on agent judgment where explicit rules would be better.

**Applies when:** All workflows (universal).

**Weight:** 1×

**Healthy range:** 85–100 (fewer than 15% of instructions are ambiguous).

**Risk at low scores:** Instructions with soft modals become inconsistent between runs.
Partial fixes become accepted as complete. The workflow "works" in testing but fails in
the scenarios the author imagined but didn't write down.

---

### Wiring Completeness Score
**Measures:** What proportion of defined persona files are actually loaded and used in
at least one phase appropriate for their role.

**Intent:** Personas represent specialised reasoning styles (analytical, strategic,
critical). If a persona exists but is never loaded, it was designed for a purpose that
is not being served. This metric checks whether the skill's persona system is fully
connected — not just defined.

**Applies when:** The workflow references or loads any persona files.

**Weight:** 1×

**Healthy range:** 100. Every defined persona should be wired.

**Risk at low scores:** Work that should benefit from a specific thinking mode (e.g.,
critical review) falls back to the default agent persona, reducing the quality of that
phase's output.

---

### Redundancy Index
**Measures:** The proportion of instructions that appear in more than one file with
substantially the same meaning.

**Intent:** Redundancy is not inherently bad — some repetition aids context. But
high redundancy creates a maintenance hazard: when a rule changes, all copies must be
updated. Missed updates mean the workflow contradicts itself. This metric flags where
a single source of truth would be more reliable.

**Applies when:** All workflows (universal).

**Weight:** 1×

**Healthy range:** 75–95 (5–25% redundancy is acceptable; above 25% is risky).

**Risk at low scores:** Rule drift — different files give conflicting instructions for
the same situation. The agent follows whichever version appears later in context,
which may not be the intended one.

---

### Acceptance Criteria Concreteness
**Measures:** The proportion of "done when", "stop when", or "confirmed when" statements
that are objectively verifiable (a number, a file count, an exit code) vs. subjective
("the result looks right", "improvement is meaningful").

**Intent:** Vague acceptance criteria mean the agent decides when it's done. Concrete
criteria transfer that decision to the workflow author. This matters most for experiment
outcomes, phase transitions, and quality gates — anywhere the agent must make a binary
pass/fail call.

**Applies when:** All workflows (universal).

**Weight:** 2× (critical — vague stop conditions cause premature or missed completion)

**Healthy range:** 85–100.

**Risk at low scores:** The agent declares experiments "confirmed" when they are
marginal. Phases end before their work is complete. Quality gates are bypassed because
"it seems fine".

---

### Subagent Alignment Score
**Measures:** Whether tasks delegated to subagents are genuinely appropriate for
subagent execution — isolated, parallelisable, without shared mutable state that would
create race conditions.

**Intent:** Subagents are powerful for parallelism and context isolation, but dangerous
if two agents write to the same file or read a shared resource mid-mutation. This metric
checks whether delegation decisions are sound, not just present.

**Applies when:** Any command file contains an explicit subagent invocation or a
"spawn subagent" directive.

**Weight:** 1×

**Healthy range:** 90–100.

**Risk at low scores:** Parallel subagents corrupt shared state. One agent's write is
overwritten by another's. Errors are non-deterministic and hard to reproduce.

---

### Human Touchpoint Count
**Measures:** How many times a full end-to-end run requires a human to provide input
or approval (not counting the initial invocation).

**Intent:** Every human touchpoint is a workflow stall. Touchpoints that require open-ended
answers (rather than approve/skip decisions) compound the problem by requiring the human
to understand the workflow's internal state. This metric pressures the workflow towards
autonomy and well-structured decision points.

**Applies when:** All workflows (universal).

**Weight:** 2× (critical — excessive touchpoints make the workflow impractical to use)

**Healthy range:** 95–100 after normalisation (target: ≤1 mandatory touchpoint per run).

**Risk at low scores:** The workflow stalls repeatedly awaiting input. Users abandon it
mid-run or batch all approvals without reading them, defeating the purpose of the review.

---

### Context Decay Resilience
**Measures:** Whether every session boundary (where a new agent session begins) includes
an explicit re-read of the original intent artefact before proceeding.

**Intent:** Agent context does not persist across sessions. A workflow that assumes the
second session "remembers" what the first decided will produce inconsistent results —
especially if the session break is hours or days later. This metric ensures the workflow
actively reconstructs context at every handoff.

**Applies when:** Any phase block includes a STOP, PAUSE, or explicit session-boundary
instruction.

**Weight:** 2× (critical — unguarded session breaks are invisible and hard to debug)

**Healthy range:** 100. Every session boundary should re-anchor.

**Risk at low scores:** Session 2 starts from an incorrect picture of the intent.
Experiments are designed against stale baseline data. The workflow diverges from its
original goal silently.

---

### Context Loading Efficiency
**Measures:** What proportion of the tokens loaded at each phase are actually relevant
to the work of that phase — averaged across all phases.

**Intent:** Loading unnecessary context wastes tokens and, more importantly, increases
the chance of an agent being distracted by irrelevant instructions. A workflow that
loads all its files at phase 1 and keeps them in context through phase 5 is paying a
constant cost that could be eliminated with phase-scoped loading.

**Applies when:** All workflows (universal).

**Weight:** 2× (critical — inefficient loading compounds across long pipelines)

**Healthy range:** 80–100.

**Risk at low scores:** Later phases are slower and more error-prone because they
must parse large context to find the relevant instructions. Earlier-phase instructions
interfere with later-phase decisions.

---

### Parallelisation Safety Score
**Measures:** Whether each mutation (write, move, delete) that could occur in a parallel
context has explicit guards: a concurrent-access check and a defined release mechanism.

**Intent:** Parallel execution is high-risk without coordination. Two agents writing to
the same file will silently corrupt it. This metric checks whether the workflow's
parallelism is safe by design, not just by luck.

**Applies when:** Any command file instructs the agent to run two or more tasks
concurrently, or uses worktree or parallel phase blocks.

**Weight:** 1×

**Healthy range:** 90–100.

**Risk at low scores:** Data loss or file corruption on any run where parallel tasks
happen to collide. The failure is intermittent and difficult to reproduce.

---

### Information Freshness Score
**Measures:** What proportion of artefacts that are written in one phase and read again
in a later phase (or later session) have an explicit TTL policy or freshness check before
use.

**Intent:** An artefact written yesterday may be stale today. A workflow that reads
cached artefacts without checking whether they are still valid will silently operate on
outdated data. This metric ensures every inter-phase or inter-session artefact has a
defined shelf life.

**Applies when:** The workflow writes an artefact in one phase and reads it again in a
later phase or later session.

**Weight:** 2× (critical — stale artefact reads are invisible and hard to detect)

**Healthy range:** 90–100.

**Risk at low scores:** A run using a stale research-log.md from a different target
or a previous week will measure against the wrong baseline. Experiments appear to
confirm or disconfirm based on incorrect pre-change scores.

---

## Design Patterns

These are reusable solutions to recurring workflow problems. Each hypothesis in Phase 3
applies one of these patterns or invents a novel one.

---

### Intent Anchor Blocks
At every phase transition, the orchestrator re-reads the original intent artefact before
proceeding. Prevents context drift across long sessions.

**Targets:** Context Decay Resilience (↑), Intent-to-Output Traceability (↑)

**When to apply:** Any workflow with session boundaries or more than three phases.

---

### Staleness TTL Policies (3-tier)
Every artefact that can go stale carries an explicit TTL policy:
- **Regenerate** — must be rebuilt before use if older than threshold
- **Load-with-caveat** — usable but agent must flag staleness to user
- **No-TTL** — canonical and does not expire (e.g., original input)

**Targets:** Information Freshness Score (↑)

**When to apply:** Any workflow with cached artefacts read across sessions.

---

### Progressive Disclosure
Phase-scoped context loading: each phase block lists only the files it needs. No phase
loads the full workflow corpus. Context is loaded on demand, not preloaded.

**Targets:** Context Loading Efficiency (↑), Human Touchpoint Count (↓)

**When to apply:** Any workflow with three or more phases.

---

### Recommendation Brief
Replace open-ended human question-and-answer with a model-formed brief. The agent
assembles evidence, states a recommended action per item, and asks for a binary
approve/skip decision per item rather than open questions.

**Targets:** Human Touchpoint Count (↓), Instruction Ambiguity Rate (↓)

**When to apply:** Any workflow with a human review or approval gate.

---

### Claim Registry
A shared registry file records which agent or phase currently holds a write lock on each
artefact. All mutations check the registry before writing and release the lock on
completion.

**Targets:** Parallelisation Safety Score (↑)

**When to apply:** Any workflow with parallel or concurrent execution.

---

### Symmetric Outcome Thresholds
For workflows with multi-tier outcome classification: define concrete numeric boundaries
for every tier, not just the passing case. Use the confirmed/pass threshold as the anchor
and define lower tiers relative to it.

**Targets:** Acceptance Criteria Concreteness (↑)

**When to apply:** Any workflow with pass/warn/fail or confirmed/partial/disconfirmed
outcome tiers.

---

### Binary Applicability Gates
For conditional instructions or optional steps: replace vague feature-presence conditions
with a single yes/no question whose answer is deterministically derivable from an earlier
phase's output.

**Targets:** Instruction Ambiguity Rate (↓), Acceptance Criteria Concreteness (↑)

**When to apply:** Any workflow with optional steps or conditional metric applicability.

---

## Live Statistics

After displaying the sections above, read `research-log.md` in the optimise skill's own
directory. For each metric that appears in at least one baseline table, compute and display:

```
### <Full Metric Name>
- Runs applied: <count>
- Score range seen: <min>–<max> (normalised)
- Average baseline: <mean>
- Largest single-run gain: +<N>pp (from H<N> — <name>)
- Times identified as weakest metric: <count>
- Confirmed hypothesis rate when targeted: <X>/<Y>
```

If fewer than 2 runs are available, note this and describe what would make the stats more
meaningful as more runs accumulate.

If `$ARGUMENTS` points to a directory containing a `research-log.md`, include a section
showing how that target's scores compare to the aggregate:

```
### How <target> compares
| Metric | Target score | Average across all runs | Delta |
|--------|-------------|------------------------|-------|
| ...    | ...         | ...                    | ...   |
```
