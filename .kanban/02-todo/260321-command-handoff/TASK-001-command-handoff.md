---
id: "260321-command-handoff/TASK-001"
subject: "260321-command-handoff"
plan: "../../01-plan/260321-command-handoff/plan-command-handoff.md"
effort: low
status: todo
created_at: "2026-03-21T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on: []
spawned_tickets: []
plan_items:
  - "Req 1.1 — end-of-capture prompt gated on clean completion"
  - "Req 1.2 — three capture handoff options"
  - "Req 1.3 — (Recommended) label and ordering"
  - "Req 1.4 — freeform not written back to file"
  - "Req 2.1 — end-of-plan prompt gated on clean completion (PASS)"
  - "Req 2.2 — five plan handoff options"
  - "Req 2.3 — Start is (Recommended)"
  - "Req 2.4 — options 1–3 invoke kanban-todo"
  - "Req 3.1–3.4 — session boundary relaxation"
  - "Req 4.1–4.4 — discard guard"
acceptance_criteria:
  - "grep -c 'Phase 9' skills/kanban/commands/capture.md returns 0 (no Phase 9 section exists yet)"
  - "grep -c 'Phase 10' skills/kanban/commands/plan.md returns 0 (no Phase 10 handoff section exists yet)"
  - "grep -c 'from-plan-handoff' skills/kanban/commands/todo.md returns 0 (whitelist not yet present)"
  - "grep -c 'Discard' skills/kanban/commands/plan.md returns 0 (discard logic not yet present)"
  - "A review checklist file exists at .kanban/01-plan/260321-command-handoff/review-command-handoff.md listing all verifiable ACs for TASK-002 through TASK-005"
consecutive_failures: 0
---

## Context

TDD red phase for 260321-command-handoff. No implementation exists yet. This ticket establishes the baseline (all checks fail) and writes a review checklist that TASK-002 through TASK-005 implementations will be verified against.

The project is a markdown agent-instruction system with no test runner. "Red" means: confirm that none of the planned changes exist yet, and produce a review checklist (grep-verifiable conditions) that will be used during `/kanban-review` to confirm each ticket passed.

## Acceptance Criteria

- `grep -c 'Phase 9' skills/kanban/commands/capture.md` returns `0` (no Phase 9 handoff section exists yet — current Phase 9 is the Report)
- `grep -c 'Phase 10' skills/kanban/commands/plan.md` returns `0` (no Phase 10 handoff exists yet)
- `grep -c 'from-plan-handoff' skills/kanban/commands/todo.md` returns `0` (whitelist not yet added)
- `grep -c 'Discard' skills/kanban/commands/plan.md` returns `0` (discard option not yet present)
- File `.kanban/01-plan/260321-command-handoff/review-command-handoff.md` exists and contains one grep-verifiable AC per planned change (minimum 8 items covering capture handoff, plan handoff, todo whitelist, and discard guard)

---
<!-- Everything below this line is append-only and chronological -->
