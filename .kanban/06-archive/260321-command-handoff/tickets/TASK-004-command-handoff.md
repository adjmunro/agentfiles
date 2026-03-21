---
id: "260321-command-handoff/TASK-004"
subject: "260321-command-handoff"
plan: "../../01-plan/260321-command-handoff/plan-command-handoff.md"
effort: medium
status: done
created_at: "2026-03-21T00:00:00Z"
claimed_at: "2026-03-21T00:00:00Z"
completed_at: "2026-03-21T00:00:00Z"
stale_after_hours: 4
depends_on:
  - "TASK-003"
spawned_tickets: []
plan_items:
  - "Req 4.1 — discard scans .kanban/02-todo through .kanban/06-archive for subject match"
  - "Req 4.2 — blocked if tickets found; describe problem; require manual intervention or explicit instruction"
  - "Req 4.3 — if clear: require user to type exact subject slug to confirm"
  - "Req 4.4 — on confirmed: remove all files under .kanban/01-plan/YYMMDD-<subject>/"
acceptance_criteria:
  - "grep -c 'Discard' skills/kanban/commands/plan.md returns >= 2 (option mention + detailed instructions)"
  - "grep -c '02-todo\\|03-in-progress\\|04-in-review\\|05-pull-request\\|06-archive' skills/kanban/commands/plan.md returns >= 1 (scan directories documented)"
  - "grep -c 'subject slug' skills/kanban/commands/plan.md returns >= 1 (slug confirmation requirement documented)"
  - "grep -c 'manually\\|manually intervene\\|explicit' skills/kanban/commands/plan.md returns >= 1 (manual override requirement documented)"
  - "The Discard instructions in plan.md specify: (1) scan 02-06 for matching tickets, (2) block with description if found, (3) require typing exact subject slug if clear, (4) delete .kanban/01-plan/YYMMDD-<subject>/ on confirmed — all four steps verifiable by reading the file"
consecutive_failures: 0
---

## Context

Implements the full Discard guard behaviour inside the plan.md Phase 10 handoff section (added by TASK-003). TASK-003 stubs the Discard option; this ticket adds the detailed instructions for how the agent must handle it.

The guard has four steps:
1. Pre-flight scan of `.kanban/02-todo/` through `.kanban/06-archive/` for ticket files matching the subject slug
2. If any found: describe which directories contain tickets and how many; stop; tell the user they must manually remove tickets or explicitly instruct the agent to override
3. If none found: present AskUserQuestion (or inline prompt) asking the user to type the exact subject slug to confirm
4. On confirmed: remove `.kanban/01-plan/YYMMDD-<subject>/` and all contents

Traced to plan §4 (all sub-requirements).

## Acceptance Criteria

- The Discard section in `skills/kanban/commands/plan.md` explicitly describes all four guard steps in order
- Step 1 (scan): names all five directories to scan (02-todo through 06-archive)
- Step 2 (block): instructs agent to describe the problem (which directories, how many tickets) and stop without deleting; instructs that user must manually intervene or explicitly tell the agent to override
- Step 3 (confirm): instructs agent to require user to type the exact subject slug (e.g. `260321-command-handoff`); states that yes/no is insufficient
- Step 4 (delete): instructs agent to remove all files under `.kanban/01-plan/YYMMDD-<subject>/`
- `grep -c '02-todo' skills/kanban/commands/plan.md` returns `>= 1`
- `grep -c 'subject slug' skills/kanban/commands/plan.md` returns `>= 1`

---
<!-- Everything below this line is append-only and chronological -->

## Work Log — 2026-03-21T00:00:00Z

Implemented the full four-step Discard guard in `skills/kanban/commands/plan.md` Phase 10 (Handoff), replacing the TASK-004 placeholder stub.

**Changes made:**
- Replaced stub comment and temporary fallback message with complete guard instructions
- Step 1: Scan `.kanban/02-todo/` through `.kanban/06-archive/` for files matching the subject slug (by filename or `subject:` frontmatter)
- Step 2: Block with descriptive error if matching tickets found — lists which directories and how many; requires manual removal or explicit user override before proceeding
- Step 3: If clear, requires user to type the exact subject slug to confirm (yes/no is explicitly stated as insufficient)
- Step 4: On confirmed slug match, remove all files under `.kanban/01-plan/YYMMDD-<subject>/`

**Acceptance criteria verified:**
- `02-todo`: 2 matches (>= 1) ✓
- `subject slug`: 6 matches (>= 1) ✓
- `manually`: 2 matches (>= 1) ✓
- `Discard`: 3 matches (>= 2) ✓

## Review — 2026-03-21T00:00Z — PASS 100.0%

| AC | Evidence | Status |
|----|----------|--------|
| `grep -c 'Discard' plan.md` >= 2 | Returns 3 (plan.md lines 215, 216, 240) | Satisfied |
| `grep -c '02-todo\|...' plan.md` >= 1 | Returns 2; Step 1 lists all five directories (02-todo through 06-archive) at plan.md:247 | Satisfied |
| `grep -c 'subject slug' plan.md` >= 1 | Returns 6; Steps 3–4 require exact slug, case-sensitive | Satisfied |
| `grep -c 'manually\|...\|explicit' plan.md` >= 1 | Returns 4; Step 2 at plan.md:257 instructs "manually remove" or "explicitly instruct" | Satisfied |
| All four steps verifiable in plan.md | Steps 1–4 at plan.md:243–269 cover all sub-requirements in order: scan 02-06, block+describe+stop, exact slug required, delete 01-plan/YYMMDD-subject/ | Satisfied |

Test results: No test framework detected — skipping test execution.
