# Phase 4 — PASS Path
<!-- Part of: review.md orchestrator -->
<!-- Active when: Phase 3 verdict is PASS (score ≥ 95% and all test suites green) -->

*Follow this path only if verdict is PASS.*

### Step A — Append Review Record

Append to the ticket file's append zone (below all existing content, never replacing frontmatter):

```markdown
## Review — YYYY-MM-DDTHH:MMZ — PASS XX%

| AC | Evidence | Status |
|----|----------|--------|
| Criterion text | file:line | Satisfied |

Test results: suite-name → PASS | FAIL per suite
```

Use ISO 8601 format for the timestamp. Replace `XX%` with the actual score rounded to one decimal place.

### Step B — Update Frontmatter

In the ticket frontmatter, set:

```yaml
status: done
```

### Step C — Move Ticket

Move the ticket file from `06-in-review/` to `07-pull-request/`:

```
.kanban/YYYY-MM-DD-<subject>/06-in-review/TASK-NNN-<subject>.md
  → .kanban/YYYY-MM-DD-<subject>/07-pull-request/TASK-NNN-<subject>.md
```

Create the `07-pull-request/` directory first if it does not exist.

### Step D — Git Commit

Check whether the project root is inside a git repository. Example (Claude Code): `Bash` with `git rev-parse --is-inside-work-tree`.

If inside a git repo: stage all modified and moved files, then commit:

```
kanban(review): PASS TASK-NNN (XX%), moving to pull-request
```

If not inside a git repo: skip silently.

### Step E — All-Tickets Check

List all ticket files across `05-in-progress/`, `06-in-review/`, and `07-pull-request/` for this subject.

If ALL tickets for this subject are now in `07-pull-request/` (none remain in earlier stages):

> "All tickets for YYYY-MM-DD-<subject> have passed in-review. Run `/implement pr` to open the pull request."

→ Next: Read `review/p6-report.md` and execute it.
