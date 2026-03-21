---
model: claude-opus-4-6
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion
argument-hint: "[YYMMDD-<subject>] — subject to plan; omit to auto-derive"
---

## DO

- Read the captured input file from `.kanban/01-plan/YYMMDD-<subject>/`
- Interview the user to surface tradeoffs, ambiguities, and success criteria
- Draft a structured plan covering 100% of captured input
- Run an audit gate and auto-fix all gaps — do not ask for permission to fix
- Commit twice: once after drafting, once after audit
- Operate only inside `.kanban/01-plan/YYMMDD-<subject>/`

## DO NOT

- Touch any files in `.kanban/02-todo/` through `.kanban/05-pull-request/`
- Write a plan without first reading and validating the input file
- Skip the interview phase — always surface ambiguities before drafting
- Ask the user whether to fix audit gaps — auto-fix all of them
- Proceed if a work session is active for this subject

---

## Phase 1 — Session Boundary Check

Check for ticket files in `.kanban/03-in-progress/` or `.kanban/04-in-review/` that match the current subject and have a recent `claimed_at` timestamp.

**STOP:** If any such files exist, print: "A work session is active. Run plan in a separate agent instance." Exit immediately.

---

## Phase 2 — Resolve Subject and Locate Input

Determine the `YYMMDD-subject` slug using the following priority order. Stop at the first source that yields a result:

1. **`$ARGUMENTS` match** — if arguments contain a `YYMMDD-*` pattern, use it as-is.
2. **Existing plan directories** — list `.kanban/01-plan/` and use the most recently modified subject directory.
3. **Git worktree** — take the last path segment of the current worktree. Example (Claude Code): `Bash` with `git worktree list`.
4. **Branch/log** — derive from the current branch name or recent commit subjects. Example (Claude Code): `Bash` with `git branch --show-current`.
5. **Conversation context** — synthesise a slug from the current conversation.
6. **Last resort** — `YYMMDD-` plus a brief slug from what the user just said.

**Date prefix:** Compute `YYMMDD` from today's date once and reuse it throughout. Example (Claude Code): `Bash` with `date +%y%m%d`.

Locate the input file at:

```
.kanban/01-plan/YYMMDD-<subject>/input-YYMMDD-<subject>.md
```

**STOP:** If the file does not exist, print: "No captured input found. Run `/kanban-capture` first." Exit immediately.

**STOP:** If the file is still a stub (all section bodies are empty or missing), print: "No captured input found. Run `/kanban-capture` first." Exit immediately. A stub is defined as a file where every section (`## What`, `## Why`, `## Constraints`, `## Assets`) contains no meaningful content.

---

## Phase 3 — Interview Before Writing

You are acting as **Critic**. Your job is to find what the input does not say before any plan is written. Do not skip this phase.

Use your environment's interactive question tool (e.g., `AskUserQuestion`, a structured prompt, or inline questions) to surface:

- **Tradeoffs** — what alternatives were considered and rejected, and why
- **Ambiguities** — terms or requirements that could be interpreted more than one way
- **Edge cases** — what happens at the boundaries, with bad input, or under failure
- **Scope boundaries** — what is explicitly excluded; what future work is deferred
- **Acceptance signals** — how will "done" be recognized; what does success look like
- **Failure modes** — what could go wrong during build, deployment, or use

Ask non-obvious questions. Do not restate things already in the input — probe the gaps. Gather enough to draft without revisiting the user.

---

## Phase 4 — Draft Plan

Using the input file and interview answers, draft `plan-YYMMDD-<subject>.md` with exactly this structure:

```markdown
## Intent
[The why — motivation and goals traced from input]

## Requirements
[Numbered: 1.1, 1.2, 2.1, etc. Each traceable to input verbatim]

## Constraints
[Hard limits, non-negotiables, platform requirements]

## Out of Scope
[Explicitly excluded. What won't be built here.]
```

Requirements MUST be numbered with a two-level scheme (e.g., `1.1`, `1.2`, `2.1`). Every requirement MUST be traceable to a specific phrase or item from the input file.

---

## Phase 5 — Confirm With User

Show the plan outline (section headings and requirement numbers with one-line summaries) and ask the user to approve before writing the full file.

**STOP:** If the user rejects the outline, revise the draft per their feedback and return to this step. Do not write the file until the user approves.

---

## Phase 6 — Write Plan File

Write the approved plan to:

```
.kanban/01-plan/YYMMDD-<subject>/plan-YYMMDD-<subject>.md
```

---

## Phase 7 — Git Commit (Draft)

Check whether the project root is inside a git repository. Example (Claude Code): `Bash` with `git rev-parse --is-inside-work-tree`.

If inside a git repo:
1. Stage the plan file.
2. Commit with the message: `kanban(plan): draft plan for YYMMDD-<subject>`

If not inside a git repo: skip silently.

---

## Phase 8 — Critic Audit Gate

**Threshold: 95%.** You are the Critic — this is not a formality. Find the gaps.

### Step A — Enumerate Input

Read `input-YYMMDD-<subject>.md` in full. Break it into a numbered list of discrete, verifiable items. Every stated requirement, constraint, asset, goal, and contextual detail is a separate item. Be granular — split compound items.

### Step B — Classify Coverage

For each enumerated item, check the plan and classify:

- **Full** — appears in the plan with sufficient detail to act on
- **Partial** — mentioned but missing detail, context, or specificity
- **Missing** — does not appear in the plan at all

### Step C — Score

```
score = (full + 0.5 × partial) / total × 100
```

### Step D — Auto-Fix All Gaps

For every Partial and Missing item: update `plan-YYMMDD-<subject>.md` to cover it. Do NOT ask for permission. Do NOT skip. Add new requirement entries, expand vague constraints, or extend the Out of Scope section as needed.

### Step E — Rescore

Recalculate the score after all fixes are applied.

### Step F — Append Audit Section

Append the following section to `plan-YYMMDD-<subject>.md`:

```markdown
## Audit: input → plan — PASS|FAIL
**Date**: ISO8601  **Threshold**: 95%

| # | Item | Status | Notes |
|---|------|--------|-------|
| 1 | User wants X | Full | §2.1 |
| 2 | Must support Y | Partial | §3 vague |

- Full: N, Partial: N, Missing: N — Total: N
- Score: (full + 0.5×partial) / total × 100 = **XX%**

### Fixes Applied
- Added §3.2 covering item 2
```

Replace `PASS|FAIL` with the actual result. Score ≥ 95% is PASS. A FAIL result means the auto-fix step did not fully resolve all gaps — investigate and fix before committing.

**STOP:** If the audit result is FAIL after fixes are applied, diagnose which items remain unresolvable and report to the user before proceeding.

---

## Phase 9 — Git Commit (Audit)

If inside a git repo:
1. Stage the updated plan file.
2. Commit with the message: `kanban(plan): audit verified YYMMDD-<subject>`

---

## Phase 10 — Report

Report to the user:
- The plan file path
- The audit result (PASS/FAIL, score, item counts)
- Any fixes that were applied during the audit
- The two commit messages (if git commits were made)

Keep the report concise. The user should be able to confirm the plan is verified and ready for the next stage.
