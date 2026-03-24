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

## Work Log — 2026-03-24T12:03:14Z

Implemented Req 6.1–6.8 by inserting a new "Pre-Defined MX Outcome Metrics (MX-OQ series)"
subsection into `skills/optimise/commands/phases/p2-baseline.md` immediately before the
`### Composite Calculation` block — the correct placement is after the custom metric
heuristics and before the composite table, so Pulse will encounter and evaluate these
metrics as part of every custom metric discovery step.

**Placement decision (WHY after heuristic block, before composite):** The pre-defined MX-OQ
metrics are part of custom metric discovery, not seed metrics — they should be evaluated
alongside any agent-discovered custom metrics and included in the composite table. Putting
them after the seed definitions but before the composite ensures they appear in the right
ordering without being confused with M1–M15.

**Structure decision (WHY #### headings, not ### ):** The existing custom metric template
uses `###` for discovered metrics. Using `####` for MX-OQ entries distinguishes
pre-defined from agent-discovered metrics, making it visually clear which metrics are
canonical and which are discovered per-run. This avoids future confusion when the composite
table is assembled.

**Skip logic (WHY explicit SKIP condition on each metric, Req 6.7):** Each metric documents
its exact skip condition and the reason text Pulse should write. This makes skip behaviour
deterministic — Pulse does not need to judge whether to skip, only whether the file pattern
exists. Reduces ambiguity and satisfies AC for graceful skipping.

**Sparse data note (WHY inline on each metric, Req 6.7):** Rather than a single shared
note, the "insufficient sample — treat as directional only" guidance is stated in the
shared preamble section. This means it applies uniformly to all five metrics without
repeating the exact wording five times.

**Causal attribution (WHY explicit paragraph, Req 6.8):** Added a dedicated paragraph in
the preamble explaining that MX-OQ metrics are designed to feed the Phase 3 hypothesis
step for causal attribution. The paragraph explicitly names the pattern (correlate MX-OQ
with M1–M15 to find structural causes of outcome degradation) and assigns responsibility
to the hypothesis phase, not the baseline phase.

All nine ACs verified via Grep before commit:
- MX-OQ1, MX-OQ2, MX-OQ3, MX-OQ4, MX-OQ5 — present
- Interview Acceptance Rate, First-Pass Review Rate, Plan Stability Rate,
  Session Satisfaction Rate, PR Critique Rate — present
- "insufficient sample" — present in preamble
- "00-quality" — present in applies-when and skip-condition lines for all five metrics
- "hypothesis" and "causal" — present in preamble paragraph and MX-OQ3 WHY comment
