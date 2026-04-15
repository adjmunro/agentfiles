## Phase 1 — Audit Target

**Persona: Pulse (Analytics)** — load `../../../personas/analytics/persona.md` now. If the file is not found, proceed without the persona and note its absence at the start of Phase 1 output. Identify as Pulse in all Phase 1 output when the persona is loaded.

### Run Log Setup

1. Use `Glob` to count files matching `<target>/optimise/researchlog-*.md`. Let **NNN** = count + 1, zero-padded to three digits (e.g. `001`, `012`). The **run log** for this invocation is `<target>/optimise/researchlog-NNN.md`. Record this path — all subsequent phases write to and re-read this file.
2. **Cross-run context** — if NNN > 001, read the `<!-- SUMMARY-START -->…<!-- SUMMARY-END -->` block from `<target>/optimise/researchlog-<NNN-1>.md`:
   - Note the previous composite score as a reference baseline.
   - List any hypotheses marked Confirmed or Disconfirmed. Record them as excluded under `## Phase 1 — Audit` in the run log — these need not be re-applied in the current run.
   - If the previous log is missing or has no SUMMARY block, proceed without cross-run context and note the absence in the run log.

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
5. **Persona staleness check** (apply if persona system is present):
   - For each persona load directive found in command files, check whether the referenced `persona.md` file exists at the stated path. If missing: flag as a broken reference — "Warning: phase N loads `<path>` which does not exist. This phase will run without a persona."
   - For each persona file that does exist, check its `soul.md` for an `## Origin` section. If the Origin indicates this is a parent that has been speciated (i.e., child personas exist in sibling directories with this one named as their Origin), note it: "Note: `<persona>` has been speciated into `<children>`. If child personas exist in sibling directories, check whether one would improve fit for this phase over the parent."
   - Record any broken references and speciation notes in `research-log.md` under the audit entry. Do not block the run — these are warnings, not errors.

Create `<target>/optimise/` if it does not exist. Write the run log at `<target>/optimise/researchlog-NNN.md` with this structure:

```markdown
<!-- SUMMARY-START -->
## Run NNN — <date> | Target: <path>
Composite: (pending) → (pending)

### Hypotheses
| ID  | Description | Outcome |
|-----|-------------|---------|
| (populated after Phase 3) | | |

### Metric Snapshot
| Metric | Baseline | Post |
|--------|---------|------|
| (populated after Phase 2) | | |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

**Target:** <path>
**Files:** <count> total (<command count> command, <support count> support)
**Token estimate:** ~<total> tokens

### Excluded from this run (confirmed/disconfirmed in prior runs)
<list from cross-run context, or "none" if NNN = 001>

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

When Phase 1 is complete, read `commands/phases/p2-baseline.md` to continue.

> **Note for all subsequent phases:** The run log path (`<target>/optimise/researchlog-NNN.md`) was established above. Every phase that says "re-read the run log" or "write to the run log" refers to this file.
