---
name: bump-dependencies
description: Proactively discovers and bumps outdated dependencies with changelog annotations, then runs a full review pipeline. When called with a PR number, reviews that dependency update PR directly.
argument-hint: "[PR-number]"
---

# Bump Dependencies

## Overview

A dual-mode dependency management skill for Kotlin/Android projects using Gradle with a
`libs.versions.toml` version catalogue.

**No-argument mode** (`/bump-dependencies`): scans the repository for outdated
dependencies, annotates each version definition with a changelog hyperlink, bumps each
dependency to its latest safe release (never younger than one week — supply-chain
protection), commits each bump atomically, opens a PR, then runs the full review
pipeline against that PR.

**PR-review mode** (`/bump-dependencies 1509`): point it at an existing PR number to
run the full review pipeline directly — split any bundled version bumps into atomic
commits, investigate each bump in parallel, apply remediation commits, score the risk,
and post one PR comment per bump.

## Pipeline

### No-argument mode

```
[Phase 0: Discover & Bump]
       │
       ├── Scan: libs.versions.toml, .github/workflows, gradle-wrapper
       ├── Per dependency: look up latest safe version, annotate changelog URL, bump
       ├── Each bump → atomic commit
       └── Push branch → open PR → hand off PR number
       │
       ▼
[Phase 1 onwards — same as PR-review mode]
```

### PR-review mode

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
                                    │
                                    ▼
                            [Phase 8: Consolidate]
                                    │
                                    ▼
                            [Phase 7: Summary]
```

## Personas

- **Echo (Examiner)** — Phase 2: changelog and API-change evidence gathering
- **Rook (Adversary)** — Phase 2 security pass: supply-chain red-teaming
- **Ink (Commit Curator)** — Phase 0: bump commits; Phase 1b: commit splitting; Phase 4: remediation commits
- **Arden (Critic)** — Phase 5: risk scoring and verdict

## Argument Format

```
/bump-dependencies           ← proactive mode: discover, bump, open PR, then review
/bump-dependencies 1509      ← review mode: review an existing PR directly
```

Pass a bare PR number for review mode. Full GitHub URLs and `#`-prefixed numbers are
also accepted as fallbacks.

Multiple dependencies updated in one PR are reviewed in parallel (Phases 2–3 and 5–6);
remediation commits (Phase 4) run sequentially to avoid git race conditions. Each bump
receives its own PR comment.

## Versioning

See `VERSION.md` for current version. Changelog in `CHANGELOG.md`.

Only bump the version when changes are scoped to `skills/bump-dependencies/`.
Use semver: patch for fixes, minor for new features, major for breaking changes.
