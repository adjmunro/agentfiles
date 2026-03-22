# Changelog

---

## v1.3.0 — 2026-03-22

### Added
- M13 — Instruction Token Efficiency (ITE): new universal seed metric measuring semantic density by detecting padding tokens (throat-clearing preamble, redundant intensifiers, decorative structure, narrative restatement); ITE = 1 − (padding_tokens / total_tokens)
- `/optimise help` command: summary table of all metrics (M1–M13) and design patterns (P1–P7) with IDs, weights, and one-line purposes
- `/optimise help <name>` detail mode: full metric/pattern definitions with methodology, intent, healthy range, risk, and improvement guidance; fuzzy-match aliases on every entry
- 5 new custom metrics: Help Content Coverage (MX5), Metric ID Consistency (MX6), Experiment Isolation Score (MX7), Recovery Path Completeness (MX8), Hypothesis Surprise Rate (MX9, moonshot)
- Recovery paths for three previously uncovered failure modes: log contamination detection (p1-audit.md), all-skip routing to Phase 5 (p3-hypothesize.md), non-git target handling (p4-experiments.md)
- File Role Stratification: M2 DD and M13 ITE now classify command files as instruction vs. documentation before scoring — documentation files excluded from both metrics
- Full-Spectrum Delta Recording: Phase 4 Step c now checks all applied metrics (not just targeted) for ≥2pp secondary changes, enabling Hypothesis Surprise Rate tracking
- Three novel patterns documented: Failure Mode Registry (NP1), File Role Stratification (NP2), Full-Spectrum Delta Recording (NP3)

### Changed
- Custom metric discovery minimum raised from 1 to 5 new metrics per run; moonshot requirement added (at least one unconventional, cross-domain metric)
- No-acronyms rule added globally: metric and pattern names must be spelled out in full in all user-facing output
- Metric and pattern IDs now shown alongside full names in user output (e.g., "Directive Density (M2 · DD)")
- Recommendation Brief template updated to use numbered plain-language summaries — no abbreviations in hypothesis IDs or metric names shown to user
- Phase 5 terminal summary and final table updated to use full metric names only
- SKILL.md metric range updated from "M1–M12" to "M1–M13"
- M13 definition completed with explicit Direction field

### Fixed
- Composite: 92.5% → 95.7% (+3.2pp) — five metrics improved this run

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
