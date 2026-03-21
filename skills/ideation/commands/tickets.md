---
model: claude-opus-4-6
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion
argument-hint: "[YYYY-MM-DD-{subject}] — subject to create tickets for"
---

## Personas

- `../../personas/scout/persona.md` — **Finn (Scout)** — active in Phase 2
- `../../personas/critic/persona.md` — **Arden (Critic)** — active in Phase 4

Read each file before proceeding. Identify by the active persona when communicating with the user.

## DO

- Write all tickets to `03-refinement/` — this is the only valid staging location during ideation
- Make TASK-001 always the TDD red phase — no exceptions, never skip, never merge into another ticket
- Write acceptance criteria that are empirically verifiable: a runnable command with expected output, or an unambiguous observable state
- Auto-fix all audit gaps before committing — never ask permission to fix
- Commit once after drafting tickets, once after the audit passes

## DO NOT

- Write any ticket to `04-todo/` — that is the Step 9 promotion gate, not yours
- Skip or merge TASK-001 with any other ticket
- Write vague ACs — "documentation updated" is not acceptable; "grep -c 'TODO' docs/ returns 0" is
- Create tickets for version bumps or changelog updates — those happen automatically in commits
- Proceed if the plan file (`02-plan-{subject}.md`) is missing

---

## Phase 1 — Load Plan

Derive the subject using the following priority order. Stop at the first match:

1. **`$ARGUMENTS`** — if arguments contain a `YYYY-MM-DD-*` pattern, use it as-is.
2. **Existing `.kanban/` subject directories** — if exactly one subject directory exists with a `02-plan-*.md` file, use that name.
3. **Git worktree path** — take the last path segment of the current worktree entry.
4. **Conversation context** — synthesise a slug from what the work is about.
5. **Branch name and recent commits** — derive from `git branch --show-current` and `git log --oneline -5`.
6. **Last resort** — combine today's date with a brief summary slug.

**Slugify rules:** lowercase, hyphens for spaces, alphanumerics and hyphens only.

Once the subject is derived, locate the plan file:

```
.kanban/YYYY-MM-DD-{subject}/02-plan-{subject}.md
```

**STOP:** If the plan file does not exist, report: "No plan found. Run `/ideate` through Step 6 first." Do not proceed.

**STOP:** If the plan file exists but contains no audit section (look for a heading containing "Audit" or "audit"), report: "Plan has not been audited. Run `/ideate` through Step 5 first." Do not proceed.

Read the plan file in full. Enumerate every numbered requirement — these are the items that must map to ticket ACs during the audit.

---

## Phase 2 — Scout Research (Brief)

Activate **Finn (Scout)**. Run a quick, focused codebase scan to inform ticket scope and dependencies. This is not a full research session — it supplements the `01-research-{subject}.md` snapshot already written during Step 2.

Scout is read-only. No files are modified in this phase.

### Scout Tasks

1. Read `01-research-{subject}.md` if it exists — avoid duplicating work already done.
2. Identify any relevant files, patterns, or conventions that have changed since that snapshot.
3. Check what already exists so tickets don't duplicate implemented work.
4. Note dependencies between the work items to suggest ticket ordering.

Scout does not write a new research file here. If findings are significant, note them inline as you draft tickets (Phase 3).

---

## Phase 3 — Draft Tickets

Activate the main implementation persona. Draft each ticket as a separate file.

### Destination Directory

All tickets MUST be written to:

```
.kanban/YYYY-MM-DD-{subject}/03-refinement/
```

**NEVER write tickets to `04-todo/`** — that directory is the Step 9 promotion gate. Tickets only move there when the user explicitly chooses "Add to backlog" at Step 9.

### TASK-001 — TDD Red Phase (mandatory, always first)

TASK-001 is ALWAYS the TDD red phase. No exceptions.

- **What it verifies**: that neither the skill nor any key files exist yet (red — nothing passes yet)
- **Effort**: `low`
- **ACs**: verify that the target files do not exist, test stubs fail, no implementation is present

### Remaining Tickets

For each logical unit of work:

- One ticket per self-contained unit completable in a single agent session
- Small enough for a low-effort model to implement without ambiguity
- Use Scout's dependency findings to set `depends_on` in frontmatter

**Effort tiers:**
- `low` — research, documentation, simple utilities; use a fast/cheap model
- `medium` — standard implementation work; use a standard model
- `high` — complex reasoning, security-critical logic, architectural decisions; use the most capable model

### Ticket Frontmatter Schema

Use exactly these fields. Do not add or remove fields.

