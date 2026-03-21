---
id: "260321-unified-pipeline/TASK-010"
subject: "260321-unified-pipeline"
plan: "../../01-plan/260321-unified-pipeline/plan-unified-pipeline.md"
effort: low
status: todo
created_at: "2026-03-22T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-009"
spawned_tickets: []
plan_items:
  - "Req 3.1 — /kanban command; skills/kanban2/"
  - "Req 1.1 — subject dir name: YYYY-MM-DD-{subject}/"
  - "Req 1.2–1.4 — loose docs (00-input, 01-research, 02-plan) + 00-assets/ + stage subdirs 03-08"
  - "Req 1.7 — archive path: .kanban/.archive/YYYY-MM-DD-{subject}/"
  - "Req 1.8 — v1 structure coexists unchanged"
acceptance_criteria:
  - "[ -f skills/kanban2/commands/init.md ] — file exists"
  - "grep -q 'model:' skills/kanban2/commands/init.md — frontmatter has model field"
  - "grep -q 'allowed-tools:' skills/kanban2/commands/init.md — frontmatter has allowed-tools"
  - "grep -qi 'YYYY-MM-DD' skills/kanban2/commands/init.md — subject dir naming convention documented"
  - "grep -qi '03-refinement' skills/kanban2/commands/init.md — 03-refinement/ stage dir referenced"
  - "grep -qi '04-todo' skills/kanban2/commands/init.md — 04-todo/ stage dir referenced"
  - "grep -qi '08-done' skills/kanban2/commands/init.md — 08-done/ stage dir referenced"
  - "grep -qi '00-assets' skills/kanban2/commands/init.md — 00-assets/ dir referenced"
  - "grep -qi '\\.archive' skills/kanban2/commands/init.md — .kanban/.archive/ path referenced"
  - "grep -qi 'coexist\\|v1\\|01-plan\\|02-todo' skills/kanban2/commands/init.md — v1 coexistence noted"
consecutive_failures: 0
---

## Context

Writes `skills/kanban2/commands/init.md` — the setup command that creates the new subject-centric `.kanban/YYYY-MM-DD-{subject}/` directory structure. Creates all stage subdirectories (`03-refinement/` through `08-done/`) and the `00-assets/` folder. Documents the archive path (`.kanban/.archive/YYYY-MM-DD-{subject}/`). Notes that v1 structure (`.kanban/{stage}/{subject}/`) coexists unchanged.

Command model: `claude-haiku-4-5-20251001` (low-tier, simple directory creation).

## Acceptance Criteria

- `skills/kanban2/commands/init.md` exists with valid frontmatter
- `YYYY-MM-DD-{subject}/` naming convention documented
- All stage directories referenced: `03-refinement/`, `04-todo/`, `05-in-progress/`, `06-in-review/`, `07-pull-request/`, `08-done/`
- `00-assets/` creation documented
- `.kanban/.archive/` path documented for later use
- V1 coexistence behaviour noted (does not touch v1 structure)

---
<!-- Everything below this line is append-only and chronological -->
