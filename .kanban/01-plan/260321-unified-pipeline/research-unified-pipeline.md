## Research: 260321-unified-pipeline
**Date**: 2026-03-22T00:00:00Z
**Status**: Snapshot — may go stale. Verify before acting.

## Project Structure

Skills live under `skills/<skill-name>/`. No central registry — skills are discovered by convention.

```
skills/
└── kanban/                  ← only existing skill (v1.2.3)
    ├── AGENTS.md
    ├── CHANGELOG.md
    ├── SKILL.md
    ├── VERSION.md
    ├── commands/            ← 9 command files
    └── personas/            ← 11 persona files
```

Neither `skills/ideation/` nor `skills/kanban2/` exist yet. Both need to be created from scratch.

## Relevant Patterns

**Skill anatomy (replicate for both new skills):**
- `AGENTS.md` — git/versioning conventions for the skill
- `CHANGELOG.md` — newest-on-top, `## X.Y.Z — The Name (YYYY-MM-DD)` format
- `SKILL.md` — full overview, state machine, directory structure, command table
- `VERSION.md` — current version + bump/changelog guidance
- `commands/` — individual command files
- `personas/` — ideation and kanban2 reference `../kanban/personas/` rather than duplicating

**Command file anatomy:**
```
---
model: <claude-model-id>
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion
argument-hint: "[...] — description"
---
## Personas
## DO / DO NOT
## Phase N — Name
```

**Key command models:**
- Orchestrators (`next.md`, `ideate.md`): haiku (low tier)
- Heavy reasoning (`capture.md`, `plan.md`): opus-4-6
- Standard work (`todo.md`, `review.md`): sonnet-4-6
- Implementation (`work.md`): haiku (overridden by ticket effort field at runtime)

**Session boundary pattern:** Phase 1 of capture.md and plan.md scans 03-in-progress/04-in-review for active tickets. Whitelist token (`from-plan-handoff`) in todo.md skips the check. Replicate in ideation (skip if `from-ideation-handoff` token present).

**Audit gate:** 95% threshold, `(full + 0.5×partial) / total × 100`, auto-fix all gaps, append structured audit block.

**Ticket frontmatter schema (unchanged from v1):**
```yaml
id, subject, plan, effort, status, created_at, claimed_at, completed_at,
stale_after_hours, depends_on, spawned_tickets, plan_items,
acceptance_criteria, consecutive_failures
```

## Dependencies

**Ideation phase files are independent of each other** but all depend on the scaffold (`skills/ideation/`) existing first. The `ideate.md` orchestrator should be written last, after all phase files are defined, since it wires them together.

**Kanban2 commands are independent of each other** once the scaffold exists. No cross-dependency between kanban2 commands except `next.md` (which dispatches `work.md` and `review.md` by name).

**Personas are shared** — both ideation and kanban2 reference `skills/kanban/personas/` via relative paths (`../kanban/personas/`). No persona files need to be created.

**Versioning:**
- Ideation: independent, starts at v1.0.0
- Kanban2: CHANGELOG.md is a copy of kanban v1's CHANGELOG.md (continuation); VERSION.md continues from v1.2.3 (current kanban version)

## Hazards

**Personas path in commands:** Both new skills will live at `skills/ideation/commands/` and `skills/kanban2/commands/`. Relative path to personas is `../../kanban/personas/` from a command file, or `../kanban/personas/` from the skill root. Verify this in each command file.

**Kanban2 directory mapping** — old v1 paths → new paths:
- `01-plan/{stage}/{subject}/` → `{subject}/00-input-`, `01-research-`, `02-plan-`
- `02-todo/{subject}/TASK-NNN.md` → `{subject}/04-todo/TASK-NNN.md`
- `03-in-progress/` → `{subject}/05-in-progress/`
- `04-in-review/` → `{subject}/06-in-review/`
- `05-pull-request/` → `{subject}/07-pull-request/`
- `06-archive/` → `.kanban/.archive/YYYY-MM-DD-{subject}/`
- New: `03-refinement/` (ideation drafts only), `08-done/` (finished tickets)

Every kanban2 command file must use the new paths throughout — do not carry over v1 paths.

**Ideation `03-refinement/`** — tickets drafted here during steps 7–8 must NOT be confused with `04-todo/`. The `ideate.md` orchestrator manages the promotion from `03-refinement/` → `04-todo/` at step 9 only.

**CHANGELOG.md for kanban2** — scout incorrectly suggested kanban2 starts at v1.0.0. Per plan §6.2, it is a continuation of kanban v1's changelog. Copy `skills/kanban/CHANGELOG.md` as the starting content, then add a new v2.0.0 (or appropriate semver) entry marking the kanban2 initialisation.

## Recommended Ticket Sequence

```
TASK-001  TDD Red Phase                         low     no deps
TASK-002  Ideation scaffold                     low     TASK-001
TASK-003  ideation/capture.md                   medium  TASK-002
TASK-004  ideation/research.md                  medium  TASK-002
TASK-005  ideation/interview.md                 medium  TASK-002
TASK-006  ideation/plan.md                      medium  TASK-002
TASK-007  ideation/tickets.md                   medium  TASK-002
TASK-008  ideation/ideate.md (orchestrator)     high    TASK-007
TASK-009  Kanban2 scaffold                      low     TASK-001
TASK-010  kanban2/init.md                       low     TASK-009
TASK-011  kanban2/work.md                       medium  TASK-009
TASK-012  kanban2/review.md                     medium  TASK-009
TASK-013  kanban2/pr.md                         medium  TASK-009
TASK-014  kanban2/cleanup.md                    medium  TASK-009
TASK-015  kanban2/next.md (orchestrator)        high    TASK-014
```

TASK-002 and TASK-009 can run in parallel (both depend only on TASK-001).
TASK-003–007 can run in parallel (all depend only on TASK-002).
TASK-010–014 can run in parallel (all depend only on TASK-009).
TASK-008 depends on TASK-007 (last phase file, orchestrator written last).
TASK-015 depends on TASK-014 (ensures work/review/pr/cleanup exist before orchestrator).
