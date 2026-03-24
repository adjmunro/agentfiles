---
id: "2026-03-25-outcome-quality-metrics/TASK-003"
subject: "2026-03-25-outcome-quality-metrics"
plan: "../02-plan-outcome-quality-metrics.md"
effort: medium
status: todo
created_at: "2026-03-25T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-001"
spawned_tickets: []
plan_items:
  - "Req 1.2 — Plan Drift and Subject Summary sections in quality envelope schema"
  - "Req 1.4 — quality envelope survives to archive"
  - "Req 3.1 — measure plan drift in cleanup.md Phase 6 after archive move"
  - "Req 3.2 — git log to find first plan commit, git diff to measure change"
  - "Req 3.3 — classify drift as None / Minor / Moderate / Significant"
  - "Req 3.4 — append Plan Drift section to quality envelope"
acceptance_criteria:
  - "Grep for 'Plan Drift' in skills/implement/commands/cleanup.md returns at least one match"
  - "Grep for 'git log.*02-plan\\|git diff.*02-plan' in skills/implement/commands/cleanup.md returns at least one match"
  - "Grep for 'None.*Minor.*Moderate\\|Significant' in skills/implement/commands/cleanup.md returns at least one match (drift magnitude classifications present)"
  - "Grep for 'Subject Summary' in skills/implement/commands/cleanup.md returns at least one match"
  - "Grep for '00-quality' in skills/implement/commands/cleanup.md returns at least one match"
  - "Grep for 'unavailable.*no git history\\|git.*not available' in skills/implement/commands/cleanup.md returns at least one match (graceful fallback documented)"
  - "Grep for 'archive' in skills/implement/commands/cleanup.md includes instruction to move quality envelope alongside other subject files (00-quality-{subject}.md included in archive move)"
consecutive_failures: 0
---

## Context

Modifies `skills/implement/commands/cleanup.md` Phase 6 to add plan drift measurement and subject summary writing (plan §3). After the archive move, uses `git log --follow --diff-filter=A` to find the plan file's first commit, then `git diff {first_commit} HEAD` to measure how much the plan changed. Classifies drift magnitude (None/Minor/Moderate/Significant) and appends to `## Plan Drift` in the subject's quality envelope. Also appends a final `## Subject Summary` block aggregating all quality signals.

The quality envelope file must be included in the archive move so it survives at `.kanban/.archive/{subject}/00-quality-{subject}.md` (plan §1.4).

## Acceptance Criteria

- Grep for `Plan Drift` in `skills/implement/commands/cleanup.md` returns at least one match
- Grep for `git log.*02-plan` or `git diff.*02-plan` in `skills/implement/commands/cleanup.md` returns at least one match
- Grep for `None` and `Minor` and `Moderate` and `Significant` in `skills/implement/commands/cleanup.md` each return at least one match (drift magnitude classifications present)
- Grep for `Subject Summary` in `skills/implement/commands/cleanup.md` returns at least one match
- Grep for `00-quality` in `skills/implement/commands/cleanup.md` returns at least one match
- Grep for `unavailable` or `no git history` in `skills/implement/commands/cleanup.md` returns at least one match (graceful fallback for missing git history)
- The archive move instruction in `skills/implement/commands/cleanup.md` explicitly includes `00-quality-{subject}.md`

<!-- Everything below this line is append-only and chronological -->
