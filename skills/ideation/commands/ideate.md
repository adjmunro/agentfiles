---
model: claude-haiku-4-5-20251001
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion, Agent
argument-hint: "[YYYY-MM-DD-{subject} | new] — subject to ideate on; 'new' prompts for subject name"
---

## Personas

This command is the orchestrator voice only. It does not adopt phase personas directly — each phase file loads its own persona. Communicate with the user plainly and concisely between phases: announce what phase is starting, report completion, surface branch points.

## DO

- Drive the full 9-step ideation loop from start to finish
- Delegate every phase to its phase file via subagent (or sequential dispatch if subagents unavailable)
- Pass minimal context to each subagent: subject slug, relevant file paths, and the phase file to invoke
- Ask the user at step 6 (validate) and step 9 (hard stop) — these are the only two user decision points after subject setup
- Commit after each phase completes (the phase file handles its own commit; confirm it ran)
- Loop back to Phase 2 (capture) when the user chooses "Add more" at step 6
- Pass `from-ideation-handoff` as an argument token when handing off to implement after step 9 promotion

## DO NOT

- Implement any phase work directly — dispatch it
- Touch `04-todo/` through `08-done/` until step 9 promotion
- Accept "yes" or "no" as confirmation for abandon — require the exact subject slug
- Overwrite any existing `00-input-{subject}.md` content — append only on loop-back
- Skip the step 9 hard stop gate under any circumstances

---

## Phase 1 — Subject Setup

Resolve the subject slug from `$ARGUMENTS`:

1. If `$ARGUMENTS` matches `YYYY-MM-DD-*` format → use it as-is.
2. If `$ARGUMENTS` is `new` or empty → use `AskUserQuestion` to ask: "What is the subject name for this ideation session?" Then slugify: lowercase, spaces → hyphens, strip non-alphanumerics except hyphens, prepend today's date as `YYYY-MM-DD`.
3. Final subject slug format: `YYYY-MM-DD-{subject-slug}`.

<!-- WHY slug uniqueness guard exists: prevents silently targeting the wrong subject directory when a subject with the same date+name already exists (e.g., two ideation sessions started on the same day with the same topic). Appending -2/-3 makes the collision explicit rather than overwriting prior work. -->
**Slug uniqueness guard:** If `.kanban/YYYY-MM-DD-{subject-slug}/` already exists and this is NOT a loop-back (i.e. `$ARGUMENTS` did not explicitly name it), append `-2` to the slug. If that also exists, try `-3`, and so on until a unique slug is found. Log which slug was chosen: "Subject directory already existed — using `YYYY-MM-DD-{subject-slug}` instead."

<!-- WHY init.md is an external dependency: init.md is provided by the kanban skill (see skills/kanban/commands/). Expected behaviour: creates .kanban/YYYY-MM-DD-{subject}/ with stage directories (00-assets, 03-refinement, 04-todo, 05-in-progress, 06-in-review, 07-pull-request, 08-done). If init.md is unavailable, create this directory structure manually with Bash before proceeding. -->
Invoke `commands/init.md` with the derived subject slug to create the subject scaffold. This creates `.kanban/YYYY-MM-DD-{subject}/` with all stage directories. If the directory already exists, `init.md` handles reinitialisation safely — only missing directories are added.

**State detection and resume routing:**

<!-- WHY resume routing exists: H1 (run 1) — multi-session subjects resume from the most advanced completed state rather than restarting, avoiding re-execution of work that has already been committed. Without this check, invoking /ideate on an existing subject would re-run from step 1 and could overwrite completed artifacts. -->
After resolving the subject slug and before announcing start, check for a partially-completed subject by testing artifact presence in order (most advanced state first):

1. If `.kanban/YYYY-MM-DD-{subject}/03-refinement/` contains at least one ticket file with substantive content → **resume at step 9 (hard stop gate)**. Announce: "Resuming ideation for `YYYY-MM-DD-{subject}` — tickets are drafted. Advancing to step 9 (hard stop gate)." Skip Phases 2–7 and jump directly to Phase 8.
2. If `.kanban/YYYY-MM-DD-{subject}/02-plan-{subject}.md` exists with substantive content → **resume at step 6 (validate)**. Announce: "Resuming ideation for `YYYY-MM-DD-{subject}` — plan is complete. Advancing to step 6 (validate with user)." Skip Phases 2–5 and jump directly to Phase 6.
3. If `.kanban/YYYY-MM-DD-{subject}/00-input-{subject}.md` contains an `## Interview` block (any date) → **resume at step 4 (plan)**. Announce: "Resuming ideation for `YYYY-MM-DD-{subject}` — interview is recorded. Advancing to step 4 (plan)." Skip Phases 2–4 and jump directly to Phase 5.
4. If `.kanban/YYYY-MM-DD-{subject}/01-research-{subject}.md` exists with substantive content → **resume at step 3 (interview)**. Announce: "Resuming ideation for `YYYY-MM-DD-{subject}` — research is complete. Advancing to step 3 (interview)." Skip Phases 2–3 and jump directly to Phase 4.
5. If `.kanban/YYYY-MM-DD-{subject}/00-input-{subject}.md` exists with substantive content → this is a **loop-back iteration**. Note this for Phase 2 — `capture.md` will append a new session block rather than create a fresh file. Announce: "Resuming ideation for `YYYY-MM-DD-{subject}`. Beginning capture (loop-back — step 1 of 9)."
6. Otherwise → this is a **fresh first run**. Announce: "Starting ideation for `YYYY-MM-DD-{subject}`. Beginning capture (step 1 of 9)."

