# Phase 6 — Post PR Comment
<!-- Part of: bump-dependencies.md orchestrator -->
<!-- Active when: Phase 5 verdict written for this bump -->
<!-- Each agent posts its own comment — there is no aggregation step -->

## Step A — Assemble the Comment

Compose a self-contained comment for this bump.

> **`<short-hash>` source:** use the short hash of the original bump commit — the commit
> cherry-picked to `dep-review/<PR-number>/<alias>` in Phase 1b Step I. This is the first
> commit on the isolated branch beyond the base branch tip. Do not use a Phase 4
> remediation commit hash here; those are listed separately in the footer line.

```markdown
## Dependency Review: `<alias>` · `<old-version>` → `<new-version>`

> Commit: `<short-hash>` · Reviewed by `/bump-dependencies`

---

<verdict block from Phase 5, verbatim>

---

*Analysis performed on <date>. Remediation commits: <comma-separated hashes, or "none">.*
```

If this bump covers multiple artifacts under one alias (e.g., `room-runtime`,
`room-compiler`, `room-ktx` all under `room`), list them in the header:

```markdown
## Dependency Review: `room` (`androidx.room:*`) · `2.5.2` → `2.6.1`
```

## Step B — Post the Comment

Write the comment to a temp file to avoid shell-escaping issues, then post:

Sanitise the alias for use in the filename — replace any `/` characters with `-`
(e.g., `actions/checkout` → `actions-checkout`) to prevent the shell from treating
the alias as a directory path. Use the sanitised alias in both the temp file name
and the `--body-file` argument.

```
ALIAS_SAFE=$(echo "<alias>" | tr '/' '-')

cat > /tmp/dep-review-<PR-number>-${ALIAS_SAFE}.md << 'EOF'
<assembled comment>
EOF

gh pr comment <PR-number> --repo <owner/repo> --body-file /tmp/dep-review-<PR-number>-${ALIAS_SAFE}.md
```

## Step C — Report to the User

```
✓ Comment posted: `<alias>` <old> → <new> — <VERDICT> (<RISK TIER>)
  PR: <PR URL>
  Remediation commits: <hashes or "none">
```

→ Done. This agent's work is complete.

> **Orchestrator note:** Once ALL per-bump Phase 6 comments have been posted (i.e.,
> every bump in the manifest has reached this point), the orchestrator must read and
> execute `phases/p7-summary.md` to post the single consolidated verdict comment.
> Per-bump agents do NOT run Phase 7 — it is an orchestrator-only step.
