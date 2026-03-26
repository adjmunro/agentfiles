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

- `../../personas/synthesis/persona.md` — **Loom (Synthesist)** — active in Phase 1 (scanning conversation across source domains: prior memory, project files, conversation history; synthesising what is worth saving)
- `../../personas/documentation/persona.md` — **Ward (Documentation)** — active in Phase 2 (writing entries for the next agent who has no session context; write for the reader, not the writer)
- `../../personas/release/persona.md` — **Helm (Release)** — active in Phase 3 (git cleanup; care before committing)

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

## Phase 1 — Conversation Audit (Loom)

*Loom (Synthesist) is active. Identify your source domains first: (1) the current conversation, (2) existing memory files, (3) relevant project files. Synthesise across all three before forming any candidates.*

**Step 1 — Load existing context:**

Read `MEMORY.md` from the memory directory to know what is already captured. Also note which project files exist that might be relevant destinations (CLAUDE.md, skill AGENTS.md files, README, etc.).

**Step 2 — Review the conversation:**

Scan the full conversation history (everything above this prompt) for content worth persisting. For each candidate, apply this three-gate test — save only if all three pass:

1. **Future value:** Would this help a future agent who has not read this conversation?
2. **Not derivable:** Can it _not_ be derived by reading the current file state or git history?
3. **Not ephemeral:** Is it relevant beyond this session only?

If gate 1=yes, gate 2=no (not derivable), gate 3=no (not ephemeral) → **save.**
If any gate fails → **do not save.**

Then classify what passes all three gates against these types:

| Criterion | Nature |
|-----------|--------|
| A convention, rule, or pattern that governs how this project works | Project file candidate |
| A decision, rationale, or constraint about a specific skill or command | Skill file candidate |
| A correction the user made to your approach, or a confirmed non-obvious choice | Feedback |
| Something learned about the user's role, expertise, or preferences | User |
| A decision, goal, or deadline about ongoing project work | Project |
| A pointer to an external resource and what it's for | Reference |

**Do not save** (gate 2 or 3 failures):

- Code patterns derivable by reading the codebase (gate 2 fails)
- Git history or who changed what (gate 2 fails)
- Debugging solutions already in the code (gate 2 fails)
- Ephemeral task details from this session only (gate 3 fails)
- Anything already captured in the files you've read (gate 1 fails)

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

**Step 4 — Write the candidate list as a carry-forward anchor:**

Before proceeding to Phase 2, write the candidate list out explicitly in this format — do not carry it only in working memory:

```
## Closeout Candidates — <date>
| Destination path | Action | Type | Reason |
|-----------------|--------|------|--------|
| skills/closeout/FUTURE.md | create | project | ... |
| memory/feedback_foo.md | create | feedback | ... |
```

If there are no candidates, write: "No candidates identified — skip Phase 2."

---

## Phase 2 — Writes (Ward)

*Ward (Documentation) is active. Write for the next agent, not for yourself — assume they have no session context and no memory of this conversation. Every entry should be self-contained.*

Re-read the candidate list you wrote at the end of Phase 1. Work through it row by row — do not rely on what you recall from Phase 1.

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

**Transition note — before Phase 3:** Write a one-line summary of what Phase 2 produced, e.g.:
`Phase 2 complete: wrote skills/closeout/FUTURE.md (new), updated memory/feedback_foo.md.`
If nothing was written: `Phase 2 complete: no writes (candidate list was empty).`

---

## Phase 3 — Git Cleanup (Helm)

*Helm (Release) is active. Leave the repository in a clean state. In this phase, Helm's role is WIP assessment and conventional commit authoring — skip checklist items about test coverage, CI, and PR creation.*

**Step 1 — Check git status:**

Run: `git status --short`

If the output is empty, skip to Phase 4 and note "Working tree already clean."

Check for secret/credential files before proceeding (`.env`, `credentials.*`, `*.key`, `*.pem`). If any are present among the changes, stop and warn the user — do not commit.

**Step 2 — Assess the state of the changes:**

Run `git diff HEAD` and read the diff carefully. Classify the working tree as one of two states:

Apply these gates in order — stop at the first that applies:

1. **Automatic WIP** if any of the following are true (check via `git grep -n "TODO\|FIXME" $(git diff --name-only HEAD)`):
   - Any changed file contains a TODO or FIXME marker
   - Any changed file shows more deletions than additions (indicates mid-restructure)
   - Any changed file is a stub or scaffold with no implementation body

2. **Dirty / WIP** — if gate 1 does not apply but the work looks clearly unfinished:
   - Partially implemented features without obvious next commits
   - Broken or inconsistent state across related files
   - Mix of unrelated half-done things

3. **Clean-ish / done** — only if the above gates both clearly do not apply:
   - Each touched area forms a logical, self-contained unit
   - No obvious holes or placeholders
   - Changes could be understood by a future agent without additional context

> **Default:** If you are uncertain which applies, default to **WIP**. A cautious WIP commit does less damage than a premature clean-ish split.

---

### If dirty / WIP → single WIP commit + RESUME.md

**Step A — Write a RESUME.md handoff file.**

A single `RESUME.md` in the repo root would be clobbered if two agents close out in parallel. Use a timestamped filename instead:

```
RESUME-<YYYY-MM-DDTHH-MM>.md
```

Write it to the repo root. Content:

```markdown
# Resume — <YYYY-MM-DD HH:MM>

## Branch
<branch name>

## State of play
- <area>: <what was done>
- <area>: <what remains to do>

## Next steps
<Concrete first action the resuming agent should take>

## How to resume
1. Run `git reset --soft HEAD~1` to restore all WIP changes to the working tree (this is a soft reset — your changes are preserved, only the commit is undone).
2. Read this file for context, then delete it.
3. Proceed with your own commits.
```

Add `RESUME-*.md` to `.gitignore` if not already present, so these files do not pollute the repository history. Alternatively, include it in the WIP commit and note that the resuming agent should delete it after reading — choose whichever is more appropriate given the repo's `.gitignore` conventions.

**Step B — Stage everything and commit.**

```zsh
git add -A
git commit -m "$(cat <<'EOF'
wip(<scope>): <brief description of what is in progress>

Work in progress — not complete. To resume:
  git reset --soft HEAD~1   # see RESUME file for full instructions
  cat RESUME-<timestamp>.md  # read the handoff notes, then delete the file

State of play:
- <area>: <what was done / what remains>
- <area>: <what was done / what remains>

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
EOF
)"
```

> **Important:** `git reset --soft HEAD~1` undoes only the commit — all changes come back to the working tree intact. Never use `--hard`, which would permanently discard the changes.

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

Before writing the report, gather from prior phases:
- **Saved:** the Phase 2 transition note (what files were written, if any)
- **Git:** the commit subject line(s) and SHA(s) from Phase 3, and whether WIP or clean-ish
- **Open work:** the kanban findings from Phase 4

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
