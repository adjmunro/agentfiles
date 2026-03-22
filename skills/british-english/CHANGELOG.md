## v1.1.0 - 2026-03-22 - Source File Support

### Added
- Source file support: `.py`, `.js`, `.ts`, `.tsx`, `.swift`, `.kt`, `.java`, `.go`,
  `.rs`, `.c`, `.cpp`, `.h`, `.cs`, `.rb`, `.sh`, `.sql`
- Comment and docstring detection for 8 comment styles (`//`, `/* */`, `/** */`,
  `///`, `#`, `"""`, `'''`, `--`)
- Doc-tag awareness: `@param`, `@returns`, etc. are never altered; only the
  prose description text after the tag is in scope

## v1.0.0 - 2026-03-22 - Initial Release

### Added
- Initial release
- `british-english` command: 4-phase conversion loop (resolve → scan → apply → commit)
- Full substitution table covering -ise, -our, -re, and -yse endings
- `--dry-run` flag to preview changes without writing
- Skip rules for fenced code blocks, inline code, frontmatter keys, and machine identifiers
- Case-preserving substitutions (Title Case, ALL CAPS, lowercase)
- Automatic conventional commit on completion
