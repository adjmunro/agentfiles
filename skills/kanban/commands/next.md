---
model: claude-haiku-4-5-20251001
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, Agent, AskUserQuestion
argument-hint: "[YYMMDD-subject] — subject to work on; omit to list available subjects"
---

## DO

- Act as a low-tier orchestrator only — dispatch work and review as subagents
- Drive the full work→review loop until PASS, escalation, or user halt
- Select the lowest-numbered unblocked ticket from `02-todo/`
- Detect stale in-progress tickets before starting any loop
- Track consecutive identical errors and escalate before looping again
- Ask the user before continuing to the next ticket after a PASS
- Announce when all tickets are in `05-pull-request/` and the subject is ready for `/kanban-pr`

## DO NOT

- Implement any ticket work directly — dispatch it
- Skip the review step after work completes
- Share your full session context with subagents — give them only what they need
- Loop indefinitely on the same error without escalating
- Assume subagents are available — degrade gracefully to sequential execution

---

## Work→Review Loop

```
┌─────────────────────────────────────┐
│         Phase 1: Subject            │
│  argument? → use it                 │
│  else → list subjects, ask user     │
│  none in 02-todo → check stale      │
└────────────────┬────────────────────┘
                 │
┌────────────────▼────────────────────┐
│         Phase 2: Ticket             │
│  scan 02-todo/YYMMDD-subject/       │
│  select lowest-numbered unblocked   │
│  all blocked? → report chain, stop  │
└────────────────┬────────────────────┘
                 │
┌────────────────▼────────────────────┐
│  Stale check: scan 03-in-progress/  │
│  stale_after_hours elapsed? → ask   │
└────────────────┬────────────────────┘
                 │
         ┌───────▼────────┐
         │  Dispatch work │ ← subagent tier = ticket effort
         └───────┬────────┘
                 │
         ┌───────▼──────────┐
         │  Dispatch review │ ← subagent tier = medium
         └───────┬──────────┘
                 │
        ┌────────▼────────┐
        │   PASS or FAIL? │
        └──┬──────────┬───┘
           │          │
         PASS        FAIL
           │          │
           │    ┌─────▼──────────────────────┐
           │    │  same error 2–3x unchanged? │
           │    └─────┬──────────┬────────────┘
           │          │          │
           │        YES          NO
           │          │          │
           │    ┌─────▼──┐  ┌───▼──────────┐
           │    │ESCALATE│  │ loop → work  │
           │    └────────┘  └──────────────┘
           │
    ┌──────▼────────────────────────────────┐
    │  Report result                        │
    │  Continue with next ticket? (Y/n)     │
    │  yes → Phase 2                        │
    │  no  → stop, report progress summary  │
    │  no more 02-todo → announce PR-ready  │
    └───────────────────────────────────────┘
```

---

## Phase 1 — Subject Selection

1. If `$ARGUMENTS` contains a subject in `YYMMDD-subject` format, use it directly. Skip to Phase 2.

2. If no argument is given:
   - Glob `.kanban/02-todo/*/` to list all subjects that contain at least one ticket file.
   - Use your environment's ask-user tool (e.g., `AskUserQuestion` in Claude Code) to confirm which subject to work on.

3. **STOP** if no subjects with `02-todo/` tickets exist:
   - Scan `.kanban/03-in-progress/` for any subjects with ticket files.
   - If found, surface them: "No todo tickets found. Found tickets in 03-in-progress — these may be from a crashed session. Resume them or move them back to 02-todo?"
   - Use the ask-user tool to get a decision before proceeding.
   - If nothing found anywhere, report that the board is empty and stop.

---

## Phase 2 — Ticket Selection

1. Glob `.kanban/02-todo/YYMMDD-subject/*.md` and sort numerically by filename prefix.

2. For each ticket (lowest number first):
   - Read the frontmatter and extract `depends_on` (list of ticket IDs or filenames).
   - A dependency is **satisfied** when its ticket file exists under `.kanban/04-local-review/` or `.kanban/05-pull-request/` **with `status: done` in frontmatter**.
   - If all dependencies are satisfied, select this ticket. Stop scanning.
   - If any dependency is unsatisfied, skip to the next ticket.

3. If **all** tickets in the subject are blocked:
   - Report the full blocking chain clearly.
   - Use the ask-user tool: "All tickets in YYMMDD-subject are blocked by unmet dependencies. Resolve the blocking tickets first, or manually unblock one?"
   - Stop until the user responds.

