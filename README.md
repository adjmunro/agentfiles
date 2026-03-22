# agentfiles

Agent instructions, skills, and commands for agentic coding workflows. Works with Claude Code, Gemini CLI, and any agent that reads markdown from a repo root.

## Structure

```
agentfiles/
├── AGENTS.md         # Repo-wide agent instructions (conventional commits, no force push)
├── CLAUDE.md         # → AGENTS.md (symlink)
├── GEMINI.md         # → AGENTS.md (symlink)
├── resources.md      # Curated external repos and tools for inspiration
├── commands/         # Standalone agent command files (root-level, not skill-scoped)
├── hooks/            # Shell hooks for agent tooling
└── skills/           # Self-contained skills — each has AGENTS.md, CHANGELOG.md, VERSION.md
    ├── british-english/
    ├── ideation/
    ├── kanban/
    ├── kanban2/
    ├── optimise/
    └── personas/
```

## Skills

### `/kanban`

A folder-based, ticket-driven development workflow. Moves work through a defined pipeline — capture raw intent, plan it, break it into tickets, implement, review, raise a PR, then archive. The folder is the status; every decision traces back to the original capture.

**Commands:** `init`, `capture`, `plan`, `todo`, `work`, `review`, `pr`, `cleanup`, `next`

### `/kanban` (kanban2)

Subject-centric variant of kanban. Organises work under `YYYY-MM-DD-{subject}/` directories with internal stage folders. Designed for parallel work on multiple subjects with cleaner separation.

**Commands:** `init`, `work`, `review`, `pr`, `cleanup`, `next`

### `/ideate`

Collapses five traditionally separate phases — capture, research, interview, plan, and ticket creation — into one seamless loop. Conducts intelligent research first, asks targeted questions informed by what already exists, builds a plan collaboratively, and exits with a ready-to-work kanban backlog.

**Nine-step flow:** capture → research → interview → plan → tickets

### `/optimise`

A scientific-method optimisation loop for workflow directories. Point it at any folder of agent instructions, command files, or documentation and it will: measure what's wrong, form evidence-based hypotheses, apply changes, re-measure, and write a full report. Supports loop modes:

- `/optimise 5 <path>` — run 5 full iterations
- `/optimise auto <path>` — loop until composite score exceeds 95%
- `/optimise <path>` — single run

**Five phases:** audit → baseline → hypothesise → experiment → report

### `/personas`

A shared library of agent personas used across skills. Each persona has a `persona.md` (role, lens, DO/DO NOT, failure mode) and a `soul.md` (essence, values, opinions, contradictions, voice, unique talent).

| Persona | Role |
|---------|------|
| Vela (Scribe) | Verbatim transcription and documentation |
| Arden (Critic) | Gap-finding and audit gates |
| Finn (Scout) | Codebase research and mapping |
| Kira (Builder) | Ticket implementation |
| Echo (Examiner) | Evidence gathering |
| Vale (Advocate) | PR defence |
| Keeper (Strategist) | Strategic reframing and planning |
| Artisan (Designer) | Visual and UX quality |
| Helm (Release) | Final-mile shipping |
| Ward (Documentation) | Doc accuracy |
| Pulse (Analytics) | Metrics and retrospectives |
| Rook (Adversary) | Red-team stress-testing |
| Loom (Synthesis) | Pattern recognition across disparate sources |
| Arc (Temporal) | Temporal reasoning and sequencing |

**Commands:** `evolve`, `summon`

### `/british-english`

Converts all human-readable prose in a target file or directory tree to Oxford British English. Leaves code, identifiers, CLI flags, and fenced/inline code blocks untouched.

**Usage:** `/british-english <path> [--dry-run]`

## Root Commands

Standalone command files that work without a skill context:

| Command | Purpose |
|---------|---------|
| `/interview` | Interview the user to expand a rough spec into a detailed one |
| `/implement` | Implement a spec or ticket and commit often |
| `/next` | Identify the next PRD to implement, audit it, and loop through review until it passes |
| `/review` | Audit implemented code against a PRD to confirm all requirements are satisfied |
| `/audit` | Audit any target, emphasising preservation of intent and reasoning |

## Hooks

| File | Trigger | Purpose |
|------|---------|---------|
| `hooks/pre-bash.sh` | `PreToolUse: Bash` | Blocks redundant Bash calls and redirects to dedicated tools (Read, Grep, Glob) |
| `hooks/title-update.sh` | `SessionStart`, `UserPromptSubmit` | Updates the session title in the status line |
| `hooks/readme-check.sh` | `PostToolUse: Bash` | Reminds the agent to update README.md when structural changes are committed |

## Inspiration Resources

See [`resources.md`](resources.md) for a curated list of external repositories, frameworks, and documentation to reach for when seeking inspiration for skill design, persona systems, and agent workflow patterns.

## License

MIT
