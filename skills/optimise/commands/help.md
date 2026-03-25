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

| ID | Metric | Weight | Applies when | Healthy | One-line purpose |
|----|--------|--------|--------------|---------|-----------------|
| M1 · IOT | Intent-to-Output Traceability | 2× | Multi-phase pipeline | 90–100 | Each phase re-reads the prior phase's output to prevent drift |
| M2 · DD | Directive Density | 1× | All workflows | 60–100 | How tightly packed with actionable instructions the workflow is |
| M3 · IAR | Instruction Ambiguity Rate | 1× | All workflows | 85–100 | How many instructions use vague modals with no qualifying condition |
| M4 · WCS | Wiring Completeness Score | 1× | Persona system present | 100 | Whether every defined persona is actually loaded and used |
| M5 · RI | Redundancy Index | 1× | All workflows | 75–95 | How much the same rule is repeated across files |
| M6 · ACC | Acceptance Criteria Concreteness | 2× | All workflows | 85–100 | Whether "done" conditions are numeric and verifiable, not subjective |
| M7 · SAS | Subagent Alignment Score | 1× | Subagent invocations present | 90–100 | Whether delegated tasks are genuinely safe to parallelise |
| M8 · HTC | Human Touchpoint Count | 2× | All workflows | 95–100 | How often a human must intervene during a full run |
| M9 · CDR | Context Decay Resilience | 2× | Session boundaries present | 100 | Whether every session handoff explicitly re-anchors intent |
| M10 · CLE | Context Loading Efficiency | 2× | All workflows | 80–100 | What fraction of loaded tokens are relevant to the current phase |
| M11 · PSS | Parallelisation Safety Score | 1× | Parallel execution present | 90–100 | Whether concurrent mutations have explicit guards and release mechanisms |
| M12 · IFS | Information Freshness Score | 2× | Cached artefacts present | 90–100 | Whether inter-session artefacts have TTL policies before re-use |
| M13 · ITE | Instruction Token Efficiency | 1× | All workflows | 80–100 | What fraction of tokens are load-bearing vs. filler/padding |
| M14 · PPF | Persona-Phase Fit Score | 1× | Persona system present | 80–100 | Whether each phase's assigned persona matches its cognitive demand, and whether unassigned phases should have one |
| M15 · PRS | Persona Richness Score | 1× | Persona system present | 85–100 | How complete and differentiated the persona files themselves are — do they define Unique Talent and Failure Mode? |

### Design Patterns

| ID | Pattern | Targets | When to apply |
|----|---------|---------|---------------|
| P1 | Intent Anchor Blocks | CDR ↑, IOT ↑ | Any workflow with session boundaries or 3+ phases |
| P2 | Staleness TTL Policies | IFS ↑ | Any workflow with cached artefacts read across sessions |
| P3 | Progressive Disclosure | CLE ↑, HTC ↓ | Any workflow with 3+ phases |
| P4 | Recommendation Brief | HTC ↓, IAR ↓ | Any workflow with a human approval gate |
| P5 | Claim Registry | PSS ↑ | Any workflow with parallel or concurrent execution |
| P6 | Symmetric Outcome Thresholds | ACC ↑ | Any workflow with multi-tier outcome classification |
| P7 | Binary Applicability Gates | IAR ↓, ACC ↑ | Any workflow with conditional or optional steps |
| P8 | Persona Rotation | PPF ↑ | Any workflow where a phase's persona is a poor fit, missing, or untested |
| P9 | Persona Speciation | PRS ↑, PPF ↑ | Any workflow where personas are thin (missing Unique Talent or Failure Mode) or where a cognitive demand has no matching persona |
| P10 | Failure Mode Registry | RPC ↑ | Any workflow with multiple conditional branches or error states |
| P11 | File Role Stratification | DD ↑, ITE ↑ | Any workflow that mixes agent-instruction files with human-reference files in the same directory |
| P12 | Content Synchronisation Audit | HCU ↑ | Any skill that maintains a parallel help/reference file alongside its command files |
| P13 | Corrective-Pattern Applicability Classification | PEV ↑ | Any workflow with a pattern library that distinguishes proactive from corrective patterns |
| P14 | Pre-Experiment Dependency Scan | EIS ↑ | Any multi-hypothesis session where ≥2 changes are queued |
| P15 | Measurement Accuracy Retrospective | RI ↑ (any estimated metric) | Any workflow where a metric has been estimated (not counted) for ≥2 consecutive runs at the same value |

