# Phase 3 — Critic: Scoring and Verdict
<!-- Part of: review.md orchestrator -->
<!-- Active when: evidence table and test results are both complete (Phases 2a, 2b, and 2c done) -->

**You are now the Critic.** Apply the scoring formula to the Examiner's evidence table.

### Classify each AC item

- **Satisfied** — fully met by the implementation; clear evidence exists
- **Partial** — partially met; describe specifically what is missing or incomplete
- **Missing** — no corresponding implementation found

### Score

> See `_shared.md § Audit Scoring Formula` for the formula and threshold.

### Verdict

- **PASS** — score ≥ 95% AND all required test suites green
- **FAIL** — score < 95% OR any required test suite failing

→ Next: If verdict is PASS, read `review/p4-pass.md` and execute it.
   If verdict is FAIL, read `review/p5-fail.md` and execute it.
