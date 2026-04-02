---
model: claude-opus-4-6
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion
argument-hint: "[YYYY-MM-DD-{subject}] — subject to create tickets for"
---

<!-- This file is a phase dispatcher. It contains ONLY boot logic and phase dispatch.
     All phase instructions live in tickets/ subdirectory files.
     Each phase file contains only that phase's instructions — no future-phase content
     is loaded until needed. Read only the current phase file. Do not pre-read future phases. -->

# Tickets — Orchestrator

## Personas

- `../../personas/scout/persona.md` — **Finn (Scout)** — active in Phase 2
- `../../personas/critic/persona.md` — **Arden (Critic)** — active in Phases 3b and 4

Read each file before proceeding. Identify by the active persona when communicating with the user.

## DO

- Write all tickets to `03-refinement/` — this is the only valid staging location during ideation
- Make TASK-001 always the TDD red phase — no exceptions, never skip, never merge into another ticket
- Write acceptance criteria that are empirically verifiable: a runnable command with expected output, or an unambiguous observable state
- Auto-fix all audit gaps before committing — never ask permission to fix
- Commit once after drafting tickets, once after the audit passes

## DO NOT

- Write any ticket directly to `04-todo/` — tickets are drafted to `03-refinement/` first and stay there until the orchestrator promotes them at Step 9 (ideate.md Phase 8), gated by user confirmation
- Skip or merge TASK-001 with any other ticket
- Write vague ACs — "documentation updated" is not acceptable; "grep -c 'TODO' docs/ returns 0" is
- Create tickets for version bumps or changelog updates — those happen automatically in commits
- Proceed if the plan file (`02-plan-{subject}.md`) is missing

## Phase Dispatch Table

| Phase | File | Active when |
|-------|------|-------------|
| 1 | `tickets/p1-load-plan.md` | command is first invoked |
| 2 | `tickets/p2-scout-research.md` | plan loaded and enumerated |
| 3 | `tickets/p3-draft-tickets.md` | Scout research complete |
| 3b | `tickets/p3b-lint.md` | all ticket files drafted — per-ticket quality check before coverage audit |
| 4 | `tickets/p4-critic-audit.md` | lint passes — all tickets have valid effort, non-empty ACs, and concrete verifiable signals |
| 4b | `tickets/p4b-tighten.md` | coverage audit passes at ≥ 95% — prose tightening pass before commit |
| 5 | `tickets/p5-commit.md` | tighten pass complete |

## Execution

Read Phase 1 file now: `tickets/p1-load-plan.md`
Execute it completely. Then read the next phase file as instructed within that file.
Each phase file ends with a "→ Next" line pointing to the next phase file.
