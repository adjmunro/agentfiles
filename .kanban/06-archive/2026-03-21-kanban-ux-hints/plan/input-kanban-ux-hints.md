# 2026-03-21-kanban-ux-hints

## What

Add argument hints to the kanban skill so that when typing `/kanban` in Claude Code, the available subcommands are visible. Improve argument hints on all individual subcommand files too.

## Why

When writing `/kanban` there are no hints or autocomplete — it feels like guessing in the dark. The user wants to see what subcommands are available without having to remember them or run `/kanban` first to get the overview.

## Constraints

- Logic stays in the skill — no separate wrapper commands
- No splitting the skill into separate skills
- The change is metadata only: add `argument-hint` frontmatter to `SKILL.md` and to each command file under `commands/`
- Individual subcommand files already have `argument-hint` in some cases (e.g. `capture.md`) — these should be reviewed and improved, not just left as-is

## Assets

- `.claude/skills/kanban/SKILL.md` — top-level skill entry point; needs `argument-hint` listing available subcommands
- `.claude/skills/kanban/commands/capture.md` — has existing `argument-hint`; review and improve
- `.claude/skills/kanban/commands/plan.md`
- `.claude/skills/kanban/commands/todo.md`
- `.claude/skills/kanban/commands/work.md`
- `.claude/skills/kanban/commands/review.md`
- `.claude/skills/kanban/commands/pr.md`
- `.claude/skills/kanban/commands/cleanup.md`
- `.claude/skills/kanban/commands/next.md`
- `.claude/skills/kanban/commands/init.md`
