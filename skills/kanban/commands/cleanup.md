---
model: claude-haiku-4-5-20251001
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion
argument-hint: "[YYYY-MM-DD-<subject>] — subject to archive; omit to auto-derive"
---

## Personas

- `../../personas/critic.md` — **Arden (Critic)** — active in Phase 0 through Phase 1
- `../../personas/analytics.md` — **Pulse (Analytics)** — active in Reporting

Read each file before proceeding. Identify by the active persona when communicating with the user.

## DO

- Verify every precondition before touching any file
- Confirm the archive structure is correct before removing originals
- Move files; never copy-and-leave or delete-without-archiving
- Commit the archive with the canonical git message

## DO NOT

- DO NOT proceed if any tickets remain in `02-todo/`, `03-in-progress/`, or `04-in-review/`
- DO NOT archive if the PR is not yet merged (GitHub repos)
- DO NOT remove stage directories themselves — only the subject subdirectories within them
- DO NOT skip the final audit — it is the last quality gate before work is sealed
- DO NOT auto-create gap tickets and skip to archive — run `kanban-next` and repeat the full loop first

---

## Precondition Flowchart

Determine repo type, then follow the appropriate branch.

```
Is this a GitHub repo?
│
├── YES → Check PR status
│         gh pr view --json state (or equivalent GitHub CLI)
│         │
│         ├── state = MERGED → continue to Phase 1
│         └── state ≠ MERGED → STOP
│               "PR not yet merged. Wait for merge confirmation before archiving."
│               (Archive is permanent — do not trigger prematurely.)
│
└── NO (non-GitHub / non-git) → Check 05-pull-request/
          All tickets for this subject present in 05-pull-request/YYYY-MM-DD-<subject>/ → continue to Phase 1
```

---

## Subject Derivation

If `[YYYY-MM-DD-subject]` is provided as an argument, use it.

If omitted, auto-derive: scan `05-pull-request/` for subject subdirectories. If exactly one exists, use it. If multiple exist, ask the user which subject to archive before proceeding.

---

## Phase 0 — Precondition Check

**STOP immediately if any of the following are true:**

1. Tickets for this subject exist in `02-todo/YYYY-MM-DD-<subject>/`
2. Tickets for this subject exist in `03-in-progress/YYYY-MM-DD-<subject>/`
3. Tickets for this subject exist in `04-in-review/YYYY-MM-DD-<subject>/`

List every blocking ticket by path and name. Do not proceed until the list is empty.

4. (GitHub repos only) The PR associated with this subject is not in `MERGED` state.

Print: `PR not yet merged. Wait for merge confirmation before archiving.`

Do not proceed.

---

## Phase 1 — Final Plan Audit

**Critic in this phase — DO NOT:**
- Approve coverage that is vague or relies on tickets without a `PASS` review entry
- Skip requirements that "seem done" — every requirement must map to a passing ticket
- Proceed to archive if the threshold is not met — create gap tickets and loop first
- Modify source code or alter ticket content (audit only)

**Source:** `.kanban/01-plan/YYYY-MM-DD-<subject>/plan-<subject>.md`
**Target:** all ticket files in `.kanban/05-pull-request/YYYY-MM-DD-<subject>/`

Read the plan. Extract every discrete requirement. For each requirement, locate the ticket(s) in `05-pull-request/YYYY-MM-DD-<subject>/` that address it and verify at least one ticket has a `PASS` review entry.

Classify each requirement:
- **Full** — covered by one or more tickets, all with a `PASS` review entry
- **Partial** — covered but the review entry is missing or ambiguous
- **Missing** — no ticket addresses this requirement

Append the following audit block to `plan-<subject>.md`:

