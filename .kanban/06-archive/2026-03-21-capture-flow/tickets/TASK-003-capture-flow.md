---
id: "2026-03-21-capture-flow/TASK-003"
subject: "2026-03-21-capture-flow"
plan: "../../01-plan/2026-03-21-capture-flow/plan-capture-flow.md"
effort: medium
status: done
created_at: "2026-03-21T00:00:00Z"
claimed_at: "2026-03-21T00:01:00Z"
completed_at: "2026-03-21T00:02:00Z"
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

## Work Log — 2026-03-21

**Changed:** `skills/kanban/commands/capture.md`, Phase 4 only.

Three targeted edits were made between the free-write collection paragraph and the topic-area list:

1. **Read-and-process instruction added.** After the existing "Collect their free-form response in full" sentence, a new paragraph was inserted: the agent is now explicitly told to read and process what the user wrote before forming any questions, and to identify gaps, ambiguities, and non-obvious territory in the specific input. This satisfies Req 2.1.

2. **Gap-derived questions, not templates.** The same paragraph states that questions must be derived from what is missing or unclear in the user's actual input — not drawn from a fixed template of required topics. This satisfies Req 2.2.

3. **Topic areas reframed as guidance.** The bullet list (impl choices, tradeoffs, edge cases, constraints, acceptance signals, prior art) was relabelled: the lead sentence now reads "The following areas are **guidance** for what kinds of gaps are worth surfacing — not a mandatory sequence to work through." This preserves the list while making the advisory-not-prescriptive intent explicit.

Rules preserved unchanged: one question at a time (sequential), no hard cap (run until picture is complete), Phases 5–9 untouched.

---

## Review — 2026-03-21

**Reviewers:** Echo (Examiner), Arden (Critic)
**Result:** PASS — 100% (5/5 satisfied, threshold 95%)

| # | Criterion | Verdict |
|---|-----------|---------|
| 1 | Phase 4 instructs agent to read and process free-write before forming questions | SATISFIED |
| 2 | Questions derived from gaps in user input, not a fixed template | SATISFIED |
| 3 | No hard cap — run until picture is complete | SATISFIED |
| 4 | One question at a time, sequentially | SATISFIED |
| 5 | Topic areas listed as guidance, not mandatory sequence | SATISFIED |

All criteria map to explicit text in Phase 4. Arden (Critic) found no grounds to contest any criterion. Ticket promoted to `05-pull-request`.
