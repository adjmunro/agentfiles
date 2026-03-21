---
id: "260321-capture-flow/TASK-001"
subject: "260321-capture-flow"
plan: "../../01-plan/260321-capture-flow/plan-capture-flow.md"
effort: low
status: todo
created_at: "2026-03-21T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
spawned_tickets: []
plan_items:
  - "Req 1.1 — Phase 4 opens with single short framing line"
  - "Req 1.2 — Agent waits for free-form text before questioning"
  - "Req 1.3 — Opening multi-choice question removed entirely"
  - "Req 2.1 — Agent reads and processes free-write before forming questions"
  - "Req 2.2 — Questions derived from gaps in user input"
  - "Req 3.1 — Each question preceded by natural-prose preamble"
  - "Req 3.2 — Preamble in agent's own voice, not labeled sections"
  - "Req 3.3 — Agent may draw on codebase/web research at discretion"
  - "Req 4.1 — No hard cap on questions"
  - "Req 4.2 — Scope: capture.md Phase 4 only"
  - "Req 4.3 — All other phases unchanged"
acceptance_criteria:
  - "A checklist exists enumerating every behaviour the new Phase 4 must exhibit, written before any edits to capture.md"
  - "Each checklist item is falsifiable: it can be confirmed or denied by reading the final capture.md"
  - "The checklist covers: (1) no multi-choice before free-write, (2) single framing line, (3) free-write collected before questions, (4) questions derived from gaps not templates, (5) natural-prose preamble per question, (6) preamble voice rules, (7) research discretion, (8) no hard cap, (9) phases 5–9 unchanged"
  - "capture.md is unmodified at the end of this ticket"
consecutive_failures: 0
---

## Context

Before touching `capture.md`, document exactly what the new Phase 4 must do — in enough detail that any edit can be verified against it. This is the red phase: define the target state first, then implement against it.

Traced to: all plan requirements (1.1–4.3).

## Acceptance Criteria

- A checklist of all new Phase 4 behaviours is written (in this ticket or a companion file) before any edits to `capture.md`
- Each item is falsifiable by reading the final `capture.md`
- Covers: no multi-choice before free-write; single framing line; free-write collected first; questions from gaps not templates; natural-prose preamble per question; preamble voice (own voice, not labeled); research at discretion; no hard cap; phases 5–9 untouched
- `capture.md` is unmodified at the end of this ticket

---
<!-- Everything below this line is append-only and chronological -->
