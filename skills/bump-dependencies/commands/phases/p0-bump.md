# Phase 0 — Discover & Bump
<!-- Part of: bump-dependencies.md orchestrator -->
<!-- Active when: no argument passed — proactive mode -->

**You are now Ink (Commit Curator).** Your job in this phase is to discover outdated
dependencies, verify each update is safe, annotate version definitions with changelog
hyperlinks, bump each dependency to its latest safe version, and commit each bump
atomically. Do not investigate, score, or post PR comments here — that is Phases 2–7.

---

## Step A — Prerequisites

> **Prerequisite check:** this phase requires a GitHub-hosted repository and an
> authenticated `gh` CLI session. Verify both before proceeding.

Run:

```
git remote get-url origin
```

Parse the SSH or HTTPS remote URL to derive `owner/repo`.

**If the remote URL domain is not `github.com`**: stop and advise the user that this
skill requires a GitHub repository and a `gh` CLI session.

**Verify `gh` authentication:**

```
gh auth status
```

If not authenticated, stop and ask the user to run `gh auth login` first.

Verify the working tree is clean before creating a branch:

```
git status --porcelain
```

If there are uncommitted changes, stop and ask the user to stash or commit them first.

Record today's date as `BUMP_DATE` in `YYYY-MM-DD` format.

---

## Step B — Create a Working Branch

```
git checkout -b deps/auto-bump-<BUMP_DATE>
```

If a branch with this name already exists locally or remotely, append a short suffix
(e.g. `-2`, `-3`) to make it unique.

Record the branch name as `BUMP_BRANCH`.

---

## Step C — Discover Version Files

Scan the repository for the following known version-definition files. Record each one
found as a **source file**:

| Source | Typical paths |
|---|---|
| Gradle version catalogue | `gradle/libs.versions.toml`, `app/gradle/libs.versions.toml` |
| GitHub Actions workflows | `.github/workflows/*.yml`, `.github/workflows/*.yaml` |
| Gradle wrapper | `gradle/wrapper/gradle-wrapper.properties` |
| Root Gradle build scripts | `build.gradle.kts`, `build.gradle` (root only — do not scan module files) |

For each source file found, proceed to the relevant section below. Process all source
files before moving to Step D.

---

## Step C.1 — Gradle Version Catalogue (`libs.versions.toml`)

Read the file in full.

**Parse `[versions]`:** extract every alias and its current version string.

**Resolve each alias to Maven coordinates:**

1. Search the `[libraries]` section for entries where `version.ref = "<alias>"`.
   Extract `group` and `name` (or split the `module` field on `:`).
2. Search the `[plugins]` section for entries where `version.ref = "<alias>"`.
   Extract the plugin `id`.
3. If no `[libraries]` or `[plugins]` entry references the alias, it may be a
   BOM alias or an indirect version — note it as **unresolved** and skip it.

**For each resolved alias**, record:
- `alias` — the key in `[versions]`
- `current_version` — the value currently in the file
- `coordinates` — Maven `group:artifact` or Gradle plugin ID
- `ecosystem` — `maven` or `gradle-plugin`

---

## Step C.2 — GitHub Actions Workflows

Read each workflow file found.

**Parse every `uses:` line** to extract action references. Each `uses:` value has the form:

```
owner/action@ref
```

where `ref` is a version tag (e.g. `v4`, `v4.2.1`) or a commit SHA.

**Skip SHA-pinned refs** (40-character hex strings) — these are intentional security
pins and must not be auto-bumped. Record them as **skipped (SHA pin)**.

**Skip `docker://` and `./local/path` references** — not version-bumped here.

For each tag-pinned action, record:
- `action` — `owner/action` (e.g. `actions/checkout`)
- `current_ref` — the tag as written (e.g. `v4`, `v4.2.1`)
- `file` — the workflow file path
- `line` — line number of the `uses:` entry

---

## Step C.3 — Gradle Wrapper

Read `gradle/wrapper/gradle-wrapper.properties`.

Extract the current Gradle version from the `distributionUrl` line, e.g.:

```
distributionUrl=https\://services.gradle.org/distributions/gradle-8.6-bin.zip
```

→ current version `8.6`.

Record as a single entry with ecosystem `gradle-wrapper`.

---

## Step D — Look Up Latest Safe Versions

For each recorded dependency, perform the following checks. **The safety rule is
absolute: never bump to a version published less than seven days ago.** Calculate
"seven days ago" relative to `BUMP_DATE`.

### Maven / Gradle Plugin Portal

For Maven libraries, query Maven Central:

```
https://search.maven.org/solrsearch/select?q=g:<group>+AND+a:<artifact>&core=gav&rows=1&wt=json
```

This returns the latest version and its `timestamp` (Unix milliseconds).

For Gradle plugins, query the Gradle Plugin Portal:

```
https://plugins.gradle.org/api/plugin/<plugin-id>/version
```

Extract the latest version and its publication date.

**If the API returns a version published within the last seven days**, skip it and
record: "Latest version `<ver>` published `<date>` — too recent (< 7 days), skipped."
Use the most recent version older than seven days instead. If no such version exists
(i.e. the library has never had a release older than one week), skip the dependency
entirely and record it as **skipped (no safe version available)**.

### GitHub Actions

Query the GitHub Releases API for the latest release:

```
gh api repos/<owner>/<action>/releases/latest
```

Extract `tag_name` and `published_at`.

**If `published_at` is within the last seven days**, apply the same fallback logic:
scan for the most recent release older than seven days using:

```
gh api repos/<owner>/<action>/releases?per_page=20
```

