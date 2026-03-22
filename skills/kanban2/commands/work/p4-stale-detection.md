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

→ Next: Read `work/p3-implementation.md` and execute it.
