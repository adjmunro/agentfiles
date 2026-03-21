## Intent

Replace kanban v1's friction-heavy multi-command workflow with two new skills built alongside it. Ideation (`/ideate`) collapses capture→research→interview→plan→tickets into one seamless user-facing loop. Kanban2 (`/kanban`) provides the work loop adapted for the new subject-centric directory structure. Both skills are built fresh alongside v1, which stays untouched until kanban2 is fully verified and the rename is done.

## Requirements

### 1. New directory structure

1.1 — Subject directory name: `YYYY-MM-DD-{subject}/` — ISO date prefix, not the YYYY-MM-DD shortform used in v1.

1.2 — Loose planning docs, numbered for natural sort order:
- `00-input-{subject}.md` — verbatim capture
- `01-research-{subject}.md` — scout findings snapshot
- `02-plan-{subject}.md` — plan + audit trail

1.3 — Assets folder: `00-assets/` — screenshots, links, reference docs.

1.4 — Stage subdirectories, numbered:
- `03-refinement/` — ideation drafts and refines tickets here; not yet available to kanban2
- `04-todo/` — tickets promoted here at step 9; pickable by kanban2
- `05-in-progress/` — claimed tickets
- `06-in-review/` — tickets under review
- `07-pull-request/` — review-passed tickets awaiting merge
- `08-done/` — finished tickets (post-merge or post-cleanup)

1.5 — Completion signal: all tickets for a subject are in `08-done/`. Done-ness can be determined by comparing ticket file count across `04-todo/` through `07-pull-request/` (should be zero) vs `08-done/` (non-zero).

1.6 — Archive behavior: on cleanup, delete all empty stage directories, then move the whole subject folder to `.kanban/.archive/YYYY-MM-DD-{subject}/`. After cleanup only `08-done/` (if non-empty) and `00-assets/` (if non-empty) should remain inside the archived subject folder.

1.7 — Archive path: `.kanban/.archive/YYYY-MM-DD-{subject}/` — hidden dot-directory, sibling to live subject folders.

1.8 — V1 structure (`.kanban/{stage}/{subject}/`) coexists unchanged during migration. Both structures may exist inside the same `.kanban/` directory without conflict.

### 2. Ideation skill

2.1 — User-facing command: `/ideate`. Skill lives at `skills/ideation/`.

2.2 — Internal structure: thin orchestrator `ideate.md` + separate phase files:
- `capture.md` — verbatim transcription (step 1)
- `research.md` — webfetch, local file scan, docs lookup (step 2)
- `interview.md` — research-informed questions with recommendations and tradeoff explanations (step 3)
- `plan.md` — plan drafting and critic audit (steps 4–5)
- `tickets.md` — ticket creation and critic audit (steps 7–8)

`ideate.md` is the orchestrator. It drives the loop, tracks state, and handles branching (loop-back vs advance). Phase files are invoked by the orchestrator and are not user-facing.

2.3 — Nine-step flow orchestrated by `ideate.md`:

**Step 1 — Capture**: transcribe user input verbatim into `00-input-{subject}.md`. Assets go in `00-assets/`. Invoke `capture.md`.

**Step 2 — Research**: before asking the user anything, run `research.md` to scan relevant local files, fetch relevant documentation, and map what already exists. Write findings to `01-research-{subject}.md`.

**Step 3 — Interview**: invoke `interview.md`. Questions must be informed by both the captured input and the research findings. Agent must give recommendations and explain tradeoffs between options — not just ask open questions. Inspired by the `/interview` command pattern.

**Step 4 — Write plan**: invoke `plan.md` to draft `02-plan-{subject}.md` based on captured input + interview answers.

**Step 5 — Audit plan**: critic gate inside `plan.md`. 95% threshold. Auto-fix all gaps. Append audit block to plan file.

**Step 6 — Validate with user**: ask whether satisfied or wants to add more.
- If satisfied → continue to step 7.
- If adding more → loop back to step 1. Append to `00-input-{subject}.md`, never overwrite. Re-run research, interview, plan, and audit for the new input. Ask again at step 6. Repeat until satisfied.

**Step 7 — Write tickets**: invoke `tickets.md`. Draft all tickets into `03-refinement/`. Ticket scope: limited enough that low-effort models can implement, but each is a complete unit of work. Acceptance criteria are the testing plan — empirically verifiable.

**Step 8 — Audit tickets**: critic gate inside `tickets.md`. Check all plan requirements map to ticket ACs. 95% threshold. Auto-fix gaps by creating additional tickets or strengthening ACs.

