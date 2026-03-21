---
id: "260321-date-format/TASK-004"
subject: "260321-date-format"
plan: "../../01-plan/260321-date-format/plan-date-format.md"
effort: medium
status: todo
created_at: "2026-03-21T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-001"
spawned_tickets: []
plan_items:
  - "Req 4.1 — Replace YYMMDD in all 9 command files"
  - "Req 4.2 — Replace date +%y%m%d with date +%Y-%m-%d"
  - "Req 4.3 — Update example slugs in command files"
  - "Req 6.1 — Update commit message templates in command files"
acceptance_criteria:
  - "grep -r 'YYMMDD' skills/kanban/commands/ returns no matches"
  - "grep -r 'date +%y%m%d' skills/kanban/commands/ returns no matches"
  - "grep -r 'date +%Y-%m-%d' skills/kanban/commands/ returns matches in capture.md, plan.md, and init.md"
  - "All 9 command files updated: capture.md, plan.md, todo.md, work.md, review.md, pr.md, cleanup.md, next.md, init.md"
  - "Commit message template examples in command files use YYYY-MM-DD-<subject> format"
  - "All example subject slugs in command files use YYYY-MM-DD- prefix"
consecutive_failures: 0
---

## Context

Update all 9 command files under `skills/kanban/commands/` to replace `YYMMDD` with `YYYY-MM-DD` throughout — in phase instructions, bash command examples, commit message templates, and subject derivation steps. Also fix the `date` command template from `date +%y%m%d` to `date +%Y-%m-%d` in the three files that use it (capture.md, plan.md, init.md).

This ticket is independent of the directory rename (TASK-002) and can run in parallel.

Traced to: Req 4.1, 4.2, 4.3, 6.1.

## Acceptance Criteria

- `grep -r 'YYMMDD' skills/kanban/commands/` returns no matches
- `grep -r 'date +%y%m%d' skills/kanban/commands/` returns no matches
- All 9 command files touched
- Commit message templates and example slugs use YYYY-MM-DD format

---
<!-- Everything below this line is append-only and chronological -->
