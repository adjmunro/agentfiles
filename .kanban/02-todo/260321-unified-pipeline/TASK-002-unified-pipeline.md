---
id: "260321-unified-pipeline/TASK-002"
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
  - "Req 2.1 — user-facing command /ideate; skill lives at skills/ideation/"
  - "Req 6.1 — ideation has its own VERSION.md (v1.0.0) and CHANGELOG.md"
  - "Req 4.2 — personas shared from skills/kanban/personas/"
acceptance_criteria:
  - "[ -d skills/ideation/commands ] — commands/ directory exists"
  - "[ -f skills/ideation/AGENTS.md ] — AGENTS.md exists"
  - "[ -f skills/ideation/SKILL.md ] — SKILL.md exists with /ideate command documented"
  - "[ -f skills/ideation/VERSION.md ] — VERSION.md exists with version 1.0.0"
  - "[ -f skills/ideation/CHANGELOG.md ] — CHANGELOG.md exists with 1.0.0 entry"
  - "grep -c '1.0.0' skills/ideation/VERSION.md returns 1"
  - "SKILL.md documents the 9-step ideation flow and new directory structure — verifiable by reading the file"
consecutive_failures: 0
---

## Context

Creates the `skills/ideation/` scaffold: all structural and documentation files for the new ideation skill. Establishes the skill as discoverable before any command files are written. Traced to plan §2.1, §6.1, §4.2.

The ideation skill starts at v1.0.0 with an independent version lifecycle. Personas are not duplicated — commands reference `../../kanban/personas/` (relative from a command file at `skills/ideation/commands/`).

## Acceptance Criteria

- `skills/ideation/` directory exists with `commands/` subdirectory
- `skills/ideation/AGENTS.md` — documents git/versioning conventions for this skill
- `skills/ideation/SKILL.md` — documents the `/ideate` command, the 9-step flow, the new directory structure (YYYY-MM-DD-{subject}/ layout), and the state machine
- `skills/ideation/VERSION.md` — contains `**Current version**: 1.0.0`
- `skills/ideation/CHANGELOG.md` — contains a `## 1.0.0 —` entry dated 2026-03-22 (initial release)
- `grep -c '1.0.0' skills/ideation/VERSION.md` returns `1`

---
<!-- Everything below this line is append-only and chronological -->