### Stats at a Glance

Read `research-log.md` in the optimise skill directory and append a compact stats table:

| ID | Metric | Avg baseline | Best gain seen | Times weakest |
|----|--------|-------------|---------------|---------------|
| M1 · IOT | ... | ... | ... | ... |

Only include metrics that have been applied at least once. Keep it to one line per metric.
End with: *"Run `/optimise help <name or ID>` for full detail on any metric or pattern."*

---

## Mode: Detail (metric or pattern argument)

Find the section below that best matches the argument. Display only that section.

---

### Intent-to-Output Traceability (M1 · IOT)
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

### Directive Density (M2 · DD)
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

### Instruction Ambiguity Rate (M3 · IAR)
*Also matches: M3, IAR, ambiguity, modal, vague, should, may*

**Measures:** The proportion of instructions that use unscoped modal verbs ("should", "may", "might", "consider", "try to") with no qualifying condition. Score = 100 − ambiguity%, so a lower proportion of ambiguous instructions produces a higher score.

**Intent:** An instruction like "should be recorded" gives no guidance on when or why — two agents may interpret it differently. A scope qualifier ("should be recorded if the target is inside a git repo") makes the instruction deterministic. This metric identifies instructions that rely on agent judgment where explicit rules would be better.

**Applies when:** All workflows (universal).

**Weight:** 1×

**Healthy range:** 85–100 (fewer than 15% of instructions are ambiguous).

**Risk at low scores:** Instructions with soft modals become inconsistent between runs. Partial fixes become accepted as complete. The workflow "works" in testing but fails in the scenarios the author imagined but didn't write down.

**What counts as ambiguous:** `"should"`, `"may"`, `"might"`, `"consider"`, `"try to"` with no `if X` condition, no domain restriction, and no specific named target. Descriptive uses of "may/can" (stating a possibility, not an instruction) do not count.

**How to improve:** Apply Binary Applicability Gates — replace each soft modal with a concrete condition. "Should be recorded" → "Record if the target is inside a git repo."

**Stats:** Baseline range 88–93 across two runs. +5pp achieved in one experiment (Binary Applicability Tests). Confirmed rate: 1/1.

---

### Wiring Completeness Score (M4 · WCS)
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

### Redundancy Index (M5 · RI)
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

### Acceptance Criteria Concreteness (M6 · ACC)
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

### Subagent Alignment Score (M7 · SAS)
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

### Human Touchpoint Count (M8 · HTC)
*Also matches: M8, HTC, human, touchpoint, stall, approval, intervention*

**Measures:** How many times a full end-to-end run requires a human to provide input or approval (not counting the initial invocation).

**Intent:** Every human touchpoint is a workflow stall. Touchpoints that require open-ended answers (rather than approve/skip decisions) compound the problem by requiring the human to understand the workflow's internal state. This metric pressures the workflow towards autonomy and well-structured decision points.

**Applies when:** All workflows (universal).

**Weight:** 2×

**Healthy range:** 95–100 after normalisation (target: ≤1 mandatory touchpoint per run).

**Risk at low scores:** The workflow stalls repeatedly awaiting input. Users abandon it mid-run or batch all approvals without reading them, defeating the purpose of the review.

**How to improve:** Apply Recommendation Brief — replace open-ended questions with structured approve/skip decisions. The agent forms the recommendation; the human only needs to say yes or no.

**Stats:** Scored 100 after the Phase 3 approval gate was removed — the workflow now self-audits the hypothesis list and auto-proceeds. Zero mandatory touchpoints per run.

---

### Context Decay Resilience (M9 · CDR)
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

### Context Loading Efficiency (M10 · CLE)
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

### Parallelisation Safety Score (M11 · PSS)
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

