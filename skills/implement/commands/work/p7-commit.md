# Phase 7 — Git Commit
<!-- Part of: work.md orchestrator -->
<!-- Active when: any phase produces a meaningful artifact (claimed ticket, implementation, work log, review move) -->

After each phase that produces a meaningful artifact (claimed ticket, implementation commit, work log, review move), make a conventional commit:

```
feat({NNN}): [what and why in one line]
```

Replace `{NNN}` with the ticket number (from the ticket's `id` field, zero-padded). The subject line must describe what was done and why it matters — not just what files were touched.

The commit body must state WHY — what this ticket delivers, which requirement it satisfies, what would break without it.

## DO / DO NOT

- NEVER use `--amend` on a commit that was already pushed to a remote — create a new commit instead.
- ALWAYS include the WHY in the commit body: what the ticket delivers, which requirement it satisfies, and what would break without it.
- NEVER bundle multiple unrelated artifacts into a single commit — one meaningful artifact per commit.
- MUST use conventional commit format: `feat({NNN}): [what and why in one line]`.
- DO return to the phase that triggered the commit after completing it; do not skip ahead.

→ Next: Return to the phase that triggered this commit and continue from where you left off.
   If all artifacts are committed and the ticket is in `06-in-review/`, proceed to `work/p8-move-to-review.md` if not already done,
   or report results to the user.
