---
name: review-dependency-update
description: Use when reviewing a dependency update PR — investigates changelogs, API changes, licence shifts, deprecations, and security issues; makes remediation commits if needed; and posts a structured verdict as a PR comment.
argument-hint: "<PR-number>"
---

# Review Dependency Update

## Overview

A structured dependency-update review pipeline for Kotlin/Android projects using
Gradle with a `libs.versions.toml` version catalog. Point it at a PR number and it
will: split any bundled version bumps into atomic commits, then investigate each bump
in parallel — assessing code impact, applying remediation commits, scoring the risk,
and posting one PR comment per bump.

## Pipeline

```
[Phase 1: Parse]
       │
       ▼
[Phase 1b: Split Commits?] ← skip if already atomic
       │
       ▼  (one agent per bump — parallel)
[Phase 2: Investigate] ──► [Phase 3: Impact]
                                    │  (all agents complete)
                                    ▼  (sequential — one bump at a time)
                           [Phase 4: Remediate?]
                                    │  (one agent per bump — parallel)
                                    ▼
                            [Phase 5: Verdict]
                                    │
                                    ▼
                            [Phase 6: Comment]
```

## Personas

- **Echo (Examiner)** — Phase 2: changelog and API-change evidence gathering
- **Rook (Adversary)** — Phase 2 security pass: supply-chain red-teaming
- **Ink (Commit Curator)** — Phase 1b: commit splitting; Phase 4: remediation commits
- **Arden (Critic)** — Phase 5: risk scoring and verdict

## Argument Format

```
/review-dependency-update 1509
```

Pass a bare PR number. The current git repository is used automatically.
Full GitHub URLs and `#`-prefixed numbers are also accepted as fallbacks.

Multiple dependencies updated in one PR are reviewed in parallel (Phases 2–3 and 5–6);
remediation commits (Phase 4) run sequentially to avoid git race conditions. Each bump
receives its own PR comment.

## Versioning

See `VERSION.md` for current version. Changelog in `CHANGELOG.md`.

Only bump the version when changes are scoped to `skills/review-dependency-update/`.
Use semver: patch for fixes, minor for new features, major for breaking changes.
