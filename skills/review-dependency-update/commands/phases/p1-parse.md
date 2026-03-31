# Phase 1 — Parse & Fetch
<!-- Part of: review-dependency-update.md orchestrator -->
<!-- Active when: command is first invoked -->

## Step A — Resolve the Repository

The argument is a bare PR number. Run:

```
git remote get-url origin
```

Parse the SSH (`git@github.com:owner/repo.git`) or HTTPS
(`https://github.com/owner/repo.git`) remote URL to derive `owner/repo`.

If the argument is hash-prefixed (`#1509`) or a full GitHub URL, strip the prefix
to extract the number and, if present in the URL, override the inferred `owner/repo`.

## Step B — Fetch PR Metadata

Run:

```
gh pr view <PR-number> --repo <owner/repo> --json number,title,body,headRefName,baseRefName,files,author,createdAt,url
```

Record:
- PR number, title, and URL
- Author and creation date
- Head and base branches

## Step C — Identify Changed Dependency Files

From the `files` field, filter for known dependency manifest formats:

| Ecosystem | Files |
|---|---|
| npm / Yarn | `package.json`, `package-lock.json`, `yarn.lock` |
| Python | `requirements*.txt`, `Pipfile`, `pyproject.toml`, `setup.cfg` |
| Ruby | `Gemfile`, `Gemfile.lock` |
| Go | `go.mod`, `go.sum` |
| Rust | `Cargo.toml`, `Cargo.lock` |
| Java / Kotlin | `build.gradle`, `build.gradle.kts`, `pom.xml`, `libs.versions.toml` |
| Swift | `Package.swift`, `Package.resolved` |
| PHP | `composer.json`, `composer.lock` |
| .NET | `*.csproj`, `*.fsproj`, `packages.config`, `Directory.Packages.props` |

Fetch the diff for each matched file:

```
gh pr diff <PR-number> --repo <owner/repo> -- <file-path>
```

## Step D — Extract Dependency Changes

Parse each diff to extract the changed packages. For each package, record:

- **Package name** (e.g., `lodash`, `com.squareup.okhttp3:okhttp`, `tokio`)
- **Old version** (removed line)
- **New version** (added line)
- **Ecosystem** (npm, PyPI, Maven, crates.io, etc.)
- **Change type**: upgrade / downgrade / new addition / removal

If the diff shows only lock-file changes with no manifest change (e.g., transitive dependency), note that it is a transitive update and record the dependency chain if determinable.

## Step E — Write the Session Brief

Produce a summary block for use in subsequent phases:

```
## Dependency Review — Session Brief
PR: <owner/repo>#<number> — <title>
URL: <url>
Author: <author>
Date: <created-at>

### Dependencies to Review
| # | Package | Ecosystem | Old → New | Type |
|---|---------|-----------|-----------|------|
| 1 | <name> | <ecosystem> | <old> → <new> | upgrade |
...
```

Print the brief to the user.

## Step F — Rename the Session

Rename the current Claude Code session to reflect the PR being reviewed:

```
/rename PR #<number> - <PR title>
```

→ Next: Read `phases/p1b-split-commits.md` and execute it.
