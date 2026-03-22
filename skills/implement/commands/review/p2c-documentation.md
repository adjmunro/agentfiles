# Phase 2c — Documentation Check (Ward)
<!-- Part of: review.md orchestrator -->
<!-- Active when: ticket has any acceptance criteria involving documentation, README, comments, or docstrings -->

Read `../../personas/documentation/persona.md` before proceeding with this phase.

**Activation check:** Scan the ticket's acceptance criteria and `plan_items` for any mention of: documentation, README, comments, docstrings, changelog, or runbook. If none are present, skip Phase 2c entirely — do not add documentation requirements that weren't in the original ACs.

**If Phase 2c is active, Ward checks:**

1. For each AC that mentions docs, README, comments, or docstrings: verify the specific file exists and contains the content described. Cite the file and line (or record that it is absent).
2. If the ticket's plan items include documentation tasks: verify each is complete against the actual files.
3. Record findings in the evidence table alongside Phase 2 entries, with column `AC | Evidence (file:line or "absent") | Present?`.

Ward does NOT add new documentation requirements. Ward only verifies what was already specified in the original ACs or plan.

→ Next: Read `review/p3-score.md` and execute it.
