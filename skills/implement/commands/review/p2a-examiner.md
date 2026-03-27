# Phase 2a — Examiner: Evidence Gathering (read-only)
<!-- Part of: review.md orchestrator -->
<!-- Active when: ticket has been resolved and confirmed in 06-in-review/ with status: in_review -->

**You are now the Examiner.** Your job is to collect evidence — nothing else. Do not score. Do not modify files. Do not run tests yet.

### Step A — Read the Plan

Locate the plan file from the path referenced in the ticket's `plan` frontmatter field. If the path is relative, resolve it from the project root.

**Before loading, apply its staleness policy:** LOAD WITH CAVEAT (TTL: 7 days). Check its `created_at` frontmatter field (or file mtime as fallback).
- If the file does not exist at the stated path: STOP. Print "Plan file not found: {path}. Verify the ticket's `plan` frontmatter field or re-run `/implement init`." Do not proceed to evidence gathering.
- If age ≤ 7 days: load normally.
- If age > 7 days: load, but prepend this warning to any extracted content:
  ⚠ STALE (written {N} days ago): treat as reference only. Verify all requirements against the current codebase before scoring.

Read the plan file.

After reading the plan, extract the `## Intent` section and write a 1-sentence intent summary. This sentence MUST be the first line of your evidence report (Step D). All subsequent evidence judgments are anchored to this intent.

### Step B — Read All Changed Source Files

From the ticket's Work Log entries, identify all files modified during the work session. Read each one in full (use `offset`/`limit` for large files).

If the Work Log does not list changed files explicitly, infer them:
- Check `git diff HEAD~1 --name-only` or `git status` for recently modified files
- Cross-reference with the plan's requirements to identify relevant files

### Step C — Map Evidence for Each Acceptance Criterion (AC)

For each AC item listed in the ticket:

1. Identify the specific file(s) and line number(s) that satisfy it — be precise.
2. If the criterion involves a command or observable output (non-coding AC), record the command verbatim; it will be executed in Phase 2b.
   > ✗ Vague: "verify the feature behaves correctly" / ✓ Concrete: "run `npm test -- --testPathPattern=auth` and confirm exit 0 with 0 failures"
3. If no evidence exists, note it explicitly as absent.
   > ✗ Vague: "ensure error handling works" / ✓ Concrete: "send request without auth header; confirm HTTP 401 with `{\"error\":\"unauthorized\"}` in body"
4. Flag any of the following, regardless of AC status:
   - Security issues (hardcoded secrets, injection vectors, missing auth checks)
   - Logic errors (off-by-one, incorrect conditionals, missing null checks)
   - Missing WHY-comments on non-obvious decisions

### Step C.5 — Regression Check

**Vigil (Regression Sentinel) governs this step.** Read `../../personas/vigil/persona.md` before proceeding.

For each file modified during this session (identified in Step B), enumerate the implicit behavioural contracts it holds — promises to callers, output formats, error states, configuration defaults, ordering guarantees. For each contract:

- Is the contract still intact in the new implementation?
- Has any contract been narrowed, broadened, or silently removed without a corresponding doc comment update, test addition, or explicit acknowledgement in the Work Log?

Add a `Regression risk` row to the evidence table (Step D) for any contract that was changed without documentation. If all implicit contracts are intact, record: "No implicit contract violations detected."

### Step D — Record the Evidence Table (no scores)

Begin the evidence report with the 1-sentence intent summary extracted in Step A. Then produce an internal evidence table with columns: `AC | Evidence (file:line or command) | Present?`

Include the `Regression risk` row from Step C.5.

This table is input for the Critic. Do not attach pass/fail labels yet.

→ Next: Read `review/p2b-tests.md` and execute it.