```markdown
## Audit: plan → done tickets — PASS|FAIL
**Date**: <ISO8601>  **Threshold**: 95%

| # | Requirement | Ticket(s) | Review Status | Coverage |
|---|------------|-----------|---------------|----------|
| 1 | ... | ... | PASS / PARTIAL / — | Full / Partial / Missing |

- Full: N, Partial: N, Missing: N — Total: N
- Score: (full + 0.5×partial) / total × 100 = **XX%**

### Fixes Applied
- (list any corrections made, or "None")
```

**If score < 95%:**

1. Create gap tickets in `.kanban/02-todo/YYYY-MM-DD-<subject>/` for every Missing or unresolvable Partial requirement
2. Auto-trigger `kanban-next` to run them through the full work → review loop
3. **STOP.** Do not proceed to Phase 2 until a subsequent `kanban-cleanup` run achieves ≥95%

**If score ≥ 95%:** continue to Phase 2.

---

## Phase 1.5 — Version Bump and Changelog

If the subject's changes are scoped to `skills/kanban/` (check the committed file paths for this subject via `git log`):

1. Read the current version from `VERSION.md`.
2. Determine the appropriate semver increment based on what was changed:
   - Patch — bug fixes, typos, minor corrections
   - Minor — new features, behaviour changes
   - Major — breaking changes
3. Bump `VERSION.md` to the next version.
4. Prepend a new entry to `CHANGELOG.md` following the format in `AGENTS.md`.
5. Commit: `chore(kanban): bump version to X.Y.Z for YYYY-MM-DD-<subject>`

If the subject's changes do not touch `skills/kanban/`, skip this phase silently.

---

## Phase 2 — Archive

### Target Structure

```
.kanban/06-archive/YYYY-MM-DD-<subject>/
├── plan/        ← everything from 01-plan/YYYY-MM-DD-<subject>/
│                   (input files, plan doc, research notes, assets)
└── tickets/     ← everything from 05-pull-request/YYYY-MM-DD-<subject>/
```

### Steps

1. Create `.kanban/06-archive/YYYY-MM-DD-<subject>/plan/` and `.kanban/06-archive/YYYY-MM-DD-<subject>/tickets/`
2. Move all contents of `.kanban/01-plan/YYYY-MM-DD-<subject>/` → `06-archive/YYYY-MM-DD-<subject>/plan/`
3. Move all contents of `.kanban/05-pull-request/YYYY-MM-DD-<subject>/` → `06-archive/YYYY-MM-DD-<subject>/tickets/`
4. **Verify** the archive structure matches the tree above before removing originals
5. Remove `.kanban/01-plan/YYYY-MM-DD-<subject>/` (the subject subdirectory only)
6. Remove `.kanban/05-pull-request/YYYY-MM-DD-<subject>/` (the subject subdirectory only)
7. Confirm no subject files remain in stages `02-todo/` through `04-in-review/` (they must already be empty per Phase 0)

Do not remove the stage directories themselves (e.g., do not delete `01-plan/` — only `01-plan/YYYY-MM-DD-<subject>/`).

### Git Commit

```
kanban(archive): complete YYYY-MM-DD-<subject>
```

Stage all moved/removed files and commit with this exact message format.

---

## Reporting

**You are now Pulse.** Report the archive facts, then the metrics. Keep the metrics honest — one sprint isn't a trend, but it's still a data point worth naming.

After a successful archive, report:

- **Archived subject:** `YYYY-MM-DD-<subject>`
- **Final audit score:** XX% (Full: N, Partial: N, Missing: N / Total: N)
- **Archive path:** `.kanban/06-archive/YYYY-MM-DD-<subject>/`
- **Files archived:** N plan files, N tickets
- **Stages cleaned:** list of stage directories that had their subject subdirectory removed

**Metrics (derive from ticket frontmatter and git log):**

- **Tickets:** N total — N passed first review, N required multiple attempts
- **Failure rate:** N% of tickets failed at least one review
- **Average cycles per ticket:** N work→review loops (total loops / total tickets)
- **Any ticket stuck 3+ times:** list by ID if applicable

One sentence on what the numbers suggest — not a conclusion, a question worth asking next time.
