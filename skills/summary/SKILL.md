---
name: summary
description: Use when you want a structured overview of git changes — for resuming sessions, reviewing PRs, or understanding what changed since the last trunk sync
argument-hint: "[pr | trunk | <git-ref>]"
---

# Summary

## Overview

A structured change-summary skill that reads git history and changed files to produce a human-readable briefing. Useful for resuming interrupted sessions, reviewing branches before raising a PR, and quickly understanding what evolved since the last trunk sync.

The skill reads git log, CHANGELOG entries, and changed skill/command/persona files, then synthesises a structured report covering what changed, why it changed, how to use the new or updated features, and what work (if any) remains open in the kanban.

## Modes

| Invocation | Scope |
|------------|-------|
| `/summary` | Changes since the branch's parent commit (default) |
| `/summary pr` | Same as default, but output is framed for PR review |
| `/summary trunk` | Changes since divergence from `main` (or `master`) |
| `/summary <ref>` | Changes since a specific git ref or commit SHA |

## Output Structure

Every run produces the following sections, in order:

1. **Context** — branch name, number of commits, date range of the changes
2. **Changes by area** — commits grouped by skill, persona, or commands scope; intent drawn from commit message subjects and bodies
3. **New & changed features** — for each touched skill or command, a brief "what it does now and how to use it" note
4. **Why** — rationale extracted from commit message bodies and changelog entries
5. **Open work** — any in-progress or to-do tickets found in `.kanban/`

## Persona Assignments

Three personas are active across the summary phases:

- **Arc (Sequencer)** — `../../personas/temporal/persona.md` — active in Phase 1; builds the change timeline and orders commits by dependency rather than chronology alone
- **Loom (Synthesist)** — `../../personas/synthesis/persona.md` — active in Phase 2 and Phase 3; synthesises across git log, CHANGELOG files, and changed command files into a unified picture
- **Ward (Documentation)** — `../../personas/documentation/persona.md` — active in Phase 2 Step 5 (doc drift detection), Phase 4 (open work scan), and Phase 5 (output assembly); writes for the reader, not the author

## Versioning

See `VERSION.md` for the current version. Changelog in `CHANGELOG.md`.

Only bump the version when changes are scoped to `skills/summary/`. Use semver: patch for fixes, minor for new features, major for breaking changes to the output format or mode set.
