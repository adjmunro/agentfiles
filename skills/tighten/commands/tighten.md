---
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
model: claude-sonnet-4-6
argument-hint: "<path> [--dry-run] [--no-commit]"
---

<!-- PROGRESSIVE DISCLOSURE: execute only the current phase block.
     Do not read ahead. Each phase's inputs are produced by the previous one. -->

# Tighten — Prose Editing Command

Tightens prose in instruction files: removes fluff, strengthens imperatives, elevates impact vocabulary, and resolves passive voice. Leaves code untouched. Runs an audit pass before committing to guarantee no meaning was lost.

## DO

- Derive the target path and dry-run flag from `$ARGUMENTS`
- Process every eligible file found under the target path
- Apply all three rule categories (Remove, Strengthen, Elevate) in a single editing pass per file
- Use judgment — the rules are lenses, not rigid substitutions; preserve meaning above all else
- Run the audit phase before committing; revert any change that altered meaning
- Commit all changes in a single conventional commit after the audit passes
- In dry-run mode: print every proposed change but write nothing

## DO NOT

- Alter content inside fenced code blocks (` ``` `…` ``` `)
- Alter content inside inline backticks (`` `…` ``)
- Alter YAML/TOML frontmatter keys or machine-readable values
- Alter file paths, CLI flags, variable names, or identifiers
- Alter `<template-placeholders>` that represent code slots
- Touch `.json`, `.yaml`, `.toml`, `.lock`, or other data/config files
- Remove content that carries information — only remove content that is purely decorative or redundant
- Weaken any instruction, rule, or warning — when uncertain, leave it unchanged

---

## Phase 1 — Resolve Target
<!-- Active when: command is first invoked -->

Parse `$ARGUMENTS`:
- Extract the target path (first non-flag argument)
- Check for `--dry-run` flag; set mode accordingly
- Check for `--no-commit` flag; if set, skip Phase 5 entirely — the caller owns the commit
- If no path is provided, stop and print:
  > No target provided. Usage: /tighten \<path\> [--dry-run]
- If the path does not exist, stop and print:
  > Path not found: {path}
- If path is a file: process that file only
- If path is a directory: glob all `.md`, `.txt`, `.rst`, `.mdx` files recursively,
  excluding `.git/`, `node_modules/`, `.kanban/` archive directories

Print a one-line summary:
> Mode: {live | dry-run} | Target: {path} | Eligible files: {N}

→ Next: Read Phase 2 and execute it.

---

## Phase 2 — Scan and Plan
<!-- Active when: target path resolved, file list known -->

Read each eligible file. Identify prose regions (exclude fenced code blocks, inline code, frontmatter keys). Within prose regions, find every instance of the three rule categories below.

Produce a change plan per file before applying anything.

---

### Rule Category 1 — REMOVE (filler, hedging, redundancy)

These add no information. Delete them or compress to the shorter form.

| Pattern | Action |
|---------|--------|
| "It is important to note that " | Delete entire phrase |
| "Please note that " | Delete entire phrase |
| "It should be noted that " | Delete entire phrase |
| "Note that " at sentence start (when sentence still reads correctly) | Delete |
| "As mentioned above" / "As mentioned before" / "As mentioned previously" | Delete |
| "As noted above" / "As described above" | Delete |
| "In other words," (when it restates the prior sentence exactly) | Delete the restatement |
| "In order to" | → "To" |
| "Due to the fact that" | → "Because" |
| "At this point in time" | → "Now" |
| "In the event that" | → "If" |
| "In the case where" / "In the case that" | → "If" |
| "For the purposes of" | → "For" |
| "With regard to" / "With respect to" | → "Regarding" |
| "Make sure to {verb}" | → "{verb}" |
| "Be sure to {verb}" | → "{verb}" |
| "Feel free to {verb}" | → "{verb}" |
| "Don't hesitate to {verb}" | → "{verb}" |
| "Make use of" | → "Use" |
| "Take into account" | → "Consider" |
| "Keep in mind that" | → "Note:" |
| "Be aware that" | → "Note:" |
| "very " before an adjective | Delete "very " |
| "really " before an adjective | Delete "really " |
| "quite " as a hedge | Delete "quite " |
| "basically " as filler | Delete "basically " |
| "simply " as a minimiser | Delete "simply " |
| "just " as a minimiser (not "just as", "just now", or comparative "just") | Delete "just " |
| "actually " as filler (not contrastive "actually, X is Y") | Delete "actually " |
| "etc." at the end of a list | Remove; expand the list if the omission loses meaning |
| "and so on" at the end of a list | Remove; expand the list if the omission loses meaning |

---

### Rule Category 2 — STRENGTHEN (weak imperatives)

Transform hedged or conditional language into clear directives. **Only apply in instruction contexts** — where the text is telling an agent what to do. Do NOT apply inside conditional clauses ("if X should occur"), descriptive sentences ("the field should contain"), or user-facing explanatory prose.

| Pattern | Action |
|---------|--------|
| "should {verb}" (instruction) | → "must {verb}" |
| "try to {verb}" | → "{verb}" (drop "try to") |
| "attempt to {verb}" | → "{verb}" |
| "aim to {verb}" | → "{verb}" |
| "ideally, {imperative}" | → "{imperative}" or "always {verb}" |
| "whenever possible" | → "always" or remove |
| "if possible" (as instruction softener) | → remove |
| "you can {verb}" (as instruction) | → "{verb}" |
| "it is possible to {verb}" | → "{verb}" |
| passive voice "X is {verbed} by Y" where Y is the acting agent | → "Y {verbs} X" |
| "perform {noun}" / "carry out {noun}" | → verb form ("perform validation" → "validate", "carry out a check" → "check") |