**Step 9 — Hard stop gate**: two options only:
- **Add to backlog** *(Recommended)* — move all tickets from `03-refinement/` to `04-todo/`. Subject is now pickable by kanban2.
- **Abandon** — confirm by typing the exact subject slug; then delete all files and the subject directory.

2.4 — Tickets during ideation live in `03-refinement/` only. `ideate.md` does not touch `04-todo/` through `08-done/` until the step 9 promotion.

2.5 — Abandon confirmation: user must type the exact subject slug (e.g. `2026-03-22-my-feature`) to confirm deletion. A yes/no is insufficient. Same pattern as the discard guard built in `2026-03-21-command-handoff`.

2.6 — Loop-back rule: all content additions are appends. `00-input-{subject}.md` grows with each loop iteration via a new session block. `02-plan-{subject}.md` is updated and re-audited in place. Prior session content is immutable.

### 3. Kanban2 skill

3.1 — User-facing command: `/kanban`. Skill name: `kanban2` until v1 retired and rename complete. Skill lives at `skills/kanban2/`.

3.2 — Work loop: picks up tickets from `.kanban/YYYY-MM-DD-{subject}/04-todo/`. Mirrors kanban v1's work→review→pr→cleanup pipeline adapted for the new directory structure.

3.3 — Thin `next.md`-equivalent orchestrator drives the work→review loop for kanban2. Same escalation, stale detection, and consecutive-failure logic as v1's `next.md`.

3.4 — Kanban2 never touches `00-input-`, `01-research-`, `02-plan-`, `00-assets/`, or `03-refinement/`.

3.5 — Finished tickets move to `08-done/` (kanban2's equivalent of v1's `06-archive`). Empty stage dirs are cleaned up on archive.

### 4. Carry-forward from kanban v1

4.1 — All v1 patterns apply to both ideation and kanban2 unless explicitly overridden by this plan:

- Verbatim transcription — zero paraphrasing, zero summarising, zero interpretation
- Critic audit gate: 95% threshold, auto-fix all gaps, never ask permission to fix, append structured audit block
- AskUserQuestion: max 4 options, `(Recommended)` label on default option, option ordering signals Enter-to-confirm
- Ticket frontmatter schema: `id`, `subject`, `plan`, `effort`, `status`, `created_at`, `claimed_at`, `completed_at`, `stale_after_hours`, `depends_on`, `spawned_tickets`, `plan_items`, `acceptance_criteria`, `consecutive_failures`
- TASK-001 is always the TDD red phase — no exceptions, never merged into another ticket
- Acceptance criteria must be empirically verifiable: runnable command with expected output, or unambiguous observable state
- Git commits after each phase with conventional commit messages
- Stale ticket detection via `stale_after_hours`
- Consecutive same-error escalation before looping again (desktop notification + escalation block)
- Argument-based boundary passthrough between skills (e.g. `from-ideation-handoff`) to whitelist sanctioned session crossings
- Persona identification when communicating (Vela, Arden, Finn, Keeper, etc.) — reuse existing persona files from `skills/kanban/personas/`
- Research snapshot format: date, "may go stale" disclaimer, sections: Project Structure / Relevant Patterns / Dependencies / Hazards / Recommended Ticket Sequence
- PR bypass conditions: non-GitHub repo skips PR; unprotected trunk skips PR; check failure defers to user
- Phase numbering discipline: when inserting new phases, renumber downstream phases and update all references

4.2 — Personas are shared — both skills reference `skills/kanban/personas/` rather than duplicating persona files.

### 5. Migration path

5.1 — Build ideation (`skills/ideation/`) and kanban2 (`skills/kanban2/`) as fresh skills alongside the existing `skills/kanban/`. No changes to any v1 files during build.

5.2 — V1 remains the active workflow until kanban2 passes its own review cycle.

5.3 — Retire v1: once kanban2 is verified, rename `skills/kanban2/` to `skills/kanban/`, archive or delete the old v1 files, and update any symlinks or references.

### 6. Versioning and changelogs

6.1 — Ideation has its own independent `VERSION.md` and `CHANGELOG.md` at `skills/ideation/`. It starts at v1.0.0 and is versioned independently from kanban v1 and kanban2.

6.2 — Kanban2's `CHANGELOG.md` inherits from kanban v1 — it is a continuation of the existing `skills/kanban/CHANGELOG.md`, not a fresh file. The version sequence continues from wherever kanban v1 left off at the time kanban2 is initialised.

6.3 — Kanban2 has its own `VERSION.md` at `skills/kanban2/`. Version bumping follows the same rules as kanban v1 (patch for fixes, minor for features, major for breaking changes).

## Constraints

