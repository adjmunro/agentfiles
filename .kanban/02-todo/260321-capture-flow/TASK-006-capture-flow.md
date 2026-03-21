---
id: "260321-capture-flow/TASK-006"
subject: "260321-capture-flow"
plan: "../../01-plan/260321-capture-flow/plan-capture-flow.md"
effort: low
status: todo
created_at: "2026-03-21T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-005"
spawned_tickets: []
plan_items:
  - "Req 4.2 — Scope: skills/kanban/ only"
acceptance_criteria:
  - "VERSION.md contains exactly: '**Current version**: 1.2.0'"
  - "CHANGELOG.md has a new entry at the top for 1.2.0 with today's date (2026-03-21)"
  - "The changelog entry has a fun two-word name, describes the free-write-first flow change, and includes bullets covering the key behaviour changes"
  - "grep -n '1.2.0' skills/kanban/VERSION.md returns a match"
  - "grep -n '1.2.0' skills/kanban/CHANGELOG.md returns a match"
consecutive_failures: 0
---

## Context

After all Phase 4 changes are implemented and verified, bump the kanban skill version and add a changelog entry. This is a minor version bump (1.1.0 → 1.2.0) because the change adds new behaviour to the capture interview flow.

Traced to: kanban skill versioning rules (CLAUDE.md: bump only when skills/kanban/ changes, minor for new features).

## Acceptance Criteria

- `VERSION.md` updated to `1.2.0`
- `CHANGELOG.md` has a new top entry for `1.2.0` dated `2026-03-21`
- Entry has a fun two-word name and describes the free-write-first capture flow
- Both files confirmed with `grep`

---
<!-- Everything below this line is append-only and chronological -->
