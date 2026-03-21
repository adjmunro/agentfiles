---
model: claude-haiku-4-5-20251001
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion
argument-hint: "[YYYY-MM-DD-{subject}] — subject to initialize"
---

## Personas

**Setup role:** Infrastructure and scaffolding. Initializes the subject-centric directory structure for a new kanban2 work cycle. Creates all stage directories and ensures they are ready for downstream work. Does not touch ideation phases or v1 legacy structure.

## DO

- Create the `.kanban/YYYY-MM-DD-{subject}/` directory structure
- Create all stage subdirectories: `03-refinement/`, `04-todo/`, `05-in-progress/`, `06-in-review/`, `07-pull-request/`, `08-done/`
- Create the `00-assets/` directory with a `.gitkeep` so it is tracked even when empty
- Document the archive path (`.kanban/.archive/YYYY-MM-DD-{subject}/`) for future reference
- Note that v1 structure coexists unchanged
- Ask for confirmation if the subject directory already exists

## DO NOT

- Clobber an existing subject directory without asking
- Modify or delete any v1 kanban structure (`.kanban/01-plan/`, `.kanban/02-todo/`, etc.)
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
   > - **(Recommended)** Reinitialize — add any missing directories (safe)
   > - Abort — do not modify anything

3. If "Abort", exit gracefully
4. If "Reinitialize", proceed to Phase 3 and create only missing directories

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

## Phase 4 — V1 Coexistence Note

Document (in this command) that the v1 kanban structure (`.kanban/01-plan/`, `.kanban/02-todo/`, `.kanban/03-in-progress/`, etc.) coexists unchanged. This command creates only the new subject-centric structure; it does not touch, read, or modify any v1 directories.

The archive path for this subject is `.kanban/.archive/YYYY-MM-DD-{subject}/` — it will be created by the cleanup command when work completes.

---

## Phase 5 — Report

Report to the user what was created. Include:

- The subject name: `YYYY-MM-DD-{subject}`
- All directories created (or skipped if they already existed)
- The `.gitkeep` location in `00-assets/`
- A note that the archive path will be `.kanban/.archive/YYYY-MM-DD-{subject}/` (created automatically by cleanup)
- A note that v1 structure (`.kanban/01-plan/`, `.kanban/02-todo/`, etc.) coexists and was not modified

Example:

```
✓ Initialized: .kanban/2026-03-22-my-feature/

Directories created:
  - 00-assets/ (with .gitkeep)
  - 03-refinement/
  - 04-todo/
  - 05-in-progress/
  - 06-in-review/
  - 07-pull-request/
  - 08-done/

Archive path (for later): .kanban/.archive/2026-03-22-my-feature/

Note: v1 kanban structure (.kanban/01-plan/, .kanban/02-todo/, etc.) coexists unchanged.
```

Keep the report concise and clear. The user should immediately see what was created and where to start.
