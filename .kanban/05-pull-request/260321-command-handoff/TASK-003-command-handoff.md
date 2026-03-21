---
id: "260321-command-handoff/TASK-003"
subject: "260321-command-handoff"
plan: "../../01-plan/260321-command-handoff/plan-command-handoff.md"
effort: medium
status: done
created_at: "2026-03-21T00:00:00Z"
claimed_at: "2026-03-21T00:00:00Z"
completed_at: "2026-03-21T00:00:00Z"
stale_after_hours: 4
depends_on:
  - "TASK-001"
spawned_tickets: []
plan_items:
  - "Req 2.1 — end-of-plan prompt only on clean completion (audit PASS)"
  - "Req 2.2 — options: Start (Recommended), New, Quit, Something else, Discard"
  - "Req 2.3 — Start carries (Recommended) label and is listed first"
  - "Req 2.4 — options 1–3 invoke kanban-todo as first action"
  - "Req 3.1 — plan→todo is the one sanctioned boundary crossing"
  - "Req 3.2 — explicit confirmation prompt before crossing boundary"
acceptance_criteria:
  - "grep -c 'Phase 10 — Handoff' skills/kanban/commands/plan.md returns 1"
  - "grep -c 'Phase 11 — Report' skills/kanban/commands/plan.md returns 1 (old Phase 10 renumbered)"
  - "grep -c 'Recommended' skills/kanban/commands/plan.md returns >= 1"
  - "grep -c 'kanban-todo' skills/kanban/commands/plan.md returns >= 1 (inline invocation documented)"
  - "grep -c 'session boundary' skills/kanban/commands/plan.md returns >= 1 (boundary crossing documented)"
  - "grep -c 'confirmation' skills/kanban/commands/plan.md returns >= 1 (confirmation prompt documented)"
  - "grep -c 'audit.*PASS\\|PASS.*audit' skills/kanban/commands/plan.md returns >= 1 (PASS gate documented)"
  - "Phase 10 section appears after Phase 9 (git commit) and before Phase 11 (report) — verified by line order in file"
consecutive_failures: 0
---

## Context

Adds the post-plan handoff prompt to `skills/kanban/commands/plan.md`. Currently the command ends at Phase 10 (Report). The new Phase 10 (Handoff) slots in between the existing Phase 9 (Git Commit, audit) and the existing Phase 10 (Report, renumbered to Phase 11).

Note: AskUserQuestion enforces a maximum of 4 options. The plan lists 5 (Start, New, Quit, Something else, Discard). Implementor should fold "New" (todo + new capture) into the "Something else" freeform option or drop it, keeping the prompt within the 4-option limit. Discard guard implementation is covered separately in TASK-004; this ticket adds the option to the prompt and stubs its behaviour.

Traced to plan §2 and §3.

## Acceptance Criteria

- `skills/kanban/commands/plan.md` contains a `## Phase 10 — Handoff` (or equivalent heading) section
- The existing Report section is renumbered to `## Phase 11 — Report`
- Phase 10 is conditioned on clean completion: only shown when audit result is PASS (reaching Phase 9 git commit implies PASS per the Phase 8 STOP guard)
- Phase 10 instructs the agent to use AskUserQuestion with up to 4 options; Start is listed first with `(Recommended)` label:
  1. Start — invoke `kanban-todo` then `kanban-next`
  2. Quit — invoke `kanban-todo` then exit
  3. Something else — freeform (covers New and any other free input)
  4. Discard — remove subject files (behaviour described; full guard in TASK-004)
- Before invoking `kanban-todo` (options 1–2), Phase 10 instructs the agent to present an explicit session-boundary confirmation prompt; if declined, return to the handoff options
- `grep -c 'Phase 10' skills/kanban/commands/plan.md` returns `1`
- `grep -c 'Phase 11' skills/kanban/commands/plan.md` returns `1`

---
<!-- Everything below this line is append-only and chronological -->

## Work Log — 2026-03-21T00:00:00Z

- Read ticket and plan; confirmed scope: insert Phase 10 Handoff between Phase 9 and Phase 10 (Report), renumber Report to Phase 11
- Moved ticket from `02-todo` to `03-in-progress`; updated frontmatter (status: in_progress, claimed_at)
- Edited `skills/kanban/commands/plan.md`:
  - Inserted `## Phase 10 — Handoff` with 4-option AskUserQuestion prompt (Start/Recommended, Quit, Something else, Discard)
  - Added session-boundary confirmation gate before kanban-todo invocations (options 1–2)
  - Documented `from-plan-handoff` argument passthrough
  - Stubbed Discard guard with TASK-004 placeholder
  - Renumbered existing `## Phase 10 — Report` to `## Phase 11 — Report`
- Verified all acceptance criteria via Grep:
  - Phase 10 — Handoff: 1 match
  - Phase 11 — Report: 1 match
  - Recommended: 2 matches
  - kanban-todo: 8 matches
  - session boundary: 2 matches
  - confirmation: 1 match
  - audit PASS: 2 matches

## Review — 2026-03-21T00:00Z — PASS 100.0%

| AC | Evidence | Status |
|----|----------|--------|
| Phase 10 — Handoff heading exists (count = 1) | `grep -c 'Phase 10 — Handoff'` → 1; plan.md:204 | Satisfied |
| Phase 11 — Report heading exists, renumbered (count = 1) | `grep -c 'Phase 11 — Report'` → 1; plan.md:247 | Satisfied |
| Phase 10 after Phase 9, before Phase 11 (line order) | Lines 196, 204, 247 — correct ordering | Satisfied |
| (Recommended) label on Start option | `grep -c 'Recommended'` → 2; plan.md:212 | Satisfied |
| kanban-todo invocation documented for options 1–2 | `grep -c 'kanban-todo'` → 8; plan.md:212–213, 227–231 | Satisfied |
| Session-boundary confirmation gate documented | `grep -c 'session boundary'` → 2; plan.md:219 | Satisfied |
| from-plan-handoff argument passthrough documented | `grep -c 'from-plan-handoff'` → 2; plan.md:231 | Satisfied |
| Freeform option (Something else) present | `grep -c 'Something else'` → 1; plan.md:214 | Satisfied |
| Discard option present (stubbed with TASK-004 placeholder) | `grep -c 'Discard'` → 4; plan.md:215, 239–243 | Satisfied |
| audit PASS gate condition documented | `grep -Ec 'audit.*PASS\|PASS.*audit'` → 2; plan.md:206 | Satisfied |

Test results: No test framework detected — skipping test execution.
