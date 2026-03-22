## v1.0.0 — 2026-03-22

### Added
- Initial release
- `british-english` command: 4-phase conversion loop (resolve → scan → apply → commit)
- Full substitution table covering -ise, -our, -re, and -yse endings
- `--dry-run` flag to preview changes without writing
- Skip rules for fenced code blocks, inline code, frontmatter keys, and machine identifiers
- Case-preserving substitutions (Title Case, ALL CAPS, lowercase)
- Automatic conventional commit on completion
