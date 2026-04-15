# Phase 7 — Run Summary Comment
<!-- Part of: bump-dependencies.md orchestrator -->
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

**Determine mode:** check the PR title to establish whether this is a proactive PR:
```
gh pr view <PR-number> --repo <owner/repo> --json title --jq '.title'
```
Record `IS_PROACTIVE=true` if the title starts with `chore(deps): bump outdated dependencies`.

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
- Remediations applied: commit hash(es) and one-line description of each fix
- Notable findings: anything worth scrutiny even if not blocking — supply-chain
  concerns, breaking changes that were auto-migrated (verify correctness),
  APPROVE WITH CONDITIONS rationale, partial fixes, deprecations left unresolved
- Items requiring human action: unresolved failures, skipped aliases, push-failed
  aliases, anything Phase 5 flagged as requiring explicit decision before merge

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

> `/bump-dependencies` · <date> · <N> bumps

<!-- EXCLUSION BANNER — include only when one or more aliases have a BLOCK verdict -->
> [!WARNING]
> **<N> dep(s) blocked**
>
> <If IS_PROACTIVE and some passed: "The following dependencies were **removed from this PR** after returning a BLOCK verdict. Only the passing deps above were merged.">
> <If IS_PROACTIVE and all blocked: omit — PR was closed by Phase 8, this comment is informational only.>
> <If NOT proactive: "The following dependencies **cannot be merged** until the issues below are resolved.">
>
> | Dependency | Reason |
> |---|---|
> | `<alias>` (`<old>` → `<new>`) | <one-line Phase 5 reason> |
>
> See the individual review comments for full details.
> <If IS_PROACTIVE: "Run `/bump-dependencies` again after addressing the issues to create a new PR.">
<!-- END EXCLUSION BANNER -->

| Alias | Old → New | Verdict |
|---|---|---|
| `<alias>` | `<old>` → `<new>` | **<VERDICT>** |
| `<alias>` | — | **Not reviewed — isolated branch push failed** |

**Overall:** <APPROVE ALL / APPROVE WITH CONDITIONS / REQUEST CHANGES / BLOCK>

**Integration tests:** <PASS | FAIL> — <suite name> <N>/<N> passing<br>
<If failed: regression introduced by `<alias>` — see bisect findings in Phase 8>

**Remediations applied:**
- `<alias>` `<short-hash>` — <one-line description, e.g. "migrated 3 DataStore usages off deprecated `preferences()` API">

_None required._

**Worth a closer look:**
- `<alias>` — <one-line flag, e.g. "breaking change in FragmentManager API — auto-migrated, verify correctness">
- `<alias>` — <one-line flag, e.g. "unsigned release tags — Rook flagged possible concern">
- `<alias>` — <one-line flag, e.g. "APPROVE WITH CONDITIONS: flaky CI job unrelated to bump, monitor next run">

_Nothing flagged._

**Needs human action:**
- `<alias>` — <one-line reason, e.g. "BLOCK: unresolved CI failure in :app:testRelease">
- `<alias>` — <one-line reason, e.g. "deprecated API in WorkManager not auto-fixed — 5 call sites require manual migration">

_None._

*Individual comments above contain full detail per bump.*
```

Rules:
- **Exclusion banner:** include whenever any alias has a BLOCK verdict. Omit
  entirely if all aliases passed. Tailor the wording to mode (proactive vs.
  dependabot/external) as shown in the template. For proactive mode with some
  passing deps, the banner explains that blocked deps were already removed from
  the PR by Phase 8 — it is informational, not a call to action.
- **Remediations applied:** include every commit where code was changed on the
  reviewer's behalf. Use `_None required._` if Phase 4 made no commits. This
  section exists so the reviewer knows what to scrutinise — code was written for
  them and they should verify it.
- **Worth a closer look:** include any finding that is non-blocking but warrants
  attention: auto-migrated breaking changes (verify correctness), supply-chain
  concerns, APPROVE WITH CONDITIONS rationale, partial remediations, deprecations
  left unresolved. Use `_Nothing flagged._` if there is nothing to flag.
- **Needs human action:** only items that require an explicit decision or manual
  work before the PR can be merged. Use `_None._` if there are none.
- Only include the bisect finding line if integration tests failed.
- Do not add a plain-English paragraph.
- Do not repeat full CI status, supply-chain tables, or breaking-change detail —
  those are in the per-bump comments.

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
  Bumps reviewed: <N> (<comma-separated aliases>)
  Merged into PR:  <N> (<passing aliases, or "none — PR closed" if all blocked>)
  Blocked:         <N> (<blocked aliases, or "none">)
  Overall: <APPROVE ALL | APPROVE WITH CONDITIONS | REQUEST CHANGES | BLOCK>
  PR: <PR URL>
```

If any aliases were blocked, append a brief note tailored to the mode:

- **Proactive, some passed:** "Blocked deps were removed from the PR. Run `/bump-dependencies` again after addressing the issues."
- **Proactive, all blocked:** "All deps blocked — PR was closed. Run `/bump-dependencies` again after addressing the issues."
- **Dependabot / external:** "Blocked deps remain in the PR. Resolve the issues flagged in the individual comments before merging."

→ Done. The skill run is complete.
