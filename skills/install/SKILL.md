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
| `sign-hook` | Batch commit-signing pre-push hook (delegates to `install-sign-hook`) |
| `british-english-hook` | Pre-commit git hook enforcing British English spelling in staged prose |
| `symlinks` | Agent-agnostic AGENTS.md normalisation, skills/hooks directory migration, worktrees |
| `gradle-idea` | Gradle idea plugin configuration, `.gitignore` entry, and worktrees directory |

## Usage

```
/install kanban ~/my-project
/install sign-hook ~/my-project
/install british-english-hook ~/my-project
/install symlinks ~/my-project
/install gradle-idea ~/my-project
```

If `target-path` is omitted, the current working directory is used as the target.

Run multiple components in sequence to fully configure a new project:

```
/install kanban ~/my-project
/install symlinks ~/my-project
/install sign-hook ~/my-project
/install british-english-hook ~/my-project
```

## Versioning

See `VERSION.md` for current version. Changelog in `CHANGELOG.md`.

Only bump the version when changes are scoped to `skills/install/`. Use semver:
patch for fixes, minor for new components or sub-operations, major for breaking changes.
