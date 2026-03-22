# Phase 5 — Scope Enforcement
<!-- Part of: work.md orchestrator -->
<!-- Active when: during Phase 3 implementation — out-of-scope work is discovered -->

If implementation reveals work that is clearly outside this ticket's acceptance criteria — a missing dependency, an adjacent bug, a required refactor — do NOT do that work here.

Instead:

1. Create a new ticket file in `.kanban/YYYY-MM-DD-{subject}/04-todo/` with proper frontmatter (see Ticket Frontmatter Reference below).
2. Give it the next available `TASK-NNN` number in the subject directory.
3. Add its ID to the `spawned_tickets` list in THIS ticket's frontmatter.
4. If the new ticket must be completed before a future ticket can run, update that future ticket's `depends_on` accordingly.

If inside a git repo, stage and commit the new ticket file:
`kanban(work): spawn {TASK-NNN} from {TASK-NNN} (out-of-scope work)`

## Ticket Reference

> See `_shared.md § Ticket Frontmatter Schema` when you need field definitions.
> See `_shared.md § Ticket Body Structure` when you need the body template.
> See `_shared.md § Directory Structure` when you need path references.

→ Next: Return to `work/p3-implementation.md` and continue implementing the current ticket.
