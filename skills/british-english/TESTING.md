# Testing — British English

## Strategy

Run the skill against small, purpose-built fixture files in `/tmp/` to verify that prose is converted correctly while code blocks, inline code, and identifiers are left untouched. Test both single-file and directory-recursive modes, and verify the `--dry-run` flag produces no writes.

## Environment Setup

1. Create a working directory: `/tmp/british-english-test/`
2. Create the following fixture files:

**`/tmp/british-english-test/prose-american.md`** — a markdown file containing American spellings in prose: "organize", "color", "behavior", "analyze", "catalog", "dialog", "recognize", "realize", "center", "fiber".

**`/tmp/british-english-test/mixed-prose-code.md`** — a markdown file with American prose spellings followed by a fenced code block containing `optimize()` and `colorize` as function names, and an inline reference like `customize`.

**`/tmp/british-english-test/code-only.ts`** — a TypeScript file with only a comment containing "organize your code" and a function named `organizeItems()`.

**`/tmp/british-english-test/subdir/nested.md`** — a nested markdown file with American spellings, to verify recursion.

3. Take a snapshot of each file's contents before running any commands so you have a baseline for comparison.

## Core Scenarios

| Scenario | Input | Expected Outcome | Status |
|----------|-------|-----------------|--------|
| Single file — prose conversion | `prose-american.md` | All American spellings converted to British equivalents; no other content changed | Untested |
| Fenced code block — no change | `mixed-prose-code.md` (fenced block contains `optimize`, `colorize`) | Prose outside the block is converted; contents of the ` ``` ` block are untouched | Untested |
| Inline code — no change | `mixed-prose-code.md` (inline `` `customize` ``) | Prose is converted; the backtick-wrapped token is untouched | Untested |
| Directory mode — recursive | Run against `/tmp/british-english-test/` | All `.md` files in the tree (including `subdir/nested.md`) are converted | Untested |
| `--dry-run` flag — no writes | Run against `prose-american.md --dry-run` | Output lists what would change; file on disk is unchanged after the run | Untested |
| Mixed file — prose only | `mixed-prose-code.md` | Only prose outside code blocks and inline spans changes; function names and identifiers are untouched | Untested |
| Source file — comments only | `code-only.ts` | Comment text "organize your code" is converted; `organizeItems` function name is untouched | Untested |

## Command Coverage

| Command / Mode | Covered by scenario |
|----------------|---------------------|
| Single-file conversion | Single file — prose conversion |
| `--dry-run` flag | `--dry-run` flag — no writes |
| Directory recursion | Directory mode — recursive |
| Fenced code block exclusion | Fenced code block — no change |
| Inline code exclusion | Inline code — no change |
| Source file comment-only mode | Source file — comments only |

## Known Issues

_(None recorded yet — append as issues are found and fixed.)_

## Refinement Log

_(Empty — append after each test run with what was learned, what changed, and the date.)_
