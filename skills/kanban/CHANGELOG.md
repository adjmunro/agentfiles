# Changelog

What's new, what's better, what's different. Most recent stuff on top.

---

## v1.2.3 - 2026-03-21 - Right Format

The directory structure diagram in SKILL.md now shows the correct `YYYY-MM-DD-<subject>/` date format instead of the old short-form date prefix.

- Updated the directory structure date prefix to `YYYY-MM-DD-<subject>/` in the SKILL.md directory structure diagram

## v1.2.2 - 2026-03-21 - Both Doors

SKILL.md now documents both PR bypass conditions side by side. A first-time reader can understand when the PR step is skipped, how the trunk-branch protection check works, and what happens when that check fails.

- Added "PR Step Bypass Conditions" section with numbered explanations for both paths
- Non-GitHub bypass preserved and clarified as always-safe
- Trunk bypass documents the fixed branch list, `gh api` protection query, and best-effort caveat
- Feature branches explicitly called out as never subject to the trunk check

## v1.2.1 - 2026-03-21 - Branch Aware

The PR command now checks whether you're on a trunk branch before opening a draft PR. Protected trunks proceed normally; unprotected trunks skip the PR step and route directly to cleanup with an audit-trail commit. If the protection check fails entirely, the command stops and asks rather than assuming.

- Added Precondition Check 3 to `pr.md`: detects trunk branches (`main`, `master`, `develop`, `trunk`) before Phase 1
- Queries `gh api repos/{owner}/{repo}/branches/{branch}/protection` to determine protection status
- Three-way outcome: protected → normal flow; unprotected → skip with audit commit; check failed → stop and ask user

## v1.2.0 - 2026-03-21 - Speak First

Capture starts with your thoughts, not a form. Phase 4 opens with a single framing line and waits for you to write freely before asking any questions. The agent reads what you wrote, then asks targeted clarifying questions informed by what you actually said — no templates, no front-loaded structure.

- Phase 4 now opens with just "What are you working on?" and waits for free-form input
- Agent reads and processes your response before forming any questions
- Clarifying questions are derived from gaps in what you wrote, not from a fixed checklist
- Each question is preceded by the agent's interpretation, recommendation, and reasoning in natural prose
- Question topics (implementation choices, edge cases, constraints, acceptance signals) remain unchanged

## v1.1.4 - 2026-03-21 - The Handoff Shortcut

Capture, plan, and todo now guide you to your next step instead of stopping abruptly. Handoff prompts let you stay in flow — move straight to planning, capture something else, or jump to work. You're always steering, never stuck waiting for the next command.

- Added handoff prompt to `capture.md` Phase 9: enter planning mode, capture again, or do something else (Recommended label steers toward planning)
- Added handoff prompt to `plan.md` Phase 6: start breaking into tickets, capture something else, or move on (Recommended toward todo-breakdown)
- Added whitelist to `todo.md` to filter captured subjects before breaking them into tickets (skip unrelated or completed items)
- Handoff prompts only show on clean completion: no unresolved gaps, successful commit, ready to move forward

## v1.1.3 - 2026-03-21 - The Right Question

ACs should answer "how do I know it's done?" — not "how should it be built?". Added a new rule to `todo.md` that explicitly calls out over-specification: don't put file names, paths, or structural choices in ACs unless they're externally observable constraints. If location or naming matters, it belongs in the plan's Constraints section.

- Added "AC Must Specify Outcomes, Not Implementation" guidance to `todo.md`
- Includes a before/after table with concrete examples
- Notes the escape hatch: if a name/path genuinely matters, put it in the plan as a Constraint

## v1.1.2 - 2026-03-21 - The Handoff

Capture now asks what you want to do next instead of just stopping. After a clean run, you get one prompt: enter planning mode, capture something else, or do something else entirely. The (Recommended) label steers you toward planning without forcing it.

- Added Phase 9 — Handoff to `commands/capture.md`, between git commit and report
- Prompt only shown on clean completion — no unresolved Critic gaps and Phase 8 commit succeeded
- Three options: Enter planning mode (Recommended), Capture something else, Something else (freeform)
- Freeform input is not written back to the input file unless the agent judges it as capture content and the user confirms
- Old Phase 9 (Report) renumbered to Phase 10

## v1.1.1 - 2026-03-21 - The Hint

Added `argument-hint` to the kanban skill's top-level SKILL.md, making all nine subcommands discoverable from the `/kanban` entry point. The hint lists each command in pipeline order so users can see what's available without running the command blind.

