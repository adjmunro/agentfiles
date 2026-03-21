# Review Checklist: 260321-command-handoff

Grep-verifiable acceptance criteria for TASK-002 through TASK-005.

## Capture Handoff (TASK-002)

- [ ] `grep -c 'Phase 9' skills/kanban/commands/capture.md` returns ≥ 1 (Phase 9 heading exists)
- [ ] `grep -c 'Phase 10' skills/kanban/commands/capture.md` returns ≥ 1 (Phase 10 renumbered report heading exists)
- [ ] `grep -c '(Recommended)' skills/kanban/commands/capture.md` returns ≥ 1 (Recommended label present in capture handoff)

## Plan Handoff (TASK-003)

- [ ] `grep -c 'Phase 10' skills/kanban/commands/plan.md` returns ≥ 1 (Phase 10 heading exists)
- [ ] `grep -c 'Phase 11' skills/kanban/commands/plan.md` returns ≥ 1 (Phase 11 renumbered report heading exists)
- [ ] `grep -c '(Recommended)' skills/kanban/commands/plan.md` returns ≥ 1 (Recommended label present in plan handoff)

## Session Boundary & Todo Whitelist (TASK-005)

- [ ] `grep -c 'from-plan-handoff' skills/kanban/commands/todo.md` returns ≥ 1 (from-plan-handoff whitelist present)

## Discard Guard (TASK-004)

- [ ] `grep -c 'Discard' skills/kanban/commands/plan.md` returns ≥ 1 (Discard option present in plan handoff)
- [ ] `grep -c '02-todo' skills/kanban/commands/plan.md` returns ≥ 1 (scan of 02-todo documented for discard guard)
- [ ] `grep -c 'subject slug' skills/kanban/commands/plan.md` returns ≥ 1 (subject slug confirmation documented)
