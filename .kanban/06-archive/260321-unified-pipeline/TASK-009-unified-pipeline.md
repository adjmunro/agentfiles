---
id: "260321-unified-pipeline/TASK-009"
subject: "260321-unified-pipeline"
plan: "../../01-plan/260321-unified-pipeline/plan-unified-pipeline.md"
effort: low
status: done
created_at: "2026-03-22T00:00:00Z"
claimed_at: "2026-03-22T00:00:00Z"
completed_at: "2026-03-22T00:00:00Z"
stale_after_hours: 4
depends_on:
  - "TASK-001"
spawned_tickets: []
plan_items:
  - "Req 3.1 — skill lives at skills/kanban2/; user-facing command /kanban"
  - "Req 6.2 — kanban2 CHANGELOG.md inherits from v1 (continuation, not fresh file)"
  - "Req 6.3 — kanban2 has its own VERSION.md starting at v2.0.0 (breaking change)"
acceptance_criteria:
  - "[ -d skills/kanban2 ] — directory exists"
  - "[ -d skills/kanban2/commands ] — commands/ subdirectory exists"
  - "[ -f skills/kanban2/AGENTS.md ] — AGENTS.md exists"
  - "[ -f skills/kanban2/SKILL.md ] — SKILL.md exists with /kanban command documented"
  - "[ -f skills/kanban2/VERSION.md ] — VERSION.md exists"
  - "grep -c '2.0.0' skills/kanban2/VERSION.md — returns 1 (version is 2.0.0)"
  - "[ -f skills/kanban2/CHANGELOG.md ] — CHANGELOG.md exists"
  - "grep -q '2.0.0' skills/kanban2/CHANGELOG.md — 2.0.0 entry present (kanban2 init)"
  - "grep -q '1.2' skills/kanban2/CHANGELOG.md — inherited v1 entries present (continuation)"
  - "SKILL.md documents new directory structure (YYYY-MM-DD-{subject}/ layout) — verifiable by reading the file"
consecutive_failures: 0
---

## Context

Creates the `skills/kanban2/` scaffold: all structural and documentation files for the kanban2 skill. Establishes the skill as discoverable before any command files are written. Traced to plan §3.1, §6.2, §6.3.

Kanban2 versioning: `CHANGELOG.md` is a continuation of `skills/kanban/CHANGELOG.md` — copy the v1 changelog as the starting content, then add a new `## 2.0.0 —` entry marking the kanban2 initialisation (breaking change: new subject-centric directory structure). `VERSION.md` starts at v2.0.0.

Personas are not duplicated — commands reference `../../kanban/personas/` (relative from `skills/kanban2/commands/`).

## Acceptance Criteria

- `skills/kanban2/` directory exists with `commands/` subdirectory
- `skills/kanban2/AGENTS.md` — documents git/versioning conventions for this skill
- `skills/kanban2/SKILL.md` — documents the `/kanban` command, the new directory structure, state machine, and command table
- `skills/kanban2/VERSION.md` — contains `**Current version**: 2.0.0`
- `skills/kanban2/CHANGELOG.md` — contains v1 inherited entries AND a `## 2.0.0 —` entry

---
<!-- Everything below this line is append-only and chronological -->

## Work Log

### Session 2026-03-22 — Kanban2 Scaffold Implementation

**Completed**: 2026-03-22T00:00:00Z

#### Phase 1: Directory Structure
- Created `skills/kanban2/` root directory
- Created `skills/kanban2/commands/` subdirectory
- Added `.gitkeep` file to `commands/` to preserve the directory in version control

#### Phase 2: AGENTS.md Documentation
- Documented git commit conventions (conventional commits, never force push)
- Documented ticket movement via `mv` (preserve audit trail)
- Documented versioning strategy: semver starting at 2.0.0 (major breaking change from v1)
- Documented changelog guidelines: newest-on-top, catchy names, brief descriptions

