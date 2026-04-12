# Phase 7 — Run Summary Comment
<!-- Part of: review-dependency-update.md orchestrator -->
<!-- Active when: ALL per-bump Phase 6 comments have been posted and Phase 8 is complete -->
<!-- Run by: the orchestrator only — never by a per-bump sub-agent -->
<!-- This phase posts exactly ONE comment for the entire PR run. -->

This is the last action the skill takes. If exactly **one** alias was reviewed,
skip this phase entirely — the Phase 6 comment already contains the full detail
and a summary would only duplicate it. Proceed to Step D (report to user) only.

For **two or more** aliases, post a concise run summary covering only information
that is new or synthesised — do not restate what the per-bump Phase 6 comments
already contain.

---

## Step A — Collect the Minimum Required Data

**Data source:** Phase 5 verdict data should already be in orchestrator context
from Wave 5. If not, retrieve from posted Phase 6 comments:

```
gh pr view <PR-number> --repo <owner/repo> --json comments \
  --jq '.comments[] | select(.body | startswith("## Dependency Review:")) | .body'
```

For each alias, extract only:
- Alias name
- Old version → new version
- Verdict (APPROVE / APPROVE WITH CONDITIONS / REQUEST CHANGES / BLOCK)
- Any items requiring human action (unresolved failures, partial remediations,
  flagged supply-chain concerns, skipped aliases, push-failed aliases)

Also retrieve the Phase 8 consolidation summary (read
`/tmp/dep-review-<PR-number>-consolidation-summary.md` if it exists, otherwise
use the summary already in context):
- Integration test result (PASS / FAIL, suite name, counts)
- Bisect findings, if any

---

## Step B — Compose the Summary Comment

Keep the comment short. The per-bump detail is in the comments above — this
comment is a navigator, not a repeat.

```markdown
## Dependency Review — Run Summary

> `/review-dependency-update` · <date> · <N> bumps

| Alias | Old → New | Verdict |
|---|---|---|
| `<alias>` | `<old>` → `<new>` | **<VERDICT>** |
| `<alias>` | — | **Not reviewed — isolated branch push failed** |

**Overall:** <APPROVE ALL / APPROVE WITH CONDITIONS / REQUEST CHANGES / BLOCK>

**Integration tests:** <PASS | FAIL> — <suite name> <N>/<N> passing<br>
<If failed: bisect finding — e.g. "`kotlin` introduced the regression">

**Needs human action:**
- <alias> — <one-line reason, e.g. "BLOCK: unresolved CI failure in :app:test">
- <alias> — <one-line reason, e.g. "deprecated API in DataStore not auto-fixed — 3 call sites">

_None — all bumps approved and integration tests passed._
_(use one of the above two lines, not both)_

*Individual comments above contain full detail per bump.*
```

Rules:
- The "Needs human action" list replaces the bullet with `_None_` if there is
  nothing requiring action. Remove the `_None_` line if there are action items.
- Only include a `Bisect finding` line if integration tests failed.
- Do not add a plain-English paragraph — the table and action list are sufficient.
- Do not repeat CI status, supply-chain signals, breaking-change details, or
  remediation commit hashes — those are all in the per-bump comments.

---

## Step C — Post the Comment

```
cat > /tmp/dep-review-<PR-number>-summary.md << 'EOF'
<assembled summary comment>
EOF

gh pr comment <PR-number> --repo <owner/repo> \
  --body-file /tmp/dep-review-<PR-number>-summary.md
```

---

## Step D — Report to the User

```
✓ Run complete — PR #<number>
  Bumps: <N> (<comma-separated aliases>)
  Overall: <APPROVE ALL | APPROVE WITH CONDITIONS | REQUEST CHANGES | BLOCK>
  PR: <PR URL>
```

→ Done. The skill run is complete.
