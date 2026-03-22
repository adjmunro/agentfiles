---
name: british-english
description: Convert all non-code prose in a target path to Oxford British English. Leaves code, identifiers, CLI flags, and fenced/inline code blocks untouched.
argument-hint: "<path> [--dry-run]"
---

# British English

Converts all human-readable prose in a target file or directory tree to Oxford British English.

## What it changes

| Category | American | British |
|----------|----------|---------|
| -ize endings | organize, optimize, customize | organise, optimise, customise |
| -or endings | color, behavior, favor, honor | colour, behaviour, favour, honour |
| -er endings | center, fiber | centre, fibre |
| -yze endings | analyze, paralyze | analyse, paralyse |
| -ogue | catalog, dialog | catalogue, dialogue |
| Other | program (as in schedule), recognize, realize | programme, recognise, realise |

Oxford comma is **not** enforced automatically — it requires contextual judgement and is left to the author.

## What it never touches

- Content inside fenced code blocks (` ``` `)
- Inline code (`` `backtick` ``)
- YAML frontmatter keys and machine-readable values
- File paths used as identifiers
- Variable names, function names, CLI flags
- Anything inside `<angle-bracket>` template placeholders that represent code

## Scope

- `$ARGUMENTS` may be a single file or a directory (recursive)
- Append `--dry-run` to preview changes without writing
- **Prose files** (`.md`, `.txt`, `.rst`, `.mdx`): entire file is converted, except fenced code blocks and inline code
- **Source files** (`.py`, `.js`, `.jsx`, `.ts`, `.tsx`, `.swift`, `.kt`, `.java`, `.go`, `.rs`, `.c`, `.cpp`, `.h`, `.cs`, `.rb`, `.sh`, `.zsh`, `.bash`, `.sql`): only comments and docstrings are converted — code is never touched
- Skips binary files, `.git/`, `node_modules/`, `.json`/`.yaml`/`.toml` data files, and `.kanban/` archives

## Versioning

See `VERSION.md`. Bump patch for word-list additions or new language comment styles, minor for new file-type support.
