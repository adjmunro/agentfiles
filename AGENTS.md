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
├── commands/     # Legacy standalone command files — pending migration to skills/prompts
└── docs/
```

Every component directory under `skills/`, `hooks/`, and `prompts/` is self-contained:

```
<type>/<name>/
├── SKILL.md / HOOK.md / PROMPT.md   # entry point loaded by the agent
├── VERSION.md                        # plain semver only — see spec below
├── CHANGELOG.md                      # newest-to-oldest, dated, named entries
├── AGENTS.md                         # development conventions for this component
└── commands/ / scripts/ / ...        # supporting files (skills and hooks only)
```

### Symlinks (internal use)

`.claude/` and `.agents/` within this repo are **not** canonical — they are symlink bridges so Claude Code can discover components locally during development:

```
.agents/skills/   →  ../skills/
.agents/hooks/    →  ../hooks/
.claude/skills/   →  ../.agents/skills/
.claude/hooks/    →  ../.agents/hooks/
```

Do not add canonical content under `.claude/` or `.agents/`. Edits always go in the top-level type directory.

When `agentfiles install` adds a component to a target project, it writes to `.agents/<type>/<name>/` and creates `.claude/<type>/` → `../.agents/<type>/` if `.claude/` exists and the symlink is missing.

### Routing — what goes where

| It is… | Put it in… | Installed to… |
|---|---|---|
| A multi-step workflow the agent runs repeatedly as a slash command | `skills/` | `.agents/skills/<name>/` |
| A shell hook that fires automatically on agent events | `hooks/` | `.agents/hooks/<name>/` |
| A one-shot instruction run once to set something up or change the project | `prompts/` | `.agents/prompts/<name>/` |
| A shell utility or CLI tool | `scripts/` | `~/.local/bin/` |
| A legacy standalone command file | `commands/` | — migrate to skill or prompt |

**Rule of thumb:** if a human invokes it repeatedly as a slash command → skill. If it fires automatically on an agent event → hook. If it reads local context and applies a one-time change → prompt.

> **Note on "commands":** Claude Code's slash command and hook *platform features* are not deprecated. The agentfiles `commands/` *directory* is a legacy format predating the skill structure — its files are pending migration.

### VERSION.md specification

`VERSION.md` contains **plain semver only** — nothing else:

```
1.2.3
```

Do not add instructions, upstream URLs, "Current version:" prefixes, or agent guidance. Those belonged to an earlier pattern where agents read version files directly. AGENTS.md is now the authoritative source of versioning conventions.

### CHANGELOG.md specification

Every version entry must follow this format exactly:

```markdown
## X.Y.Z — Name (YYYY-MM-DD)

One or two sentences describing what changed and why it matters to the user.

- Specific bullet point
- Another bullet point
```

Rules:
- **Newest first** — latest version at the top of the file.
- **Named releases** — every version gets a short, memorable name (2–4 words).
- **Dated** — `(YYYY-MM-DD)` at the end of the header, not standalone.
- **No subsections** — do not use `### Added`, `### Changed`, `### Fixed` headers; bullets are sufficient.
- **Brief** — one paragraph plus a few bullets maximum per entry.

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
