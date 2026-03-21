# 260321-date-format

## What

i want to change all YYMMDD to YYYY-MM-DD

Rename everything — existing .kanban/ dirs, ticket IDs, frontmatter, command files, SKILL.md and docs. Going-forward only is not acceptable; everything should be consistent.

## Why

YYMMDD is ambiguous and hard to read at a glance. YYYY-MM-DD is ISO 8601, sorts correctly, and is immediately human-readable without mental parsing.

## Constraints

- All existing `.kanban/` directories must be renamed from `YYMMDD-<subject>` to `YYYY-MM-DD-<subject>` (e.g. `260321-capture-flow` → `2026-03-21-capture-flow`)
- All ticket file frontmatter (`id:`, `subject:`, `plan:` fields) must be updated to reflect the new directory names
- All command files (`capture.md`, `plan.md`, `todo.md`, `work.md`, `review.md`, `pr.md`, `cleanup.md`, `next.md`, `init.md`) must be updated wherever `YYMMDD` appears in examples, instructions, or bash commands
- The `date` bash command template must change from `date +%y%m%d` to `date +%Y-%m-%d`
- `SKILL.md` and any other docs must be updated wherever `YYMMDD` appears
- Commit messages that include the subject slug must use the new format going forward (e.g. `kanban(capture): capture raw input for 2026-03-21-<subject>`)

## Assets

- `.kanban/` — all existing stage directories with YYMMDD-prefixed subjects
- `skills/kanban/commands/` — all 9 command files
- `skills/kanban/SKILL.md` — state machine and directory structure docs
