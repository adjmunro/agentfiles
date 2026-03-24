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

## Session-Close Rating

<!-- WHY this section exists: plan §4 (Req 4.1–4.4) adds a lightweight outcome-signal layer.
     The ticket move above is already complete — this prompt is advisory and non-blocking.
     If the user skips or gives any non-matching response, nothing is written. No re-prompt occurs.
     Satisfies: Req 4.1, Req 4.4 (move-first ordering enforced by position in this file). -->

After the ticket has been moved and committed, ask the user a single `AskUserQuestion`:

```
Session close — how did this session go?
  yes       — produced what was needed
  partially — got there but with friction
  no        — something went wrong
  skip      — don't record
```

**Response handling** (valid responses: yes / partially / no / skip):

- If the user responds with **yes**, **partially**, or **no**:
  <!-- WHY: Req 4.2 — append a Work Sessions entry so outcome signals accumulate in the quality envelope -->
  1. Resolve the quality envelope path: `.kanban/{subject}/00-quality-{subject}.md`
     (where `{subject}` is the full `YYYY-MM-DD-{subject}` slug).
  2. If the file does not exist, create it with a `## Work Sessions` heading.
  3. If the file exists but has no `## Work Sessions` section, append that heading.
  4. Append the following entry under `## Work Sessions`:
     ```markdown
     ### Session — YYYYMMDD-HH:MM — {TASK-NNN} — {rating}
     ```
     Use the current UTC timestamp for `YYYYMMDD-HH:MM` and the user's exact response word for `{rating}`.
  5. Stage and commit the quality envelope file:
     ```
     kanban(work): record session rating for {TASK-NNN}
     ```
  6. The quality envelope is **append-only** — never overwrite or reorder existing entries.

- If the user responds **skip**, types nothing, or responds with anything that does not exactly match yes / partially / no:
  <!-- WHY: Req 4.3 — escape hatch must be effortless; do not re-prompt or write anything -->
  Proceed without writing. Do not re-prompt.

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
