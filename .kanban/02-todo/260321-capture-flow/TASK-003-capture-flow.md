---
id: "260321-capture-flow/TASK-003"
subject: "260321-capture-flow"
plan: "../../01-plan/260321-capture-flow/plan-capture-flow.md"
effort: medium
status: todo
created_at: "2026-03-21T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-002"
spawned_tickets: []
plan_items:
  - "Req 2.1 — Agent reads and processes free-write before forming questions"
  - "Req 2.2 — Questions derived from gaps in user input, not fixed template"
  - "Req 4.1 — No hard cap on questions — run until complete"
acceptance_criteria:
  - "Phase 4 in capture.md instructs the agent to read and process the free-form input before formulating any question"
  - "Phase 4 instructs that questions must be derived from gaps and ambiguities in what the user wrote — not pulled from a fixed list"
  - "Phase 4 retains the instruction to continue asking until the picture is complete (no hard cap)"
  - "Phase 4 retains the instruction to ask one question at a time sequentially"
  - "The existing question topic areas (impl choices, tradeoffs, edge cases, constraints, acceptance signals, prior art) are still listed as guidance — not as a mandatory template"
consecutive_failures: 0
---

## Context

After the user submits free-form input, the agent must read it and derive questions from the gaps — not apply a fixed question template. This ticket wires in the read-then-ask logic: agent processes what the user wrote, identifies non-obvious territory, and asks sequentially until the picture is complete.

Traced to: Req 2.1, 2.2, 4.1.

## Acceptance Criteria

- Phase 4 instructs agent to read and process free-write before forming questions
- Questions are derived from gaps in the user's input — not a fixed template
- Existing question topic areas remain as guidance, not as a mandatory sequence
- One question at a time, sequentially
- No hard cap — run until picture is complete

---
<!-- Everything below this line is append-only and chronological -->