```yaml
---
id: "{subject}/TASK-NNN"
subject: "{subject}"
plan: "../02-plan-{subject}.md"
effort: low|medium|high
status: todo
created_at: "YYYY-MM-DDTHH:MM:SSZ"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on: []
spawned_tickets: []
plan_items:
  - "Req X.Y — description"
acceptance_criteria:
  - "runnable command — expected result"
consecutive_failures: 0
---
```

- `id` — `{subject}/TASK-NNN` where NNN is zero-padded (001, 002, ...)
- `plan_items` — list every plan requirement this ticket addresses
- `depends_on` — omit or leave empty if this ticket has no dependencies
- `acceptance_criteria` — see rules below

### Ticket Body Structure

```markdown
## Context
[Why this ticket exists, traced directly to plan items. Written once, never modified.]

## Acceptance Criteria
[Complete list. Each item is empirically verifiable — a command with expected output, or a state that can be observed without interpretation.]

<!-- Everything below this line is append-only and chronological -->
```

### Acceptance Criteria Must Be Empirically Verifiable

Every AC MUST be verifiable by running a command or observing a concrete state. Vague criteria are not acceptable.

| NOT acceptable | Acceptable |
|---|---|
| "Documentation updated" | "`grep -c 'TODO' docs/` returns 0" |
| "Tests pass" | "`npm test -- --testPathPattern=auth` exits 0" |
| "Error handling improved" | "Sending request without auth header returns HTTP 401 with body `{\"error\":\"unauthorized\"}`" |

ACs answer *"how do I know it's done?"* — not *"how should it be built?"*. Do not specify file names, directory locations, or function names unless they are genuinely externally observable constraints.

### File Naming

```
TASK-001-{subject}.md
TASK-002-{subject}.md
...
```

Where `{subject}` is the short slug portion of the parent directory name (strip the `YYYY-MM-DD-` date prefix).

Git commit after writing all ticket files:

```
kanban(tickets): draft N tickets for {subject}
```

---

## Phase 4 — Critic Audit Gate (Step 8)

Activate **Arden (Critic)**. Audit ticket coverage against plan requirements.

### Scoring

- **Full** — requirement is directly addressed by a ticket's AC with a verifiable command or observable state
- **Partial** — requirement is mentioned in a ticket's context or `plan_items` but the AC doesn't fully verify it
- **Missing** — no ticket addresses the requirement

Score: `(full + 0.5 × partial) / total × 100`

**Threshold: 95%.** Do not round up.

### Audit Table

Build a coverage table:

| # | Requirement | Ticket(s) | Status | Notes |
|---|-------------|-----------|--------|-------|
| 1 | Req text    | TASK-001  | Full   |       |

### Auto-Fix (if score < 95%)

If the score falls below 95%, auto-fix immediately — **never ask permission**:

1. For every **Missing** requirement: create a new ticket in `03-refinement/` that covers it.
2. For every **Partial** requirement: strengthen the relevant ticket's ACs so they are fully verifiable.
3. Re-run the audit, update the table and score.
4. Repeat until the threshold is met.

### Audit Block

Append this block to the plan file (`02-plan-{subject}.md`):

```markdown
## Audit: plan → tickets — PASS|FAIL
**Date**: ISO8601  **Threshold**: 95%

| # | Requirement | Ticket(s) | Status | Notes |
|---|------------|-----------|--------|-------|
| 1 | Req text   | TASK-001  | Full   |       |

- Full: N, Partial: N, Missing: N — Total: N
- Score: (full + 0.5×partial) / total × 100 = **XX%**

### Fixes Applied
- Created TASK-NNN for requirement X (was Missing)
- Strengthened TASK-NNN AC for requirement Y (was Partial)
```

Git commit after audit passes:

```
kanban(tickets): audit verified {subject}
```

---

## Phase 5 — Git Commit

After Phase 4 completes and the audit passes:

1. Stage all new and modified files.
2. Commit with the message:

```
kanban(tickets): draft N tickets for {subject}
```

Include in the commit body:
- Number of tickets created
- Audit score
- Any tickets auto-created during the fix pass

---

## Key Rules Summary

| Rule | Detail |
|------|--------|
| Ticket destination | `03-refinement/` only — never `04-todo/` |
| TASK-001 | Always TDD red phase — no exceptions |
| ACs | Must be empirically verifiable commands or observable states |
| Audit threshold | 95% — do not round up |
| Auto-fix | Fix gaps immediately — never ask permission |
| Version/changelog tickets | Never create these — they happen automatically in commits |
| Frontmatter schema | Fixed — use exact fields from schema above |
