---
model: claude-opus-4-6
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion
argument-hint: "[YYMMDD-<subject>] — subject to capture; omit to auto-derive"
---

## DO

- Operate as **Scribe** (primary) and **Critic** (challenger) throughout this command
- Interview the user and transcribe their words **verbatim** — zero paraphrasing, zero summarising
- Derive the subject name from context without asking the user
- Route a single session to multiple subject directories when the user discusses distinct workstreams
- Append new `## Session` blocks to existing input files rather than overwriting them
- Run a Critic pass before committing to surface unstated assumptions and missing constraints

## DO NOT

- Ask the user for a subject name — always derive it from the priority sources
- Summarise, interpret, or paraphrase any user statement
- Touch `02-todo/`, `03-in-progress/`, `04-in-review/`, `05-pull-request/`, or `06-archive/` under any circumstances
- Overwrite prior session content in an existing input file
- Proceed if an active work session is detected for the subject (see Phase 1)

---

## Phase 1 — Session Boundary Check

Scan `.kanban/03-in-progress/` and `.kanban/04-in-review/` for ticket files belonging to the same subject as the one being captured. A match exists if any filename contains the derived subject slug or if a ticket's `subject:` frontmatter field matches.

**STOP:** If a matching ticket exists with a recent `claimed_at` timestamp (within the last 48 hours), print exactly:

> A work session is active for this subject. Run capture/plan in a separate agent instance.

Then exit. Do not write any files. No exceptions.

---

## Phase 2 — Derive Subject Name

Determine the subject slug using the following priority order. Work through each source in order and stop at the first that yields a usable result. NEVER ask the user.

1. **`$ARGUMENTS` match** — if arguments were passed containing a `YYMMDD-*` pattern, extract and use it as-is.
2. **Existing plan content** — inspect `.kanban/01-plan/` for existing subject directories. If the current conversation context maps clearly to an in-flight subject, route there and reuse that name.
3. **Git worktree** — run `git worktree list` and take the last path segment of the **current** worktree entry (the one whose path matches the working directory). Example (Claude Code): `Bash` tool with `git worktree list`.
4. **Conversation content** — synthesise a short slug from what the work is actually about based on context available in this session.
5. **Branch and log** — run `git branch --show-current` and `git log --oneline -5` to infer the subject from branch name and recent commit messages. Example (Claude Code): `Bash` tool.
6. **Last resort** — construct a slug from today's date and a brief summary of what the user just said.

**Slugify rules:**
- Lowercase only
- Replace spaces with hyphens
- Strip all characters except alphanumerics and hyphens

**Date prefix:** Compute `YYMMDD` from today's date once and use it throughout this run. Example (Claude Code): `Bash` tool with `date +%y%m%d`. The final subject name MUST follow the pattern `YYMMDD-subject-slug`.

---

## Phase 3 — Locate or Create the Input File

Construct the target paths:

```
.kanban/01-plan/YYMMDD-<subject>/
.kanban/01-plan/YYMMDD-<subject>/input-YYMMDD-<subject>.md
```

**If the input file does not exist or is a stub (empty sections only):**

Create the subject directory if needed, then create the file with this structure:

```markdown
# YYMMDD-<subject>

## What

## Why

## Constraints

## Assets
```

**If the input file exists with substantive content:**

Do NOT overwrite it. Append a new session block at the end of the file. The block header uses the current date and time:

```markdown

## Session YYMMDD-HH:MM
```

All content captured in this run goes inside this block. Prior sessions are immutable.

---

## Phase 4 — Scribe Mode: Interview the User

Adopt the **Scribe** role. Your job is to surface a complete picture of the work before writing anything.

Ask clarifying questions using your environment's interactive question tool if available (e.g., `AskUserQuestion` in Claude Code). If no interactive tool is available, ask questions one at a time inline and wait for the user's response before proceeding.

**Do not ask everything at once.** Questions should be sequential and responsive — each answer may inform the next question.

Questions MUST target non-obvious territory:

- Technical implementation choices and tradeoffs
- UI/UX specifics where applicable
- Edge cases and failure modes
- Hard constraints (timeline, scope, performance, compatibility)
- Acceptance signals — what does "done" look like exactly?
- Dependencies on existing code, designs, or external systems
- What has already been tried or ruled out

Continue asking until the picture is complete. "Complete" means: someone could hand this document to a developer who has never seen this project and they would know exactly what to build, why, and when to stop.

---

## Phase 5 — Transcribe Verbatim

Write the user's words into the input file under the appropriate sections.

**The cardinal rule: user words go in word-for-word, unedited.**

- Zero summarising
- Zero interpreting
- Zero paraphrasing
- Correct obvious typos only if the meaning would otherwise be ambiguous — never alter intent

Agent questions and explanations are NOT transcribed in full. Where an agent response visibly shaped the user's thinking, capture a single bracketed summary line: `[Agent clarified: <one-line summary>]`. Nothing more.

For a **first run**, distribute content across the four sections:

- `## What` — what the work is; what is being built or changed
- `## Why` — the motivation, goal, or problem being solved
- `## Constraints` — hard limits, assumptions, non-negotiables, out-of-scope items
- `## Assets` — existing code, designs, documentation, references, or prior art the user mentioned

For a **subsequent run**, all content goes inside the `## Session YYMMDD-HH:MM` block. Use the same four subsections within that block if the content warrants it, or write as a flat transcript if the session was narrowly focused.

User words are the audit ground truth. The plan will be audited against this file. Corruption here propagates everywhere downstream.

---

## Phase 6 — Critic Pass

Before writing the final file content, adopt the **Critic** role. Silently scan the captured material for:

- Unstated assumptions (things the user assumed you already knew)
- Missing constraints (what happens at the boundary cases?)
- Acceptance signals not yet defined (how will the user know the work is done?)
- Contradictions between sections
- Ambiguous terms that could be interpreted multiple ways

If gaps are found, ask one final targeted question round — keep it to the minimum set that would meaningfully close the gaps. Then transcribe any new answers per Phase 5.

If no meaningful gaps exist, proceed silently.

---

## Phase 7 — Write the File

Write the complete input file content using your environment's file-write tool. For first runs, write the full file. For subsequent runs, append the new session block.

NEVER overwrite prior session content under any circumstances.

---

## Phase 8 — Git Commit

Check whether the project is inside a git repository. Example (Claude Code): `Bash` tool with `git rev-parse --is-inside-work-tree`.

If inside a git repo:
1. Stage only the input file (and its parent directory if newly created).
2. Commit with the message: `kanban(capture): capture raw input for YYMMDD-<subject>`

If not inside a git repo: skip this phase silently.

---

## Phase 9 — Report

Report to the user:

- The subject name derived and which source it came from (e.g. "derived from git worktree path")
- The path to the input file written
- Whether this was a first run (new file) or a subsequent run (new session block appended)
- Whether a git commit was made (and the commit message if so)
- Any gaps the Critic identified that were not fully resolved — flag these explicitly so the user can address them before running `/kanban-plan`

Keep the report concise. The user should be able to confirm capture succeeded and understand what, if anything, needs follow-up before planning begins.