### Information Freshness Score (M12 · IFS)
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

### Intent Anchor Blocks (P1)
*Also matches: P1, anchor, intent, re-read, drift*

**Problem it solves:** Without an explicit re-read at each phase transition, later phases operate on memory rather than the actual recorded output — causing compounding drift.

**How it works:** At every phase transition, the orchestrator re-reads the original intent artefact (e.g., `research-log.md`) before proceeding. The re-read is the first instruction in the phase, before any other work.

**Targets:** Context Decay Resilience (↑), Intent-to-Output Traceability (↑)

**When to apply:** Any workflow with session boundaries or more than three phases.

**Typical gain:** Scores that are already low on Context Decay Resilience tend to jump to 100 in a single experiment — the fix is structural and complete.

---

### Staleness TTL Policies (P2)
*Also matches: P2, TTL, stale, freshness, tier, regenerate, caveat*

**Problem it solves:** Workflows that re-read cached artefacts without checking their age silently operate on outdated data.

**How it works:** Every artefact that can go stale is tagged with a 3-tier policy: Regenerate (must be rebuilt if older than threshold or target has changed), Load-with-caveat (usable but flagged), or No-TTL (canonical, never expires). The check runs at the re-read point, before the artefact is used.

**Targets:** Information Freshness Score (↑)

**When to apply:** Any workflow with cached artefacts read across sessions.

**Typical gain:** Information Freshness Score goes from 0 to 100 in a single experiment — the metric is binary once the policy is in place.

---

### Progressive Disclosure (P3)
*Also matches: P3, progressive, phase-scoped, context, loading, on-demand*

**Problem it solves:** Loading the full workflow corpus at phase 1 and keeping it in context through all phases wastes tokens and creates noise that distracts later-phase work.

**How it works:** Each phase block lists only the files it needs. The orchestrator does not preload anything — context is loaded on entry to each phase and not carried forward.

**Targets:** Context Loading Efficiency (↑), Human Touchpoint Count (↓)

**When to apply:** Any workflow with three or more phases.

**Typical gain:** The most versatile pattern for Context Loading Efficiency. Three applications on the same target achieved +9pp, +17pp, and +20pp respectively as the pattern was applied at increasing granularity.

---

### Recommendation Brief (P4)
*Also matches: P4, brief, recommendation, approve, skip, open-ended, question*

**Problem it solves:** Workflows that ask open-ended questions require the human to understand the workflow's internal state in order to answer. This increases cognitive load and stall time.

**How it works:** The agent assembles all evidence, forms a recommended action per item, and presents each as a binary approve/skip decision. The human reads and decides; they do not need to generate answers.

**Targets:** Human Touchpoint Count (↓), Instruction Ambiguity Rate (↓)

**When to apply:** Any workflow with a human review or approval gate.

**Typical gain:** Reduces perceived friction even when the raw touchpoint count is unchanged — structured decisions are faster to process than open questions.

---

### Claim Registry (P5)
*Also matches: P5, registry, lock, mutex, claim, write lock, concurrent*

**Problem it solves:** Parallel agents writing to shared files without coordination silently corrupt data.

**How it works:** A shared registry file records which agent or phase currently holds a write lock on each artefact. All mutations check the registry before writing and release the lock on completion.

**Targets:** Parallelisation Safety Score (↑)

**When to apply:** Any workflow with parallel or concurrent execution.

**Typical gain:** Converts non-deterministic corruption failures into deterministic "lock held" errors that are debuggable.

---

### Symmetric Outcome Thresholds (P6)
*Also matches: P6, symmetric, thresholds, confirmed, partial, disconfirmed, numeric floor*

**Problem it solves:** Workflows that define the passing case concretely but leave lower tiers vague ("no meaningful improvement") create a gap where the agent applies its own judgment.

**How it works:** Define concrete numeric boundaries for every tier — not just the passing case. Use the confirmed/pass threshold as the anchor (e.g., ≥3pp) and define lower tiers relative to it (partial: ≥1pp but <3pp; disconfirmed: <1pp on all targets AND composite ≤0).

