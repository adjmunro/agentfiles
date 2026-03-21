---
id: "2026-03-21-capture-flow/TASK-001"
subject: "2026-03-21-capture-flow"
plan: "../../01-plan/2026-03-21-capture-flow/plan-capture-flow.md"
effort: low
status: done
created_at: "2026-03-21T00:00:00Z"
claimed_at: "2026-03-21T00:00:00Z"
completed_at: "2026-03-21T00:00:00Z"
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

## Work Log — 2026-03-21

### Behaviour Checklist for Phase 4

This checklist enumerates every requirement the new Phase 4 must exhibit, verifiable by reading the final `capture.md`. Each item is falsifiable — can be confirmed or denied by textual inspection.

- [ ] Phase 4 opens with a single short framing line (e.g., "What are you working on?") — no multi-choice options, no structured prompts before the user writes
- [ ] The opening framing line is immediately followed by an interactive text input request (agent waits for user response before proceeding)
- [ ] No multi-choice question appears anywhere before the user's free-form input has been collected
- [ ] After user submits free-form text, the agent displays acknowledgment or processing statement before asking any clarifying questions
- [ ] Clarifying questions are derived from specific gaps or ambiguities in what the user actually wrote — not drawn from a fixed template of required topics
- [ ] Each clarifying question is preceded by a natural-prose preamble in which the agent interprets the input, states a recommendation or observation, and explains reasoning
- [ ] Preamble text is written in the agent's own voice (first person, conversational) — not using labeled section headers like "**My read:**" or "**I'd recommend:**"
- [ ] Preamble may reference insights from codebase research or web research, drawn at the agent's discretion based on the question context
- [ ] No hard limit on the number of clarifying questions — agent continues until the picture is complete
- [ ] Phase 5 (Transcribe Verbatim) remains unchanged in structure and rules
- [ ] Phase 6 (Critic Pass) remains unchanged in structure and rules
- [ ] Phase 7 (Write the File) remains unchanged in structure and rules
- [ ] Phase 8 (Git Commit) remains unchanged in structure and rules
- [ ] Phase 9 (Handoff) remains unchanged in structure and rules
- [ ] Phase 10 (Report) remains unchanged in structure and rules
- [ ] No other content in `capture.md` has been modified (Phases 1–3 unchanged, all DO/DO NOT rules unchanged, all helper instructions unchanged)

### Confirmation

`capture.md` has not been read since the checklist was written. Verification of this checklist against the final `capture.md` will occur in a subsequent ticket (TASK-002 or later) when Phase 4 is implemented.

---

## Review — 2026-03-21

**Reviewers:** Echo (Examiner) → Arden (Critic)
**Result:** PASS — 100% (4/4 criteria fully satisfied)

### Criterion Assessment

| # | Criterion | Result |
|---|-----------|--------|
| 1 | Checklist exists in append zone, written before any capture.md edits | SATISFIED |
| 2 | Each item is falsifiable by reading capture.md | SATISFIED |
| 3 | All 9 required areas covered | SATISFIED |
| 4 | capture.md is unmodified | SATISFIED |

### Notes

- All 9 required areas confirmed present: no multi-choice before free-write (items 1, 3); single framing line (item 1); free-write before questions (items 2, 3); questions from gaps not templates (item 5); natural-prose preamble (item 6); preamble voice rules (item 7); research discretion (item 8); no hard cap (item 9); phases 5–9 unchanged (items 10–16).
- `git diff` on capture.md returned no output — file is provably unmodified, corroborating the self-attestation in the Confirmation section.
- Checklist coverage exceeds the minimum: 16 items cover Phases 1–3 and Phase 10 in addition to the 9 required areas.
- Arden (Critic) found no weaknesses to report.
