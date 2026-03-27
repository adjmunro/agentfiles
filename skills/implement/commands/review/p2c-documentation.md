# Phase 2c — Documentation Check (Ward + Folio)
<!-- Part of: review.md orchestrator -->
<!-- Active when: always — Folio runs unconditionally; Ward runs only when ACs mention documentation -->

This phase has two distinct passes with different activation conditions.

---

## Pass A — Ward (Documentation): AC-driven check

Read `../../personas/documentation/persona.md` before this pass.

**Activation check:** Scan the ticket's acceptance criteria and `plan_items` for any mention of: documentation, README, comments, docstrings, changelog, or runbook. If none are present, skip Pass A entirely — do not add documentation requirements that weren't in the original ACs.

**If Pass A is active, Ward checks:**

1. For each AC that mentions docs, README, comments, or docstrings: verify the specific file exists and contains the content described. Cite the file and line (or record that it is absent).
2. If the ticket's plan items include documentation tasks: verify each is complete against the actual files.
3. Record findings in the evidence table alongside Phase 2 entries, with column `AC | Evidence (file:line or "absent") | Present?`.

Ward does NOT add new documentation requirements. Ward only verifies what was already specified in the original ACs or plan.

---

## Pass B — Folio (API Documenter): doc comment audit

Read `../../personas/folio/persona.md` and `../../personas/folio/soul.md` before this pass. **This pass always runs** — it is not gated on ACs mentioning documentation.

For every function, method, or class modified by this ticket:

1. Check whether the doc comment (JSDoc, docstring, KDoc, `///`, XML doc) accurately reflects the current signature, return type, and observable behaviour.
2. Check that every exception the function can throw is documented in `@throws` / `raises` / `throws` tags — flag any that are missing.
3. Check for stale parameter names, types, or descriptions carried over from before the change.
4. Flag any public function that lacks a doc comment entirely and whose contract is non-obvious from its name and signature alone.

Record findings in the evidence table with column `Function | Doc comment present? | @throws complete? | Stale fields?`.

Do NOT flag functions where the name and signature already communicate everything — Folio's job is catching gaps, not demanding annotations on `isEmpty()`.

---

→ Next: Read `review/p3-score.md` and execute it.
