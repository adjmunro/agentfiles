---
id: "260321-date-format/TASK-001"
subject: "260321-date-format"
plan: "../../01-plan/260321-date-format/plan-date-format.md"
effort: low
status: in-progress
created_at: "2026-03-21T00:00:00Z"
claimed_at: "2026-03-21T22:30:00Z"
completed_at: ~
stale_after_hours: 4
spawned_tickets: []
plan_items:
  - "Req 1.1 — Rename all .kanban/ YYMMDD- dirs to YYYY-MM-DD-"
  - "Req 1.2 — Include date-format subject itself"
  - "Req 2.1 — Update id: frontmatter"
  - "Req 2.2 — Update subject: frontmatter"
  - "Req 2.3 — Update plan: relative paths"
  - "Req 3.1 — Update # YYMMDD-<subject> titles"
  - "Req 3.2 — Update ## Research: YYMMDD-<subject> headers"
  - "Req 3.3 — Update all other internal cross-references"
  - "Req 4.1 — Replace YYMMDD in all 9 command files"
  - "Req 4.2 — Replace date +%y%m%d with date +%Y-%m-%d"
  - "Req 4.3 — Update example slugs in command files"
  - "Req 5.1 — Update SKILL.md directory diagram"
  - "Req 5.2 — Update any other YYMMDD in docs"
  - "Req 6.1 — Update commit message templates in command files"
acceptance_criteria:
  - "A checklist exists enumerating every file and field that must change, written before any edits are made"
  - "Checklist covers: 11 directories to rename (with before/after names), 9 command files, SKILL.md, all ticket/plan/research files with YYMMDD content"
  - "Each checklist item is falsifiable: can be confirmed by reading the final file or running grep"
  - "No files are modified at the end of this ticket — grep -r 'YYMMDD' . returns the same count as the pre-change baseline"
consecutive_failures: 0
---

## Context

Before touching any file, document exactly what must change and where. This is the red phase: establish a complete, falsifiable inventory of every rename target so the implementation tickets can verify against it.

Traced to: all plan requirements (1.1–6.1).

## Acceptance Criteria

- Checklist of all targets written before any edits
- Covers: 11 dirs, 9 command files, SKILL.md, all .kanban/ content files
- Every item falsifiable by grep or file read
- No files modified at end of this ticket

---
<!-- Everything below this line is append-only and chronological -->
