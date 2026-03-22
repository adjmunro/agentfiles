---
argument-hint: "[metric name or keyword]"
---

<!-- This file serves two modes:
     - No argument (or argument is empty): display the summary table only.
     - Argument given: find the matching metric or pattern below and display its
       full detail section only. Match fuzzily — the user may type a partial name,
       a keyword, or an ID (e.g. "M5", "redundancy", "context loading", "P3").
       If nothing matches, say so and list the valid names. -->

---

## Mode: Summary (no argument)

Display this table, then the patterns table, then the stats summary. Nothing else.

### Seed Metrics

| Metric | Weight | Applies when | Healthy | One-line purpose |
|--------|--------|--------------|---------|-----------------|
| Intent-to-Output Traceability | 2× | Multi-phase pipeline | 90–100 | Each phase re-reads the prior phase's output to prevent drift |
| Directive Density | 1× | All workflows | 60–100 | How tightly packed with actionable instructions the workflow is |
| Instruction Ambiguity Rate | 1× | All workflows | 85–100 | How many instructions use vague modals with no qualifying condition |
| Wiring Completeness Score | 1× | Persona system present | 100 | Whether every defined persona is actually loaded and used |
| Redundancy Index | 1× | All workflows | 75–95 | How much the same rule is repeated across files |
| Acceptance Criteria Concreteness | 2× | All workflows | 85–100 | Whether "done" conditions are numeric and verifiable, not subjective |
| Subagent Alignment Score | 1× | Subagent invocations present | 90–100 | Whether delegated tasks are genuinely safe to parallelise |
| Human Touchpoint Count | 2× | All workflows | 95–100 | How often a human must intervene during a full run |
| Context Decay Resilience | 2× | Session boundaries present | 100 | Whether every session handoff explicitly re-anchors intent |
| Context Loading Efficiency | 2× | All workflows | 80–100 | What fraction of loaded tokens are relevant to the current phase |
| Parallelisation Safety Score | 1× | Parallel execution present | 90–100 | Whether concurrent mutations have explicit guards and release mechanisms |
| Information Freshness Score | 2× | Cached artefacts present | 90–100 | Whether inter-session artefacts have TTL policies before re-use |

### Design Patterns

| Pattern | Targets | When to apply |
|---------|---------|---------------|
| Intent Anchor Blocks | Context Decay Resilience ↑, Intent-to-Output Traceability ↑ | Any workflow with session boundaries or 3+ phases |
| Staleness TTL Policies | Information Freshness Score ↑ | Any workflow with cached artefacts read across sessions |
| Progressive Disclosure | Context Loading Efficiency ↑, Human Touchpoint Count ↓ | Any workflow with 3+ phases |
| Recommendation Brief | Human Touchpoint Count ↓, Instruction Ambiguity Rate ↓ | Any workflow with a human approval gate |
| Claim Registry | Parallelisation Safety Score ↑ | Any workflow with parallel or concurrent execution |
| Symmetric Outcome Thresholds | Acceptance Criteria Concreteness ↑ | Any workflow with multi-tier outcome classification |
| Binary Applicability Gates | Instruction Ambiguity Rate ↓, Acceptance Criteria Concreteness ↑ | Any workflow with conditional or optional steps |

### Stats at a Glance

Read `research-log.md` in the optimise skill directory and append a compact stats table:

| Metric | Avg baseline | Best gain seen | Times weakest |
|--------|-------------|---------------|---------------|
| ... | ... | ... | ... |

Only include metrics that have been applied at least once. Keep it to one line per metric.
End with: *"Run `/optimise help <metric name>` for full detail on any metric or pattern."*

---

## Mode: Detail (metric or pattern argument)

Find the section below that best matches the argument. Display only that section.

---

### Intent-to-Output Traceability
*Also matches: M1, IOT, traceability, drift, pipeline*

**Measures:** Whether each phase in a multi-phase pipeline explicitly re-reads the artefact produced by the previous phase before doing its own work.

**Intent:** In a long pipeline, the context an agent has at phase 4 is not the same as at phase 1. Without explicit re-anchoring, the agent works from memory rather than from the actual recorded output — producing a "telephone game" effect where each phase drifts slightly from the original intent. This metric catches that drift before it compounds.

**Applies when:** The workflow has two or more sequential phases where each phase produces an artefact consumed by the next.

**Weight:** 2×

**Healthy range:** 90–100. Any phase missing a re-read is a latent drift risk.

