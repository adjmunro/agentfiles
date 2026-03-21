---
id: "2026-03-21-capture-flow/TASK-002"
subject: "2026-03-21-capture-flow"
plan: "../../01-plan/2026-03-21-capture-flow/plan-capture-flow.md"
effort: medium
status: done
created_at: "2026-03-21T00:00:00Z"
claimed_at: "2026-03-21T10:00:00Z"
completed_at: "2026-03-21T10:30:00Z"
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

## Work Log — 2026-03-21

**Builder:** Kira (Builder)

### Change Made

Edited `skills/kanban/commands/capture.md`, Phase 4 only.

**Removed:** The opening `AskUserQuestion` call that instructed the agent to use an interactive multi-choice question tool before the user had written anything. Specifically, this paragraph was deleted:

> Ask clarifying questions using your environment's interactive question tool if available (e.g., `AskUserQuestion` in Claude Code). If no interactive tool is available, ask questions one at a time inline and wait for the user's response before proceeding.

**Replaced with:**

> Ask the user: **What are you working on?**
>
> Wait for the user to write before doing anything else. Collect their free-form response in full before proceeding to any clarifying questions.

The rest of Phase 4 — the sequential-questioning rule, the topic list, and the completeness definition — is completely unchanged.

### Why

The old opening forced the interaction into a structured form before the user had said a word. Multi-choice questions assume the agent already knows what dimensions are important, which it doesn't until it hears from the user. Front-loading structure produces poorly targeted follow-up questions and makes capture feel like filling in a form rather than having a conversation.

The fix is the simplest possible inversion: ask one open question, wait, then proceed from what the user actually wrote. The clarifying questions still exist — they just run after, informed by real input rather than anticipating it.

### Verification

`grep -n 'AskUserQuestion\|multi.choice\|multiSelect' skills/kanban/commands/capture.md` returned two hits: line 3 (frontmatter `allowed-tools` list) and line 193 (Phase 9 handoff). Neither is in Phase 4 before the free-write step. Clean.

Phases 5–9 were inspected and are unchanged — confirmed by `git diff`.

Kanban skill bumped to 1.1.4. CHANGELOG.md updated.

---

## Review — 2026-03-21

**Examiner:** Echo (Examiner)
**Critic:** Arden (Critic)
**Outcome:** PASS
**Score:** 5/5 — 100%

### Evidence

| # | Criterion | Result |
|---|-----------|--------|
| 1 | Phase 4 opens with single short framing line, no multi-choice before free-write | PASS — line 103: "Ask the user: **What are you working on?**" |
| 2 | Opening AskUserQuestion multi-choice block removed from Phase 4 | PASS — commit 40ab82e confirms deletion; no AskUserQuestion in Phase 4 |
| 3 | Phase 4 instructs agent to collect free-form text before proceeding | PASS — line 105 explicit: "Wait for the user to write before doing anything else…" |
| 4 | grep shows no multi-choice call in Phase 4 before free-write step | PASS — only hits at line 3 (frontmatter) and line 193 (Phase 9); Phase 4 is lines 99–121 |
| 5 | Phases 5–9 unchanged | PASS — git diff HEAD clean; commit diff shows only 3 lines changed inside Phase 4 hunk |

### Critic Notes

`AskUserQuestion` remains in `allowed-tools` frontmatter and in Phase 9 — both are correct and intentional. Neither is a violation. No partial credits required. Work is clean and scoped exactly to the stated change.
