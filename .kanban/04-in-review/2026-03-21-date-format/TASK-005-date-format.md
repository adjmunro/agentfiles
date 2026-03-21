---
id: "260321-date-format/TASK-005"
subject: "260321-date-format"
plan: "../../01-plan/260321-date-format/plan-date-format.md"
effort: low
status: in-review
created_at: "2026-03-21T00:00:00Z"
claimed_at: "2026-03-21T22:50:00Z"
completed_at: "2026-03-21T23:00:00Z"
stale_after_hours: 4
depends_on:
  - "TASK-001"
spawned_tickets: []
plan_items:
  - "Req 5.1 — Update SKILL.md directory structure diagram"
  - "Req 5.2 — Update any other YYMMDD occurrences in docs"
acceptance_criteria:
  - "grep 'YYMMDD' skills/kanban/SKILL.md returns no matches"
  - "The directory structure diagram in SKILL.md shows YYYY-MM-DD-<subject>/ instead of YYMMDD-<subject>/"
  - "grep -r 'YYMMDD' skills/kanban/ --include='*.md' --exclude-dir=commands returns no matches (covers SKILL.md and any other non-command docs)"
consecutive_failures: 0
---

## Context

`SKILL.md` contains one `YYMMDD` occurrence in the directory structure ASCII diagram (~line 55). Update it to `YYYY-MM-DD`. Also scan for any other non-command doc files in `skills/kanban/` that may reference `YYMMDD` and update them.

This ticket is independent of the directory rename (TASK-002) and can run in parallel.

Traced to: Req 5.1, 5.2.

## Acceptance Criteria

- `grep 'YYMMDD' skills/kanban/SKILL.md` returns no matches
- Directory diagram shows `YYYY-MM-DD-<subject>/`
- No other non-command docs contain `YYMMDD`

---
<!-- Everything below this line is append-only and chronological -->

## Work Log — 2026-03-21T22:50:00Z

**Builder (Kira)**

Scanned all non-command `.md` files in `skills/kanban/` for `YYMMDD` occurrences.

**Findings:**
- `skills/kanban/SKILL.md` line 55: `│   └── YYMMDD-<subject>/` — updated to `YYYY-MM-DD-<subject>/`
- `skills/kanban/CHANGELOG.md` — no occurrences
- `skills/kanban/VERSION.md` — no occurrences
- `skills/kanban/AGENTS.md` — no occurrences
- `skills/kanban/CLAUDE.md` — no occurrences

**Post-edit verification:** `grep 'YYMMDD' skills/kanban/SKILL.md` returns no matches. `grep -r 'YYMMDD' skills/kanban/ --include='*.md' --exclude-dir=commands` returns no matches.

**Version bump:** 1.2.2 → 1.2.3 (patch — doc correction in directory diagram)

All acceptance criteria met.
