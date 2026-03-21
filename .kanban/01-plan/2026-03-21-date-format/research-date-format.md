## Research: 260321-date-format
**Date**: 2026-03-21T00:00:00Z
**Status**: Snapshot — may go stale. Verify before acting.

## Project Structure

**11 subject directories to rename** across `.kanban/` stages:

| Stage | Current | Target |
|-------|---------|--------|
| 01-plan | 260321-date-format | 2026-03-21-date-format |
| 01-plan | 260321-command-handoff | 2026-03-21-command-handoff |
| 02-todo | 260321-command-handoff | 2026-03-21-command-handoff |
| 02-todo | 260321-kanban-ux-hints | 2026-03-21-kanban-ux-hints |
| 03-in-progress | 260321-command-handoff | 2026-03-21-command-handoff |
| 03-in-progress | 260321-kanban-ux-hints | 2026-03-21-kanban-ux-hints |
| 04-in-review | 260321-kanban-ux-hints | 2026-03-21-kanban-ux-hints |
| 05-pull-request | 260321-command-handoff | 2026-03-21-command-handoff |
| 06-archive | 260321-capture-flow | 2026-03-21-capture-flow |
| 06-archive | 260321-kanban-ux-hints | 2026-03-21-kanban-ux-hints |
| 06-archive | 260321-pr-trunk-skip | 2026-03-21-pr-trunk-skip |

Note: 260321-capture-flow and 260321-pr-trunk-skip also have active tickets in 02-todo (separate from archived versions).

**21 files with YYMMDD content** (167 total occurrences):
- 9 command files: 117 occurrences (capture, plan, todo, work, review, pr, cleanup, next, init)
- SKILL.md: 1 occurrence (directory structure diagram, line ~55)
- 11 ticket/plan/research files under .kanban/: 50 occurrences

**3 files with `date +%y%m%d`** needing conversion to `date +%Y-%m-%d`:
- commands/capture.md, commands/plan.md, commands/init.md

## Relevant Patterns

- Directories renamed with `mv` — never delete/recreate (audit trail)
- All 11 subject dirs follow identical `YYMMDD-<subject>` → `YYYY-MM-DD-<subject>` pattern
- Command files use YYMMDD in: phase instructions, bash examples, commit message templates, subject slug derivation steps
- Ticket frontmatter fields affected: `id`, `subject`, `plan` (relative path)
- File title/header patterns: `# YYMMDD-<subject>`, `## Research: YYMMDD-<subject>`
- No YYMMDD references exist outside `skills/kanban/` and `.kanban/`

## Dependencies

- Directory renames (TASK-002) must happen before content updates to .kanban/ files (TASK-003) — paths in frontmatter reference the new directory names
- Command file updates (TASK-004) are independent of directory renames
- SKILL.md update (TASK-005) is independent
- Version bump (TASK-006) is last

## Hazards

- **Self-referential rename**: `260321-date-format` is in the rename list. After TASK-002 runs, the working subject directory is `2026-03-21-date-format`. Subsequent tasks must reference the new path.
- **02-todo subjects**: `260321-capture-flow` and `260321-pr-trunk-skip` have active tickets in `02-todo` (not just in archive). These dirs also need renaming — don't miss them.
- **Relative paths in frontmatter**: `plan:` fields like `../../01-plan/260321-capture-flow/plan-capture-flow.md` must be updated after directory rename.
- **43 total markdown files touched** — methodical file-by-file edits required; no bulk sed (use Edit tool per file).

## Recommended Ticket Sequence

1. **TASK-001** — TDD Red Phase: enumerate falsifiable criteria before any changes
2. **TASK-002** — Rename all 11 .kanban/ subject directories via `mv`
3. **TASK-003** — Update file content under .kanban/ (frontmatter, titles, cross-refs)
4. **TASK-004** — Update all 9 command files (YYMMDD→YYYY-MM-DD, date command templates)
5. **TASK-005** — Update SKILL.md directory structure diagram
6. **TASK-006** — Version bump & changelog