**Targets:** Acceptance Criteria Concreteness (↑)

**When to apply:** Any workflow with multi-tier outcome classification.

**Typical gain:** +13pp on Acceptance Criteria Concreteness in the run where it was first applied.

---

### Binary Applicability Gates (P7)
*Also matches: P7, binary, applicability, gate, condition, yes/no, deterministic*

**Problem it solves:** Vague feature-presence conditions like "multi-session orchestration: yes/no" require an agent to make a judgment call that different agents may resolve differently.

**How it works:** Replace each condition with a single yes/no question whose answer is deterministically derivable from an earlier phase's output. Example: "Does any phase block include a STOP or PAUSE instruction?" rather than "Does the workflow have session boundaries?"

**Targets:** Instruction Ambiguity Rate (↓), Acceptance Criteria Concreteness (↑)

**When to apply:** Any workflow with optional steps, conditional metric applicability, or skip/apply decisions.

**Typical gain:** +5pp on Instruction Ambiguity Rate, +6pp on Acceptance Criteria Concreteness in the run where it was applied.

---

### Persona Speciation (P9)
*Also matches: P9, speciate, speciation, distil, distillation, fork, evolve, new persona, unique talent, failure mode*

**Problem it solves:** Personas that are well-structured on paper but don't define a Unique Talent or Failure Mode behave like generic labels — they name a role but don't change output. Separately, workflows sometimes need a cognitive mode that no existing persona covers.

**How it works:** Two mechanisms:

*Speciation* — diverge an existing persona along one dimension (temporal scope, adversarial intensity, domain depth, output type) to create a focused variant that outperforms the generalist in its niche. Each speciated persona gets a new name and character, not a version number. Parent/child relationship is recorded in the child's `soul.md` Origin section.

*Distillation* — read a run log or retrospective where a persona was active. Extract behaviors that consistently produced measurably better outputs but aren't in the persona's DO rules. Crystallize them as concrete new rules. Prune rules that were never exercised. Deepen soul fields that the run revealed but the file doesn't capture. This is evidence-based sharpening, not guesswork.

Both are executed via `/personas evolve` — the command handles scoring, recommendation briefs, and file creation.

**Targets:** Persona Richness Score (↑), Persona-Phase Fit Score (↑)

**When to apply:**
- Persona Richness Score < 85 on any persona (missing Unique Talent or Failure Mode)
- A phase's cognitive demand has no matching persona in the library (gap-fill)
- A persona has been used in multiple runs but hasn't been updated based on what worked

**Typical gain:** First application on a library that lacks Unique Talent/Failure Mode across the board: expect +20–30pp on Persona Richness Score. Distillation gains are harder to predict but tend to produce more consistent per-phase output quality on subsequent runs.

---

### Persona Rotation (P8)
*Also matches: P8, persona, rotation, fit, alternative, invent, cognitive, style, reassign*

**Problem it solves:** A persona system that assigns the same persona to every phase, or that assigns a persona by name without matching cognitive style to phase demand, produces worse output than no persona at all — because the agent adopts a style that conflicts with the task.

**How it works:** For each phase that scores below full fit on Persona-Phase Fit (M14), try an alternative persona. First look for a better match among existing persona files. If none fits, invent a new persona: define name, core trait, cognitive style, what it emphasises, what it de-emphasises, and tone, and write it as a proper persona file. Compare the quality markers of the phase's output under the new assignment: does it produce more concrete outputs? More comprehensive coverage? More appropriate challenge?

**When to apply:**
- Any phase that scores partial or mismatch on Persona-Phase Fit
- Any phase that is currently unassigned but has a non-trivial cognitive demand (analysis, critique, strategy, creative generation)
- Any workflow whose persona files are thin (missing cognitive style, emphasis/de-emphasis fields, or tone)

**When to invent vs. reuse:** Invent a new persona when the cognitive demand is genuinely novel and no existing persona is within 80% of the ideal style. Do not assign a slightly-wrong existing persona just to avoid creating a file — the fit matters more than the file count.

**Targets:** Persona-Phase Fit Score (↑)

