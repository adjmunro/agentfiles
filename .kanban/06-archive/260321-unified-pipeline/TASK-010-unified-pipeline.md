---
id: "260321-unified-pipeline/TASK-010"
subject: "260321-unified-pipeline"
plan: "../../01-plan/260321-unified-pipeline/plan-unified-pipeline.md"
effort: low
status: done
created_at: "2026-03-22T00:00:00Z"
claimed_at: "2026-03-22T00:00:00Z"
completed_at: "2026-03-22T00:00:00Z"
stale_after_hours: 4
depends_on:
  - "TASK-009"
spawned_tickets: []
plan_items:
  - "Req 3.1 — /kanban command; skills/kanban2/"
  - "Req 1.1 — subject dir name: YYYY-MM-DD-{subject}/"
  - "Req 1.2–1.4 — loose docs (00-input, 01-research, 02-plan) + 00-assets/ + stage subdirs 03-08"
  - "Req 1.7 — archive path: .kanban/.archive/YYYY-MM-DD-{subject}/"
  - "Req 1.8 — v1 structure coexists unchanged"
acceptance_criteria:
  - "[ -f skills/kanban2/commands/init.md ] — file exists"
  - "grep -q 'model:' skills/kanban2/commands/init.md — frontmatter has model field"
  - "grep -q 'allowed-tools:' skills/kanban2/commands/init.md — frontmatter has allowed-tools"
  - "grep -qi 'YYYY-MM-DD' skills/kanban2/commands/init.md — subject dir naming convention documented"
  - "grep -qi '03-refinement' skills/kanban2/commands/init.md — 03-refinement/ stage dir referenced"
  - "grep -qi '04-todo' skills/kanban2/commands/init.md — 04-todo/ stage dir referenced"
  - "grep -qi '08-done' skills/kanban2/commands/init.md — 08-done/ stage dir referenced"
  - "grep -qi '00-assets' skills/kanban2/commands/init.md — 00-assets/ dir referenced"
  - "grep -qi '\\.archive' skills/kanban2/commands/init.md — .kanban/.archive/ path referenced"
  - "grep -qi 'coexist\\|v1\\|01-plan\\|02-todo' skills/kanban2/commands/init.md — v1 coexistence noted"
consecutive_failures: 0
---

## Context

Writes `skills/kanban2/commands/init.md` — the setup command that creates the new subject-centric `.kanban/YYYY-MM-DD-{subject}/` directory structure. Creates all stage subdirectories (`03-refinement/` through `08-done/`) and the `00-assets/` folder. Documents the archive path (`.kanban/.archive/YYYY-MM-DD-{subject}/`). Notes that v1 structure (`.kanban/{stage}/{subject}/`) coexists unchanged.

Command model: `claude-haiku-4-5-20251001` (low-tier, simple directory creation).

## Acceptance Criteria

- `skills/kanban2/commands/init.md` exists with valid frontmatter
- `YYYY-MM-DD-{subject}/` naming convention documented
- All stage directories referenced: `03-refinement/`, `04-todo/`, `05-in-progress/`, `06-in-review/`, `07-pull-request/`, `08-done/`
- `00-assets/` creation documented
- `.kanban/.archive/` path documented for later use
- V1 coexistence behaviour noted (does not touch v1 structure)

---
<!-- Everything below this line is append-only and chronological -->

## Work Log — 2026-03-22

**Ticket claimed** at 2026-03-22T00:00:00Z

### Implementation Complete

Created `skills/kanban2/commands/init.md` — the setup command for the new subject-centric kanban2 structure.

**Deliverables:**
- Valid frontmatter with `model: claude-haiku-4-5-20251001` and `allowed-tools` specification
- Frontmatter includes `argument-hint: "[YYYY-MM-DD-{subject}] — subject to initialize"`
- Clear documentation of the `YYYY-MM-DD-{subject}/` naming convention with examples
- Full Phase 1–5 workflow: Resolve Subject → Check Existing → Create Structure → V1 Coexistence → Report
- All stage directories documented: `03-refinement/`, `04-todo/`, `05-in-progress/`, `06-in-review/`, `07-pull-request/`, `08-done/`
- `00-assets/` directory creation documented with `.gitkeep` for git tracking
- Archive path documented: `.kanban/.archive/YYYY-MM-DD-{subject}/` for future cleanup command use
- V1 coexistence behavior explicitly noted (v1 structure at `.kanban/01-plan/`, `.kanban/02-todo/`, etc. remains untouched)

### Acceptance Criteria Verification

All 10 acceptance criteria verified passing:
1. ✓ File exists at `skills/kanban2/commands/init.md`
2. ✓ Frontmatter has `model:` field
3. ✓ Frontmatter has `allowed-tools:` field
4. ✓ `YYYY-MM-DD` naming convention documented
5. ✓ `03-refinement/` stage dir referenced
6. ✓ `04-todo/` stage dir referenced
7. ✓ `08-done/` stage dir referenced
8. ✓ `00-assets/` dir referenced
9. ✓ `.kanban/.archive/` path referenced
10. ✓ V1 coexistence noted (mentions v1, 01-plan, 02-todo, coexistence)

**Status: Ready for merge**

### Review — 2026-03-22

**Result: PASS (10/10 — 100%)**

All 10 acceptance criteria verified against `skills/kanban2/commands/init.md`:

1. PASS — File exists
2. PASS — `model: claude-haiku-4-5-20251001` present in frontmatter
3. PASS — `allowed-tools:` present in frontmatter
4. PASS — `YYYY-MM-DD` naming convention documented throughout
5. PASS — `03-refinement/` referenced (lines 14, 68, 73, 84, 116)
6. PASS — `04-todo/` referenced (lines 14, 69, 74, 116)
7. PASS — `08-done/` referenced (lines 14, 75)
8. PASS — `00-assets/` referenced (lines 15, 69, 78, etc.)
9. PASS — `.kanban/.archive/` path referenced (lines 16, 86, 97, 114, 116)
10. PASS — V1 coexistence noted (v1, 01-plan, 02-todo, coexists all present)

Ticket moved to `05-pull-request/`. Status set to `done`.
