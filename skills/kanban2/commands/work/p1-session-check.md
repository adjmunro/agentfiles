# Phase 1 — Session Boundary
<!-- Part of: work.md orchestrator -->
<!-- Active when: command is first invoked — always runs before any other phase -->

**Check that this is NOT a capture or plan session.** Kanban2 is work-only. If `$ARGUMENTS` contains `from-ideation-handoff`, this is a sanctioned crossing — proceed without challenge.

Otherwise, scan `.kanban/YYYY-MM-DD-{subject}/05-in-progress/` for any active in-progress tickets. If a ticket exists there with `status: in_progress` and its `claimed_at` timestamp has NOT exceeded `stale_after_hours`, report a conflict:

> Active in-progress ticket found: `{ticket-id}`. Resolve or reset it before claiming a new ticket.

Then exit. Do not touch any files.

If the in-progress ticket IS stale (see Phase 4 for staleness definition), surface it and ask the user whether to continue with that ticket or reset it before picking a new one.

→ Next: Read `work/p2-ticket-selection.md` and execute it.
