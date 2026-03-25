---
name: optimise
description: Use when you want to systematically measure and improve a workflow directory — agent skills, code repos, documentation stores, or any directory of instruction files
argument-hint: "<path-to-target-workflow-directory>"
---

# Optimise

## Overview

A scientific-method optimisation loop for workflow directories. Point it at any folder
of agent instructions, command files, or documentation and it will: measure what's
wrong, form evidence-based hypotheses, apply changes, re-measure, and write a report.
The same loop that produced the kanban/ideation/personas improvements is packaged here
so it can be reused on any target.

## 5-Phase Loop

```
[Phase 1: Audit] ──► [Phase 2: Baseline] ──► [Phase 3: Hypothesize]
                                                        │ human approves
                                                        ▼
                                             [Phase 4: Experiment Loop]
                                                        │
                                                        ▼
                                               [Phase 5: Report]
```

Full metric library (M1–M15), composite scoring formula, custom metric discovery
process, and design patterns (P1–P15): see `commands/phases/p2-baseline.md` (metrics)
and `commands/phases/p3-hypothesize.md` (patterns).
Novel patterns discovered per run are recorded in `research-log.md`; once confirmed
as seed candidates they are promoted to P15+ in `commands/phases/p3-hypothesize.md`.

## Versioning

See `VERSION.md` for current version. Changelog in `CHANGELOG.md`.

Only bump the version when changes are scoped to `skills/optimise/`. Use semver:
patch for fixes, minor for new features, major for breaking changes.
