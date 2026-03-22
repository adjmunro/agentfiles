---
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
model: claude-sonnet-4-6
argument-hint: "<path> [--dry-run]"
---

<!-- PROGRESSIVE DISCLOSURE: execute only the current phase block.
     Do not read ahead. Each phase's inputs are produced by the previous one. -->

# British English — Conversion Command

Converts all non-code prose in the target path to Oxford British English.

## DO

- Derive the target path and dry-run flag from `$ARGUMENTS`
- Process every eligible file found under the target path
- Preserve all formatting, structure, and indentation exactly
- Skip code blocks, inline code, frontmatter keys, and machine identifiers
- In dry-run mode: print every proposed change but write nothing
- Commit all changes in a single conventional commit after writing

## DO NOT

- Alter content inside fenced code blocks (` ``` `…` ``` `)
- Alter content inside inline backticks (`` `…` ``)
- Alter YAML/TOML frontmatter keys or machine-readable values
- Alter file paths, CLI flags, variable names, or identifiers
- Alter `<template-placeholders>` that represent code slots
- Change American spellings that appear inside shell commands or tool invocations
- Invent synonyms — only apply the substitution list; when uncertain, leave it
- Alter actual code — identifiers, string literals, keywords, type names, import paths
- Touch `.json`, `.yaml`, `.toml`, `.lock`, or other data/config files with no comment syntax

---

## Phase 1 — Resolve Target
<!-- Active when: command is first invoked -->

Parse `$ARGUMENTS`:
- Extract the target path (first non-flag argument)
- Check for `--dry-run` flag; set mode accordingly
- If no path is provided, stop and print:
  > No target provided. Usage: /british-english <path> [--dry-run]
- If the path does not exist, stop and print:
  > Path not found: {path}
- If path is a file: process that file only
- If path is a directory: glob all eligible files recursively,
  excluding `.git/`, `node_modules/`, `.kanban/` archive directories

  **Prose files** (entire file is prose): `.md`, `.txt`, `.rst`, `.mdx`

  **Source files** (only comments and docstrings): `.py`, `.js`, `.ts`, `.tsx`,
  `.jsx`, `.swift`, `.kt`, `.java`, `.go`, `.rs`, `.c`, `.cpp`, `.h`, `.cs`,
  `.rb`, `.sh`, `.zsh`, `.bash`, `.sql`

Print a one-line summary:
> Mode: {live | dry-run} | Target: {path} | Eligible files: {N}

→ Next: Read Phase 2 and execute it.

---

## Phase 2 — Scan and Plan
<!-- Active when: target path resolved, file list known -->

Read each eligible file. For each file, identify **prose regions** based on file type,
then scan those regions for American spellings. Never alter anything outside a prose region.

### Prose regions by file type

**Prose files** (`.md`, `.txt`, `.rst`, `.mdx`) — the entire file is prose, with two exceptions:
- Skip fenced code blocks: ` ``` `…` ``` ` (any language tag)
- Skip inline code: `` `…` ``
- Skip YAML/TOML frontmatter blocks (between leading `---` delimiters), except `description:` and other clearly human-readable value fields

**Source files** — only the following regions are prose:

| Comment style | Languages | Region |
|---------------|-----------|--------|
| `//` line comment | JS, TS, Swift, Go, Rust, Java, Kotlin, C, C++, C# | from `//` to end of line |
| `/* … */` block comment | JS, TS, Java, Kotlin, C, C++, C#, Swift | full block content |
| `/** … */` doc-comment | JS, TS, Java, Kotlin, Swift | full block content |
| `///` doc-comment | Rust, Swift | from `///` to end of line |
| `#` line comment | Python, Ruby, Shell, Bash, Zsh | from `#` to end of line |
| `"""…"""` / `'''…'''` docstring | Python | full docstring content |
| `--` line comment | SQL | from `--` to end of line |
| `/* … */` block comment | SQL | full block content |

