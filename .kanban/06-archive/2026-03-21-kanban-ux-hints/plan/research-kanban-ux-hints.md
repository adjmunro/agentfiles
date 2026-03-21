## Research: 2026-03-21-kanban-ux-hints
**Date**: 2026-03-21T00:00:00Z
**Status**: Snapshot — may go stale. Verify before acting.

## Project Structure

```
.claude/skills/kanban/
├── SKILL.md          ← top-level skill entry point (THE gap — no argument-hint)
├── AGENTS.md         ← commit/versioning rules
├── CHANGELOG.md
├── VERSION.md        ← semver; bump required for skill changes
├── commands/
│   ├── init.md       ✓ has argument-hint
│   ├── capture.md    ✓ has argument-hint
│   ├── plan.md       ✓ has argument-hint
│   ├── todo.md       ✓ has argument-hint
│   ├── work.md       ✓ has argument-hint
│   ├── review.md     ✓ has argument-hint
│   ├── pr.md         ✓ has argument-hint
│   ├── cleanup.md    ✓ has argument-hint
│   └── next.md       ✓ has argument-hint
└── personas/         (out of scope)
```

## Relevant Patterns

**Frontmatter convention** (from command files):
```yaml
---
model: <model-id>
allowed-tools: Read, Grep, ...
argument-hint: "<hint text>"
---
```

`argument-hint` is a single-line string. All 9 command files use it. SKILL.md currently has only `name` and `description` — no `argument-hint` field.

**SKILL.md current frontmatter:**
```yaml
---
name: kanban
description: Use when managing a software development project with a structured pipeline from capture through implementation, review, PR, and archive — especially when intent and reasoning must be traceable across agent sessions
---
```

**Existing hints (all 9 command files):**

| File | Current hint |
|------|-------------|
| init.md | `[YYYY-MM-DD-<subject>] — optional subject name override; omit to auto-derive` |
| capture.md | `[YYYY-MM-DD-<subject>] — subject to capture; omit to auto-derive` |
| plan.md | `[YYYY-MM-DD-<subject>] — subject to plan; omit to auto-derive` |
| todo.md | `[YYYY-MM-DD-<subject>] — subject to break down; omit to auto-derive` |
| work.md | `[YYYY-MM-DD-<subject>/TASK-NNN] — specific ticket path; omit to auto-select lowest unblocked` |
| review.md | `[YYYY-MM-DD-<subject>/TASK-NNN] — specific ticket; omit to auto-select from 04-in-review` |
| pr.md | `[YYYY-MM-DD-<subject>] — subject to raise PR for; omit to auto-derive` |
| cleanup.md | `[YYYY-MM-DD-<subject>] — subject to archive; omit to auto-derive` |
| next.md | `[YYYY-MM-DD-<subject>] — subject to work on; omit to list available subjects` |

All look accurate. `work.md` and `review.md` correctly use the `TASK-NNN` path format since they operate at ticket granularity. Minor candidates for improvement: `pr.md` hint is generic ("raise PR for") — could be more informative.

## Dependencies

- SKILL.md change is independent from command file audit — either can land first
- VERSION.md and CHANGELOG.md must be updated after SKILL.md changes (AGENTS.md rules)
- Technical verification (§3.1) depends on SKILL.md change being committed and tested

## Hazards

- **Unverified assumption**: It is unknown whether the superpowers skill system reads `argument-hint` from SKILL.md the same way it does from individual command files. If unsupported, the SKILL.md change is a no-op and a fallback strategy is needed. This should be flagged in the ticket AC.
- **`init.md` hint ambiguity**: The hint says "optional subject name override" but `init` creates the folder structure, not a subject plan. The wording is technically accurate (init *does* accept an optional subject) but could cause confusion. Worth revisiting in the audit pass.

## Recommended Ticket Sequence

1. **TASK-001** — TDD Red Phase: write a verification script that asserts the expected final state. Runs red (fails) before any changes.
2. **TASK-002** — Add `argument-hint` to `SKILL.md`; bump version; update CHANGELOG.
3. **TASK-003** — Audit all 9 command file hints; update any that are inaccurate or could be improved; run verification script to confirm green.
