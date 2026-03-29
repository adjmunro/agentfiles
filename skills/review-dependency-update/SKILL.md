---
name: review-dependency-update
description: Use when reviewing a dependency update PR — investigates changelogs, API changes, licence shifts, deprecations, and security issues; makes remediation commits if needed; and posts a structured verdict as a PR comment.
argument-hint: "<PR-number | #PR-number | PR-URL>"
---

# Review Dependency Update

## Overview

A structured dependency-update review pipeline. Point it at a PR number or URL and it
will: investigate the dependency change end-to-end, assess code impact, apply
remediation commits where needed, score the risk, and post a verdict comment on the PR.

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
- **Kira (Builder)** — Phase 4: remediation commits (only when changes are needed)
- **Arden (Critic)** — Phase 5: risk scoring and verdict

## Argument Format

```
/review-dependency-update 1509
/review-dependency-update #1509
/review-dependency-update https://github.com/owner/repo/pull/1509
```

Multiple dependencies updated in one PR are reviewed in sequence; each receives
its own verdict section in the final comment.

## Versioning

See `VERSION.md` for current version. Changelog in `CHANGELOG.md`.

Only bump the version when changes are scoped to `skills/review-dependency-update/`.
Use semver: patch for fixes, minor for new features, major for breaking changes.
