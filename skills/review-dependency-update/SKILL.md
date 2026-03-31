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

## 6-Phase Pipeline

```
[Phase 1: Parse] ──► [Phase 2: Investigate] ──► [Phase 3: Impact]
                                                        │
                                                        ▼
                                              [Phase 4: Remediate?]
                                                        │
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

Multiple dependencies updated in one PR are reviewed in sequence; each receives
its own verdict section in the final comment.

## Versioning

See `VERSION.md` for current version. Changelog in `CHANGELOG.md`.

Only bump the version when changes are scoped to `skills/review-dependency-update/`.
Use semver: patch for fixes, minor for new features, major for breaking changes.
