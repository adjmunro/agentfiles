---
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
argument-hint: "<component>"
---

# Install — Dispatcher

Installs a named component into the current working directory (which must be a git repository).

## Available Components

| Component | Description |
|-----------|-------------|
| `kanban` | `.kanban/` directory scaffold and command symlinks for ideation and implement |
| `sign-hook` | Batch commit-signing pre-push hook |
| `british-english-hook` | Pre-commit British English enforcement hook |
| `symlinks` | Agent-agnostic AGENTS.md, skills/hooks directory migration, worktrees |
| `gradle-idea` | Gradle idea plugin, `.gitignore` entry, worktrees directory |
| `bash-guard` | Pre-tool-use hook blocking redundant Bash calls |
| `readme-hook` | Post-tool-use hook prompting README updates on structural changes |
| `title-hook` | Session and prompt hooks setting the terminal title from git context |
| `all` | Runs: kanban, symlinks, sign-hook, british-english-hook, bash-guard, readme-hook, title-hook |

## DO

- Use the current working directory as the target — never ask for a path
- Verify the current directory is a git repository before touching anything
- Resolve `$AGENTFILES_PATH` once and pass it to components that need it
- For `all`: run each component in sequence, continuing even if one warns

## DO NOT

- Modify any file outside the current repository (except `~/.local/bin/` for sign-hook)
- Proceed if the current directory is not a git repository

---

## Phase 1 — Parse Arguments

Read `$ARGUMENTS`:
- If empty: print the component table above and stop.
- First token: component name.

**Valid component names:** `kanban`, `sign-hook`, `british-english-hook`, `symlinks`,
`gradle-idea`, `bash-guard`, `readme-hook`, `title-hook`, `all`

If the name is not in the list, print:
> Unknown component: `{name}`
> Valid components: kanban, sign-hook, british-english-hook, symlinks, gradle-idea, bash-guard, readme-hook, title-hook, all

Stop without touching any files.

---

## Phase 2 — Verify Repository

Run: `git rev-parse --git-dir`

If this fails, stop and print:
> Not a git repository. Initialise git first (`git init`).

---

## Phase 3 — Resolve Agentfiles Source

Two components (`kanban` command symlinks, `sign-hook`) need to read files from
agentfiles. Resolve the source once here and pass it to those components.

Set `$AGENTFILES_PATH` if the environment variable is set and the path exists locally.

If `$AGENTFILES_PATH` is not set or the path does not exist:
- Set `$AGENTFILES_URL=https://raw.githubusercontent.com/adjmunro/agentfiles/main`
- Components that need remote files will fetch via WebFetch from this URL
- Components that do not need agentfiles source are unaffected either way

---

## Phase 4 — Dispatch

**Single component:** Read the file at `skills/install/commands/components/{component}.md`
(relative to `$AGENTFILES_PATH`) and execute it.

**`all`:** Execute each component in this order, reading and running each component file:
1. `kanban`
2. `symlinks`
3. `sign-hook`
4. `british-english-hook`
5. `bash-guard`
6. `readme-hook`
7. `title-hook`

Between each component, print a divider:
```
─────────────────────────────────────
```

---

## Phase 5 — Final Report

After all components complete, print:

```
✓ install/{component} complete
```

For `all`, print a summary line for each component with ✓ or ⚠ for warnings.
