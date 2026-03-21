---
id: kanban
argument-hint: "init | work | review | pr | cleanup | next"
---

# Kanban2 Skill

> Work loop for the subject-centric directory structure. Picks up tickets from `YYYY-MM-DD-{subject}/04-todo/` and routes them through implementation, review, PR, and archive.

## User-Facing Command

**`/kanban`** — Orchestrate work from ticket claim through archive. Routes to subcommands based on the argument passed:

- `init` — Set up a new subject directory with stage folders
- `work` — Claim a ticket and implement it
- `review` — Run local review and score pass/fail
- `pr` — Prepare the ticket for PR (or skip if non-GitHub/unprotected trunk)
- `cleanup` — Archive completed tickets and report metrics
- `next` — Identify and claim the next pickable ticket

## Directory Structure

Kanban2 works with the new subject-centric layout:

```
.kanban/
├── YYYY-MM-DD-{subject}/
│   ├── 00-input-{subject}.md          (ideation phase only)
│   ├── 01-research-{subject}.md       (ideation phase only)
│   ├── 02-plan-{subject}.md           (ideation phase only)
│   ├── 00-assets/                     (ideation phase — never touched by kanban2)
│   ├── 03-refinement/                 (ideation phase only — never touched by kanban2)
│   ├── 04-todo/                       (kanban2 picks up from here)
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

**Key difference from kanban v1:** Tickets flow through numbered stages starting at `04-todo/` (not v1's `02-todo/`). This preserves the ideation phases (`00-input-`, `01-research-`, `02-plan-`, `00-assets/`, `03-refinement/`) as read-only from kanban2's perspective.

## State Machine

```
                    ┌─────────────────┐
                    │  04-todo/       │
                    │  (pickable)     │
                    └────────┬────────┘
                             │
                        /kanban work
                             │
                    ┌────────▼────────┐
                    │ 05-in-progress/ │
                    │  (claimed)      │
                    └────────┬────────┘
                             │
                        /kanban review
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
           /kanban pr
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
| Setup | `init` | Create subject directory and stage folders | Subject name + directory path | New `YYYY-MM-DD-{subject}/` tree |
| Work | `work` | Claim ticket, implement, log changes | Ticket in `04-todo/` | Ticket moved to `05-in-progress/` with work log |
| Review | `review` | Run acceptance criteria checks, score pass/fail | Ticket in `05-in-progress/` | Ticket moved to `06-in-review/` (PASS) or stays in `05-in-progress/` (FAIL) |
| PR | `pr` | Prepare ticket for PR or skip if safe | Ticket in `06-in-review/` | Ticket moved to `07-pull-request/` or `08-done/` |
| Cleanup | `cleanup` | Archive completed tickets and report metrics | Ticket in `08-done/` | Ticket moved to `.kanban/.archive/YYYY-MM-DD-{subject}/08-done/` |
| Orchestrate | `next` | Identify next pickable ticket and claim it | Tickets in `04-todo/` | Ticket moved to `05-in-progress/` |

## Distinction from Kanban v1

Kanban2 is a fresh implementation adapted for the new directory structure. Key differences:

- **Directory structure**: Tickets start at `04-todo/` (v1: `02-todo/`)
- **Plan-layer isolation**: Kanban2 never reads, writes, or touches:
  - `00-input-`, `01-research-`, `02-plan-` files
  - `00-assets/` directory
  - `03-refinement/` directory
  - These belong to ideation; kanban2 begins work only after tickets are promoted to `04-todo/`
- **Archive path**: Finished work moves to `.kanban/.archive/YYYY-MM-DD-{subject}/`
- **Shared personas**: Commands reference `../../kanban/personas/` (shared from v1, never duplicated)
- **Same discipline**: Verbatim transcription, critic audit gates, per-unit commits, TDD red-phase discipline — all carry forward

## Personas

All personas are shared from `skills/kanban/personas/`:

- **Vela (Scribe)** — transcribes and documents
- **Arden (Critic)** — audits completeness and correctness
- **Finn (Scout)** — researches codebase
- **Kira (Builder)** — implements changes
- **Echo (Examiner)** — verifies acceptance criteria
- **Vale (Advocate)** — advocates for the work in PR
- **Keeper (Strategist)** — challenges scope assumptions
- **Artisan (Designer)** — owns visual and UX quality
- **Helm (Release)** — ensures shipping safety
- **Ward (Documentation)** — maintains documentation health
- **Pulse (Analytics)** — generates metrics

Commands identify their active persona(s) in transcripts.

## Carry-Forward from Kanban v1

All established patterns from kanban v1 remain:

- **Conventional commits** with scoped versioning
- **Critic audit gate**: 95% threshold, auto-fix all gaps, append structured audit block
- **AskUserQuestion**: max 4 options, `(Recommended)` label on default
- **Ticket frontmatter schema**: id, subject, plan, effort, status, created_at, claimed_at, completed_at, stale_after_hours, depends_on, spawned_tickets, plan_items, acceptance_criteria, consecutive_failures
- **TASK-001 = TDD red phase**: No exceptions, never merged into another ticket
- **Acceptance criteria**: Empirically verifiable (runnable command with expected output, or unambiguous observable state)
- **Git commits**: One per phase, with conventional commit messages
- **Stale ticket detection** via `stale_after_hours`
- **Consecutive failure escalation**: Desktop notification + escalation block when identical gap recurs 2–3 times
- **Argument-based boundary passthrough**: Use `from-ideation-handoff` to whitelist sanctioned session crossings
- **Research snapshot format**: Date, "may go stale" disclaimer, sections: Project Structure / Relevant Patterns / Dependencies / Hazards / Recommended Ticket Sequence
- **PR bypass conditions**: Non-GitHub repo skips PR; unprotected trunk skips PR; check failure defers to user
- **Phase numbering discipline**: When inserting new phases, renumber downstream and update all references

## Session Design

**Kanban2 is work-only.** It does not orchestrate capture or planning — those belong to the ideation skill (`/ideate`). Kanban2 begins when a ticket is pickable in `04-todo/`.

**Session boundaries are hard:**
- A work session is independent: claim, implement, log, complete
- A review session is independent: run checks, score, route
- An orchestration session identifies and claims the next ticket
- No cross-session state (except ticket files themselves)

**Escalation and stale detection:**
- `stale_after_hours` field in ticket frontmatter triggers escalation prompts
- Consecutive failures on the same ticket fire desktop notifications and escalation blocks
- Consecutive same-error encounters (2–3 times) also escalate

## Parallelization Safety

Each git worktree has its own working directory, which means `.kanban/` at the repo root is a separate, independent directory tree per worktree — one worktree cannot see another's in-progress tickets or claim locks. This makes parallel sessions across different worktrees naturally isolated at the filesystem level; no coordination mechanism is needed between them, and such cross-worktree parallelism is safe and encouraged. The claim lock mechanism (`.kanban/{subject}/.claims/{ticket-id}.lock`) exists only to guard against races within a single worktree, where two sessions could otherwise both read a ticket as unclaimed and attempt to claim it simultaneously. This is the intended design: cross-worktree parallelism needs no locks; intra-worktree parallelism requires them.
