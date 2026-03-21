---
model: claude-sonnet-4-6
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, Agent, AskUserQuestion
argument-hint: "[YYMMDD-subject] — subject to break down; omit to auto-derive"
---

## DO

- Scout the codebase and write a research snapshot before creating any tickets
- Create one TASK-001 ticket for the TDD red phase — always, no exceptions
- Create one ticket per logical unit of work, ordered by dependency
- Confirm the full ticket list with the user before writing any files
- Run a Critic audit after writing tickets and auto-fix any gaps
- Commit after each phase

## DO NOT

- Modify source code — Scout is read-only
- Create tickets before the user confirms the plan
- Skip TASK-001 or merge the TDD red phase into another ticket
- Write vague acceptance criteria — every AC must be an empirically verifiable command or observable state
- Proceed if no verified plan exists

---

## Session Boundary

Derive `YYMMDD-subject` using the following priority order. Stop at the first match:

1. **`$ARGUMENTS`** — if arguments contain a `YYMMDD-*` pattern, use it as-is.
2. **Existing `.kanban/01-plan/` directories** — if exactly one subject directory exists and no argument was passed, use that name.
3. **Git worktree path** — take the last path segment of the current worktree entry.
4. **Conversation context** — synthesise a slug from what the work is about.
5. **Branch name and recent commits** — derive from `git branch --show-current` and `git log --oneline -5`.
6. **Last resort** — combine today's date with a brief summary slug.

**Slugify rules:** lowercase, hyphens for spaces, alphanumerics and hyphens only.

Once the subject is derived, locate the plan file:

```
.kanban/01-plan/YYMMDD-subject/plan-YYMMDD-subject.md
```

**STOP:** If the plan file does not exist, report: "No verified plan found. Run `/kanban-plan` first." Do not proceed.

**STOP:** If the plan file exists but contains no audit section (look for a heading containing "Audit" or "audit"), report: "No verified plan found. Run `/kanban-plan` first." Do not proceed.

---

## Phase 1 — Scout (read-only research)

Spawn a Scout subagent if your environment supports subagents. If not, run Scout behavior in the current session. Either way: **Scout MUST NOT modify any source file or create any ticket.**

Scout's mission is to read and map, then write a single research snapshot.

### Scout Tasks

1. Read the plan file in full: `.kanban/01-plan/YYMMDD-subject/plan-YYMMDD-subject.md`
2. Read the project's directory structure (top two levels).
3. Read relevant source files, configs, and entry points identified in the plan.
4. Grep for existing implementations, test patterns, and related conventions.
5. Identify what already exists versus what needs to be built.
6. Note tight coupling, fragile areas, and files that require extra care.
7. Suggest a ticket sequence based on what depends on what.

### Scout Output

Write findings to:

```
.kanban/01-plan/YYMMDD-subject/research-YYMMDD-subject.md
```

Use exactly this structure:

```markdown
## Research: YYMMDD-subject
**Date**: ISO8601
**Status**: Snapshot — may go stale. Verify before acting.

## Project Structure
[What exists and where — relevant files and directories]

## Relevant Patterns
[Existing conventions, naming, style, test structure the implementation must follow]

## Dependencies
[What touches what; coupling concerns; shared state]

## Hazards
[Files or areas requiring extra care — fragile tests, tight coupling, security boundaries]

## Recommended Ticket Sequence
[Scout's suggested order, with brief rationale based on dependencies]
```

Git commit after writing: `kanban(todo): write research for YYMMDD-subject`

---

## Phase 2 — Ticket Planning

Read the plan file and enumerate every numbered requirement.

### TASK-001 — TDD Red Phase (mandatory, always first)

TASK-001 is ALWAYS the TDD red phase. No exceptions. Do not skip it. Do not merge it into another ticket.

- **Effort:** `low`
- **Acceptance criteria:** all test stubs are written and every stub fails (no implementation exists yet)
- **Body:** describe what each test asserts, what functions, types, or interfaces the tests expect to find

### Remaining Tickets

For each logical unit of work beyond the TDD scaffolding:

- One ticket per self-contained unit completable in a single agent session
- Use Scout's recommended sequence as the default ordering
- Set `depends_on` in frontmatter wherever ordering is mandatory
- Assign effort tier based on reasoning load and risk (see schema below)