- `SKILL.md` now includes `argument-hint: "capture | plan | todo | work | review | pr | cleanup | next | init"` in frontmatter
- Hint format is pipe-separated and ordered by stage in the pipeline for easy visual scanning

## v1.1.0 - 2026-03-21 - The Full Roster

The 5 extended personas are now wired into the commands that need them. Keeper challenges strategy during planning, Artisan reviews design evidence in review, Helm runs the pre-flight checklist before PR promotion, Ward guides Work Log quality during implementation, and Pulse generates metrics on archive.

- `plan.md` — Keeper (Strategist) active during Phase 3 interview alongside Arden
- `review.md` — Artisan (Designer) runs optional Phase 2c for tickets with visual/UX criteria
- `pr.md` — Helm (Release) owns Phase 4 pre-flight checklist before `gh pr ready`
- `work.md` — Ward (Documentation) perspective injected into Phase 6 Work Log guidance
- `cleanup.md` — Pulse (Analytics) generates subject-level metrics in Reporting

## v1.0.7 - 2026-03-21 - The Personalities

The personas got richer. Same roles, same rules — but now each one has a distinct voice, habits, and a characteristic way of being wrong or right. Enough personality to know who's speaking without the name tag.

- Expanded Voice sections across all 11 personas with distinct tones, quirks, and characteristic phrases
- Nothing that changes how they work — just how they feel to work with

## v1.0.6 - 2026-03-21 - The Extended Roster

Five new specialist personas join the team, covering the gaps between capture and archive: product strategy, design quality, release safety, documentation health, and team analytics.

- Keeper (Strategist) — reframes problems before implementation; challenges scope assumptions
- Artisan (Designer) — owns visual and UX quality from design system to pixel polish
- Helm (Release) — final-mile shipping safety; readiness checklist, test verification, clean push
- Ward (Documentation) — keeps docs honest; cross-references diffs, updates stale references
- Pulse (Analytics) — velocity, test health, bottlenecks, and retrospective summaries

## v1.0.5 - 2026-03-21 - The Characters

The six specialist roles now have names and live in their own files. Vela (Scribe), Arden (Critic), Finn (Scout), Kira (Builder), Echo (Examiner), Vale (Advocate) — each with their own identity, voice, and cross-command rules. Commands reference their persona files directly, so personality and duties can be updated in one place.

- Added `personas/` directory with 6 persona files — one per specialist role
- Each persona has a name, purpose, universal DO/DO NOT rules, and a distinct voice
- Command files updated to load their active persona(s) and identify by name in transcripts
- Command-specific DO/DO NOT items remain in command files; universal rules live in personas

## v1.0.4 - 2026-03-21 - The Rename

Three cosmetic-but-important clarifications: the review stage is now `in-review` everywhere (was `local-review`), the state machine in SKILL.md uses real directory names and correctly models the PR feedback loop, and subject placeholders in naming examples now use `<subject>` notation to make clear they're parameters.

- Renamed `04-local-review/` → `04-in-review/` throughout all command files
- Fixed state machine: FAIL routes to `03-in-progress` (not `02-todo`); PR feedback creates new `02-todo` tickets (not a separate stage)
- Subject placeholders in file/path patterns now use `<subject>` notation (e.g. `input-<subject>.md`)

## v1.0.3 - 2026-03-21 - The Audit Gap

Four coverage gaps found by auditing the implementation against the original plan. All fixed — the audit now passes at ≥95%.

- Added `assets/` directory to `SKILL.md` diagram, `init.md` Phase 4 creation steps, keeping the spec faithful
- Replaced `review.md`'s two-line routing note with a proper ASCII branching diagram showing PASS/FAIL destinations and side effects
- Made Scout's low-tier model mapping explicit in `todo.md` Phase 1 (was implicit, now states haiku/fast)
- Added `Critic in this phase — DO NOT` constraint blocks to `todo.md` Phase 4 and `cleanup.md` Phase 1

## v1.0.2 - 2026-03-21 - The House Rules

Conventional commits, no force push, and scoped versioning are now codified. The kanban skill won't bump its own version for commits that only touch other parts of the repo. Root-level AGENTS.md added so every agent working in this repo knows the rules from the start.

- Added `AGENTS.md` at repo root with conventional commits format and force-push prohibition
- Added `CLAUDE.md` and `GEMINI.md` symlinks at repo root pointing to `AGENTS.md`
- Rewrote `skills/kanban/AGENTS.md`: kanban-specific, conventional commits, scoped versioning rule
- Fixed `VERSION.md` upstream URL (was pointing to non-existent `actions/version.md` path)
- Version bumps now only required when `skills/kanban/` files are part of the commit

