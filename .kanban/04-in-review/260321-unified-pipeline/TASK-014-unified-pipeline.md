---
id: "260321-unified-pipeline/TASK-014"
subject: "260321-unified-pipeline"
plan: "../../01-plan/260321-unified-pipeline/plan-unified-pipeline.md"
effort: medium
status: in_review
created_at: "2026-03-22T00:00:00Z"
claimed_at: "2026-03-22T00:00:00Z"
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-009"
spawned_tickets: []
plan_items:
  - "Req 1.5 — completion signal: all tickets in 08-done/"
  - "Req 1.6 — archive: delete empty stage dirs, move whole subject folder to .kanban/.archive/"
  - "Req 3.5 — finished tickets move to 08-done/"
  - "Req 4.1 — git commits after each phase"
acceptance_criteria:
  - "[ -f skills/kanban2/commands/cleanup.md ] — file exists"
  - "grep -q 'model:' skills/kanban2/commands/cleanup.md — frontmatter has model field"
  - "grep -q 'allowed-tools:' skills/kanban2/commands/cleanup.md — frontmatter has allowed-tools"
  - "grep -qi '08-done' skills/kanban2/commands/cleanup.md — 08-done/ referenced as completion signal"
  - "grep -qi '\\.archive' skills/kanban2/commands/cleanup.md — .kanban/.archive/ archive path referenced"
  - "grep -qi 'YYYY-MM-DD' skills/kanban2/commands/cleanup.md — date-prefixed archive dir format present"
  - "grep -qi 'empty\\|delete.*dir\\|remove.*dir' skills/kanban2/commands/cleanup.md — empty stage dir cleanup documented"
  - "grep -qi '00-assets\\|assets' skills/kanban2/commands/cleanup.md — 00-assets/ preserved in archive noted"
  - "grep -qi 'git' skills/kanban2/commands/cleanup.md — git commit step present"
consecutive_failures: 0
---

## Context

Writes `skills/kanban2/commands/cleanup.md` — the archive and cleanup command for kanban2. Adapts v1's `cleanup.md` (Critic persona) for the new subject-centric directory structure. Key behaviours:

- Completion check: all tickets for the subject are in `08-done/` (zero remaining in `04-todo/` through `07-pull-request/`)
- Archive: delete all empty stage directories, then move the entire subject folder to `.kanban/.archive/YYYY-MM-DD-{subject}/`
- Post-archive state: only `08-done/` (if non-empty) and `00-assets/` (if non-empty) remain inside the archived subject folder
- Does not touch plan-layer files during cleanup (they move with the subject folder)

Command model: `claude-haiku-4-5-20251001` (low-tier, straightforward file operations).

## Acceptance Criteria

- `skills/kanban2/commands/cleanup.md` exists with valid frontmatter
- `08-done/` as completion signal documented (all tickets must be there)
- Archive path: `.kanban/.archive/YYYY-MM-DD-{subject}/` documented
- Empty stage directory cleanup step present
- `00-assets/` preservation in archive noted
- Git commit step present

---
<!-- Everything below this line is append-only and chronological -->

## Work Log

**2026-03-22T00:00:00Z** — `kanban-work` (claude-sonnet-4-6)

- Moved ticket `02-todo/` → `03-in-progress/`, set `status: in_progress`, `claimed_at: "2026-03-22T00:00:00Z"`
- Read v1 reference: `skills/kanban/commands/cleanup.md` (Critic/Pulse pattern, v1 stage paths)
- Created `skills/kanban2/commands/cleanup.md` with:
  - Frontmatter: `model: claude-haiku-4-5-20251001`, `allowed-tools`, `argument-hint`
  - Single persona: Arden (Critic) via `../../kanban/personas/critic.md`
  - DO / DO NOT section with v1 coexistence guard
  - Phase 1 — Completion Check: zero tickets in `04-todo/`–`07-pull-request/`, non-zero in `08-done/`
  - Phase 2 — Audit Summary: count + sanity-check status fields
  - Phase 3 — Clean Empty Dirs: `rmdir` empty stage dirs, preserve `08-done/` and `00-assets/`
  - Phase 4 — Archive: `mkdir -p .kanban/.archive/`, `mv` subject to `.kanban/.archive/YYYY-MM-DD-{subject}/`
  - Phase 5 — Git Commit: `kanban(cleanup): archive {subject}`
- Verified all 9 ACs: PASS
- Moved ticket `03-in-progress/` → `04-in-review/`, set `status: in_review`
