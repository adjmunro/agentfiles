---
id: "260321-kanban-ux-hints/TASK-001"
subject: "260321-kanban-ux-hints"
plan: "../../01-plan/260321-kanban-ux-hints/plan-kanban-ux-hints.md"
effort: low
status: todo
created_at: "2026-03-21T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
spawned_tickets: []
plan_items:
  - "Req 3.1 — verify SKILL.md supports argument-hint after implementation"
  - "Acceptance signals — hint appears AND all frontmatter is correct"
acceptance_criteria:
  - "A file `verify-kanban-ux-hints.sh` exists at the repo root (or `.kanban/`) and is executable"
  - "Running the script before any changes exits non-zero (red) — SKILL.md has no argument-hint"
  - "Script checks: `grep -q 'argument-hint' .claude/skills/kanban/SKILL.md` — fails on current state"
  - "Script checks each of the 9 command files has a non-empty argument-hint field"
  - "Script output clearly identifies which checks pass and which fail"
consecutive_failures: 0
---

## Context

Before touching any files, we need a runnable verification spec that defines the exact expected final state. This is the TDD red phase: the script should fail today (SKILL.md has no argument-hint) and pass once implementation is complete.

The script serves as both a test harness and a living spec — it documents precisely what "done" means for this subject.

## Acceptance Criteria

- `verify-kanban-ux-hints.sh` exists and is executable (`chmod +x`)
- Running it now exits non-zero and prints a failing check for SKILL.md's missing `argument-hint`
- It checks all 10 files: SKILL.md + 9 command files (init, capture, plan, todo, work, review, pr, cleanup, next)
- Each check prints a clear PASS/FAIL line identifying the file
- Overall exit code is 0 only when all checks pass

---
<!-- Everything below this line is append-only and chronological -->