- Ideation is a thin orchestrator + phase files, not a monolith
- User-facing commands: `/ideate` and `/kanban` only; all phase files are internal
- Subject dir name format: `YYYY-MM-DD-{subject}/` — full ISO date, not YYYY-MM-DD shortform
- Tickets never leave `03-refinement/` during ideation until step 9 explicit promotion
- Abandon requires typing the exact subject slug; no shortcuts
- Kanban2 never reads or writes plan-layer files
- Personas are shared from `skills/kanban/personas/` — not duplicated

## Out of Scope

- Migration tooling to convert existing v1 `.kanban/` directories to the new structure
- Changes to any existing kanban v1 source files during build
- Implementation details of individual phase files beyond their stated interfaces (each phase file gets its own ticket)
- A combined UI or wrapper that runs ideation and kanban2 from a single entry point

## Audit: input → plan — PASS
**Date**: 2026-03-22T00:00:00Z  **Threshold**: 95%

| # | Item | Status | Notes |
|---|------|--------|-------|
| 1 | Two new skills: ideation + kanban2 | Full | §2, §3 |
| 2 | Ideation = seamless 9-step loop | Full | §2.3 |
| 3 | Step 1: capture verbatim + assets | Full | §2.3 |
| 4 | Step 2: research before interview | Full | §2.3 |
| 5 | Step 3: interview informed by research, with recommendations + tradeoffs | Full | §2.3 |
| 6 | Steps 4–5: write + audit plan | Full | §2.3 |
| 7 | Step 6: validate loop — append only, never overwrite | Full | §2.3, §2.6 |
| 8 | Steps 7–8: write + audit tickets | Full | §2.3 |
| 9 | Step 9: abandon or backlog only | Full | §2.3 |
| 10 | Tickets in 03-refinement/ until step 9 | Full | §2.4 |
| 11 | Abandon: subject slug confirmation | Full | §2.5 |
| 12 | Thin orchestrator + phase files (not monolith) | Full | §2.2 |
| 13 | /ideate + /kanban as user-facing commands | Full | §2.1, §3.1 |
| 14 | Subject dir: YYYY-MM-DD-{subject}/ | Full | §1.1 |
| 15 | Numbered loose docs: 00-input, 01-research, 02-plan | Full | §1.2 |
| 16 | 00-assets/ | Full | §1.3 |
| 17 | Stage dirs: 03-refinement through 08-done | Full | §1.4 |
| 18 | 08-done as completion signal | Full | §1.5 |
| 19 | Archive: delete empty dirs, keep 08-done + 00-assets | Full | §1.6 |
| 20 | Archive path: .kanban/.archive/YYYY-MM-DD-{subject}/ | Full | §1.7 |
| 21 | V1 coexists unchanged | Full | §1.8, §5.1 |
| 22 | Carry-forward: all v1 patterns | Full | §4 |
| 23 | Personas shared from skills/kanban/personas/ | Full | §4.2 |
| 24 | Kanban2 = next.md pattern work loop | Full | §3.3 |
| 25 | Kanban2 never touches plan-layer files | Full | §3.4 |
| 26 | Migration: build alongside, retire after verify, rename | Full | §5 |
| 27 | Why: research too late in v1 (todo phase) | Full | Intent |
| 28 | Why: separate skills to avoid self-editing during build | Full | Intent |
| 29 | Ideation has its own VERSION.md and CHANGELOG.md | Full | §6.1 |
| 30 | Kanban2 CHANGELOG inherits from v1 (continuation, not fresh) | Full | §6.2 |
| 31 | Kanban2 has its own VERSION.md | Full | §6.3 |

- Full: 31, Partial: 0, Missing: 0 — Total: 31
- Score: (31 + 0.5×0) / 31 × 100 = **100%**

### Fixes Applied
Session 260322: added §6 (versioning and changelogs) to cover ideation's independent VERSION.md/CHANGELOG.md and kanban2's inherited changelog.

## Audit: plan → tickets — PASS
**Date**: 2026-03-22T00:00:00Z  **Threshold**: 95%

