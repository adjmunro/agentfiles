---
model: claude-haiku-4-5-20251001
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion
argument-hint: "[YYYY-MM-DD-{subject}] — subject to initialise"
---

## DO

- Create the `.kanban/YYYY-MM-DD-{subject}/` directory structure
- Create all stage subdirectories: `03-refinement/`, `04-todo/`, `05-in-progress/`, `06-in-review/`, `07-pull-request/`, `08-done/`
- Create the `00-assets/` directory with a `.gitkeep` so it is tracked even when empty
- Ask for confirmation if the subject directory already exists

## DO NOT

- Clobber an existing subject directory without asking
- Create files outside of `.kanban/`
- Proceed without validating the subject name format

---

## Phase 1 — Resolve Subject

Derive the subject slug from `$ARGUMENTS`. The subject name must follow the pattern `YYYY-MM-DD-{subject}` (full ISO date, lowercase alphanumeric + hyphens, no spaces).

**Priority order:**
1. If `$ARGUMENTS` is provided and matches `YYYY-MM-DD-*`, use it as-is
2. If not provided or invalid format, ask the user to provide the subject in the required format

**Ask the user:**
> Enter the subject directory name in format `YYYY-MM-DD-{subject}` (e.g., `2026-03-22-my-feature`):

Validate the format before proceeding. If invalid, ask again.

---

## Phase 2 — Check Existing

Check whether `.kanban/YYYY-MM-DD-{subject}/` already exists in the project root.

**If it exists:**
1. List what directories and files are present inside
2. Ask the user:
   > Subject directory `.kanban/YYYY-MM-DD-{subject}/` already exists. Options:
   > - **(Recommended)** Reinitialise — add any missing directories (safe)
   > - Abort — do not modify anything

3. If "Abort", exit gracefully
4. If "Reinitialise", proceed to Phase 3 and create only missing directories

**If it does not exist:**
Proceed to Phase 3.

---

## Phase 3 — Create Structure

Inside `.kanban/YYYY-MM-DD-{subject}/`, create these directories:

```
.kanban/YYYY-MM-DD-{subject}/
├── 00-assets/           (with .gitkeep)
├── 03-refinement/
├── 04-todo/
├── 05-in-progress/
├── 06-in-review/
├── 07-pull-request/
└── 08-done/
```

Create each directory using your file-creation tool. Add a `.gitkeep` file inside `00-assets/` to ensure the directory is tracked by git even when empty.

---

## Phase 4 — Report

Report to the user what was created. Include:

- The subject name: `YYYY-MM-DD-{subject}`
- All directories created (or skipped if they already existed)
- The `.gitkeep` location in `00-assets/`
- A note that the archive path will be `.kanban/.archive/{subject}/` (created automatically by the cleanup command)

Example:

```
✓ Initialised: .kanban/2026-03-22-my-feature/

Directories created:
  - 00-assets/ (with .gitkeep)
  - 03-refinement/
  - 04-todo/
  - 05-in-progress/
  - 06-in-review/
  - 07-pull-request/
  - 08-done/

Archive path (for later): .kanban/.archive/2026-03-22-my-feature/
```

Keep the report concise and clear. The user should immediately see what was created and where to start.

This command creates only the subject scaffold. To populate it with tickets, run `/ideate YYYY-MM-DD-{subject}` or create tickets directly in `04-todo/`.