**Risk at low scores:** Phase 4 operates on a stale or reconstructed picture of the intent. Experiments address the wrong problem. Results are not comparable across runs.

**How to improve:** Apply Intent Anchor Blocks — add an explicit re-read of `research-log.md` (or the equivalent intent artefact) at the start of each phase block.

**Stats:** Scored 100 in both runs. Never needed targeting.

---

### Directive Density
*Also matches: M2, DD, density, imperatives, directives*

**Measures:** How many actionable instructions (DO / DO NOT items, imperatives) the workflow contains per 100 tokens of content.

**Intent:** A workflow that is mostly narrative or explanatory gives an agent too much room to improvise. Directive density is a proxy for how much of the content is actually constraining agent behaviour vs. filling space. Too low means the agent decides too much on its own.

**Applies when:** All workflows (universal).

**Weight:** 1×

**Healthy range:** 60–100 after normalisation (target: ≥2 directives per 100 tokens). Very high density is not a problem — it means the workflow is tightly specified.

**Risk at low scores:** The agent fills gaps with its own defaults, which may differ between runs or model versions. Behaviour becomes unpredictable.

**How to improve:** Audit narrative sections and convert explanations into explicit DO / DO NOT rules. Remove padding that describes what the workflow does rather than constraining how.

**Stats:** Scored 100 in both runs. Never needed targeting.

---

### Instruction Ambiguity Rate
*Also matches: M3, IAR, ambiguity, modal, vague, should, may*

**Measures:** The proportion of instructions that use unscoped modal verbs ("should", "may", "might", "consider", "try to") with no qualifying condition.

**Intent:** An instruction like "should be recorded" gives no guidance on when or why — two agents may interpret it differently. A scope qualifier ("should be recorded if the target is inside a git repo") makes the instruction deterministic. This metric identifies instructions that rely on agent judgment where explicit rules would be better.

**Applies when:** All workflows (universal).

**Weight:** 1×

**Healthy range:** 85–100 (fewer than 15% of instructions are ambiguous).

**Risk at low scores:** Instructions with soft modals become inconsistent between runs. Partial fixes become accepted as complete. The workflow "works" in testing but fails in the scenarios the author imagined but didn't write down.

**What counts as ambiguous:** `"should"`, `"may"`, `"might"`, `"consider"`, `"try to"` with no `if X` condition, no domain restriction, and no specific named target. Descriptive uses of "may/can" (stating a possibility, not an instruction) do not count.

**How to improve:** Apply Binary Applicability Gates — replace each soft modal with a concrete condition. "Should be recorded" → "Record if the target is inside a git repo."

**Stats:** Baseline range 88–93 across two runs. +5pp achieved in one experiment (Binary Applicability Tests). Confirmed rate: 1/1.

---

### Wiring Completeness Score
*Also matches: M4, WCS, wiring, persona, connected*

**Measures:** What proportion of defined persona files are actually loaded and used in at least one phase appropriate for their role.

**Intent:** Personas represent specialised reasoning styles (analytical, strategic, critical). If a persona exists but is never loaded, it was designed for a purpose that is not being served. This metric checks whether the skill's persona system is fully connected — not just defined.

**Applies when:** The workflow references or loads any persona files.

**Weight:** 1×

**Healthy range:** 100. Every defined persona should be wired.

**Risk at low scores:** Work that should benefit from a specific thinking mode (e.g., critical review) falls back to the default agent persona, reducing the quality of that phase's output.

**How to improve:** For each persona file that exists, identify which phase it is best suited to and add an explicit load directive there.

**Stats:** Scored 100 in both runs. Never needed targeting.

---

### Redundancy Index
*Also matches: M5, RI, redundancy, duplication, repeated, single source of truth*

**Measures:** The proportion of instructions that appear in more than one file with substantially the same meaning.

**Intent:** Redundancy is not inherently bad — some repetition aids context. But high redundancy creates a maintenance hazard: when a rule changes, all copies must be updated. Missed updates mean the workflow contradicts itself. This metric flags where a single source of truth would be more reliable.

**Applies when:** All workflows (universal).

**Weight:** 1×

**Healthy range:** 75–95 (5–25% redundancy is acceptable; above 25% is risky).

**Risk at low scores:** Rule drift — different files give conflicting instructions for the same situation. The agent follows whichever version appears later in context, which may not be the intended one.

