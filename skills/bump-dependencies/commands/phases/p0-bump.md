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
| Local composite actions | `.github/actions/**/action.yml`, `.github/actions/**/action.yaml` |
| Gradle wrapper | `gradle/wrapper/gradle-wrapper.properties` |
| Root Gradle build scripts | `build.gradle.kts`, `build.gradle` (root only — do not scan module files) |

Also search the repository for any `libs.versions.toml` files at non-standard paths
using a broad glob (`**/libs.versions.toml`). Add any found at paths not already
listed in the table above to the source file list, noting their path. This covers
composite-build layouts where version catalogues live under `build-logic/`,
`buildSrc/`, or other included-build roots.

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
   Include it in the Step I summary under "Skipped (unresolved)" and add a note
   in the PR body row: "BOM/indirect — transitive dependency versions not checked;
   manual review recommended."

**For each resolved alias**, record:
- `alias` — the key in `[versions]`
- `current_version` — the value currently in the file
- `coordinates` — Maven `group:artifact` or Gradle plugin ID
- `ecosystem` — `maven` or `gradle-plugin`

---

## Step C.2 — GitHub Actions (Workflows and Local Composite Actions)

Read each workflow file (`.github/workflows/*.yml` / `*.yaml`) and each local
composite action file (`.github/actions/**/action.yml` / `action.yaml`).

**Parse every `uses:` line** to extract action references. Each `uses:` value has
one of these forms:

| Form | Example | Treatment |
|---|---|---|
| SHA-pinned with tag comment | `owner/action@abc123 # v4.2.1` | Bump — resolve latest safe tag to SHA |
| SHA-pinned without comment | `owner/action@abc123def456...` | Bump — identify current version, then resolve latest safe tag to SHA |
| Tag-pinned (any form) | `owner/action@v4.2.1`, `owner/action@v4` | Bump and convert to SHA pin |
| `docker://` or `./local/path` | — | Skip — not managed here |

**SHA pinning is the target format for all GitHub Actions**, regardless of how they
are currently pinned. Always find the globally latest safe release (not just the latest
within the current major). The 7-day safety window is the only constraint; do not
restrict bumps to within the same major version.

For each action to process, record:
- `action` — `owner/action` (e.g. `actions/checkout`)
- `current_ref` — the SHA or tag as written
- `current_version` — the tag comment if present, or the tag itself; for bare SHAs
  with no comment, leave blank (will be populated from the API in Step D)
- `file` — the file path
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

## Step C.4 — Root Gradle Build Scripts

Read each root build script (`build.gradle.kts`, `build.gradle`).

Scan for top-level version variable declarations:
- **Kotlin DSL**: lines matching `val <name> = "<X.Y.Z>"` or `val <name>: String = "<X.Y.Z>"`
- **Groovy DSL**: lines matching `ext.<name> = "<X.Y.Z>"` or entries inside an `ext { }` block

For each candidate version variable, search the same file for where it is used to determine the dependency it controls (e.g., `implementation("com.example:lib:$kotlinVersion")`). If the dependency's Maven coordinates or Gradle plugin ID are identifiable, record the entry with `ecosystem: maven` or `gradle-plugin`. If not, record it as **unresolved** and skip.

If the root build script contains no top-level version declarations (all versions are managed via `libs.versions.toml`), skip with no entries recorded.

---

## Step D — Look Up Latest Safe Versions

**The safety rule is absolute: never bump to a version published less than seven days
ago.** Calculate "seven days ago" relative to `BUMP_DATE`.

Use the batched lookup strategies below to minimise API round trips. Do not make
individual calls per dependency when a batch approach is available.

### Maven and Gradle Plugin Portal — parallel batch

Generate a shell script from the full list of Maven and Gradle plugin dependencies
collected in Steps C.1, then run it in one pass. The script fetches all versions
concurrently and emits a tab-separated table:

```bash
#!/usr/bin/env zsh
fetch_maven() {
  local group=$1 artifact=$2
  local url="https://search.maven.org/solrsearch/select?q=g:${group}+AND+a:${artifact}&core=gav&rows=5&wt=json"
  curl -sf "$url" | python3 -c "
import sys, json
data = json.load(sys.stdin)
docs = data['response']['docs']
for d in docs:
    print(d['g'] + ':' + d['a'], d['v'], d.get('timestamp', 0), sep='\t')
"
}
fetch_plugin() {
  local plugin_id=$1
  local url="https://plugins.gradle.org/api/plugin/${plugin_id}/version"
  curl -sf "$url" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print('${plugin_id}', d['version'], d.get('date',''), sep='\t')
"
}
# --- generated entries ---
fetch_maven  com.squareup.okhttp3  okhttp &
fetch_plugin com.android.tools.build.gradle &
# ... one line per dependency
wait
```

