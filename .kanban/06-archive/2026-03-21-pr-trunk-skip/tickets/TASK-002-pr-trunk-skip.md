---
id: "2026-03-21-pr-trunk-skip/TASK-002"
subject: "2026-03-21-pr-trunk-skip"
plan: "../../01-plan/2026-03-21-pr-trunk-skip/plan-pr-trunk-skip.md"
effort: medium
status: done
created_at: "2026-03-21T00:00:00Z"
claimed_at: "2026-03-21T21:20:00Z"
completed_at: "2026-03-21T21:30:00Z"
stale_after_hours: 4
depends_on:
  - "TASK-001"
spawned_tickets: []
plan_items:
  - "Req 1.1 — Detect trunk branch at start of kanban-pr"
  - "Req 1.2 — Fixed list: main, master, develop, trunk"
  - "Req 2.1 — Query gh api for branch protection"
  - "Req 2.2 — Unprotected or non-GitHub: skip"
  - "Req 2.3 — Protected: run normal PR flow"
  - "Req 2.4 — Check fails: stop and ask user"
  - "Req 3.1 — Skip mirrors non-GitHub path → cleanup"
  - "Req 3.2 — Logic in kanban-pr only"
acceptance_criteria:
  - "pr.md contains a new Precondition Check 3 inserted after Check 2 (all tickets in pipeline) and before Derive Subject"
  - "Check 3 runs `git branch --show-current` and tests against the fixed list: main, master, develop, trunk"
  - "If trunk branch detected: `gh api repos/{owner}/{repo}/branches/{branch}/protection` is called"
  - "If protection confirmed: pr.md prints a clear message and continues to Phase 1 (normal flow)"
  - "If unprotected: pr.md prints a clear skip message, makes an empty git commit with message `kanban(pr): skip draft PR for YYYY-MM-DD-<subject> — trunk branch unprotected`, and instructs proceeding to kanban-cleanup"
  - "If gh check fails for any reason (no auth, no network, error): pr.md stops with a clear message and asks the user whether to skip or raise a PR"
  - "If current branch is NOT a trunk branch: Check 3 passes silently, normal flow continues"
  - "grep 'main\\|master\\|develop\\|trunk' skills/kanban/commands/pr.md returns a match in the new check block"
  - "Phases 1–4 of pr.md are unchanged"
consecutive_failures: 0
---

## Context

Adds Precondition Check 3 to `pr.md`. After confirming GitHub remote and all tickets in the pipeline (Checks 1–2), the command now detects trunk branches and routes accordingly: skip (unprotected), proceed (protected), or stop and ask (check failed). The skip path emits an audit-trail commit before handing off to cleanup.

Insertion point: after Precondition Check 2, before Derive Subject.

Traced to: Req 1.1, 1.2, 2.1, 2.2, 2.3, 2.4, 3.1, 3.2.

## Acceptance Criteria

- New Precondition Check 3 exists in pr.md, in the correct position
- Trunk list: main, master, develop, trunk — exact match
- Three-way outcome: protected → normal flow; unprotected → skip with commit; failed → stop and ask
- Skip commit message format: `kanban(pr): skip draft PR for YYYY-MM-DD-<subject> — trunk branch unprotected`
- Non-trunk branches: check passes silently
- Phases 1–4 unchanged

---
<!-- Everything below this line is append-only and chronological -->

## Work Log — 2026-03-21T21:20:00Z

Added Precondition Check 3 — Trunk Branch to `skills/kanban/commands/pr.md`.

The new block was inserted immediately after the existing Precondition Check 2 (all tickets must have reached `05-pull-request/`) and immediately before the `## Derive Subject` section. It instructs the agent to run `git branch --show-current` and test the result against the hardcoded list `main`, `master`, `develop`, `trunk`. If the branch is not on the list the check passes silently and execution falls through to Derive Subject. If the branch is on the list, the agent derives `{owner}/{repo}` from `git remote get-url origin` and calls `gh api repos/{owner}/{repo}/branches/{branch}/protection`. A protected result prints a confirmation message and continues to Phase 1; a 404/unprotected result prints a skip message, emits an empty commit with the message `kanban(pr): skip draft PR for YYYY-MM-DD-<subject> — trunk branch unprotected`, and routes to `/kanban-cleanup`; any other error causes a hard stop and asks the user whether to skip or raise a PR. Phases 1–4 are unchanged.

## Review — 2026-03-21T21:35:00Z — PASS 100%

Reviewers: Echo (Examiner) + Arden (Critic)

| AC | Evidence (pr.md lines) | Result |
|---|---|---|
| 1. Check 3 after Check 2, before Derive Subject | Lines 45–69 between line 43 (Check 2 end) and line 74 (Derive Subject) | SATISFIED |
| 2. `git branch --show-current`, fixed list main/master/develop/trunk | Line 47 — exact list present | SATISFIED |
| 3. `gh api repos/{owner}/{repo}/branches/{branch}/protection` called | Lines 54–58 | SATISFIED |
| 4. Protected → clear message + continue to Phase 1 | Line 62: "Branch is protected — proceeding with PR flow." | SATISFIED |
| 5. Unprotected → skip message + empty commit with exact message + cleanup | Lines 63–67, exact commit message on line 65 | SATISFIED |
| 6. Check fails → STOP, clear message, ask user to skip or raise PR | Line 68 | SATISFIED |
| 7. Non-trunk → passes silently | Lines 49–50 | SATISFIED |
| 8. grep returns match in check block | Lines 47 and 65 both within block (lines 45–69) | SATISFIED |
| 9. Phases 1–4 unchanged | Lines 78–255 unmodified | SATISFIED |

Score: 9/9 = 100%
