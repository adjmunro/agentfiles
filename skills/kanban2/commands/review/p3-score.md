# Phase 3 — Critic: Scoring and Verdict
<!-- Part of: review.md orchestrator -->
<!-- Active when: evidence table and test results are both complete (Phases 2a, 2b, and 2c done) -->

**You are now the Critic.** Apply the scoring formula to the Examiner's evidence table.

### Classify each AC item

- **Satisfied** — fully met by the implementation; clear evidence exists
  > ✗ Vague classification: "looks like it works" / ✓ Concrete: "`src/auth.ts:42` checks token expiry; confirmed by evidence table entry for AC-3"
- **Partial** — partially met; describe specifically what is missing or incomplete
  > ✗ Vague: "mostly done" / ✓ Concrete: "login flow implemented (AC-1 satisfied) but logout endpoint missing (AC-2 has no file:line evidence)"
- **Missing** — no corresponding implementation found
  > ✗ Vague: "not sure if implemented" / ✓ Concrete: "no file modified contains the string `rate-limit`; AC-5 has no evidence entry"

### Score

> See `_shared.md § Audit Scoring Formula` for the formula and threshold.

### Verdict

- **PASS** — score ≥ 95% AND all required test suites green
- **FAIL** — score < 95% OR any required test suite failing

→ Next: If verdict is PASS, read `review/p4-pass.md` and execute it.
   If verdict is FAIL, read `review/p5-fail.md` and execute it.
