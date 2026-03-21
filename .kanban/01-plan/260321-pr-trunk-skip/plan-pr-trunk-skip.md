## Intent

The kanban PR stage should be skipped when the current branch is a known trunk branch — the same way it is skipped for non-GitHub repos. Raising a PR from trunk into trunk is nonsensical. Before skipping, the command checks remote branch protection via the `gh` CLI to avoid bypassing a protected branch accidentally. If the check fails for any reason, the command stops and asks the user rather than guessing.

## Requirements

### 1. Trunk detection

1.1 At the start of `kanban-pr`, detect whether the current branch is one of: `main`, `master`, `develop`, `trunk`.

1.2 The trunk branch list is fixed — not configurable per-repo.

### 2. Remote protection check

2.1 If a trunk branch is detected, query remote branch protection using `gh api repos/{owner}/{repo}/branches/{branch}/protection`.

2.2 If the branch is confirmed unprotected, or if the remote is not a GitHub remote (i.e. `gh` is unavailable or the remote URL is not github.com), proceed with the skip.

2.3 If the branch is confirmed protected, do NOT skip — run the normal PR flow.

2.4 If the protection check fails for any reason (no network, no auth, API error), stop and ask the user to confirm whether to skip or raise a PR before proceeding.

### 3. Skip behaviour

3.1 When skipping, the command behaves identically to the existing non-GitHub skip path: proceed directly to `/kanban-cleanup`.

3.2 The trunk-skip logic lives entirely in `kanban-pr`. `kanban-next` is not modified.

### 4. Documentation

4.1 `SKILL.md` state machine note is updated to document both PR bypass conditions: non-GitHub repos, and trunk branches (with the protection-check caveat noted).

## Constraints

- Trunk branch list is fixed: `main`, `master`, `develop`, `trunk`.
- Remote protection check uses `gh` CLI only — no other method.
- On check failure: stop and ask the user. Do not assume.
- Skip logic is in `kanban-pr` only.

## Out of Scope

- Per-repo trunk branch list configuration.
- Changes to `kanban-next`.
- Changes to any command other than `kanban-pr` and `SKILL.md`.

## Audit: input → plan — PASS
**Date**: 2026-03-21T00:00:00Z  **Threshold**: 95%

| # | Item | Status | Notes |
|---|------|--------|-------|
| 1 | Skip PR on trunk | Full | §1.1, §3.1 |
| 2 | Fixed list: main/master/develop/trunk | Full | §1.1, §1.2, Constraints |
| 3 | Unless protected on remote | Full | §2.3 |
| 4 | Check remote if in doubt | Full | §2.1, §2.4 |
| 5 | gh CLI only | Full | §2.1, Constraints |
| 6 | Failure → stop and ask | Full | §2.4, Constraints |
| 7 | Mirrors non-GitHub path → cleanup | Full | §3.1 |
| 8 | kanban-pr only, next unaffected | Full | §3.2, Out of Scope |
| 9 | SKILL.md two bypass conditions | Full | §4.1 |

- Full: 9, Partial: 0, Missing: 0 — Total: 9
- Score: (9 + 0.5×0) / 9 × 100 = **100%**

### Fixes Applied
- None.