**How to improve:** Identify the most duplicated content (usually full metric/pattern tables, composite formulas, or global rules) and consolidate to one canonical file. Add pointers in the others rather than copies.

**Stats:** Baseline range 66–91. Largest single gain: +24pp (stripping SKILL.md duplication). Confirmed rate: 1/1 when targeted. Note: showed a −3pp incidental regression in run 2 when phase splitting added navigation lines — acceptable tradeoff.

---

### Acceptance Criteria Concreteness
*Also matches: M6, ACC, acceptance, concrete, done, stop, confirmed, vague criteria*

**Measures:** The proportion of "done when", "stop when", or "confirmed when" statements that are objectively verifiable (a number, a file count, an exit code) vs. subjective ("the result looks right", "improvement is meaningful").

**Intent:** Vague acceptance criteria mean the agent decides when it's done. Concrete criteria transfer that decision to the workflow author. This matters most for experiment outcomes, phase transitions, and quality gates — anywhere the agent must make a binary pass/fail call.

**Applies when:** All workflows (universal).

**Weight:** 2×

**Healthy range:** 85–100.

**Risk at low scores:** The agent declares experiments "confirmed" when they are marginal. Phases end before their work is complete. Quality gates are bypassed because "it seems fine".

**How to improve:** Two patterns apply well here. Symmetric Outcome Thresholds adds numeric floors to every tier (not just the passing case). Binary Applicability Gates replaces judgment calls with yes/no questions derivable from earlier outputs.

**Stats:** Baseline range 75–86. Two experiments confirmed in run 1, totalling +19pp. Confirmed rate: 2/2.

---

### Subagent Alignment Score
*Also matches: M7, SAS, subagent, parallel agents, delegation, race condition*

**Measures:** Whether tasks delegated to subagents are genuinely appropriate for subagent execution — isolated, parallelisable, without shared mutable state that would create race conditions.

**Intent:** Subagents are powerful for parallelism and context isolation, but dangerous if two agents write to the same file or read a shared resource mid-mutation. This metric checks whether delegation decisions are sound, not just present.

**Applies when:** Any command file contains an explicit subagent invocation or a "spawn subagent" directive.

**Weight:** 1×

**Healthy range:** 90–100.

**Risk at low scores:** Parallel subagents corrupt shared state. One agent's write is overwritten by another's. Errors are non-deterministic and hard to reproduce.

**How to improve:** Apply Claim Registry — add a shared lock file that agents check before mutating any shared artefact. Or restructure to ensure each subagent has exclusive ownership of its output files.

**Stats:** Skipped in both runs (no subagent invocations in the target). Will activate on any workflow that uses parallel agents.

---

### Human Touchpoint Count
*Also matches: M8, HTC, human, touchpoint, stall, approval, intervention*

**Measures:** How many times a full end-to-end run requires a human to provide input or approval (not counting the initial invocation).

**Intent:** Every human touchpoint is a workflow stall. Touchpoints that require open-ended answers (rather than approve/skip decisions) compound the problem by requiring the human to understand the workflow's internal state. This metric pressures the workflow towards autonomy and well-structured decision points.

**Applies when:** All workflows (universal).

**Weight:** 2×

**Healthy range:** 95–100 after normalisation (target: ≤1 mandatory touchpoint per run).

**Risk at low scores:** The workflow stalls repeatedly awaiting input. Users abandon it mid-run or batch all approvals without reading them, defeating the purpose of the review.

**How to improve:** Apply Recommendation Brief — replace open-ended questions with structured approve/skip decisions. The agent forms the recommendation; the human only needs to say yes or no.

**Stats:** Scored 95 in both runs (one touchpoint: the Phase 3 approval gate). Considered appropriate — never targeted.

---

### Context Decay Resilience
*Also matches: M9, CDR, session, handoff, context loss, decay, boundary*

**Measures:** Whether every session boundary (where a new agent session begins) includes an explicit re-read of the original intent artefact before proceeding.

**Intent:** Agent context does not persist across sessions. A workflow that assumes the second session "remembers" what the first decided will produce inconsistent results — especially if the session break is hours or days later. This metric ensures the workflow actively reconstructs context at every handoff.

**Applies when:** Any phase block includes a STOP, PAUSE, or explicit session-boundary instruction.

**Weight:** 2×

**Healthy range:** 100. Every session boundary should re-anchor.

**Risk at low scores:** Session 2 starts from an incorrect picture of the intent. Experiments are designed against stale baseline data. The workflow diverges from its original goal silently.

