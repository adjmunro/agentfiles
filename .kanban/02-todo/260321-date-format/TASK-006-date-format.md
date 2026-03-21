---
id: "260321-date-format/TASK-006"
subject: "260321-date-format"
plan: "../../01-plan/260321-date-format/plan-date-format.md"
effort: low
status: todo
created_at: "2026-03-21T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-003"
  - "TASK-004"
  - "TASK-005"
spawned_tickets: []
plan_items:
  - "Req 5.2 — kanban skill versioning rules apply"
acceptance_criteria:
  - "VERSION.md contains exactly: '**Current version**: 1.2.0'"
  - "CHANGELOG.md has a single entry for 1.2.0 at the top, dated 2026-03-21, with a fun two-word name"
  - "The 1.2.0 entry covers all three changes shipping together: capture-flow free-write, pr-trunk-skip, and YYMMDD→YYYY-MM-DD rename"
  - "grep '1.2.0' skills/kanban/VERSION.md returns a match"
  - "grep '1.2.0' skills/kanban/CHANGELOG.md returns a match"
  - "grep -r 'YYMMDD' skills/kanban/ returns no matches (final verification across entire skill)"
  - "find .kanban -type d -name '260321-*' returns no results (final verification of dir renames)"
consecutive_failures: 0
---

## Context

Final ticket. After all renames and content updates are complete (TASK-003, TASK-004, TASK-005), bump the kanban skill version to 1.2.0 and add a single changelog entry covering all three changes shipping in this version: capture-flow free-write-first flow, pr-trunk-skip logic, and the YYMMDD→YYYY-MM-DD date format rename.

Coordinate with 260321-capture-flow TASK-006 and 260321-pr-trunk-skip TASK-004 — only one 1.2.0 entry should exist. This ticket owns the entry.

Also runs final grep verification across the entire skill to confirm no YYMMDD remains anywhere.

Traced to: kanban versioning rules (minor bump for new features + rename).

## Acceptance Criteria

- `VERSION.md` updated to `1.2.0`
- Single `1.2.0` changelog entry at top of `CHANGELOG.md`
- Entry covers all three subjects shipping in v1.2.0
- `grep -r 'YYMMDD' skills/kanban/` returns no matches
- `find .kanban -type d -name '260321-*'` returns no results

---
<!-- Everything below this line is append-only and chronological -->