Within a doc-comment or docstring, **do not** alter:
- `@param`, `@returns`, `@throws`, `@see`, and similar tag names (the tag keyword itself)
- Code examples within doc-comments (indented blocks or ` ``` ` fences inside the comment)
- Type names, identifiers, or paths appearing after a doc tag (e.g. `@param {string} colorValue` — leave `colorValue` alone, but the description text after it is prose)

Use this substitution table. Apply **only** these substitutions — do not improvise:

### -ize → -ise
| Find | Replace |
|------|---------|
| optimize / optimizing / optimized / optimization / optimizations | optimise / optimising / optimised / optimisation / optimisations |
| organize / organizing / organized / organization / organizations | organise / organising / organised / organisation / organisations |
| customize / customizing / customized / customization | customise / customising / customised / customisation |
| normalize / normalizing / normalized / normalization | normalise / normalising / normalised / normalisation |
| recognize / recognizing / recognized / recognition (only the -ize form) | recognise / recognising / recognised |
| generalize / generalizing / generalized / generalization | generalise / generalising / generalised / generalisation |
| prioritize / prioritizing / prioritized | prioritise / prioritising / prioritised |
| summarize / summarizing / summarized | summarise / summarising / summarised |
| categorize / categorizing / categorized / categorization | categorise / categorising / categorised / categorisation |
| initialize / initializing / initialized / initialization | initialise / initialising / initialised / initialisation |
| finalize / finalizing / finalized | finalise / finalising / finalised |
| synchronize / synchronizing / synchronized | synchronise / synchronising / synchronised |
| visualize / visualizing / visualized | visualise / visualising / visualised |
| utilize / utilizing / utilized / utilization | utilise / utilising / utilised / utilisation |
| emphasize / emphasizing / emphasized | emphasise / emphasising / emphasised |
| authorize / authorizing / authorized / authorization | authorise / authorising / authorised / authorisation |
| specialize / specializing / specialized | specialise / specialising / specialised |
| realize / realizing / realized / realization | realise / realising / realised / realisation |
| localize / localizing / localized / localization | localise / localising / localised / localisation |
| formalize / formalizing / formalized | formalise / formalising / formalised |
| tokenize / tokenizing / tokenized / tokenization | tokenise / tokenising / tokenised / tokenisation |
| serialize / serializing / serialized / serialization | serialise / serialising / serialised / serialisation |
| maximize / maximizing / maximized | maximise / maximising / maximised |
| minimize / minimizing / minimized | minimise / minimising / minimised |
| canonicalize / canonicalized | canonicalise / canonicalised |
| stabilize / stabilized | stabilise / stabilised |
| contextualize / contextualized | contextualise / contextualised |
| parallelize / parallelized | parallelise / parallelised |

### -our spellings
| Find | Replace |
|------|---------|
| behavior / behaviors / behavioral | behaviour / behaviours / behavioural |
| color / colors / colored / colorful | colour / colours / coloured / colourful |
| flavor / flavors | flavour / flavours |
| favor / favors / favorable | favour / favours / favourable |
| honor / honors / honorable | honour / honours / honourable |
| labor / labors | labour / labours |
| neighbor / neighbors | neighbour / neighbours |
| humor / humors / humorous | humour / humours / humorous (unchanged — "humorous" is the same in both) |

### -re spellings
| Find | Replace |
|------|---------|
| center / centers / centered | centre / centres / centred |
| fiber / fibers | fibre / fibres |

### Other
| Find | Replace |
|------|---------|
| analyze / analyzes / analyzing / analyzed / analysis (leave "analysis" — same in both) | analyse / analyses / analysing / analysed |
| paralyze / paralyzed | paralyse / paralysed |
| catalog / catalogs | catalogue / catalogues |
| dialog (when meaning conversation or narrative, not UI component) | dialogue |
| generalized | generalised |

### Case-preserving rules
- If the source word is Title Case (e.g. `Behavior`), the replacement must also be Title Case (`Behaviour`)
- If ALL CAPS (`BEHAVIOR`), replace with ALL CAPS (`BEHAVIOUR`)
- Otherwise, replace in lowercase

### Skipping rules
Apply no substitution if the match is:
- Inside ` ``` ` … ` ``` ` (any language)
- Inside `` `…` `` (inline code)
- Inside a YAML/TOML frontmatter block (between leading `---` delimiters), unless the value is clearly prose (e.g. a `description:` field containing a full sentence)
- Part of a proper noun, trademark, or library name (e.g. `SwiftUI`, `NSColor`, `ActionDispatch`)
- Inside a URL or file path

Produce a change plan:
```
File: {path}
  Line {N}: "{before}" → "{after}"
  Line {N}: "{before}" → "{after}"
  ...
  Subtotal: {count} changes
```

If dry-run mode: print the full plan and stop. Print:
> Dry run complete. {total} changes across {file count} files. Re-run without --dry-run to apply.

→ Next: Read Phase 3 and execute it (live mode only).

---

## Phase 3 — Apply Changes
<!-- Active when: scan complete, live mode confirmed -->

For each file with planned changes:
1. Read the current file content
2. Apply each substitution using the case-preserving rules from Phase 2
3. Write the updated content back to the file
4. Print: `✓ {path} — {N} changes`

If a file had zero planned changes, skip it silently.

After all files are written, print a summary:
```
Applied {total changes} substitutions across {file count} files.
```

→ Next: Read Phase 4 and execute it.

---

## Phase 4 — Commit
<!-- Active when: all files written -->

If the target is inside a git repository:

Stage all modified files and commit:
```
git add {modified files}
git commit -m "chore({scope}): convert prose to Oxford British English

Applied British English spelling conventions to all non-code prose:
-ise endings, -our spellings, -re endings, analyse over analyze.

Code within fenced blocks and inline backticks left as American
English to match tooling and library conventions.

{N} substitutions across {file count} files."
```

Where `{scope}` is derived from the target path (e.g. `skills/kanban2` → `kanban2`,
repo root → `repo`).

If not inside a git repository, skip this phase and note it in the report.

→ Done. Print final report.

---

## Final Report

```
British English conversion complete.
Target:  {path}
Files:   {file count} modified
Changes: {total substitutions}
Mode:    {live | dry-run}
Commit:  {hash} | not a git repo | dry-run (no commit)
```
