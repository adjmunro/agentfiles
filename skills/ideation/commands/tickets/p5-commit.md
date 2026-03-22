# Phase 5 — Git Commit
<!-- Part of: tickets.md orchestrator -->
<!-- Active when: audit passes at ≥ 95% (Phase 4 done) -->

After Phase 4 completes and the audit passes:

1. Stage all new and modified files.
2. Commit with the message:

```
kanban(tickets): draft N tickets for {subject}
```

Include in the commit body:
- Number of tickets created
- Audit score
- Any tickets auto-created during the fix pass

## DO / DO NOT

- NEVER commit if the audit score is below 95% — the commit gate only opens when Phase 4 passes.
- ALWAYS stage all new and modified files before committing; do not commit a partial ticket set.
- MUST include the audit score in the commit body — a bare ticket count is not sufficient.
- NEVER use `--amend` to retrofit a commit once any files have been pushed to a remote branch.
- DO include the count of auto-created fix tickets in the commit body if any were created during the Phase 4 auto-fix pass.

## Backlog Promotion

After the commit succeeds, promote all tickets from `03-refinement/` to `04-todo/`:

1. Move every `TASK-NNN-{subject}.md` file from `03-refinement/` to `04-todo/`. Create `04-todo/` if it does not exist.
   - Use `git mv` inside a git repo, or move the file and then `git add -A` to capture both the deletion and the addition.
2. Stage and commit:
   ```
   kanban(tickets): promote N tickets to backlog for {subject}
   ```
3. Report the ticket IDs now available in `04-todo/`.

This makes the tickets immediately available to `implement work`. The `03-refinement/` directory is left in place but empty — it serves as a breadcrumb showing where tickets were staged before promotion.

→ Done. Return to orchestrator and report results.
