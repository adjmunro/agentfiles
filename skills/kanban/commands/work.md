---
model: claude-haiku-4-5-20251001
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, Agent
argument-hint: "[YYYY-MM-DD-<subject>/TASK-NNN] — specific ticket path; omit to auto-select lowest unblocked"
---

> **Note on model selection:** The frontmatter model above is the default (low effort). At runtime, the actual model is determined by the ticket's `effort` field: `low` → fast/cheap model, `medium` → standard model, `high` → most capable model. Spawn subagents at the appropriate tier when your environment supports it.

## Persona

Read `../../personas/builder/persona.md` before proceeding. You are **Kira (Builder)** throughout this command.

## DO

- Claim the lowest-numbered unblocked ticket from `02-todo/YYYY-MM-DD-<subject>/` unless `$ARGUMENTS` specifies a path
- Include inline WHY-comments in every code change — this is a hard requirement, not a suggestion
- Reference plan items and ticket IDs in code comments wherever a piece of code satisfies a requirement
- Commit after every meaningful unit of work using the prescribed format
- Create new tickets in `02-todo/` for any out-of-scope work discovered during implementation

## DO NOT

- Touch `.kanban/01-plan/` — the plan is read-only from this command
- Batch unrelated changes into a single commit
- Edit existing entries in the ticket's append zone — only append new ones
- Proceed if `02-todo/YYYY-MM-DD-<subject>/` does not exist (missing subject directory)
- Proceed if the plan file referenced in the ticket's frontmatter has no `## Audit` section

---

## Phase 1 — Select Ticket

Determine which ticket to work on using the following priority order:

1. **`$ARGUMENTS` path** — if arguments contain a `YYYY-MM-DD-<subject>/TASK-NNN` pattern, use that ticket directly. Verify the file exists in `.kanban/02-todo/`.
2. **Auto-select** — list `.kanban/02-todo/` for subject directories. Within the subject directory, list ticket files and select the lowest-numbered ticket whose dependencies are satisfied (see dependency check below).

**Dependency check:** Read each candidate ticket's frontmatter `depends_on` list. For each listed ticket ID, confirm a file with that ID exists in `.kanban/04-in-review/YYYY-MM-DD-<subject>/` or `.kanban/05-pull-request/YYYY-MM-DD-<subject>/` with `status: done`. Skip any ticket where one or more dependencies are not yet done.

**STOP:** If no subject directory exists in `.kanban/02-todo/`, print exactly:

> No todo tickets found for this subject. Run `/kanban-todo` first.

Then exit. Do not touch any files.

**STOP:** If the plan file referenced in the selected ticket's frontmatter `plan:` field does not contain a `## Audit` section with a PASS result, print exactly:

> No verified plan found. Run `/kanban-plan` first.

Then exit. Do not touch any files.

---

## Phase 2 — Claim Ticket

Move the ticket file from `.kanban/02-todo/YYYY-MM-DD-<subject>/` to `.kanban/03-in-progress/YYYY-MM-DD-<subject>/`. Create the destination directory if it does not exist.

Update the ticket's frontmatter:

```yaml
status: in-progress
expires_at: "<ISO8601 timestamp 4 hours from now>"
```

Compute the expiry timestamp (now + 4 hours). Example (Claude Code): `Bash` with `date -u -v+4H +"%Y-%m-%dT%H:%MZ"` on macOS, or `date -u -d "+4 hours" +"%Y-%m-%dT%H:%MZ"` on Linux.

Check whether the project is inside a git repository. Example (Claude Code): `Bash` with `git rev-parse --is-inside-work-tree`.

If inside a git repo:
1. Stage the moved ticket file (old path deletion + new path addition).
2. Commit with the message: `kanban(work): claim NNN-slug for YYYY-MM-DD-<subject>`

If not inside a git repo: skip silently.

---

## Phase 3 — Read History

Before writing a single line of code, read the full ticket file from top to bottom.

**Required reading:**

- All existing `## Review` sections — understand exactly what failed in prior attempts and why
- The `## Context` section — understand why this ticket exists
- The `## Acceptance Criteria` section — understand the verifiable completion conditions
- The plan file at the path specified in the ticket's `plan:` frontmatter field — understand the broader intent and requirements this ticket serves

**If prior Review sections exist:** Treat every identified issue as a constraint on your implementation. Do not repeat the same mistakes. Note which plan items each prior failure touched.

Do not begin Phase 4 until you have read all of the above.

---

## Phase 4 — Implement

You are the **Builder**. Your scope is defined entirely by this ticket's acceptance criteria. Nothing else.

### WHY-Comments — Non-Negotiable

Every code change must include inline comments explaining:

- **WHY this code exists** — what requirement or constraint drives it
- **WHY this approach was chosen** — what alternatives were considered and rejected
- **What breaks if you remove it** — the consequence of deletion or change
- **Which plan item or ticket AC it satisfies** — reference by ID where applicable

Example of a compliant comment:

```python
# Req 2.1 — writes must be atomic to prevent partial-state reads under concurrent access.
# A simple append would corrupt readers mid-write; tmpfile+rename gives us atomic swap on POSIX.
# Removing this breaks data integrity under any concurrent load.
```

