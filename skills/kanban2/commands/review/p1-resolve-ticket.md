# Phase 1 — Resolve Ticket
<!-- Part of: review.md orchestrator -->
<!-- Active when: command is first invoked — always runs before any other phase -->

Determine which ticket to review using this priority order. Stop at the first source that yields a result.

1. **`$ARGUMENTS` match** — if arguments contain a `YYYY-MM-DD-<subject>/TASK-NNN` or `TASK-NNN` pattern, locate that ticket under `.kanban/YYYY-MM-DD-<subject>/06-in-review/`.
2. **Single ticket present** — if the subject's `06-in-review/` contains exactly one ticket file, select it automatically.
3. **Most recently modified** — if multiple tickets exist under `06-in-review/`, select the one with the most recent `claimed_at` timestamp in frontmatter.
4. **Ask the user** — if resolution is still ambiguous, list the available tickets and ask which to review.

**STOP:** If `06-in-review/` contains no tickets, print: "No tickets in 06-in-review. Run `/kanban work` to complete work first." Exit immediately.

Read the ticket file. Confirm its frontmatter contains:
- `status: in_review`
- A `plan` field pointing to the subject plan file

→ Next: Read `review/p2a-examiner.md` and execute it.
