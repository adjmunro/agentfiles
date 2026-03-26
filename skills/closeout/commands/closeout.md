---
allowed-tools: Read, Glob, Grep, Bash, Write, Edit
argument-hint: ""
---

<!-- ORCHESTRATOR: This skill closes the session cleanly. It writes insights to the most
     relevant project file first (CLAUDE.md, SKILL.md, AGENTS.md, etc.) and falls back to
     the memory directory only for content with no natural project home. It then stages and
     commits all uncommitted changes. -->

## Personas

Read each file before proceeding.

- `../../personas/scribe/persona.md` — **Scribe** — active in Phase 1 and Phase 2 (identifying and writing memory entries)
- `../../personas/release/persona.md` — **Release** — active in Phase 3 (git cleanup and commit)

---

## Memory directory

The persistent memory directory for this project is:

```
~/.claude/projects/-Users-adjmunro-Developer-agentfiles/memory/
```

The index file is `MEMORY.md` inside that directory. Each memory entry is a separate `.md` file with YAML frontmatter.

Memory file frontmatter format:

```yaml
---
name: short-kebab-name
description: One-line description — used to judge relevance in future conversations
type: user | feedback | project | reference
---
```

For `feedback` and `project` types, structure the body as:

> Rule or fact statement.
>
> **Why:** the reason the user gave or the motivation behind it.
>
> **How to apply:** when and where this kicks in.

`MEMORY.md` is an index only — it contains a markdown table linking to each file with a brief description. Never write memory content directly into `MEMORY.md`.

---

## Phase 1 — Conversation Audit (Scribe)

*Scribe is active. Read before writing.*

**Step 1 — Load existing context:**

Read `MEMORY.md` from the memory directory to know what is already captured. Also note which project files exist that might be relevant destinations (CLAUDE.md, skill AGENTS.md files, README, etc.).

**Step 2 — Review the conversation:**

Scan the full conversation history (everything above this prompt) for content worth persisting. Apply the filter — only save content that meets at least one criterion:

| Criterion | Nature |
|-----------|--------|
| A convention, rule, or pattern that governs how this project works | Project file candidate |
| A decision, rationale, or constraint about a specific skill or command | Skill file candidate |
| A correction the user made to your approach, or a confirmed non-obvious choice | Feedback |
| Something learned about the user's role, expertise, or preferences | User |
| A decision, goal, or deadline about ongoing project work | Project |
| A pointer to an external resource and what it's for | Reference |

**Do not save:**

- Code patterns derivable by reading the codebase
- Git history or who changed what
- Debugging solutions already in the code
- Ephemeral task details from this session only
- Anything that is already captured in the files you've read

**Step 3 — Route each candidate to its destination:**

For each candidate, determine where it belongs using this priority order:

1. **Relevant project file** — if the insight applies to a specific skill, write it into that skill's `AGENTS.md` or `SKILL.md`. If it's a project-wide convention or instruction, write it into `CLAUDE.md`. If there is a clear, natural home in the codebase, prefer it — it will be read by any agent working in that area, not just when memory is loaded.

2. **Memory file (fallback)** — use the memory directory only for content that has no natural project file home: user profile information, cross-project feedback, references to external systems, or project-state facts that do not belong in any instruction file.

For each candidate, record:
- The destination file (path, or memory type + proposed filename)
- Whether it should create a new entry or update an existing one
- A one-line reason why it's worth saving

If the candidate list is empty, record that explicitly and skip Phase 2.

---

## Phase 2 — Writes (Scribe)

*Scribe is active. Write precisely — these files are read in future conversations.*

Work through the candidate list from Phase 1 in routing priority order: project files first, memory as fallback.

### 2a — Project file writes

For each candidate routed to a project file:

1. Read the destination file first.
2. Identify the right location within it (e.g. a relevant section in `AGENTS.md`, or an appropriate heading in `CLAUDE.md`).
3. Edit it to add or update the information. Do not erase existing content unless it is directly contradicted. Preserve the file's existing structure and style.
4. Keep additions concise — a new rule or note should be one to three lines, not a paragraph.

