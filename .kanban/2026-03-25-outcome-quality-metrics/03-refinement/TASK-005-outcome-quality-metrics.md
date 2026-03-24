---
id: "2026-03-25-outcome-quality-metrics/TASK-005"
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
  - "Req 1.2 — PR Responses section in quality envelope schema"
  - "Req 5.1 — append PR Responses entry in p5-fail.md after consecutive_failures increment"
  - "Req 5.2 — cycle number = consecutive_failures value after increment"
  - "Req 5.3 — create quality envelope if it does not exist"
acceptance_criteria:
  - "Grep for 'PR Responses' in skills/implement/commands/review/p5-fail.md returns at least one match"
  - "Grep for '00-quality' in skills/implement/commands/review/p5-fail.md returns at least one match"
  - "Grep for 'consecutive_failures' in skills/implement/commands/review/p5-fail.md returns at least one match (cycle number sourced from this field)"
  - "Grep for 'Criteria' in skills/implement/commands/review/p5-fail.md returns at least one match (failed criteria logged in the entry)"
  - "The PR Responses write instruction in p5-fail.md appears after the consecutive_failures increment instruction"
  - "Grep for 'create.*if.*not exist\\|does not exist' in skills/implement/commands/review/p5-fail.md returns at least one match (file creation fallback documented)"
consecutive_failures: 0
---

## Context

Modifies `skills/implement/commands/review/p5-fail.md` to append a `## PR Responses` entry to the subject's quality envelope each time a ticket is returned for rework (plan §5). The entry records the ticket ID, date, cycle number (from `consecutive_failures` after increment), and the failed review criteria. The quality envelope is created if it does not exist (e.g. if the subject skipped the interview phase).

## Acceptance Criteria

- Grep for `PR Responses` in `skills/implement/commands/review/p5-fail.md` returns at least one match
- Grep for `00-quality` in `skills/implement/commands/review/p5-fail.md` returns at least one match
- Grep for `consecutive_failures` in `skills/implement/commands/review/p5-fail.md` returns at least one match (cycle number sourced from this field)
- Grep for `Criteria` in `skills/implement/commands/review/p5-fail.md` returns at least one match (failed criteria logged in the entry)
- The PR Responses write instruction in `p5-fail.md` appears after the `consecutive_failures` increment instruction
- Grep for `create.*if.*not exist` or `does not exist` in `skills/implement/commands/review/p5-fail.md` returns at least one match (file creation fallback documented)

<!-- Everything below this line is append-only and chronological -->
