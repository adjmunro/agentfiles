# Phase 4 — Remediation
<!-- Part of: bump-dependencies.md orchestrator -->
<!-- Active when: Phase 3 found actionable usages (must-fix items) -->
<!-- Skip this phase entirely if no actionable usages were found -->
<!-- CONCURRENCY: This phase MUST run sequentially. If multiple bumps need remediation,
     the orchestrator queues them one at a time. Do not begin this phase if another
     bump's Phase 4 is still in progress — git operations are not concurrency-safe. -->

**You are now Ink (Commit Curator).** Read `../../personas/ink/persona.md` and
`../../personas/ink/soul.md` now. Your job is to replace every must-fix usage
identified in the Phase 3 impact table, then commit each fix as a clean, legible
unit of history. Stage by logical unit — not by file. Write commit messages that
explain why, not just what.

## Step A — Checkout the Isolated Branch

Check out the isolated branch for this alias group. Do **not** check out the PR
head branch — Phase 4 operates entirely on the isolated branch so that each
alias group's fixes remain independent of all other alias groups.

```
git checkout dep-review/<PR-number>/<alias>
```

If the isolated branch does not exist locally, fetch it first:

```
git fetch origin dep-review/<PR-number>/<alias>
git checkout dep-review/<PR-number>/<alias>
```

Confirm you are on the correct isolated branch before making any changes:

```
git branch --show-current
# must print: dep-review/<PR-number>/<alias>
```

> **Note:** Phase 4 must never touch the PR head branch. All commits and the
> force-push in Step F target the isolated branch only. The PR head branch is
> replaced wholesale by Phase 8 (consolidation) after all isolated branches
> have been verified.

## Step A.1 — Incorporate CI Failures into the Must-Fix List

Before working through the Phase 3 impact table, check the session brief for CI
triage results written by Phase 1 Step G.

Read `/tmp/dep-review-<PR-number>-session-brief.md` (or the in-prompt CI Status
section if the file is unavailable).

For each CI failure categorised as **API break**, **Deprecation became removal**,
or **Migration required**:
- Add it to the must-fix list for this phase, treating it with the same priority
  as a Phase 3 actionable usage
- Record the source as "CI failure" in the Remediation Summary (Step E)
- Use the root-cause summary from the CI triage table to guide the fix

For each CI failure categorised as **Test environment issue**:
- Record it in the Remediation Summary under "Skipped (advisory)"
- Do not attempt to fix it — it is not caused by the dependency change

For each CI failure categorised as **Other**:
- Record it in the Remediation Summary under "Skipped (requires manual attention)"
- Flag it explicitly so the Phase 5 verdict can account for it

If there are no CI failures (Phase 1 Step G recorded "All checks passed"), continue
directly to Step B.

## Step B — Fix Each Actionable Usage

Work through the must-fix items from the Phase 3 impact table in order. For each:

### 1. Understand the replacement

Before changing anything, confirm the correct migration path:
- Use the changelog's migration notes if present
- Consult the package documentation or README for the new API
- If no replacement exists (a removal with no equivalent), flag it explicitly and skip — do not guess

### 2. Apply the change

Make the minimum change required:
- Replace the deprecated or removed call with the recommended alternative
- Preserve the original intent and surrounding logic exactly
- Do not refactor, rename, or clean up surrounding code
- Update any type annotations, error handling, or response handling required by the new API signature

### 3. Add or update tests

For each changed call site:
- Confirm an existing test exercises the changed code path
- If no test exists, add a focused unit test that verifies the new behaviour
- If existing tests mock the deprecated API, update the mock to the new API

Run the relevant test suite to confirm the change does not break anything:

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

### 4. Commit atomically (Ink)

Once tests pass, stage by logical unit (use `git add -p` if a file contains
unrelated changes), then commit:

```
git add <affected files>
git commit -m "fix(deps): replace <deprecated-symbol> with <replacement> after <package> bump to <new-version>

<body: why this API was deprecated, what the replacement provides, link to
changelog entry or migration guide>"
```

Review the diff before staging — do not include unrelated changes. Verify
with `git log --oneline` after each commit that the sequence reads coherently.

### 5. Repeat

Move to the next actionable usage and repeat Steps 1–4.

## Step C — Advisory Migrations (optional)

After all must-fix items are committed, assess the advisory usages (deprecations
without urgency). Apply the migration if ALL of the following are true:
- The replacement API is documented in the changelog with a code example or migration guide
- The total number of call sites is ≤3, OR all call sites are structurally identical (copy-paste)
- The migration is a pure rename or equivalent-replacement: the new API accepts the
  same input types and returns the same output type, OR the changelog explicitly
  states "no behaviour change" (or equivalent) for this symbol

