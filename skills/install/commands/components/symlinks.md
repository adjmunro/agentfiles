# Component: symlinks

Normalises the agent configuration layout in the target repository across three
independent sub-operations:

1. **Reconcile** AGENTS.md / CLAUDE.md / GEMINI.md into a single source of truth
2. **Migrate** `.claude/skills/` and `.claude/hooks/` under `.agents/` if applicable
3. **Create** `.worktrees/` and symlink `.claude/worktrees/` and `.agents/worktrees/` to it

**Inputs:** `$TARGET`, `$AGENTFILES_ROOT`

## DO

- Always use relative symlink paths — symlinks must survive the repo being moved
- Never delete content without first writing it somewhere else
- Confirm with the user before merging CLAUDE.md content into AGENTS.md (Case C below)
- Create `.agents/` if it does not exist and content needs to move into it

## DO NOT

- Overwrite a real directory with a symlink — move the real content first
- Create GEMINI.md if it already exists pointing to AGENTS.md — skip silently
- Proceed with the merge step (Case C) if both files have identical content

---

## Sub-operation 1 — AGENTS.md / CLAUDE.md / GEMINI.md Reconciliation

Determine what exists at `$TARGET`:

---

**Case A: CLAUDE.md exists, AGENTS.md does not**

1. Read `CLAUDE.md`
2. Produce an agent-agnostic version by applying these substitutions to prose:
   - "the Read tool" → "the file reading tool"
   - "the Edit tool" → "the file editing tool"
   - "the Write tool" → "the file writing tool"
   - "the Bash tool" → "the shell execution tool"
   - "the Glob tool" → "the file search tool"
   - "the Grep tool" → "the content search tool"
   - "the Agent tool" → "the subagent tool"
   - "the WebFetch tool" → "the web fetch tool"
   - "Claude Code" (when referring to the agent) → "the agent"
   - "Claude" alone (when referring to the agent's behaviour, not a person) → "the agent"
   - Preserve any section already written in tool-agnostic language
3. Write the agnostic content to `AGENTS.md`
4. Delete `CLAUDE.md`
5. Create symlink: `CLAUDE.md` → `AGENTS.md` (relative)
6. Print: "✓ Created AGENTS.md from CLAUDE.md (agent-agnostic); CLAUDE.md → AGENTS.md"

---

**Case B: AGENTS.md exists, CLAUDE.md does not**

1. Create symlink: `CLAUDE.md` → `AGENTS.md` (relative)
2. Print: "✓ Created CLAUDE.md → AGENTS.md symlink"

---

**Case C: Both exist**

1. Read both files
2. Identify content in CLAUDE.md that is not present in AGENTS.md (unique sections,
   rules, or instructions that AGENTS.md lacks)
3. If there is unique content:
   a. Show the user the unique sections found in CLAUDE.md
   b. Ask for confirmation before merging
   c. On confirmation: append the unique content to AGENTS.md under a separator:
      ```
      <!-- merged from CLAUDE.md -->
      ```
4. Delete CLAUDE.md
5. Create symlink: `CLAUDE.md` → `AGENTS.md` (relative)
6. Print: "✓ Merged CLAUDE.md → AGENTS.md; CLAUDE.md now a symlink"

If content is identical, skip the merge and go straight to replacing CLAUDE.md with
a symlink, noting "content was identical — no merge needed".

---

**Case D: Neither exists**

Print: "No AGENTS.md or CLAUDE.md found — skipping reconciliation."
Proceed to GEMINI.md and sub-operations 2 and 3.

---

**Always after any case:**

Check GEMINI.md:
- If it exists and already points to `AGENTS.md` → print "GEMINI.md already linked — skipped"
- If it exists and points elsewhere → print a warning and skip
- If it does not exist and AGENTS.md now exists → create symlink: `GEMINI.md` → `AGENTS.md` (relative);
  print "✓ GEMINI.md → AGENTS.md symlink"

---

## Sub-operation 2 — Skills and Hooks Directory Migration

Only run this sub-operation if `.claude/` exists in `$TARGET`.

Create `$TARGET/.agents/` if it does not exist.

**For `.claude/skills/`:**

| State | Action |
|-------|--------|
| `.claude/skills/` is a real directory | Move it to `.agents/skills/`; replace `.claude/skills/` with a relative symlink → `.agents/skills/` |
| `.claude/skills/` is already a symlink to `.agents/skills/` | Print "skills/ already linked — skipped" |
| `.agents/skills/` exists but `.claude/skills/` does not | Create `.claude/skills/` → `.agents/skills/` symlink |
| Neither exists | Skip silently |

**For `.claude/hooks/`:**

Repeat identical logic for `hooks/`.

Print results:
```
Skills:  ✓ moved .claude/skills/ → .agents/skills/ + symlink created
         (or) ✓ .claude/skills/ → .agents/skills/ symlink created
         (or) already linked — skipped
Hooks:   [same]
```

---

## Sub-operation 3 — Worktrees Directory

1. Create `$TARGET/.worktrees/` as a real directory if it does not exist.
   Print: "✓ Created .worktrees/"

2. If `.claude/` exists in `$TARGET`:
   - If `.claude/worktrees` does not exist: create symlink `.claude/worktrees` → `../.worktrees` (relative)
   - If it exists and points correctly: print "already linked — skipped"
   - Print: "✓ .claude/worktrees → .worktrees"

3. If `.agents/` exists in `$TARGET`:
   - Same logic for `.agents/worktrees` → `../.worktrees`
   - Print: "✓ .agents/worktrees → .worktrees"

---

## Final Report

Print a consolidated summary of all three sub-operations, listing any warnings or
skipped steps separately beneath the results.
