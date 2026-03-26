---
name: closeout
description: Use when closing a Claude session cleanly — saves any unsaved conversation insights to memory, commits all uncommitted changes, and confirms the working directory is in a clean state.
argument-hint: ""
---

# Closeout

## Overview

A session-hygiene skill that ensures nothing important is lost when a Claude Code session ends. It reviews the current conversation for insights, decisions, or context that belong in persistent memory but haven't been saved yet, writes them to the appropriate memory files, then commits all uncommitted changes in the repository so that the working directory is clean and the git history is current.

Run `/closeout` at the end of any session where you've discussed plans, made decisions, or learned things about the project that should survive into the next conversation.

## What it does

| Step | Description |
|------|-------------|
| Memory audit | Scans the conversation for insights not yet captured in memory files |
| Memory writes | Saves new or updated entries to the correct memory file; updates `MEMORY.md` index |
| Git cleanup | Stages and commits all uncommitted changes with a conventional commit message |
| Status report | Summarises what was saved and what was committed |

## When to use

- At the end of any working session before closing the terminal
- After an exploration or planning discussion that surfaced decisions or preferences
- Whenever `git status` is dirty and you want a clean close

## Versioning

See `VERSION.md` for the current version. Changelog in `CHANGELOG.md`.

Only bump the version when changes are scoped to `skills/closeout/`. Use semver: patch for fixes, minor for new features, major for breaking changes.
