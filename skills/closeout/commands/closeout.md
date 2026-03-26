---
allowed-tools: Read, Glob, Grep, Bash, Write, Edit
argument-hint: ""
---

<!-- ORCHESTRATOR: This skill closes the session cleanly. It writes to the memory directory
     and stages/commits changes. It must not modify source files beyond what is needed to save
     memory entries and commit existing work. -->

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

**Step 1 — Load existing memory:**

Read `MEMORY.md` to know what is already captured. Note the file names and descriptions so you do not duplicate them.

**Step 2 — Review the conversation:**

Scan the full conversation history (everything above this prompt) for content that belongs in persistent memory but is not yet captured. Apply the following filter — only save content that meets at least one criterion:

| Criterion | Memory type |
|-----------|-------------|
| Something learned about the user's role, expertise, or preferences | `user` |
| A correction the user made to your approach, or a confirmed non-obvious choice | `feedback` |
| A decision, goal, deadline, or rationale about ongoing project work | `project` |
| A pointer to an external resource and what it's for | `reference` |

**Do not save:**

- Code patterns derivable by reading the codebase
- Git history or who changed what
- Debugging solutions already in the code
- Anything in CLAUDE.md
- Ephemeral task details from this session only
- The existence of this closeout skill (it's in the codebase)

**Step 3 — Build a candidate list:**

For each candidate entry, note:
- The memory type
- A proposed file name (e.g. `feedback_commit_style.md`)
- Whether it should update an existing file or create a new one
- A one-line summary of why it's worth saving

If the candidate list is empty, record that explicitly and skip Phase 2.

---

## Phase 2 — Memory Writes (Scribe)

*Scribe is active. Write precisely — memory files are read in future conversations.*

For each candidate from Phase 1:

**If creating a new file:**

1. Write the file to the memory directory using the frontmatter format above.
2. Add a row to `MEMORY.md` in the table: `| [filename.md](filename.md) | type | one-line description |`

**If updating an existing file:**

1. Read the existing file first.
2. Edit it to incorporate the new information. Do not erase old content unless it is directly contradicted.
3. Update the description in `MEMORY.md` if the scope has changed.

Keep entries concise. A memory file should be skimmable in under 30 seconds.

After writing, re-read `MEMORY.md` and verify:
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

### Memory
- <Saved / Updated / No new entries>
  - [filename.md] — <one-line description of what was saved>

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
