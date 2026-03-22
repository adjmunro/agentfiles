# Component: symlinks

Normalises the agent configuration layout in the current repository across three
independent sub-operations:

1. **Reconcile** AGENTS.md / CLAUDE.md / GEMINI.md into a single source of truth
2. **Migrate** `.claude/skills/` and `.claude/hooks/` under `.agents/` if applicable
3. **Create** `.worktrees/` and symlink `.claude/worktrees` and `.agents/worktrees` to it

## DO

- Always use relative symlink paths — symlinks must survive the repo being moved
- Never delete content without first writing it somewhere else
- Confirm with the user before merging CLAUDE.md content into AGENTS.md (Case C)
- Create `.agents/` if it does not exist and content needs to move into it

## DO NOT

- Overwrite a real directory with a symlink — move the real content first
- Create GEMINI.md if it already exists pointing to AGENTS.md — skip silently
- Proceed with the merge step (Case C) if both files have identical content

---

## Sub-operation 1 — AGENTS.md / CLAUDE.md / GEMINI.md Reconciliation

**Case A: CLAUDE.md exists, AGENTS.md does not**
1. Read CLAUDE.md
2. Produce an agent-agnostic version:
   - "the Read tool" → "the file reading tool"
   - "the Edit tool" → "the file editing tool"
   - "the Write tool" → "the file writing tool"
   - "the Bash tool" → "the shell execution tool"
   - "the Glob tool" → "the file search tool"
   - "the Grep tool" → "the content search tool"
   - "the Agent tool" → "the subagent tool"
   - "the WebFetch tool" → "the web fetch tool"
   - "Claude Code" (referring to the agent) → "the agent"
   - "Claude" alone (referring to the agent's behaviour) → "the agent"
3. Write agnostic content to AGENTS.md
4. Delete CLAUDE.md
5. Create symlink: CLAUDE.md → AGENTS.md (relative)
6. Print: "✓ Created AGENTS.md from CLAUDE.md (agent-agnostic); CLAUDE.md → AGENTS.md"

**Case B: AGENTS.md exists, CLAUDE.md does not**
1. Create symlink: CLAUDE.md → AGENTS.md (relative)
2. Print: "✓ Created CLAUDE.md → AGENTS.md symlink"

**Case C: Both exist**
1. Read both files; identify content unique to CLAUDE.md
2. If unique content exists:
   a. Show the user the unique sections
   b. Ask for confirmation before merging
   c. On confirmation: append to AGENTS.md under `<!-- merged from CLAUDE.md -->`
3. Delete CLAUDE.md; create symlink CLAUDE.md → AGENTS.md (relative)
4. Print: "✓ Merged CLAUDE.md → AGENTS.md; CLAUDE.md now a symlink"

If content is identical: replace CLAUDE.md with symlink directly; note "content was identical — no merge needed".

**Case D: Neither exists**
Print: "No AGENTS.md or CLAUDE.md found — skipping reconciliation."

**Always after any case:**

Check GEMINI.md:
- Already points to AGENTS.md → print "GEMINI.md already linked — skipped"
- Points elsewhere → warn and skip
- Does not exist and AGENTS.md now exists → create GEMINI.md → AGENTS.md; print "✓ GEMINI.md → AGENTS.md"

---

## Sub-operation 2 — Skills and Hooks Directory Migration

Only run if `.claude/` exists in the current directory.

Create `.agents/` if it does not exist.

**For `.claude/skills/`:**

| State | Action |
|-------|--------|
| Real directory | Move to `.agents/skills/`; replace `.claude/skills/` with relative symlink |
| Already a correct symlink | Print "already linked — skipped" |
| `.agents/skills/` exists but `.claude/skills/` absent | Create `.claude/skills/` → `.agents/skills/` symlink |
| Neither exists | Skip silently |

**For `.claude/hooks/`:** Repeat identical logic.

---

## Sub-operation 3 — Worktrees Directory

1. Create `.worktrees/` as a real directory if it does not exist. Print: "✓ Created `.worktrees/`"

2. If `.claude/` exists:
   - If `.claude/worktrees` absent: create `.claude/worktrees` → `../.worktrees` (relative)
   - Correct already: skip. Print: "✓ `.claude/worktrees` → `.worktrees`"

3. If `.agents/` exists:
   - Same for `.agents/worktrees` → `../.worktrees`
   - Print: "✓ `.agents/worktrees` → `.worktrees`"

---

## Final Report

Consolidated summary of all three sub-operations. List any warnings or skipped steps separately.
