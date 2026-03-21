# Ideation Skill

> **User-facing command**: `/ideate`
> **Skill location**: `skills/ideation/`
> **Persona references**: `../../kanban/personas/`

The ideation skill collapses five traditionally separate phases into one seamless loop: capture, research, interview, plan, and ticket creation. A user brings a raw idea, the skill conducts intelligent research first, asks targeted questions informed by what already exists, builds a plan collaboratively, and exits with a ready-to-work backlog in the kanban2 work queue.

---

## The `/ideate` Command

Invoke with `/ideate` to start a new ideation session. The command orchestrates a 9-step workflow, tracking state across multiple session boundaries. Users stay in flow without needing to remember which phase comes next.

---

## Nine-Step Ideation Flow

### Step 1 — Capture

Transcribe user input **verbatim** — zero paraphrasing, zero summarizing, zero interpretation. Write captured text into `00-input-{subject}.md`. Any shared files, screenshots, or reference materials go into `00-assets/`. Never ask structure-forcing questions first; let the user write freely.

**Files created**:
- `00-input-{subject}.md` — verbatim input
- `00-assets/` — (if assets provided)

**Next**: Advance to Step 2 (research).

---

### Step 2 — Research

Before interviewing the user about anything, conduct an intelligent research snapshot. Scan the local codebase, fetch relevant documentation, look up existing designs or tickets, and map what already exists. Write findings into `01-research-{subject}.md`.

**Research snapshot format** (required):
- Date captured: `[YYYY-MM-DD]`
- "May go stale" disclaimer
- Sections:
  - Project Structure
  - Relevant Patterns
  - Dependencies
  - Hazards
  - Recommended Ticket Sequence

**Files created**:
- `01-research-{subject}.md` — snapshot of what exists

**Next**: Advance to Step 3 (interview).

---

### Step 3 — Interview

Ask research-informed questions. Every question must reference something from the captured input or the research findings. Provide recommendations and explain tradeoffs between options — never ask empty open questions. If the user's captured input already covers a topic thoroughly, skip that question.

**Rules**:
- Max 4 options per question
- Label the recommended option with `(Recommended)`
- Reference captured input or research findings in the preamble to each question
- Explain why each option matters and what the tradeoffs are

**Files read**:
- `00-input-{subject}.md`
- `01-research-{subject}.md`

**Next**: Advance to Step 4 (write plan).

---

### Step 4 — Write Plan

Draft a structured plan based on:
1. The captured input
2. The interview answers
3. The research snapshot

The plan should address Goals, Scope, Implementation Strategy, Constraints, Acceptance Signals, and any remaining Unknowns. Write to `02-plan-{subject}.md`.

