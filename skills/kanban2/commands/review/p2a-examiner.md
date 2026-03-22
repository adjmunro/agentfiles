# Phase 2a — Examiner: Evidence Gathering (read-only)
<!-- Part of: review.md orchestrator -->
<!-- Active when: ticket has been resolved and confirmed in 06-in-review/ with status: in_review -->

**You are now the Examiner.** Your job is to collect evidence — nothing else. Do not score. Do not modify files. Do not run tests yet.

### Step A — Read the Plan

Locate the plan file from the path referenced in the ticket's `plan` frontmatter field. If the path is relative, resolve it from the project root.

**Before loading, apply its staleness policy:** LOAD WITH CAVEAT (TTL: 7 days). Check its `created_at` frontmatter field (or file mtime as fallback).
- If age ≤ 7 days: load normally.
- If age > 7 days: load, but prepend this warning to any extracted content:
  ⚠ STALE (written {N} days ago): treat as reference only. Verify all requirements against the current codebase before scoring.

Read the plan file.

After reading the plan, extract the `## Intent` section and write a 1-sentence intent summary. This sentence MUST be the first line of your evidence report (Step D). All subsequent evidence judgments are anchored to this intent.

### Step B — Read All Changed Source Files

From the ticket's implementation notes or `## Changes` section, identify all files modified during the work session. Read each one in full (use `offset`/`limit` for large files).

If the ticket does not list changed files explicitly, infer them:
- Check `git diff HEAD~1 --name-only` or `git status` for recently modified files
- Cross-reference with the plan's requirements to identify relevant files

### Step C — Map Evidence for Each Acceptance Criterion (AC)

For each AC item listed in the ticket:

1. Identify the specific file(s) and line number(s) that satisfy it — be precise.
2. If the criterion involves a command or observable output (non-coding AC), record the command verbatim; it will be executed in Phase 2b.
3. If no evidence exists, note it explicitly as absent.
4. Flag any of the following, regardless of AC status:
   - Security issues (hardcoded secrets, injection vectors, missing auth checks)
   - Logic errors (off-by-one, incorrect conditionals, missing null checks)
   - Missing WHY-comments on non-obvious decisions

### Step D — Record the Evidence Table (no scores)

Begin the evidence report with the 1-sentence intent summary extracted in Step A. Then produce an internal evidence table with columns: `AC | Evidence (file:line or command) | Present?`

This table is input for the Critic. Do not attach pass/fail labels yet.

→ Next: Read `review/p2b-tests.md` and execute it.