**How to improve:** Apply Intent Anchor Blocks at every STOP/PAUSE point — add an explicit re-read of the intent artefact as the first instruction after the boundary resumes.

**Stats:** Scored 100 in both runs. Never needed targeting.

---

### Context Loading Efficiency
*Also matches: M10, CLE, context, loading, efficiency, tokens, irrelevant*

**Measures:** What proportion of the tokens loaded at each phase are actually relevant to the work of that phase — averaged across all phases.

**Intent:** Loading unnecessary context wastes tokens and, more importantly, increases the chance of an agent being distracted by irrelevant instructions. A workflow that loads all its files at phase 1 and keeps them in context through phase 5 is paying a constant cost that could be eliminated with phase-scoped loading.

**Applies when:** All workflows (universal).

**Weight:** 2×

**Healthy range:** 80–100.

**Risk at low scores:** Later phases are slower and more error-prone because they must parse large context to find the relevant instructions. Earlier-phase instructions interfere with later-phase decisions.

**How to improve:** Apply Progressive Disclosure — move each file load inside the phase that needs it. The single most impactful version of this is splitting a monolithic command file into per-phase files so the orchestrator only loads one at a time.

**Stats:** The most consistently weak metric across both runs. Baseline range 48–75, average 61.5. Three experiments all confirmed: +9pp (deduplication), +17pp (phase-scoped persona loading), +20pp (phase file splitting). If you're unsure where to start on a new target, check this first.

---

### Parallelisation Safety Score
*Also matches: M11, PSS, parallel, concurrent, lock, mutex, guard, worktree*

**Measures:** Whether each mutation (write, move, delete) that could occur in a parallel context has explicit guards: a concurrent-access check and a defined release mechanism.

**Intent:** Parallel execution is high-risk without coordination. Two agents writing to the same file will silently corrupt it. This metric checks whether the workflow's parallelism is safe by design, not just by luck.

**Applies when:** Any command file instructs the agent to run two or more tasks concurrently, or uses worktree or parallel phase blocks.

**Weight:** 1×

**Healthy range:** 90–100.

**Risk at low scores:** Data loss or file corruption on any run where parallel tasks happen to collide. The failure is intermittent and difficult to reproduce.

**How to improve:** Apply Claim Registry — define a registry file listing which agent holds each write lock. Mutations acquire the lock, write, and release. Alternatively, restructure so each parallel branch owns distinct output files with no overlap.

**Stats:** Skipped in both runs (no parallel execution in the target). Will activate on any workflow that uses concurrent phases or worktrees.

---

### Information Freshness Score
*Also matches: M12, IFS, freshness, stale, TTL, cached, artefact, expiry*

**Measures:** What proportion of artefacts that are written in one phase and read again in a later phase (or later session) have an explicit TTL policy or freshness check before use.

**Intent:** An artefact written yesterday may be stale today. A workflow that reads cached artefacts without checking whether they are still valid will silently operate on outdated data. This metric ensures every inter-phase or inter-session artefact has a defined shelf life.

**Applies when:** The workflow writes an artefact in one phase and reads it again in a later phase or later session.

**Weight:** 2×

**Healthy range:** 90–100.

**Risk at low scores:** A run using a stale research log from a different target or a previous week will measure against the wrong baseline. Experiments appear to confirm or disconfirm based on incorrect pre-change scores.

**How to improve:** Apply Staleness TTL Policies — at every point where a cached artefact is re-read, add a 3-tier freshness check: regenerate if the target path has changed, load with a caveat if the artefact is older than the threshold, use as-is if it's fresh.

