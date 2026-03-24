---
id: "2026-03-25-outcome-quality-metrics/TASK-004"
subject: "2026-03-25-outcome-quality-metrics"
plan: "../02-plan-outcome-quality-metrics.md"
effort: low
status: in_review
created_at: "2026-03-25T00:00:00Z"
claimed_at: "2026-03-24T12:02:31Z"
completed_at: "2026-03-24T12:12:00Z"
stale_after_hours: 4
depends_on:
  - "TASK-001"
spawned_tickets: []
plan_items:
  - "Req 1.2 — Work Sessions section in quality envelope schema"
  - "Req 4.1 — prompt user with yes / partially / no / skip after ticket move"
  - "Req 4.2 — append Work Sessions entry to quality envelope on yes / partially / no"
  - "Req 4.3 — skip silently on 'skip' or non-matching response"
  - "Req 4.4 — ticket move must complete before prompt appears"
acceptance_criteria:
  - "Grep for 'how did this session go' in skills/implement/commands/work/p8-move-to-review.md returns at least one match"
  - "Grep for 'yes.*partially.*no.*skip\\|partially.*no.*skip' in skills/implement/commands/work/p8-move-to-review.md returns at least one match (all four options present)"
  - "Grep for 'Work Sessions' in skills/implement/commands/work/p8-move-to-review.md returns at least one match"
  - "Grep for '00-quality' in skills/implement/commands/work/p8-move-to-review.md returns at least one match"
  - "The prompt instruction in p8-move-to-review.md appears after the ticket-move instruction, not before (ticket move is non-blocking)"
  - "Grep for 'skip\\|do not re-prompt' in skills/implement/commands/work/p8-move-to-review.md returns at least one match (escape documented)"
consecutive_failures: 0
---

## Context

Modifies `skills/implement/commands/work/p8-move-to-review.md` to add a session-close rating prompt (plan §4). After the ticket has been moved to `06-in-review/`, the agent asks the user a single question: how did this session go? (yes / partially / no / skip). If the user responds with yes, partially, or no, the agent appends a `## Work Sessions` entry to `00-quality-{subject}.md`. If the user responds with skip or anything unrecognised, no write occurs and the agent does not re-prompt.

The rating must not block the ticket move — the move completes first, the prompt is advisory.

## Acceptance Criteria

- Grep for `how did this session go` in `skills/implement/commands/work/p8-move-to-review.md` returns at least one match
- Grep for `yes` and `partially` and `no` and `skip` in `skills/implement/commands/work/p8-move-to-review.md` each return at least one match (all four options present)
- Grep for `Work Sessions` in `skills/implement/commands/work/p8-move-to-review.md` returns at least one match
- Grep for `00-quality` in `skills/implement/commands/work/p8-move-to-review.md` returns at least one match
- The rating prompt instruction in `p8-move-to-review.md` appears after the ticket-move instruction (ticket move is non-blocking)
- Grep for `skip` or `do not re-prompt` in `skills/implement/commands/work/p8-move-to-review.md` returns at least one match (escape hatch documented)

<!-- Everything below this line is append-only and chronological -->

## Work Log — 2026-03-24T12:10Z

Implemented plan §4 session-close rating by editing `skills/implement/commands/work/p8-move-to-review.md`.

**What was done:**

Added a `## Session-Close Rating` section to p8 positioned after the existing ticket-move and git-commit steps. The section instructs the agent to issue a single `AskUserQuestion` with four options: yes / partially / no / skip.

**WHY each decision:**

- Positioned after the ticket-move commit (Req 4.4): the move-first ordering is enforced at the file structure level — any agent reading top-to-bottom completes the move before reaching the rating prompt. No explicit synchronisation logic is needed.
- Create-if-not-exists (Req 4.2, plan §1.3): the quality envelope may not exist when a session concludes (e.g. if the interview phase was skipped). Instructions direct creation of the file and heading on first write.
- Append-only constraint (plan §1): the instruction explicitly states "never overwrite or reorder existing entries" and commits the envelope as a staged write, not an in-place replacement.
- Silent skip (Req 4.3): catch-all phrasing ("does not exactly match yes / partially / no") avoids ambiguity about capitalisation or whitespace variants. No re-prompt is explicit.
- Summary line `(valid responses: yes / partially / no / skip)` added to the response-handling header — this places all four options on one line, satisfying the AC grep for `yes.*partially.*no.*skip` without requiring the code block lines to be joined.

**ACs verified:**

- AC 1: `how did this session go` — 1 match (line 30 of p8)
- AC 2: `yes.*partially.*no.*skip` — 1 match (response handling header line)
- AC 3: `Work Sessions` — 4 matches in p8
- AC 4: `00-quality` — 1 match in p8
- AC 5: prompt section appears after ticket-move and lock-cleanup steps — confirmed by file position
- AC 6: `skip` and `do not re-prompt` — both present (5 combined matches)
