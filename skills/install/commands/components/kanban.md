# Component: kanban

Creates the `.kanban/` directory scaffold in the target repository, then symlinks
the ideation and implement command directories into `.claude/commands/` (and
`.agents/commands/` if that directory also exists in the target).

**Inputs:** `$TARGET`, `$AGENTFILES_ROOT`

## DO

- Create all scaffold directories with a `.gitkeep` file so they are tracked by git
- Use relative symlink paths, not absolute — symlinks must survive the repo being moved
- Check before creating: skip any directory or symlink that already exists correctly
- Warn (and skip) if a symlink slot is occupied by something pointing elsewhere

## DO NOT

- Overwrite a real directory with a symlink
- Remove or modify any existing files in the target
- Create `.claude/` or `.agents/` if they do not already exist — only link into them

---

## Phase 1 — Create .kanban/ Scaffold

Check whether `$TARGET/.kanban/` exists:
- If it already exists: check which of the stage directories are present; skip those,
  create any that are missing
- If it does not exist: create the full structure

Directories to create inside `$TARGET/.kanban/`:

```
01-plan/
02-todo/
03-in-progress/
04-in-review/
05-pull-request/
06-archive/
```

For each directory: create it, then write an empty `.gitkeep` file inside it.

After this phase, print:
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

The symlink sources are:
- `$AGENTFILES_ROOT/skills/ideation/commands`
- `$AGENTFILES_ROOT/skills/implement/commands`

**For `.claude/commands/` (if `.claude/` exists in `$TARGET`):**

1. Create `$TARGET/.claude/commands/` if it does not exist
2. For each skill name (`ideation`, `implement`):
   a. If `$TARGET/.claude/commands/{name}` does not exist → create a relative symlink
      pointing from `.claude/commands/{name}` to the skill's commands directory
   b. If it exists and is already a correct symlink → print "already linked — skipped"
   c. If it exists and points elsewhere → print a warning and skip; do not overwrite

**For `.agents/commands/` (if `.agents/` exists in `$TARGET`):**

Repeat the identical logic for `$TARGET/.agents/commands/{name}`.

**If neither `.claude/` nor `.agents/` exists in `$TARGET`:**

Print:
> Warning: neither `.claude/` nor `.agents/` found in `{target}`.
> Command symlinks were not created.
> Create either directory and re-run `/install kanban {target}` to link them.

---

## Phase 3 — Report

Print a consolidated summary:

```
Command symlinks (.claude/commands/):
  ✓ ideation  → {relative-path}
  ✓ implement → {relative-path}

Command symlinks (.agents/commands/):    [if .agents/ exists]
  ✓ ideation  → {relative-path}
  ✓ implement → {relative-path}
```

List any warnings (skipped symlinks, missing `.claude/`/`.agents/`) beneath the
summary. Suggest running `/ideate` to start the first subject.
