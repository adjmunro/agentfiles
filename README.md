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
├── scripts/          # Reusable shell scripts installed to ~/.local/bin/
└── skills/           # Self-contained skills — each has AGENTS.md, CHANGELOG.md, VERSION.md
    ├── british-english/
    ├── ideation/
    ├── implement/
    ├── optimise/
    ├── personas/
    └── summary/
```

## Getting Started

### Bootstrap a new project

From any git repository, run:

```zsh
zsh <(curl -sSL https://raw.githubusercontent.com/adjmunro/agentfiles/main/scripts/bootstrap.sh)
```

This downloads the `/install` skill into `.agents/skills/install/` (or `.claude/skills/install/`). Then run `/install all` for standard setup, or pick components individually:

```
/install kanban
/install symlinks
/install bash-guard
/install readme-hook
/install title-hook
/install sign-hook
/install british-english-hook
/install gradle-idea
```

### Cold-start agent prompt

No curl access? Paste this into any agent:

```
Fetch https://raw.githubusercontent.com/adjmunro/agentfiles/main/scripts/bootstrap.sh
and execute it in the current directory to install the /install skill.

Then inspect the project and run /install for each appropriate component:
- kanban, symlinks, bash-guard, readme-hook, title-hook, sign-hook,
  british-english-hook — suitable for most projects
- gradle-idea — only if a root build.gradle or build.gradle.kts exists
Skip any component that does not make sense for this project's stack.
```

---

## Skills

### `/install`

Bootstraps any git repository with agentfiles components. Run `/install all` to
apply the full standard setup, or pick components individually.

| Component | What it installs |
|-----------|-----------------|
| `kanban` | `.kanban/` directory scaffold (01-plan through 06-archive) and command symlinks |
| `sign-hook` | Batch commit-signing pre-push hook |
| `british-english-hook` | Pre-commit British English enforcement (perl, portable) |
| `symlinks` | AGENTS.md/CLAUDE.md/GEMINI.md unification, skills/hooks dir migration, worktrees |
| `gradle-idea` | Gradle IDEA plugin with `.worktrees` exclusion |
| `bash-guard` | Pre-tool-use hook blocking redundant Bash calls (cat/grep/find/ls) |
| `readme-hook` | Post-commit hook reminding the agent to update README.md on structural changes |
| `title-hook` | Terminal title hook — sets window title from repo/branch/PR context |

### `/implement`

Subject-centric implementation skill. Organises work under `YYYY-MM-DD-{subject}/` directories with internal stage folders. Picks up tickets from `04-todo/` and routes them through implementation, review, PR, and archive.

**Commands:** `work`, `review`, `pr`, `cleanup`, `next`

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
| Sable (Interrogator) | Demand validation — should this be built at all? |
| Trace (Debugger) | Systematic root-cause isolation |
| Vault (Architect) | Pre-implementation architecture lock-in and failure-mode naming |
| Lens (Verifier) | Live application testing and severity classification |

**Commands:** `evolve`, `summon`

### `/summary`

Produces a structured briefing of git changes — what changed, why, and how to use new or updated features. Useful for resuming interrupted sessions, reviewing branches before raising a PR, and understanding what evolved since the last trunk sync.

- `/summary` — changes since the branch parent (default)
- `/summary pr` — same scope, framed for PR review
- `/summary trunk` — since divergence from `main`
- `/summary <ref>` — since a specific git ref or commit SHA

### `/british-english`

Converts all human-readable prose in a target file or directory tree to Oxford British English. Leaves code, identifiers, CLI flags, and fenced/inline code blocks untouched.

**Usage:** `/british-english <path> [--dry-run]`

## Root Commands

Standalone command files that work without a skill context:

| Command | Purpose |
|---------|---------|
| `/init` | Create a new `.kanban/YYYY-MM-DD-{subject}/` directory with all stage folders |
| `/interview` | Interview the user to expand a rough spec into a detailed one |
| `/implement` | Implement a spec or ticket and commit often |
| `/next` | Identify the next PRD to implement, audit it, and loop through review until it passes |
| `/review` | Audit implemented code against a PRD to confirm all requirements are satisfied |
| `/audit` | Audit any target, emphasising preservation of intent and reasoning |
| `/install-sign-hook` | Install the batch commit-signing pre-push hook into any git repo |

## Scripts

Reusable shell scripts that live in `scripts/` and are installed to `~/.local/bin/` by their corresponding agent commands.

| Script | Installed as | Purpose |
|--------|--------------|---------|
| `scripts/sign-branch.sh` | `git-sign-branch` | Batch-sign unsigned commits on the current branch before push |

### `git-sign-branch`

Signs all unsigned commits authored by the current git user since the most recent commit they authored that already carries a GPG signature. Falls back to the remote tracking branch merge-base if no prior signed commit exists. Commits by other authors are left untouched.

Install into any repo with `/install-sign-hook`. Once installed, `git push` automatically signs pending commits — no extra steps needed.

## Hooks

| File | Trigger | Purpose |
|------|---------|---------|
| `hooks/pre-bash.sh` | `PreToolUse: Bash` | Blocks redundant Bash calls and redirects to dedicated tools (Read, Grep, Glob) |
| `hooks/title-update.sh` | `SessionStart`, `UserPromptSubmit` | Updates the session title in the status line |
| `hooks/readme-check.sh` | `PostToolUse: Bash` | Reminds the agent to update README.md when structural changes are committed |

## Testing

Each skill has a `TESTING.md` that records test strategy, scenarios, known issues, and a refinement log. Run a scenario, update the Status column, and append to Known Issues or Refinement Log as you go. The personas skill uses a single shared `TESTING.md` with one section per persona.

| Skill | Testing doc |
|-------|------------|
| british-english | `skills/british-english/TESTING.md` |
| ideation | `skills/ideation/TESTING.md` |
| implement | `skills/implement/TESTING.md` |
| optimise | `skills/optimise/TESTING.md` |
| personas | `skills/personas/TESTING.md` |
| summary | `skills/summary/TESTING.md` |

## Inspiration Resources

See [`resources.md`](resources.md) for a curated list of external repositories, frameworks, and documentation to reach for when seeking inspiration for skill design, persona systems, and agent workflow patterns.

## License

MIT
