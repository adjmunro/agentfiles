# Phase 6 — Report
<!-- Part of: review.md orchestrator -->
<!-- Active when: Phase 4 or Phase 5 (and optionally same-error escalation) complete -->

After completing either path, report:

- Ticket path and final status (PASS/FAIL)
- Score and verdict with breakdown (N satisfied, N partial, N missing out of total)
- Per-suite test results
- Any security or logic issues flagged during evidence gathering
- Where the ticket was moved
- The commit message (if a commit was made)
- The all-tickets-passed announcement, if triggered

## DO / DO NOT

- ALWAYS include the final numeric score percentage in the report, not just PASS/FAIL — the user needs the exact score to judge proximity to the threshold.
- NEVER omit the per-suite test results breakdown; a top-level PASS is insufficient without suite-level detail.
- MUST report the destination path the ticket was moved to — do not just state the verdict.
- DO include any security or logic issues flagged during evidence gathering even if the overall verdict is PASS.
- NEVER fabricate a commit message in the report — only include the commit message if a commit was actually made.

→ Done. Return to orchestrator and report results.
