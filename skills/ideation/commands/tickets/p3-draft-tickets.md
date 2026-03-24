# Phase 3 — Draft Tickets
<!-- Part of: tickets.md orchestrator -->
<!-- Active when: Scout research complete (Phase 2 done) -->

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
id: "YYYY-MM-DD-{subject}/TASK-NNN"
subject: "YYYY-MM-DD-{subject}"
plan: "../02-plan-{subject}.md"
effort: low | medium | high
status: todo | in_progress | in_review | done
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

Field notes:
- `id` — `YYYY-MM-DD-{subject}/TASK-NNN` where NNN is zero-padded (001, 002, ...)
- `plan` — points to `../02-plan-{subject}.md` relative to the ticket file
- `plan_items` — list every plan requirement this ticket addresses
- `depends_on` — omit or leave empty if this ticket has no dependencies
- `acceptance_criteria` — must be empirically verifiable commands or observable states

> Cross-reference: `skills/implement/commands/_shared.md § Ticket Frontmatter Schema` uses the same fields. If the implement skill's schema diverges, keep this definition authoritative for ideation-created tickets.

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

### Vague → Concrete Reference

Use this table when drafting ACs to catch common vague patterns before the Critic audit:

| Pattern | Vague | Concrete |
|---------|-------|----------|
| File exists | "Config file created" | "`ls .env` exits 0 and file contains `DATABASE_URL`" |
| Test passes | "Tests pass" | "`npm test -- --testPathPattern=auth` exits 0, 0 failures" |
| API response | "Returns correct data" | "GET /users/1 returns HTTP 200 with `{\"id\":1}` in body" |
| No regressions | "Existing tests still work" | "`npm test` exits 0, same number of passing tests as before claim" |

### AC Commands — Environment Note

When writing shell commands as ACs, use relative paths from the project root. In Claude Code environments, avoid `grep` in Bash — use the `Grep` tool instead for content searches. Where a Bash command is necessary, write it as a `python3 -c` assertion where possible, since Python is portable and avoids shell-tool restrictions.

### File Naming

```
TASK-001-{subject}.md
TASK-002-{subject}.md
...
```

Where `{subject}` is the short slug portion of the parent directory name (strip the `YYYY-MM-DD-` date prefix).

→ Next: Read `tickets/p4-critic-audit.md` and execute it. (The final git commit happens in p5, after the audit passes.)
