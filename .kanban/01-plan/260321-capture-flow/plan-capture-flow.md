## Intent

The current capture command opens Phase 4 with a multi-choice question before the user has written anything. This forces the user into a structured response before establishing context, making questions poorly targeted and the interaction feel like a form rather than a conversation. The goal is to invert the flow: collect free-form input first, then ask pointed clarifying questions informed by what the user actually wrote. Each question should be preceded by the agent's interpretation, recommendation, and reasoning — in natural prose, drawn from context or research at its discretion.

## Requirements

### 1. Free-write first

1.1 Phase 4 opens with a single short framing line (e.g. "What are you working on?") — no structured prompts, no multi-choice questions, before the user has written anything.

1.2 The agent waits for free-form text input from the user before proceeding to any structured questioning.

1.3 The current opening multi-choice question is removed entirely from Phase 4.

### 2. Read-then-ask flow

2.1 After the user submits free-form input, the agent reads and processes it before forming any questions.

2.2 Questions are derived from gaps and ambiguities in what the user wrote — not from a fixed template.

### 3. Question preamble

3.1 Each clarifying question is preceded by a short natural-prose preamble: the agent's interpretation of the input, its recommendation, and the reasoning behind it.

3.2 The preamble is written in the agent's own voice — not as labeled sections (no "My read:" / "I'd recommend:" headers).

3.3 The agent may draw on codebase reads, web research, or session context to inform the preamble — at its own discretion based on what the question warrants.

### 4. Unchanged behaviours

4.1 Question count: run until the picture is complete — no hard cap.

4.2 Scope: changes apply to `capture.md` Phase 4 only. `plan.md` Phase 3 is unaffected.

4.3 All other phases in `capture.md` (1–3, 5–9) remain unchanged.

## Constraints

- Change is scoped to `skills/kanban/commands/capture.md`, Phase 4 only.
- Preamble format is natural prose in the agent's own voice — not labeled sections.
- Research for preamble: agent decides (may include codebase reads or web research).
- Framing before free-write: a single short orienting line, not a form or structured prompt.

## Out of Scope

- Changes to `plan.md` Phase 3 interview behaviour.
- Changes to any other kanban command file.
- Changes to persona files.
- Adding or removing question topic areas (implementation choices, tradeoffs, edge cases, constraints, acceptance signals — these remain as-is).

## Audit: input → plan — PASS
**Date**: 2026-03-21T00:00:00Z  **Threshold**: 95%

| # | Item | Status | Notes |
|---|------|--------|-------|
| 1 | Multi-choice before free-write is the problem | Full | §1.3 |
| 2 | Free-write first | Full | §1.1, §1.2 |
| 3 | Interview based on free-write | Full | §2.1, §2.2 |
| 4 | Multi-choice clarifies non-obvious things | Full | §2.2 |
| 5 | Similar to /interview: read-first, ask-second | Full | §2.1 |
| 6 | Summary of thoughts, recommendation, why | Full | §3.1 |
| 7 | Preamble from agent's own analysis | Full | §3.3 |
| 8 | Minimal framing (short line) | Full | §1.1, Constraints |
| 9 | No hard cap on questions | Full | §4.1 |
| 10 | Each question preceded by interpretation + recommendation + reasoning | Full | §3.1 |
| 11 | Natural prose, not labeled sections | Full | §3.2, Constraints |
| 12 | Capture only, not plan.md | Full | §4.2, Out of Scope |
| 13 | Agent decides research, may include web | Full | §3.3, Constraints |
| 14 | Phase 4 is the change location | Full | Constraints |

- Full: 14, Partial: 0, Missing: 0 — Total: 14
- Score: (14 + 0.5×0) / 14 × 100 = **100%**

### Fixes Applied
- None.

## Audit: plan → todo — PASS
**Date**: 2026-03-21T00:00:00Z  **Threshold**: 95%

| # | Requirement | Ticket(s) | Status | Notes |
|---|------------|-----------|--------|-------|
| 1 | 1.1 Single framing line | TASK-001, TASK-002 | Full | |
| 2 | 1.2 Wait for free-form text | TASK-001, TASK-002 | Full | |
| 3 | 1.3 Remove opening multi-choice | TASK-001, TASK-002 | Full | |
| 4 | 2.1 Read/process before questioning | TASK-001, TASK-003 | Full | |
| 5 | 2.2 Questions from gaps, not template | TASK-001, TASK-003 | Full | |
| 6 | 3.1 Natural-prose preamble per question | TASK-001, TASK-004 | Full | |
| 7 | 3.2 Agent's own voice, no labeled sections | TASK-001, TASK-004 | Full | |
| 8 | 3.3 Research at agent's discretion | TASK-001, TASK-004 | Full | |
| 9 | 4.1 No hard cap | TASK-001, TASK-003 | Full | |
| 10 | 4.2 Capture only, plan.md untouched | TASK-005, TASK-006 | Full | |
| 11 | 4.3 Phases 5–9 unchanged | TASK-005 | Full | |

- Full: 11, Partial: 0, Missing: 0 — Total: 11
- Score: (11 + 0.5×0) / 11 × 100 = **100%**

### Fixes Applied
- None.
