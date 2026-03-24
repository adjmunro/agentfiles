---
id: "2026-03-25-outcome-quality-metrics/TASK-005"
subject: "2026-03-25-outcome-quality-metrics"
plan: "../02-plan-outcome-quality-metrics.md"
effort: low
status: in_review
created_at: "2026-03-25T00:00:00Z"
claimed_at: "2026-03-24T12:02:37Z"
completed_at: "2026-03-24T12:02:37Z"
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

## Work Log — 2026-03-24T12:02:37Z

Implemented Step B2 in `skills/implement/commands/review/p5-fail.md` (Req 5.1, 5.2, 5.3).

**What was done:** Inserted a new Step B2 between the existing Step B (consecutive_failures increment) and Step C (move ticket). Step B2 instructs the reviewer agent to append a `## PR Responses` entry to `.kanban/{subject}/00-quality-{subject}.md` each time a ticket is returned for rework.

**WHY placed between Step B and escalation:** The cycle number is derived from `consecutive_failures` after increment (Req 5.2) — positioning after Step B ensures the correct post-increment value is available. Positioning before the same-error escalation section ensures the quality envelope write happens even if the session is interrupted during escalation handling; the log is a side-effect that must always fire.

**WHY append-only constraint is documented inline:** The quality envelope is shared across multiple phases (interview, work sessions, cleanup). A reviewer modifying an existing entry would corrupt signals that other phases will later aggregate into MX-OQ metrics. The append-only constraint is stated explicitly in Step B2 to prevent accidental overwrites.

**WHY file creation fallback is documented:** Subjects that skip the interview phase never have `00-quality-{subject}.md` created. Without the fallback, Step B2 would silently fail or error on first PR fail, producing a gap in MX-OQ5 data (Req 5.3). The fallback creates the file with only `## PR Responses` — no other sections are pre-created, as each is the responsibility of its own phase (Plan §1.2, §1.3).

All six ACs verified by grep against the modified file before committing.
