# Testing — Ideation

## Strategy

Spin up a fresh git repository in `/tmp/ideation-test/` and drive the full 9-step flow with a lightweight test idea, verifying directory structure, file creation, and state-machine transitions at each step. Boundary cases (loop-back, abandon, mid-session resume, multi-subject) each require their own sub-scenario.

## Environment Setup

1. Create and initialise a git repository:
   ```
   /tmp/ideation-test/
   ```
2. Ensure the repository has at least one commit so git state is valid.
3. No `.kanban/` directory should exist before the first scenario begins — verify this before each scenario.
4. For the resume scenario, manually create a partial `.kanban/` state:
   - `YYYY-MM-DD-test-idea/00-input-test-idea.md` — any content
   - Do NOT create `02-plan-test-idea.md`
5. For the multi-subject scenario, pre-populate two subject directories, each with their own `00-input-*.md`.

## Core Scenarios

| Scenario | Input | Expected Outcome | Status |
|----------|-------|-----------------|--------|
| Happy path — full 9 steps | Invoke `/ideate`, provide a simple idea (e.g. "a CLI tool that counts words"), answer interview questions, approve the plan, approve tickets, choose "backlog" at step 9 | All 9 steps complete; tickets appear in `04-todo/`; ideation phase files (`00-input-*`, `01-research-*`, `02-plan-*`) are present and read-only from implement's perspective | Untested |
| Step 6 loop-back — "add more" | At step 6 validation, respond "add more" | Skill returns to step 1 (capture) and appends to the same subject directory; does not create a new subject | Untested |
| Abandon at step 9 | At step 9, choose "abandon" | All subject files and directories under `.kanban/YYYY-MM-DD-{subject}/` are deleted; no tickets remain | Untested |
| Resume mid-session | `.kanban/` exists with `00-input-*.md` but no `02-plan-*.md` | Skill detects existing state, picks up at step 4 (Write Plan) rather than restarting from step 1 | Untested |
| Multiple subjects — correct subject targeted | Two subject directories exist; invoke `/ideate` | Skill operates on the correct subject (most recent or explicitly selected) without touching the other | Untested |
| Research step produces file | Happy path, step 2 | `01-research-{subject}.md` is created and contains content before the interview begins | Untested |
| Ticket audit gate — auto-fix | At step 8, a ticket is below the 95% audit threshold | Skill auto-fixes the gap without user intervention and re-scores before moving to step 9 | Untested |

## Command Coverage

| Command file | Covered by scenario |
|--------------|---------------------|
| `commands/capture.md` (step 1) | Happy path, Loop-back |
| `commands/research.md` (step 2) | Happy path — research step |
| `commands/interview.md` (step 3) | Happy path |
| `commands/plan.md` — write (step 4) | Happy path, Resume mid-session |
| `commands/plan.md` — audit gate (step 5) | Happy path |
| `commands/plan.md` — validation (step 6) | Loop-back, Happy path |
| `commands/tickets.md` — write (step 7) | Happy path |
| `commands/tickets.md` — audit gate (step 8) | Ticket audit gate — auto-fix |
| `commands/tickets.md` — promotion (step 9, backlog) | Happy path |
| `commands/tickets.md` — promotion (step 9, abandon) | Abandon at step 9 |

## Known Issues

_(None recorded yet — append as issues are found and fixed.)_

## Refinement Log

_(Empty — append after each test run with what was learned, what changed, and the date.)_
