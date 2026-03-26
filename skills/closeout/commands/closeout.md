---
allowed-tools: Read, Glob, Grep, Bash, Write, Edit
argument-hint: ""
---

<!-- ORCHESTRATOR: This skill closes the session cleanly. It writes notes and findings to
     non-instruction project files (research logs, FUTURE.md) or to the memory directory.
     It does NOT touch instruction files (AGENTS.md, SKILL.md, commands/, CLAUDE.md) — those
     are modified through deliberate implementation workflows, not session cleanup. It then
     stages and commits all uncommitted changes. -->

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

Closeout does **not** write to instruction files (`AGENTS.md`, `SKILL.md`, `commands/`, `CLAUDE.md`). Modifying those is a deliberate implementation act that belongs in a proper workflow, not in session cleanup.

For each candidate, pick the first destination that fits:

1. **Non-instruction project file** — for notes, findings, or forward-looking content that belongs near a specific skill but must not influence agent behaviour yet:
   - A skill's `research-log-*.md` — exploration findings, candidate approaches
   - A skill's `FUTURE.md` (create if absent) — deferred plans, open questions, ideas worth revisiting

2. **Memory file** — for content with no natural project file home: user profile information, cross-project feedback, references to external systems, or project-state facts.

For each candidate, record:
- The destination file (path, or memory type + proposed filename)
- Whether it should create a new entry or update an existing one
- A one-line reason why it's worth saving

If the candidate list is empty, record that explicitly and skip Phase 2.

---

## Phase 2 — Writes (Scribe)

*Scribe is active. Write precisely — these files carry context into future sessions.*

Work through the candidate list from Phase 1.

### 2a — Non-instruction project file writes

For each candidate routed to a `research-log-*.md` or `FUTURE.md`:

1. If the file exists, read it first, then append or integrate the new content.
2. If creating `FUTURE.md`, open with a brief heading and a one-line purpose note.
3. Keep entries dated (`YYYY-MM-DD`) so they are easy to age out later.

### 2b — Memory file writes

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

If the output is empty, skip to Phase 4 and note "Working tree already clean."

Check for secret/credential files before proceeding (`.env`, `credentials.*`, `*.key`, `*.pem`). If any are present among the changes, stop and warn the user — do not commit.

**Step 2 — Assess the state of the changes:**

Run `git diff HEAD` and read the diff carefully. Classify the working tree as one of two states:

**Dirty / WIP** — the work is clearly unfinished. Signs include:
- Partially implemented features (stubs, TODOs, missing wiring)
- Broken or inconsistent state across related files
- Changes that make no coherent sense without further work
- Mix of unrelated half-done things

**Clean-ish / done** — the changes are coherent and complete enough to stand on their own. Signs include:
- Each touched area forms a logical, self-contained unit
- No obvious holes or placeholders
- Changes could be understood by a future agent without additional context

---

### If dirty / WIP → single WIP commit

Stage everything and make one commit with a `wip:` prefix. The commit body must include a handoff note so the next agent knows to reset before building on it.

```zsh
git add -A
git commit -m "$(cat <<'EOF'
wip(<scope>): <brief description of what is in progress>

Work in progress — not complete. The next agent working in this area
should run `git reset HEAD~1` to unstage these changes before making
their own commits.

State of play:
- <area>: <what was done / what remains>
- <area>: <what was done / what remains>

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
EOF
)"
```

---

### If clean-ish / done → logical group commits

Do not lump everything into one commit. Group the changes into small, related sets and commit them separately in a sensible order (dependencies first, then dependents; foundational changes before surface changes).

For each group:

1. Stage only the files in that group: `git add <file> <file> ...`
2. Compose a conventional commit message:
   - Subject: `<type>(<scope>): <description>` — under 72 characters
   - Body: describe what changed and why; mention any non-obvious side effects
3. Commit using a HEREDOC:

```zsh
git commit -m "$(cat <<'EOF'
<type>(<scope>): <subject>

<body>

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
EOF
)"
```

Repeat for each group. Common `type` values: `feat`, `fix`, `refactor`, `docs`, `chore`.

---

**Step 3 — Verify:**

Run `git status --short`. If the output is empty, the tree is clean. If anything remains, report it and explain why it was not committed (e.g. untracked build artefacts, intentionally excluded files).

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
- <WIP commit / N logical commits / Already clean>
  - `<subject line>` _(wip / type)_
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
