---
id: "2026-03-25-outcome-quality-metrics/TASK-003"
subject: "2026-03-25-outcome-quality-metrics"
plan: "../02-plan-outcome-quality-metrics.md"
effort: medium
status: in_review
created_at: "2026-03-25T00:00:00Z"
claimed_at: "2026-03-24T11:52:52Z"
completed_at: "2026-03-24T12:05:00Z"
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

## Work Log — 2026-03-24T11:52Z

Modified `skills/implement/commands/cleanup.md` to add plan drift measurement and subject summary writing (satisfies req 1.2, 1.4, 3.1–3.4).

**Phase 4 archive diagram (req 1.4):** Added `00-quality-{subject}.md` explicitly to the expected final state diagram. The `mv` command already carries the whole folder so the file would move automatically, but naming it explicitly prevents any future cleanup step from treating it as orphaned. Added a WHY-comment explaining this.

**Phase 6 renamed** to "Reporting and Quality Envelope" to reflect the expanded scope. The original reporting block (archive facts + metrics) is preserved unchanged — the new sub-phases append after.

**Phase 6a — Plan Drift Measurement (req 3.1–3.4):**
- Uses `git log --follow --diff-filter=A` to find the first commit that created the plan file (req 3.2). `--follow` is required because git tracks renames; `--diff-filter=A` restricts to the creation event, not every modification.
- Uses `git diff {first_commit} HEAD -- .kanban/.archive/{subject}/02-plan-{subject}.md` for the diff (req 3.2). Runs against the archived path post-move so the diff is consistent with HEAD state.
- Excludes the `## Audit` block from the line count (WHY: audit block is always appended at plan→ticket transition, so including it would inflate drift for every subject regardless of genuine plan volatility).
- Magnitude table: None (0 lines), Minor (1–10), Moderate (11–30), Significant (31+) — req 3.3.
- Graceful fallback: if git is unavailable or the command returns no output, writes `Plan drift: unavailable (no git history)` instead of failing — req 3.4 and plan §3 constraint.

**Phase 6b — Subject Summary (req 1.2):**
- Reads all five sections from the quality envelope and aggregates them into a single table row per signal. Chosen as a table rather than prose for machine readability (optimise MX-OQ metrics will parse these envelopes).
- Sections with no data use `—` placeholder — this makes the absence explicit and prevents the optimise skill from mis-reading a missing row as zero rather than "not recorded".
- Commits the quality envelope separately from the archive commit (req 3.4's Step 4 + Phase 6b commit) so the audit trail clearly shows what was measured at what point.

No out-of-scope work was discovered. TASK-003 ACs are fully satisfied.
