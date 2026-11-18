# Intent Preservation During Rebase

Rebase conflict resolution is not about making Git happy. It is about preserving the reason a commit existed while respecting the target branch's newer structure.

## The Core Rule

Resolve to the target branch's current architecture, then re-express the rebased commit's intent inside that architecture.

Do not treat the old file path, old language, or old config format as sacred. Those are implementation details that may already have been deliberately replaced upstream.

## What To Extract From The Rebased Commit

Before editing anything, answer:

1. What problem was this commit solving?
2. What behavior, invariant, or dependency was it trying to change?
3. Which part of that intent is still relevant after the target branch's migration or move?

If you cannot answer those questions from the conflict markers alone, inspect the replayed commit directly:

```zsh
git rebase --show-current-patch
git show --stat --summary REBASE_HEAD
git show REBASE_HEAD -- <path>
```

To locate where a moved or renamed concern now lives on the target branch, search with the Grep tool rather than shelling out to `grep`/`rg`.

## Mapping Old Structure To New Structure

Typical translations:

- `build.gradle` -> `build.gradle.kts`
  - preserve the configuration intent
  - translate it into Kotlin DSL
- inline dependency versions -> `libs.versions.toml`
  - preserve the requested version or alias intent
  - update the catalog rather than reintroducing inline literals
- old file path -> renamed or moved file
  - preserve the behavior change
  - apply it in the new path
- Java class -> Kotlin class
  - preserve logic and nullability intent
  - translate the implementation into Kotlin instead of recreating Java

## Duplicate Migration Commits

If the target branch already contains the migration or move that the rebased commit is trying to replay, that stopped commit may be redundant.

Signals:

- the conflict mentions deleted legacy files that no longer exist on the target branch
- the upstream branch already contains the same move, rename, or migration
- the replayed patch mostly tries to reintroduce an older structure rather than add new behavior

When those signals are present, verify whether any non-duplicate behavior remains. If not, skip the commit. If some behavior remains, preserve that behavior in the new structure and continue rather than skipping blindly.

## Resolution Standard

A good resolution has these properties:

- the target branch keeps its newer structure
- the rebased branch keeps its actual behavior change
- no obsolete files are revived
- a future reviewer can still see what the rebased commit meant

A bad resolution may compile, but it quietly undoes the target branch's migration or drops the rebased branch's intent. Avoid both failures.