**Stats:** Baseline range 0–100 (binary in practice — either you have a policy or you don't). +100pp achieved in one experiment. Confirmed rate: 1/1. The fix is typically a one-time addition.

---

### Intent Anchor Blocks
*Also matches: P1, anchor, intent, re-read, drift*

**Problem it solves:** Without an explicit re-read at each phase transition, later phases operate on memory rather than the actual recorded output — causing compounding drift.

**How it works:** At every phase transition, the orchestrator re-reads the original intent artefact (e.g., `research-log.md`) before proceeding. The re-read is the first instruction in the phase, before any other work.

**Targets:** Context Decay Resilience (↑), Intent-to-Output Traceability (↑)

**When to apply:** Any workflow with session boundaries or more than three phases.

**Typical gain:** Scores that are already low on Context Decay Resilience tend to jump to 100 in a single experiment — the fix is structural and complete.

---

### Staleness TTL Policies
*Also matches: P2, TTL, stale, freshness, tier, regenerate, caveat*

**Problem it solves:** Workflows that re-read cached artefacts without checking their age silently operate on outdated data.

**How it works:** Every artefact that can go stale is tagged with a 3-tier policy: Regenerate (must be rebuilt if older than threshold or target has changed), Load-with-caveat (usable but flagged), or No-TTL (canonical, never expires). The check runs at the re-read point, before the artefact is used.

**Targets:** Information Freshness Score (↑)

**When to apply:** Any workflow with cached artefacts read across sessions.

**Typical gain:** Information Freshness Score goes from 0 to 100 in a single experiment — the metric is binary once the policy is in place.

---

### Progressive Disclosure
*Also matches: P3, progressive, phase-scoped, context, loading, on-demand*

**Problem it solves:** Loading the full workflow corpus at phase 1 and keeping it in context through all phases wastes tokens and creates noise that distracts later-phase work.

**How it works:** Each phase block lists only the files it needs. The orchestrator does not preload anything — context is loaded on entry to each phase and not carried forward.

**Targets:** Context Loading Efficiency (↑), Human Touchpoint Count (↓)

**When to apply:** Any workflow with three or more phases.

**Typical gain:** The most versatile pattern for Context Loading Efficiency. Three applications on the same target achieved +9pp, +17pp, and +20pp respectively as the pattern was applied at increasing granularity.

---

### Recommendation Brief
*Also matches: P4, brief, recommendation, approve, skip, open-ended, question*

**Problem it solves:** Workflows that ask open-ended questions require the human to understand the workflow's internal state in order to answer. This increases cognitive load and stall time.

**How it works:** The agent assembles all evidence, forms a recommended action per item, and presents each as a binary approve/skip decision. The human reads and decides; they do not need to generate answers.

**Targets:** Human Touchpoint Count (↓), Instruction Ambiguity Rate (↓)

**When to apply:** Any workflow with a human review or approval gate.

**Typical gain:** Reduces perceived friction even when the raw touchpoint count is unchanged — structured decisions are faster to process than open questions.

---

### Claim Registry
*Also matches: P5, registry, lock, mutex, claim, write lock, concurrent*

**Problem it solves:** Parallel agents writing to shared files without coordination silently corrupt data.

**How it works:** A shared registry file records which agent or phase currently holds a write lock on each artefact. All mutations check the registry before writing and release the lock on completion.

**Targets:** Parallelisation Safety Score (↑)

**When to apply:** Any workflow with parallel or concurrent execution.

**Typical gain:** Converts non-deterministic corruption failures into deterministic "lock held" errors that are debuggable.

---

### Symmetric Outcome Thresholds
*Also matches: P6, symmetric, thresholds, confirmed, partial, disconfirmed, numeric floor*

**Problem it solves:** Workflows that define the passing case concretely but leave lower tiers vague ("no meaningful improvement") create a gap where the agent applies its own judgment.

**How it works:** Define concrete numeric boundaries for every tier — not just the passing case. Use the confirmed/pass threshold as the anchor (e.g., ≥3pp) and define lower tiers relative to it (partial: ≥1pp but <3pp; disconfirmed: <1pp on all targets AND composite ≤0).

**Targets:** Acceptance Criteria Concreteness (↑)

**When to apply:** Any workflow with multi-tier outcome classification.

**Typical gain:** +13pp on Acceptance Criteria Concreteness in the run where it was first applied.

---

### Binary Applicability Gates
*Also matches: P7, binary, applicability, gate, condition, yes/no, deterministic*

**Problem it solves:** Vague feature-presence conditions like "multi-session orchestration: yes/no" require an agent to make a judgment call that different agents may resolve differently.

**How it works:** Replace each condition with a single yes/no question whose answer is deterministically derivable from an earlier phase's output. Example: "Does any phase block include a STOP or PAUSE instruction?" rather than "Does the workflow have session boundaries?"

**Targets:** Instruction Ambiguity Rate (↓), Acceptance Criteria Concreteness (↑)

**When to apply:** Any workflow with optional steps, conditional metric applicability, or skip/apply decisions.

**Typical gain:** +5pp on Instruction Ambiguity Rate, +6pp on Acceptance Criteria Concreteness in the run where it was applied.

---