---

## Stale Ticket Detection

Before starting the loop, scan `.kanban/03-in-progress/YYMMDD-subject/` for ticket files where:
- `claimed_at` is set in frontmatter
- The elapsed time since `claimed_at` exceeds `stale_after_hours` (default: 4 hours if unset)
- The ticket has not moved to a later stage

If any stale tickets are found, surface them via the ask-user tool:

> "Found N stale ticket(s) in 03-in-progress/YYMMDD-subject. These may be from a crashed session:
> - [ticket list]
>
> Resume them (continue work from where they left off) or move them back to 02-todo to start fresh?"

Wait for the user's decision before continuing. Do not silently skip stale tickets.

---

## Phase 3 — Work→Review Loop

### Dispatching subagents

Construct a minimal context bundle for each subagent — do NOT pass your full session:
- Ticket file path (absolute)
- Subject name (`YYMMDD-subject`)
- Plan file path (`.kanban/01-plan/YYMMDD-subject/plan.md` if it exists)
- For work: instruct the subagent to behave as `kanban-work`
- For review: instruct the subagent to behave as `kanban-review`

Subagent tier for work = ticket's `effort` field (e.g., `low` → haiku, `medium` → sonnet, `high` → opus).
Subagent tier for review = medium.

**If subagents are unavailable**, run `kanban-work` then `kanban-review` behaviors sequentially in the current session rather than skipping either step.

### Loop steps

```
a. Dispatch kanban-work for the selected ticket
b. Dispatch kanban-review for the ticket after work completes
c. Read the review outcome (PASS or FAIL) from the ticket's frontmatter or review output
```

**On PASS:**
- Report the result clearly.
- Ask via the ask-user tool: "Continue with next ticket in YYMMDD-subject? (Y/n)"
- If yes → return to Phase 2 and select the next unblocked ticket.
- If no → stop and print a progress summary (tickets completed, tickets remaining).
- If no tickets remain in `02-todo/` and all are in `05-pull-request/`, announce:
  > "All tickets in YYMMDD-subject are in 05-pull-request. This subject is ready for /kanban-pr."

**On FAIL:**
- Move the ticket back to `03-in-progress/` if it isn't already there.
- Record the primary blocking error signature from the review notes.
- Check whether this is the same error seen in the previous 1–2 consecutive failures.
  - **Different error** → loop back to step (a) immediately.
  - **Same error 2–3 times unchanged** → escalate (see below).

### Same-Error Escalation

When the same blocking error appears 2–3 consecutive times without meaningful change:

1. Send a desktop notification using your platform's native mechanism (e.g., `osascript -e 'display notification ...'` on macOS, or the equivalent on Linux/Windows). This is best-effort — do not fail if unavailable.

2. Print a prominent terminal block:

```
╔══════════════════════════════════════════════╗
║           ESCALATION — REPEATED FAILURE      ║
╠══════════════════════════════════════════════╣
║ Ticket:  [ticket filename]                   ║
║ Subject: [YYMMDD-subject]                    ║
║ Attempts: N                                  ║
╠══════════════════════════════════════════════╣
║ FAILURE PATTERN                              ║
║ [Synthesised summary of all review notes]    ║
╠══════════════════════════════════════════════╣
║ RECOMMENDED ACTION                           ║
║ [Concrete, specific fix direction]           ║
╚══════════════════════════════════════════════╝
```

3. Use the ask-user tool to surface the full failure pattern and ask how to proceed:
   > "This ticket has failed with the same error N times. Here is the full failure pattern: [details]. How would you like to proceed? (Fix the approach / Skip this ticket / Abort)"

4. **Do NOT retry** until the user has responded. Respect their decision:
   - Fix the approach → apply the user's guidance, then restart the loop from step (a).
   - Skip → move the ticket back to `02-todo/` with a blocking note appended to its Work Log, continue to next ticket.
   - Abort → stop the session and report full progress summary.

---

## Progress Summary Format

When stopping (user said no, abort, or no tickets remain), always print:

```
Subject: YYMMDD-subject
  Completed this session: [N tickets → 05-pull-request]
  Remaining in 02-todo:   [N tickets]
  Blocked:                [N tickets, list blockers]
  Stale/in-progress:      [N tickets]
```
