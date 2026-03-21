Review $ARGUMENTS — audit the implemented code against the PRD to confirm all requirements are satisfied.

## Protocol

1. **Read the PRD** — identify every acceptance criterion, in-scope item, and constraint
2. **Inspect the implementation** — read the relevant source files; run `swift build` and `swift test` to confirm they pass
3. **Map each requirement to the code** — for every item in the PRD, find the specific file and line(s) that satisfy it, or note that it is absent
4. **Classify each item**:
   - **Satisfied** — requirement is fully met by the implementation
   - **Partial** — requirement is partially met; describe what is missing
   - **Missing** — requirement has no corresponding implementation
5. **Calculate** -- Satisfaction % = (satisfied + 0.5 × partial) / total × 100
6. **Verdict**:
   - **PASS** — all items satisfied or partial with trivial gaps that don't affect correctness; no significant issues
   - **FAIL** — one or more items are missing or partial in a way that matters

## Output

Return a clear PASS or FAIL verdict with:
- A table mapping each PRD requirement to its satisfaction status
- For FAIL: a prioritised list of issues, each described specifically enough to be actionable (what is missing, where it should be, why it matters)
- For PASS: a brief summary confirming coverage

Append the verdict and full results table to the PRD, then commit the PRD.

Be a strict but fair reviewer. Raise issues only when they are **significant and valid** — don't flag style preferences or deferred items that are explicitly out of scope in the PRD.
