---
model: claude-haiku-4-5-20251001
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion, Agent
argument-hint: "[YYYY-MM-DD-{subject}/TASK-NNN] — ticket to implement"
---

> **Note on model selection:** The frontmatter model above is the default (low effort). At runtime, the actual model is determined by the ticket's `effort` field: `low` → fast/cheap model, `medium` → standard model, `high` → most capable model. Spawn subagents at the appropriate tier when your environment supports it.

## Personas

Read `../../personas/builder/persona.md` before proceeding. You are **Kira (Builder)** throughout this command.

## DO

- Claim the lowest-numbered unblocked ticket from `.kanban/YYYY-MM-DD-{subject}/04-todo/` unless `$ARGUMENTS` specifies a ticket
- Include inline WHY-comments in every code change — this is a hard requirement, not a suggestion
- Reference plan items and ticket IDs in code comments wherever a piece of code satisfies a requirement
- Commit after every meaningful unit of work using the prescribed format
- Create new tickets in `04-todo/` for any out-of-scope work discovered during implementation
- Override model tier based on the ticket's `effort` field (low→haiku, medium→sonnet, high→opus)

## DO NOT

- Touch plan-layer files or directories: `00-input-*`, `01-research-*`, `02-plan-*`, `00-assets/`, `03-refinement/`
- Batch unrelated changes into a single commit
- Edit existing entries in the ticket's append zone — only append new ones
- Proceed if `.kanban/YYYY-MM-DD-{subject}/04-todo/` does not exist

---

## Phase 1 — Session Boundary

**Check that this is NOT a capture or plan session.** Kanban2 is work-only. If `$ARGUMENTS` contains `from-ideation-handoff`, this is a sanctioned crossing — proceed without challenge.

Otherwise, scan `.kanban/YYYY-MM-DD-{subject}/05-in-progress/` for any active in-progress tickets. If a ticket exists there with `status: in_progress` and its `claimed_at` timestamp has NOT exceeded `stale_after_hours`, report a conflict:

> Active in-progress ticket found: `{ticket-id}`. Resolve or reset it before claiming a new ticket.

Then exit. Do not touch any files.

If the in-progress ticket IS stale (see Phase 4 for staleness definition), surface it and ask the user whether to continue with that ticket or reset it before picking a new one.

---

## Phase 2 — Ticket Selection

Determine which ticket to implement using the following priority order:

1. **`$ARGUMENTS` path** — if arguments contain a `YYYY-MM-DD-{subject}/TASK-NNN` pattern, locate that ticket in `.kanban/YYYY-MM-DD-{subject}/04-todo/`. Verify the file exists.
2. **Auto-select** — list `.kanban/YYYY-MM-DD-{subject}/04-todo/` for ticket files. Select the lowest-numbered ticket whose `depends_on` are all satisfied.

**Dependency check:** Read each candidate ticket's frontmatter `depends_on` list. For each listed ticket ID, confirm a file with that ID exists in `.kanban/YYYY-MM-DD-{subject}/06-in-review/`, `.kanban/YYYY-MM-DD-{subject}/07-pull-request/`, or `.kanban/YYYY-MM-DD-{subject}/08-done/` with `status: in_review`, `status: in_pr`, or `status: done`. Skip any ticket where one or more dependencies are not yet satisfied.

**STOP:** If no ticket files exist in `04-todo/`, print exactly:

> No todo tickets found for this subject. Run `/kanban init` first or check that tickets have been promoted to `04-todo/`.

Then exit. Do not touch any files.

**Move the selected ticket** from `.kanban/YYYY-MM-DD-{subject}/04-todo/` to `.kanban/YYYY-MM-DD-{subject}/05-in-progress/`. Create the destination directory if it does not exist.

Update the ticket's frontmatter:

```yaml
status: in_progress
claimed_at: "<ISO8601 timestamp>"
```

Compute the current timestamp. Example (Claude Code): `Bash` with `date -u +"%Y-%m-%dT%H:%M:%SZ"` on macOS/Linux.

If inside a git repo:
1. Stage the moved ticket file (old path deletion + new path addition).
2. Commit with the message: `kanban(work): claim {TASK-NNN} for {YYYY-MM-DD-subject}`

---

## Phase 3 — Implementation

<!-- INTENT ANCHOR — re-read original intent before writing any code -->
<!-- 1. Read the ticket's `plan` frontmatter field to get the plan file path. -->
<!-- 2. Read the `## Intent` section from that plan file. -->
<!-- 3. State the intent in exactly 1 sentence before writing any code. Do not proceed until this sentence is written. -->

