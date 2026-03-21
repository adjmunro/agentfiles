---
id: "260321-date-format/TASK-004"
subject: "260321-date-format"
plan: "../../01-plan/260321-date-format/plan-date-format.md"
effort: medium
status: done
created_at: "2026-03-21T00:00:00Z"
claimed_at: "2026-03-21T22:50:00Z"
completed_at: "2026-03-21T23:00:00Z"
stale_after_hours: 4
depends_on:
  - "TASK-001"
spawned_tickets: []
plan_items:
  - "Req 4.1 — Replace YYMMDD in all 9 command files"
  - "Req 4.2 — Replace date +%y%m%d with date +%Y-%m-%d"
  - "Req 4.3 — Update example slugs in command files"
  - "Req 6.1 — Update commit message templates in command files"
acceptance_criteria:
  - "grep -r 'YYMMDD' skills/kanban/commands/ returns no matches"
  - "grep -r 'date +%y%m%d' skills/kanban/commands/ returns no matches"
  - "grep -r 'date +%Y-%m-%d' skills/kanban/commands/ returns matches in capture.md, plan.md, and init.md"
  - "All 9 command files updated: capture.md, plan.md, todo.md, work.md, review.md, pr.md, cleanup.md, next.md, init.md"
  - "Commit message template examples in command files use YYYY-MM-DD-<subject> format"
  - "All example subject slugs in command files use YYYY-MM-DD- prefix"
consecutive_failures: 0
---

## Context

Update all 9 command files under `skills/kanban/commands/` to replace `YYMMDD` with `YYYY-MM-DD` throughout — in phase instructions, bash command examples, commit message templates, and subject derivation steps. Also fix the `date` command template from `date +%y%m%d` to `date +%Y-%m-%d` in the three files that use it (capture.md, plan.md, init.md).

This ticket is independent of the directory rename (TASK-002) and can run in parallel.

Traced to: Req 4.1, 4.2, 4.3, 6.1.

## Acceptance Criteria

- `grep -r 'YYMMDD' skills/kanban/commands/` returns no matches
- `grep -r 'date +%y%m%d' skills/kanban/commands/` returns no matches
- All 9 command files touched
- Commit message templates and example slugs use YYYY-MM-DD format

---
<!-- Everything below this line is append-only and chronological -->

## Work Log — 2026-03-21T23:00:00Z

All 9 command files under `skills/kanban/commands/` updated to replace `YYMMDD` with `YYYY-MM-DD` throughout.

**Changes made:**

- `capture.md` — argument-hint, `$ARGUMENTS` match pattern, date prefix text + `date +%y%m%d` → `date +%Y-%m-%d`, directory path templates, file content template (`# YYMMDD-<subject>` and `## Session YYMMDD-HH:MM`), commit message template. 9 occurrences.
- `plan.md` — argument-hint, subject derivation slug, `$ARGUMENTS` match pattern, last-resort prefix, date prefix text + `date +%y%m%d` → `date +%Y-%m-%d`, directory path templates (input and plan files), two commit message templates, `kanban-todo` handoff invocation, discard path. 13 occurrences.
- `todo.md` — argument-hint, subject slug label, `$ARGUMENTS` match pattern, all path templates (plan, research), research header, 3 commit message templates, ticket proposal block, ticket frontmatter schema (id/subject/plan), subject-strip note. 16 occurrences.
- `work.md` — argument-hint, 3 DO/DO NOT path references, `$ARGUMENTS` match pattern, dependency check paths (2), claim-ticket path (2), commit message template, spawned-ticket path, complete-ticket path (2), frontmatter schema (3 fields). 12 occurrences.
- `review.md` — argument-hint, `$ARGUMENTS` match pattern, PASS/FAIL move paths (2), all-tickets-passed announcement. 5 occurrences.
- `pr.md` — argument-hint, 3 precondition paths, skip-PR commit message, Derive Subject description, plan/tickets read paths (2), PR body path, draft-PR commit message, 2 ticket-creation paths, 2 feedback commit messages, notification message, terminal block. 15 occurrences.
- `cleanup.md` — all 23 occurrences replaced via `replace_all` on the `YYMMDD-<subject>` pattern, plus the `[YYMMDD-subject]` argument description.
- `next.md` — argument-hint, diagram path label, subject format description, 10 occurrences of `YYMMDD-<subject>` in body prose, escalation block, progress summary.
- `init.md` — argument-hint, `$ARGUMENTS` match pattern, date prefix text + `date +%y%m%d` → `date +%Y-%m-%d`, final pattern note, directory path templates (2), stub description prose, stub file path, stub content header, commit message template. 10 occurrences.

**Verification:** `grep -r 'YYMMDD\|date +%y%m%d' skills/kanban/commands/` returns no matches.

All ACs satisfied: Req 4.1, 4.2, 4.3, 6.1.

## Review — 2026-03-22T00:00:00Z — PASS 100%

| AC | Result | Evidence |
|---|---|---|
| 1. `grep -r 'YYMMDD' skills/kanban/commands/` returns no matches | PASS | No matches found |
| 2. `grep -r 'date +%y%m%d' skills/kanban/commands/` returns no matches | PASS | No matches found |
| 3. `date +%Y-%m-%d` matches in capture.md, plan.md, init.md only | PASS | Exactly those 3 files matched |
| 4. All 9 command files contain YYYY-MM-DD | PASS | All 9 files confirmed via grep files_with_matches |
| 5. Commit message templates use YYYY-MM-DD-`<subject>` format | PASS | Spot-checked cleanup.md, init.md, plan.md, capture.md, todo.md, work.md, pr.md |
| 6. Example subject slugs use YYYY-MM-DD- prefix | PASS | Confirmed across all 9 files |

Score: 6/6 = **100%** — threshold met (≥95%).

Reviewers: Echo (Examiner) + Arden (Critic)