## v1.0.1 - 2026-03-21 - The Corrections

Three correctness fixes caught by post-implementation review. Nothing structural — just three wrong values that would have caused real bugs.

- Fixed `review.md`: status check now correctly requires `status: local-review`, not the non-existent `status: in-review`
- Fixed `next.md`: dependency satisfaction now requires `status: done` in frontmatter, not just file presence in the target directory
- Fixed `next.md`: removed reference to non-existent `06-blocked/` stage directory — tickets skip back to `02-todo/` instead

## v1.0.0 - 2026-03-21 - The Full Pipeline

The whole system is live. Every stage from raw idea to merged PR now has a command behind it — capture, plan, ticket breakdown, implementation, local review, PR advocacy, orchestration, and archive. The kanban skill is no longer a sketch; it's a complete workflow.

- Added `SKILL.md` — the routing entry point that maps all 9 commands and documents the state machine, session design, and directory structure
- All 9 commands are in place: `init`, `capture`, `plan`, `todo`, `work`, `review`, `pr`, `cleanup`, `next`
- Session boundary enforcement: capture/plan sessions and work sessions are hard-separated
- State machine documented with full PASS/FAIL routing and non-GitHub fallback paths

## v0.5.0 - 2026-03-21 - The Examiner and Critic

Local review is now a first-class stage. The `/kanban-review` command maps every acceptance criterion to file-level evidence, runs all applicable test suites, scores pass/fail, and routes the ticket — all without touching a line of source code.

- Added `commands/review.md` — the `/kanban-review` command for the local review phase
- Two-role structure: Examiner gathers evidence (read-only), Critic applies the scoring formula and delivers the verdict
- Test framework auto-detection covers Swift, Gradle, npm, Make, pytest, and Go — all matching suites run, not just the first
- PASS path: appends review record, sets `status: done`, moves ticket to `05-pull-request/`, announces when all tickets are ready for PR
- FAIL path: appends prioritised issue list, clears timestamps, increments `consecutive_failures`, returns ticket to `03-in-progress/`
- Same-error escalation fires a desktop notification and prominent terminal block when the identical gap recurs 2–3 times unchanged

## v0.4.0 - 2026-03-21 - The Builder Arrives

The `work` command lands. Claim a ticket, implement it with rigorous WHY-comments and per-unit commits, then hand it off to local review — all in one self-contained agent session.

- Added `commands/work.md` — the Builder phase covering claim → implement → log → complete
- Ticket dependency resolution: skips blocked tickets, respects `depends_on` ordering
- WHY-comments in all code changes are a hard requirement enforced at the command level
- Out-of-scope work discovered during implementation spawns new tickets rather than bloating the current one
- Subagent tier selection driven by ticket `effort` field (low/medium/high → haiku/sonnet/opus)

## v0.3.0 - 2026-03-21 - The Ticket Writer

The kanban skill can now break a verified plan into actionable tickets. Scout researches the codebase first, then the Critic checks that every plan requirement got covered before calling it done.

- Added `commands/todo.md` — the `/kanban-todo` command for the todo-breakdown phase
- Scout subagent maps the codebase and writes a research snapshot before any tickets are created
- TASK-001 is always the TDD red phase — no exceptions baked into the prompt
- User confirms the full ticket list before any files are written
- Critic audit gate enforces 95% plan coverage and auto-fixes gaps with new tickets

## v0.2.0 - 2026-03-21 - The Planner

The planning command is here. `/kanban-plan` reads your captured input, interviews you on the gaps, drafts a structured plan, and runs a critic audit gate — auto-fixing any coverage holes before signing off.

- Added `commands/plan.md` — the full planning phase command
- Interview phase surfaces tradeoffs, edge cases, failure modes, and acceptance signals before any writing happens
- Critic audit gate scores input→plan coverage at 95% threshold, auto-fixes all gaps, and appends a structured audit section to the plan file
- Two-commit workflow: draft commit after plan is approved, audit commit after gate passes
- Session boundary check prevents running plan while a work session is active for the same subject

## v0.1.0 - 2026-03-21 - The Foundation

The skeleton is up. You can initialise a kanban board and capture raw ideas into structured input files. Nothing moves tickets yet — that comes next.

- Added `commands/init.md` — sets up the board directory structure and stage folders
- Added `commands/capture.md` — interviews the user and writes structured input files ready for planning
