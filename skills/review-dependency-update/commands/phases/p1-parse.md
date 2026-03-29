# Phase 1 — Parse & Fetch
<!-- Part of: review-dependency-update.md orchestrator -->
<!-- Active when: command is first invoked -->

## Step A — Resolve the Repository

If the argument contains a full GitHub URL, extract `owner/repo` from the path.
If no repo was specified, run:

```
git remote get-url origin
```

Parse the SSH or HTTPS remote URL to derive `owner/repo`.

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

→ Next: Read `phases/p2-investigate.md` and execute it for the first dependency in the list.
