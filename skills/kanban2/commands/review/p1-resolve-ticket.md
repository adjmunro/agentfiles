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

## DO / DO NOT

- NEVER proceed past this phase without confirming the ticket's frontmatter contains `status: in_review` — a ticket not yet promoted to `06-in-review/` must not be reviewed.
- ALWAYS stop and print the no-ticket message if `06-in-review/` contains no tickets; do not attempt to search other directories.
- DO select the most recently modified ticket automatically when multiple tickets exist — do not prompt the user unless resolution is still ambiguous after applying all four priority rules.
- NEVER modify the ticket file during this phase — resolution is read-only.
- MUST confirm the `plan` frontmatter field is present and non-empty before proceeding to Phase 2a.

→ Next: Read `review/p2a-examiner.md` and execute it.
