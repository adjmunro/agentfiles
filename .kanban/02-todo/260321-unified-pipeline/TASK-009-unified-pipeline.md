---
id: "260321-unified-pipeline/TASK-009"
subject: "260321-unified-pipeline"
plan: "../../01-plan/260321-unified-pipeline/plan-unified-pipeline.md"
effort: low
status: todo
created_at: "2026-03-22T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-001"
spawned_tickets: []
plan_items:
  - "Req 3.1 — skill lives at skills/kanban2/; user-facing command /kanban"
  - "Req 6.2 — kanban2 CHANGELOG.md inherits from v1 (continuation, not fresh file)"
  - "Req 6.3 — kanban2 has its own VERSION.md starting at v2.0.0 (breaking change)"
acceptance_criteria:
  - "[ -d skills/kanban2 ] — directory exists"
  - "[ -d skills/kanban2/commands ] — commands/ subdirectory exists"
  - "[ -f skills/kanban2/AGENTS.md ] — AGENTS.md exists"
  - "[ -f skills/kanban2/SKILL.md ] — SKILL.md exists with /kanban command documented"
  - "[ -f skills/kanban2/VERSION.md ] — VERSION.md exists"
  - "grep -c '2.0.0' skills/kanban2/VERSION.md — returns 1 (version is 2.0.0)"
  - "[ -f skills/kanban2/CHANGELOG.md ] — CHANGELOG.md exists"
  - "grep -q '2.0.0' skills/kanban2/CHANGELOG.md — 2.0.0 entry present (kanban2 init)"
  - "grep -q '1.2' skills/kanban2/CHANGELOG.md — inherited v1 entries present (continuation)"
  - "SKILL.md documents new directory structure (YYYY-MM-DD-{subject}/ layout) — verifiable by reading the file"
consecutive_failures: 0
---

## Context

Creates the `skills/kanban2/` scaffold: all structural and documentation files for the kanban2 skill. Establishes the skill as discoverable before any command files are written. Traced to plan §3.1, §6.2, §6.3.

Kanban2 versioning: `CHANGELOG.md` is a continuation of `skills/kanban/CHANGELOG.md` — copy the v1 changelog as the starting content, then add a new `## 2.0.0 —` entry marking the kanban2 initialisation (breaking change: new subject-centric directory structure). `VERSION.md` starts at v2.0.0.

Personas are not duplicated — commands reference `../../kanban/personas/` (relative from `skills/kanban2/commands/`).

## Acceptance Criteria

- `skills/kanban2/` directory exists with `commands/` subdirectory
- `skills/kanban2/AGENTS.md` — documents git/versioning conventions for this skill
- `skills/kanban2/SKILL.md` — documents the `/kanban` command, the new directory structure, state machine, and command table
- `skills/kanban2/VERSION.md` — contains `**Current version**: 2.0.0`
- `skills/kanban2/CHANGELOG.md` — contains v1 inherited entries AND a `## 2.0.0 —` entry

---
<!-- Everything below this line is append-only and chronological -->
