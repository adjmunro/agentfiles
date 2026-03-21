---
id: "260321-command-handoff/TASK-002"
subject: "260321-command-handoff"
plan: "../../01-plan/260321-command-handoff/plan-command-handoff.md"
effort: medium
status: todo
created_at: "2026-03-21T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-001"
spawned_tickets: []
plan_items:
  - "Req 1.1 — end-of-capture prompt only on clean completion"
  - "Req 1.2 — three options: Enter planning mode (Recommended), Capture something else, Something else (freeform)"
  - "Req 1.3 — (Recommended) label on first option; option ordering signals Enter-to-default"
  - "Req 1.4 — freeform input not written back to input file unless judged as capture content and user confirms"
acceptance_criteria:
  - "grep -c 'Phase 9 — Handoff' skills/kanban/commands/capture.md returns 1"
  - "grep -c 'Phase 10 — Report' skills/kanban/commands/capture.md returns 1 (old Phase 9 renumbered)"
  - "grep -c 'Recommended' skills/kanban/commands/capture.md returns >= 1"
  - "grep -c 'clean completion' skills/kanban/commands/capture.md returns >= 1 (gate condition documented)"
  - "grep -c 'Capture something else' skills/kanban/commands/capture.md returns >= 1"
  - "grep -c 'kanban-plan' skills/kanban/commands/capture.md returns >= 1 (inline invocation documented)"
  - "Phase 9 section appears after Phase 8 (git commit) and before Phase 10 (report) — verified by line order in file"
consecutive_failures: 0
---

## Context

Adds the post-capture handoff prompt to `skills/kanban/commands/capture.md`. Currently the command ends at Phase 9 (Report). The new Phase 9 (Handoff) slots in between the existing Phase 8 (Git Commit) and the existing Phase 9 (Report, renumbered to Phase 10).

Traced to plan §1 (all sub-requirements).

## Acceptance Criteria

- `skills/kanban/commands/capture.md` contains a `## Phase 9 — Handoff` (or equivalent heading) section
- The existing Report section is renumbered to `## Phase 10 — Report`
- Phase 9 is conditioned on clean completion: explicitly states it is only shown when no Critic gaps remain (Phase 6 found no unresolved items) and Phase 8 git commit completed
- Phase 9 instructs the agent to use AskUserQuestion with three options, in this order:
  1. Enter planning mode — labelled `(Recommended)`, described as invoking `kanban-plan` inline
  2. Capture something else — described as invoking a new `kanban-capture` inline, same session, no context clearing
  3. Something else — freeform; treated as a normal in-context message, no special handler
- Phase 9 notes that freeform input (option 3) is not written back to the input file unless the agent judges it as additional capture content and the user confirms
- `grep -c 'Phase 9' skills/kanban/commands/capture.md` returns `1`
- `grep -c 'Phase 10' skills/kanban/commands/capture.md` returns `1`

---
<!-- Everything below this line is append-only and chronological -->
