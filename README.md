# agentfiles

Agent instructions, skills, and commands for agentic coding workflows. Works with Claude Code, Gemini CLI, and any agent that reads markdown from a repo root.

## Structure

```
agentfiles/
├── AGENTS.md         # Repo-wide agent instructions (conventional commits, no force push)
├── CLAUDE.md         # → AGENTS.md (symlink)
├── GEMINI.md         # → AGENTS.md (symlink)
├── commands/         # Standalone agent command files
├── hooks/            # Shell hooks for agent tooling
└── skills/
    └── kanban/       # Full kanban workflow skill
```

## Skills

### kanban

A complete ticket-driven development workflow — from raw idea to merged PR — powered by agent commands.

**Commands:** `init`, `capture`, `plan`, `todo`, `work`, `review`, `pr`, `cleanup`, `next`

See [`skills/kanban/SKILL.md`](skills/kanban/SKILL.md) for full documentation.

## License

MIT
