---
name: propagate-renames
description: Audit markdown and KDoc references after file/directory renames, find stale links, and fix them.
---

# Propagate Renames

## Overview

Finds file and directory renames in recent git history, then searches markdown files
and KDoc comments for references that were not updated. Reports stale references and
applies fixes.

## When to Use

- After renaming or moving a file or directory in a repository
- Before merging a refactor branch that touched many file paths
- As a periodic audit to catch links that broke silently over time

---

## Step 1 — Establish Scope

**Determine the commit range to inspect.** If the user supplied a range (e.g.
`HEAD~5..HEAD`, a branch name, or a specific commit SHA), use it. Otherwise default
to the last 20 commits on the current branch:

```
git log --oneline -20
```

Record the range as `COMMIT_RANGE`.

---

## Step 2 — Extract Renames from Git History

Retrieve all file and directory renames within `COMMIT_RANGE`:

```
git log --diff-filter=R --name-status --format="" <COMMIT_RANGE>
```

Each output line has the form:

```
R<score>	<old-path>	<new-path>
```

For example:

```
R100	skills/review-dependency-update/SKILL.md	skills/bump-dependencies/SKILL.md
```

Build a rename table: one row per rename, columns `old_path` and `new_path`.

**Directory renames:** git reports renames at the file level. If multiple files share
a common path prefix that changed (e.g. `skills/foo/...` → `skills/bar/...`), record
the directory-level rename separately: `old_prefix = skills/foo`, `new_prefix =
skills/bar`. These directory-level entries let you catch references to the parent path
that do not include a filename.

If no renames are found in `COMMIT_RANGE`, report:

> "No file or directory renames found in `<COMMIT_RANGE>`. Nothing to propagate."

and stop.

---

## Step 3 — Derive Search Terms

For each rename in the table, derive the search terms to look for in the repository:

**File renames:**
- `old_basename` — the filename without directory (e.g. `SKILL.md`)
- `old_path` — the full relative path as recorded by git
- `old_path_no_ext` — path without extension (e.g. `skills/review-dependency-update/SKILL`)

**Directory renames:**
- `old_prefix` — the directory path prefix (e.g. `skills/review-dependency-update`)

**Kotlin package path (Kotlin files only):** if `old_path` ends in `.kt`:
1. Strip the source root prefix (`src/main/kotlin/`, `src/test/kotlin/`, or equivalent)
2. Replace `/` with `.` and drop `.kt`
3. Record as `old_package_path` (e.g. `com.example.old.ClassName`)

Record all derived terms alongside their rename row.

---

## Step 4 — Search for Stale References

For each rename, search the repository for stale references. Run these searches across
all `.md` files and all `.kt` files in the repository:

```
Search target files: **/*.md, **/*.kt
Exclude: .git/, build/, .gradle/, node_modules/, any binary or generated file
```

For each derived search term, look for the following reference patterns:

### Markdown patterns

| Pattern | Example |
|---|---|
| Link target (inline) | `[text](old/path/to/file.md)` |
| Link target (reference-style) | `[ref]: old/path/to/file.md` |
| Backtick-wrapped path | `` `old/path/to/file.md` `` |
| Bare path in prose | `old/path/to/file.md` (word boundary on both sides) |
| `@`-reference | `@old/path/to/file` |

### KDoc patterns (`.kt` files only)

| Pattern | Example |
|---|---|
| Bracketed class/member ref | `[ClassName][com.example.old.ClassName]` |
| `@see` reference | `@see com.example.old.ClassName` |
| `@link` in prose | `[com.example.old.ClassName]` |

For each match found, record:
- `file` — path of the file containing the stale reference
- `line` — line number
- `match_text` — the matched string
- `old_term` — which search term matched
- `suggested_fix` — the `old_term` replaced with the corresponding `new_path` or
  `new_package_path`

**Templated paths:** if a path contains `{variable}` placeholders, flag it as
`needs_review` rather than auto-fixing — the template may intentionally span old and
new paths.

---

## Step 5 — Present Findings

Before applying any fixes, present a summary:

```
### Stale Reference Audit

Renames inspected: <N>
Stale references found: <N> across <N> files

| File | Line | Stale reference | Suggested fix |
|---|---|---|---|
| <path> | <N> | `<match>` | `<fix>` |
| <path> | <N> | `<match>` | needs review — templated path |
```

If no stale references are found:

> "All references up to date — no stale paths found for the renames in `<COMMIT_RANGE>`."

and stop.

---

## Step 6 — Apply Fixes

For each row where `suggested_fix` is not `needs_review`:

1. Open the file.
2. Replace `old_term` with the corresponding new path on that line.
3. Write the file.

Do not alter indentation, surrounding text, or any other part of the line.

After all fixes are applied, stage the changed files:

```
git add <changed-files>
```

Do **not** commit — leave staging for the user to review and commit with an
appropriate message.

---

## Step 7 — Report

Print a completion summary:

```
✓ Propagate renames complete

Renames inspected:     <N>
References fixed:      <N> across <N> files
Needs review:          <N> (templated paths — see table above)

Files modified:
  <list of changed files>

Review staged changes with `git diff --staged`, then commit.
```

If any `needs_review` items remain, list them explicitly so the user can inspect them
manually.
