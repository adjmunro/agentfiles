# Phase 4 — Remediation
<!-- Part of: review-dependency-update.md orchestrator -->
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

## Step A — Checkout the PR Branch

If not already on the PR's head branch, check it out:

```
gh pr checkout <PR-number> --repo <owner/repo>
```

Confirm you are on the correct branch before making any changes.

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
without urgency). If the migration is low-risk and well-documented:
- Apply and commit using the same Ink process
- Prefix the commit message: `chore(deps): migrate <symbol> (deprecated in <version>)`

If the migration is ambiguous or would require significant refactoring, leave it and
note it in the Phase 5 verdict for the reviewer's attention.

## Step D — Final Test Run

Run the full test suite once more after all commits:

```
<full test suite command>
```

Record the result: total tests, passing, failing, skipped.

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

### Skipped (requires manual attention)
- `removedClass` at lib/bar.py:17 — no replacement available; architectural decision needed
```

→ Next: Read `phases/p5-verdict.md` and execute it.
