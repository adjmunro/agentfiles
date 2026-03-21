---
id: "260321-unified-pipeline/TASK-006"
subject: "260321-unified-pipeline"
plan: "../../01-plan/260321-unified-pipeline/plan-unified-pipeline.md"
effort: medium
status: in_review
created_at: "2026-03-22T00:00:00Z"
claimed_at: "2026-03-22T00:00:00Z"
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-002"
spawned_tickets: []
plan_items:
  - "Req 2.3 Step 4 — Write plan: draft 02-plan-{subject}.md from captured input + interview answers"
  - "Req 2.3 Step 5 — Audit plan: critic gate, 95% threshold, auto-fix all gaps, append audit block"
  - "Req 4.1 — audit formula: (full + 0.5×partial) / total × 100"
  - "Req 4.1 — git commit after phase completes"
acceptance_criteria:
  - "[ -f skills/ideation/commands/plan.md ] — file exists"
  - "grep -q 'model:' skills/ideation/commands/plan.md — frontmatter has model field"
  - "grep -q 'allowed-tools:' skills/ideation/commands/plan.md — frontmatter has allowed-tools"
  - "grep -qi '02-plan' skills/ideation/commands/plan.md — references 02-plan-{subject}.md output file"
  - "grep -qi '95' skills/ideation/commands/plan.md — 95% audit threshold documented"
  - "grep -qi 'auto.fix\\|auto fix' skills/ideation/commands/plan.md — auto-fix requirement present"
  - "grep -qi 'audit block\\|append.*audit\\|audit.*append' skills/ideation/commands/plan.md — audit block appended to plan file"
  - "grep -qi 'partial' skills/ideation/commands/plan.md — partial credit formula present"
  - "grep -qi 'git' skills/ideation/commands/plan.md — git commit step present"
consecutive_failures: 0
---

## Context

Writes `skills/ideation/commands/plan.md` — Steps 4–5 of the ideation flow. Step 4 drafts `02-plan-{subject}.md` based on the captured input and interview answers. Step 5 runs the critic audit gate: 95% threshold, auto-fix all gaps (never ask permission), append structured audit block to the plan file.

Audit formula: `(full + 0.5×partial) / total × 100`. All gaps must be auto-fixed before the phase ends.

Command model: `claude-opus-4-6` (heavy reasoning for plan drafting and critic gate).

## Acceptance Criteria

- `skills/ideation/commands/plan.md` exists with valid frontmatter
- References `02-plan-{subject}.md` as the output file
- 95% audit threshold documented
- Auto-fix rule present (never ask permission to fix)
- Audit block append step documented (structured block appended to plan file)
- Partial credit formula (`0.5×partial`) present
- Git commit step present at end of phase

---
<!-- Everything below this line is append-only and chronological -->

## Work Log — 2026-03-22T00:00:00Z

**Agent**: kanban-work
**Status**: in_review

### Summary

Implemented `skills/ideation/commands/plan.md` — Steps 4–5 of the ideation flow.

### Work Done

- Created `/Users/adjmunro/Developer/agentfiles/skills/ideation/commands/plan.md`
- Frontmatter: `model: claude-opus-4-6`, `allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion`
- Personas: Keeper (Strategist) for drafting, Arden (Critic) for audit gate
- Phase 1: Load Context — reads all session blocks from `00-input-{subject}.md`, stops if missing
- Phase 2: Draft Plan — writes `02-plan-{subject}.md` with Intent, Requirements, Constraints, Out of Scope sections
- Phase 3: Critic Audit Gate — 95% threshold, full/partial/missing classification, auto-fix mandatory, appends structured audit block
- Phase 4: Git commit with `kanban(plan): draft plan for {subject}`
- Phase 5: Report to user

### AC Results

All 9 acceptance criteria passed:
- file exists: PASS
- model field: PASS
- allowed-tools: PASS
- 02-plan reference: PASS
- 95% threshold: PASS
- auto-fix: PASS
- audit block append: PASS
- partial formula: PASS
- git commit: PASS
