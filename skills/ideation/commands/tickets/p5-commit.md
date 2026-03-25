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

<!-- WHY commit gate is locked below 95%: committing a partial ticket set could allow the implement skill to claim tickets before all coverage gaps are resolved. A committed-but-incomplete ticket set would appear complete from the git history perspective, making the gap invisible to future audits. -->
- NEVER commit if the audit score is below 95% — the commit gate only opens when Phase 4 passes.
- ALWAYS stage all new and modified files before committing; do not commit a partial ticket set.
- MUST include the audit score in the commit body — a bare ticket count is not sufficient.
- NEVER use `--amend` to retrofit a commit once any files have been pushed to a remote branch.
- DO include the count of auto-created fix tickets in the commit body if any were created during the Phase 4 auto-fix pass.

<!-- WHY promotion is NOT here: H21 (run 5) found that this section contradicted ideate.md Phase 7 — "no tickets go to 04-todo until step 9 explicitly promotes them." Having p5-commit.md promote immediately made the user-confirmation gate at Phase 8 semantically void. Promotion is the orchestrator's responsibility, gated by user choice. -->

**Note — promotion is deferred to the orchestrator.** This phase ends at the audit commit. Ticket files remain in `03-refinement/` until the user makes their choice at Step 9 (ideate.md Phase 8). Do NOT move tickets to `04-todo/` here.

If you are invoking `tickets.md` directly without the `ideate.md` orchestrator, manually promote tickets from `03-refinement/` to `04-todo/{subject}/` after this command completes.

→ Done. Return to orchestrator (ideate.md Phase 8) for the Step 9 hard stop gate.
