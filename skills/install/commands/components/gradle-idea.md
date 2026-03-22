# Component: gradle-idea

Configures the Gradle IDEA plugin in the target project to exclude the `.worktrees/`
directory from IntelliJ IDEA indexing, adds `.worktrees/` to `.gitignore`, and
creates the `.worktrees/` directory with symlinks from `.claude/` and `.agents/`.

**Inputs:** `$TARGET`, `$AGENTFILES_ROOT`

## DO

- Detect whether the build file is Groovy (`build.gradle`) or Kotlin DSL (`build.gradle.kts`)
- Only modify the root-level build file — never touch submodule build files
- Check before adding: skip the plugin or exclusion if already present
- Add `.worktrees/` to `.gitignore` only if not already present

## DO NOT

- Modify any build file other than the root `build.gradle` or `build.gradle.kts`
- Proceed if no root build file exists — report clearly and stop
- Add duplicate `idea { }` blocks

---

## Phase 1 — Find Root Build File

Use Glob to check for `$TARGET/build.gradle` then `$TARGET/build.gradle.kts`.

- If `build.gradle` exists: set `$BUILD_FILE=$TARGET/build.gradle`, `$BUILD_TYPE=groovy`
- If `build.gradle.kts` exists: set `$BUILD_FILE=$TARGET/build.gradle.kts`, `$BUILD_TYPE=kts`
- If neither exists: print the following and stop:

> No root build.gradle or build.gradle.kts found in `{target}`.
> The gradle-idea component requires a Gradle project.

---

## Phase 2 — Add idea Plugin

Read `$BUILD_FILE`.

**Detect whether the idea plugin is already configured:**
- Groovy: look for `apply plugin: 'idea'` or `'idea'` inside a `plugins { }` block
- KTS: look for `id("idea")` inside a `plugins { }` block

If already present: print "idea plugin already configured — skipping" and go to Phase 3.

**If not present:**

For **Groovy** (`build.gradle`):
- If a `plugins { }` block exists: add `apply plugin: 'idea'` on a new line immediately
  after the closing `}` of the plugins block
- If no `plugins { }` block: insert `apply plugin: 'idea'` near the top of the file,
  after any `buildscript { }` block (or at the very top if no buildscript block exists)

For **KTS** (`build.gradle.kts`):
- If a `plugins { }` block exists: add `    id("idea")` as the last entry inside it,
  before the closing `}`
- If no `plugins { }` block exists: insert at the top of the file:
  ```kotlin
  plugins {
      id("idea")
  }
  ```

Write the modified build file.
Print: "✓ idea plugin added to `{build_file}`"

---

## Phase 3 — Add idea Module Exclusion

Read the (now updated) `$BUILD_FILE`.

**Check for an existing `idea { }` block with a `.worktrees` exclusion:**
- Groovy: look for `excludeDirs` referencing `.worktrees`
- KTS: look for `excludeDirs.add` referencing `.worktrees`

If already present: print "idea module exclusion already configured — skipping" and go to Phase 4.

**If not present:** Append the following block at the end of `$BUILD_FILE`.

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

Write the file.
Print: "✓ idea module exclusion for `.worktrees` added"

---

## Phase 4 — Update .gitignore

Check whether `$TARGET/.gitignore` exists.

- If it does not exist: create it with the content `.worktrees/`
- If it exists: check whether `.worktrees/` or `.worktrees` appears as a line
  - Present: print "`.worktrees` already in `.gitignore` — skipped"
  - Absent: append `.worktrees/` on a new line at the end

Print: "✓ `.worktrees/` added to `.gitignore`" (or the skipped message)

---

## Phase 5 — Worktrees Directory and Symlinks

1. Create `$TARGET/.worktrees/` as a real directory if it does not exist.
   Print: "✓ Created `.worktrees/`"

2. If `.claude/` exists in `$TARGET`:
   - If `.claude/worktrees` does not exist: create symlink `.claude/worktrees` → `../.worktrees`
   - If it already points correctly: print "`.claude/worktrees` already linked — skipped"
   - Print: "✓ `.claude/worktrees` → `.worktrees`"

3. If `.agents/` exists in `$TARGET`:
   - Same logic for `.agents/worktrees` → `../.worktrees`
   - Print: "✓ `.agents/worktrees` → `.worktrees`"

---

## Phase 6 — Report

```
gradle-idea installation complete for: {target}

  Build file:      {build_file}
  idea plugin:     ✓ added  |  already present — skipped
  idea exclusion:  ✓ added  |  already present — skipped
  .gitignore:      ✓ .worktrees/ added  |  already present — skipped
  .worktrees/:     ✓ created  |  already existed
  .claude/ link:   ✓ .claude/worktrees → .worktrees  |  skipped (no .claude/)
  .agents/ link:   ✓ .agents/worktrees → .worktrees  |  skipped (no .agents/)
```
