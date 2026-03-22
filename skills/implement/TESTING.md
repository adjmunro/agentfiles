# Testing — Implement

## Strategy

Spin up a fresh git repository in `/tmp/implement-test/` with a pre-populated `.kanban/` structure and a sample ticket in `04-todo/`, then exercise each subcommand in sequence to verify state transitions, pass/fail routing, and archive behaviour. The PR bypass path requires a repository with no GitHub remote configured.

## Environment Setup

1. Create and initialise a git repository at `/tmp/implement-test/`.
2. Create a `.kanban/` structure with a single subject:
   ```
   .kanban/
   └── 2026-01-01-test-subject/
       ├── 04-todo/
       │   └── TASK-001-test-subject.md   ← sample ticket with acceptance criteria
       ├── 05-in-progress/
       ├── 06-in-review/
       ├── 07-pull-request/
       └── 08-done/
   ```
3. `TASK-001-test-subject.md` should have a minimal frontmatter block, a Description field, and two Acceptance Criteria — one trivially satisfiable, one requiring a file edit.
4. For the PR bypass scenario, ensure the repository has no `origin` remote configured.
5. For the stale detection scenario, modify the ticket file externally (change a field) after `work` has claimed it but before `review` runs.

## Core Scenarios

| Scenario | Input | Expected Outcome | Status |
|----------|-------|-----------------|--------|
| Happy path — work → review → pr → cleanup | `TASK-001` in `04-todo/`; run `work`, then `review`, then `pr`, then `cleanup` | Ticket progresses: `04-todo/` → `05-in-progress/` → `06-in-review/` → `07-pull-request/` → `08-done/` → `.kanban/.archive/` | Untested |
| Review fail — ticket sent back | Ticket in `05-in-progress/` with unsatisfied AC; run `review` | Ticket remains in `05-in-progress/`; review report records FAIL with unmet criteria listed | Untested |
| PR bypass — no GitHub remote | Ticket in `06-in-review/`; no `origin` remote; run `pr` | Ticket moves directly to `08-done/` without attempting `gh pr create` | Untested |
| `next` command — picks first ticket | Two tickets in `04-todo/`; run `next` | First ticket (alphabetically or by creation order) is claimed and moved to `05-in-progress/` | Untested |
| `cleanup` — runs when `08-done/` has tickets | Ticket in `08-done/`; run `cleanup` | Ticket is archived to `.kanban/.archive/{subject}/08-done/`; cleanup report is produced | Untested |
| `cleanup` — skips when `08-done/` is empty | No tickets in `08-done/`; run `cleanup` | Cleanup reports nothing to archive and exits cleanly without error | Untested |
| Stale detection — external modification | Ticket in `05-in-progress/`; file modified externally; run `review` | Warning is raised about external modification before review proceeds | Untested |

## Command Coverage

| Command file | Covered by scenario |
|--------------|---------------------|
| `commands/work.md` | Happy path, Stale detection |
| `commands/work/p1-session-check.md` | Happy path |
| `commands/work/p4-stale-detection.md` | Stale detection |
| `commands/work/p5-scope-enforcement.md` | Happy path |
| `commands/work/p6-work-log.md` | Happy path |
| `commands/work/p7-commit.md` | Happy path |
| `commands/work/p8-move-to-review.md` | Happy path |
| `commands/review.md` | Happy path, Review fail |
| `commands/review/p2a-examiner.md` | Happy path, Review fail |
| `commands/review/p2b-tests.md` | Happy path (if test framework detected) |
| `commands/review/p2c-documentation.md` | Happy path (if AC involves docs) |
| `commands/review/p3-score.md` | Happy path, Review fail |
| `commands/review/p4-pass.md` | Happy path |
| `commands/review/p5-fail.md` | Review fail |
| `commands/review/p6-report.md` | Happy path, Review fail |
| `commands/pr.md` | Happy path, PR bypass |
| `commands/cleanup.md` | `cleanup` runs, `cleanup` skips |
| `commands/next.md` | `next` command |

## Known Issues

_(None recorded yet — append as issues are found and fixed.)_

## Refinement Log

_(Empty — append after each test run with what was learned, what changed, and the date.)_