### 2b — Memory file writes (fallback)

For each candidate routed to the memory directory:

**If creating a new file:**

1. Write the file using the frontmatter format defined in the "Memory directory" section above.
2. Add a row to `MEMORY.md`: `| [filename.md](filename.md) | type | one-line description |`

**If updating an existing file:**

1. Read the existing file first.
2. Edit it to incorporate the new information. Do not erase old content unless it is directly contradicted.
3. Update the description in `MEMORY.md` if the scope has changed.

Keep memory entries concise — skimmable in under 30 seconds.

After all writes, re-read `MEMORY.md` and verify:
- All rows in the index point to files that exist
- No duplicate entries
- The table does not exceed 200 rows (truncation point)

---

## Phase 3 — Git Cleanup (Release)

*Release is active. Leave the repository in a clean state.*

**Step 1 — Check git status:**

Run: `git status --short`

If the output is empty (working tree clean), skip to Phase 4 and note "Working tree already clean."

**Step 2 — Inspect what is uncommitted:**

Run: `git diff --stat HEAD` and `git status --short` together to understand the scope.

Categorise the changes into areas (e.g. `skills/closeout`, `memory`, `hooks`, `commands`). This determines the commit scope and message.

**Step 3 — Stage all changes:**

Run: `git add -A`

Do not selectively stage — the goal is a clean working tree. If you notice files that look like secrets or credentials (`.env`, `credentials.*`, `*.key`, `*.pem`), stop and warn the user instead of staging them.

**Step 4 — Compose the commit message:**

Use conventional commits. The scope should reflect the primary area changed:

- Single area: `chore(closeout): session closeout — save memory entries`
- Multiple areas: use the dominant area as scope, mention others in the body

Body format:

```
Committed as part of session closeout.

Areas changed:
- skills/closeout: <brief description>
- memory: <brief description>
- <other area>: <brief description>
```

If there is only one area and the change is self-evident, a body is optional.

**Step 5 — Commit:**

Run the commit. Use a HEREDOC to pass the message cleanly:

```zsh
git commit -m "$(cat <<'EOF'
chore(<scope>): <subject>

<body>

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
EOF
)"
```

**Step 6 — Verify:**

Run `git status --short` again. If the output is empty, the tree is clean. If not, report what remains and why it was not committed (e.g. untracked files that look like build artefacts or secrets).

---

## Phase 4 — Open Work Check

Scan for any active or queued tickets in `.kanban/`:

- `.kanban/*/05-in-progress/` — active
- `.kanban/*/04-todo/` — queued

Read filenames only (not content). If any are found, list them in the output. This is informational only — do not modify kanban state.

If `.kanban/` does not exist or all columns are empty, note: "No open kanban tickets."

---

## Phase 5 — Status Report

Output a brief, structured report:

```
## Closeout — <date>

### Saved
- <Saved / Updated / No new entries>
  - `<file path>` — <one-line description of what was saved> _(project file / memory)_

### Git
- <Committed / Already clean>
  - Commit: `<subject line>` (<SHA, if available>)
  - Or: Working tree was already clean — nothing to commit.

### Open work
- <Ticket list or "No open kanban tickets.">

### Notes
- <Any warnings, skipped items, or things the user should be aware of>
```

Keep the report tight. One line per entry where possible.

---

## Error handling

| Condition | Behaviour |
|-----------|-----------|
| Not inside a git repository | Abort Phase 3 with: "Not a git repository — skipping git cleanup." Continue to Phase 4. |
| Potential secret file detected | Stop Phase 3, warn the user, list the suspicious files. Do not commit. |
| Memory directory does not exist | Warn the user and skip Phase 2. The directory should be at `~/.claude/projects/-Users-adjmunro-Developer-agentfiles/memory/`. |
| `MEMORY.md` index is missing | Create it with a header row only, then proceed. |
| Commit fails (hook or other error) | Report the failure and the hook output. Do not retry. The user should investigate. |
