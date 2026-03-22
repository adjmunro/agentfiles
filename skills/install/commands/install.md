---
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
argument-hint: "<component> [target-path]"
---

# Install — Dispatcher

Installs a named component from the agentfiles repository into a target project.

## Available Components

| Component | Description |
|-----------|-------------|
| `kanban` | `.kanban/` directory scaffold and command symlinks for ideation and implement |
| `sign-hook` | Batch commit-signing pre-push hook |
| `british-english-hook` | Pre-commit British English enforcement hook |
| `symlinks` | Agent-agnostic AGENTS.md, skills/hooks directory migration, worktrees |
| `gradle-idea` | Gradle idea plugin, `.gitignore` entry, worktrees directory |

## DO

- Resolve the agentfiles root as the repository containing this command file
  (this file is at `skills/install/commands/install.md`, so the root is three levels up)
- Resolve the target path from `$ARGUMENTS` (second token), defaulting to cwd if absent
- Verify the target is a git repository before touching anything
- Delegate all logic to the component file — do not inline component steps here

## DO NOT

- Run more than one component per invocation
- Modify any file outside the target repository (except `~/.local/bin/` for sign-hook)
- Proceed if the target path does not exist or is not a git repository
- Duplicate logic from `commands/install-sign-hook.md` — reference it instead

---

## Phase 1 — Resolve Arguments

Parse `$ARGUMENTS`:
- First token: component name (required)
- Remaining tokens: target path (optional, defaults to current working directory)

**Valid component names:** `kanban`, `sign-hook`, `british-english-hook`, `symlinks`, `gradle-idea`

If no arguments are given, print the component table above and stop.

If the component name is not in the list above, print:

> Unknown component: `{name}`
> Valid components: kanban, sign-hook, british-english-hook, symlinks, gradle-idea

Stop without touching any files.

**Resolve the agentfiles root:**

This command file lives at `skills/install/commands/install.md` within the agentfiles
repo. Navigate three parent directories up from this file's location to find the
agentfiles root. Store this absolute path as `$AGENTFILES_ROOT`.

**Resolve the target path:**

- If provided: expand any `~` and resolve to an absolute path
- If not provided: use the current working directory
- Verify the path exists; if not, stop and print:
  > Target path not found: `{path}`

Verify the target is a git repository:
- Run: `git -C "{target}" rev-parse --git-dir`
- If this fails, stop and print:
  > `{path}` is not a git repository. Initialise git first (`git init`).

Store resolved values: `$COMPONENT`, `$TARGET`, `$AGENTFILES_ROOT`

---

## Phase 2 — Dispatch

Read the file at:

```
$AGENTFILES_ROOT/skills/install/commands/components/$COMPONENT.md
```

Execute the instructions in that file. The variables `$COMPONENT`, `$TARGET`, and
`$AGENTFILES_ROOT` are in scope for the component.

---

## Phase 3 — Final Report

After the component completes, print a one-line summary:

```
✓ install/{component} complete — {target}
```

If the component reported any warnings, list them beneath the summary.
