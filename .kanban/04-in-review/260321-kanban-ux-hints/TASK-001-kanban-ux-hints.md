---
id: "260321-kanban-ux-hints/TASK-001"
subject: "260321-kanban-ux-hints"
plan: "../../01-plan/260321-kanban-ux-hints/plan-kanban-ux-hints.md"
effort: low
status: in-review
created_at: "2026-03-21T00:00:00Z"
claimed_at: "2026-03-21T00:00:00Z"
completed_at: "2026-03-21T00:00:00Z"
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

## Work Log

### 2026-03-21 — TDD Red Phase Implementation (TASK-001)

**What was done:**
Created `scripts/verify-hints.sh` — a comprehensive verification script that validates the exact end state for the kanban-ux-hints subject. The script:
- Checks for `argument-hint` field presence in SKILL.md
- Validates all 9 command files (init, capture, plan, todo, work, review, pr, cleanup, next)
- Reports PASS/FAIL for each check with clear file identification
- Returns exit code 0 only when all 10 checks pass, non-zero otherwise

**Why this structure:**
The script implements TDD red-phase verification. It defines the boundary between "done" (all fields present and non-empty) and "not done" (any missing/empty hint). Each check uses a regex pattern (`^argument-hint: *[^ ~]`) to detect both presence and non-emptiness, avoiding false positives from `~` (YAML null) or whitespace-only values. The script runs all checks before failing, providing complete diagnostics rather than stopping at the first failure.

**Current state:**
Script is RED as expected:
- SKILL.md: FAIL (missing argument-hint)
- All 9 commands: PASS (already have argument-hint)
- Exit code: 1

This is correct behavior for red-phase TDD. TASK-002 will add the argument-hint field to SKILL.md, and TASK-003 will audit/improve the 9 command hints. Once both complete, this script will return exit code 0.
