# Phase 7 — Final Consolidated Verdict Comment
<!-- Part of: review-dependency-update.md orchestrator -->
<!-- Active when: ALL per-bump Phase 6 comments have been posted -->
<!-- Run by: the orchestrator only — never by a per-bump sub-agent -->
<!-- This phase posts exactly ONE comment for the entire PR, consolidating all bumps. -->

This is the last action the skill takes. Collect the Phase 5 verdict blocks and
all session data produced during the run, then post a single summary comment to
the PR. A reviewer reading only this comment should be able to understand the
full picture without scrolling through the individual per-bump comments.

## Step A — Collect Data Across All Bumps

**Data source:** Phase 5 verdict data should be available in context from the
orchestrator's Wave 5 setup (see the orchestrator's Wave 5 section for how this
data is collected). If it is not in context, retrieve it from the Phase 6 PR
comments already posted:

```
gh pr view <PR-number> --repo <owner/repo> --json comments \
  --jq '.comments[] | select(.body | startswith("## Dependency Review:")) | .body'
```

Use each matching comment as the Phase 5 verdict block for that bump.

For each bump reviewed during this run, gather:

1. **Dependency identity** — alias, old version → new version, version span (single / multi with count).
2. **CI status** — was CI passing at Phase 1? Did Phase 4 resolve all failures? Are any failures still unresolved, and what are they?
3. **Supply chain signals** — Rook's findings: tag signing status, registry integrity, source commit anomalies, maintainer-change flags. Record as "No concerns", "Possible concern: …", or "Confirmed concern: …".
4. **Breaking changes and deprecations** — what was found across the full version span (including intermediate releases); whether each was remediated or left for manual action.
5. **Remediations made** — commit hashes and a one-line description of each fix.
6. **Verdict** — tier (Low / Medium / High / Critical), score, and verdict (APPROVE / APPROVE WITH CONDITIONS / REQUEST CHANGES / BLOCK). Include any override applied.
7. **Consolidation outcome** — from the Phase 8 consolidation summary. Retrieve using the following priority order:
   - **Primary:** read `/tmp/dep-review-<PR-number>-consolidation-summary.md` if it exists (written by Phase 8 Step G).
   - **Fallback:** use the Phase 8 consolidation summary already in orchestrator context if the file is absent.
   Record: merge outcome per alias (clean / conflict resolved / skipped), integration test result (PASS / FAIL), bisect findings if any.

If a bump was skipped (Phase 2 or 3 could not complete), note it as "Skipped — manual review required".

Also check the manifest for any entries with `push_failed: true` (aliases whose
isolated branches could not be pushed to the remote in Phase 1b Step I). For each
such alias, add a row to the Bumps Reviewed table with:
- Alias: `<alias>`
- Verdict: **Not reviewed — isolated branch push failed in Phase 1b**
- All other columns: `—`

These aliases were excluded from the review pipeline. The reviewer must assess
them manually before merging the PR.

## Step B — Compose the Summary Comment

Assemble a single markdown comment using the template below. Render it faithfully — do not collapse sections, even if they contain only "None" or "N/A" values.

```markdown
## Dependency Review Summary

> Reviewed by `/review-dependency-update` · <date> · <N> bump(s) across <N> alias(es)

---

### Bumps Reviewed

| Alias | Packages | Old → New | Span | Tier | Score | Verdict |
|---|---|---|---|---|---|---|
| `<alias>` | `<packages>` | `<old>` → `<new>` | single \| multi (<N> versions) | <TIER> | <score> | <VERDICT> |
| `<alias>` | — | — | — | — | — | **Not reviewed — isolated branch push failed in Phase 1b** |

---

### CI Status

| Alias | Status at Phase 1 | Status after Remediation | Unresolved Failures |
|---|---|---|---|
| `<alias>` | Passing \| Failing (<N> jobs) | All resolved \| Still failing \| N/A | <list or "None"> |

> **CI hard blocks:** <list any bumps whose verdict was forced to REQUEST CHANGES by an unresolved CI failure, or "None">

---

### Supply Chain Signals

| Alias | Tag Signing | Registry Integrity | Source Commits | Maintainer / Ownership |
|---|---|---|---|---|
| `<alias>` | Signed \| Unsigned \| Regression | OK \| Anomaly found | OK \| Anomaly found | No change \| Change detected |

> Rook overall finding: <"No supply-chain concerns raised across all bumps" | list of confirmed or possible concerns with alias>

---

### Breaking Changes and Deprecations

| Alias | Breaking Changes | Deprecations in Our Code | Status |
|---|---|---|---|
| `<alias>` | <list or "None"> | <list or "None"> | Fully remediated \| Partial \| Manual action required \| N/A |

For multi-version spans, note any signals that originated from intermediate releases rather than the final version.

---

### Remediations Made

| Alias | Commit | Description |
|---|---|---|
| `<alias>` | `<short-hash>` | <one-line description> |

_If no remediations were required: "No changes were required — the codebase was already compatible across all bumps."_

---

### Final Verdicts

| Alias | Tier | Score | Verdict | Notes |
|---|---|---|---|---|
| `<alias>` | <TIER> | <score> | **<VERDICT>** | <override applied, or "—"> |

**Overall recommendation:** <APPROVE ALL / APPROVE WITH CONDITIONS / REQUEST CHANGES / BLOCK — state which aliases drive the overall recommendation and why>

---

### Plain-English Summary

<One paragraph, 4–8 sentences, written for a non-technical reviewer. Name each dependency and what it is. State whether the upgrade is safe and why. Note any issues that were found and whether they were fixed automatically. Flag anything that still requires human action. Do not use jargon or scoring notation — translate all findings into plain language.>

---

*Analysis performed on <date>. Individual per-bump comments with full detail are posted above this comment.*
```

## Step C — Post the Comment

Write the comment to a temp file, then post it to the PR:

```
cat > /tmp/dep-review-<PR-number>-summary.md << 'EOF'
<assembled summary comment>
EOF

gh pr comment <PR-number> --repo <owner/repo> --body-file /tmp/dep-review-<PR-number>-summary.md
```

## Step D — Report to the User

```
✓ Final summary comment posted to PR #<number>
  Bumps covered: <N> (<comma-separated aliases>)
  Overall recommendation: <APPROVE ALL | APPROVE WITH CONDITIONS | REQUEST CHANGES | BLOCK>
  PR: <PR URL>
```

→ Done. The skill run is complete.