Substantive content means: file exists, size > 0 bytes, and contains at least one non-heading line (a line that does not start with `#`). A file with only headings or an empty body does not qualify.

---

## Phase 2 — Step 1: Capture

Invoke `capture.md` for this subject.

Dispatch as subagent with:
- Subject slug: `YYYY-MM-DD-{subject}`
- Phase file: `skills/ideation/commands/capture.md`
- Input file path: `.kanban/YYYY-MM-DD-{subject}/00-input-{subject}.md`
- Whether this is a loop-back iteration (first run or append)

If subagents are unavailable, run `capture.md` behaviour sequentially in the current session.

Wait for capture to complete before proceeding. Capture ends when `00-input-{subject}.md` is written (or appended) and a git commit is made.

---

## Phase 3 — Step 2: Research

<!-- WHY re-read before each dispatch (active intent anchors, run 1): re-reading the primary artifact before dispatching a subagent prevents context drift across long sessions. Without this anchor, a subagent may operate on a stale in-memory copy of the intent rather than the committed file state. -->
Re-read `.kanban/YYYY-MM-DD-{subject}/00-input-{subject}.md` now to anchor context before dispatching.
Confirm: subject slug matches $ARGUMENTS (or derived slug from Phase 1). File must exist — do not dispatch if missing.

Invoke `research.md` for this subject. Research runs automatically — do not ask the user for input before or during research.

Dispatch as subagent with:
- Subject slug: `YYYY-MM-DD-{subject}`
- Phase file: `skills/ideation/commands/research.md`
- Input file path: `.kanban/YYYY-MM-DD-{subject}/00-input-{subject}.md`
- Output file path: `.kanban/YYYY-MM-DD-{subject}/01-research-{subject}.md`

Announce: "Research complete. Beginning interview (step 3 of 9)."

---

## Phase 4 — Step 3: Interview

Re-read `.kanban/YYYY-MM-DD-{subject}/00-input-{subject}.md` now to anchor context before dispatching.
Confirm: subject slug is current (matches Phase 1 resolution). File must exist and contain substantive content — do not dispatch if missing.

Invoke `interview.md` for this subject.

Dispatch as subagent with:
- Subject slug: `YYYY-MM-DD-{subject}`
- Phase file: `skills/ideation/commands/interview.md`
- Input file: `.kanban/YYYY-MM-DD-{subject}/00-input-{subject}.md`
- Research file: `.kanban/YYYY-MM-DD-{subject}/01-research-{subject}.md`

Wait for the interview to complete (user has reviewed and approved/amended the recommendation brief, and decisions are recorded).

---

## Phase 5 — Steps 4–5: Plan + Audit

Re-read `.kanban/YYYY-MM-DD-{subject}/00-input-{subject}.md` now to anchor context before dispatching.
Confirm: subject slug is current (matches Phase 1 resolution). File must exist and contain at least one interview block — do not dispatch if missing.

Invoke `plan.md` for this subject. The plan phase writes the plan and runs the internal audit — both steps 4 and 5 are handled by a single phase file.

Dispatch as subagent with:
- Subject slug: `YYYY-MM-DD-{subject}`
- Phase file: `skills/ideation/commands/plan.md`
- Input file: `.kanban/YYYY-MM-DD-{subject}/00-input-{subject}.md`
- Research file: `.kanban/YYYY-MM-DD-{subject}/01-research-{subject}.md`
- Output file: `.kanban/YYYY-MM-DD-{subject}/02-plan-{subject}.md`

Wait for the plan (and its audit) to complete before proceeding to step 6.

---

## Phase 6 — Step 6: Validate with User

Re-read `.kanban/YYYY-MM-DD-{subject}/02-plan-{subject}.md` now to anchor context before presenting to the user.

Ask the user using `AskUserQuestion` (max 4 options):

> "The plan for `YYYY-MM-DD-{subject}` is ready. Are you satisfied, or would you like to add more?"

Options:
1. **Satisfied — continue to tickets** *(Recommended)*
2. **Add more — loop back to capture**
3. **Abandon this subject**

**If option 1 (Satisfied)**: Continue to Phase 7.

