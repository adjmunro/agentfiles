---
id: "260321-unified-pipeline/TASK-001"
subject: "260321-unified-pipeline"
plan: "../../01-plan/260321-unified-pipeline/plan-unified-pipeline.md"
effort: low
status: todo
created_at: "2026-03-22T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on: []
spawned_tickets: []
plan_items:
  - "All requirements — TDD red phase establishes baseline before any implementation"
acceptance_criteria:
  - "grep -rq 'skills/ideation' /Users/adjmunro/Developer/agentfiles/skills/ 2>/dev/null; [ $? -ne 0 ] — skills/ideation/ does not exist yet (exit non-zero = not found = pass)"
  - "grep -rq 'skills/kanban2' /Users/adjmunro/Developer/agentfiles/skills/ 2>/dev/null; [ $? -ne 0 ] — skills/kanban2/ does not exist yet"
  - "File .kanban/01-plan/260321-unified-pipeline/review-unified-pipeline.md exists with >= 15 grep-verifiable AC items covering both ideation and kanban2 deliverables"
consecutive_failures: 0
---

## Context

TDD red phase for 260321-unified-pipeline. Neither `skills/ideation/` nor `skills/kanban2/` exist yet. This ticket confirms the baseline (zero implementation) and writes a review checklist used during `/kanban-review` to verify TASK-002 through TASK-015.

## Acceptance Criteria

- `[ ! -d skills/ideation ]` — skills/ideation/ does not exist (exits 0 when dir absent)
- `[ ! -d skills/kanban2 ]` — skills/kanban2/ does not exist (exits 0 when dir absent)
- `.kanban/01-plan/260321-unified-pipeline/review-unified-pipeline.md` exists and contains at minimum 15 grep-verifiable items covering:
  - ideation scaffold files (AGENTS.md, SKILL.md, VERSION.md, CHANGELOG.md)
  - ideation commands (ideate.md, capture.md, research.md, interview.md, plan.md, tickets.md)
  - kanban2 scaffold files
  - kanban2 commands (init.md, work.md, review.md, pr.md, cleanup.md, next.md)

---
<!-- Everything below this line is append-only and chronological -->