If the current ref uses major-version pinning (e.g. `v4`), find the latest patch
release within that major series that is also older than seven days. Only upgrade
across major versions if the current major series has no newer safe releases.

### Gradle Wrapper

Query the Gradle services API:

```
https://services.gradle.org/versions/all
```

Filter to stable releases only (exclude `-rc`, `-milestone`, `-nightly` suffixes).
Sort by version descending. Select the newest release whose `buildTime` is older than
seven days.

---

## Step E — Determine Changelog URL

For each dependency that has a safe update available, find the canonical changelog
URL to annotate into the version file. Use the known-sources table from Phase 2
(`phases/p2-investigate.md`) as the primary lookup.

**Known-source lookup order:**

1. Check the library family against the Kotlin/Android primary sources table in
   `phases/p2-investigate.md` (read only the table section — do not execute Phase 2).
2. **GitHub Releases page** for the action or library repository:
   `https://github.com/<owner>/<repo>/releases`
3. **Maven Central artifact page** (fallback for Maven):
   `https://central.sonatype.com/artifact/<groupId>/<artifactId>`
4. If no specific changelog is locatable, use the Maven Central search URL:
   `https://search.maven.org/artifact/<groupId>/<artifactId>`

Record the resolved changelog URL as `changelog_url` for each dependency.

---

## Step F — Apply Bumps

For each dependency that has a safe update available (`current_version` ≠ `safe_latest`),
apply the following edits and commits **one dependency at a time**.

> **Do not batch multiple dependency bumps into a single commit.** Each alias or action
> gets exactly one commit.

### libs.versions.toml — editing rules

Locate the version line for the alias in the `[versions]` section. The line will look
like one of:

```toml
kotlin = "1.9.22"
kotlin = "1.9.22" # https://existing-comment.example.com
```

**Edit the line in place** to:
1. Replace the version string with `safe_latest`.
2. If there is no trailing `# https://...` comment, append ` # <changelog_url>`.
3. If there is already a trailing `# https://...` comment, replace its URL with
   `changelog_url`.

Example result:

```toml
kotlin = "2.0.21" # https://kotlinlang.org/docs/releases.html
```

Do not reformat any other part of the file.

### GitHub Actions workflows — editing rules

Locate each `uses:` line for this action. Replace only the `@ref` portion:

```yaml
- uses: actions/checkout@v4.2.1 # https://github.com/actions/checkout/releases
```

If the line has no trailing comment, add one. If a comment exists, update it.

For major-version-pinned refs (e.g. `uses: actions/checkout@v4`): preserve the
major-pin style — update to the new major version tag if a major upgrade is available,
or leave the major pin unchanged if the bump is within the same major.

### gradle-wrapper.properties — editing rules

Update the `distributionUrl` line to point to the new version:

```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-<safe_latest>-bin.zip
```

Add a comment line **immediately above** the `distributionUrl` line (`.properties`
format does not support trailing inline comments):

```properties
# Release notes: https://docs.gradle.org/<safe_latest>/release-notes.html
distributionUrl=https\://services.gradle.org/distributions/gradle-<safe_latest>-bin.zip
```

If a `# Release notes:` comment line already exists immediately above `distributionUrl`,
update its URL. Do not add a second comment line.

---

## Step G — Commit Each Bump

After editing the file(s) for a single dependency, stage the modified file(s) and
create a commit:

```
git add <modified-files>
git commit -m "chore(deps): bump <alias-or-action> from <old> to <new>"
```

The commit body (optional) may include the changelog URL and a one-sentence summary
of the release if it is immediately available from the API response. Keep it concise.

Repeat Steps F and G for every dependency with a safe update, in this order:
1. `libs.versions.toml` entries — alphabetical by alias
2. GitHub Actions — alphabetical by `owner/action`
3. Gradle wrapper — last

If no dependencies have safe updates, print a summary and stop:

> "All dependencies are up to date (or no safe version is available for those that
> are not). No commits made."

Do not proceed to Step H if no commits were made.

---

## Step H — Push Branch and Open PR

Push the branch:

```
git push -u origin <BUMP_BRANCH>
```

Create the PR:

```
gh pr create \
  --title "chore(deps): bump outdated dependencies (<BUMP_DATE>)" \
  --body "$(cat <<'BODY'
## Automated dependency bumps

Generated by `/bump-dependencies` on <BUMP_DATE>.

### Bumps included

| Dependency | From | To | Changelog |
|---|---|---|---|
<table rows — one per bumped dependency>

### Safety note

No dependency in this PR was bumped to a version published fewer than seven days
before this PR was created. This policy guards against supply-chain attacks that
exploit the window between a package being compromised and detection.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
BODY
)"
```

Record the PR number from the `gh pr create` output.

Print to the user:

> "Phase 0 complete. Opened PR #<number> with <N> dependency bump(s). Proceeding to
> Phase 1 to run the full review pipeline."

---

## Step I — Bump Summary

Before handing off, print a concise summary table:

```
### Proactive Bump Summary

| Dependency | Old | New | Changelog |
|---|---|---|---|
| <alias/action> | <old> | <new> | <url> |
...

Skipped (too recent):  <list or "none">
Skipped (up to date):  <list or "none">
Skipped (unresolved):  <list or "none">
Skipped (SHA pin):     <list or "none">

Branch: <BUMP_BRANCH>
PR:     #<number>
```

→ Next: hand the PR number to the orchestrator. The orchestrator will read
`phases/p1-parse.md` and execute the full review pipeline against PR #<number>.