**If option 2 (Add more)**: Loop back to Phase 2 (Step 1: Capture). The `capture.md` phase will append a new session block to `00-input-{subject}.md` — it never overwrites prior content. After capture completes, continue through research → interview → plan → audit and return to this validation step (Phase 6) again.

**If option 3 (Abandon)**: Trigger the abandon flow:
1. Ask: "Type the exact subject slug to confirm deletion: `YYYY-MM-DD-{subject}`"
2. Wait for the user's input.
3. If the user's response matches the slug exactly → delete the entire `.kanban/YYYY-MM-DD-{subject}/` directory and all its contents. Report: "Subject `YYYY-MM-DD-{subject}` has been abandoned and all files deleted." Stop.
4. If the user's response does not match → cancel. Report: "Confirmation did not match. Abandonment cancelled. No files were deleted." Return to the option prompt.

---

## Phase 7 — Steps 7–8: Tickets + Audit

Re-read `.kanban/YYYY-MM-DD-{subject}/02-plan-{subject}.md` now to anchor context before dispatching.
Confirm: subject slug is current (matches Phase 1 resolution). Plan file must exist and contain an audit section — do not dispatch if missing.

Invoke `tickets.md` for this subject. The tickets phase writes all ticket files into `03-refinement/` and runs the internal ticket audit — both steps 7 and 8 are handled by a single phase file.

Dispatch as subagent with:
- Subject slug: `YYYY-MM-DD-{subject}`
- Phase file: `skills/ideation/commands/tickets.md`
- Plan file: `.kanban/YYYY-MM-DD-{subject}/02-plan-{subject}.md`
- Output directory: `.kanban/YYYY-MM-DD-{subject}/03-refinement/`

**Important**: tickets are written to `03-refinement/` only. No tickets go to `04-todo/` until step 9 explicitly promotes them. This keeps the ideation loop safe — the user can still abandon without affecting the implement work queue.

Wait for tickets and the ticket audit to complete.

---

## Phase 8 — Step 9: Hard Stop Gate

Re-read `.kanban/YYYY-MM-DD-{subject}/02-plan-{subject}.md` now to anchor context before the final decision.

This is the final decision point. Ask the user using `AskUserQuestion` (max 2 options):

> "Ideation for `YYYY-MM-DD-{subject}` is complete. The tickets are staged in `03-refinement/` and ready to promote. What would you like to do?"

Options:
1. **Add to backlog (move tickets to `04-todo/`)** *(Recommended)*
2. **Abandon (delete everything for this subject)**

**If option 1 (Add to backlog)**:
1. Move all ticket files from `.kanban/YYYY-MM-DD-{subject}/03-refinement/` to `.kanban/YYYY-MM-DD-{subject}/04-todo/` (create `04-todo/` if it does not exist).
   <!-- WHY idempotency guard on ticket move: H21 (run 5) — guards against double-promotion if Phase 8 is re-entered after a crash mid-move. Each ticket's presence in 04-todo/ is checked before git mv to prevent a second mv attempt on an already-moved file, which would fail with a "file not found in 03-refinement" error. -->
   - Before moving each file, check whether it already exists in `04-todo/`. If it does → skip the move for that ticket (already promoted).
   - Use `git mv` inside a git repo, or move the file and then `git add -A` to capture both the deletion and the addition.
2. Stage and commit:
   ```
   kanban(tickets): promote N tickets to backlog for {subject}
   ```
   Body: number of tickets promoted, ticket IDs (e.g., "TASK-001 through TASK-005"), and destination (`04-todo/{subject}/`).
3. Report: "Subject `YYYY-MM-DD-{subject}` is now in backlog. Pick it up with `/implement from-ideation-handoff`."
4. The `from-ideation-handoff` token signals to implement that this is a sanctioned boundary crossing from ideation.
5. Stop.

**If option 2 (Abandon)**:
1. Ask: "Type the exact subject slug to confirm deletion: `YYYY-MM-DD-{subject}`"
2. Wait for the user's input.
3. If the user's response matches the slug exactly → delete the entire `.kanban/YYYY-MM-DD-{subject}/` directory and all its contents. Report: "Subject `YYYY-MM-DD-{subject}` has been abandoned and all files deleted." Stop.
4. If the user's response does not match → cancel. Report: "Confirmation did not match. Abandonment cancelled. No files were deleted." Return to the option prompt.

---

## Key Rules

- `03-refinement/` is the ONLY staging area for tickets during ideation. Never write tickets to `04-todo/` until step 9 promotion.
- The step 9 promotion moves tickets: `03-refinement/` → `04-todo/{subject}/`
- Abandon requires the exact subject slug typed by the user — a simple "yes" or "no" is insufficient and must be rejected.
- Loop-back is append-only: `capture.md` appends a new session block; prior content in `00-input-{subject}.md` is immutable.
- All phase files are internal (not user-facing). Only `ideate.md` is the `/ideate` command.
- The `from-ideation-handoff` token is passed to implement at step 9 promotion to whitelist the sanctioned boundary crossing.
