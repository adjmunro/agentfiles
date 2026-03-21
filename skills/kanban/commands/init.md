---
model: claude-haiku-4-5-20251001
allowed-tools: Read, Glob, Bash, Write
argument-hint: "[YYMMDD-<subject>] — optional subject name override; omit to auto-derive"
---

## DO

- Create the `.kanban/` directory structure in the project root
- Derive a subject name from available context without asking the user
- Create a stub input file for the initialised subject
- Commit the result if inside a git repo

## DO NOT

- Clobber an existing `.kanban/` directory under any circumstances
- Ask the user for a subject name — always derive it
- Create files outside of `.kanban/`
- Proceed past the safety check if `.kanban/` already exists

---

## Phase 1 — Safety Check

Check whether a `.kanban/` directory already exists in the project root.

**STOP:** If `.kanban/` exists, read its current state, report what directories and files are present, and exit. NEVER overwrite or modify existing kanban state. No exceptions.

---

## Phase 2 — Create Stage Directories

Create the following six directories under `.kanban/` in the project root. Use your environment's file-creation tool or equivalent directory-creation command.

```
.kanban/01-plan/
.kanban/02-todo/
.kanban/03-in-progress/
.kanban/04-in-review/
.kanban/05-pull-request/
.kanban/06-archive/
```

---

## Phase 3 — Derive Subject Name

Determine the subject slug using the following priority order. Work through each source in order and stop at the first one that yields a usable result. NEVER ask the user.

1. **`$ARGUMENTS` match** — if arguments were passed and contain a `YYMMDD-*` pattern, extract and use it as-is.
2. **Existing plan content** — if `.kanban/01-plan/` already contains directories, check if the current work maps to an in-flight subject and reuse that name.
3. **Git worktree** — run a git worktree list command and take the last path segment of the current worktree entry. Example (Claude Code): `Bash` tool with `git worktree list`.
4. **Conversation content** — synthesise a short slug from what the work is actually about based on context in this conversation.
5. **Branch and log** — run a command to get the current branch name and recent commit subject lines. Example (Claude Code): `Bash` tool with `git branch --show-current` and `git log --oneline -5`.
6. **Last resort** — construct a slug from today's date and a brief summary of what the user just said.

**Slugify rules:**
- Lowercase only
- Replace spaces with hyphens
- Strip all characters except alphanumerics and hyphens

**Date prefix:** Compute `YYMMDD` from today's date once and use it consistently throughout this run. Example (Claude Code): `Bash` tool with `date +%y%m%d`.

The final subject name MUST follow the pattern `YYMMDD-subject-slug`.

---

## Phase 4 — Create Subject Directory and Stub Input File

Create the subject directory under `01-plan/`, including an `assets/` subdirectory for any binary files or referenced assets:

```
.kanban/01-plan/YYMMDD-<subject>/
.kanban/01-plan/YYMMDD-<subject>/assets/
```

Create the stub input file at:

```
.kanban/01-plan/YYMMDD-<subject>/input-YYMMDD-<subject>.md
```

The stub file MUST contain exactly the following structure (replace `YYMMDD-<subject>` with the derived name):

```markdown
# YYMMDD-<subject>

## What

## Why

## Constraints

## Assets
```

---

## Phase 5 — Git Commit

Check whether the project root is inside a git repository. Example (Claude Code): `Bash` tool with `git rev-parse --is-inside-work-tree`.

If inside a git repo:
1. Stage the newly created `.kanban/` directory.
2. Commit with the message: `kanban: initialise .kanban/ for YYMMDD-<subject>`

If not inside a git repo: skip this phase silently. No warning needed.

---

## Phase 6 — Report

Report to the user what was created. Include:
- The six stage directories that were created
- The subject name that was derived and which source it came from (e.g. "derived from git worktree path")
- The path to the stub input file
- Whether a git commit was made (and the commit message if so)

Keep the report concise. The user should be able to see at a glance that initialisation succeeded and where to start writing.
