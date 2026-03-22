## Phase 1 — Audit Target

**Persona: none (neutral observer)**

If `research-log.md` exists in the target directory, apply the 3-tier TTL policy before reading it (Intent Anchor):
- **Tier A — Regenerate**: the log's `**Target:**` header does not match `$ARGUMENTS` path → archive the existing log to `research-log-archived-<date>.md`, start a fresh log.
- **Tier B — Load-with-caveat**: target matches AND log date is >7 days old → load but flag to the user: "Warning: research-log.md is from <date> — scores may be stale."
- **Tier C — Use as-is**: target matches AND log is ≤7 days old → read and proceed.
- **Contamination check** (apply after Tier A/B/C): after loading, scan for `**Subjects:**` or `**Branch:**` metadata headers that reference a different workflow (e.g., subject names not matching the target directory). If found, warn the user: "Warning: this research-log appears to contain data from a different target (subjects: <X>). Prior score data in the contaminated section should not be used as a baseline." Continue with the run — do not archive unless the user requests it.
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
5. **Persona staleness check** (apply if persona system is present):
   - For each persona load directive found in command files, check whether the referenced `persona.md` file exists at the stated path. If missing: flag as a broken reference — "Warning: phase N loads `<path>` which does not exist. This phase will run without a persona."
   - For each persona file that does exist, check its `soul.md` for an `## Origin` section. If the Origin indicates this is a parent that has been speciated (i.e., child personas exist in sibling directories with this one named as their Origin), note it: "Note: `<persona>` has been speciated into `<children>`. Consider whether the phase should use a more specific variant."
   - Record any broken references and speciation notes in `research-log.md` under the audit entry. Do not block the run — these are warnings, not errors.

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

When Phase 1 is complete, read `commands/phases/p2-baseline.md` to continue.
