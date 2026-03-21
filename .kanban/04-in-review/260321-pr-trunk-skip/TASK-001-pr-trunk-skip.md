---
id: "260321-pr-trunk-skip/TASK-001"
subject: "260321-pr-trunk-skip"
plan: "../../01-plan/260321-pr-trunk-skip/plan-pr-trunk-skip.md"
effort: low
status: in-review
created_at: "2026-03-21T00:00:00Z"
claimed_at: "2026-03-21T21:00:00Z"
completed_at: "2026-03-21T21:10:00Z"
stale_after_hours: 4
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
  - "Req 4.1 — SKILL.md documents both bypass conditions"
acceptance_criteria:
  - "A checklist exists enumerating every new behaviour introduced to pr.md and SKILL.md, written before any edits to either file"
  - "Each checklist item is falsifiable by reading the final pr.md or SKILL.md"
  - "Checklist covers: trunk detection (branch names), protection check (gh command used), three-way outcome (protected/unprotected/failed), skip path (commit + handoff to cleanup), SKILL.md second bypass condition"
  - "pr.md and SKILL.md are unmodified at the end of this ticket"
consecutive_failures: 0
---

## Context

Before touching `pr.md` or `SKILL.md`, document exactly what the new trunk-skip behaviour must do — in enough detail that any edit can be verified against it. This is the red phase: define the target state first, then implement against it.

Traced to: all plan requirements (1.1–4.1).

## Acceptance Criteria

- Checklist of all new behaviours written before any file edits
- Each item falsifiable by reading the final files
- Covers: trunk detection, protection check via gh, three-way branch (protected/unprotected/failed), skip commit, cleanup handoff, SKILL.md two-bypass note
- `pr.md` and `SKILL.md` unmodified at end of this ticket

---
<!-- Everything below this line is append-only and chronological -->

## Work Log — 2026-03-21T21:00:00Z

Checklist written to `.kanban/01-plan/260321-pr-trunk-skip/verify-pr-trunk-skip.md`.

The checklist covers all nine plan requirements across six sections: trunk detection (the four fixed branch names and placement before Phase 1), the exact `gh api repos/{owner}/{repo}/branches/{branch}/protection` command used for the protection check, the three-way outcome (protected → continue, unprotected/non-GitHub → skip, check failure → stop and ask), the skip path (commit message shape, handoff to kanban-cleanup, what is NOT done), SKILL.md documentation of both bypass conditions with the protection-check caveat, and scope constraints confirming kanban-next and all other commands remain untouched. Every item maps back to a plan requirement and can be verified by reading the final `pr.md` or `SKILL.md`.

pr.md and SKILL.md unmodified.
