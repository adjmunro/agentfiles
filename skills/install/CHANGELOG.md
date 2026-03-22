# Changelog

What's new, what's better, what's different. Most recent stuff on top.

---

## 1.1.0 — Bootstrap Ready (2026-03-23)

Three new hook components, a one-liner bootstrap script, and a reworked invocation
model — `/install` now runs from within the target repo itself, not from agentfiles.

- Added `bash-guard`, `readme-hook`, `title-hook` components — embed hook scripts, write to `.claude/hooks/`, patch `settings.json`
- Added `all` shorthand — chains kanban, symlinks, sign-hook, british-english-hook, bash-guard, readme-hook, title-hook
- Dropped `[target-path]` argument — always installs into the current working directory
- Replaced `~/Developer/agentfiles` default with GitHub raw URL fallback (`$AGENTFILES_URL`)
- Added `scripts/bootstrap.sh` — curl-able one-liner to install `/install` into any repo
- Added README "Getting Started" section with bootstrap command and cold-start agent prompt

---

## 1.0.0 — The First Installer (2026-03-23)

The install skill is live. Point it at any target repository and install kanban
scaffolding, commit-signing hooks, British English enforcement, agent-agnostic
symlinks, or Gradle/IDEA worktree configuration — each as a standalone component.

- Added `kanban` component — `.kanban/` directory scaffold + command symlinks for ideation and implement
- Added `sign-hook` component — delegates to the existing `install-sign-hook` command
- Added `british-english-hook` component — git pre-commit hook with portable perl substitutions
- Added `symlinks` component — AGENTS.md normalisation, skills/hooks directory migration, worktrees
- Added `gradle-idea` component — `build.gradle` idea plugin + `.gitignore` entry + worktrees directory
