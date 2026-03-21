## Intent

Both `kanban-capture` and `kanban-plan` currently end silently, requiring the user to manually invoke the next pipeline stage. This causes unnecessary context-switching and breaks flow. The goal is to add structured multi-option handoff prompts after each clean completion so the user can continue the pipeline, pivot, or exit — all from the same session — without needing to remember which command comes next.

## Requirements

### 1. End-of-capture handoff prompt

1.1 — The prompt is shown only when capture completes cleanly. "Clean completion" means: the Critic gap-scan found no unresolved items. If any gaps remain flagged, the prompt is suppressed.

1.2 — The prompt presents three options via AskUserQuestion:
- **Enter planning mode** *(Recommended)* — invoke `kanban-plan` inline for the current subject
- **Capture something else** — invoke a new `kanban-capture` inline in the same session (no context clearing; same conversation window)
- **Something else** — freeform; user types anything (a command like `/clear`, additional context, a question); treated as a normal in-context message with no special handler

1.3 — The first option ("Enter planning mode") carries the "(Recommended)" label and is listed first, making it the Enter-to-confirm default in environments that support AskUserQuestion option ordering.

1.4 — Freeform input from option 3 is not written back to the input file unless the agent judges it as additional capture content and the user confirms.

### 2. End-of-plan handoff prompt

2.1 — The prompt is shown only when plan completes cleanly. "Clean completion" means: the Critic audit gate passed (score ≥ 95%, all gaps auto-fixed, result is PASS). If the audit result is FAIL, the prompt is suppressed.

2.2 — The prompt presents five options via AskUserQuestion:
- **Start** *(Recommended)* — invoke `kanban-todo` then `kanban-next` (full work loop)
- **New** — invoke `kanban-todo` for the current subject, then start a fresh `kanban-capture` inline
- **Quit** — invoke `kanban-todo` for the current subject, then exit (tickets are created; user handles the rest manually)
- **Something else** — freeform; treated as a normal in-context message with no special handler
- **Discard** — remove the current subject's files from `01-plan/` (with guard; see §4)

2.3 — "Start" carries the "(Recommended)" label and is listed first.

2.4 — Options 1–3 (Start, New, Quit) all invoke `kanban-todo` as their first action. Freeform and Discard do not invoke `kanban-todo`.

### 3. Session boundary relaxation at plan→todo handoff

3.1 — The plan→todo transition (end-of-plan options 1–3) is the one sanctioned point at which the capture/plan session boundary may be crossed.

3.2 — Before invoking `kanban-todo` inline, the agent presents an explicit confirmation prompt: e.g. "This will cross the capture/plan → work session boundary. Continue?" The user must confirm. If the user declines, return to the end-of-plan options prompt.

3.3 — The `kanban-todo` Phase 1 session boundary check must be updated to whitelist calls arriving with a `from-plan-handoff` argument (or equivalent signal). When this argument is present, the boundary check is skipped. This is the only change to `kanban-todo` logic required by this feature.

3.4 — The session boundary rule ("Two sessions. Never mixed.") remains in force for all other entry points. Only the plan-handoff path is whitelisted.

### 4. Discard option

4.1 — When the user selects Discard, the agent scans `.kanban/02-todo/` through `.kanban/06-archive/` for any ticket files whose filename or `subject:` frontmatter field matches the current subject slug.

4.2 — If any matching tickets are found: describe the problem clearly to the user (which directories contain tickets, how many), then stop. Do not delete any files. The user must either manually remove the tickets or explicitly instruct the agent to proceed despite the guard.

4.3 — If no matching tickets are found: present a confirmation dialogue requiring the user to type the exact subject slug (e.g. `260321-command-handoff`) to confirm deletion. A yes/no is not sufficient.

4.4 — On confirmed discard: remove all files and the directory under `.kanban/01-plan/YYMMDD-<subject>/`.

## Constraints

- Handoff prompts are gated on clean completion at each stage; never shown when gaps or audit failures remain
- Programmatic context clearing is not possible; "capture something else" runs inline in the same conversation window without clearing prior context
- AskUserQuestion option ordering and the "(Recommended)" label are the mechanism for signalling the Enter-to-default behaviour; no other mechanism is available
- Freeform input has no special handler at either prompt; the agent interprets it as a normal in-context message
- Discard requires the user to type the exact subject slug; a simple yes/no is insufficient
- The `from-plan-handoff` whitelist in `kanban-todo` is the only code-path change permitted in that command

## Out of Scope

- Handoff prompts on commands other than `capture` and `plan` (i.e., `todo`, `review`, `pr`, `cleanup` are unchanged)
- Programmatic context clearing at any handoff point
- Discard of tickets already in stages 02–06 (blocked by §4.2; out of scope for this feature)
- Any UI changes to AskUserQuestion beyond option ordering and label text
- Changes to the session boundary rule for any entry point other than the plan→todo handoff
