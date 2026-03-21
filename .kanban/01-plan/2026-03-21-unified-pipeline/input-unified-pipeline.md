# 2026-03-21-unified-pipeline

## What

two new skills: ideation and kanban2 (renamed to kanban after full migration from kanban v1).

the ideation skill absorbs what is currently spread across /kanban-capture, /kanban-plan, and /kanban-todo into a single seamless flow. from the user's perspective, it should be one contiguous thing — no manually invoking plan then todo. it's a loop.

the ideation flow, in order:

1. capture user input verbatim, including any assets (screenshots, links, docs)
2. research — webfetch, local file scan, relevant documentation lookup — before asking the user anything
3. interview — non-obvious questions informed by the research and the captured input. should give advice on recommended choices and explain tradeoffs/pros and cons between options. inspired by /interview command
4. write the plan
5. audit the plan against the verbatim user input (critic gate, 95% threshold)
6. validate with the user: satisfied, or want to add more? if adding more → back to step 1, append only, never overwrite. loop through all steps again for the new input. if satisfied → continue
7. write the todo tickets. scope should be limited so that even low-effort models can implement changes, but each ticket is still a complete unit of work. acceptance criteria are the testing plan for that ticket — empirically verifiable
8. audit the tickets against the plan (critic gate)
9. hard stop gate: ask user — abandon the plan (delete everything) or add to backlog (move tickets to todo/). those are the only two options.

if abandon: delete everything for this subject.
if backlog: move tickets from their draft location into the subject's todo/ folder, making them pickable by kanban2.

the orchestration is internal to the ideation skill — a thin loop that advances through steps and loops back when the user wants to add more. same pattern as next.md in kanban v1.

kanban2 is the work loop — equivalent to todo through cleanup in kanban v1 but adapted for the new directory structure. thin orchestration via a next-equivalent command. the ideation skill does not touch anything beyond depositing tickets into todo/.

[Agent clarified: orchestration lives inside each skill respectively, no separate third orchestrator needed. based on next.md pattern from kanban v1]

## Why

the current kanban workflow requires the user to manually invoke /kanban-capture, /kanban-plan, and /kanban-todo in sequence. this is friction. the user shouldn't need to know or care about the internal stages — they should just start the process and be guided through it.

additionally, research currently happens in the todo phase (scout), which is too late — questions should be informed by research, not asked blind and then researched after. moving research before the interview produces better questions and better plans.

two separate skills (ideation + kanban2) because the planning and implementation loops have different session concerns, different cadences, and different user interactions. keeping them separate also avoids the problem of a skill editing itself mid-run.

build both new alongside kanban v1, which stays untouched. once migration is complete, rename kanban2 → kanban and retire v1.

## Constraints

### directory structure (new — breaking change from kanban v1)

subject is the top-level concern inside .kanban/:

```
.kanban/
├── {subject}/
│   ├── input-{subject}.md          ← verbatim capture
│   ├── research-{subject}.md       ← scout findings
│   ├── plan-{subject}.md           ← plan + audit trail
│   ├── assets/                     ← screenshots, docs, links
│   ├── todo/
│   ├── in-progress/
│   ├── in-review/
│   └── pull-request/
└── .archive/
    └── YYYY-MM-DD-{subject}/       ← whole subject folder moved here on completion
```

stage folders live inside subject, not the other way around. plan docs (input, research, assets) sit loose in the subject folder alongside the stage subfolders.

archive is `.kanban/.archive/YYYY-MM-DD-{subject}/` — hidden, date-prefixed, sibling to the live subject folders.

old kanban v1 structure (`.kanban/{stage}/{subject}/`) is NOT changed. both structures coexist until migration is complete.

### carry forward from kanban v1

everything learned and proven in kanban v1 applies unless explicitly changed here:

- verbatim transcription in capture — zero paraphrasing, zero summarising
- critic audit gate: 95% threshold, auto-fix all gaps, never ask permission to fix
- AskUserQuestion: max 4 options, (Recommended) label on default, option ordering signals enter-to-confirm
- ticket frontmatter schema (id, subject, plan, effort, status, created_at, claimed_at, completed_at, stale_after_hours, depends_on, spawned_tickets, plan_items, acceptance_criteria, consecutive_failures)
- TASK-001 is always the TDD red phase — no exceptions
- acceptance criteria must be empirically verifiable (runnable command or unambiguous observable state)
- git commits after each phase with conventional commit messages
- stale ticket detection (stale_after_hours)
- consecutive failures escalation before looping again
- from-plan-handoff style argument passing for sanctioned boundary crossings between skills
- persona identification when communicating (Vela, Arden, Finn, etc.)
- research snapshot format (date, status: may go stale, sections: project structure / relevant patterns / dependencies / hazards / recommended ticket sequence)
- PR bypass conditions (non-github repo, unprotected trunk)
- phase numbering and renumbering discipline when inserting new phases
- the 4-option AskUserQuestion limit discovered during command-handoff implementation

### ticket staging in ideation

tickets are drafted and audited inside the subject folder during ideation (not yet in todo/). only when the user confirms "add to backlog" at step 9 do the tickets move into the subject's todo/ subfolder. this is the atomic promotion gate — tickets in todo/ are ready to be picked up by kanban2; tickets not yet there are still in draft.

### scope limits

- ideation does not touch todo/, in-progress/, in-review/, or pull-request/ until the final step 9 promotion
- kanban2 does not touch input, research, plan, or assets files
- retire kanban v1 only after kanban2 is fully verified

## Assets

- existing kanban v1 skill: `skills/kanban/` — primary reference for patterns, personas, schemas, and command structure
- personas already written: scribe (Vela), critic (Arden), scout (Finn), strategist (Keeper), designer, release, docs, analytics, advocate, examiner
- next.md — the thin orchestrator pattern to replicate for both ideation and kanban2 work loops
- AskUserQuestion tool — supports (Recommended) label, max 4 options, option ordering
- command-handoff implementation (2026-03-21-command-handoff) — proven pattern for post-phase prompts and session boundary passthrough
