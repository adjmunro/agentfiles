# Changelog

---

## 1.0.0 — Initial Release (2026-04-14)

First version. Covers file and directory renames from git history, searches `.md`
and `.kt` files for six markdown reference patterns and three KDoc patterns, derives
Kotlin package paths from renamed `.kt` files, and applies fixes in place leaving
staging to the user.

- Git rename extraction via `--diff-filter=R --name-status`
- Directory-level rename detection from shared path prefixes
- Markdown patterns: inline links, reference-style links, backtick paths, bare prose
  paths, `@`-references
- KDoc patterns: bracketed class/member refs, `@see`, `[...]` prose links
- Templated `{variable}` paths flagged as `needs_review` rather than auto-fixed
- No auto-commit — stages changes only

---
