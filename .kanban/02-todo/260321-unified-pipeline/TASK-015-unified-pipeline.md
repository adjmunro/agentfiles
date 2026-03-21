---
id: "260321-unified-pipeline/TASK-015"
subject: "260321-unified-pipeline"
plan: "../../01-plan/260321-unified-pipeline/plan-unified-pipeline.md"
effort: high
status: todo
created_at: "2026-03-22T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-014"
spawned_tickets: []
plan_items:
  - "Req 3.3 — thin next.md-equivalent orchestrator drives the work→review loop for kanban2"
  - "Req 3.3 — same escalation, stale detection, and consecutive-failure logic as v1's next.md"
  - "Req 3.2 — picks up from .kanban/YYYY-MM-DD-{subject}/04-todo/"
  - "Req 4.1 — argument-based boundary passthrough"
acceptance_criteria:
  - "[ -f skills/kanban2/commands/next.md ] — file exists"
  - "grep -q 'model:' skills/kanban2/commands/next.md — frontmatter has model field"
  - "grep -q 'allowed-tools:' skills/kanban2/commands/next.md — frontmatter has allowed-tools"
  - "grep -q 'argument-hint:' skills/kanban2/commands/next.md — frontmatter has argument-hint"
  - "grep -qi 'work.md' skills/kanban2/commands/next.md — dispatches to work.md"
  - "grep -qi 'review.md' skills/kanban2/commands/next.md — dispatches to review.md"
  - "grep -qi 'pr.md' skills/kanban2/commands/next.md — dispatches to pr.md"
  - "grep -qi 'cleanup.md' skills/kanban2/commands/next.md — dispatches to cleanup.md"
  - "grep -qi '04-todo' skills/kanban2/commands/next.md — scans 04-todo/ for available work"
  - "grep -qi '05-in-progress\\|06-in-review\\|07-pull-request' skills/kanban2/commands/next.md — scans active stages"
  - "grep -qi 'stale' skills/kanban2/commands/next.md — stale ticket detection logic present"
  - "grep -qi 'consecutive' skills/kanban2/commands/next.md — consecutive failure escalation present"
  - "grep -qi 'YYYY-MM-DD' skills/kanban2/commands/next.md — new subject dir format referenced"
consecutive_failures: 0
---

## Context

Writes `skills/kanban2/commands/next.md` — the thin orchestrator for kanban2's work loop. This is the user-facing `/kanban` command entry point. It mirrors v1's `next.md` pattern: scans stages in priority order, dispatches to the appropriate command (`work.md`, `review.md`, `pr.md`, `cleanup.md`), handles stale detection, consecutive-failure escalation, and desktop notifications.

Key differences from v1's `next.md`:
- Scans `YYYY-MM-DD-{subject}/04-todo/` through `07-pull-request/` (not v1 flat `02-todo/` etc.)
- Must handle multiple subjects if more than one has active tickets
- Completion check: `08-done/` as the terminal state

Command model: `claude-haiku-4-5-20251001` (low-tier orchestrator, same as v1 next.md).

## Acceptance Criteria

- `skills/kanban2/commands/next.md` exists with valid frontmatter
- Dispatches to all four command files by name: `work.md`, `review.md`, `pr.md`, `cleanup.md`
- Scans `04-todo/` for available work (new path, not v1 `02-todo/`)
- Scans active stages: `05-in-progress/`, `06-in-review/`, `07-pull-request/`
- Stale ticket detection present
- Consecutive failure escalation present
- New `YYYY-MM-DD-{subject}/` path format used throughout

---
<!-- Everything below this line is append-only and chronological -->
