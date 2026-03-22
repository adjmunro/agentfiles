# Phase 1 — Session Boundary
<!-- Part of: work.md orchestrator -->
<!-- Active when: command is first invoked — always runs before any other phase -->

**Check that this is NOT a capture or plan session.** Kanban2 is work-only. If `$ARGUMENTS` contains `from-ideation-handoff`, this is a sanctioned crossing — proceed without challenge.

Otherwise, scan `.kanban/YYYY-MM-DD-{subject}/05-in-progress/` for any active in-progress tickets. If a ticket exists there with `status: in_progress` and its `claimed_at` timestamp has NOT exceeded `stale_after_hours`, report a conflict:

> Active in-progress ticket found: `{ticket-id}`. Resolve or reset it before claiming a new ticket.

Then exit. Do not touch any files.

If the in-progress ticket IS stale (see Phase 4 for staleness definition), surface it and ask the user whether to continue with that ticket or reset it before picking a new one.

## DO / DO NOT

- NEVER start work if a ticket is already in `05-in-progress/` for the current subject and its `claimed_at` has not exceeded `stale_after_hours` — surface the conflict and exit.
- DO allow a `from-ideation-handoff` argument to bypass the in-progress check; this is a sanctioned cross-skill entry point.
- NEVER modify or touch any ticket files during this phase — it is read-only.
- ALWAYS distinguish between an active ticket (not stale) and a stale one before deciding how to proceed; treat them differently.
- MUST confirm the session is a work session (not capture or plan) before executing any subsequent phase.

→ Next: Read `work/p2-ticket-selection.md` and execute it.
