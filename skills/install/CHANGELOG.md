# Changelog

What's new, what's better, what's different. Most recent stuff on top.

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
