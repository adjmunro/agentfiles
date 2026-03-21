---
id: "260321-unified-pipeline/TASK-008"
subject: "260321-unified-pipeline"
plan: "../../01-plan/260321-unified-pipeline/plan-unified-pipeline.md"
effort: high
status: todo
created_at: "2026-03-22T00:00:00Z"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-007"
spawned_tickets: []
plan_items:
  - "Req 2.1 — /ideate is the user-facing command"
  - "Req 2.2 — ideate.md is the thin orchestrator; phase files are invoked by it"
  - "Req 2.3 — 9-step flow: capture→research→interview→plan→audit→validate→tickets→audit→promote/abandon"
  - "Req 2.4 — tickets stay in 03-refinement/ until step 9 only"
  - "Req 2.5 — abandon: type exact subject slug to confirm; delete all files"
  - "Req 2.6 — loop-back: append only, never overwrite; loops from step 6 back to step 1"
  - "Req 4.1 — from-ideation-handoff argument token for boundary passthrough"
  - "Req 4.1 — git commit after phase completes"
acceptance_criteria:
  - "[ -f skills/ideation/commands/ideate.md ] — file exists"
  - "grep -q 'model:' skills/ideation/commands/ideate.md — frontmatter has model field"
  - "grep -q 'allowed-tools:' skills/ideation/commands/ideate.md — frontmatter has allowed-tools"
  - "grep -q 'argument-hint:' skills/ideation/commands/ideate.md — frontmatter has argument-hint"
  - "grep -q '9\\|nine\\|step' skills/ideation/commands/ideate.md — 9-step flow referenced"
  - "grep -qi 'capture.md' skills/ideation/commands/ideate.md — invokes capture.md phase file"
  - "grep -qi 'research.md' skills/ideation/commands/ideate.md — invokes research.md phase file"
  - "grep -qi 'interview.md' skills/ideation/commands/ideate.md — invokes interview.md phase file"
  - "grep -qi 'plan.md' skills/ideation/commands/ideate.md — invokes plan.md phase file"
  - "grep -qi 'tickets.md' skills/ideation/commands/ideate.md — invokes tickets.md phase file"
  - "grep -qi '03-refinement' skills/ideation/commands/ideate.md — references 03-refinement/ for staging"
  - "grep -qi '04-todo' skills/ideation/commands/ideate.md — references 04-todo/ as promotion target"
  - "grep -qi 'abandon\\|slug' skills/ideation/commands/ideate.md — abandon guard with slug confirmation"
  - "grep -qi 'append\\|loop' skills/ideation/commands/ideate.md — loop-back append rule present"
  - "grep -qi 'from-ideation-handoff' skills/ideation/commands/ideate.md — boundary passthrough token present"
consecutive_failures: 0
---

## Context

Writes `skills/ideation/commands/ideate.md` — the thin orchestrator for the 9-step ideation flow. This is the user-facing `/ideate` command. It drives the loop, tracks state, and handles branching (loop-back at step 6 vs advance to step 7). Phase files (`capture.md`, `research.md`, `interview.md`, `plan.md`, `tickets.md`) are invoked by the orchestrator and are not user-facing.

Key behaviours:
- Step 6 validate loop: if user wants to add more → loop back to step 1, append only
- Step 9 hard stop: **Add to backlog** (move `03-refinement/` → `04-todo/`, Recommended) or **Abandon** (type exact subject slug to confirm; delete all subject files)
- `from-ideation-handoff` argument token for sanctioned boundary crossings

Command model: `claude-haiku-4-5-20251001` (low-tier orchestrator, mirrors next.md pattern).

## Acceptance Criteria

- `skills/ideation/commands/ideate.md` exists with valid frontmatter
- All 5 phase files referenced by name (`capture.md`, `research.md`, `interview.md`, `plan.md`, `tickets.md`)
- `03-refinement/` referenced as ticket staging location during ideation
- `04-todo/` referenced as the step 9 promotion target
- Abandon guard: subject slug confirmation documented (not just yes/no)
- Loop-back rule: append-only, loops from step 6 back to step 1
- `from-ideation-handoff` boundary passthrough token present

---
<!-- Everything below this line is append-only and chronological -->
