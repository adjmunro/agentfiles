---
id: "2026-03-25-outcome-quality-metrics/TASK-006"
subject: "2026-03-25-outcome-quality-metrics"
plan: "../02-plan-outcome-quality-metrics.md"
effort: medium
status: in_progress
created_at: "2026-03-25T00:00:00Z"
claimed_at: "2026-03-24T12:03:14Z"
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-001"
spawned_tickets: []
plan_items:
  - "Req 6.1 — add MX metric definitions to p2-baseline.md custom metric discovery section"
  - "Req 6.2 — MX-OQ1 Interview Acceptance Rate (weight 2×)"
  - "Req 6.3 — MX-OQ2 First-Pass Review Rate (weight 2×)"
  - "Req 6.4 — MX-OQ3 Plan Stability Rate (weight 1×)"
  - "Req 6.5 — MX-OQ4 Session Satisfaction Rate (weight 1×)"
  - "Req 6.6 — MX-OQ5 PR Critique Rate (weight 2×, lower is better)"
  - "Req 6.7 — all metrics skip gracefully with explanation when data is absent; sparse data noted"
  - "Req 6.8 — MX-OQ metrics feed optimise hypothesis phase for causal attribution"
acceptance_criteria:
  - "Grep for 'MX-OQ1' and 'MX-OQ2' and 'MX-OQ3' and 'MX-OQ4' and 'MX-OQ5' in skills/optimise/commands/phases/p2-baseline.md each return at least one match"
  - "Grep for 'Interview Acceptance Rate' in skills/optimise/commands/phases/p2-baseline.md returns at least one match"
  - "Grep for 'First-Pass Review Rate' in skills/optimise/commands/phases/p2-baseline.md returns at least one match"
  - "Grep for 'Plan Stability Rate' in skills/optimise/commands/phases/p2-baseline.md returns at least one match"
  - "Grep for 'Session Satisfaction Rate' in skills/optimise/commands/phases/p2-baseline.md returns at least one match"
  - "Grep for 'PR Critique Rate' in skills/optimise/commands/phases/p2-baseline.md returns at least one match"
  - "Grep for 'insufficient sample\\|sparse' in skills/optimise/commands/phases/p2-baseline.md returns at least one match (sparse data note present)"
  - "Grep for '00-quality' in skills/optimise/commands/phases/p2-baseline.md returns at least one match (metrics reference quality envelope files)"
  - "Grep for 'hypothesis\\|causal' in skills/optimise/commands/phases/p2-baseline.md returns at least one match (causal attribution role documented)"
consecutive_failures: 0
---

## Context

Modifies `skills/optimise/commands/phases/p2-baseline.md` to add five pre-defined MX outcome metrics (MX-OQ1 through MX-OQ5) under the Custom Metric Discovery section (plan §6). These metrics target `.kanban/.archive/*/00-quality-*.md` files and aggregate signals across all archived subjects.

MX-OQ1 (Interview Acceptance Rate) and MX-OQ2 (First-Pass Review Rate) are weight 2×. MX-OQ3 (Plan Stability Rate) and MX-OQ4 (Session Satisfaction Rate) are weight 1×. MX-OQ5 (PR Critique Rate) is weight 2×, lower is better. All five metrics skip gracefully with an explanation if the applicable data does not exist. Sparse data (fewer than 3 archived subjects) is noted as directional only. All metrics are advisory — they inform optimise hypotheses but do not gate anything.

## Acceptance Criteria

- Grep for `MX-OQ1` and `MX-OQ2` and `MX-OQ3` and `MX-OQ4` and `MX-OQ5` in `skills/optimise/commands/phases/p2-baseline.md` each return at least one match
- Grep for `Interview Acceptance Rate` in `skills/optimise/commands/phases/p2-baseline.md` returns at least one match
- Grep for `First-Pass Review Rate` in `skills/optimise/commands/phases/p2-baseline.md` returns at least one match
- Grep for `Plan Stability Rate` in `skills/optimise/commands/phases/p2-baseline.md` returns at least one match
- Grep for `Session Satisfaction Rate` in `skills/optimise/commands/phases/p2-baseline.md` returns at least one match
- Grep for `PR Critique Rate` in `skills/optimise/commands/phases/p2-baseline.md` returns at least one match
- Grep for `insufficient sample` or `sparse` in `skills/optimise/commands/phases/p2-baseline.md` returns at least one match (sparse data handling documented)
- Grep for `00-quality` in `skills/optimise/commands/phases/p2-baseline.md` returns at least one match (metrics reference quality envelope path)
- Grep for `hypothesis` or `causal` in `skills/optimise/commands/phases/p2-baseline.md` returns at least one match (causal attribution role documented)

<!-- Everything below this line is append-only and chronological -->
