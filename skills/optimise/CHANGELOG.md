# Changelog

---

## v1.2.0 — 2026-03-22

### Added
- Phase file split: `commands/optimise.md` replaced by orchestrator + `commands/phases/p1-p5.md` — per-phase context load drops from ~2,500t to ~700-1,000t (M10 CLE 75 → 95)
- P6 (Symmetric Outcome Thresholds) and P7 (Binary Applicability Gates) added to Design Patterns in `p3-hypothesize.md`; P1-P5 restored alongside them (were absent after v1.1.0 SKILL.md strip)
- Persona load fallback: "if not found, proceed without" clause on all three phase persona directives (MX4 PLR 0 → 100)
- `scope qualifier` definition with examples added to M3 IAR methodology (MX2 MMC 83 → 100)
- Concrete/vague examples added to M6 ACC methodology

### Fixed
- SKILL.md pointer updated to reference `commands/phases/p3-hypothesize.md` accurately (Design Patterns section)
- Seed candidate promotion note in Phase 5 corrected to reference `p3-hypothesize.md`
- MX3 PPR 0 → 100: NP1/NP2 promoted; P1-P5 restored to command file (they were accidentally omitted in v1.1.0)

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
