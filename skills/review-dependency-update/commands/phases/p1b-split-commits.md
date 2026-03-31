# Phase 1b — Split Commits
<!-- Part of: review-dependency-update.md orchestrator -->
<!-- Active when: Phase 1 complete — always runs as a check, skips if already atomic -->

**You are Ink (Commit Curator).** Read `../../personas/ink/persona.md` and
`../../personas/ink/soul.md` now. Your job is to ensure each logical dependency
bump lives in its own commit before investigation begins. A bundled commit is
harder to bisect, harder to revert selectively, and obscures which change
introduced a regression.

---

## Step A — Inspect the PR Commits

Fetch the commits on the PR branch that are not on the base branch:

```
gh pr view <PR-number> --repo <owner/repo> --json commits \
  --jq '.commits[] | {oid: .oid, message: .messageHeadline}'
```

Check out the PR branch to inspect the working tree:

```
gh pr checkout <PR-number> --repo <owner/repo>
```

For each commit, inspect the files it touches — specifically any `libs.versions.toml`,
`build.gradle.kts`, `build.gradle`, `settings.gradle.kts`, or `gradle/libs.versions.toml`.

---

## Step B — Identify the Grouping Source

### Primary signal: `libs.versions.toml` (Gradle Version Catalog)

If the project uses a version catalog (`gradle/libs.versions.toml` or
`libs.versions.toml`), this file is the authoritative grouping source.

Parse the `[versions]` table to identify version aliases and which `[libraries]`
and `[plugins]` entries reference each alias via `version.ref`:

```toml
[versions]
kotlin = "2.0.0"          # ← alias
room  = "2.6.1"

[libraries]
kotlin-stdlib   = { group = "org.jetbrains.kotlin", name = "kotlin-stdlib",  version.ref = "kotlin" }
kotlin-reflect  = { group = "org.jetbrains.kotlin", name = "kotlin-reflect", version.ref = "kotlin" }
androidx-room-runtime  = { group = "androidx.room", name = "room-runtime",  version.ref = "room" }

[plugins]
kotlin-android  = { id = "org.jetbrains.kotlin.android", version.ref = "kotlin" }
```

**Rule:** all entries — libraries AND plugins — that share the same version alias
belong in the same commit. The version alias is the group, not the groupId or the
package namespace.

This means:
- `kotlin-stdlib` + `kotlin-reflect` + the `kotlin-android` **plugin** all move
  together under a single `kotlin` alias bump
- `room-runtime` + `room-compiler` + `room-ktx` all move together under `room`
- `compose-bom` (the BOM library) and `compose-compiler` plugin may share an alias
  or may be separate — follow the catalog, not assumptions

### Secondary signal: same groupId (no version catalog)

If no version catalog exists, fall back to groupId-based grouping:

- Same Maven `groupId` → same commit (e.g., all `androidx.room:*` together)
- Same Gradle Plugin ID prefix → same commit
- Known coordinated pairs across groupIds (see table below) → same commit

### Plugin ↔ dependency equivalence table

Many Kotlin/Android libraries have both a Gradle plugin and a runtime dependency.
These are the same tool and must always be in the same commit:

| Plugin ID | Dependency artifact | Notes |
|---|---|---|
| `com.android.application` / `com.android.library` | `com.android.tools.build:gradle` | Android Gradle Plugin (AGP) |
| `org.jetbrains.kotlin.android` / `org.jetbrains.kotlin.jvm` | `org.jetbrains.kotlin:kotlin-gradle-plugin` | Kotlin compiler |
| `com.google.devtools.ksp` | `com.google.devtools.ksp:symbol-processing-api` | KSP |
| `com.google.dagger.hilt.android` | `com.google.dagger:hilt-android-gradle-plugin` | Hilt |
| `androidx.navigation.safeargs.kotlin` | `androidx.navigation:navigation-safe-args-gradle-plugin` | Navigation Safe Args |
| `com.squareup.wire` | `com.squareup.wire:wire-gradle-plugin` | Wire |

If a bump in `[plugins]` and a bump in `[libraries]` correspond to the same tool
(even with different identifiers), they go in the same commit.

### Shared version number as a supporting signal

If two artifacts with different groupIds bump to exactly the same new version number,
check whether they are known to release in lockstep (e.g., all Jetpack Compose
artifacts, all Kotlin Coroutines artifacts). If the version catalog confirms they
share an alias, group them. If there is no catalog and the version match is
coincidental, do not group on version number alone.

---

## Step C — Determine Atomicity

A commit is **already atomic** if every dependency change in it belongs to the
same version-catalog alias (or the same groupId if no catalog exists), and any
corresponding plugin entry is also included.

If every bump commit in the PR is already atomic: print

> Phase 1b: commits are already atomic — no splitting required.

and skip to `→ Next` immediately.

---

## Step D — Plan the Split

For each non-atomic commit, produce a split plan before touching anything:

```
Bundle: <short-hash> — "<original commit message>"

Split into:
  Commit A: kotlin alias bump (1.9.22 → 2.0.0)
    libs: kotlin-stdlib, kotlin-reflect, kotlin-test
    plugins: kotlin-android, kotlin-serialization
    files: gradle/libs.versions.toml (versions.kotlin line), build.gradle.kts (if pinned)

  Commit B: room alias bump (2.5.2 → 2.6.1)
    libs: room-runtime, room-compiler, room-ktx
    files: gradle/libs.versions.toml (versions.room line)

  Commit C: agp alias bump (8.4.2 → 8.5.0)
    libs: (none — version-only entry)
    plugins: android-application, android-library
    files: gradle/libs.versions.toml (versions.agp line)
```

