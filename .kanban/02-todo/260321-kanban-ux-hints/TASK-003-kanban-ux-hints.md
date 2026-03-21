---
id: "260321-kanban-ux-hints/TASK-003"
subject: "260321-kanban-ux-hints"
plan: "../../01-plan/260321-kanban-ux-hints/plan-kanban-ux-hints.md"
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
  - "Req 2.1 — Audit all 9 command files against their current argument-hint values"
  - "Req 2.2 — Revise any hint that is vague, inaccurate, or doesn't match what the command accepts"
acceptance_criteria:
  - "All 9 command files have been read and compared against their actual argument behaviour"
  - "Any hint that was inaccurate or misleading has been updated with a more accurate value"
  - "Running `verify-kanban-ux-hints.sh` exits 0 (all checks pass — green)"
  - "`grep -rn 'argument-hint' .claude/skills/kanban/commands/` returns exactly 9 non-empty matches"
consecutive_failures: 0
---

## Context

All 9 command files already have `argument-hint` values — so this is a review and quality pass, not a gap-fill. The Scout identified `init.md` as a minor candidate for review (its hint says "subject name override" but init's primary purpose is creating the `.kanban/` folder structure, which might confuse users who expect the hint to describe what init does, not just its optional argument).

Once hints are reviewed and any updates committed, run the verification script from TASK-001 to confirm the full suite passes.

## Acceptance Criteria

- Each of the 9 command files has been opened and its `argument-hint` compared against its actual behaviour
- Files with accurate hints: no change made, but explicitly noted as reviewed
- Files with inaccurate or improvable hints: updated
- `verify-kanban-ux-hints.sh` exits 0 after all updates

---
<!-- Everything below this line is append-only and chronological -->
