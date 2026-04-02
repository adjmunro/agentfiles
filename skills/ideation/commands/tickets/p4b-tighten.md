# Phase 4b — Tighten Ticket Prose
<!-- Part of: tickets.md orchestrator -->
<!-- Active when: coverage audit passes at ≥ 95% (Phase 4 done), before commit -->

Run a prose tightening pass over all drafted tickets. This removes filler, strengthens imperatives, resolves passive voice, and elevates impact vocabulary — without changing the meaning or coverage already verified by Phase 4.

### Dispatch

Read `skills/tighten/commands/tighten.md` and execute it with:
- **Target**: `.kanban/YYYY-MM-DD-{subject}/03-refinement/`
- **Flag**: `--no-commit` — the ideation commit in Phase 5 covers these files

The tighten skill runs its own audit phase internally before returning. If tighten reverts any changes, note the count in the Phase 5 commit body.

### Scope

Tighten edits ticket prose only — `## Context` sections, `## Acceptance Criteria` text, and any narrative body content. Frontmatter fields (`effort`, `status`, `depends_on`, etc.) are machine-readable values; tighten must not alter them.

→ Next: Read `tickets/p5-commit.md` and execute it.
