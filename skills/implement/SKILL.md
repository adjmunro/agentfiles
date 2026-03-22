---
id: implement
argument-hint: "work | review | pr | cleanup | next"
---

# Implement Skill

> Work loop for the subject-centric directory structure. Picks up tickets from `YYYY-MM-DD-{subject}/04-todo/` and routes them through implementation, review, PR, and archive.

## User-Facing Command

**`/implement`** — Orchestrate work from ticket claim through archive. Routes to subcommands based on the argument passed:

- `work` — Claim a ticket and implement it
- `review` — Run local review and score pass/fail
- `pr` — Prepare the ticket for PR (or skip if non-GitHub/unprotected trunk)
- `cleanup` — Archive completed tickets and report metrics
- `next` — Identify and claim the next pickable ticket

## Directory Structure

The implement skill works with the subject-centric layout:

```
.kanban/
├── YYYY-MM-DD-{subject}/
│   ├── 00-input-{subject}.md          (ideation phase only)
│   ├── 01-research-{subject}.md       (ideation phase only)
│   ├── 02-plan-{subject}.md           (ideation phase only)
│   ├── 00-assets/                     (ideation phase — never touched by implement)
│   ├── 03-refinement/                 (ideation phase only — never touched by implement)
│   ├── 04-todo/                       (implement picks up from here)
│   │   └── TASK-NNN-{subject}.md
│   ├── 05-in-progress/
│   │   └── TASK-NNN-{subject}.md
│   ├── 06-in-review/
│   │   └── TASK-NNN-{subject}.md
│   ├── 07-pull-request/
│   │   └── TASK-NNN-{subject}.md
│   └── 08-done/
│       └── TASK-NNN-{subject}.md
└── .archive/
    └── YYYY-MM-DD-{subject}/
        └── 08-done/
            └── TASK-NNN-{subject}.md
```

**Key point:** Tickets flow through numbered stages starting at `04-todo/`. This preserves the ideation phases (`00-input-`, `01-research-`, `02-plan-`, `00-assets/`, `03-refinement/`) as read-only from implement's perspective.

## State Machine

```
                    ┌─────────────────┐
                    │  04-todo/       │
                    │  (pickable)     │
                    └────────┬────────┘
                             │
                        /implement work
                             │
                    ┌────────▼────────┐
                    │ 05-in-progress/ │
                    │  (claimed)      │
                    └────────┬────────┘
                             │
                        /implement review
                             │
                ┌────────────┴────────────┐
                │                         │
           PASS │                         │ FAIL
                │                         │
         ┌──────▼─────┐          ┌────────▼────────┐
         │ 06-in-review│          │ 05-in-progress/ │
         │ (ready→pr)  │          │ (retry)         │
         └──────┬─────┘          └─────────────────┘
                │
           /implement pr
                │
         ┌──────▼────────┐
         │ 07-pull-      │
         │    request/   │
         │ (awaiting     │
         │  merge)       │
         └──────┬────────┘
                │
           (merged or
          force-skipped
            via cleanup)
                │
         ┌──────▼────────┐
         │ 08-done/      │
         │ (complete)    │
         └───────────────┘
```

## Command Table

| Stage | Command | Purpose | Input | Output |
|-------|---------|---------|-------|--------|
| Work | `work` | Claim ticket, implement, log changes | Ticket in `04-todo/` | Ticket moved to `05-in-progress/` with work log |
| Review | `review` | Run acceptance criteria checks, score pass/fail | Ticket in `05-in-progress/` | Ticket moved to `06-in-review/` (PASS) or stays in `05-in-progress/` (FAIL) |
| PR | `pr` | Prepare ticket for PR or skip if safe | Ticket in `06-in-review/` | Ticket moved to `07-pull-request/` or `08-done/` |
| Cleanup | `cleanup` | Archive completed tickets and report metrics | Ticket in `08-done/` | Ticket moved to `.kanban/.archive/{subject}/08-done/` |
| Orchestrate | `next` | Identify next pickable ticket and claim it | Tickets in `04-todo/` | Ticket moved to `05-in-progress/` |

## Personas

See `skills/personas/SKILL.md` for the full roster. All personas are shared from `skills/personas/`. Each command file lists its active persona(s) and the phases they govern.

## Command Details

See the individual command files for full phase logic, DO/DO NOT rules, and escalation paths:

- `commands/work.md` — ticket claim and implementation
- `commands/review.md` — evidence gathering, scoring, and verdict
- `commands/pr.md` — PR preparation and bypass conditions
- `commands/cleanup.md` — archive and metrics
- `commands/next.md` — orchestration and work→review loop

To initialise a new subject directory, use the shared `/init` command (`commands/init.md` at the repo root).