---

### Rule Category 3 — ELEVATE (impact vocabulary)

Apply this as a judgment lens, not a substitution table. When a word or phrase is technically correct but bland, replace it with a more precise or emphatic alternative — only where the stronger word is accurate.

**Verb upgrades (use the more specific verb when it fits):**

| Weak | Stronger |
|------|----------|
| "check" (when the action is definitive) | "verify" or "confirm" |
| "use" (when the action enforces a constraint) | "enforce" |
| "get" | "retrieve", "fetch", or "obtain" as context dictates |
| "do X" (vague imperative) | specific verb for X |
| "make X" (vague) | "create", "build", "construct", "generate" as context dictates |
| "handle" (vague) | "process", "resolve", "recover from" as context dictates |
| "deal with" | "address", "resolve" |

**Emphasis markers for hard rules:**

When a rule is genuinely blocking — violation causes data loss, incorrect state, or security failure — escalate the signal:

| Weak | Stronger |
|------|----------|
| "do not" (for hard constraints) | "NEVER" |
| "always" (for non-negotiable requirements) | "ALWAYS" (caps) |
| "stop" (for hard blockers) | "STOP" (caps) |
| "important" (for genuinely critical rules) | "critical" |
| "note:" (for warnings with real consequences) | "WARNING:" |

**Stakes-setting:** Where a rule's violation has a named consequence, add it. Example: "do not edit existing entries" → "NEVER edit existing entries — the append zone is chronological; edits corrupt the audit trail." Only add stakes where they are accurate and not already stated.

---

### Change Plan Format

```
File: {path}
  Remove:    {N} filler phrases / redundancies
  Strengthen: {N} weak imperatives
  Elevate:   {N} vocabulary upgrades
  Net token delta (estimated): -{N} tokens
  ---
  Line {N}: "{before}" → "{after}"
  Line {N}: DELETE "{text}"
  ...
```

If dry-run mode: print the full plan and stop. Print:
> Dry run complete. Estimated -{N} tokens across {file count} files. Re-run without --dry-run to apply.

→ Next: Read Phase 3 and execute it (live mode only).

---

## Phase 3 — Apply Changes
<!-- Active when: scan complete, change plan produced, live mode confirmed -->

For each file with planned changes:
1. Read the current file content
2. Apply the change plan — remove, strengthen, elevate as scanned
3. Write the updated content back to the file
4. Print: `✓ {path} — {N} changes ({remove} removed, {strengthen} strengthened, {elevate} elevated)`

Track every deletion in a "removed content log" — you will need this in Phase 4.

After all files are written, print:
```
Applied {total changes} edits across {file count} files.
Estimated token reduction: -{N} tokens.
```

→ Next: Read Phase 4 and execute it.

---

## Phase 4 — Audit
<!-- Active when: all files written -->

Re-read every modified file. For each, verify:

1. **No instruction weakened**: every rule, constraint, or directive present before is still present after — or is now expressed more strongly. Flag any rule that appears to have been softened or removed.

2. **No information lost**: facts, examples, table rows, and named identifiers present before are still present after. Filler deletions must not have accidentally taken load-bearing content with them.

3. **No meaning changed**: the "should" → "must" strengthening was only applied in instruction contexts. Scan for any "must" in a conditional clause ("if X must occur") — these are likely incorrect upgrades; revert them.

4. **Passive voice reversals are accurate**: the new active sentence names the correct actor. If uncertain, revert.

5. **NEVER/ALWAYS caps are warranted**: each caps escalation corresponds to a genuinely hard rule, not a preference. Revert any that were applied to soft guidance.

For each issue found: revert the specific change, note it in the audit log.

**Audit log format:**

```
Audit: {file count} files reviewed
  Reverted {N} changes:
    - {path} line {N}: reverted "{new}" → "{original}" (reason: {why})
  Confirmed {N} changes: all meaning-preserving
```

If zero issues found: print "Audit clean — all {N} changes confirmed."

→ Next: Read Phase 5 and execute it.

---

## Phase 5 — Commit
<!-- Active when: audit complete, all suspect changes reverted -->

If the target is inside a git repository:

Stage all modified files and commit:

```
git add {modified files}
git commit -m "chore({scope}): tighten prose — remove fluff, strengthen imperatives

Removed filler phrases and hedge qualifiers. Strengthened weak
imperatives (should → must, try to → direct verb). Elevated key
rules with emphatic markers where warranted. Passive voice resolved
where actor was unambiguous. Audit pass confirmed no meaning lost.

{N} edits across {file count} files. Estimated -{N} tokens."
```

Where `{scope}` is derived from the target path (e.g. `skills/implement` → `implement`, repo root → `repo`).

If not inside a git repository, skip this phase and note it in the report.

→ Done. Print final report.

---

## Final Report

```
Tighten complete.
Target:   {path}
Files:    {file count} modified
Edits:    {N} total ({remove} removed, {strengthen} strengthened, {elevate} elevated)
Reverted: {N} (audit catches)
Δ tokens: -{N} estimated
Commit:   {hash} | not a git repo | dry-run (no commit)
```
