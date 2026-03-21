---
id: "260321-unified-pipeline/TASK-007"
subject: "260321-unified-pipeline"
plan: "../../01-plan/260321-unified-pipeline/plan-unified-pipeline.md"
effort: medium
status: done
created_at: "2026-03-22T00:00:00Z"
claimed_at: "2026-03-22T00:00:00Z"
completed_at: "2026-03-22T00:00:00Z"
stale_after_hours: 4
depends_on:
  - "TASK-002"
spawned_tickets: []
plan_items:
  - "Req 2.3 Step 7 — Write tickets: draft all tickets into 03-refinement/"
  - "Req 2.3 Step 8 — Audit tickets: check all plan requirements map to ticket ACs; 95% threshold; auto-fix gaps"
  - "Req 2.4 — tickets during ideation live in 03-refinement/ only"
  - "Req 4.1 — ticket frontmatter schema"
  - "Req 4.1 — git commit after phase completes"
acceptance_criteria:
  - "[ -f skills/ideation/commands/tickets.md ] — file exists"
  - "grep -q 'model:' skills/ideation/commands/tickets.md — frontmatter has model field"
  - "grep -q 'allowed-tools:' skills/ideation/commands/tickets.md — frontmatter has allowed-tools"
  - "grep -qi '03-refinement' skills/ideation/commands/tickets.md — references 03-refinement/ as ticket staging dir"
  - "grep -qi '95' skills/ideation/commands/tickets.md — 95% audit threshold documented"
  - "grep -qi 'auto.fix\\|auto fix' skills/ideation/commands/tickets.md — auto-fix requirement present"
  - "grep -qi 'acceptance.criteria\\|AC' skills/ideation/commands/tickets.md — AC requirements documented"
  - "grep -qi 'empirical\\|verif' skills/ideation/commands/tickets.md — empirically verifiable ACs requirement"
  - "grep -qi 'frontmatter' skills/ideation/commands/tickets.md — ticket frontmatter schema referenced"
  - "grep -qi 'git' skills/ideation/commands/tickets.md — git commit step present"
consecutive_failures: 0
---

## Context

Writes `skills/ideation/commands/tickets.md` — Steps 7–8 of the ideation flow. Step 7 drafts all tickets into `03-refinement/` (tickets never touch `04-todo/` during ideation). Step 8 runs the critic audit gate: check all plan requirements map to ticket ACs, 95% threshold, auto-fix gaps by creating additional tickets or strengthening ACs.

Ticket scope: limited enough that low-effort models can implement, but each is a complete unit of work. ACs are the testing plan — empirically verifiable.

Command model: `claude-opus-4-6` (heavy reasoning for ticket drafting and critic gate).

## Acceptance Criteria

- `skills/ideation/commands/tickets.md` exists with valid frontmatter
- References `03-refinement/` as the exclusive ticket staging directory during ideation
- 95% audit threshold documented
- Auto-fix rule present (create additional tickets or strengthen ACs to close gaps)
- Empirically verifiable AC requirement documented
- Ticket frontmatter schema referenced
- Git commit step present at end of phase

---
<!-- Everything below this line is append-only and chronological -->

## Work Log — 2026-03-22T00:00:00Z

- Wrote `skills/ideation/commands/tickets.md` (Steps 7–8 of the ideation flow)
- All 10 acceptance criteria verified passing
- Ticket moved: `02-todo/` → `03-in-progress/` → `04-in-review/`

## Review Log — 2026-03-22T00:00:00Z

- Reviewer: kanban-review
- Score: 10/10 = 100% (threshold: 95%) — PASS
- All 10 ACs verified: file exists, model/allowed-tools frontmatter present, 03-refinement/ staging referenced, 95% threshold documented, auto-fix requirement present, AC/acceptance-criteria documented, empirically verifiable requirement present, frontmatter schema referenced, git commit step present
- Ticket moved: `04-in-review/` → `05-pull-request/`