**Effort tiers:**
- `low` — research, documentation, simple utilities; use a fast/cheap model
- `medium` — standard implementation work; use a standard model
- `high` — complex reasoning, security-critical logic, architectural decisions; use the most capable model

### Confirm Before Writing

**STOP and confirm with the user** before creating any ticket files. Present the proposed list in this format:

```
Proposed tickets for YYMMDD-subject:

  TASK-001  TDD Red Phase — [one-line description]          (no deps)
  TASK-002  [Title]       — [one-line description]          (depends: TASK-001)
  TASK-003  [Title]       — [one-line description]          (depends: TASK-002)
  ...

Proceed with creating these tickets? (yes / adjust)
```

Do not write any files until the user confirms.

---

## Phase 3 — Write Tickets

Once the user confirms, write each ticket to:

```
.kanban/02-todo/YYMMDD-subject/TASK-NNN-subject.md
```

Where:
- `NNN` = zero-padded 3-digit sequence number (001, 002, ...)
- `subject` = the short slug portion of the parent directory name (strip the `YYMMDD-` date prefix)

### Ticket Frontmatter Schema

```yaml
---
id: "YYMMDD-subject/TASK-NNN"
subject: "YYMMDD-subject"
plan: "../../01-plan/YYMMDD-subject/plan-YYMMDD-subject.md"
effort: low | medium | high
status: todo
created_at: "ISO8601"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-001"
spawned_tickets: []
plan_items:
  - "Req 2.1 — description"
acceptance_criteria:
  - "Verifiable command or observable output"
consecutive_failures: 0
---
```

- `depends_on` — omit the field entirely if this ticket has no dependencies
- `plan_items` — list every plan requirement this ticket addresses
- `acceptance_criteria` — runnable commands with expected outputs, or unambiguous observable states

### Ticket Body Structure

```markdown
## Context
[Why this ticket exists, traced directly to plan items. Written once, never modified.]

## Acceptance Criteria
[Complete list. Each item is empirically verifiable — a command with expected output, or a state that can be observed without interpretation.]

---
<!-- Everything below this line is append-only and chronological -->
```

### AC Must Be Empirically Verifiable

Every acceptance criterion MUST be verifiable by running a command or observing a concrete state. Vague criteria are not acceptable.

| NOT acceptable | Acceptable |
|---|---|
| "Documentation updated" | "`grep -c 'TODO' docs/` returns 0" |
| "Tests pass" | "`npm test -- --testPathPattern=auth` exits 0" |
| "Error handling improved" | "Sending request without auth header returns HTTP 401 with body `{\"error\":\"unauthorized\"}`" |

Git commit after writing: `kanban(todo): create N tickets for YYMMDD-subject`

---

## Phase 4 — Critic Audit Gate

Run a plan → todo coverage audit. The Critic role checks that every plan requirement maps to at least one ticket's `plan_items` or acceptance criteria. Threshold: **95%**.

### Scoring

- **Full** — requirement is directly addressed by a ticket's AC
- **Partial** — requirement is mentioned in context but AC doesn't fully verify it
- **Missing** — no ticket addresses the requirement

Score: `(full + 0.5 × partial) / total × 100`

### Audit Format

Append this block to the plan file (`plan-YYMMDD-subject.md`):

```markdown
## Audit: plan → todo — PASS|FAIL
**Date**: ISO8601  **Threshold**: 95%

| # | Requirement | Ticket(s) | Status | Notes |
|---|------------|-----------|--------|-------|
| 1 | Req text   | TASK-001  | Full   |       |

- Full: N, Partial: N, Missing: N — Total: N
- Score: (full + 0.5×partial) / total × 100 = **XX%**

### Fixes Applied
- Created TASK-NNN for requirement X (was Missing)
```

### Auto-Fix

If the score is below 95%:

1. Create additional tickets for every Missing requirement.
2. Upgrade Partial tickets by strengthening their acceptance criteria.
3. Re-run the audit and update the table and score.
4. Repeat until the threshold is met.

Git commit after audit: `kanban(todo): audit verified YYMMDD-subject`

---

## Phase 5 — Report

Report to the user:

- Subject name and how it was derived
- Path to the research snapshot
- Number of tickets created and their titles
- Audit result (PASS/FAIL, score)
- Any tickets auto-created during the audit fix pass

Keep the report concise. The user should be able to see at a glance that the todo phase succeeded and which ticket to pick up first.
