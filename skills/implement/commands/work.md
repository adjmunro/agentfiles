---
model: claude-haiku-4-5-20251001
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion, Agent
argument-hint: "[YYYY-MM-DD-{subject}/TASK-NNN] — ticket to implement"
---

<!-- This file is a phase dispatcher. It contains ONLY boot logic and phase dispatch.
     All phase instructions live in work/ subdirectory files.
     Each phase file contains only that phase's instructions — no future-phase content
     is loaded until needed. Read only the current phase file. Do not pre-read future phases. -->

> **Note on model selection:** The frontmatter model above is the default (low effort). At runtime, the actual model is determined by the ticket's `effort` field: `low` → fast/cheap model, `medium` → standard model, `high` → most capable model. Spawn subagents at the appropriate tier when your environment supports it.

# Work — Orchestrator

## Personas

Read `../../personas/builder/persona.md` before proceeding. You are **Kira (Builder)** throughout this command.

## DO

- Claim the lowest-numbered unblocked ticket from `.kanban/YYYY-MM-DD-{subject}/04-todo/` unless `$ARGUMENTS` specifies a ticket
- Include inline WHY-comments in every code change — this is a hard requirement, not a suggestion
- Reference plan items and ticket IDs in code comments wherever a piece of code satisfies a requirement
- Commit after every meaningful unit of work using the prescribed format
- Create new tickets in `04-todo/` for any out-of-scope work discovered during implementation
- Override model tier based on the ticket's `effort` field (low→haiku, medium→sonnet, high→opus)

## DO NOT

- Touch plan-layer files or directories: `00-input-*`, `01-research-*`, `02-plan-*`, `00-assets/`, `03-refinement/`
- Batch unrelated changes into a single commit
- Edit existing entries in the ticket's append zone — only append new ones
- Proceed if `.kanban/YYYY-MM-DD-{subject}/04-todo/` does not exist
- Move a ticket to `05-in-progress/` without first writing a lock file to `.kanban/YYYY-MM-DD-{subject}/.claims/`

## Phase Dispatch Table

| Phase | File | Active when |
|-------|------|-------------|
| 1 | `work/p1-session-check.md` | command is first invoked |
| 2 | `work/p2-ticket-selection.md` | Phase 1 check passed |
| 3 | `work/p3-implementation.md` | ticket selected and claimed |
| 4 | `work/p4-stale-detection.md` | ticket has been claimed |
| 5 | `work/p5-scope-enforcement.md` | out-of-scope work discovered during Phase 3 |
| 6 | `work/p6-work-log.md` | implementation complete |
| 7 | `work/p7-commit.md` | any phase produces a meaningful artifact |
| 8 | `work/p8-move-to-review.md` | all ACs verified and work log appended |

> **Execution order note:** Phase 4 (Stale Detection) runs immediately after Phase 2, before Phase 3 (Implementation). The numbering reflects logical grouping, not strict execution sequence. Actual order: 1 → 2 → 4 → 3 → 5 → 6 → 7 → 8.

## Execution

Read Phase 1 file now: `work/p1-session-check.md`
Execute it completely. Then read the next phase file as instructed within that file.
Each phase file ends with a "→ Next" line pointing to the next phase file.
