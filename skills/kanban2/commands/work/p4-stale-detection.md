# Phase 4 — Stale Detection
<!-- Part of: work.md orchestrator -->
<!-- Active when: ticket has been claimed — check staleness before proceeding to implementation -->

After claiming a ticket, compute whether it is stale:

```
stale = (now - claimed_at) > (stale_after_hours * 3600 seconds)
```

If stale:
1. Surface this exact message to the user:
   ```
   [STALE TICKET] {subject}/{ticket-id} has been claimed for {N} hours
   (stale_after_hours: {threshold}). The session that claimed it may have
   been interrupted. Run `/kanban work {subject}` to resume or re-claim.
   ```
2. Ask the user whether to:
   - **(Recommended)** Continue — proceed with implementation as-if fresh
   - Reset — move the ticket back to `04-todo/`, clear `claimed_at` and `status`, and exit

If the user chooses to continue, proceed to Phase 3 implementation. If reset, move the ticket back and exit cleanly.

## DO / DO NOT

- ALWAYS check `claimed_at` before evaluating `stale_after_hours` — if `claimed_at` is empty the ticket was never claimed and the staleness formula cannot apply.
- NEVER silently continue past a stale ticket; always surface the stale message and wait for an explicit user decision.
- DO present exactly two options — Continue or Reset — do not add a third option or skip the prompt.
- NEVER clear `claimed_at` on a Continue decision; only clear it on a Reset.
- MUST move the ticket back to `04-todo/` and clear both `claimed_at` and `status` fields if the user chooses Reset before exiting.

→ Next: Read `work/p3-implementation.md` and execute it.
