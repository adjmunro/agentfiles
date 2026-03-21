---
id: "260321-date-format/TASK-003"
subject: "260321-date-format"
plan: "../../01-plan/260321-date-format/plan-date-format.md"
effort: medium
status: todo
created_at: "2026-03-21T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-002"
spawned_tickets: []
plan_items:
  - "Req 2.1 — Update id: frontmatter in all ticket files"
  - "Req 2.2 — Update subject: frontmatter in all ticket files"
  - "Req 2.3 — Update plan: relative paths in all ticket files"
  - "Req 3.1 — Update # YYMMDD-<subject> titles in input files"
  - "Req 3.2 — Update ## Research: YYMMDD-<subject> headers in research files"
  - "Req 3.3 — Update all other internal cross-references"
acceptance_criteria:
  - "grep -r 'YYMMDD\\|260321' .kanban/ returns no matches after edits"
  - "All ticket id: fields use 2026-03-21-<subject>/TASK-NNN format"
  - "All ticket subject: fields use 2026-03-21-<subject> format"
  - "All ticket plan: relative paths resolve correctly to renamed directories"
  - "All input file title lines (# ...) use 2026-03-21-<subject>"
  - "All research file ## Research: headers use 2026-03-21-<subject>"
  - "Files edited: all 11 ticket/plan/research files identified in research snapshot (50 occurrences across .kanban/)"
consecutive_failures: 0
---

## Context

After directories are renamed (TASK-002), update the content inside `.kanban/` files to match. Three frontmatter fields need updating in every ticket file (`id`, `subject`, `plan`). Title and header lines in input and research files need updating. Any other internal cross-references (e.g. audit table subject references) need updating.

Directories renamed in TASK-002 — this ticket only touches file content, not paths.

Traced to: Req 2.1, 2.2, 2.3, 3.1, 3.2, 3.3.

## Acceptance Criteria

- `grep -r 'YYMMDD\|260321' .kanban/` returns no matches
- All ticket frontmatter fields updated
- All title/header lines updated
- All relative paths in `plan:` fields resolve correctly

---
<!-- Everything below this line is append-only and chronological -->
