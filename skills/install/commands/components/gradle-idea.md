# Component: gradle-idea

Configures the Gradle IDEA plugin in the current project to exclude `.worktrees/`
from IntelliJ IDEA indexing, adds `.worktrees/` to `.gitignore`, and creates the
`.worktrees/` directory with symlinks from `.claude/` and `.agents/`.

## DO

- Detect whether the build file is Groovy (`build.gradle`) or Kotlin DSL (`build.gradle.kts`)
- Only modify the root-level build file — never touch submodule build files
- Check before adding: skip if already present
- Add `.worktrees/` to `.gitignore` only if not already present

## DO NOT

- Modify any build file other than the root `build.gradle` or `build.gradle.kts`
- Proceed if no root build file exists — report clearly and stop
- Add duplicate `idea { }` blocks

---

## Phase 1 — Find Root Build File

Glob for `./build.gradle` then `./build.gradle.kts` in the current directory.

- Found `build.gradle`: set `$BUILD_FILE=./build.gradle`, `$BUILD_TYPE=groovy`
- Found `build.gradle.kts`: set `$BUILD_FILE=./build.gradle.kts`, `$BUILD_TYPE=kts`
- Neither found: print the following and stop:
  > No root build.gradle or build.gradle.kts found. The gradle-idea component requires a Gradle project.

---

## Phase 2 — Add idea Plugin

Read `$BUILD_FILE`. Check if already configured:
- Groovy: `apply plugin: 'idea'` or `'idea'` in a `plugins { }` block
- KTS: `id("idea")` in a `plugins { }` block

If already present: print "idea plugin already configured — skipping". Go to Phase 3.

**If not present:**

For **Groovy**: add `apply plugin: 'idea'` after the closing `}` of any `plugins { }` block,
or near the top of the file if no plugins block exists.

For **KTS**: add `    id("idea")` as the last entry inside the `plugins { }` block, or
insert a new `plugins { id("idea") }` block at the top if none exists.

Write the file. Print: "✓ idea plugin added to `{build_file}`"

---

## Phase 3 — Add idea Module Exclusion

Read the updated `$BUILD_FILE`. Check for an existing `.worktrees` exclusion in an
`idea { }` block. If already present: print "idea module exclusion already configured — skipping".

**If not present:** append to `$BUILD_FILE`:

For **Groovy**:
```groovy
idea {
    module {
        excludeDirs += file(".worktrees")
    }
}
```

For **KTS**:
```kotlin
idea {
    module {
        excludeDirs.add(file(".worktrees"))
    }
}
```

Print: "✓ idea module exclusion for `.worktrees` added"

---

## Phase 4 — Update .gitignore

- `.gitignore` absent: create it with `.worktrees/`
- `.gitignore` present, `.worktrees` already listed: print "already in `.gitignore` — skipped"
- `.gitignore` present, not listed: append `.worktrees/` on a new line

Print: "✓ `.worktrees/` added to `.gitignore`" (or skipped message)

---

## Phase 5 — Worktrees Directory and Symlinks

1. Create `.worktrees/` if it does not exist. Print: "✓ Created `.worktrees/`"
2. If `.claude/` exists: create `.claude/worktrees` → `../.worktrees` if absent. Print: "✓ `.claude/worktrees` → `.worktrees`"
3. If `.agents/` exists: same for `.agents/worktrees`. Print: "✓ `.agents/worktrees` → `.worktrees`"

---

## Phase 6 — Report

```
gradle-idea installation complete

  Build file:      {build_file}
  idea plugin:     ✓ added  |  already present — skipped
  idea exclusion:  ✓ added  |  already present — skipped
  .gitignore:      ✓ .worktrees/ added  |  already present — skipped
  .worktrees/:     ✓ created  |  already existed
  .claude/ link:   ✓ .claude/worktrees → .worktrees  |  skipped (no .claude/)
  .agents/ link:   ✓ .agents/worktrees → .worktrees  |  skipped (no .agents/)
```
