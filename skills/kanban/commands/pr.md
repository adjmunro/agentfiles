---
model: claude-sonnet-4-6
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, Agent, AskUserQuestion
argument-hint: "[YYMMDD-<subject>] — subject to raise PR for; omit to auto-derive"
---

## DO

- Advocate for the implementation — reply to invalid comments with codebase evidence (file paths and line numbers)
- Create tickets for valid reviewer concerns and run them through the full pipeline
- Poll continuously until all comments are resolved and all CI checks are green
- Cite the plan and acceptance criteria when a reviewer missed the intent
- Stay in the polling loop — this session runs until the PR is ready or escalation is required

## DO NOT

- Patch code inline inside `05-pull-request/` — NEVER take shortcuts
- Close or abandon the PR while unresolved comments or failing CI checks remain
- Dismiss a reviewer concern without citing specific evidence from the codebase
- Promote the PR to ready until every comment is resolved and every check is green
- Archive anything — `kanban-cleanup` handles archiving after confirmed merge

---

## Precondition Check

Before doing anything else, verify the preconditions. STOP hard if any are unmet.

**1. Confirm this is a GitHub-backed git repo.**

Run `git remote -v` and look for a `github.com` URL. If no GitHub remote is found, this command does not apply — skip it entirely. All tickets in `05-pull-request/` is sufficient to proceed to `kanban-cleanup`.

**2. Confirm all tickets for this subject have reached `05-pull-request/`.**

Check these directories for any tickets under the subject folder:
- `.kanban/02-todo/YYMMDD-<subject>/`
- `.kanban/03-in-progress/YYMMDD-<subject>/`
- `.kanban/04-in-review/YYMMDD-<subject>/`

If any tickets remain in those stages, STOP. This command must not run until the full pipeline has been completed for all existing tickets.

---

## Derive Subject

If no argument was provided, derive `YYMMDD-subject` by inspecting `.kanban/05-pull-request/` for a single subject folder. If multiple folders are present and no argument was given, ask the user to specify.

---

## Phase 1 — Create Draft PR

**Gather PR content:**

1. Read `.kanban/01-plan/YYMMDD-<subject>/plan-YYMMDD-<subject>.md` and extract the `## Intent` section.
2. Read all ticket files from `.kanban/05-pull-request/YYMMDD-<subject>/`. For each ticket, extract its ID, title, and a one-line summary from the frontmatter or body.
3. Compose the PR body using the format below.

**PR body format:**

```
## Intent
[From plan ## Intent section]

## Tickets
- TASK-001 — [title]: [one-line summary]
- TASK-002 — [title]: [one-line summary]

## Plan
See: .kanban/01-plan/YYMMDD-<subject>/plan-YYMMDD-<subject>.md
```

**Create the draft PR** using your platform's GitHub CLI. Example using `gh`:

```
gh pr create --draft --title "[Concise title derived from intent]" --body "[composed body]"
```

After the PR is created, make a git commit:

```
git commit --allow-empty -m "kanban(pr): open draft PR for YYMMDD-<subject>"
```

(Use `--allow-empty` only if there are no staged changes; otherwise commit normally with the message above.)

---

## Phase 2 — Active Polling Loop

This is a continuous session. Do not treat this as a one-shot check. Poll at a short interval — approximately every 2 minutes — until the exit condition is met.

**Exit condition:** ALL reviewer comments resolved AND all CI checks green.

On each poll cycle:

1. Fetch the latest PR state (comments, review threads, CI check statuses).
2. For each unresolved reviewer comment or review thread, classify it.
3. For each CI check, evaluate its status.
4. Take the appropriate action (see below).
5. Wait, then repeat.

---

## Comment Classification and Routing

```
Reviewer comment
       |
       v
Is the concern already addressed in the current codebase?
       |
      YES → Invalid comment → Reply with evidence → Mark resolved
       |
      NO
       |
       v
Is this a real bug, missing edge case, security issue, or gap in the AC?
       |
      YES → Valid comment → Create ticket → Full pipeline → Loop continues
       |
      NO / UNCERTAIN → Lean toward creating a ticket
```

### Invalid Comment — Reply with Evidence

A comment is invalid when:
- The concern is already addressed in the implementation (cite the code)
- The reviewer misread the approach or misunderstood what the code does
- The concern conflicts with explicitly stated intent in the plan or acceptance criteria

**Action:**
- Read the relevant files and locate the exact lines that address the reviewer's concern
- Reply directly in the PR thread. Include:
  - Specific file path(s) and line number(s)
  - A brief explanation of why the implementation is correct
  - Reference to `plan-YYMMDD-<subject>.md` or the ticket's acceptance criteria if the reviewer missed the intent
- Mark the thread as resolved after replying
- Do NOT change any code

Do not write "we disagree" without evidence. Every reply must cite the codebase.

### Valid Comment — Create a Ticket

A comment is valid when:
- It identifies a real bug not caught by the acceptance criteria
- It surfaces a missing edge case
- It raises a security concern
- The acceptance criteria themselves were incomplete — the plan missed something
- You are uncertain (lean toward creating a ticket)

**Action:**
1. Create a new ticket file in `.kanban/02-todo/YYMMDD-<subject>/` with proper frontmatter (ID, title, description, acceptance criteria derived from the reviewer's concern).
2. Make a git commit:
   ```
   git commit -m "kanban(pr): add TASK-NNN from PR feedback for YYMMDD-<subject>"
   ```
3. Reply to the PR comment acknowledging the concern and noting that a ticket has been created.
4. The new ticket must travel the **full pipeline**: `kanban-work` → `kanban-review` → `05-pull-request/`. No shortcuts.
5. Continue polling. The PR stays open while the ticket is in flight.

---

## Phase 3 — CI Monitoring

Monitor CI checks in the same polling loop. Do not treat CI as a separate phase — it runs concurrently with comment handling.

**If a CI check is failing:**

1. Fetch and read the CI logs to diagnose the failure.
2. Determine whether an existing ticket covers the fix, or create a new fix ticket in `.kanban/02-todo/YYMMDD-<subject>/`.
3. Work the ticket through the full pipeline.
4. Push the fix commits.
5. Continue polling until the check turns green.

Do not promote the PR while any CI check is failing.

---

## Phase 4 — Promote and Notify

When ALL of the following are true:
- Every reviewer comment and review thread is resolved
- Every CI check is green
- No tickets remain in `02-todo/`, `03-in-progress/`, or `04-in-review/` for this subject

**Promote the PR:**

Mark it as ready for review using your platform's GitHub CLI. Example:

```
gh pr ready
```

**Send a desktop notification** via your platform's notification tool. Example on macOS:

```
osascript -e 'display notification "PR ready — your move" with title "Kanban: YYMMDD-<subject>"'
```

Use the equivalent notification mechanism on Linux (e.g., `notify-send`) or Windows (e.g., PowerShell toast notifications).

**Print a prominent terminal block:**

```
=========================================
  PR READY FOR REVIEW
  YYMMDD-<subject>
  [PR URL]
=========================================
```

---

## Archive Gate

Do NOT archive any tickets or the plan folder. The `kanban-cleanup` command is responsible for archiving, and it verifies that the PR is confirmed merged before proceeding. This command's job ends at promotion.
