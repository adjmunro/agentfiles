# Phase 8 — Move to Review
<!-- Part of: work.md orchestrator -->
<!-- Active when: all acceptance criteria verified and work log appended -->

When all acceptance criteria are verified, move the ticket from `.kanban/YYYY-MM-DD-{subject}/05-in-progress/` to `.kanban/YYYY-MM-DD-{subject}/06-in-review/`. Create the destination directory if it does not exist.

Update the ticket's frontmatter:

```yaml
status: in_review
completed_at: "<ISO8601 timestamp>"
```

**Lock file cleanup:** After moving the ticket to `06-in-review/`, delete `.kanban/YYYY-MM-DD-{subject}/.claims/{ticket-id}.lock` if it exists. This releases the claim so the slot is available if the ticket is ever reset.

If inside a git repo:
1. Stage the moved ticket file.
2. Commit with the message: `kanban(work): complete {TASK-NNN}, moving to 06-in-review`

## Report

Report to the user:

- The ticket that was claimed and worked (ID and slug)
- What was implemented and which ACs were satisfied
- The number of commits made
- Any new tickets spawned (with IDs and brief descriptions)
- The final ticket location (now in `06-in-review/`)
- Any issues encountered that the reviewer must be aware of

Keep the report concise. The user must be able to confirm the ticket is ready for local review without reading the ticket file themselves.

→ Done. Return to orchestrator and report results.
