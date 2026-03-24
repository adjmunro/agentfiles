---
id: "2026-03-25-outcome-quality-metrics/TASK-002"
subject: "2026-03-25-outcome-quality-metrics"
plan: "../02-plan-outcome-quality-metrics.md"
effort: medium
status: in_progress
created_at: "2026-03-25T00:00:00Z"
claimed_at: "2026-03-24T11:43:20Z"
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-001"
spawned_tickets: []
plan_items:
  - "Req 1.1 — create 00-quality-{subject}.md file type"
  - "Req 1.2 — file schema with Interview Signals section"
  - "Req 1.3 — created on first write by interview.md"
  - "Req 2.1 — classify each recommendation as Approved / Overridden / Rejected"
  - "Req 2.2 — rejection heuristics via backtrack phrases in Phase 4"
  - "Req 2.3 — append Interview Signals block to quality envelope"
  - "Req 2.4 — commit quality envelope alongside interview files"
acceptance_criteria:
  - "Grep for 'Interview Signals' in skills/ideation/commands/interview.md returns at least one match"
  - "Grep for 'Approved' and 'Overridden' and 'Rejected' in skills/ideation/commands/interview.md each return at least one match"
  - "Grep for 'backtrack' or 'Actually' or 'don.*do that' in skills/ideation/commands/interview.md returns at least one match (rejection heuristic documented)"
  - "Grep for '00-quality' in skills/ideation/commands/interview.md returns at least one match"
  - "Grep for 'kanban(interview)' in skills/ideation/commands/interview.md returns at least one match (commit instruction references quality envelope)"
  - "Grep for 'Summary.*approved.*overridden.*rejected' in skills/ideation/commands/interview.md returns at least one match (summary line format present)"
  - "Grep for 'create.*if.*not exist\\|does not exist' in skills/ideation/commands/interview.md returns at least one match (create-on-first-write behaviour documented)"
consecutive_failures: 0
---

## Context

Modifies `skills/ideation/commands/interview.md` to add interview acceptance tracking (plan §2). After recording the user's response in Phase 4, the agent classifies each recommendation item as Approved, Overridden, or Rejected using backtrack-phrase heuristics, then appends an `## Interview Signals` block to a new `00-quality-{subject}.md` quality envelope file. The quality envelope is created on first write. Both files are staged and committed together under the existing `kanban(interview):` commit.

The `## Interview Signals` section is the first of five sections in the quality envelope schema (plan §1.2).

## Acceptance Criteria

- Grep for `Interview Signals` in `skills/ideation/commands/interview.md` returns at least one match
- Grep for `Approved` and `Overridden` and `Rejected` in `skills/ideation/commands/interview.md` each return at least one match
- Grep for `backtrack` or `Actually` or `don.*do that` in `skills/ideation/commands/interview.md` returns at least one match (rejection heuristic documented)
- Grep for `00-quality` in `skills/ideation/commands/interview.md` returns at least one match
- Grep for `kanban(interview)` in `skills/ideation/commands/interview.md` returns at least one match (commit instruction references quality envelope)
- Grep for `Summary.*approved.*overridden.*rejected` in `skills/ideation/commands/interview.md` returns at least one match (summary line format present)
- Grep for `create.*if.*not exist` or `does not exist` in `skills/ideation/commands/interview.md` returns at least one match (create-on-first-write behaviour documented)

<!-- Everything below this line is append-only and chronological -->
