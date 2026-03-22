---
name: install
description: Install agentfiles components into a target repository. Run from within the agentfiles repo.
argument-hint: "<component> [target-path]"
---

# Install Skill

> Installs components from this agentfiles repository into a target project.
> Each component is self-contained — install one, several, or all of them.

## Components

| Component | What it installs |
|-----------|-----------------|
| `kanban` | `.kanban/` directory scaffold (01-plan through 06-archive) and command symlinks for ideation and implement |
| `sign-hook` | Batch commit-signing pre-push hook |
| `british-english-hook` | Pre-commit British English enforcement (perl, portable) |
| `symlinks` | Agent-agnostic AGENTS.md normalisation, skills/hooks directory migration, worktrees |
| `gradle-idea` | Gradle idea plugin with `.worktrees` exclusion, `.gitignore`, and worktrees directory |
| `bash-guard` | Pre-tool-use hook blocking redundant Bash calls (cat/grep/find/ls → Read/Grep/Glob) |
| `readme-hook` | Post-commit hook reminding the agent to update README.md on structural changes |
| `title-hook` | Terminal title hooks (SessionStart + UserPromptSubmit) — repo/branch/PR context |
| `all` | Runs all of the above except `gradle-idea` (which is Gradle-project specific) |

## Usage

Run from within the target repository (after bootstrapping):

```
/install all
/install kanban
/install symlinks
/install sign-hook
/install british-english-hook
/install bash-guard
/install readme-hook
/install title-hook
/install gradle-idea
```

## Bootstrap

To get `/install` into a new repo from scratch:

```zsh
zsh <(curl -sSL https://raw.githubusercontent.com/adjmunro/agentfiles/main/scripts/bootstrap.sh)
```

## Versioning

See `VERSION.md` for current version. Changelog in `CHANGELOG.md`.

Only bump the version when changes are scoped to `skills/install/`. Use semver:
patch for fixes, minor for new components or sub-operations, major for breaking changes.
