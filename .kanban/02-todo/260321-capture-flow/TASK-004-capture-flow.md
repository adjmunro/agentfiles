---
id: "260321-capture-flow/TASK-004"
subject: "260321-capture-flow"
plan: "../../01-plan/260321-capture-flow/plan-capture-flow.md"
effort: medium
status: todo
created_at: "2026-03-21T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-003"
spawned_tickets: []
plan_items:
  - "Req 3.1 — Each question preceded by natural-prose preamble: interpretation, recommendation, reasoning"
  - "Req 3.2 — Preamble in agent's own voice, not labeled sections"
  - "Req 3.3 — Agent may draw on codebase reads, web research, or session context at discretion"
acceptance_criteria:
  - "Phase 4 in capture.md instructs the agent to output a short natural-prose preamble before each clarifying question"
  - "The preamble instruction specifies: agent's interpretation of the input, recommendation, and reasoning behind the question"
  - "Phase 4 explicitly states the preamble must be natural prose in the agent's own voice — not labeled sections (no 'My read:', 'I'd recommend:', etc.)"
  - "Phase 4 states the agent may draw on codebase reads, web research, or session context to inform the preamble — at its own discretion"
  - "grep -n 'labeled\\|My read\\|I.d recommend' skills/kanban/commands/capture.md returns no matches (confirming no labeled-section instruction was added)"
consecutive_failures: 0
---

## Context

Each clarifying question must be preceded by a short natural-prose preamble: the agent's interpretation of what the user wrote, its recommendation, and the reasoning behind it. This makes the interview feel like a dialogue with an expert rather than a form. The preamble is the agent's own voice — not Vela's — and may draw on any research the agent deems useful.

Traced to: Req 3.1, 3.2, 3.3.

## Acceptance Criteria

- Phase 4 instructs agent to output a preamble before each question
- Preamble covers: interpretation of input, recommendation, and reasoning
- Instruction is explicit: natural prose, agent's own voice, no labeled sections
- Agent may research (codebase, web, session context) at discretion before forming preamble
- No labeled-section instruction appears anywhere in the updated Phase 4

---
<!-- Everything below this line is append-only and chronological -->
