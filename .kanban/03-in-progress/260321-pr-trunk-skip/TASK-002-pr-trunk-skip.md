---
id: "260321-pr-trunk-skip/TASK-002"
subject: "260321-pr-trunk-skip"
plan: "../../01-plan/260321-pr-trunk-skip/plan-pr-trunk-skip.md"
effort: medium
status: in-progress
created_at: "2026-03-21T00:00:00Z"
claimed_at: "2026-03-21T21:20:00Z"
completed_at: ~
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
  - "If unprotected: pr.md prints a clear skip message, makes an empty git commit with message `kanban(pr): skip draft PR for YYMMDD-<subject> — trunk branch unprotected`, and instructs proceeding to kanban-cleanup"
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
- Skip commit message format: `kanban(pr): skip draft PR for YYMMDD-<subject> — trunk branch unprotected`
- Non-trunk branches: check passes silently
- Phases 1–4 unchanged

---
<!-- Everything below this line is append-only and chronological -->
