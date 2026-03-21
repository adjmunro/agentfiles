---
id: "260321-kanban-ux-hints/TASK-002"
subject: "260321-kanban-ux-hints"
plan: "../../01-plan/260321-kanban-ux-hints/plan-kanban-ux-hints.md"
effort: low
status: todo
created_at: "2026-03-21T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-001"
spawned_tickets: []
plan_items:
  - "Req 1.1 — Add argument-hint to SKILL.md frontmatter listing all subcommands in pipeline order"
  - "Req 1.2 — Format as pipe-separated list, concise enough to read at a glance"
  - "Req 3.1 — Verify SKILL.md supports argument-hint; document fallback if unsupported"
acceptance_criteria:
  - "`grep 'argument-hint' .claude/skills/kanban/SKILL.md` returns a non-empty line"
  - "The hint value contains all subcommands in order: capture, plan, todo, work, review, pr, cleanup, next, init"
  - "`cat .claude/skills/kanban/VERSION.md` shows a bumped version (patch or minor) vs the pre-change version"
  - "`head -5 .claude/skills/kanban/CHANGELOG.md` shows an entry for the new version"
  - "If SKILL.md does not surface the hint in Claude Code UI after testing, a note is added to the ticket log describing the behaviour and proposing a fallback"
consecutive_failures: 0
---

## Context

SKILL.md is the entry point for the `/kanban` skill. It currently has no `argument-hint` in its frontmatter — so when a user types `/kanban` in Claude Code, there is no visible indicator of available subcommands. This ticket adds the hint.

The hint format follows plan §1.2: pipe-separated list of subcommands in pipeline order. Example:
```
argument-hint: "capture | plan | todo | work | review | pr | cleanup | next | init"
```

Note: it is unverified whether SKILL.md actually surfaces `argument-hint` in the Claude Code UI (individual command files do, but SKILL.md may behave differently). Test after committing and document the result.

Version bump and CHANGELOG update are required by AGENTS.md for all kanban skill changes.

## Acceptance Criteria

- `SKILL.md` frontmatter contains `argument-hint` with all 9 subcommands in pipeline order
- `VERSION.md` reflects a bumped version
- `CHANGELOG.md` has a new entry describing the change
- Post-commit: tested in Claude Code UI; result documented in this ticket's log section (pass or fallback noted)

---
<!-- Everything below this line is append-only and chronological -->
