# Kanban2 Shared Reference

> This file is loaded on demand. Individual command files reference specific sections.
> Do not load this file unless a command file explicitly requests a section.

---

## Ticket Frontmatter Schema

Use exactly these fields. Do not add or remove fields.

```yaml
---
id: "YYYY-MM-DD-{subject}/TASK-NNN"
subject: "YYYY-MM-DD-{subject}"
plan: "../02-plan-{subject}.md"
effort: low | medium | high
status: todo | in_progress | in_review | done
created_at: "ISO8601"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-001"
spawned_tickets: []
plan_items:
  - "Req 2.1 — description"
acceptance_criteria:
  - "Verifiable command or observable output"
consecutive_failures: 0
---
```

Field notes:
- `id` — `YYYY-MM-DD-{subject}/TASK-NNN` where NNN is zero-padded (001, 002, ...)
- `plan_items` — list every plan requirement this ticket addresses
- `depends_on` — omit or leave empty if this ticket has no dependencies
- `acceptance_criteria` — must be empirically verifiable commands or observable states

---

## Ticket Body Structure

```markdown
## Context
[Why this ticket exists — static, set once.]

## Acceptance Criteria
[Complete list — static, set once.]

---
<!-- Everything below this line is append-only and chronological -->

## Work Log — YYYY-MM-DDTHH:MMZ
[What was done, decisions made, why each decision was made.]

## Review — YYYY-MM-DDTHH:MMZ — FAIL 72%
[Evidence table, issue list — written by reviewer, not by Builder.]

## Work Log — YYYY-MM-DDTHH:MMZ
[Addressing review issues from above — reference each issue by number or description.]
```

**Static zone** (`## Context`, `## Acceptance Criteria`): set once at ticket creation.

**Append zone** (below `<!-- Everything below this line is append-only -->`): strictly chronological. Every entry is appended. Existing entries are never edited. This is the cross-agent audit trail.

---

## Audit Scoring Formula

```
score = (satisfied + 0.5 × partial) / total × 100
```

- **Satisfied** — fully met by the implementation; clear evidence exists
- **Partial** — partially met; describe specifically what is missing or incomplete
- **Missing** — no corresponding implementation found

**Threshold: 95%.** PASS requires score ≥ 95% AND all required test suites green.

---

## Directory Structure

```
.kanban/YYYY-MM-DD-{subject}/
├── 00-input-*/          # read-only from kanban2
├── 01-research-*/       # read-only from kanban2
├── 02-plan-*/           # read-only from kanban2
├── 00-assets/           # read-only from kanban2
├── 03-refinement/       # read-only from kanban2
├── 04-todo/             # tickets waiting to be claimed
├── 05-in-progress/      # tickets currently being worked
├── 06-in-review/        # tickets awaiting review
├── 07-pull-request/     # tickets that passed review
├── 08-done/             # archived tickets
└── .claims/             # lock files — one per claimed ticket
```

**Plan-layer isolation:** paths `00-input-*`, `01-research-*`, `02-plan-*`, `00-assets/`, and `03-refinement/` are read-only from kanban2. Never write, move, rename, or delete files in these paths.
