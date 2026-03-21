---
id: "260321-unified-pipeline/TASK-011"
subject: "260321-unified-pipeline"
plan: "../../01-plan/260321-unified-pipeline/plan-unified-pipeline.md"
effort: medium
status: in_review
created_at: "2026-03-22T00:00:00Z"
claimed_at: "2026-03-22T00:00:00Z"
completed_at: "2026-03-22T00:00:00Z"
stale_after_hours: 4
depends_on:
  - "TASK-009"
spawned_tickets: []
plan_items:
  - "Req 3.2 — picks up tickets from .kanban/YYYY-MM-DD-{subject}/04-todo/"
  - "Req 3.4 — kanban2 never touches 00-input-, 01-research-, 02-plan-, 00-assets/, 03-refinement/"
  - "Req 4.1 — all v1 work.md patterns carry forward (WHY-comments, per-ticket effort model)"
  - "Req 4.1 — stale ticket detection via stale_after_hours"
  - "Req 4.1 — consecutive failures escalation"
  - "Req 4.1 — git commits after each phase"
acceptance_criteria:
  - "[ -f skills/kanban2/commands/work.md ] — file exists"
  - "grep -q 'model:' skills/kanban2/commands/work.md — frontmatter has model field"
  - "grep -q 'allowed-tools:' skills/kanban2/commands/work.md — frontmatter has allowed-tools"
  - "grep -qi '04-todo' skills/kanban2/commands/work.md — picks up from 04-todo/ (not v1 02-todo/)"
  - "grep -qi '05-in-progress' skills/kanban2/commands/work.md — moves ticket to 05-in-progress/"
  - "grep -qi '06-in-review\\|in.review' skills/kanban2/commands/work.md — moves ticket to 06-in-review/"
  - "grep -qi 'stale' skills/kanban2/commands/work.md — stale_after_hours detection present"
  - "grep -qi 'consecutive' skills/kanban2/commands/work.md — consecutive failure escalation present"
  - "grep -qi 'WHY\\|why.comment\\|comment.*why' skills/kanban2/commands/work.md — WHY-comment requirement present"
  - "grep -qi '03-refinement\\|00-input\\|01-research\\|02-plan' skills/kanban2/commands/work.md — DO NOT references for plan-layer files"
consecutive_failures: 0
---

## Context

Writes `skills/kanban2/commands/work.md` — the implementation command for kanban2. Adapts v1's `work.md` for the new subject-centric directory structure. Key path changes:
- Ticket source: `YYYY-MM-DD-{subject}/04-todo/` (was v1 `02-todo/{subject}/`)
- In-progress: `YYYY-MM-DD-{subject}/05-in-progress/` (was v1 `03-in-progress/`)
- In-review: `YYYY-MM-DD-{subject}/06-in-review/` (was v1 `04-in-review/`)

Kanban2 must never touch plan-layer files (`00-input-`, `01-research-`, `02-plan-`, `00-assets/`, `03-refinement/`). All v1 work patterns carry forward: WHY-comments, per-ticket effort model override, stale detection, consecutive failure escalation, git commits.

Command model: `claude-haiku-4-5-20251001` (overridden by ticket `effort` field at runtime).

## Acceptance Criteria

- `skills/kanban2/commands/work.md` exists with valid frontmatter
- Picks up tickets from `04-todo/` (not v1's `02-todo/`)
- Moves claimed ticket to `05-in-progress/`
- Moves completed ticket to `06-in-review/`
- Stale ticket detection (`stale_after_hours`) present
- Consecutive failure escalation present
- WHY-comment requirement documented
- Explicit prohibition on touching plan-layer paths (`03-refinement/`, `00-input-`, etc.)

---
<!-- Everything below this line is append-only and chronological -->

## Work Log — 2026-03-22T00:00:00Z

Implemented `skills/kanban2/commands/work.md` — the implementation command for the kanban2 skill.

**What was done:**
- Created `skills/kanban2/commands/work.md` with all required frontmatter: `model: claude-haiku-4-5-20251001`, `allowed-tools`, `argument-hint`
- Structured command around 10 phases adapted from v1's work.md, with all paths updated to kanban2's subject-centric layout
- Phase 1 (Session Boundary): added `from-ideation-handoff` passthrough check and in-progress conflict detection — WHY: kanban2 is work-only; active ticket conflicts must be surfaced before claiming new work to avoid split-brain state
- Phase 2 (Ticket Selection): targets `04-todo/` (not v1's `02-todo/`) and moves claimed ticket to `05-in-progress/` — WHY: Req 3.2 requires the new directory structure; picking from `02-todo/` would be a hard regression
- Phase 3 (Implementation): explicit plan-layer isolation section listing `00-input-*`, `01-research-*`, `02-plan-*`, `00-assets/`, `03-refinement/` as never-touch paths — WHY: Req 3.4; these belong to ideation and kanban2 must never corrupt them
- Phase 3 (Implementation): WHY-comment requirement documented as non-negotiable with examples — WHY: Req 4.1 carry-forward from v1; omitting WHY-comments is a defect
- Phase 4 (Stale Detection): implemented `stale_after_hours` check with continue/reset options — WHY: Req 4.1; interrupted sessions need explicit user confirmation before resuming
- Phase 6 (Work Log): append-only zone instruction with cross-agent memory note — WHY: the ticket file is the only persistent state across sessions; destroying history breaks forensics
- Phase 8 (Move to Review): targets `06-in-review/` (not v1's `04-in-review/`) — WHY: Req 3.2 path alignment
- Consecutive Failure Escalation section: `consecutive_failures >= 2` warns, `>= 3` sends desktop notification and escalation block — WHY: Req 4.1 carry-forward; recurring same-gap failures need escalation before another failed attempt

**All 10 ACs verified passing** via grep checks before moving to in-review.

**No out-of-scope work discovered.** No new tickets spawned.
