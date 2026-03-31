# Phase 1b — Split Commits
<!-- Part of: review-dependency-update.md orchestrator -->
<!-- Active when: Phase 1 complete — always runs as a check, skips if already atomic -->

**You are Ink (Commit Curator).** Read `../../personas/ink/persona.md` and
`../../personas/ink/soul.md` now. Your job is to ensure each dependency bump
lives in its own commit before investigation begins. A bundled bump commit is
harder to bisect, harder to revert selectively, and obscures which change
introduced a regression.

## Step A — Inspect the PR Commits

Fetch the commits on the PR branch that are not on the base branch:

```
gh pr view <PR-number> --repo <owner/repo> --json commits \
  --jq '.commits[] | {oid: .oid, message: .messageHeadline}'
```

For each commit, check whether it touches more than one dependency manifest
(package.json, go.mod, Cargo.toml, etc.) with bumps to multiple unrelated packages.

A commit is **already atomic** if it bumps exactly one package (or one group of
related packages — see grouping rules below). If every bump commit in the PR is
already atomic, print:

> Commits are already atomic — no splitting required.

Skip to `→ Next` immediately.

## Step B — Identify Bundles

A **bundle** is a single commit that bumps two or more packages that are not
meaningfully related to each other.

### Grouping rules (bumps that belong together)

Keep the following in the same commit:
- **Same library family** — packages sharing an npm scope, Maven groupId, or
  PyPI namespace (e.g., `@babel/core` + `@babel/preset-env`; `com.squareup.okhttp3:*`)
- **Coordinated release** — packages that always version-lock together
  (e.g., `react` + `react-dom`; `boto3` + `botocore`; `eslint` + `eslint-plugin-*`
  when bumped to the same version)
- **Same version-catalog entry** — packages declared in a shared BOM or
  `libs.versions.toml` entry that moves as one unit

Everything else is unrelated and must be separated into its own commit.

## Step C — Plan the Split

For each bundle identified in Step B, produce a split plan:

```
Bundle: commit <short-hash> — "<original message>"
  → Commit 1: <package-a> <old> → <new>  [e.g., "chore(deps): bump lodash 4.17.20 → 4.17.21"]
  → Commit 2: <package-b> <old> → <new>  [e.g., "chore(deps): bump react 17.0.2 → 18.3.1"]
  → Commit 3: <package-c> + <package-d>  [related group — same commit]
```

Print the plan to the user before making any changes.

## Step D — Checkout and Rewrite

Check out the PR branch:

```
gh pr checkout <PR-number> --repo <owner/repo>
```

For each bundle commit (working oldest-first if multiple exist):

1. **Soft-reset** the bundle commit to unstage its changes while preserving the
   working tree:
   ```
   git reset --soft HEAD~1
   ```

2. **Stage and commit each group separately** using `git add -p` or targeted
   `git add <files>` to isolate only the manifest and lock-file changes for that
   package (or package group). Follow Ink's commit discipline:
   - Subject: `chore(deps): bump <package> <old> → <new>`
   - Body: one line stating what the bump covers
     (e.g., `Routine patch bump; no API changes. Separated for bisect traceability.`)
   - Do not stage unrelated source changes — only manifest and lock-file lines
     belonging to this package

3. Repeat until all groups from the bundle are committed.

4. Verify the sequence with `git log --oneline` — each commit should be
   independently meaningful and non-overlapping.

## Step E — Force-Push

Once all bundle commits have been replaced with atomic commits:

```
git push --force-with-lease origin <head-branch>
```

Use `--force-with-lease`, not `--force`, to fail safely if the remote has
received new commits since checkout.

## Step F — Report

Print a summary of what changed:

```
Split complete.
  <short-hash-before> → <short-hash-1>, <short-hash-2> — <package-a> / <package-b>
  (repeat for each bundle rewritten)
Branch force-pushed: <head-branch>
```

→ Next: Read `phases/p2-investigate.md` and execute it for the first dependency
in the session brief.
