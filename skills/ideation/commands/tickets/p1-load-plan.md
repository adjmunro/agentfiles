# Phase 1 — Load Plan
<!-- Part of: tickets.md orchestrator -->
<!-- Active when: command is first invoked — always runs before any other phase -->

Derive the subject using the following priority order. Stop at the first match:

1. **`$ARGUMENTS`** — if arguments contain a `YYYY-MM-DD-*` pattern, use it as-is.
2. **Existing `.kanban/` subject directories** — if exactly one subject directory exists with a `02-plan-*.md` file, use that name.
3. **Git worktree path** — take the last path segment of the current worktree entry.
4. **Conversation context** — synthesise a slug from what the work is about.
5. **Branch name and recent commits** — derive from `git branch --show-current` and `git log --oneline -5`.
6. **Last resort** — combine today's date with a brief summary slug.

**Slugify rules:** lowercase, hyphens for spaces, alphanumerics and hyphens only.

Once the subject is derived, locate the plan file:

```
.kanban/YYYY-MM-DD-{subject}/02-plan-{subject}.md
```

**Before loading the plan file, apply its staleness policy:**
LOAD WITH CAVEAT (TTL: 7 days). Check its `created_at` frontmatter field (or file mtime as fallback).
- If age ≤ 7 days: load normally.
- If age > 7 days: load, but prepend this warning to any extracted content:
  ⚠ STALE (written {N} days ago): treat as reference only. Verify against current codebase before acting.

**STOP:** If the plan file does not exist, report: "No plan found. Run `/ideate` through Step 6 first." Do not proceed.

**STOP:** If the plan file exists but contains no audit section (look for a heading containing "Audit" or "audit"), report: "Plan has not been audited. Run `/ideate` through Step 5 first." Do not proceed.

Read the plan file in full. Enumerate every numbered requirement — these are the items that must map to ticket ACs during the audit.

→ Next: Read `tickets/p2-scout-research.md` and execute it.
