---
id: "260321-command-handoff/TASK-006"
subject: "260321-command-handoff"
plan: "../../01-plan/260321-command-handoff/plan-command-handoff.md"
effort: low
status: todo
created_at: "2026-03-21T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-002"
  - "TASK-003"
  - "TASK-004"
  - "TASK-005"
spawned_tickets: []
plan_items:
  - "Implied by kanban skill CLAUDE.md: version bump required for any kanban skill change"
acceptance_criteria:
  - "grep -c '1.2.0' skills/kanban/VERSION.md returns 1"
  - "grep -c '1.2.0' skills/kanban/CHANGELOG.md returns 1"
  - "The CHANGELOG entry for 1.2.0 appears at the top of the file (newest-on-top convention) and describes the handoff prompt feature"
consecutive_failures: 0
---

## Context

Final housekeeping ticket: bump the kanban skill version from 1.1.1 to 1.2.0 and add a CHANGELOG entry. Per the kanban skill CLAUDE.md:
- Version bump is required whenever changes are scoped to `skills/kanban/`
- This is a minor version bump (new feature: handoff prompts)
- CHANGELOG entry goes at the top of the file, newest-on-top
- Entry format: `## 1.2.0 — The [Fun Two-Word Name] (2026-03-21)`

Run after TASK-002, TASK-003, TASK-004, and TASK-005 are all complete.

## Acceptance Criteria

- `grep -c '1.2.0' skills/kanban/VERSION.md` returns `1`
- `grep -c '1.2.0' skills/kanban/CHANGELOG.md` returns `1`
- The 1.2.0 CHANGELOG entry is the first entry in the file (appears before any existing entries)
- The entry has a fun two-word name, a date of 2026-03-21, a 1–2 sentence summary, and bullet points describing the handoff prompt feature

---
<!-- Everything below this line is append-only and chronological -->
