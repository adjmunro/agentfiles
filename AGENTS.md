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

Common scopes: `implement`, `commands`, `hooks`, `skills`, `config`

Examples:
- `feat(implement): add pr command with GitHub and manual fallback paths`
- `fix(commands): correct audit.md status field reference`
- `chore(config): update AGENTS.md symlinks at repo root`

**Never force push.** This is a hard rule with no exceptions.

## Repository Structure

```
agentfiles/
├── commands/         # Standalone agent command files
├── hooks/            # Shell hooks for agent tooling
└── skills/
    └── implement/    # The implement skill — subject-centric pipeline from capture to archive
```

Each skill under `skills/` is self-contained: it has its own `AGENTS.md`, `CHANGELOG.md`, `VERSION.md`, and a `commands/` subdirectory with the actual skill logic.

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
