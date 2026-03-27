---
model: claude-sonnet-4-6
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion
argument-hint: "[YYYY-MM-DD-{subject}/TASK-NNN] — ticket to review"
---

<!-- This file is a phase dispatcher. It contains ONLY boot logic and phase dispatch.
     All phase instructions live in review/ subdirectory files.
     Each phase file contains only that phase's instructions — no future-phase content
     is loaded until needed. Read only the current phase file. Do not pre-read future phases. -->

# Review — Orchestrator

## Personas

- `../../personas/examiner/persona.md` — **Echo (Examiner)** — active in Phases 2–2c
- `../../personas/vigil/persona.md` — **Vigil (Regression Sentinel)** — active in Phase 2b alongside Echo
- `../../personas/folio/persona.md` — **Folio (API Documenter)** — active in Phase 2c
- `../../personas/critic/persona.md` — **Arden (Critic)** — active in Phase 3

Read each file before proceeding. Identify by the active persona when communicating with the user.

## DO

- Read the ticket and all referenced source files before forming any judgment
- Score using the formula: `(satisfied + 0.5×partial) / total × 100`
- Route the ticket: PASS → `07-pull-request/`, FAIL → `05-in-progress/`
- Commit the result with the correct message for each path

## DO NOT

- Merge the Examiner and Critic roles into one pass — maintain the separation

---

```
[06-in-review/] ──► Phase 2: Examiner maps evidence
                  ──► Phase 2b: run test suites
                  ──► Phase 3: Critic scores
                                    │
                  ┌─────────────────┴─────────────────┐
                  │                                   │
           score ≥95%                          score <95%
         all tests green                    or any test failing
                  │                                   │
                  ▼                                   ▼
        [07-pull-request/]                  [05-in-progress/]
    announce if all subject              clear claimed_at/completed_at
    tickets now in 07-pull-request       increment consecutive_failures
                                         escalate if same error 2–3×
```

## Phase Dispatch Table

| Phase | File | Active when |
|-------|------|-------------|
| 1 | `review/p1-resolve-ticket.md` | command is first invoked |
| 2a | `review/p2a-examiner.md` | ticket resolved and confirmed in 06-in-review/ |
| 2b | `review/p2b-tests.md` | Examiner evidence table complete |
| 2c | `review/p2c-documentation.md` | any AC involves documentation |
| 3 | `review/p3-score.md` | evidence table and test results complete |
| 4 | `review/p4-pass.md` | Phase 3 verdict is PASS |
| 5 | `review/p5-fail.md` | Phase 3 verdict is FAIL |
| 6 | `review/p6-report.md` | Phase 4 or Phase 5 complete |

## Execution

Read Phase 1 file now: `review/p1-resolve-ticket.md`
Execute it completely. Then read the next phase file as instructed within that file.
Each phase file ends with a "→ Next" line pointing to the next phase file.
