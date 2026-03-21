## Research: 260321-command-handoff
**Date**: 2026-03-21T00:00:00Z
**Status**: Snapshot — may go stale. Verify before acting.

## Project Structure

Target files (all under `skills/kanban/commands/`):
- `capture.md` — 194 lines; ends at Phase 9 (Report)
- `plan.md` — 213 lines; ends at Phase 10 (Report)
- `todo.md` — 284 lines; Session Boundary section at lines 33–54

Supporting files:
- `skills/kanban/VERSION.md` — current version: 1.1.1
- `skills/kanban/CHANGELOG.md` — newest-on-top convention
- `skills/kanban/personas/` — scout, critic, scribe, strategist etc.

No test runner exists; this is a markdown agent-instruction system. TDD red phase = write behavioral acceptance criteria stubs before any file is modified.

## Relevant Patterns

**AskUserQuestion** is already in `allowed-tools` on all three command files. Existing usage is in interview phases (Phase 4 of capture, Phase 3 of plan) — sequential questions, one at a time. New handoff prompts follow the same pattern: multi-option AskUserQuestion, "(Recommended)" label on the first option.

**Session boundary checks** in capture.md (Phase 1) and plan.md (Phase 1) scan `.kanban/03-in-progress/` and `.kanban/04-in-review/` for tickets with a recent `claimed_at`. They have no current whitelist mechanism.

**todo.md Session Boundary** (lines 33–54): argument resolver at line 37 extracts a `YYMMDD-*` pattern from `$ARGUMENTS`. It does NOT currently scan for active work sessions — it only checks for a verified plan file. The `from-plan-handoff` argument does not match `YYMMDD-*` and will fall through to subsequent resolution steps harmlessly.

**Clean completion signals**:
- `capture.md`: implicit — reaching Phase 8 git commit without hitting a STOP
- `plan.md`: explicit — Phase 8 Critic audit gate blocks on FAIL; reaching Phase 9 git commit implies PASS

## Dependencies

**Insertion points** (where new phases slot in):
- `capture.md`: new Phase 9 (handoff) inserts between existing Phase 8 (git commit) and Phase 9 (report, renumbered to Phase 10)
- `plan.md`: new Phase 10 (handoff) inserts between existing Phase 9 (git commit) and Phase 10 (report, renumbered to Phase 11)

**Argument passing**: `$ARGUMENTS` in todo.md first checks for `YYMMDD-*` match. `from-plan-handoff` does not match; it falls through silently. No code change needed to accept it — it just needs to not break anything (it won't). However, the plan (§3.3) requires an explicit whitelist. Add a check: "if argument contains `from-plan-handoff`, skip session boundary check and proceed to subject resolution."

**Discard sub-feature** lives entirely inside the plan.md handoff phase. It requires:
1. Pre-flight scan of `.kanban/02-todo/` through `.kanban/06-archive/` for subject match
2. Block + describe if tickets found
3. AskUserQuestion requiring exact subject slug to confirm if clear
4. `Bash` `rm -rf .kanban/01-plan/YYMMDD-<subject>/` on confirmed

## Hazards

**No test runner** — acceptance criteria must be observable states (grep for required text in modified files, or behavioral verification by running the command).

**Phase numbering** — both capture and plan need phase numbers renumbered after insertion. Easy to get wrong; check carefully.

**AskUserQuestion max 4 options** — the plan specifies 5 options at end-of-plan. AskUserQuestion enforces a max of 4. The "New" option (todo + new capture) must be folded into freeform or dropped, or "Something else" and "Discard" combined. This was already discovered during the capture session — "New" was omitted from the live prompt. The plan file lists 5 options. Implementor should note: in practice only 4 can be presented; fold "New" into freeform or drop it.

**Freeform "Something else"** — has no special handler. Implementing it means offering it as an option in AskUserQuestion; when selected, the AskUserQuestion "Other" text input is returned as the answer. The agent then handles it as a normal in-context message. No code-path needed beyond presenting the option.

## Recommended Ticket Sequence

1. **TASK-001** — TDD Red Phase: write behavioral AC stubs before any implementation (no deps)
2. **TASK-002** — `capture.md`: add Phase 9 handoff prompt + renumber Phase 9→10 (depends: TASK-001)
3. **TASK-003** — `plan.md`: add Phase 10 handoff prompt + renumber Phase 10→11 (depends: TASK-001; can parallel TASK-002)
4. **TASK-004** — `plan.md` handoff: discard guard — scan, block, slug-confirm, delete (depends: TASK-003)
5. **TASK-005** — `todo.md`: explicit `from-plan-handoff` whitelist in Session Boundary (depends: TASK-003)
6. **TASK-006** — Version bump 1.1.1 → 1.2.0 and CHANGELOG entry (depends: TASK-002, TASK-003, TASK-004, TASK-005)
