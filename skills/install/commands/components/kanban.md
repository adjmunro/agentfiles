# Component: kanban

Creates the `.kanban/` directory scaffold in the current repository, then symlinks
the ideation and implement command directories into `.claude/commands/` (and
`.agents/commands/` if that directory also exists).

## DO

- Create all scaffold directories with a `.gitkeep` file so they are tracked by git
- Use relative symlink paths — symlinks must survive the repo being moved
- Check before creating: skip any directory or symlink that already exists correctly
- Warn (and skip) if a symlink slot is occupied by something pointing elsewhere

## DO NOT

- Overwrite a real directory with a symlink
- Remove or modify any existing files
- Create `.claude/` or `.agents/` if they do not already exist — only link into them

---

## Phase 1 — Create .kanban/ Scaffold

Check whether `.kanban/` exists in the current directory:
- If it already exists: check which stage directories are present; skip those, create any missing
- If it does not exist: create the full structure

Directories to create inside `.kanban/`:

```
01-plan/
02-todo/
03-in-progress/
04-in-review/
05-pull-request/
06-archive/
```

For each directory: create it, then write an empty `.gitkeep` file inside it.

Print:
```
.kanban/ scaffold:
  ✓ 01-plan/
  ✓ 02-todo/
  ✓ 03-in-progress/
  ✓ 04-in-review/
  ✓ 05-pull-request/
  ✓ 06-archive/
```
Mark any pre-existing directories as "(already existed)".

---

## Phase 2 — Symlink Command Directories

**Agentfiles source check:**

Command symlinks must point to a local directory — they cannot point to a URL.
Check whether `$AGENTFILES_PATH` is set and resolves to a real local path.

- If `$AGENTFILES_PATH` is set and valid: use it as the symlink source
- If not available: print a warning and skip this phase
  > Warning: `$AGENTFILES_PATH` not set or not found. Command symlinks require a local agentfiles checkout.
  > Clone https://github.com/adjmunro/agentfiles and set `$AGENTFILES_PATH` to link commands.

The symlink sources are:
- `$AGENTFILES_PATH/skills/ideation/commands`
- `$AGENTFILES_PATH/skills/implement/commands`

**For `.claude/commands/` (if `.claude/` exists):**

1. Create `.claude/commands/` if it does not exist
2. For each skill name (`ideation`, `implement`):
   a. If `.claude/commands/{name}` does not exist → create a relative symlink
   b. If it exists and is a correct symlink → print "already linked — skipped"
   c. If it exists and points elsewhere → print a warning and skip

**For `.agents/commands/` (if `.agents/` exists):**

Repeat the same logic for `.agents/commands/{name}`.

**If neither `.claude/` nor `.agents/` exists:**

Print:
> Warning: neither `.claude/` nor `.agents/` found. Command symlinks were not created.
> Create either directory and re-run `/install kanban` to link them.

---

## Phase 3 — Report

Print a consolidated summary including any warnings. Suggest running `/ideate` to
start the first subject.
