---
id: "260321-date-format/TASK-002"
subject: "260321-date-format"
plan: "../../01-plan/260321-date-format/plan-date-format.md"
effort: medium
status: in-review
created_at: "2026-03-21T00:00:00Z"
claimed_at: "2026-03-21T22:50:00Z"
completed_at: "2026-03-21T23:00:00Z"
stale_after_hours: 4
depends_on:
  - "TASK-001"
spawned_tickets: []
plan_items:
  - "Req 1.1 — Rename all .kanban/ YYMMDD- dirs to YYYY-MM-DD-"
  - "Req 1.2 — Include date-format subject itself"
acceptance_criteria:
  - "All 11 subject directories under .kanban/ are renamed from 260321-<subject> to 2026-03-21-<subject> using mv"
  - "Specifically: 260321-date-format→2026-03-21-date-format, 260321-command-handoff (×4 stages)→2026-03-21-command-handoff, 260321-kanban-ux-hints (×4 stages)→2026-03-21-kanban-ux-hints, 260321-capture-flow (06-archive)→2026-03-21-capture-flow, 260321-pr-trunk-skip (06-archive)→2026-03-21-pr-trunk-skip"
  - "Also rename active 02-todo subject dirs: 260321-capture-flow→2026-03-21-capture-flow, 260321-pr-trunk-skip→2026-03-21-pr-trunk-skip"
  - "find .kanban -type d -name '260321-*' returns no results after rename"
  - "find .kanban -type d -name '2026-03-21-*' returns 11+ results"
  - "All ticket files still exist at their new paths (mv preserved them)"
consecutive_failures: 0
---

## Context

Rename all 11 `.kanban/` subject directories from `260321-` prefix to `2026-03-21-` using `mv`. The directory is the audit trail — delete+recreate is forbidden. This includes the `date-format` subject directory itself (self-referential rename). After this ticket, the working directory for subsequent tasks is `.kanban/01-plan/2026-03-21-date-format/`.

Traced to: Req 1.1, 1.2.

## Acceptance Criteria

- All 11 dirs renamed via `mv`
- `find .kanban -type d -name '260321-*'` returns nothing
- `find .kanban -type d -name '2026-03-21-*'` returns 11+ results
- All files still present at new paths

---
<!-- Everything below this line is append-only and chronological -->

## Work Log — 2026-03-21T22:50:00Z

Renamed 13 directories from `260321-` to `2026-03-21-` using `mv`.

| Old path | New path |
|----------|----------|
| `.kanban/01-plan/260321-date-format/` | `.kanban/01-plan/2026-03-21-date-format/` |
| `.kanban/01-plan/260321-unified-pipeline/` | `.kanban/01-plan/2026-03-21-unified-pipeline/` |
| `.kanban/02-todo/260321-date-format/` | `.kanban/02-todo/2026-03-21-date-format/` |
| `.kanban/02-todo/260321-kanban-ux-hints/` | `.kanban/02-todo/2026-03-21-kanban-ux-hints/` |
| `.kanban/03-in-progress/260321-date-format/` | `.kanban/03-in-progress/2026-03-21-date-format/` |
| `.kanban/03-in-progress/260321-kanban-ux-hints/` | `.kanban/03-in-progress/2026-03-21-kanban-ux-hints/` |
| `.kanban/04-in-review/260321-date-format/` | `.kanban/04-in-review/2026-03-21-date-format/` |
| `.kanban/04-in-review/260321-kanban-ux-hints/` | `.kanban/04-in-review/2026-03-21-kanban-ux-hints/` |
| `.kanban/05-pull-request/260321-date-format/` | `.kanban/05-pull-request/2026-03-21-date-format/` |
| `.kanban/06-archive/260321-capture-flow/` | `.kanban/06-archive/2026-03-21-capture-flow/` |
| `.kanban/06-archive/260321-command-handoff/` | `.kanban/06-archive/2026-03-21-command-handoff/` |
| `.kanban/06-archive/260321-kanban-ux-hints/` | `.kanban/06-archive/2026-03-21-kanban-ux-hints/` |
| `.kanban/06-archive/260321-pr-trunk-skip/` | `.kanban/06-archive/2026-03-21-pr-trunk-skip/` |

Verification:
- `find .kanban -type d -name '260321-*'`: (empty — no results)
- `find .kanban -type d -name '2026-03-21-*'`: 13 results
