Identify the next PRD to implement, audit it, implement it, and loop through review until it passes.

## Step 1: Identify the next PRD

- Scan `docs/plan/` for PRD files (numbered PRD-XXX-*.md)
- Scan `docs/in-progress/`, `docs/review/`, and `docs/done/` to know what is already started or complete
- Pick the lowest-numbered PRD that is only in `docs/plan/` (not in progress, review, or done)
- Announce which PRD you selected and why

## Step 2: Audit

Run the equivalent of `/audit <selected-PRD> against @docs/specs/spec.md` following the full audit protocol:

1. **Enumerate** -- Parse the spec into discrete, verifiable items relevant to this PRD's scope
2. **Map** -- Classify each as Full / Partial / Missing in the PRD
3. **Calculate** -- Coverage % = (full + 0.5 × partial) / total × 100
4. **Fix** -- Update the PRD for any missing or partial items. Preserve intentions and reasons. Before marking anything missing, check other PRDs in `docs/plan/`, `docs/in-progress/`, `docs/review/`, and `docs/done/` — it may be intentionally deferred
5. **Recalculate** -- Should reach ~100%
6. **Store** -- Append a verification section to the PRD with the coverage map, metrics, and fixes applied
7. **Commit** -- Commit any PRD changes before proceeding

## Step 3: Implement

Run the equivalent of `/implement <selected-PRD>`:

1. Move the PRD to `docs/in-progress/` — commit the move
2. Plan, implement, test — commit after each meaningful unit of work
3. Append the Implementation Summary to the PRD — commit the PRD update
4. Move the PRD to `docs/review/` — commit the move

## Step 4: Review loop

Run the equivalent of `/review <selected-PRD>` — audit the implemented work against the PRD to confirm all requirements are satisfied.

- If `/review` raises **significant and valid issues**:
  1. Add those issues as new tasks in the PRD — commit the PRD update
  2. Move the PRD back to `docs/in-progress/` — commit the move
  3. Run `/implement` again to address the new tasks (commits happen during implementation)
  4. Move the PRD back to `docs/review/` — commit the move
  5. Return to the top of Step 4

- If `/review` **passes** (no significant issues):
  1. Append the review result to the PRD — commit the PRD update
  2. Move the PRD to `docs/done/` — commit the move
