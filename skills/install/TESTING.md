# Testing — Install

## Strategy

Create a temporary git repository at `/tmp/install-test/` and run each component
against it in isolation. Verify outcomes by inspecting the resulting directory
structure, symlink targets, and file contents. Repeat with a pre-populated target
to verify idempotency and collision-handling behaviour.

## Environment Setup

```zsh
# Create a fresh git repo as the install target
git init /tmp/install-test
cd /tmp/install-test

# Populate for specific component tests:
echo "# My Project" > README.md
echo "Hello color and organize" >> README.md   # for british-english-hook
mkdir -p .claude                                # for symlinks + kanban
echo "# Claude instructions" > CLAUDE.md       # for symlinks merge test

# For gradle-idea tests (pick one):
echo 'plugins {}' > build.gradle               # Groovy
# OR
echo 'plugins {}' > build.gradle.kts           # KTS
```

Invoke each component from within the agentfiles repo, pointing at the temp target:
```
/install kanban /tmp/install-test
/install symlinks /tmp/install-test
/install british-english-hook /tmp/install-test
/install sign-hook /tmp/install-test
/install gradle-idea /tmp/install-test
```

## Core Scenarios

| Scenario | Component | Input State | Expected Outcome | Status |
|----------|-----------|-------------|-----------------|--------|
| Fresh kanban scaffold | `kanban` | Empty repo, no `.claude/` | `.kanban/` with 6 stage dirs + `.gitkeep`; command symlinks skipped with warning | Untested |
| Kanban with `.claude/` present | `kanban` | `.claude/` exists | `.kanban/` scaffold + symlinks in `.claude/commands/` for ideation and implement | Untested |
| Kanban with `.agents/` present | `kanban` | Both `.claude/` and `.agents/` exist | Symlinks created in both `.claude/commands/` and `.agents/commands/` | Untested |
| Kanban idempotency | `kanban` | Run twice on same target | Second run is a no-op; no broken symlinks or duplicate directories | Untested |
| Kanban — symlink already points elsewhere | `kanban` | `.claude/commands/ideation` is a symlink to a different path | Warning printed; existing symlink preserved | Untested |
| Sign hook — fresh install | `sign-hook` | No `pre-push` hook | `~/.local/bin/git-sign-branch` written; `.git/hooks/pre-push` installed and executable | Untested |
| Sign hook — already installed | `sign-hook` | Existing hook calling `git-sign-branch` | Reports "already installed" and exits cleanly | Untested |
| British English hook — fresh | `british-english-hook` | No `pre-commit` hook | Hook script written; `chmod 755` applied | Untested |
| British English hook — existing hook | `british-english-hook` | Existing `pre-commit` hook | Original backed up as `pre-commit.bak`; new hook chains to it | Untested |
| British English hook — substitution fires | `british-english-hook` | Staged `.md` file with "organize" | File contains "organise" after commit; file re-staged automatically | Untested |
| British English hook — code blocks skipped | `british-english-hook` | Staged `.md` with "organize" inside fenced code block | Substitution not applied inside the code block | Untested |
| Symlinks — CLAUDE.md only | `symlinks` | `CLAUDE.md` exists, no `AGENTS.md` | Content made agent-agnostic; written as `AGENTS.md`; `CLAUDE.md` → symlink; `GEMINI.md` → symlink | Untested |
| Symlinks — AGENTS.md only | `symlinks` | `AGENTS.md` exists, no `CLAUDE.md` | `CLAUDE.md` → `AGENTS.md` symlink; `GEMINI.md` → `AGENTS.md` symlink | Untested |
| Symlinks — both exist | `symlinks` | Both `CLAUDE.md` and `AGENTS.md` present | Unique CLAUDE.md content shown to user; merged into AGENTS.md; CLAUDE.md replaced with symlink | Untested |
| Symlinks — skills dir migration | `symlinks` | `.claude/skills/` is a real directory | Directory moved to `.agents/skills/`; `.claude/skills/` replaced with relative symlink | Untested |
| Symlinks — worktrees setup | `symlinks` | `.claude/` and `.agents/` both exist | `.worktrees/` created; both get relative symlinks pointing to it | Untested |
| Symlinks — idempotency | `symlinks` | Run twice | Second run reports "already linked / skipped" for all steps | Untested |
| Gradle-idea — Groovy build | `gradle-idea` | `build.gradle` (Groovy) | `apply plugin: 'idea'` added; `idea { }` block added; `.worktrees/` in `.gitignore`; `.worktrees/` dir created | Untested |
| Gradle-idea — KTS build | `gradle-idea` | `build.gradle.kts` | `id("idea")` added to plugins block; `idea { }` block added | Untested |
| Gradle-idea — plugin already present | `gradle-idea` | idea plugin already in build file | Plugin step skipped; exclusion and gitignore steps still run | Untested |
| Gradle-idea — no build file | `gradle-idea` | No `build.gradle` or `build.gradle.kts` | Error reported clearly; no files modified | Untested |

## Command Coverage

| Command file | Covered by scenario |
|--------------|---------------------|
| `commands/install.md` | All scenarios (entry point) |
| `commands/components/kanban.md` | Kanban scenarios |
| `commands/components/sign-hook.md` | Sign hook scenarios |
| `commands/components/british-english-hook.md` | British English hook scenarios |
| `commands/components/symlinks.md` | Symlinks scenarios |
| `commands/components/gradle-idea.md` | Gradle-idea scenarios |

## Known Issues

_(None recorded yet — append as issues are found and fixed.)_

## Refinement Log

_(Empty — append after each test run with what was learned, what changed, and the date.)_
