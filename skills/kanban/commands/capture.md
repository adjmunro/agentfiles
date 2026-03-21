---
model: claude-opus-4-6
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion
argument-hint: "[YYYY-MM-DD-<subject>] — subject to capture; omit to auto-derive"
---

## Personas

- `../../personas/scribe/persona.md` — **Vela (Scribe)** — active in Phases 4–8
- `../../personas/critic/persona.md` — **Arden (Critic)** — active in Phase 6

Read each file before proceeding. Identify by the active persona when communicating with the user.

## DO

- Derive the subject name from context without asking the user
- Route a single session to multiple subject directories when the user discusses distinct workstreams
- Run a Critic pass before committing to surface unstated assumptions and missing constraints

## DO NOT

- Touch `02-todo/`, `03-in-progress/`, `04-in-review/`, `05-pull-request/`, or `06-archive/` under any circumstances
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

1. **`$ARGUMENTS` match** — if arguments were passed containing a `YYYY-MM-DD-*` pattern, extract and use it as-is.
2. **Existing plan content** — inspect `.kanban/01-plan/` for existing subject directories. If the current conversation context maps clearly to an in-flight subject, route there and reuse that name.
3. **Git worktree** — run `git worktree list` and take the last path segment of the **current** worktree entry (the one whose path matches the working directory). Example (Claude Code): `Bash` tool with `git worktree list`.
4. **Conversation content** — synthesise a short slug from what the work is actually about based on context available in this session.
5. **Branch and log** — run `git branch --show-current` and `git log --oneline -5` to infer the subject from branch name and recent commit messages. Example (Claude Code): `Bash` tool.
6. **Last resort** — construct a slug from today's date and a brief summary of what the user just said.

**Slugify rules:**
- Lowercase only
- Replace spaces with hyphens
- Strip all characters except alphanumerics and hyphens

**Date prefix:** Compute `YYYY-MM-DD` from today's date once and use it throughout this run. Example (Claude Code): `Bash` tool with `date +%Y-%m-%d`. The final subject name MUST follow the pattern `YYYY-MM-DD-subject-slug`.

---

## Phase 3 — Locate or Create the Input File

Construct the target paths:

```
.kanban/01-plan/YYYY-MM-DD-<subject>/
.kanban/01-plan/YYYY-MM-DD-<subject>/input-<subject>.md
```

**If the input file does not exist or is a stub (empty sections only):**

Create the subject directory if needed, then create the file with this structure:

```markdown
# YYYY-MM-DD-<subject>

## What

## Why

## Constraints

## Assets
```

**If the input file exists with substantive content:**

Do NOT overwrite it. Append a new session block at the end of the file. The block header uses the current date and time:

```markdown

## Session YYYY-MM-DD-HH:MM
```

All content captured in this run goes inside this block. Prior sessions are immutable.

---

## Phase 4 — Scribe Mode: Interview the User

Adopt the **Scribe** role. Your job is to surface a complete picture of the work before writing anything.

Ask the user: **What are you working on?**

Wait for the user to write before doing anything else. Collect their free-form response in full before proceeding to any clarifying questions.

Once the user has submitted their free-form input, **read and process what they wrote** before forming any questions. Identify gaps, ambiguities, and non-obvious territory in their specific input. Questions must be derived from what is missing or unclear in what the user actually wrote — not drawn from a fixed template of required topics.

Before asking each clarifying question, write a short natural-prose preamble. The preamble must cover three things: your interpretation of what the user wrote (what you understood them to mean), your recommendation or inclination on that point, and your reasoning for why the question needs to be asked. Write this in your own voice — flowing prose, first person, conversational — not as structured sections or formatted headers. You may draw on codebase reads, web research, or session context to inform the preamble at your own discretion, based on what the question warrants.

The following areas are **guidance** for what kinds of gaps are worth surfacing — not a mandatory sequence to work through:

- Technical implementation choices and tradeoffs
- UI/UX specifics where applicable
- Edge cases and failure modes
- Hard constraints (timeline, scope, performance, compatibility)
- Acceptance signals — what does "done" look like exactly?
- Dependencies on existing code, designs, or external systems
- What has already been tried or ruled out

**Do not ask everything at once.** Ask one question at a time, sequentially — each answer may inform the next question.

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

For a **subsequent run**, all content goes inside the `## Session YYYY-MM-DD-HH:MM` block. Use the same four subsections within that block if the content warrants it, or write as a flat transcript if the session was narrowly focused.

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
2. Commit with the message: `kanban(capture): capture raw input for YYYY-MM-DD-<subject>`

If not inside a git repo: skip this phase silently.

---

## Phase 9 — Handoff

This phase runs only on clean completion. Skip it silently if any of the following are true:

- Phase 6 found unresolved Critic gaps (the user did not fully answer the follow-up question round)
- Phase 8 git commit did not complete (e.g. not inside a git repo, or the commit failed)
- Any STOP condition was triggered earlier in the run

If capture completed cleanly, present the user with a choice of what to do next. Use `AskUserQuestion` with three options in this order:

1. **Enter planning mode (Recommended)** — invoke `kanban-plan` inline for the current subject, passing the subject slug as the argument. This is the natural next step after capture.
2. **Capture something else** — invoke a new `kanban-capture` inline in the same session. No context clearing is possible; the existing session context remains.
3. **Something else** — treat the user's free-form response as a normal in-context message. No special handler is invoked.

If the user selects option 3 and provides a free-form message, do NOT write it back to the input file. The exception: if the agent judges the content as additional capture material for the current subject, ask the user explicitly whether to append it. Only append if the user confirms.

---

## Phase 10 — Report

Report to the user:

- The subject name derived and which source it came from (e.g. "derived from git worktree path")
- The path to the input file written
- Whether this was a first run (new file) or a subsequent run (new session block appended)
- Whether a git commit was made (and the commit message if so)
- Any gaps the Critic identified that were not fully resolved — flag these explicitly so the user can address them before running `/kanban-plan`

Keep the report concise. The user should be able to confirm capture succeeded and understand what, if anything, needs follow-up before planning begins.
