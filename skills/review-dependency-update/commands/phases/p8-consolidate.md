# Phase 8 — Consolidate
<!-- Part of: review-dependency-update.md orchestrator -->
<!-- Active when: All Wave 3 agents (Phases 5–6) have completed -->
<!-- Run by: the orchestrator only — never by a per-bump sub-agent -->
<!-- This phase merges all verified isolated branches directly into the PR head
     branch and pushes it, then deletes all working branches. -->

This phase is the last operation that touches git. It runs once, after all
per-bump agents have completed Phases 5 and 6. The orchestrator (not a sub-agent)
executes every step in sequence.

---

## Step A — Reset the PR Head Branch to Base

Work directly on the PR head branch rather than creating a separate consolidation
branch. Fetch the current remote state, check it out, then rewind it to the base
branch tip so the isolated branches can be merged onto a clean slate:

```
git fetch origin <head-branch> <base-branch>
git checkout <head-branch>
git reset --hard origin/<base-branch>
```

Confirm you are on the correct branch and at the base tip:

```
git branch --show-current
# must print: <head-branch>
git log --oneline -1
# must match HEAD of origin/<base-branch>
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

**All-skipped early exit:** If every alias was skipped (i.e., the merge results list
contains only `skipped` entries), do **not** proceed to Steps C, D, or E. The
branch has been reset to base but has no new changes — running the test suite
would be meaningless and pushing would overwrite the PR head with a no-op.
Instead:
- Write to Step G: "All aliases were skipped — no isolated branches were merged."
- Proceed directly to Step F (cleanup) to delete all isolated branches.
- In Step G Notes field: "PR head branch was not modified — all bumps were flagged
  as BLOCK or unverified by Phase 5. Manual review required before merging."

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
     git checkout <head-branch>
     ```

If bisection cannot isolate a single alias (e.g., the failure only occurs when
two alias groups are present together), record that finding explicitly. Then
return to the HEAD of the consolidated branch before continuing:

```
git checkout <head-branch>
```

---

## Step E — Force-Push the PR Head Branch

Push the updated `<head-branch>` to the remote. A force-push is required because
Step A rewound the local history past the original dependabot commits:

```
git push --force-with-lease origin <head-branch>
```

Use `--force-with-lease` to fail safely if the remote has moved since Phase 1b.
If the push is rejected:

1. Run `git fetch origin <head-branch>` to retrieve the current remote state.
2. Run `git log --oneline origin/<head-branch>` to inspect what changed.
3. **If the remote tip matches the PR's original head commit** (i.e., no human has
   pushed to the branch since Phase 1b): the rejection is a stale lease artefact —
   update the lease and retry once:
   ```
   git push --force-with-lease=<head-branch>:$(git rev-parse origin/<head-branch>) \
     origin <head-branch>
   ```
4. **If the remote has new commits not from this run** (i.e., a human or another
   process pushed after Phase 1b): do **not** retry. Stop and report:
   > "Consolidation push rejected — `<head-branch>` has new commits on the remote
   > that were not part of this review run. Re-run Phase 8 after reconciling the
   > remote changes, or push manually."
   Record this in Step G under Notes and proceed to Step F (cleanup only).

Do not use `--force` without `--lease` under any circumstance.

After a successful push, confirm the remote head branch matches the local tip:

```
gh pr view <PR-number> --repo <owner/repo> --json headRefOid --jq '.headRefOid'
```

---

## Step F — Clean Up Working Branches

All `dep-review/<PR-number>/<alias>` isolated branches have served their purpose.
Delete each one — remote and local:

```
git push origin --delete dep-review/<PR-number>/<alias> 2>/dev/null || true
git branch -D dep-review/<PR-number>/<alias> 2>/dev/null || true
```

Repeat for each alias in the manifest (merged and skipped alike).

After all isolated branches are deleted, check out the base branch and delete the
local copy of the PR head branch. The remote was updated by Step E; the local copy
can be re-fetched with `gh pr checkout` if further changes are needed:

```
git checkout <base-branch>
git branch -D <head-branch>
```

Do **not** delete the remote `<head-branch>` — it is the PR head and must remain.

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

Also write the consolidation summary to a temp file for Phase 7:

```
cat > /tmp/dep-review-<PR-number>-consolidation-summary.md << 'EOF'
<consolidation summary markdown>
EOF
```

If the write fails (e.g., `/tmp` is not writable), proceed without writing and
note: "Consolidation summary not persisted — Phase 7 will use in-context data."

→ Next: Read `phases/p7-summary.md` and execute it. Pass the consolidation
summary above alongside the collected Phase 5 verdict data.