**Typical gain:** Likely varies significantly by target. On workflows where personas are currently decorative (name-only, or loaded without matching style), expect +20–40pp. On well-designed persona systems, Persona Rotation may confirm the existing assignments are near-optimal, which is also valuable evidence.

---

### Failure Mode Registry (P10)
*Also matches: P10, failure mode, failure mode registry, recovery, recovery path, error state, branch, fallback*

**Problem it solves:** Workflows with multiple conditional branches have implicit failure modes — situations where the agent has no prescribed next action. Without explicit recovery instructions, the agent improvises or halts, producing inconsistent results. The failure modes are usually known to the workflow designer but never written down, so each agent that encounters them is starting from scratch.

**How it works:** Enumerate all failure modes for the workflow. A failure mode is any state where a phase can produce an output that the next phase cannot proceed on: invalid target path, missing file, stale log, all branches skipped, confirmed disconfirmation, external command unavailable. For each failure mode, verify that the phase file contains an explicit recovery instruction — a prescribed next action the agent should take. Add recovery paths wherever they are missing.

**When to apply:**
- Multi-phase pipelines where some phases have conditional routing
- Data ingestion workflows where input validation can fail
- Deployment scripts with rollback conditions
- Any workflow where phases can produce distinct error states

**Targets:** Recovery Path Completeness (↑)

**Typical gain:** First application on a workflow with implicit failure modes: expect +20–40pp on Recovery Path Completeness. Effort is proportional to the number of conditional branches in the workflow.

---

### File Role Stratification (P11)
*Also matches: P11, file role, stratification, instruction file, documentation file, reference file, help file, human reference*

**Problem it solves:** Workflows that mix agent-instruction files (command files with imperative verbs, phase logic, DO/DO NOT rules) and human-reference files (help content, explanatory prose, reference tables) in the same directory produce misleading Directive Density and Instruction Token Efficiency scores. Documentation tokens dilute both metrics, making instruction quality appear lower than it is and masking genuine instruction padding.

**How it works:** Before scoring Directive Density (M2) and Instruction Token Efficiency (M13), classify each file by primary audience: *instruction file* (primary audience is an agent — contains phase logic, directives, DO/DO NOT rules) or *documentation file* (primary audience is a human — contains help content, reference tables, explanatory prose). Score only instruction files for both metrics. Record the classification in Phase 2 output so it can be re-applied consistently across runs.

**When to apply:**
- Any workflow directory that contains both command files and help/reference files
- Skills that have grown a help.md or reference guide alongside their agent command files
- When Directive Density or Instruction Token Efficiency scores seem unusually low despite well-written instructions

**Targets:** Directive Density (↑), Instruction Token Efficiency (↑)

**Typical gain:** On workflows with 1 documentation file among 5–6 instruction files: +5pp on Directive Density, +9pp on Instruction Token Efficiency. Gain scales with the proportion of documentation tokens in the corpus.

---

### Instruction Token Efficiency (M13 · ITE)
*Also matches: M13, ITE, token, efficiency, padding, filler, compression, density, verbose*

**Measures:** What fraction of tokens in command files carry load-bearing content (directives, conditions, examples, named entities) vs. padding (filler phrases, decorative structure, narrative restatement).

**Intent:** Every token an agent loads is a token it must process. Padding tokens — "please make sure to", "it is important that", decorative dividers, prose that describes rather than constrains — consume context budget without adding constraint. Tighter instructions are cheaper to load, less likely to be misread, and leave more room for the content that actually matters.

**Applies when:** All workflows (universal).

**Weight:** 1×

**Healthy range:** 80–100.

**Risk at low scores:** Instructions are verbose and harder to parse. The agent spends processing budget on filler before reaching the actual rule. In long workflows this compounds — later phases receive diluted signal.

**What counts as padding:**
- Throat-clearing preamble: "Please make sure to", "It is important that", "You should always remember to", "Note that", "Be aware that"
- Redundant intensifiers: "very", "really", "quite", "always" where already implied by context
- Decorative structure: divider lines used more than once per logical section, headers that restate the section title in the first sentence
- Narrative restatement: sentences with no imperative verb and no condition that describe what the workflow does rather than constraining how

