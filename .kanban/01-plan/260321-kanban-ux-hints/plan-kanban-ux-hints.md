# Plan: 260321-kanban-ux-hints

## Intent

Make kanban subcommands discoverable directly from the `/kanban` entry point in Claude Code. Currently the skill has no argument hint — users must remember subcommand names or run the command blind to see the overview. The fix is metadata-only: add `argument-hint` to `SKILL.md` and audit/improve existing hints on all nine command files.

## Requirements

### 1. Top-level skill hint

**1.1** Add `argument-hint` to `SKILL.md` frontmatter listing all subcommands in pipeline order.

**1.2** Format the hint as a pipe-separated list, concise enough to read at a glance:
```
capture | plan | todo | work | review | pr | cleanup | next | init
```

### 2. Subcommand-level hint quality

**2.1** Audit all nine command files against their current `argument-hint` values:
- `init.md` — has hint; verify accuracy against what the command actually accepts
- `capture.md` — has hint; verify accuracy
- `plan.md` — has hint; verify accuracy
- `todo.md` — has hint; verify accuracy
- `work.md` — has hint; verify accuracy
- `review.md` — has hint; verify accuracy
- `pr.md` — has hint; verify accuracy
- `cleanup.md` — has hint; verify accuracy
- `next.md` — has hint; verify accuracy

**2.2** Revise any hint that is vague, inaccurate, or doesn't match what the command actually accepts as arguments.

### 3. Technical verification

**3.1** After implementing, verify that `SKILL.md` actually surfaces the `argument-hint` in Claude Code's UI (unverified assumption). If `SKILL.md` does not support `argument-hint`, document the finding and propose an alternative — such as updating the skill `description` field to include subcommand names, or exploring other frontmatter fields.

## Constraints

- All changes are frontmatter-only — no logic, command phases, personas, or prompt content is modified
- No new files created; no commands split out, wrapped, or duplicated
- The kanban skill remains a single skill with subcommands routed via `$ARGUMENTS`
- `SKILL.md` and the nine command files under `commands/` are the only files in scope

## Out of Scope

- True dropdown/tab-completion autocomplete (requires platform-level changes to Claude Code; not achievable from skill files alone)
- Logic changes to any command's phase flow or behavior
- Changes to persona files, version files, changelog, or any non-command files
- Creating standalone slash commands (e.g. `/kanban-capture`) as wrappers

## Audit: input → plan — PASS
**Date**: 2026-03-21T00:00:00Z  **Threshold**: 95%

| # | Item | Status | Notes |
|---|------|--------|-------|
| 1 | Add argument-hint to SKILL.md | Full | §1.1, §1.2 |
| 2 | Improve hints on all subcommand files | Full | §2.1, §2.2 |
| 3 | Discoverability motivation | Full | Intent |
| 4 | No wrapper commands | Full | Constraints + Out of Scope |
| 5 | No splitting skill | Full | Constraints |
| 6 | Metadata only | Full | Constraints |
| 7 | Review existing hints, not just add | Full | §2.2 explicitly covers revision |
| 8 | SKILL.md asset | Full | §1.1 |
| 9 | capture.md existing hint review | Full | §2.1 |
| 10 | All 9 command files listed | Full | §2.1 enumerates all nine |

- Full: 10, Partial: 0, Missing: 0 — Total: 10
- Score: (10 + 0.5×0) / 10 × 100 = **100%**

### Fixes Applied
None — all input items fully covered on first pass.

---

## Acceptance Signals

- `/kanban` typed in Claude Code shows a visible hint listing available subcommands
- All nine command files have accurate, reviewed `argument-hint` values
- Both criteria verified: visually in the Claude Code UI and by code inspection of frontmatter
