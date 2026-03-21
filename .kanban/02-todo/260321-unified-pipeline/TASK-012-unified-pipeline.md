---
id: "260321-unified-pipeline/TASK-012"
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
  - "Req 3.2 — review mirrors kanban v1's review→pr pipeline adapted for new directory structure"
  - "Req 4.1 — critic audit gate: 95% threshold, auto-fix all gaps, append audit block"
  - "Req 4.1 — acceptance criteria are the testing plan — empirically verifiable"
  - "Req 4.1 — git commits after each phase"
acceptance_criteria:
  - "[ -f skills/kanban2/commands/review.md ] — file exists"
  - "grep -q 'model:' skills/kanban2/commands/review.md — frontmatter has model field"
  - "grep -q 'allowed-tools:' skills/kanban2/commands/review.md — frontmatter has allowed-tools"
  - "grep -qi '06-in-review' skills/kanban2/commands/review.md — picks up from 06-in-review/ (not v1 04-in-review/)"
  - "grep -qi '07-pull-request\\|pull.request' skills/kanban2/commands/review.md — moves PASS ticket to 07-pull-request/"
  - "grep -qi '05-in-progress' skills/kanban2/commands/review.md — moves FAIL ticket back to 05-in-progress/"
  - "grep -qi '95' skills/kanban2/commands/review.md — 95% audit threshold documented"
  - "grep -qi 'acceptance.criteria\\|AC' skills/kanban2/commands/review.md — AC verification against ticket"
  - "grep -qi 'git' skills/kanban2/commands/review.md — git commit step present"
consecutive_failures: 0
---

## Context

Writes `skills/kanban2/commands/review.md` — the review command for kanban2. Adapts v1's `review.md` (Examiner + Critic personas) for the new subject-centric directory structure. Key path changes:
- Review source: `YYYY-MM-DD-{subject}/06-in-review/` (was v1 `04-in-review/`)
- PASS → moves to `YYYY-MM-DD-{subject}/07-pull-request/` (was v1 `05-pull-request/`)
- FAIL → moves back to `YYYY-MM-DD-{subject}/05-in-progress/` (was v1 `03-in-progress/`)

Critic audit gate: 95% threshold, auto-fix gaps, append structured audit block. Maps evidence to acceptance criteria from the ticket file.

Command model: `claude-sonnet-4-6` (standard review work).

## Acceptance Criteria

- `skills/kanban2/commands/review.md` exists with valid frontmatter
- Picks up tickets from `06-in-review/` (not v1's `04-in-review/`)
- PASS path: ticket moves to `07-pull-request/`
- FAIL path: ticket moves back to `05-in-progress/`
- 95% audit threshold documented
- AC evidence-mapping present
- Git commit step present

---
<!-- Everything below this line is append-only and chronological -->
