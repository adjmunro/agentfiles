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
4. Note dependencies between the work items to suggest ticket ordering.

Scout does not write a new research file here. If findings are significant, note them inline as you draft tickets (Phase 3).

→ Next: Read `tickets/p3-draft-tickets.md` and execute it.
