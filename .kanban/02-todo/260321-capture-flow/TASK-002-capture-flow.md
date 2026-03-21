---
id: "260321-capture-flow/TASK-002"
subject: "260321-capture-flow"
plan: "../../01-plan/260321-capture-flow/plan-capture-flow.md"
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
  - "Req 1.1 — Phase 4 opens with single short framing line"
  - "Req 1.2 — Agent waits for free-form text before questioning"
  - "Req 1.3 — Opening multi-choice question removed entirely"
acceptance_criteria:
  - "Phase 4 in capture.md opens with a single short framing line (e.g. 'What are you working on?') — no multi-choice question appears before the user has written anything"
  - "The current opening AskUserQuestion multi-choice block is removed from Phase 4"
  - "Phase 4 instructs the agent to collect free-form text from the user before proceeding"
  - "grep -n 'AskUserQuestion' skills/kanban/commands/capture.md shows no multi-choice call in Phase 4 before the free-write step"
  - "Phases 5–9 are unchanged (diff shows no edits outside Phase 4)"
consecutive_failures: 0
---

## Context

The current Phase 4 opens immediately with a structured `AskUserQuestion` multi-choice call. This ticket removes that opening question and replaces it with: a single short framing line followed by a free-form text input step. The agent waits for the user to write before asking anything.

Traced to: Req 1.1, 1.2, 1.3.

## Acceptance Criteria

- Phase 4 opens with a single short framing line — no multi-choice before free-write
- The current opening multi-choice question block is removed
- Phase 4 instructs agent to collect free-form input before proceeding to questions
- `grep` confirms no multi-choice call appears in Phase 4 before the free-write step
- Phases 5–9 are untouched

---
<!-- Everything below this line is append-only and chronological -->
