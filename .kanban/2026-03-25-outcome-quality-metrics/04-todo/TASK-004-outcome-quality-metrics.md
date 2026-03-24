---
id: "2026-03-25-outcome-quality-metrics/TASK-004"
subject: "2026-03-25-outcome-quality-metrics"
plan: "../02-plan-outcome-quality-metrics.md"
effort: low
status: todo
created_at: "2026-03-25T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-001"
spawned_tickets: []
plan_items:
  - "Req 1.2 — Work Sessions section in quality envelope schema"
  - "Req 4.1 — prompt user with yes / partially / no / skip after ticket move"
  - "Req 4.2 — append Work Sessions entry to quality envelope on yes / partially / no"
  - "Req 4.3 — skip silently on 'skip' or non-matching response"
  - "Req 4.4 — ticket move must complete before prompt appears"
acceptance_criteria:
  - "Grep for 'how did this session go' in skills/implement/commands/work/p8-move-to-review.md returns at least one match"
  - "Grep for 'yes.*partially.*no.*skip\\|partially.*no.*skip' in skills/implement/commands/work/p8-move-to-review.md returns at least one match (all four options present)"
  - "Grep for 'Work Sessions' in skills/implement/commands/work/p8-move-to-review.md returns at least one match"
  - "Grep for '00-quality' in skills/implement/commands/work/p8-move-to-review.md returns at least one match"
  - "The prompt instruction in p8-move-to-review.md appears after the ticket-move instruction, not before (ticket move is non-blocking)"
  - "Grep for 'skip\\|do not re-prompt' in skills/implement/commands/work/p8-move-to-review.md returns at least one match (escape documented)"
consecutive_failures: 0
---

## Context

Modifies `skills/implement/commands/work/p8-move-to-review.md` to add a session-close rating prompt (plan §4). After the ticket has been moved to `06-in-review/`, the agent asks the user a single question: how did this session go? (yes / partially / no / skip). If the user responds with yes, partially, or no, the agent appends a `## Work Sessions` entry to `00-quality-{subject}.md`. If the user responds with skip or anything unrecognised, no write occurs and the agent does not re-prompt.

The rating must not block the ticket move — the move completes first, the prompt is advisory.

## Acceptance Criteria

- Grep for `how did this session go` in `skills/implement/commands/work/p8-move-to-review.md` returns at least one match
- Grep for `yes` and `partially` and `no` and `skip` in `skills/implement/commands/work/p8-move-to-review.md` each return at least one match (all four options present)
- Grep for `Work Sessions` in `skills/implement/commands/work/p8-move-to-review.md` returns at least one match
- Grep for `00-quality` in `skills/implement/commands/work/p8-move-to-review.md` returns at least one match
- The rating prompt instruction in `p8-move-to-review.md` appears after the ticket-move instruction (ticket move is non-blocking)
- Grep for `skip` or `do not re-prompt` in `skills/implement/commands/work/p8-move-to-review.md` returns at least one match (escape hatch documented)

<!-- Everything below this line is append-only and chronological -->
