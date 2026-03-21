---
model: claude-sonnet-4-6
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion
argument-hint: "[YYYY-MM-DD-{subject}/TASK-NNN] — ticket to review"
---

## Personas

This command uses two personas. Load both files before proceeding.

- Read `../../kanban/personas/examiner.md` — you are **Echo (Examiner)** during Phases 2–2b (evidence gathering and test execution)
- Read `../../kanban/personas/critic.md` — you are **Arden (Critic)** during Phase 3 (scoring and verdict)

Identify by the active persona when communicating with the user.

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

---

## Phase 1 — Resolve Ticket

Determine which ticket to review using this priority order. Stop at the first source that yields a result.

1. **`$ARGUMENTS` match** — if arguments contain a `YYYY-MM-DD-<subject>/TASK-NNN` or `TASK-NNN` pattern, locate that ticket under `.kanban/YYYY-MM-DD-<subject>/06-in-review/`.
2. **Single ticket present** — if the subject's `06-in-review/` contains exactly one ticket file, select it automatically.
3. **Most recently modified** — if multiple tickets exist under `06-in-review/`, select the one with the most recent `claimed_at` timestamp in frontmatter.
4. **Ask the user** — if resolution is still ambiguous, list the available tickets and ask which to review.

**STOP:** If `06-in-review/` contains no tickets, print: "No tickets in 06-in-review. Run `/kanban work` to complete work first." Exit immediately.

Read the ticket file. Confirm its frontmatter contains:
- `status: in_review`
- A `plan` field pointing to the subject plan file

---

## Phase 2 — Examiner: Evidence Gathering (read-only)

**You are now the Examiner.** Your job is to collect evidence — nothing else. Do not score. Do not modify files. Do not run tests yet.

### Step A — Read the Plan

Locate and read the plan file from the path referenced in the ticket's `plan` frontmatter field. If the path is relative, resolve it from the project root.

### Step B — Read All Changed Source Files

From the ticket's implementation notes or `## Changes` section, identify all files modified during the work session. Read each one in full (use `offset`/`limit` for large files).

If the ticket does not list changed files explicitly, infer them:
- Check `git diff HEAD~1 --name-only` or `git status` for recently modified files
- Cross-reference with the plan's requirements to identify relevant files

### Step C — Map Evidence for Each Acceptance Criterion (AC)

For each AC item listed in the ticket:

1. Identify the specific file(s) and line number(s) that satisfy it — be precise.
2. If the criterion involves a command or observable output (non-coding AC), record the command verbatim; it will be executed in Phase 2b.
3. If no evidence exists, note it explicitly as absent.
4. Flag any of the following, regardless of AC status:
   - Security issues (hardcoded secrets, injection vectors, missing auth checks)
   - Logic errors (off-by-one, incorrect conditionals, missing null checks)
   - Missing WHY-comments on non-obvious decisions

### Step D — Record the Evidence Table (no scores)

Produce an internal evidence table with columns: `AC | Evidence (file:line or command) | Present?`

This table is input for the Critic. Do not attach pass/fail labels yet.

---

## Phase 2b — Test Execution

Infer test framework(s) from project files. Check for each of the following — run ALL that match, not just the first:

| File present | Command to run |
|---|---|
| `Package.swift` | `swift test` |
| `build.gradle` or `build.gradle.kts` | `./gradlew test` |
| `package.json` | `npm test` |
| `Makefile` with a `test` target | `make test` |
| `pytest.ini` or `pyproject.toml` with `[tool.pytest*]` | `pytest` |
| `go.mod` | `go test ./...` |

**Override:** If the ticket frontmatter specifies a `test_command` field, run that instead of (or in addition to) the inferred commands.

Run unit, integration, and UI/instrumentation suites where applicable. Record per-suite results: `suite name → PASS | FAIL (N passed, N failed)`.

If no test framework is detected and no `test_command` is specified, record: "No test framework detected — skipping test execution."

---

## Phase 3 — Critic: Scoring and Verdict

**You are now the Critic.** Apply the scoring formula to the Examiner's evidence table.

### Classify each AC item

- **Satisfied** — fully met by the implementation; clear evidence exists
- **Partial** — partially met; describe specifically what is missing or incomplete
- **Missing** — no corresponding implementation found

### Score

```
score = (satisfied + 0.5 × partial) / total × 100
```

### Verdict

- **PASS** — score ≥ 95% AND all required test suites green
- **FAIL** — score < 95% OR any required test suite failing

---

## Phase 4 — PASS Path

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

> "All tickets for YYYY-MM-DD-<subject> have passed in-review. Run `/kanban pr` to open the pull request."

---

## Phase 5 — FAIL Path

*Follow this path only if verdict is FAIL.*

### Step A — Append Review Record

Append to the ticket file's append zone:

```markdown
## Review — YYYY-MM-DDTHH:MMZ — FAIL XX%

| AC | Evidence | Status | Gap |
|----|----------|--------|-----|
| Criterion text | — | Missing | What needs to be added |

Issues (prioritised):
1. [Most critical — specific and actionable: what is missing, where it should live, why it matters]
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

---

## Phase 6 — Same-Error Escalation

After each FAIL, extract the primary blocking error or gap pattern from the review record just written.

Compare it against the primary blocking error from the previous FAIL on this ticket (stored in the ticket's review history).

**If the same primary error recurs 2–3 times unchanged** (not a new or different error — the identical gap, unaddressed):

1. Fire a desktop notification using your platform's notification tool (e.g., `osascript -e 'display notification "Kanban: NNN stuck on [error]" with title "Review escalation"'` on macOS, or an equivalent mechanism on other platforms).
2. Print a prominent terminal block:

   ```
   ╔══════════════════════════════════════════════════╗
   ║  REVIEW ESCALATION — TASK-NNN STUCK             ║
   ║                                                  ║
   ║  Recurring failure: [synthesised pattern]        ║
   ║  Seen N times. Not resolved by prior attempts.   ║
   ║                                                  ║
   ║  Suggested fix direction:                        ║
   ║  [Concrete, specific action to break the loop]   ║
   ╚══════════════════════════════════════════════════╝
   ```

3. If your environment provides an ask-user tool, present the escalation through it and wait for explicit acknowledgment before any retry.

**A new or different error means progress** — do not escalate for new errors. Escalate only when the identical gap recurs without change.

---

## Phase 7 — Report

After completing either path, report:

- Ticket path and final status (PASS/FAIL)
- Score and verdict with breakdown (N satisfied, N partial, N missing out of total)
- Per-suite test results
- Any security or logic issues flagged during evidence gathering
- Where the ticket was moved
- The commit message (if a commit was made)
- The all-tickets-passed announcement, if triggered
