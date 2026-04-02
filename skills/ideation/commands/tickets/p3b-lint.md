# Phase 3b — Ticket Lint
<!-- Part of: tickets.md orchestrator -->
<!-- Active when: all ticket files drafted (Phase 3 done), before coverage audit -->

Activate **Arden (Critic)**. Run per-ticket quality checks across all files in `03-refinement/`. This phase checks intrinsic ticket quality — it is distinct from p4's coverage audit (which checks plan → ticket mapping). Fix all auto-fixable issues before proceeding.

### Lint Checks

Run each check against every ticket in `.kanban/YYYY-MM-DD-{subject}/03-refinement/`:

| ID | Check | Auto-fix? |
|----|-------|-----------|
| L1 | `effort` field is set to `low`, `medium`, or `high` (not null or absent) | Yes — infer from AC count |
| L2 | `plan_items` list is non-empty (at least one entry) | No — flag for user |
| L3 | AC count is consistent with the effort tier | Yes — adjust effort label |
| L4 | Every AC contains at least one concrete verifiable signal | No — flag for user |
| L5 | `## Context` section is present and non-empty | No — flag for user |
| L6 | All `depends_on` entries reference tickets that exist in `03-refinement/` | No — flag for user |

**Effort / AC count thresholds (L1 inference, L3 coherence):**
- `low` — 1–3 ACs
- `medium` — 4–6 ACs
- `high` — 7+ ACs

**Concrete verifiable signal (L4 heuristic):** an AC passes L4 if it contains at least one of: an exit code (`exits 0`, `exit 1`), an HTTP status code, a command invocation with expected output, a file path with a named observable property, or a measurable count or value. ACs consisting entirely of prose with no observable anchor fail L4 — e.g. "Documentation updated" fails; "`grep -c 'TODO' docs/` returns 0" passes.

### Lint Table

Build one table covering all tickets:

| Ticket | L1 effort | L2 plan_items | L3 AC/effort | L4 AC specificity | L5 context | L6 depends_on | Status |
|--------|-----------|---------------|--------------|-------------------|------------|---------------|--------|
| TASK-001 | ✓ | ✓ | ✓ | ✓ | ✓ | n/a | PASS |

Mark each cell ✓ (pass) or ✗ with a brief note (e.g. "✗ missing", "✗ AC 2 vague"). The rightmost Status column is PASS only if all checks pass.

### Auto-Fix

Apply all auto-fixable issues immediately — **never ask permission**:

- **L1 — missing or invalid effort**: infer from AC count using the thresholds above. Record: "Set TASK-NNN effort to `{tier}` (inferred from N ACs)."
- **L3 — effort/AC mismatch**: adjust the `effort` field to match the AC count tier. Record: "Adjusted TASK-NNN effort `{old}` → `{new}` (N ACs suggests `{new}`)."

Do not auto-fix L2, L4, L5, or L6 — these require authorial judgement.

### Non-Auto-Fixable Issues

If any L2, L4, L5, or L6 failures remain after fixing L1 and L3, present a consolidated list and wait for the user to resolve each one before re-running the lint table:

> ⚠ Ticket lint issues require resolution before the coverage audit:
>
> - **TASK-NNN L4**: AC "{text}" — no verifiable signal. Rewrite to include a command with expected output, exit code, or observable state.
> - **TASK-NNN L2**: `plan_items` is empty — add at least one plan requirement reference.
> - **TASK-NNN L5**: `## Context` section is missing or empty — add a brief explanation of why this ticket exists.
> - **TASK-NNN L6**: `depends_on` references `TASK-NNN` which does not exist in `03-refinement/` — correct or remove.

Once the user has fixed all flagged issues, re-run the full lint table to confirm every ticket passes before proceeding.

→ Next: Read `tickets/p4-critic-audit.md` and execute it.