| # | Requirement | Status | Tickets |
|---|-------------|--------|---------|
| 1 | §1.1 Subject dir YYYY-MM-DD-{subject}/ | Full | TASK-010, TASK-015 |
| 2 | §1.2 Loose docs: 00-input, 01-research, 02-plan | Full | TASK-003, TASK-004, TASK-006 |
| 3 | §1.3 00-assets/ folder | Full | TASK-003, TASK-010 |
| 4 | §1.4 Stage dirs 03-refinement through 08-done | Full | TASK-007, TASK-010, TASK-011–014 |
| 5 | §1.5 Completion signal: all tickets in 08-done/ | Full | TASK-014, TASK-015 |
| 6 | §1.6 Archive: delete empty dirs, move whole subject folder | Full | TASK-014 |
| 7 | §1.7 Archive path .kanban/.archive/YYYY-MM-DD-{subject}/ | Full | TASK-010, TASK-014 |
| 8 | §1.8 V1 structure coexists unchanged | Full | TASK-010 |
| 9 | §2.1 /ideate command; skills/ideation/ | Full | TASK-002 |
| 10 | §2.2 ideate.md orchestrator + 5 phase files (not monolith) | Full | TASK-002, TASK-008 |
| 11 | §2.3 Step 1 — capture.md: verbatim, 00-input, 00-assets | Full | TASK-003 |
| 12 | §2.3 Step 2 — research.md: webfetch + file scan, before interview | Full | TASK-004 |
| 13 | §2.3 Step 3 — interview.md: research-informed + recommendations + tradeoffs | Full | TASK-005 |
| 14 | §2.3 Steps 4–5 — plan.md: draft + critic audit | Full | TASK-006 |
| 15 | §2.3 Step 6 — validate loop: satisfied or add-more | Full | TASK-008 |
| 16 | §2.3 Steps 7–8 — tickets.md: draft into 03-refinement/ + audit | Full | TASK-007 |
| 17 | §2.3 Step 9 — hard stop: backlog or abandon only | Full | TASK-008 |
| 18 | §2.4 Tickets in 03-refinement/ only until step 9 | Full | TASK-007, TASK-008 |
| 19 | §2.5 Abandon: exact subject slug required (not yes/no) | Full | TASK-008 |
| 20 | §2.6 Loop-back: append only, never overwrite | Full | TASK-003, TASK-008 |
| 21 | §3.1 /kanban command; skills/kanban2/ | Full | TASK-009 |
| 22 | §3.2 Work loop picks up from 04-todo/ | Full | TASK-011, TASK-015 |
| 23 | §3.3 thin next.md-equivalent orchestrator | Full | TASK-015 |
| 24 | §3.4 kanban2 never touches plan-layer files | Full | TASK-011 |
| 25 | §3.5 Finished tickets → 08-done/ | Full | TASK-013, TASK-014 |
| 26 | §4.1 Verbatim transcription (zero paraphrase) | Full | TASK-003 |
| 27 | §4.1 Critic audit gate: 95% threshold, auto-fix, append block | Full | TASK-006, TASK-007 |
| 28 | §4.1 AskUserQuestion: max 4 options, (Recommended) label | Full | TASK-005, TASK-008 |
| 29 | §4.1 Ticket frontmatter schema | Full | TASK-007 (+ all tickets) |
| 30 | §4.1 TASK-001 = TDD red phase, no exceptions | Full | TASK-001 |
| 31 | §4.1 Acceptance criteria empirically verifiable | Full | TASK-007 (+ all tickets) |
| 32 | §4.1 Git commits after each phase | Full | TASK-003–008, TASK-010–015 |
| 33 | §4.1 Stale ticket detection (stale_after_hours) | Full | TASK-011, TASK-015 |
| 34 | §4.1 Consecutive failure escalation + desktop notification | Full | TASK-011, TASK-015 |
| 35 | §4.1 Boundary passthrough token (from-ideation-handoff) | Full | TASK-008 |
| 36 | §4.1 Persona identification (reuse skills/kanban/personas/) | Full | TASK-002, TASK-009 |
| 37 | §4.1 Research snapshot format (date, stale disclaimer, sections) | Full | TASK-004 |
| 38 | §4.1 PR bypass conditions (non-GitHub, unprotected trunk, check fail) | Full | TASK-013 |
| 39 | §4.2 Personas shared from skills/kanban/personas/, not duplicated | Full | TASK-002, TASK-009 |
| 40 | §5.1 Build alongside v1; no changes to v1 files during build | Full | TASK-001 |
| 41 | §6.1 Ideation VERSION.md + CHANGELOG.md; v1.0.0 | Full | TASK-002 |
| 42 | §6.2 Kanban2 CHANGELOG inherits from v1 (continuation) | Full | TASK-009 |
| 43 | §4.1 Phase numbering discipline when inserting phases | Partial | All command tasks — process rule, not directly grep-verifiable |

- Full: 42, Partial: 1, Missing: 0 — Total: 43
- Score: (42 + 0.5×1) / 43 × 100 = **98.8%** ✓ PASS

**Note**: §5.3 (retire v1 after kanban2 verified) is explicitly Out of Scope during build per plan Constraints.

### Fixes Applied
No gaps found above 95% threshold. No auto-fixes required.
