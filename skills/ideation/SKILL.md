# Ideation Skill

> **User-facing command**: `/ideate`
> **Skill location**: `skills/ideation/`
> **Persona references**: `../../personas/`

The ideation skill collapses five traditionally separate phases into one seamless loop: capture, research, interview, plan, and ticket creation. A user brings a raw idea, the skill conducts intelligent research first, asks targeted questions informed by what already exists, builds a plan collaboratively, and exits with a ready-to-work backlog in the implement work queue.

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
│   ├── 04-todo/                            ← ready for implement (step 9 promotion)
│   │   └── (tickets moved here after promotion)
│   ├── 05-in-progress/                     ← implement work phase
│   ├── 06-in-review/                       ← implement review phase
│   ├── 07-pull-request/                    ← implement PR phase
│   └── 08-done/                            ← implement archive (completion signal)
│
└── YYYY-MM-DD-another-idea/
    └── (same structure)
```

---

## State Machine

The ideation skill operates as a deterministic state machine with six stable states (waiting for user action) and transient phases (internal work).

### Entry Routing

When `/ideate` is invoked with an existing subject, the orchestrator checks artifact presence in reverse order (most advanced state first) and routes accordingly:

| Condition | Routes to |
|-----------|-----------|
| Tickets exist in `03-refinement/` with substantive content | Step 9 (hard stop gate) |
| `02-plan-{subject}.md` exists with substantive content | Step 6 (validate with user) |
| `00-input-{subject}.md` contains an `## Interview` block | Step 4 (write plan) |
| `01-research-{subject}.md` exists with substantive content | Step 3 (interview) |
| `00-input-{subject}.md` exists with substantive content | Step 1 (capture — loop-back append) |
| No artefacts exist | Step 1 (capture — fresh run) |

Substantive content: file exists, size > 0 bytes, and contains at least one non-heading line.

### Flow Diagram

```
      ┌──────────────────────────────────────────────┐
      │  START: /ideate invoked                       │
      └───────────────┬──────────────────────────────┘
                      │
                      ▼
        ┌─────────────────────────────────┐
        │  Entry Routing (see table above)│
        │  Check artifact presence and    │
        │  route to correct step          │
        └──────┬──────────────────────────┘
               │ Fresh run or loop-back
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
            ┌─────────────────────────────┐
            │  Step 5: Audit Plan         │
            │  95% threshold, auto-fix    │
            └──┬──────────────────────────┘
               │ PASS                  FAIL (< 95% after auto-fix)
               │                          │
               │                          ▼
               │             ┌──────────────────────────────┐
               │             │  User choice:                │
               │             │  (a) Accept with [UNRESOLVED]│
               │             │  (b) Loop back to capture    │
               │             └──────────────────────────────┘
               │
               ▼
        ┌─────────────────────────────────────┐
        │  Step 6: Validate with User         │
        │  Satisfied? Add more? Abandon?      │
        └─┬──────────────────┬──────────────┬─┘
          │ Add more         │ Satisfied    │ Abandon
          │                  │              │
          └──► [Loop to      │              ▼
               Step 1] †     │   Slug confirm → Delete → END
                             │
                             ▼
                    ┌────────────────────────┐
                    │  Step 7: Write Tickets │
                    │  03-refinement/ drafts │
                    └────────┬───────────────┘
                             │
                             ▼
                    ┌────────────────────────┐
                    │  Step 8: Audit Tickets │
                    │  95% threshold,        │
                    │  auto-fix gaps         │
                    └────────┬───────────────┘
                             │
                             ▼
                    ┌────────────────────────┐
                    │  Step 9: Hard Stop     │
                    │  Backlog or Abandon?   │
                    └──┬─────────────────┬───┘
                       │                 │
                Backlog │                 │ Abandon
                       │                 │
                       ▼                 ▼
               ┌─────────────┐   Slug confirm → Delete → END
               │ Promote to  │
               │ 04-todo/    │
               │ (implement) │
               └──────┬──────┘
                      │
                      ▼
                    END
```

† Loop-back reruns ALL steps 1–5 in sequence (capture → research → interview → plan → audit) before returning to Step 6. Each loop-back appends a new session block to `00-input-{subject}.md`; prior content is immutable.

---

## Integration with implement

Once ideation finishes a subject and promotes tickets to `04-todo/`, the subject becomes available to implement. The implement skill never touches:
- `00-input-{subject}.md`
- `01-research-{subject}.md`
- `02-plan-{subject}.md`
- `00-assets/`
- `03-refinement/`

The implement skill owns `04-todo/` through `08-done/`, implementing and reviewing tickets without re-planning. If a ticket requires planning changes, it spawns a new ideation session, not an implement loop-back.

---

## Boundary Passthrough

When ideation hands off to implement (or vice versa), arguments are used to whitelist sanctioned crossings. For example, `from-ideation-handoff` confirms that a boundary crossing is intentional and expected.

---

## Session Design

Ideation sessions are **planning sessions**, separate from work sessions (implement). Within a single ideation session, users stay in flow through all 9 steps. Between steps, the skill commits progress and preserves state in the directory structure and ticket files.

---

## Version and Status

**Current version**: 1.6.0 (See `VERSION.md`)
**Independent lifecycle**: Ideation versioning is separate from the implement skill.

For version history, see `CHANGELOG.md`.
