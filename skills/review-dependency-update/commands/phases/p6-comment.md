# Phase 6 — Post PR Comment
<!-- Part of: review-dependency-update.md orchestrator -->
<!-- Active when: Phase 5 verdict written for this bump -->
<!-- Each agent posts its own comment — there is no aggregation step -->

## Step A — Assemble the Comment

Compose a self-contained comment for this bump:

```markdown
## Dependency Review: `<alias>` · `<old-version>` → `<new-version>`

> Commit: `<short-hash>` · Reviewed by `/review-dependency-update`

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

```
cat > /tmp/dep-review-<alias>.md << 'EOF'
<assembled comment>
EOF

gh pr comment <PR-number> --repo <owner/repo> --body-file /tmp/dep-review-<alias>.md
```

## Step C — Report to the User

```
✓ Comment posted: `<alias>` <old> → <new> — <VERDICT> (<RISK TIER>)
  PR: <PR URL>
  Remediation commits: <hashes or "none">
```

→ Done. This agent's work is complete.
