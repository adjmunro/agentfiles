# Phase 4 — Critic Audit Gate
<!-- Part of: tickets.md orchestrator -->
<!-- Active when: all ticket files drafted and committed (Phase 3 done) -->

Activate **Arden (Critic)**. Audit ticket coverage against plan requirements.

### Scoring

- **Full** — requirement is directly addressed by a ticket's AC with a verifiable command or observable state
  > ✗ Vague AC that yields Partial: "the implement skill works" / ✓ Concrete AC that yields Full: "`/implement work` exits without error and moves ticket to `05-in-progress/`"
- **Partial** — requirement is mentioned in a ticket's context or `plan_items` but the AC doesn't fully verify it
  > ✗ Vague: "ticket references the requirement but has no testable AC" / ✓ Fix: strengthen the AC to include a command with expected output
- **Missing** — no ticket addresses the requirement
  > ✗ Vague gap report: "coverage seems thin" / ✓ Concrete gap: "Requirement 4 (audit scoring formula) has no ticket; create TASK-NNN with AC: `score formula returns 87.5 for 7 full + 1 partial out of 8`"

Score: `(full + 0.5 × partial) / total × 100`

**Threshold: 95%.** Do not round up.

### Audit Table

Build a coverage table:

| # | Requirement | Ticket(s) | Status | Notes |
|---|-------------|-----------|--------|-------|
| 1 | Req text    | TASK-001  | Full   |       |

<!-- WHY dependency graph audit exists: H7 (run 2) found that coverage audits passed (all requirements mapped to tickets) while dependency edges were missing. Without explicit ordering, implementation attempts could fail because a dependent ticket was started before its upstream was complete. -->
### Dependency Graph Audit (mandatory — run after the coverage audit passes)

After the coverage audit reaches 95%, verify dependency completeness:

For each ticket in `03-refinement/`, check whether its work logically presupposes any other ticket's output. If a ticket's implementation requires output from another ticket that is not listed in its `depends_on` field, add the missing dependency edge.

Build a brief dependency chain summary:

```
TASK-001 → TASK-002 → TASK-003
TASK-001 → TASK-004
```

This is the implementation order — verify it is consistent with the plan's requirement ordering. If any missing dependency edges are found, update the affected ticket files and note each correction in the audit block under Fixes Applied.

### Auto-Fix (if score < 95%)

If the score falls below 95%, auto-fix immediately — **never ask permission**:

1. For every **Missing** requirement: create a new ticket in `03-refinement/` that covers it.
2. For every **Partial** requirement: strengthen the relevant ticket's ACs so they are fully verifiable.
3. Re-run the audit, update the table and score.
4. Repeat until the threshold is met.

### Audit Block

**Idempotency guard:** Before appending, check whether a line matching `## Audit: plan → tickets` already exists in `02-plan-{subject}.md`. If it does → the audit block is already recorded. Skip the append and proceed to p5-commit.md.

Append this block to the plan file (`02-plan-{subject}.md`):

```markdown
## Audit: plan → tickets — PASS|FAIL
**Date**: ISO8601  **Threshold**: 95%

| # | Requirement | Ticket(s) | Status | Notes |
|---|------------|-----------|--------|-------|
| 1 | Req text   | TASK-001  | Full   |       |

- Full: N, Partial: N, Missing: N — Total: N
- Score: (full + 0.5×partial) / total × 100 = **XX%**

### Fixes Applied
- Created TASK-NNN for requirement X (was Missing)
- Strengthened TASK-NNN AC for requirement Y (was Partial)
```

Git commit after audit passes:

```
kanban(tickets): audit verified {subject}
```
Body: coverage score, total requirement count, and a note of any tickets auto-created or ACs strengthened during the fix pass (or "no fixes required" if all requirements were Full on first pass).

### Key Rules Summary

| Rule | Detail |
|------|--------|
| Ticket destination | `03-refinement/` only — never `04-todo/` |
| TASK-001 | Always TDD red phase — no exceptions |
| ACs | Must be empirically verifiable commands or observable states |
| Audit threshold | 95% — do not round up |
| Auto-fix | Fix gaps immediately — never ask permission |
| Version/changelog tickets | Never create these — they happen automatically in commits |
| Frontmatter schema | Fixed — use exact fields from schema above |

→ Next: Read `tickets/p5-commit.md` and execute it.
