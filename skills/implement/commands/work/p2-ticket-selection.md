# Phase 2 — Ticket Selection
<!-- Part of: work.md orchestrator -->
<!-- Active when: Phase 1 check passed — no conflicting in-progress ticket found -->

Determine which ticket to implement using the following priority order:

1. **`$ARGUMENTS` path** — if arguments contain a `YYYY-MM-DD-{subject}/TASK-NNN` pattern, locate that ticket in `.kanban/YYYY-MM-DD-{subject}/04-todo/`. Verify the file exists.
2. **Auto-select** — list `.kanban/YYYY-MM-DD-{subject}/04-todo/` for ticket files. Select the lowest-numbered ticket whose `depends_on` are all satisfied.

**Dependency check:** Read each candidate ticket's frontmatter `depends_on` list. For each listed ticket ID, confirm a file with that ID exists in `.kanban/YYYY-MM-DD-{subject}/06-in-review/` or `.kanban/YYYY-MM-DD-{subject}/07-pull-request/` with `status: done`. Skip any ticket where one or more dependencies are not yet satisfied.

A dependency is **not** considered satisfied if the ticket is still under review (`status: in_review`) — it could fail review and be returned. Only `status: done` in a post-review directory confirms the work is complete and stable.

**STOP:** If no ticket files exist in `04-todo/`, print exactly:

> No todo tickets found for this subject. Run `/init` first or check that tickets have been promoted to `04-todo/`.

Then exit. Do not touch any files.

**Pre-claim check — run before moving any ticket:**

In these steps, `{subject}` is the **full** `YYYY-MM-DD-{subject}` slug (e.g. `2026-03-22-linkcheck`), matching the directory name used everywhere else.

1. Check for `.kanban/YYYY-MM-DD-{subject}/.claims/{ticket-id}.lock`.
2. If the lock file exists:
   a. Read its `claimed_at` timestamp and `stale_after_hours` value.
   b. If age > `stale_after_hours`: the lock is abandoned. Delete it and proceed to step 3.
   c. If age ≤ `stale_after_hours`: this ticket is already claimed in this session. Skip it — select the next unclaimed ticket from `04-todo/` instead and repeat the pre-claim check for that ticket.
3. Write the lock file to `.kanban/YYYY-MM-DD-{subject}/.claims/{ticket-id}.lock` with:
   ```
   claimed_at: {ISO timestamp}
   session_hint: {first 8 chars of a random UUID or current timestamp in ms}
   stale_after_hours: {value from ticket frontmatter, default 4}
   ```
   Create `.kanban/YYYY-MM-DD-{subject}/.claims/` if it does not exist.
4. Then proceed to move the ticket to `05-in-progress/` and update its frontmatter.

**Move the selected ticket** from `.kanban/YYYY-MM-DD-{subject}/04-todo/` to `.kanban/YYYY-MM-DD-{subject}/05-in-progress/`. Create the destination directory if it does not exist.

Update the ticket's frontmatter:

```yaml
status: in_progress
claimed_at: "<ISO8601 timestamp>"
```

Compute the current timestamp. Example (Claude Code): `Bash` with `date -u +"%Y-%m-%dT%H:%M:%SZ"` on macOS/Linux.

If inside a git repo:
1. Stage the moved ticket file (old path deletion + new path addition).
2. Commit with the message: `kanban(work): claim {TASK-NNN} for {YYYY-MM-DD-subject}`

→ Next: Read `work/p4-stale-detection.md` and execute it. (Stale check runs before implementation.)
