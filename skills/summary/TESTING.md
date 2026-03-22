# Testing — Summary

## Strategy

Run the skill against the agentfiles repo itself — it has a real git history and a `.kanban/` directory, making it an ideal target without needing a synthetic environment. Each mode is tested in isolation. The "no commits since ref" and "open kanban work" scenarios require specific repo state, noted in the setup steps below.

## Environment Setup

1. The target repository is: `/Users/adjmunro/Developer/agentfiles/`
2. Verify the repo has at least 3 commits on the current branch before starting (check `git log --oneline -5`).
3. For the `ref` mode scenario, record a commit SHA from `git log --oneline` that is at least 2 commits back — use this as `<ref>` in the test.
4. For the "no commits since ref" scenario, use the SHA of the most recent commit (HEAD) — running `/summary <HEAD-SHA>` should produce a graceful empty-state message.
5. For the "open kanban work" scenario: if `.kanban/` has no in-progress tickets, create a temporary ticket file at `.kanban/2026-01-01-test/05-in-progress/TASK-TEST-001.md` with minimal content. Remove it after the test.
6. For `pr` mode, it is safe to run against any branch — no PR is created, it only changes output framing.

## Core Scenarios

| Scenario | Input | Expected Outcome | Status |
|----------|-------|-----------------|--------|
| Default mode — branch summary | `/summary` on `main` with ≥3 commits | Output contains Context, Changes by area, New & changed features, Why, and Open work sections in order | Untested |
| `pr` mode — PR-framed output | `/summary pr` | Same content as default but framed for PR review; language and structure appropriate for a reviewer reading it | Untested |
| `trunk` mode — divergence from main | `/summary trunk` on a branch that has diverged from `main` | Shows only changes since divergence point; does not include commits from `main` that post-date the branch | Untested |
| `ref` mode — changes since SHA | `/summary <ref>` using a known SHA | Shows all changes introduced after that specific commit; matches `git log <ref>..HEAD` range | Untested |
| No commits since ref — graceful empty state | `/summary <HEAD-SHA>` | Produces a clear "nothing to summarise" or equivalent message; does not error or produce a malformed report | Untested |
| Open kanban work — appears in report | `.kanban/` has an in-progress ticket; run `/summary` | Open Work section lists the in-progress ticket; not silently omitted | Untested |

## Command Coverage

| Command file | Covered by scenario |
|--------------|---------------------|
| `commands/summary.md` — default mode | Default mode |
| `commands/summary.md` — pr mode | `pr` mode |
| `commands/summary.md` — trunk mode | `trunk` mode |
| `commands/summary.md` — ref mode | `ref` mode |
| `commands/summary.md` — empty state handling | No commits since ref |
| `commands/summary.md` — kanban integration | Open kanban work |

## Known Issues

_(None recorded yet — append as issues are found and fixed.)_

## Refinement Log

_(Empty — append after each test run with what was learned, what changed, and the date.)_
