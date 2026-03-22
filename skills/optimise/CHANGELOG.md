# Changelog

---

## v1.1.0 — 2026-03-22

### Added
- 3-tier TTL policy for `research-log.md` with target-path validation (H3)
- Binary applicability test questions for M1, M4, M7, M9, M11, M12 (H5)
- Symmetric numeric thresholds for Partial and Disconfirmed outcomes (H4)
- Two novel pattern candidates: NP1 (Symmetric Outcome Thresholds), NP2 (Binary Applicability Gates)

### Changed
- `SKILL.md` trimmed to overview + loop diagram + versioning only; full metric library and patterns now single-sourced in `commands/optimise.md` (H1)
- Persona loading moved from top-level preload into each phase header — Phase 2: Pulse, Phase 3: Keeper, Phase 4: Arden (H2)
- Progressive disclosure note updated to explicitly cover personas

### Fixed
- M12 IFS: `research-log.md` had no freshness check; score 0 → 100 after TTL policy
- M5 RI: ~700 tokens of metric/formula/pattern content duplicated in SKILL.md; redundancy 34% → 10%

---

## v1.0.0 — 2026-03-22

### Added
- Initial release
- optimise command: full 5-phase optimisation loop
- 12 metrics covering intent traceability, efficiency, quality, safety, and freshness
- 5 reusable design patterns extracted from kanban/ideation/personas research
- Universal vs. workflow-specific metric categorisation
