---
id: "260321-pr-trunk-skip/TASK-003"
subject: "260321-pr-trunk-skip"
plan: "../../01-plan/260321-pr-trunk-skip/plan-pr-trunk-skip.md"
effort: low
status: todo
created_at: "2026-03-21T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-002"
spawned_tickets: []
plan_items:
  - "Req 4.1 — SKILL.md documents both PR bypass conditions"
acceptance_criteria:
  - "SKILL.md contains a note documenting two PR bypass conditions: non-GitHub repos and trunk branches (main/master/develop/trunk) without branch protection"
  - "The trunk-branch bypass note mentions the gh protection check and best-effort caveat"
  - "The existing non-GitHub skip note is preserved verbatim or improved — not removed"
  - "grep 'trunk' skills/kanban/SKILL.md returns a match in the bypass note"
  - "The state machine diagram or surrounding prose makes both bypass paths clear to a first-time reader"
consecutive_failures: 0
---

## Context

`SKILL.md` currently only documents the non-GitHub PR bypass. This ticket adds a second bypass condition — trunk branches without remote branch protection — so the state machine documentation reflects reality after TASK-002 lands.

Traced to: Req 4.1.

## Acceptance Criteria

- SKILL.md documents both bypass conditions
- Trunk-bypass note includes: branch names, gh protection check, best-effort caveat
- Existing non-GitHub note preserved
- First-time reader can understand both paths from the docs alone

---
<!-- Everything below this line is append-only and chronological -->
