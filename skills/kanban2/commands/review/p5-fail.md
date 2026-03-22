# Phase 5 — FAIL Path
<!-- Part of: review.md orchestrator -->
<!-- Active when: Phase 3 verdict is FAIL (score < 95% or any test suite failing) -->

*Follow this path only if verdict is FAIL.*

### Step A — Append Review Record

Append to the ticket file's append zone:

```markdown
## Review — YYYY-MM-DDTHH:MMZ — FAIL XX%

| AC | Evidence | Status | Gap |
|----|----------|--------|-----|
| Criterion text | — | Missing | What needs to be added |

Issues (prioritised):
1. [Most critical — specific and actionable: what is missing, where it belongs, why it is required]
2. [Next issue...]
```

Prioritise issues by impact. Each issue must name the specific thing missing, the file or location where it belongs, and why it is required.

### Step B — Clear Timestamps and Increment Failures

In the ticket frontmatter, set:

```yaml
completed_at: ~
```

Increment `consecutive_failures` by 1. If the field does not exist, add it with value `1`.

### Step C — Move Ticket

Move the ticket file from `06-in-review/` back to `05-in-progress/`:

```
.kanban/YYYY-MM-DD-<subject>/06-in-review/TASK-NNN-<subject>.md
  → .kanban/YYYY-MM-DD-<subject>/05-in-progress/TASK-NNN-<subject>.md
```

### Step D — Git Commit

If inside a git repo: stage all modified and moved files, then commit:

```
kanban(review): FAIL TASK-NNN (XX%), returned to in-progress
```

If not inside a git repo: skip silently.

### Same-Error Escalation

After each FAIL, extract the primary blocking error or gap pattern from the review record just written.

Compare it against the primary blocking error from the previous FAIL on this ticket (stored in the ticket's review history).

**If the same primary error recurs 2–3 times unchanged** (not a new or different error — the identical gap, unaddressed):

1. Fire a desktop notification using your platform's notification tool (e.g., `osascript -e 'display notification "Kanban: NNN stuck on [error]" with title "Review escalation"'` on macOS, or an equivalent mechanism on other platforms).
2. Print this exact escalation message:

   ```
   [ESCALATION] {subject}/{ticket-id} has failed review {N} times with
   the same gap: "{gap description}". This may represent a broken
   assumption in the plan. Options:
     1. Fix the implementation gap (most common)
     2. Create a plan amendment ticket and revisit
     3. Mark this ticket as blocked with a note
   ```

3. If your environment provides an ask-user tool, present the escalation through it and wait for explicit acknowledgment before any retry.

**A new or different error means progress** — do not escalate for new errors. Escalate only when the identical gap recurs without change.

→ Next: Read `review/p6-report.md` and execute it.