If any of these conditions is false, leave it and note it in the Phase 5 verdict
for the reviewer's attention. If the conditions are met:
- Apply and commit using the same Ink process
- Prefix the commit message: `chore(deps): migrate <symbol> (deprecated in <version>)`

## Step D — Final Test Run

Run the full test suite once more after all commits:

```
<full test suite command>
```

Record the result: total tests, passing, failing, skipped.

## Step D.1 — CI Re-check (if CI was failing at Phase 1)

If Phase 1 Step G recorded any CI failures, wait for CI to re-run on the new commits
(or trigger it manually if required by the project). Then fetch the updated check status:

```
gh pr checks <PR-number> --repo <owner/repo>
```

> **Re-check scope:** `gh pr checks <PR-number>` returns CI status for the PR head
> branch commit — not for the isolated branch `dep-review/<PR-number>/<alias>`.
> Since Phase 4 operates on the isolated branch, this result reflects the original
> PR commits (pre-remediation). Post-remediation CI is only observable on the
> isolated branch if the project runs CI on `dep-review/*` branches, or after Phase 8
> merges isolated branches onto the PR head branch. **Record the data source**
> ("PR head branch CI" or "isolated branch CI") in Step E's CI Status After
> Remediation table so Phase 5 knows what scope the data covers.

Record the updated result for each previously failing job:
- **Now passing** — record as resolved in the Remediation Summary
- **Still failing** — record as unresolved; this blocks the Phase 5 verdict from
  approving unless the failure is categorised as "Test environment issue"
- **Not yet complete (pending)** — note as pending; Phase 5 will apply the +2
  "re-check pending" scoring signal (see Phase 5 scoring matrix)

## Step F — Force-Push the Isolated Branch

> **Step ordering note:** Step F (Force-Push) appears in this file after Step D.1 and
> before Step E (Remediation Summary). This ordering is intentional — the isolated branch
> is pushed first so that the summary written in Step E can reference the final pushed
> state. Continue to Step E after completing this step.

After all commits are made and tests pass, push the isolated branch to the remote:

```
git push --force-with-lease origin dep-review/<PR-number>/<alias>
```

Use `--force-with-lease` to fail safely if the remote has been updated since
checkout. This ensures no commits from other agents are silently discarded.

If the push is rejected:
1. Run `git fetch origin dep-review/<PR-number>/<alias>` to retrieve the remote state.
2. Run `git log --oneline origin/dep-review/<PR-number>/<alias>` to inspect what changed.
3. **If the remote tip is the cherry-pick commit from Phase 1b** (no new commits beyond
   base + cherry-pick): the rejection is a stale lease from the Phase 1b push — update
   the lease and retry **once**:
   ```
   git push --force-with-lease=dep-review/<PR-number>/<alias>:$(git rev-parse origin/dep-review/<PR-number>/<alias>) \
     origin dep-review/<PR-number>/<alias>
   ```
4. **If the remote has unexpected commits** (commits not made by this run): stop and
   report: "Force-push rejected on `dep-review/<PR-number>/<alias>` — unexpected remote
   commits detected. Manual inspection required before proceeding."
5. Do not attempt a second retry. If the single retry also fails, stop and report.

> **Do not push to the PR head branch.** Phase 8 (consolidation) is responsible
> for merging all verified isolated branches onto a fresh consolidation branch
> and force-pushing that to replace the PR head branch. Phase 4 must never write
> to the PR head branch directly.

## Step E — Write the Remediation Summary

```
## Remediation: <package-name>

### Commits Made
| Commit | Description |
|---|---|
| <short-hash> | fix(deps): replace `oldFn` with `newFn` after <package> bump |
| ... | ... |

### Test Results
- Suite: <name> — <N>/<N> passing

### CI Status After Remediation
| Job | Before | After | Notes |
|---|---|---|---|
| <job-name> | fail | pass | Fixed by commit <hash> |
| <job-name> | fail | fail | Unresolved — requires manual attention |
| (if no CI failures were recorded in Phase 1, write: "CI was passing at Phase 1 — no re-check required.") | | | |

### Skipped (requires manual attention)
- `removedClass` at lib/bar.py:17 — no replacement available; architectural decision needed
- CI job `<name>` — categorised as "Other"; root cause: <summary>
```

→ Next: Read `phases/p5-verdict.md` and execute it.
