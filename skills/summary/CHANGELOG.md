# Changelog

---

## v1.0.0 - 2026-03-22 - Initial Release

### Added
- Initial release of the `/summary` skill
- Four invocation modes: default (branch parent), `pr` (PR review framing), `trunk` (divergence from main), and `<ref>` (arbitrary git ref)
- Structured output sections: Context, Changes by area, New & changed features, Why, and Open work
- Persona assignments: Arc (Sequencer) for temporal reasoning, Loom (Synthesist) for cross-source synthesis, Ward (Documentation) for doc accuracy
- CHANGELOG scanning: reads changed `CHANGELOG.md` files in `skills/` and `personas/` directories
- Open work detection: scans `.kanban/` for in-progress tickets