**Note on tokenisation encoding:** A related but separate concern is how efficiently the text itself tokenises given the model's vocabulary (e.g. certain markdown symbols, CamelCase, or special characters produce more tokens per visible character than plain prose). This is worth tracking as a moonshot custom metric on targets where raw token cost is critical, but requires running an actual tokeniser and is too tooling-dependent to be a seed metric.

**How to improve:** Audit for the padding categories above. Replace preamble phrases with direct imperatives ("Record X if Y" instead of "Please make sure to always record X when Y occurs"). Remove decorative dividers that add no navigational value. Convert narrative description paragraphs into explicit DO / DO NOT rules.

**Stats:** New metric — no historical data yet.

---

### Content Synchronisation Audit (P12)
*Also matches: P12, content sync, synchronisation, help file, reference file, named entries, documentation, help currency*

**Problem it solves:** When a skill's instruction files gain new named entries — new metrics, new patterns, new phases, new steps — its parallel help or reference files fall out of sync. Users querying the help command find no entry for the new content, creating a gap between what the system does and what is documented. The trust chain between instruction and documentation breaks silently: no error is thrown, so the gap persists until someone notices by accident.

**How it works:** Whenever an instruction file is updated with new named entries in any session, read every corresponding reference or help file in the same session and check whether matching entries exist. Add missing entries before the session closes. Run this check proactively — do not wait until a baseline measures Help Content Currency (MX15) below threshold.

**When to apply:**
- Any skill that maintains a parallel help.md or reference guide alongside its command files
- After adding new metrics, patterns, phases, or named rules to any instruction file
- During any Phase 4 experiment that adds named content to instruction files

**Targets:** Help Content Currency (↑)

**Typical gain:** On a skill where 3 new patterns were added to instruction files but not yet documented in help.md: +15–25pp on Help Content Currency. Gain scales with the number of undocumented named entries.

---

### Corrective-Pattern Applicability Classification (P13)
*Also matches: P13, corrective, applicability, classification, trigger condition, dormant, pattern validation, PEV*

**Problem it solves:** Pattern libraries that grow over time mix two kinds of patterns: proactive patterns (apply to improve things that are already working) and corrective patterns (apply only when a specific measured condition is met). When measuring Pattern Experimental Validation Rate, treating never-applicable corrective patterns as unvalidated inflates perceived validation debt and creates pressure to run experiments on patterns whose trigger conditions have never fired.

**How it works:** In the pattern library, mark each corrective pattern with its explicit trigger condition using a `[corrective — applies when <condition>]` tag on the pattern header. When measuring Pattern Experimental Validation Rate (MX16 · PEV): count only applicable patterns in the denominator. A pattern is applicable if its trigger condition has been true at least once in the workflow's run history. A pattern whose trigger condition has never been true is correctly dormant — exclude it from the PEV denominator and record it as `N/A` rather than unvalidated.

**When to apply:**
- Any workflow with a pattern library that distinguishes proactive from corrective patterns
- When Pattern Experimental Validation Rate is below 90% and some unvalidated patterns have trigger conditions
- When adding a new corrective pattern to any library

**Targets:** Pattern Experimental Validation Rate (↑)

**Typical gain:** On a library where 1–2 corrective patterns have never been triggered: +8–15pp on Pattern Experimental Validation Rate by removing them from the denominator. The primary value is measurement accuracy — preventing false deficit signals.

---

### Pre-Experiment Dependency Scan (P14)
*Also matches: P14, dependency scan, file overlap, concurrent, sequential, multi-hypothesis, experiment isolation*

**Problem it solves:** When multiple hypotheses are approved in a single session and two or more modify the same file, applying them concurrently or in arbitrary order produces non-attributable metric deltas. It becomes impossible to assign credit or blame to either change — the score moved, but which hypothesis caused it?

**How it works:** Before applying the first experiment in any Phase 4 session, read the full list of pending (approved, not yet run) hypotheses. Check whether any two pending hypotheses modify the same file. If overlap is found: note it in the research log and run the overlapping hypotheses sequentially with a metric re-check between each. If no overlap exists: proceed in any order. This scan runs once per Phase 4 session, not once per hypothesis.