Print the full plan to the user. Wait for explicit confirmation or correction.
- If the user confirms (or does not respond within 60 seconds), proceed to Step E.
- If the user requests a change, revise the plan and re-print before continuing.
- If operating in a fully automated mode with no user present, print the plan and proceed immediately.

---

## Step E — Rewrite the Commits

For each bundle commit, working oldest-first:

1. **Soft-reset** to unstage the commit while preserving the working tree:
   ```
   git reset --soft HEAD~1
   ```

2. **For each group in the split plan**, stage only the lines belonging to that
   group using `git add -p` on the version catalog (or manifest files). The
   version catalog change for a single alias is typically a one- or two-line diff —
   stage only those lines, plus any corresponding lock-file or pinned-version changes
   in `build.gradle.kts` files.

3. **Commit each group** with a descriptive message:
   ```
   chore(deps): bump <alias-name> <old> → <new>

   Separating from bundle for bisect traceability. This commit covers:
   libs: <comma-separated library aliases>
   plugins: <comma-separated plugin aliases> (if any)
   ```

4. Verify with `git log --oneline` that each commit is independently meaningful.

---

## Step F — Force-Push

```
git push --force-with-lease origin <head-branch>
```

Use `--force-with-lease` — fail safely if the remote has moved since checkout.

---

## Step G — Cross-Bump Compatibility Check

Before producing the manifest, check whether any pair of aliases has a known
version-constraint relationship. If two or more aliases are being bumped, consult
this table:

| Alias pair | Constraint | How to check |
|---|---|---|
| `kotlin` + `ksp` | KSP major.minor must match Kotlin major.minor | e.g., Kotlin 2.0.x requires KSP 2.0.x — confirm both aliases use matching major.minor |
| `agp` + `kotlin` | AGP and Kotlin have documented compatible version pairs | Check the [AGP release notes](https://developer.android.com/build/releases/gradle-plugin) for the minimum Kotlin version required |
| `compose-compiler` + `kotlin` | Compose Compiler requires a specific Kotlin version range | Check the [Compose Compiler compatibility map](https://developer.android.com/jetpack/androidx/releases/compose-kotlin) |
| `compose-bom` + `compose-compiler` | BOM version implies specific compiler version | Use BOM mapping at `https://developer.android.com/jetpack/compose/bom/bom-mapping` |
| `hilt` + `ksp` | Hilt's KSP variant requires matching KSP version | Check Hilt release notes for the KSP version it was built against |

For each constraint pair where both aliases appear in this PR:
1. Confirm the new versions satisfy the constraint.
2. If they do not, flag the incompatibility in the manifest and note that the two bumps should be co-reviewed even though they are in separate commits.
3. If the constraint cannot be verified (changelog unavailable), mark as "unverified — manual check recommended."

If no constrained pairs are found among the bumped aliases, note: "No cross-bump constraints detected."

---

## Step H — Produce the Atomic Commit Manifest

Write a manifest of the final atomic commits for the orchestrator to use in
parallel dispatch. For each atomic commit, record:

```
{
  "commit": "<short-hash>",
  "alias": "<version-catalog-alias or groupId>",
  "packages": ["<groupId:artifactId>", ...],
  "plugins": ["<plugin-id>", ...],
  "old_version": "<old>",
  "new_version": "<new>",
  "cross_bump_constraints": ["<note, or empty array>"],
  "isolated_branch": "dep-review/<PR-number>/<alias>"
}
```

Also record the following PR-level context once (shared across all entries):

```
{
  "pr_number": "<number>",
  "pr_url": "<url>",
  "owner_repo": "<owner/repo>",
  "base_branch": "<base-branch>",
  "head_branch": "<head-branch>"
}
```

This manifest, including PR context, is passed to each parallel agent.

---

## Step I — Create Isolated Branches

For each entry in the manifest, create an isolated branch forked from the
**base branch** (not the PR head branch) with only that alias group's commit
cherry-picked onto it.

For each manifest entry in order:

```
# Create the isolated branch from base
git checkout <base-branch>
git checkout -b dep-review/<PR-number>/<alias>

# Cherry-pick the alias commit onto the isolated branch
git cherry-pick <commit-hash>

# Push the isolated branch to the remote
git push origin dep-review/<PR-number>/<alias>
```

If the cherry-pick produces a conflict (e.g., because the version catalog line
was last modified by a different bump in the same bundle), resolve it by keeping
only the lines belonging to this alias — the other aliases will be handled on
their own isolated branches. Commit the resolution before pushing.

After creating all isolated branches, confirm that:
- Each isolated branch exists on the remote
- Each branch contains exactly the commits from the base branch plus the one
  alias commit (verify with `git log --oneline <base-branch>..dep-review/<PR-number>/<alias>`)

The `isolated_branch` field in the manifest is already populated from Step H.
No further update is needed.

→ Next: Return the manifest to the orchestrator. The orchestrator dispatches one
agent per entry — read the orchestrator's **Parallel Dispatch** section now.
