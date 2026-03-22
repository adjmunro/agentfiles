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

| Step | Name | Command file |
|------|------|--------------|
| 1 | Capture | See `commands/capture.md` for full phase instructions. |
| 2 | Research | See `commands/research.md` for full phase instructions. |
| 3 | Interview | See `commands/interview.md` for full phase instructions. |
| 4 | Write Plan | See `commands/plan.md` for full phase instructions. |
| 5 | Audit Plan | See `commands/plan.md` (audit gate section) for full phase instructions. |
| 6 | Validate with User | See `commands/plan.md` (validation section) for full phase instructions. |
| 7 | Write Tickets | See `commands/tickets.md` for full phase instructions. |
| 8 | Audit Tickets | See `commands/tickets.md` (audit gate section) for full phase instructions. |
| 9 | Hard Stop Gate | See `commands/tickets.md` (promotion section) for full phase instructions. |

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
