# Phase 2 — Scout Research (Brief)
<!-- Part of: tickets.md orchestrator -->
<!-- Active when: plan file loaded and enumerated (Phase 1 complete) -->

Activate **Finn (Scout)**. Run a quick, focused codebase scan to inform ticket scope and dependencies. This is not a full research session — it supplements the `01-research-{subject}.md` snapshot already written during Step 2.

Scout is read-only. No files are modified in this phase.

### Scout Tasks

1. Read `01-research-{subject}.md` if it exists — avoid duplicating work already done.
   **Before loading, apply its staleness policy:** LOAD WITH CAVEAT (TTL: 48 hours). Check its `created_at` frontmatter field (or file mtime as fallback).
   - If age ≤ 48 hours: load normally.
   - If age > 48 hours: load, but prepend this warning to any extracted content:
     ⚠ STALE (written {N} days ago): treat as reference only. Verify against current codebase before acting.
2. Identify any relevant files, patterns, or conventions that have changed since that snapshot.
3. Check what already exists so tickets don't duplicate implemented work.
<!-- WHY four-criteria dependency rule exists: H12 (run 3) found that vague "note dependencies" instructions missed indirect and infrastructure dependencies — agents identified only sequential ordering and missed shared-schema and auth-layer dependencies. The four-criteria rule (trigger condition + dependency-type examples + output format + coverage mandate) makes detection deterministic. -->
4. Identify dependency ordering between work items. For each requirement from the plan, check: does it create or modify a file, database schema, API contract, configuration key, or data structure that any other requirement would read or consume? If yes, the creating requirement must be completed before the consuming one — express this as "Req X → Req Y (reason: X creates the schema/API/file that Y needs)". Also check for shared-infrastructure dependencies: if any requirement modifies the auth layer, database schema, or core utilities, all requirements that depend on that infrastructure depend on it implicitly — list those downstream requirements explicitly. Check ALL requirements — do not rely only on the most obvious sequential ordering.

Scout does not write a new research file here. If findings are significant, note them inline as you draft tickets (Phase 3).

→ Next: Read `tickets/p3-draft-tickets.md` and execute it.