**Files read**:
- `00-input-{subject}.md`
- `01-research-{subject}.md`
- (User's interview answers)

**Files created/updated**:
- `02-plan-{subject}.md` — the drafted plan

**Next**: Advance to Step 5 (audit plan).

---

### Step 5 — Audit Plan

Run a critic audit gate. Verify that the plan addresses all captured input and interview findings. Threshold: 95%. If gaps are found, auto-fix them by adding missing sections — **never ask permission**. Append a structured audit block to `02-plan-{subject}.md` recording what was checked, any gaps found, and fixes applied.

**Audit block format** (append to plan file):

```
---
## Audit Log

**Date**: [YYYY-MM-DDTHH:MM:SSZ]
**Threshold**: 95%

| Item | Status | Notes |
|------|--------|-------|
| [requirement] | [Full/Partial/Missing] | [details] |

- Full: N, Partial: N, Missing: N
- Score: (Full + 0.5×Partial) / Total × 100 = **X%** ✓ PASS / ✗ FAIL

### Fixes Applied

[Describe any auto-fixes made]
```

**Next**: Advance to Step 6 (validate with user).

---

### Step 6 — Validate with User

Ask: "Are you satisfied with this plan, or would you like to add more?"

**Option A** (Recommended): **Satisfied** → Continue to Step 7.

**Option B**: **Add more** → Loop back to Step 1. Append new input to `00-input-{subject}.md` (never overwrite). Re-run research, interview, plan, and audit for the new input. Return to this validation step and ask again.

**Option C**: **Abandon** → Confirm by typing the exact subject slug (e.g. `2026-03-22-my-feature`). On confirmation, delete all subject files and the directory.

**Rules**:
- All appends to `00-input-{subject}.md` are new session blocks — prior content is immutable
- `02-plan-{subject}.md` is updated in place and re-audited each loop
- Only exit the loop via option A (satisfied) or option C (abandon)

**Next**:
- Satisfied → Step 7
- Add more → Step 1
- Abandon → End (delete directory)

---

### Step 7 — Write Tickets

Break the plan into concrete, actionable tickets. Scope each ticket so a low-effort model can implement it, but each is a complete unit of work. Write all tickets into `03-refinement/`.

**Ticket frontmatter** (required schema):

```yaml
---
id: "{subject}/TASK-NNN"
subject: "{subject}"
plan: "../../02-plan-{subject}.md"
effort: low|medium|high
status: draft
created_at: "[ISO timestamp]"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on: []
spawned_tickets: []
plan_items: []
acceptance_criteria:
  - "criterion 1"
  - "criterion 2"
consecutive_failures: 0
---
```

**Rules**:
- Tickets stay in `03-refinement/` — they are not yet available to kanban2
- Acceptance criteria must be empirically verifiable (runnable commands or observable state)
- Write tickets one per file: `TASK-001-{subject}.md`, `TASK-002-{subject}.md`, etc.

**Files created**:
- `03-refinement/TASK-001-{subject}.md` (and more)

**Next**: Advance to Step 8 (audit tickets).

---

### Step 8 — Audit Tickets

Run a critic audit gate on the ticket set. Verify every requirement in the plan maps to at least one ticket acceptance criterion. Threshold: 95%. Auto-fix gaps by creating additional tickets or strengthening existing ACs — **never ask permission**.

**Audit process**:
1. Map each plan requirement to ticket(s)
2. Verify each ticket AC is empirically testable
3. Check for orphaned requirements
4. Check for over-scoped tickets

**Audit block** (append to each ticket):

```
---
## Audit Log

**Date**: [YYYY-MM-DDTHH:MM:SSZ]

| Requirement | Status | Ticket | Notes |
|-------------|--------|--------|-------|
| [plan item] | [mapped/orphaned] | TASK-NNN | [notes] |

Coverage: X%

### Fixes Applied

[Describe any new tickets created or ACs strengthened]
```

**Next**: Advance to Step 9 (hard stop gate).

---

### Step 9 — Hard Stop Gate

Two options only. Ask: "Ready to add these to your backlog or abandon this idea?"

**Option A** (Recommended): **Add to backlog** → Move all tickets from `03-refinement/` to `04-todo/`. Subject is now available to kanban2 for implementation work.

**Option B**: **Abandon** → Confirm by typing the exact subject slug. On confirmation, delete all files and the subject directory. No partial keeps.

**Rules**:
- No partial decisions — all-or-nothing
- Abandon requires exact slug confirmation (e.g. `2026-03-22-my-feature`), not just "yes"
- Once promoted to `04-todo/`, kanban2 takes over; ideation does not touch those tickets again

**Next**:
- Add to backlog → End (promotion complete)
- Abandon → End (directory deleted)

---

## Directory Structure

Each subject lives in a directory named `YYYY-MM-DD-{subject}/` inside `.kanban/`. The full ISO date prefix (not the short form) ensures temporal clarity and prevents collisions.

```
.kanban/
├── YYYY-MM-DD-my-feature/                  ← subject dir (ISO date + slug)
│   ├── 00-input-my-feature.md              ← verbatim capture (step 1)
│   ├── 00-assets/                          ← screenshots, files (step 1)
│   ├── 01-research-my-feature.md           ← research snapshot (step 2)
│   ├── 02-plan-my-feature.md               ← plan + audit log (steps 4–5)
│   │
│   ├── 03-refinement/                      ← ideation-stage tickets (steps 7–8)
│   │   ├── TASK-001-my-feature.md
│   │   ├── TASK-002-my-feature.md
│   │   └── ...
│   │
│   ├── 04-todo/                            ← ready for kanban2 (step 9 promotion)
│   │   └── (tickets moved here after promotion)
│   ├── 05-in-progress/                     ← kanban2 work phase
│   ├── 06-in-review/                       ← kanban2 review phase
│   ├── 07-pull-request/                    ← kanban2 PR phase
│   └── 08-done/                            ← kanban2 archive (completion signal)
│
└── YYYY-MM-DD-another-idea/
    └── (same structure)
```

---

## State Machine

The ideation skill operates as a deterministic state machine with six stable states (waiting for user action) and transient phases (internal work).

```
      ┌─────────────────────────────────────────────┐
      │  START: /ideate invoked                      │
      └───────────────┬─────────────────────────────┘
                      │
                      ▼
            ┌─────────────────────┐
            │  Step 1: Capture    │
            │  Write input, assets│
            └─────────┬───────────┘
                      │
                      ▼
            ┌─────────────────────┐
            │  Step 2: Research   │
            │  Scan & document    │
            └─────────┬───────────┘
                      │
                      ▼
            ┌─────────────────────┐
            │  Step 3: Interview  │
            │  Ask informed Qs    │
            └─────────┬───────────┘
                      │
                      ▼
            ┌─────────────────────┐
            │  Step 4: Write Plan │
            │  Draft structure    │
            └─────────┬───────────┘
                      │
                      ▼
            ┌─────────────────────┐
            │  Step 5: Audit Plan │
            │  95% threshold,     │
            │  auto-fix gaps      │
            └─────────┬───────────┘
                      │
                      ▼
        ┌─────────────────────────────────────┐
        │  Step 6: Validate with User         │
        │  Satisfied? Add more? Abandon?      │
        └─┬───────────────────────────────┬───┘
          │ Add more                      │ Satisfied
          │                               │
          └──► [Loop back to Step 1]      │
                                          │
                                          ▼
                        ┌─────────────────────────┐
                        │  Step 7: Write Tickets  │
                        │  03-refinement/ drafts  │
                        └────────┬────────────────┘
                                 │
                                 ▼
                        ┌─────────────────────────┐
                        │  Step 8: Audit Tickets  │
                        │  95% threshold,         │
                        │  auto-fix gaps          │
                        └────────┬────────────────┘
                                 │
                                 ▼
                        ┌─────────────────────────┐
                        │  Step 9: Hard Stop      │
                        │  Backlog or Abandon?    │
                        └─┬──────────────────┬────┘
                          │                  │
                   Backlog │                  │ Abandon
                          │                  │
                          ▼                  ▼
                    ┌──────────────┐    ┌─────────────┐
                    │ Promote to   │    │ Delete all  │
                    │ 04-todo/     │    │ subject     │
                    │ (kanban2 ready)│    │ files       │
                    └──────────────┘    └─────────────┘
                          │                  │
                          ▼                  ▼
                      ┌─────────────────────────┐
                      │  END                    │
                      │  (ready for kanban2 or  │
                      │   idea abandoned)       │
                      └─────────────────────────┘
```

---

## Key Behaviors

### Verbatim Transcription

Capture records exactly what the user says — zero paraphrasing, zero summarizing, zero interpretation. If the user is vague, record that vagueness. If they're repetitive, record that repetition. The research and interview phases build on this raw material without contaminating it.

### Critic Audit Gates

Plan audit (Step 5) and ticket audit (Step 8) both use a 95% threshold. Gaps are auto-fixed **without asking permission**:
- Missing sections are added to the plan
- Orphaned requirements spawn new tickets
- Weak ACs are strengthened

The audit block is appended to the file (never overwrites), creating an immutable audit trail.

### Loop-Back Append-Only Rule

When a user chooses to "add more" at Step 6, new input is appended to `00-input-{subject}.md` in a new session block. Prior input stays intact. Research, interview, and plan are re-run for the new input, then the plan is updated in place and re-audited.

### Personas Shared, Not Duplicated

The ideation skill references persona files from `../../kanban/personas/` rather than duplicating them. This keeps personality, rules, and voice in one place.

### Tickets Until Step 9

During ideation, all tickets live in `03-refinement/`. No tickets move to `04-todo/` (kanban2's work queue) until Step 9 explicitly promotes them. This keeps the ideation loop safe — user can abandon without affecting kanban2.

### Abandon Requires Slug Confirmation

Abandonment is not a casual choice. Users must type the exact subject slug (e.g. `2026-03-22-my-feature`) to confirm. Simple "yes/no" is insufficient.

---

## Integration with kanban2

Once ideation finishes a subject and promotes tickets to `04-todo/`, the subject becomes available to kanban2. Kanban2 never touches:
- `00-input-{subject}.md`
- `01-research-{subject}.md`
- `02-plan-{subject}.md`
- `00-assets/`
- `03-refinement/`

Kanban2 owns `04-todo/` through `08-done/`, implementing and reviewing tickets without re-planning. If a ticket requires planning changes, it spawns a new ideation session, not a kanban2 loop-back.

---

## Boundary Passthrough

When ideation hands off to kanban2 (or vice versa), arguments are used to whitelist sanctioned crossings. For example, `from-ideation-handoff` confirms that a boundary crossing is intentional and expected.

---

## Session Design

Ideation sessions are **planning sessions**, separate from work sessions (kanban2). Within a single ideation session, users stay in flow through all 9 steps. Between steps, the skill commits progress and preserves state in the directory structure and ticket files.

---

## Version and Status

**Current version**: 1.0.0 (See `VERSION.md`)
**Independent lifecycle**: Ideation versioning is separate from kanban v1 and kanban2.

For version history, see `CHANGELOG.md`.