**When to apply:**
- Any Phase 4 session where ≥2 hypotheses are approved
- Any multi-hypothesis optimisation context where changes are queued for concurrent application

**Targets:** Experiment Isolation Score (↑)

**Typical gain:** Primarily a measurement integrity fix rather than a score improvement. On runs where overlapping hypotheses were previously applied concurrently: expect +10–20pp on Experiment Isolation Score. The main benefit is that future attribution decisions become trustworthy.

---

### Persona Richness Score (M15 · PRS)
*Also matches: M15, PRS, richness, persona, talent, failure mode, distil, depth, soul*

**Measures:** How complete and differentiated the persona files are for every persona loaded by the workflow — specifically whether they define a Unique Talent (the cognitive superpower that makes them irreplaceable) and a Failure Mode (when they cause harm).

**Intent:** A persona without a Unique Talent is generic — it names a role but does not change behaviour. A persona without a Failure Mode gets applied to phases where it actively makes things worse (a critic on a brainstorming phase, a builder on a planning phase). The richness score surfaces personas that are merely decorative, so the optimise loop can propose sharpening them through distillation or creating better-fit alternatives through speciation.

**Applies when:** The workflow references or loads any persona files.

**Weight:** 1×

**Healthy range:** 85–100 (at least 12/14 rubric points per persona). A score below 71% means Unique Talent and Failure Mode are both missing — the persona is structurally decorative regardless of its other content.

**Richness Rubric (14 points per persona):**
- Purpose defined (1pt), DO ≥3 rules (1pt), DO NOT ≥2 rules (1pt), When to summon (1pt): these form the functional skeleton
- **Failure Mode** (2pt): when not to use this persona — prevents misapplication
- soul.md present (1pt), Essence (1pt), Core Truths ≥3 (1pt), Opinions ≥2 (1pt), Contradictions ≥1 (1pt), Voice (1pt): these form the character layer
- **Unique Talent** (2pt): the specific cognitive superpower — must be narrow and non-generic

**Risk at low scores:** Personas are invoked but produce no measurable difference in output quality over no persona at all. Phases calling for analytical rigor get decorated with an "analytics" label but not with analytical constraints. Personas are assigned to harmful phases because no one documented when not to use them.

**How to improve:** Run `/personas evolve audit` to get a per-persona score breakdown and specific missing fields. Then `/personas evolve distil <name>` to sharpen existing personas using evidence from real runs, or `/personas evolve speciate <name>` to create a more potent narrower variant.

**Stats:** New metric — no historical data yet.

---

### Persona-Phase Fit Score (M14 · PPF)
*Also matches: M14, PPF, persona, fit, cognitive, role, assignment, rotation, mismatch*

**Measures:** Whether each phase's assigned persona matches the cognitive demands of that phase — and whether phases without a persona should have one.

**Intent:** A persona is not decoration. A critic persona on a measurement phase may produce sceptical scores that are too conservative; an analytics persona on a creative brainstorm may narrow the output prematurely. The value of a persona system comes from deliberate assignment — matching cognitive style to task demand. This metric surfaces mismatches that silently reduce output quality and identifies phases where adding a persona would be valuable but none was assigned.

**Applies when:** The workflow references or loads any persona files, or any phase includes a persona load directive.

**Weight:** 1×

**Healthy range:** 80–100.

**Risk at low scores:** Phases that would benefit from a sceptical reviewer fall back to the agent's default agreeable mode. Phases that need systematic enumeration get a creative persona that samples rather than catalogues. The workflow has a persona system but is not getting the benefit of it.

**Cognitive demand taxonomy:**
- **Analysis / measurement**: systematic enumeration, quantitative scoring, pattern detection → analytics-style persona
- **Strategy / planning**: prioritisation, synthesis, forward-projection → strategist-style persona
- **Critique / adversarial review**: fault-finding, challenge, stress-testing → critic-style persona
- **Reporting / documentation**: neutrality, comprehensiveness, clarity → neutral observer (no persona is correct here)
- **Creative generation**: divergent thinking, novelty-seeking → creative/expansive persona; a critic or analyst is a mismatch