Output columns: `coordinates | version | timestamp_ms_or_date`.

Parse the output to find the newest entry per coordinate older than seven days.
**Exclude pre-release versions** before applying the 7-day check: discard any version
string containing `-alpha`, `-beta`, `-rc`, `-SNAPSHOT`, `-M[0-9]`, or `-milestone`
(case-insensitive). Only stable releases are eligible as `safe_latest`.
**If the newest stable available is within seven days**, use the next older stable entry
from the `rows=5` result set. If all five entries are too recent or are pre-releases,
record **skipped (no safe version available)**.

**If a dependency is absent from the batch output** (no row for its coordinates — indicating a fetch function failed with a network error, API timeout, or malformed response): record it as **Skipped (lookup failed)** in the Step I summary and exclude it from this run's bumps. Do not stop Phase 0 for a single lookup failure — continue with the remaining dependencies.

For Gradle plugins the Plugin Portal API returns only the latest version; if it is
too recent, fall back to fetching:
```
https://plugins.gradle.org/m2/<plugin/id/as/path>/<plugin.id>.gradle.plugin/maven-metadata.xml
```
and parse `<versioning><versions>` to find the next oldest stable release. Apply
the same pre-release exclusion (`-alpha`, `-beta`, `-rc`, `-SNAPSHOT`, `-M[0-9]`,
`-milestone`) before selecting.

### GitHub Actions — single GraphQL batch

Collect the distinct `owner/repo` pairs for every action found in Steps C.2. Build
one GraphQL query that fetches the five most recent releases for all of them at once:

```graphql
query {
  checkout: repository(owner: "actions", name: "checkout") {
    releases(first: 5, orderBy: {field: CREATED_AT, direction: DESC}) {
      nodes { tagName publishedAt isPrerelease tagCommit { oid } }
    }
  }
  uploadArtifact: repository(owner: "actions", name: "upload-artifact") {
    releases(first: 5, orderBy: {field: CREATED_AT, direction: DESC}) {
      nodes { tagName publishedAt isPrerelease tagCommit { oid } }
    }
  }
  # ... one alias per distinct action repo
}
```

Run with:

```
gh api graphql -f query='<query>'
```

The `tagCommit.oid` field gives the commit SHA directly from the release object —
no second round-trip needed to resolve tags to SHAs.

> **Note:** GraphQL aliases must be valid identifiers (letters, digits, underscores).
> Derive an alias from `owner_repo` with slashes replaced by underscores, e.g.
> `actions/checkout` → `actions_checkout`.

Parse the response: for each action, skip any release where `isPrerelease` is `true`.
From the remaining releases, find the most recent whose `publishedAt` is older than
seven days. Record `tagName` as `target_tag` and `tagCommit.oid` as `target_sha`.

If `tagCommit` is null (annotated tag not yet linked), fall back for that action only:

```
gh api repos/<owner>/<action>/git/ref/tags/<tag_name>
```

Dereference if the object type is `tag` (annotated): fetch
`gh api repos/<owner>/<action>/git/tags/<object_sha>` and use the inner `object.sha`.

**For bare-SHA entries with no tag comment**, identify the current version by checking
whether the SHA appears in the GraphQL `tagCommit.oid` fields already fetched —
no extra API call needed if it matches.

### Gradle Wrapper — single call

```
curl -sf https://services.gradle.org/versions/all
```

Filter to stable releases only (exclude `-rc`, `-milestone`, `-nightly` suffixes).
Sort by `buildTime` descending. Select the newest whose `buildTime` is older than
seven days.

---

## Step E — Determine Changelog URL

For each dependency that has a safe update available, find the canonical changelog
URL to annotate into the version file. Use the known-sources table from Phase 2
(`phases/p2-investigate.md`) as the primary lookup.

**Known-source lookup order:**

1. Check the library family against the Kotlin/Android primary sources table in
   `phases/p2-investigate.md`: navigate to the `### Kotlin/Android primary sources`
   section heading in that file and read only that section — do not execute Phase 2.
