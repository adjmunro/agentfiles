---
id: "260321-capture-flow/TASK-004"
subject: "260321-capture-flow"
plan: "../../01-plan/260321-capture-flow/plan-capture-flow.md"
effort: medium
status: in-review
created_at: "2026-03-21T00:00:00Z"
claimed_at: "2026-03-21T09:00:00Z"
completed_at: "2026-03-21T09:30:00Z"
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
consecutive_failures: 1
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

## Work Log — 2026-03-21

Added natural-prose preamble instruction to Phase 4 of `skills/kanban/commands/capture.md`.

The new paragraph appears between the gap-identification instruction and the guidance list. It requires the agent to write a short preamble before each clarifying question covering: (1) its interpretation of the user's input, (2) its recommendation or inclination on that point, and (3) its reasoning for why the question is needed. The instruction specifies flowing prose in the agent's own voice — first person, conversational — and explicitly prohibits labeled-section patterns ("My read:", "I'd recommend:", "Reasoning:"). The agent may draw on codebase reads, web research, or session context at its own discretion.

Phases 5–9 and all other content in capture.md are unchanged. No version bump or CHANGELOG update per ticket instructions.

## Review — 2026-03-21 (Echo / Arden)

**Reviewers:** Echo (Examiner), Arden (Critic)
**Outcome:** FAIL — 90% (threshold 95%)

| # | Criterion | Result |
|---|-----------|--------|
| 1 | Phase 4 instructs agent to output a natural-prose preamble before each clarifying question | PASS |
| 2 | Preamble instruction specifies interpretation, recommendation, and reasoning | PASS |
| 3 | Preamble must be natural prose in agent's own voice — no labeled sections | PASS |
| 4 | Agent may draw on codebase, web research, or session context at discretion | PASS |
| 5 | grep returns no matches for `labeled\|My read\|I.d recommend` | PARTIAL |

**AC5 detail:** The grep test matches line 109 because the prohibited patterns ("My read:", "I'd recommend:", "labeled sections") are quoted inline as negative examples within the prohibition sentence itself. The semantic intent — no instruction to use labeled sections — is satisfied. The literal grep test is not. Scored as partial (0.5).

**Score:** (4 + 0.5) / 5 × 100 = 90%

**Required fix:** Either (a) remove the quoted examples from the prohibition sentence so the grep produces no matches, or (b) revise the acceptance criterion to reflect that the grep will match quoted negative examples. The implementation intent is correct; the criterion and implementation are in tension.

## Work Log — 2026-03-21 (Fix Applied)

Fixed the grep false-positive by removing inline quoted examples from the Phase 4 prohibition sentence in `skills/kanban/commands/capture.md`. Changed "not as labeled sections or structured headers. Patterns like 'My read:', 'I'd recommend:', or 'Reasoning:' are prohibited." to "not as structured sections or formatted headers." The prohibition remains clear — no labeled sections, no structured formats — but the quoted examples that triggered the grep match have been removed. The semantic intent is unchanged; the grep verification now passes: `grep -n 'labeled\|My read\|I.d recommend' skills/kanban/commands/capture.md` returns no matches.