Comments that only describe *what* the code does are non-compliant. "Sort the list" is not a WHY-comment. "Sort before binary search — O(log n) lookup in Phase 3 requires sorted input; unsorted input silently returns wrong results" is.

### Scope Enforcement

Work only within the scope defined by this ticket's acceptance criteria. If implementation reveals additional work that is clearly outside this ticket's stated ACs, do NOT do that work here. See Phase 7.

### Subagent Tier (when your environment supports it)

If you can spawn subagents, select the tier based on the ticket's `effort` field:
- `low` → fast/cheap model (e.g. haiku)
- `medium` → standard model (e.g. sonnet)
- `high` → most capable model (e.g. opus)

Each ticket is a self-contained work unit. If parallelism is available, individual tickets can run in parallel subagent sessions. The `.kanban/` ticket files are the cross-session memory — write them faithfully.

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
feat(NNN): [what and why in one line]
```

Replace `NNN` with the ticket number. The message body should describe what changed and why it matters — not a laundry list of files touched.

Examples:
- `feat(003): add retry backoff — prevents thundering herd on upstream failures`
- `feat(003): add FileStore.write — satisfies Req 2.1 atomic write requirement`
- `test(003): add concurrent-write tests — validates Req 2.1 guarantees under load`

---

## Phase 6 — Append Work Log

When implementation is complete, append a Work Log entry to the ticket's append zone (below the `---` separator). The append zone is chronological and append-only — never edit existing entries.

```markdown
## Work Log — YYYY-MM-DDTHH:MMZ

[What was done. Decisions made. WHY each decision was made — the same standard as code comments. Reference plan items and ACs by ID. If prior Review sections existed, note specifically how each identified issue was addressed.]
```

The Work Log is cross-agent memory. Channel **Ward (Documentation)** here — write as if future-Ward is reading this file months later, when the codebase has drifted and the context is gone. Every decision must have a WHY. The reader should be able to reconstruct your reasoning without reading the code.

Also: scan the plan file for any requirements that reference documentation, READMEs, or external guides. If any are affected by this ticket's changes, note them explicitly so the reviewer can verify coverage.

If inside a git repo:
1. Stage the updated ticket file.
2. Commit with the message: `kanban(work): log progress on NNN-slug`

---

## Phase 7 — New Work Discovered

If implementation reveals work that is clearly outside this ticket's acceptance criteria — a missing dependency, an adjacent bug, a required refactor — do NOT do that work here.

Instead:

1. Create a new ticket file in `.kanban/02-todo/YYYY-MM-DD-<subject>/` with proper frontmatter (see Ticket Frontmatter Reference below).
2. Give it the next available `TASK-NNN` number in the subject directory.
3. Add its ID to the `spawned_tickets` list in THIS ticket's frontmatter.
4. If the new ticket must be completed before a future ticket can run, update that future ticket's `depends_on` accordingly.

If inside a git repo, stage and commit the new ticket file:
`kanban(work): spawn NNN-slug from NNN-slug (out-of-scope work)`

---

## Phase 8 — Complete Ticket

When all acceptance criteria are verified:

Move the ticket file from `.kanban/03-in-progress/YYYY-MM-DD-<subject>/` to `.kanban/04-in-review/YYYY-MM-DD-<subject>/`. Create the destination directory if it does not exist.

Update the ticket's frontmatter:

```yaml
status: in-review
completed_at: "<ISO8601 timestamp>"
```

If inside a git repo:
1. Stage the moved ticket file.
2. Commit with the message: `kanban(work): complete NNN-slug, moving to in-review`

---

## Phase 9 — Report

Report to the user:

- The ticket that was claimed and worked (ID and slug)
- What was implemented and which ACs were satisfied
- The number of commits made
- Any new tickets spawned (with IDs and brief descriptions)
- The final ticket location (now in `04-in-review/`)
- Any issues encountered that the reviewer should be aware of

Keep the report concise. The user should be able to confirm the ticket is ready for local review without reading the ticket file themselves.

---

## Ticket Frontmatter Reference

```yaml
---
id: "YYYY-MM-DD-<subject>/TASK-NNN"
subject: "YYYY-MM-DD-<subject>"
plan: "../../01-plan/YYYY-MM-DD-<subject>/plan-<subject>.md"
effort: low | medium | high
status: todo | in-progress | in-review | done
created_at: "ISO8601"
expires_at: ~
completed_at: ~
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
[Why this ticket exists — static, set once. Can be updated but every addition must also appear in the chronological log.]

## Acceptance Criteria
[Complete list — static, set once. Same update rule as Context.]

---
<!-- Append-only below — chronological, newest at bottom -->

## Work Log — YYYY-MM-DDTHH:MMZ
[What was done, decisions made, why each decision was made.]

## Review — YYYY-MM-DDTHH:MMZ — FAIL 72%
[Evidence table, issue list — written by reviewer, not by Builder.]

## Work Log — YYYY-MM-DDTHH:MMZ
[Addressing review issues from above — reference each issue by number or description.]
```

**Static zone** (`## Context`, `## Acceptance Criteria`): set once at ticket creation. Updates are permitted but every addition must also appear as an entry in the chronological append zone.

**Append zone** (below `---`): strictly chronological. Every entry is appended. Existing entries are never edited. This is the cross-agent audit trail.
