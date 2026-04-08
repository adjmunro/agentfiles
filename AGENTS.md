# agentfiles

Agent instructions and skills for agentic coding workflows.

## Git Commits

Use **conventional commits** for all changes:

```
feat(scope): short description
fix(scope): short description
refactor(scope): short description
docs(scope): short description
chore(scope): short description
```

The commit body should be generated — describe what changed, why, and any non-obvious side effects. Keep the subject line under 72 characters.

Common scopes: `scripts`, `hooks`, `skills`, `prompts`, `config`

Examples:
- `feat(implement): add pr command with GitHub and manual fallback paths`
- `fix(hooks): correct bash-guard pattern for zsh process substitution`
- `chore(config): update AGENTS.md symlinks at repo root`

**Never force push.** This is a hard rule with no exceptions.

## Repository Structure

```
agentfiles/
├── skills/       # Multi-step agentic workflows (versioned directories)
├── hooks/        # Shell hooks for agent tooling (versioned directories)
├── prompts/      # One-shot agent instructions (versioned directories)
├── scripts/      # Shell utilities and the agentfiles CLI
├── commands/     # [deprecated] superseded by skills/
└── docs/
```

Every component directory under `skills/`, `hooks/`, and `prompts/` is self-contained:

```
<type>/<name>/
├── SKILL.md / HOOK.md / PROMPT.md   # entry point loaded by the agent
├── VERSION.md                        # semver — bump when the component changes
├── CHANGELOG.md                      # newest-to-oldest, dated, named entries
├── AGENTS.md                         # development conventions for this component
└── commands/ / scripts/ / ...        # supporting files (skills and hooks only)
```

### Symlinks (internal use)

`.claude/` and `.agents/` within this repo are **not** canonical — they are symlink bridges so Claude Code can discover components locally during development:

```
.claude/commands/<name>.md  →  ../../skills/<name>/SKILL.md    (or similar)
.claude/hooks/<name>.sh     →  ../../hooks/<name>/hook.sh
```

Do not add canonical content under `.claude/` or `.agents/`. Edits always go in the top-level type directory.

### Routing — what goes where

| It is… | Put it in… | Installed to… |
|---|---|---|
| A multi-step workflow the agent runs repeatedly | `skills/` | `<skills_dir>/<name>/` |
| A shell hook that fires on agent events | `hooks/` | `.claude/hooks/<name>/` |
| A one-shot instruction the agent runs once to set something up | `prompts/` | `.claude/prompts/<name>/` |
| A shell utility or CLI tool | `scripts/` | `~/.local/bin/` or project scripts dir |
| ~~A standalone command file~~ | ~~`commands/`~~ | ~~deprecated~~ |

**Rule of thumb:** if a human would invoke it repeatedly as a slash command, it's a skill. If it fires automatically in response to an agent event, it's a hook. If it's a one-time environment setup or project change that reads local context to decide what to do, it's a prompt.

## Language & Spelling

- **Documentation, comments, and all prose** (markdown files, AGENTS.md, SKILL.md, CHANGELOG.md, commit messages, inline comments): use **Oxford British English**.
  - -ise endings: organise, optimise, customise, normalise, recognise, etc.
  - British spellings: colour, behaviour, favour, honour, centre, analyse, catalogue, etc.
  - Oxford comma: use a serial comma before the final item in a list of three or more.
- **Code** (variable names, function names, identifiers, string literals, CLI flags, file paths that are part of a codebase): use **American English**, as most tooling, libraries, and APIs use American conventions.
- When in doubt: if it will be read by a human, British English. If it will be executed by a machine, American English.

## Agent Compatibility

- Write instructions in generalised language — no tool-specific API names in command files.
- Each command file should work as a standalone prompt if pasted into a basic chat interface.
- Hint at advanced features (subagents, parallel execution) but don't require them.
