---
id: "260321-pr-trunk-skip/TASK-004"
subject: "260321-pr-trunk-skip"
plan: "../../01-plan/260321-pr-trunk-skip/plan-pr-trunk-skip.md"
effort: low
status: in-progress
created_at: "2026-03-21T00:00:00Z"
claimed_at: "2026-03-21T22:00:00Z"
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-003"
spawned_tickets: []
plan_items:
  - "Req 4.1 — skills/kanban/ scoped change warrants version bump"
acceptance_criteria:
  - "VERSION.md contains exactly: '**Current version**: 1.2.0'"
  - "CHANGELOG.md has a new entry at the top for 1.2.0 dated 2026-03-21"
  - "The changelog entry has a fun two-word name and describes both the capture-flow and pr-trunk-skip changes (these ship in the same version bump)"
  - "grep '1.2.0' skills/kanban/VERSION.md returns a match"
  - "grep '1.2.0' skills/kanban/CHANGELOG.md returns a match"
consecutive_failures: 0
---

## Context

Both `260321-capture-flow` and `260321-pr-trunk-skip` are scoped to `skills/kanban/` and both warrant a minor version bump (new behaviour). They ship together as v1.2.0. This ticket handles the bump and changelog entry for the pr-trunk-skip work; coordinate with the capture-flow TASK-006 to ensure only one 1.2.0 entry exists.

Traced to: kanban skill versioning rules (minor bump for new feature).

## Acceptance Criteria

- `VERSION.md` updated to `1.2.0`
- `CHANGELOG.md` has a single top entry for `1.2.0` dated `2026-03-21`
- Entry covers both changes shipping in this version
- Both files confirmed with `grep`

---
<!-- Everything below this line is append-only and chronological -->
