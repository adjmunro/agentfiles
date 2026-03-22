---
name: optimize
description: Use when you want to systematically measure and improve a workflow directory — agent skills, code repos, documentation stores, or any directory of instruction files
argument-hint: "<path-to-target-workflow-directory>"
---

# Optimize

## Overview

A scientific-method optimization loop for workflow directories. Point it at any folder
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

## Metrics

The metric library is **not a fixed checklist**. M1–M12 are a seed library extracted
from the kanban/ideation/personas study — they have track records and defined
measurement methods. The skill applies applicable seeds, skips irrelevant ones, and
**always discovers new metrics** tailored to the specific workflow being optimized.

Every optimization run should produce at least 1–2 custom metrics. If a workflow has
a quality dimension that no seed metric captures, that gap is itself a finding.

### Seed Metrics — Universal

### Universal Metrics

| ID | Name | Direction | Weight | Normalization | Notes |
|----|------|-----------|--------|---------------|-------|
| M2 | Directive Density (DD) | ↑ higher | 1× | (raw/2.0)×100, cap 100 | directives per 100 tokens |
| M3 | Instruction Ambiguity Rate (IAR) | ↓ lower | 1× | 100 − raw% | % of instructions containing modal verbs with no scope |
| M5 | Redundancy Index (RI) | ↓ lower | 1× | 100 − raw% | % of instructions duplicated elsewhere in the workflow |
| M6 | AC Concreteness (ACC) | ↑ higher | 2× | raw % | % of acceptance criteria that are measurable/verifiable |
| M8 | Human Touchpoint Count (HTC) | ↓ lower | 2× | max(0, 100−(count/20)×100) | # of required human interactions per full run |
| M10 | Context Loading Efficiency (CLE) | ↑ higher | 2× | raw % | % of loaded context relevant to the current phase |

### Seed Metrics — Workflow-Specific

Skip these with explicit rationale when the target workflow does not use the
relevant feature. Record the skip reason in the research log.

| ID | Name | Applies When | Direction | Weight | Normalization |
|----|------|-------------|-----------|--------|---------------|
| M1 | Intent-to-Output Traceability (IOT) | multi-phase pipeline | ↑ higher | 2× | raw % |
| M4 | Wiring Completeness Score (WCS) | persona system present | ↑ higher | 1× | raw % |
| M7 | Subagent Alignment Score (SAS) | subagent invocations present | ↑ higher | 2× | raw % |
| M9 | Context Decay Resilience (CDR) | multi-session orchestration | ↑ higher | 2× | raw % |
| M11 | Parallelization Safety Score (PSS) | parallel/concurrent execution | ↑ higher | 2× | partial-credit % |
| M12 | Information Freshness Score (IFS) | cached or persisted artifacts | ↑ higher | 2× | raw % |

### Custom Metrics — Discovered Per-Run

After applying seed metrics, Pulse derives additional metrics specific to the target
workflow. Custom metrics follow the same format: name, direction, weight, normalization
method, measurement methodology. They are included in the composite alongside seeds.

Examples of custom metrics discovered in practice:
- **Output Format Compliance** — for doc generators: % of outputs matching the required schema
- **Branch Coverage Completeness** — for test suites: % of code paths exercised by tests
- **Link Rot Rate** — for documentation: % of cross-references pointing to files that exist
- **Escape Hatch Frequency** — for agent skills: % of phases with explicit fallback paths
- **Naming Consistency** — for code repos: % of identifiers following declared conventions

Custom metrics are recorded in `research-log.md` under `## Custom Metrics` with their
full definition. They persist across optimization runs on the same workflow.

### Composite Scoring Formula

```
Composite = sum(normalized_score × weight) / (total_weight × 100) × 100
```

Where `total_weight` is the sum of weights for all applied metrics only. Skipped
metrics do not contribute to the denominator. This ensures the composite is
meaningful even when several workflow-specific metrics are inapplicable.

Normalization per metric:
- **DD**: (raw_directives_per_100_tokens / 2.0) × 100, capped at 100
- **IAR**: 100 − ambiguity_percentage
- **RI**: 100 − redundancy_percentage
- **ACC**: percentage of ACs that are concrete and verifiable
- **HTC**: max(0, 100 − (touchpoint_count / 20) × 100)
- **CLE**: percentage of context tokens that are phase-relevant
- **IOT, WCS, SAS, CDR, PSS, IFS**: raw percentage scores

## Design Patterns Discovered

Five patterns extracted from the kanban/ideation/personas research. Apply these
preferentially when forming hypotheses — each has a track record of results.

### P1 — Intent Anchor Blocks
At every phase transition, the orchestrator re-reads the original intent artifact
before proceeding. Prevents context drift across long sessions.
Targets: CDR (↑), IOT (↑)

### P2 — Staleness TTL Policies (3-tier)
Every artifact that can go stale carries an explicit TTL policy:
- **Tier A — Regenerate**: artifact must be rebuilt before use if older than threshold
- **Tier B — Load-with-caveat**: artifact is usable but model must flag staleness to user
- **Tier C — No-TTL**: artifact is canonical and does not expire (e.g. original input)
Targets: IFS (↑)

### P3 — Progressive Disclosure
Phase-scoped context loading: each phase block lists only the files it needs. No
phase loads the full workflow corpus. Context is loaded on demand, not preloaded.
Targets: CLE (↑), HTC (↓)

### P4 — Recommendation Brief
Replace open-ended human Q&A interviews with a model-formed recommendation brief.
The model assembles evidence, states a recommended action per item, and asks the
human to approve/reject per item rather than answer open questions. Reduces
touchpoints while preserving human control at decision gates.
Targets: HTC (↓), IAR (↓)

### P5 — Claim Registry
For workflows with parallel or concurrent execution: a shared registry file records
which agent/phase currently holds a write lock on each artifact. All mutations check
the registry before writing and release the lock on completion. Prevents silent races.
Targets: PSS (↑)

## Versioning

See `VERSION.md` for current version. Changelog in `CHANGELOG.md`.

Only bump the version when changes are scoped to `skills/optimize/`. Use semver:
patch for fixes, minor for new features, major for breaking changes.
