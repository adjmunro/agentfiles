# Changelog

---

## 1.1.0 - 2026-03-27 - Optimise pass: clarity, anchoring, personas

### Added
- Carry-forward candidate table written at end of Phase 1; Phase 2 re-reads it explicitly (intent anchor — P1)
- Three-gate positive decision tree for Phase 1 scope: future value, not derivable, not ephemeral
- Binary WIP/done classification gates with automatic WIP triggers (TODO/FIXME, deletion-heavy diff) and explicit "if uncertain → WIP" fallback
- Exclusion list items now annotate which gate they fail for transparency

### Changed
- Replaced Scribe (Vela) with Loom (Synthesist) for Phase 1 — better fit for cross-domain synthesis across conversation, memory, and project files
- Replaced Scribe (Vela) with Ward (Documentation) for Phase 2 — "write for the next agent, not for yourself" framing
- Deduplicated soft-reset explanation: full explanation kept in `> Important:` callout; commit body now defers to RESUME file

---

## 1.0.0 - 2026-03-27 - Initial release

### Added
- Four-phase closeout workflow: memory audit, memory writes, git cleanup, status report
- Memory type detection (user, feedback, project, reference) with file-per-entry pattern
- Conventional commit generation scoped by changed-file areas
- Open-work scan of `.kanban/` in-progress and to-do columns
- Error handling for clean repos, missing memory directory, and unresolvable git state

---