#### Phase 3: VERSION.md
- Set **Current version** to 2.0.0 (breaking change from v1's 1.2.3)
- Documented upstream URL for version checks
- Included version request handling, update check, and changelog lookup procedures

#### Phase 4: CHANGELOG.md
- Copied entire v1 changelog (versions 0.1.0 through 1.2.3) as inherited content
- Prepended new `## 2.0.0 — The New Order (2026-03-22)` entry describing:
  - Subject directory format: `YYYY-MM-DD-{subject}/`
  - Stage renumbering: `04-todo/` through `08-done/`
  - Plan-layer isolation: kanban2 never touches ideation files/directories
  - Persona sharing from `../../kanban/personas/`
  - Work loop routing and completion signal

#### Phase 5: SKILL.md Documentation
- Documented `/kanban` user-facing command with subcommand routing (init, work, review, pr, cleanup, next)
- Diagrammed complete subject-centric directory structure showing:
  - Ideation-only layers: `00-input-`, `01-research-`, `02-plan-`, `00-assets/`, `03-refinement/`
  - Kanban2 work layers: `04-todo/` through `08-done/`
  - Archive structure: `.kanban/.archive/YYYY-MM-DD-{subject}/`
- Documented state machine with full routing diagram (work → review → PASS/FAIL → pr/return → done)
- Created command table showing all 6 subcommands with purpose, input, output
- Documented distinction from kanban v1:
  - New directory structure with numbered stage progression
  - Plan-layer isolation (no touching of ideation files)
  - Archive path for finished work
  - Shared persona references
  - Carried-forward discipline (conventional commits, critic gates, per-unit commits, TDD red phases)
- Listed all 11 personas with roles (6 core + 5 extended)
- Documented session design: work-only, hard session boundaries, escalation/stale detection logic

#### Acceptance Criteria Verification
- ✓ `[ -d skills/kanban2 ]`
- ✓ `[ -d skills/kanban2/commands ]`
- ✓ `[ -f skills/kanban2/AGENTS.md ]`
- ✓ `[ -f skills/kanban2/SKILL.md ]` with /kanban command documented
- ✓ `[ -f skills/kanban2/VERSION.md ]`
- ✓ `grep -c '2.0.0' skills/kanban2/VERSION.md` returns 1
- ✓ `[ -f skills/kanban2/CHANGELOG.md ]`
- ✓ `grep -q '2.0.0' skills/kanban2/CHANGELOG.md`
- ✓ `grep -q '1.2' skills/kanban2/CHANGELOG.md` (inherited v1 entries)
- ✓ SKILL.md documents new directory structure (YYYY-MM-DD-{subject}/ layout)

All acceptance criteria verified and passing.

---

## Review Audit — 2026-03-22

**Reviewer**: kanban-review
**Result**: PASS
**Score**: 10/10 (100%) — threshold 95%

| # | Criterion | Result |
|---|-----------|--------|
| 1 | `[ -d skills/kanban2 ]` | PASS |
| 2 | `[ -d skills/kanban2/commands ]` | PASS |
| 3 | `[ -f skills/kanban2/AGENTS.md ]` | PASS |
| 4 | `[ -f skills/kanban2/SKILL.md ]` with /kanban documented | PASS |
| 5 | `[ -f skills/kanban2/VERSION.md ]` | PASS |
| 6 | `grep -c '2.0.0' VERSION.md` returns 1 | PASS |
| 7 | `[ -f skills/kanban2/CHANGELOG.md ]` | PASS |
| 8 | `grep -q '2.0.0' CHANGELOG.md` | PASS |
| 9 | `grep -q '1.2' CHANGELOG.md` | PASS |
| 10 | SKILL.md documents `YYYY-MM-DD-{subject}/` structure | PASS |

All structural files present. VERSION.md at 2.0.0. CHANGELOG.md inherits v1 entries (0.1.0–1.2.3) and prepends `## 2.0.0 — The New Order`. SKILL.md documents `/kanban` command, full directory diagram, state machine, and command table. Moving to `05-pull-request/`.
