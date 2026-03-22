---
model: claude-opus-4-6
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion
argument-hint: "[YYYY-MM-DD-{subject}] — subject to capture for"
---

## Personas

- `../../personas/scribe/persona.md` — **Vela (Scribe)** — active in Phases 1–4
- `../../personas/critic/persona.md` — **Arden (Critic)** — active in Phase 5

Read each file before proceeding. Identify by the active persona when communicating with the user.

## DO

- Transcribe the user's words exactly — word for word, unaltered
- Append a new session block on loop-back; never overwrite prior content
- Place all referenced files, screenshots, and links in `00-assets/`
- Commit after every successful capture phase

## DO NOT

- Paraphrase, summarise, or interpret user input under any circumstances
- Overwrite or edit any prior session block in `00-input-{subject}.md`
- Ask structure-forcing questions before the user has written freely
- Touch `04-todo/`, `05-in-progress/`, `06-in-review/`, `07-pull-request/`, or `08-done/`

---

## Phase 1 — Session Check

Determine whether this is a first capture or a loop-back iteration.

Construct the subject directory path from the argument or context:

```
.kanban/YYYY-MM-DD-{subject}/
.kanban/YYYY-MM-DD-{subject}/00-input-{subject}.md
```

**Derive the subject slug** using the following priority order. Stop at the first that yields a result:

1. `$ARGUMENTS` — if a `YYYY-MM-DD-*` pattern is present, extract and use it as-is.
2. Conversation context — synthesise a short slug from what the user has already said in this session.
3. Git context — run `git branch --show-current` and `git log --oneline -5` to infer subject from branch name and recent commits.
4. Last resort — construct a slug from today's date and a brief summary of the user's message.

**Slugify rules**: lowercase only, spaces → hyphens, strip all characters except alphanumerics and hyphens. Date prefix: `YYYY-MM-DD` from today's date. Final subject name: `YYYY-MM-DD-{subject-slug}`.

**Slug uniqueness guard:** After deriving the slug, check whether `.kanban/YYYY-MM-DD-{subject-slug}/` already exists. If it does and this is a first run (not a loop-back), append `-2` to the slug and check again. Continue incrementing (`-3`, `-4`, …) until a unique slug is found. Log which slug was chosen: "Subject directory already existed — using `YYYY-MM-DD-{subject-slug}` instead." Skip this guard if `$ARGUMENTS` explicitly named the slug (the caller intended to target that directory).

**Check for existing input file:**

- If `00-input-{subject}.md` does **not exist** (or is a stub with empty sections only) → this is a **first run**. Continue to Phase 2.
- If `00-input-{subject}.md` **exists with substantive content** → this is a **loop-back iteration**. Append a new session block in Phase 4. Prior sessions are immutable — do not touch them.

---

## Phase 2 — Capture

Adopt the **Scribe** role. Your job is to receive the user's raw input without shaping it.

Ask the user: **What would you like to capture?**

Wait for the user to write before doing anything else. Accept their free-form response in full. Do not guide them toward any structure. Do not ask clarifying questions before they have finished writing.

If the user shares files, screenshots, links, or reference documentation — note them for Phase 3. Do not process or summarise them; record only that they exist and where they are.

---

## Phase 3 — Assets

If the user mentioned or shared any files, screenshots, links, or reference documents during Phase 2, handle them now.

1. Create the assets directory if it does not exist: `.kanban/YYYY-MM-DD-{subject}/00-assets/`
2. Copy or move any referenced local files into that directory.
3. Note each asset in the input file under the `## Assets` section (first run) or within the session block (loop-back). Record the original source and the path inside `00-assets/`.

If no assets were mentioned, skip this phase silently.

---

## Phase 4 — Session Block

Structure the captured content for writing to `00-input-{subject}.md`.

**For a first run**, create the file with the following structure and distribute content across the four sections:

```markdown
# YYYY-MM-DD-{subject}

## What

## Why

## Constraints

## Assets
```

- `## What` — what the work is; what is being built or changed
- `## Why` — the motivation, goal, or problem being solved
- `## Constraints` — hard limits, assumptions, non-negotiables, out-of-scope items
- `## Assets` — existing files, screenshots, links, or reference docs the user mentioned

**For a loop-back iteration**, append a new session block at the end of the existing file:

```markdown

## Session YYYYMMDD-HH:MM
```

All content captured in this run goes inside this block. Use the same four subsections within the block if the content warrants it, or write as a flat transcript if the session was narrowly focused.

**The cardinal rule — verbatim transcription**:

- Zero paraphrasing
- Zero summarising
- Zero interpreting
- Transcribe exactly what the user said, word for word
- Correct obvious typos only if the meaning would otherwise be ambiguous — never alter intent

Agent questions and explanations are NOT transcribed in full. Where an agent response visibly shaped the user's thinking, capture a single bracketed summary line: `[Agent clarified: <one-line summary>]`. Nothing more.

User words are the audit ground truth. The plan will be audited against this file. Corruption here propagates everywhere downstream.

Write the file using the file-write tool. NEVER overwrite prior session content under any circumstances.

---

## Phase 5 — Critic Pass

Before committing, adopt the **Critic** role. Silently scan the captured material for:

- Unstated assumptions (things the user assumed you already knew)
- Missing constraints (what happens at boundary cases?)
- Acceptance signals not yet defined (how will the user know the work is done?)
- Contradictions between sections
- Ambiguous terms that could be interpreted multiple ways

If meaningful gaps are found, ask one final targeted question round — keep it to the minimum set that would close the gaps. Transcribe any new answers per Phase 4 rules (verbatim, append-only).

If no meaningful gaps exist, proceed silently.

---

## Phase 6 — Git Commit

Check whether the project is inside a git repository. Example (Claude Code): `Bash` tool with `git rev-parse --is-inside-work-tree`.

If inside a git repo:

1. Stage only the input file and assets directory (if newly created).
2. Commit with the message: `kanban(capture): capture raw input for {subject}`

If not inside a git repo: skip this phase silently.

---

## Phase 7 — Report

Report to the user:

- The subject name derived and which source it came from (e.g. "derived from `$ARGUMENTS`" or "derived from conversation context")
- The path to the input file written
- Whether this was a first run (new file) or a loop-back iteration (new session block appended)
- Any assets captured and their location in `00-assets/`
- Whether a git commit was made (and the commit message if so)
- Any Critic gaps that were not fully resolved — flag these explicitly so they can be addressed before the next ideation step

Keep the report concise. The user should be able to confirm capture succeeded and know what, if anything, needs follow-up before research begins.

→ Next: Run `ideation/commands/research.md` to explore the codebase or prior art, then `ideation/commands/interview.md` to form recommendations.