2. **GitHub Releases page** for the action or library repository:
   `https://github.com/<owner>/<repo>/releases`
3. **Maven Central artifact page** (fallback for Maven):
   `https://central.sonatype.com/artifact/<groupId>/<artifactId>`
4. If no specific changelog is locatable, use the Maven Central search URL:
   `https://search.maven.org/artifact/<groupId>/<artifactId>`

Record the resolved changelog URL as `changelog_url` for each dependency.

---

## Step F — Apply Bumps

For each dependency that has a safe update available, apply the following edits and
commits **one dependency at a time**.

> **Do not batch multiple dependency bumps into a single commit.** Each alias or action
> gets exactly one commit.

**Before editing any file**, verify that `safe_latest` is strictly newer than
`current_version` using semantic version ordering. A version is strictly newer if it is
greater than the current version (e.g. `2.1.0 > 2.0.21`). If `safe_latest ≤
current_version` (i.e. the repo is already at or ahead of the safe latest), skip this
dependency and record it as **Skipped (already at safe latest)** in the Step I summary.
Do not apply an edit or create a commit for it.

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

### GitHub Actions — editing rules

All GitHub Actions must be written in **SHA-pinned format** with a trailing `# <tag>`
comment. This is both the target format for new entries and the update format for
existing ones.

Locate each `uses:` line for this action and rewrite it as:

```yaml
uses: actions/checkout@<target_sha> # <target_tag>  <changelog_url>
```

The changelog URL is appended after the tag comment, separated by two spaces, so the
line carries both the human-readable tag and the changelog pointer:

```yaml
- uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2  https://github.com/actions/checkout/releases
```

Rules:
- If the line already has a trailing comment, replace it entirely with the new
  `# <target_tag>  <changelog_url>` form.
- Do not change indentation or any other part of the line.
- Apply this rewrite to every occurrence of the same action across all scanned files
  in a single commit (workflows + local composite actions together).

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

For GitHub Actions, use the tag names in the commit message (not SHAs):

```
chore(deps): bump actions/checkout from v4.1.7 to v4.2.2
```

For the Gradle wrapper, use the version number directly:

```
chore(deps): bump Gradle wrapper from 8.6 to 8.13
```

The commit body (optional) may include the changelog URL and a one-sentence summary
of the release if it is immediately available from the API response. Keep it concise.
Note: GitHub Actions GraphQL responses include release description text — use it for
the summary sentence. Maven search (solrsearch) and the Gradle Plugin Portal API do
not include release descriptions — for these ecosystems, include only the changelog URL.

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

**Before creating the PR**, check whether an open proactive bump PR already exists
for this repository:

```
gh pr list --repo <owner/repo> --head <BUMP_BRANCH> --state open --json number,title
```

If a PR is returned, a PR for this exact branch already exists (e.g. from a previous
interrupted run). Record the existing PR number, skip `gh pr create`, and proceed
directly to Step I using that number.

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
<table rows — one per bumped dependency; use tag names for GitHub Actions>

### Dependency scan summary

| Status | Dependencies |
|---|---|
| Bumped | <N> |
| Skipped (too recent) | <list or "none"> |
| Skipped (already at safe latest) | <list or "none"> |
| Skipped (up to date) | <list or "none"> |
| Skipped (unresolved) | <list or "none"> |
| Skipped (lookup failed) | <list or "none"> |
| Skipped (docker/local ref) | <list or "none"> |

### Safety note

No dependency in this PR was bumped to a version published fewer than seven days
before this PR was created. This policy guards against supply-chain attacks that
exploit the window between a package being compromised and detection.

GitHub Actions are pinned to commit SHAs with an inline tag comment, following
supply-chain security best practice.

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
| <alias/action> | <old-version> | <new-version> | <url> |
...

Skipped (too recent):          <list or "none">
Skipped (up to date):          <list or "none">
Skipped (already at safe latest): <list or "none">
Skipped (unresolved):          <list or "none">
Skipped (lookup failed):       <list or "none">
Skipped (docker/local ref):    <list or "none">

Branch: <BUMP_BRANCH>
PR:     #<number>
```

→ Next: hand the PR number to the orchestrator. The orchestrator will read
`phases/p1-parse.md` and execute the full review pipeline against PR #<number>.
