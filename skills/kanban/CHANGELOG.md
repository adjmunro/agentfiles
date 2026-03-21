# Changelog

What's new, what's better, what's different. Most recent stuff on top.

---

## 1.0.3 — The Audit Gap (2026-03-21)

Four coverage gaps found by auditing the implementation against the original plan. All fixed — the audit now passes at ≥95%.

- Added `assets/` directory to `SKILL.md` diagram, `init.md` Phase 4 creation steps, keeping the spec faithful
- Replaced `review.md`'s two-line routing note with a proper ASCII branching diagram showing PASS/FAIL destinations and side effects
- Made Scout's low-tier model mapping explicit in `todo.md` Phase 1 (was implicit, now states haiku/fast)
- Added `Critic in this phase — DO NOT` constraint blocks to `todo.md` Phase 4 and `cleanup.md` Phase 1

## 1.0.2 — The House Rules (2026-03-21)

Conventional commits, no force push, and scoped versioning are now codified. The kanban skill won't bump its own version for commits that only touch other parts of the repo. Root-level AGENTS.md added so every agent working in this repo knows the rules from the start.

- Added `AGENTS.md` at repo root with conventional commits format and force-push prohibition
- Added `CLAUDE.md` and `GEMINI.md` symlinks at repo root pointing to `AGENTS.md`
- Rewrote `skills/kanban/AGENTS.md`: kanban-specific, conventional commits, scoped versioning rule
- Fixed `VERSION.md` upstream URL (was pointing to non-existent `actions/version.md` path)
- Version bumps now only required when `skills/kanban/` files are part of the commit

## 1.0.1 — The Corrections (2026-03-21)

Three correctness fixes caught by post-implementation review. Nothing structural — just three wrong values that would have caused real bugs.

- Fixed `review.md`: status check now correctly requires `status: local-review`, not the non-existent `status: in-review`
- Fixed `next.md`: dependency satisfaction now requires `status: done` in frontmatter, not just file presence in the target directory
- Fixed `next.md`: removed reference to non-existent `06-blocked/` stage directory — tickets skip back to `02-todo/` instead

## 1.0.0 — The Full Pipeline (2026-03-21)

The whole system is live. Every stage from raw idea to merged PR now has a command behind it — capture, plan, ticket breakdown, implementation, local review, PR advocacy, orchestration, and archive. The kanban skill is no longer a sketch; it's a complete workflow.

- Added `SKILL.md` — the routing entry point that maps all 9 commands and documents the state machine, session design, and directory structure
- All 9 commands are in place: `init`, `capture`, `plan`, `todo`, `work`, `review`, `pr`, `cleanup`, `next`
- Session boundary enforcement: capture/plan sessions and work sessions are hard-separated
- State machine documented with full PASS/FAIL routing and non-GitHub fallback paths

## 0.5.0 — The Examiner and Critic (2026-03-21)

Local review is now a first-class stage. The `/kanban-review` command maps every acceptance criterion to file-level evidence, runs all applicable test suites, scores pass/fail, and routes the ticket — all without touching a line of source code.

- Added `commands/review.md` — the `/kanban-review` command for the local review phase
- Two-role structure: Examiner gathers evidence (read-only), Critic applies the scoring formula and delivers the verdict
- Test framework auto-detection covers Swift, Gradle, npm, Make, pytest, and Go — all matching suites run, not just the first
- PASS path: appends review record, sets `status: done`, moves ticket to `05-pull-request/`, announces when all tickets are ready for PR
- FAIL path: appends prioritised issue list, clears timestamps, increments `consecutive_failures`, returns ticket to `03-in-progress/`
- Same-error escalation fires a desktop notification and prominent terminal block when the identical gap recurs 2–3 times unchanged

## 0.4.0 — The Builder Arrives (2026-03-21)

The `work` command lands. Claim a ticket, implement it with rigorous WHY-comments and per-unit commits, then hand it off to local review — all in one self-contained agent session.

- Added `commands/work.md` — the Builder phase covering claim → implement → log → complete
- Ticket dependency resolution: skips blocked tickets, respects `depends_on` ordering
- WHY-comments in all code changes are a hard requirement enforced at the command level
- Out-of-scope work discovered during implementation spawns new tickets rather than bloating the current one
- Subagent tier selection driven by ticket `effort` field (low/medium/high → haiku/sonnet/opus)

## 0.3.0 — The Ticket Writer (2026-03-21)

The kanban skill can now break a verified plan into actionable tickets. Scout researches the codebase first, then the Critic checks that every plan requirement got covered before calling it done.

- Added `commands/todo.md` — the `/kanban-todo` command for the todo-breakdown phase
- Scout subagent maps the codebase and writes a research snapshot before any tickets are created
- TASK-001 is always the TDD red phase — no exceptions baked into the prompt
- User confirms the full ticket list before any files are written
- Critic audit gate enforces 95% plan coverage and auto-fixes gaps with new tickets

## 0.2.0 — The Planner (2026-03-21)

The planning command is here. `/kanban-plan` reads your captured input, interviews you on the gaps, drafts a structured plan, and runs a critic audit gate — auto-fixing any coverage holes before signing off.

- Added `commands/plan.md` — the full planning phase command
- Interview phase surfaces tradeoffs, edge cases, failure modes, and acceptance signals before any writing happens
- Critic audit gate scores input→plan coverage at 95% threshold, auto-fixes all gaps, and appends a structured audit section to the plan file
- Two-commit workflow: draft commit after plan is approved, audit commit after gate passes
- Session boundary check prevents running plan while a work session is active for the same subject
