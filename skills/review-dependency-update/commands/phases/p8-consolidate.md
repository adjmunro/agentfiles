# Phase 8 — Consolidate
<!-- Part of: review-dependency-update.md orchestrator -->
<!-- Active when: All Wave 3 agents (Phases 5–6) have completed -->
<!-- Run by: the orchestrator only — never by a per-bump sub-agent -->
<!-- This phase merges all verified isolated branches into a single consolidated
     branch and replaces the PR head branch. -->

This phase is the last operation that touches git. It runs once, after all
per-bump agents have completed Phases 5 and 6. The orchestrator (not a sub-agent)
executes every step in sequence.

---

## Step A — Create the Consolidation Branch

Create a fresh branch forked from the **base branch** (not the current PR head).
This branch will accumulate each alias group's verified commits in manifest order.

```
git fetch origin <base-branch>
git checkout origin/<base-branch>
git checkout -b dep-review/<PR-number>/consolidated
```

Confirm you are on the correct branch:

```
git branch --show-current
# must print: dep-review/<PR-number>/consolidated
```

---

## Step B — Merge Each Isolated Branch in Manifest Order

For each alias in the manifest, in the order they were recorded:

1. **Check the alias's verdict from Phase 5.** If the isolated branch for this
   alias was flagged as unverified or failed (i.e., Phase 5 returned BLOCK or
   the agent reported it could not remediate), skip it and record it as skipped:

   ```
   Skipped: dep-review/<PR-number>/<alias> — Phase 5 verdict: <BLOCK | unverified>
   ```

   Do not block consolidation for other aliases — continue to the next entry.

2. **Merge the verified isolated branch** using a non-fast-forward merge so each
   alias group's contribution is traceable in the consolidated history:

   ```
   git merge --no-ff dep-review/<PR-number>/<alias> \
     -m "merge(deps): consolidate <alias> bump (<old> → <new>)"
   ```

3. **If the merge produces a conflict** (e.g., two alias groups edited adjacent
   lines in `libs.versions.toml`), resolve it by accepting both sets of changes —
   each alias's version line is independent. Commit the resolution, then continue.

4. Record the merge result for Step G:
   - Alias name
   - Merge outcome: `clean` | `conflict resolved` | `skipped`
   - The merge commit hash (if merged)

---

## Step C — Run the Full Integration Test Suite

After all non-skipped isolated branches are merged, run the full integration test
suite on the consolidated branch:

```
<infer test command from project files:
 Package.swift → swift test
 build.gradle / build.gradle.kts → ./gradlew test
 package.json → npm test
 Makefile → make test
 pytest.ini / pyproject.toml → pytest
 go.mod → go test ./...
 Cargo.toml → cargo test>
```

Record the result:
- Total tests, passing, failing, skipped
- Whether the suite passed or failed overall

If the suite passes: proceed to Step E.
If the suite fails: proceed to Step D (bisect).

---

## Step D — Bisect on Integration Test Failure

If the full integration test suite fails, identify which alias group introduced
the regression by re-running tests at each merge point in the consolidated branch.

For each alias merge point (from oldest to newest in consolidation order):

1. Check out the consolidated branch at the merge commit for this alias:

   ```
   git checkout <merge-commit-hash-for-alias>
   ```

2. Run the full integration test suite at that point.

3. Record the result for this alias:
   - Suite result: `pass` | `fail`
   - First alias at which the suite transitions from `pass` to `fail` is the
     **regression introducer**

4. After identifying the regression introducer:
   - Record the finding in the consolidation summary (Step G)
   - Do **not** automatically skip the regression-introducing alias — flag it
     explicitly so a human can decide whether to exclude it or investigate further
   - Return to the HEAD of the consolidated branch:

     ```
     git checkout dep-review/<PR-number>/consolidated
     ```

If bisection cannot isolate a single alias (e.g., the failure only occurs when
two alias groups are present together), record that finding explicitly.

---

## Step E — Force-Push to Replace the PR Head Branch

Push the consolidation branch to the remote, replacing the PR head branch:

```
git push --force-with-lease origin \
  dep-review/<PR-number>/consolidated:<head-branch>
```

Use `--force-with-lease` to fail safely if the remote has moved. If the push is
rejected, fetch and inspect the remote state before retrying — do not use
`--force` without `--lease`.

After a successful push, confirm the PR head branch now points to the
consolidation branch's tip:

```
gh pr view <PR-number> --repo <owner/repo> --json headRefOid --jq '.headRefOid'
```

---

## Step F — Clean Up Isolated Branches

Delete each remote isolated branch that was successfully merged in Step B.
Skipped branches are also deleted — they will not be merged and their purpose
is complete.

```
git push origin --delete dep-review/<PR-number>/<alias>
```

Repeat for each alias in the manifest. Do not delete the consolidation branch
(`dep-review/<PR-number>/consolidated`) — it now backs the PR head branch.

---

## Step G — Write the Consolidation Summary

Record a structured summary for use by Phase 7. This summary supplements the
per-bump Phase 5 verdict data.

```
## Consolidation Summary

### Merge Results
| Alias | Isolated Branch | Merge Outcome | Merge Commit |
|---|---|---|---|
| <alias> | dep-review/<PR-number>/<alias> | clean \| conflict resolved \| skipped | <short-hash or "—"> |

### Integration Test Result
- Suite: <name> — <N>/<N> passing — **PASS** | **FAIL**

### Bisect Findings (if integration tests failed)
| Alias | Suite Result at Merge Point | Notes |
|---|---|---|
| <alias> | pass \| fail | <e.g., "regression introduced here" or "—"> |

### Skipped Alias Groups
<list of aliases skipped due to Phase 5 BLOCK or unverified status, or "None">

### Notes
<any conflict resolutions, edge cases, or manual actions required>
```

→ Next: Read `phases/p7-summary.md` and execute it. Pass the consolidation
summary above alongside the collected Phase 5 verdict data.
