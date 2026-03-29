# Phase 6 — Post PR Comment
<!-- Part of: review-dependency-update.md orchestrator -->
<!-- Active when: Phase 5 verdict blocks written for all dependencies -->

## Step A — Assemble the Comment

Compose the full comment by wrapping all verdict blocks from Phase 5 in a top-level
structure:

```markdown
## Dependency Update Review

> Reviewed by `/review-dependency-update` — automated analysis with human-in-the-loop verdict.

---

<verdict block for dependency 1>

---

<verdict block for dependency 2 (if applicable)>

---

### Overall Recommendation

**<APPROVE / APPROVE WITH CONDITIONS / REQUEST CHANGES / BLOCK>**

<If multiple dependencies: state the aggregate verdict — the most severe individual
verdict governs the overall recommendation. One BLOCK overrides all APPROVEs.>

<1–2 sentences summarising the key reason for the overall recommendation.>

---

*Analysis performed on <date>. Commits in this review: <comma-separated short hashes, or "none">.*
```

## Step B — Post the Comment

Post the assembled comment to the PR:

```
gh pr comment <PR-number> --repo <owner/repo> --body "<assembled comment>"
```

Use a heredoc or temp file if the comment body is long, to avoid shell escaping issues:

```
gh pr comment <PR-number> --repo <owner/repo> --body-file /tmp/dep-review-comment.md
```

## Step C — Report to the User

Print a summary:

```
✓ Comment posted to <PR URL>

Dependency review complete.
<package-name>: <VERDICT> (<RISK TIER>)
<package-name-2>: <VERDICT> (<RISK TIER>)
...
Overall: <AGGREGATE VERDICT>

Commits made: <N> (<list short hashes>) / none
```

→ Done. Return control to the user.
