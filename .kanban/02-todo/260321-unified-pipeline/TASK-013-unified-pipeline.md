---
id: "260321-unified-pipeline/TASK-013"
subject: "260321-unified-pipeline"
plan: "../../01-plan/260321-unified-pipeline/plan-unified-pipeline.md"
effort: medium
status: todo
created_at: "2026-03-22T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-009"
spawned_tickets: []
plan_items:
  - "Req 3.2 — pr mirrors kanban v1's pr pipeline adapted for new directory structure"
  - "Req 4.1 — PR bypass conditions: non-GitHub repo skips PR; unprotected trunk skips PR; check failure defers to user"
  - "Req 4.1 — git commits after each phase"
acceptance_criteria:
  - "[ -f skills/kanban2/commands/pr.md ] — file exists"
  - "grep -q 'model:' skills/kanban2/commands/pr.md — frontmatter has model field"
  - "grep -q 'allowed-tools:' skills/kanban2/commands/pr.md — frontmatter has allowed-tools"
  - "grep -qi '07-pull-request' skills/kanban2/commands/pr.md — picks up from 07-pull-request/ (not v1 05-pull-request/)"
  - "grep -qi '08-done' skills/kanban2/commands/pr.md — merged tickets move to 08-done/"
  - "grep -qi 'non.github\\|not.*github\\|no.*gh\\|bypass' skills/kanban2/commands/pr.md — non-GitHub bypass condition present"
  - "grep -qi 'unprotected\\|protection' skills/kanban2/commands/pr.md — unprotected trunk bypass condition present"
  - "grep -qi 'check.*fail\\|fail.*check\\|defer\\|user' skills/kanban2/commands/pr.md — check failure defers to user"
  - "grep -qi 'git' skills/kanban2/commands/pr.md — git commit or PR audit step present"
consecutive_failures: 0
---

## Context

Writes `skills/kanban2/commands/pr.md` — the pull-request command for kanban2. Adapts v1's `pr.md` (Advocate persona) for the new subject-centric directory structure. Key path changes:
- PR source: `YYYY-MM-DD-{subject}/07-pull-request/` (was v1 `05-pull-request/`)
- Merged tickets: move to `YYYY-MM-DD-{subject}/08-done/` (was v1 `06-archive/`)

PR bypass conditions (carry-forward from §4.1):
1. Non-GitHub repo → skip PR entirely
2. Unprotected trunk → skip PR, create audit-trail commit, route to cleanup
3. Protection check fails → stop and ask user (never auto-skip on unknown)

Command model: `claude-sonnet-4-6`.

## Acceptance Criteria

- `skills/kanban2/commands/pr.md` exists with valid frontmatter
- Picks up tickets from `07-pull-request/` (not v1's `05-pull-request/`)
- Merged tickets move to `08-done/`
- Non-GitHub bypass condition documented
- Unprotected trunk bypass condition documented
- Check-failure defers to user (not auto-skip) documented

---
<!-- Everything below this line is append-only and chronological -->
