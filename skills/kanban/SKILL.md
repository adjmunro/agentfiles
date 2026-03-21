---
name: kanban
description: Use when managing a software development project with a structured pipeline from capture through implementation, review, PR, and archive — especially when intent and reasoning must be traceable across agent sessions
argument-hint: "capture | plan | todo | work | review | pr | cleanup | next | init"
---

# Kanban

## Overview

A folder-based kanban workflow that moves work through a defined pipeline: capture raw intent, plan it, break it into tickets, implement, review, raise a PR, then archive. The folder is the status — location is the single source of truth, with every decision traceable back to the original capture.

## State Machine

```
[02-todo] ──► [03-in-progress] ──► [04-in-review]
                     ▲                    │ FAIL
                     └────────────────────┘
                                          │ PASS (all subject tickets)
                                          ▼
                                  [05-pull-request]
                                          │
                               PR feedback creates new
                               tickets in [02-todo] ◄──┘
                                          │ merged (GitHub) / manual (non-GitHub)
                                          ▼
                                    [06-archive]
```

### PR Step Bypass Conditions

Two conditions allow the PR step to be skipped automatically:

**1. Non-GitHub repository**
If the project is not hosted on GitHub (no `gh` CLI, non-GitHub remote), the PR step is bypassed entirely. Once all subject tickets reach `05-pull-request/`, run `/kanban-cleanup` directly. This is always a safe skip — no check is needed.

**2. Trunk branch without remote branch protection**
If the current branch is one of the fixed trunk names (`main`, `master`, `develop`, `trunk`), `/kanban-pr` runs a protection check before opening a PR:

```
gh api repos/{owner}/{repo}/branches/{branch}/protection
```

- **Protected trunk** → normal PR flow proceeds.
- **Unprotected trunk** → PR step is skipped; an audit-trail commit is created and the subject routes directly to cleanup.
- **Check fails** (no `gh` auth, network error, API error) → the command stops and asks the user whether to skip or proceed. It does **not** skip automatically. This is a best-effort check: when the answer is unknowable, the agent defers to the human.

Feature branches and non-trunk branch names are never subject to this check — they always follow the full PR flow.

## Directory Structure

```
.kanban/
├── 01-plan/                 ← capture + plan (worktree-agnostic)
│   └── YYYY-MM-DD-<subject>/
│       ├── input-<subject>.md
│       ├── plan-<subject>.md
│       ├── research-<subject>.md
│       └── assets/
├── 02-todo/
├── 03-in-progress/
├── 04-in-review/
├── 05-pull-request/
└── 06-archive/
```

The folder is the status. Location is the single source of truth.

## Commands

| Command | Stage | Role | Tier | Purpose |
|---------|-------|------|------|---------|
| `/kanban-init` | Setup | — | low | Create `.kanban/` structure |
| `/kanban-capture` | 01-plan | Scribe + Critic | high | Interview user, transcribe verbatim |
| `/kanban-plan` | 01-plan | Critic | high | Draft plan, audit against input |
| `/kanban-todo` | 02-todo | Scout → Critic | medium | Research codebase, create tickets |
| `/kanban-work` | 03-in-progress | Builder | per-ticket | Implement with WHY-comments |
| `/kanban-review` | 04-in-review | Examiner + Critic | medium | Map evidence, score pass/fail |
| `/kanban-pr` | 05-pull-request | Advocate | medium | GitHub PR, polling, CI |
| `/kanban-cleanup` | 06-archive | Critic | low | Audit, archive, clean stages |
| `/kanban-next` | Orchestrator | — | low | Auto work→review loop |

## Session Design

Two sessions. Never mixed.

- **Capture session**: `kanban-capture` + `kanban-plan` only. Never touches 02-05.
- **Work session**: `kanban-todo` through `kanban-next`. Never touches `01-plan/`.

Hard error if sessions cross-contaminate. Both commands enforce a session boundary check at startup.

## When in Doubt, Interview

Before committing to a plan or locking scope, surface edge cases, constraints, and acceptance signals by asking. This applies at `capture` and `plan` stages. Ask — don't assume. Someone who has never seen the project should be able to read the captured input and know exactly what to build, why, and when to stop.

## Ticket Naming

`TASK-NNN-<subject>.md` — zero-padded 3-digit sequence, within the subject directory under each stage folder. TASK-001 is always the TDD red phase.

## Version

See `VERSION.md` for the current version. Run `/kanban version` to check.