**Persona depth check:** A persona file that defines only a name and one-line description is functionally decorative. For full credit, each loaded persona must define at minimum: name, core trait, cognitive style, what it emphasises, what it de-emphasises, and tone.

**How to improve:** Apply Persona Rotation (P8) — for each phase with a partial or mismatch score, try an alternative persona drawn from existing files or invent a new one. When inventing, write a proper persona file; do not assign a name without defining the cognitive style.

**Stats:** New metric — no historical data yet.

---

### Measurement Accuracy Retrospective (P15)
*Also matches: P15, retrospective, accuracy, estimated, re-audit, measurement, scope*

**Purpose:** When a metric has been estimated (rather than precisely counted) for two or more consecutive runs at the same value, conduct a targeted re-audit to either confirm the estimate or correct it.

**Problem it solves:** Estimated scores tend to accumulate hidden errors: the scope may silently drift to include out-of-scope files, or the counting method may differ from the metric's definition. A score that is stable but has never been directly verified is a liability — the system appears to be at a known quality level when it may not be. The Measurement Accuracy Retrospective converts a "probably correct" score into a ground-truth measurement.

**How to apply:**
1. Identify any metric that has not been directly measured from source files for ≥2 consecutive runs (look for "estimate", "approximately", or unchanged scores over multiple runs in the research-log).
2. Re-read the metric's definition and methodology from `p2-baseline.md` to confirm scope.
3. Count or score the metric precisely from the current source files — do not rely on the prior estimate.
4. If the precise count differs from the estimate by ≥2pp, update the score and record the mechanism ("scope included out-of-scope file X; corrected denominator").
5. If the precise count confirms the estimate, record that too ("precise audit confirmed estimate; no score change").

**When to apply:** Any run where a metric shows the same estimated score for ≥2 consecutive runs without a direct re-measurement.

**Healthy outcome:** The precise score either improves (estimate was pessimistic) or is confirmed (estimate was accurate). A score that worsens after re-measurement is a rare but important finding — it means the metric was over-estimated.

**Targets:** Redundancy Index (most commonly), Instruction Ambiguity Rate, any metric with a "~" or "approximately" qualifier in the baseline notes.

**Stats:** First applied in run 6 (self-optimisation). Corrected Redundancy Index from 88 to 97 by removing out-of-scope file from the scope.

---

### Loop Control (count mode / auto mode)
*Also matches: loop, count, auto, iterations, N runs, loop mode, termination*

**Purpose:** Run the full 5-phase optimise cycle multiple times on the same target, with automatic termination when either a count is reached or a quality threshold is met.

**Invocation modes:**

| Mode | Syntax | Terminates when |
|------|--------|----------------|
| Single run (default) | `/optimise <path>` | After Phase 5 completes |
| Count mode | `/optimise N <path>` | After N full iterations complete |
| Auto mode | `/optimise auto <path>` | Composite > 95%, OR Phase 3 produces zero hypotheses, OR 2 consecutive iterations with only Partial results |

**How it works:**
- Each iteration runs all 5 phases in sequence (Audit → Baseline → Hypothesise → Experiment → Report).
- Hypothesis numbering is continuous across iterations — do not reset to H1. If run 1 ends at H5, run 2 starts at H6.
- Confirmed changes from previous iterations must not be re-applied.
- At the start of each iteration, `research-log.md` is re-read as the Intent Anchor before Phase 1.

**When to use count mode:** When you want a fixed number of improvement passes (e.g., `/optimise 3 skills/ideation/` to run three optimisation loops on the ideation skill).

**When to use auto mode:** When you want to drive the composite above 95% and let the skill decide when to stop. Use with caution on first runs — if the baseline is low, auto mode may run many iterations.

**Loop termination safety:** Count mode always terminates. Auto mode has three exit conditions (score threshold, zero hypotheses, stalled-partial guard) to prevent infinite loops.
