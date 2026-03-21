---
id: "2026-03-21-pr-trunk-skip/TASK-004"
subject: "2026-03-21-pr-trunk-skip"
plan: "../../01-plan/2026-03-21-pr-trunk-skip/plan-pr-trunk-skip.md"
effort: low
status: done
created_at: "2026-03-21T00:00:00Z"
claimed_at: "2026-03-21T22:00:00Z"
completed_at: "2026-03-21T22:10:00Z"
stale_after_hours: 4
depends_on:
  - "TASK-003"
spawned_tickets: []
plan_items:
  - "Req 4.1 — skills/kanban/ scoped change warrants version bump"
acceptance_criteria:
  - "VERSION.md contains exactly: '**Current version**: 1.2.2'"
  - "CHANGELOG.md has an entry for 1.2.1 (Branch Aware) covering the pr.md trunk-branch check"
  - "CHANGELOG.md has an entry for 1.2.2 (Both Doors) covering the SKILL.md docs addition"
  - "CHANGELOG.md has a 1.2.0 entry (Speak First) for the capture-flow work (separate subject)"
  - "grep '1.2.2' skills/kanban/VERSION.md returns a match"
consecutive_failures: 0
---

## Context

Both `2026-03-21-capture-flow` and `2026-03-21-pr-trunk-skip` are scoped to `skills/kanban/` and both warrant a minor version bump (new behaviour). They ship together as v1.2.0. This ticket handles the bump and changelog entry for the pr-trunk-skip work; coordinate with the capture-flow TASK-006 to ensure only one 1.2.0 entry exists.

Traced to: kanban skill versioning rules (minor bump for new feature).

## Acceptance Criteria

- `VERSION.md` updated to `1.2.0`
- `CHANGELOG.md` has a single top entry for `1.2.0` dated `2026-03-21`
- Entry covers both changes shipping in this version
- Both files confirmed with `grep`

---
<!-- Everything below this line is append-only and chronological -->

### 2026-03-21T22:00:00Z — Kira (Builder) — Version state reconciliation

**Original plan vs. reality:**

The original plan assumed that `2026-03-21-capture-flow` and `2026-03-21-pr-trunk-skip` would ship together as a single combined v1.2.0 minor bump. That plan was coherent at ticket-write time but the two subjects ran independently.

What actually happened:

- `2026-03-21-capture-flow` shipped first and claimed **v1.2.0** ("Speak First") for its capture UX changes. That subject is already archived.
- TASK-002's builder handled the `pr.md` trunk-branch check and bumped to **v1.2.1** ("Branch Aware").
- TASK-003's builder handled the companion `SKILL.md` docs addition and bumped to **v1.2.2** ("Both Doors").

**Verified state (2026-03-21T22:00:00Z):**

- `skills/kanban/VERSION.md` — `**Current version**: 1.2.2` — confirmed
- `skills/kanban/CHANGELOG.md` — entries for 1.2.2, 1.2.1, and 1.2.0 all present and correctly scoped — confirmed

**Outcome:** The original ACs (targeting 1.2.0) were stale. They have been updated in frontmatter to reflect the actual version state. No further version changes are needed — the history is correct as committed.

## Review — 2026-03-21T22:15:00Z — PASS 100%

**Reviewers:** Echo (Examiner) + Arden (Critic)

| AC | Criterion | Result |
|----|-----------|--------|
| 1 | `VERSION.md` contains exactly `**Current version**: 1.2.2` | SATISFIED |
| 2 | `CHANGELOG.md` has a 1.2.1 "Branch Aware" entry covering pr.md trunk-branch check | SATISFIED |
| 3 | `CHANGELOG.md` has a 1.2.2 "Both Doors" entry covering SKILL.md docs addition | SATISFIED |
| 4 | `CHANGELOG.md` has a 1.2.0 "Speak First" entry for capture-flow work | SATISFIED |
| 5 | `grep '1.2.2' skills/kanban/VERSION.md` returns a match | SATISFIED |

**Score:** (5 + 0) / 5 × 100 = **100%** — threshold 95% — PASS

**Notes:** All five updated ACs are fully satisfied. VERSION.md line 5 matches the required string exactly. CHANGELOG.md contains all three expected entries (1.2.0, 1.2.1, 1.2.2) with the correct names and correct scope coverage. The work log provides a clear, coherent explanation of why the original 1.2.0 ACs were stale — the two subjects ran independently rather than co-shipping — and confirms the builder verified the actual state before updating the ACs. No gaps found.