Before writing a single line of code, read the full ticket file from top to bottom.

**Required reading:**

- All existing `## Review` sections — understand exactly what failed in prior attempts and why
- The `## Context` section — understand why this ticket exists
- The `## Acceptance Criteria` section — understand the verifiable completion conditions

**Staleness policies for artifacts read in this phase:**
- Ticket file (`05-in-progress/TASK-NNN-*.md`): NO TTL — frontmatter is updated in-place and always reflects current state. Load without age check.
- Plan file (path from ticket's `plan` frontmatter field): LOAD WITH CAVEAT (TTL: 7 days). Check its `created_at` frontmatter field (or file mtime as fallback).
  - If age ≤ 7 days: load normally.
  - If age > 7 days: load, but prepend this warning to any extracted content:
    ⚠ STALE (written {N} days ago): treat as reference only. Plan may not reflect current codebase — verify requirements against existing code before implementing.

**If prior Review sections exist:** Treat every identified issue as a constraint on your implementation. Do not repeat the same mistakes. Note which plan items each prior failure touched.

**Model tier override:** Read the ticket's `effort` field and select the appropriate model:
- `low` → fast/cheap model (e.g. haiku)
- `medium` → standard model (e.g. sonnet)
- `high` → most capable model (e.g. opus)

If your environment supports spawning subagents, select the appropriate tier here.

### WHY-Comments — Non-Negotiable

Every code change must include inline comments explaining:

- **WHY this code exists** — what requirement or constraint drives it
- **WHY this approach was chosen** — what alternatives were considered and rejected
- **What breaks if you remove it** — the consequence of deletion or change
- **Which plan item or ticket AC it satisfies** — reference by ID where applicable

Comments that only describe *what* the code does are non-compliant. "Sort the list" is not a WHY-comment. "Sort before binary search — O(log n) lookup in Phase 3 requires sorted input; unsorted input silently returns wrong results" is.

### Scope Enforcement

Work only within the scope defined by this ticket's acceptance criteria. If implementation reveals additional work outside this ticket's stated ACs, do NOT do that work here. See Phase 7.

### Plan-Layer Isolation

The following paths are **read-only** from kanban2. Never write, move, rename, or delete:
- `00-input-*` files
- `01-research-*` files
- `02-plan-*` files
- `00-assets/` directory and its contents
- `03-refinement/` directory and its contents

Kanban2 picks up work only after tickets are promoted to `04-todo/`.

---

## Phase 4 — Stale Detection

After claiming a ticket, compute whether it is stale:

```
stale = (now - claimed_at) > (stale_after_hours * 3600 seconds)
```

If stale:
1. Surface a warning to the user:
   > Ticket `{ticket-id}` was claimed at `{claimed_at}` and has exceeded its `stale_after_hours` limit of `{N}` hours. It may represent a prior interrupted session.
2. Ask the user whether to:
   - **(Recommended)** Continue — proceed with implementation as-if fresh
   - Reset — move the ticket back to `04-todo/`, clear `claimed_at` and `status`, and exit

If the user chooses to continue, proceed to Phase 3 implementation. If reset, move the ticket back and exit cleanly.

---

## Phase 5 — Commit Discipline

Commit after every meaningful, self-contained unit of work. A meaningful unit is one of:

- A model or type definition
- A function or method (with its tests if co-located)
- A test suite for an existing function
- A protocol, interface, or schema
- A configuration change that is complete in itself

**Never batch unrelated changes into a single commit.**

Commit message format:

```
feat({NNN}): [what and why in one line]
```

Replace `{NNN}` with the ticket number. The message body should describe what changed and why it matters — not a laundry list of files touched.

Examples:
- `feat(011): add work.md command — implements kanban2 ticket claim and implementation flow`
- `feat(011): add stale detection — prevents resuming abandoned sessions without user confirmation`

---

## Phase 6 — Append Work Log

When implementation is complete, append a Work Log entry to the ticket's append zone (below the `<!-- Everything below this line is append-only -->` comment). The append zone is chronological and append-only — never edit existing entries.

```markdown
## Work Log — YYYY-MM-DDTHH:MMZ

[What was done. Decisions made. WHY each decision was made — the same standard as code comments. Reference plan items and ACs by ID. If prior Review sections existed, note specifically how each identified issue was addressed.]
```

The Work Log is cross-agent memory. Write as if future-Ward (Documentation persona) is reading this months later when the codebase has drifted and the context is gone. Every decision must have a WHY. The reader should be able to reconstruct your reasoning without reading the code.

If inside a git repo:
1. Stage the updated ticket file.
2. Commit with the message: `kanban(work): log progress on {TASK-NNN}`

---

## Phase 7 — New Work Discovered

If implementation reveals work that is clearly outside this ticket's acceptance criteria — a missing dependency, an adjacent bug, a required refactor — do NOT do that work here.

Instead:

1. Create a new ticket file in `.kanban/YYYY-MM-DD-{subject}/04-todo/` with proper frontmatter (see Ticket Frontmatter Reference below).
2. Give it the next available `TASK-NNN` number in the subject directory.
3. Add its ID to the `spawned_tickets` list in THIS ticket's frontmatter.
4. If the new ticket must be completed before a future ticket can run, update that future ticket's `depends_on` accordingly.

If inside a git repo, stage and commit the new ticket file:
`kanban(work): spawn {TASK-NNN} from {TASK-NNN} (out-of-scope work)`

---

## Phase 8 — Move to Review

When all acceptance criteria are verified, move the ticket from `.kanban/YYYY-MM-DD-{subject}/05-in-progress/` to `.kanban/YYYY-MM-DD-{subject}/06-in-review/`. Create the destination directory if it does not exist.

Update the ticket's frontmatter:

```yaml
status: in_review
completed_at: "<ISO8601 timestamp>"
```

If inside a git repo:
1. Stage the moved ticket file.
2. Commit with the message: `kanban(work): complete {TASK-NNN}, moving to 06-in-review`

---

## Phase 9 — Git Commit

After each phase that produces a meaningful artifact (claimed ticket, implementation commit, work log, review move), make a conventional commit:

```
feat(scope): implement {ticket-id}
```

The commit body should state WHY — what this ticket delivers, which requirement it satisfies, what would break without it.

---

## Phase 10 — Report

Report to the user:

- The ticket that was claimed and worked (ID and slug)
- What was implemented and which ACs were satisfied
- The number of commits made
- Any new tickets spawned (with IDs and brief descriptions)
- The final ticket location (now in `06-in-review/`)
- Any issues encountered that the reviewer should be aware of

Keep the report concise. The user should be able to confirm the ticket is ready for local review without reading the ticket file themselves.

---

## Consecutive Failure Escalation

If the ticket's `consecutive_failures` field is ≥ 2, escalate before starting implementation:

> Warning: This ticket has failed review `{consecutive_failures}` consecutive time(s). The same gap may be recurring. Review prior `## Review` sections carefully before proceeding.

If `consecutive_failures` is ≥ 3, send a desktop notification (if your environment supports it) and append an escalation block:

```markdown
## Escalation — YYYY-MM-DDTHH:MMZ

Ticket has reached {N} consecutive failures. Identical gap may be recurring. Prior review sections reviewed: [yes/no]. Approach taken to break the pattern: [description].
```

---

## Ticket Frontmatter Reference

```yaml
---
id: "YYYY-MM-DD-{subject}/TASK-NNN"
subject: "YYYY-MM-DD-{subject}"
plan: "../../01-plan/YYYY-MM-DD-{subject}/plan-{subject}.md"
effort: low | medium | high
status: todo | in_progress | in_review | done
created_at: "ISO8601"
claimed_at: ~
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-001"
spawned_tickets: []
plan_items:
  - "Req 2.1 — description"
acceptance_criteria:
  - "Verifiable command or observable output"
consecutive_failures: 0
---
```

---

## Ticket Body Structure Reference

```markdown
## Context
[Why this ticket exists — static, set once.]

## Acceptance Criteria
[Complete list — static, set once.]

---
<!-- Everything below this line is append-only and chronological -->

## Work Log — YYYY-MM-DDTHH:MMZ
[What was done, decisions made, why each decision was made.]

## Review — YYYY-MM-DDTHH:MMZ — FAIL 72%
[Evidence table, issue list — written by reviewer, not by Builder.]

## Work Log — YYYY-MM-DDTHH:MMZ
[Addressing review issues from above — reference each issue by number or description.]
```

**Static zone** (`## Context`, `## Acceptance Criteria`): set once at ticket creation.

**Append zone** (below `<!-- Everything below this line is append-only -->`): strictly chronological. Every entry is appended. Existing entries are never edited. This is the cross-agent audit trail.
