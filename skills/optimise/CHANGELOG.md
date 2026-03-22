# Changelog

---

## v1.7.0 - 2026-03-22 - Approval Gate Removal

### Added
- Loop support: `/optimise N <path>` runs the full 5-phase cycle N times; `/optimise auto <path>` loops until the composite score exceeds 95% using `(confirmed + 0.5 × partial) / total × 100`; default (no specifier) remains a single run
- Loop Control section in `optimise.md`: defines loop termination rules, hypothesis numbering continuity across iterations, and the zero-hypothesis exit condition for auto mode
- Self-Audit step in Phase 3: before proceeding to experiments, the agent audits the hypothesis list for intent accuracy, checks coverage using the composite formula, and fills gaps for any metric below 80 with no hypothesis targeting it

### Changed
- Phase 3 approval gate removed: the Recommendation Brief is displayed as information but no longer requires human approval before Phase 4 begins — the self-audit replaces it
- `optimise.md` DO rule "Present the Recommendation Brief and wait for human approval" removed
- `optimise.md` DO NOT rule "Begin Phase 4 without explicit human approval" removed
- `help.md` HTC stats note updated: scored 100 after approval gate removal (zero mandatory touchpoints per run)

### Fixed
- Human Touchpoint Count (M8 · HTC): was capped at 95 by the Phase 3 gate; now 100

---

## v1.6.0 - 2026-03-22 - Pattern Library Expansion

### Added
- P12 (Content Synchronisation Audit), P13 (Corrective-Pattern Applicability Classification), P14 (Pre-Experiment Dependency Scan) added to `p3-hypothesize.md` Design Patterns library
- P12/P13/P14 added to `help.md`: summary table rows and full detail sections
- Research log archival mechanism: Phase 5 now checks log size; if >15,000 tokens, archives older runs to `research-log-archive-<date>.md` and resets the live log to current run only
- 5 new custom metrics: Novel Pattern Promotion Currency (MX20), Research Log Size Manageability (MX21), Hypothesis Effect Traceability (MX22, moonshot 2×), Cross-Metric Stability Rate (MX23), Implementation-Changelog Consistency (MX24)
- First archival executed: `research-log-archive-2026-03-22.md` created; live log reduced from ~36,000t to ~8,000t
- NP7 (Measurement Accuracy Retrospective) documented as novel pattern — seed candidate

### Changed
- SKILL.md: pattern range updated from "P1–P11" to "P1–P14"; seed candidate promotion pointer updated from "P10+" to "P12+"
- Redundancy Index corrected from 88 to 97: precise audit found actual cross-instruction-file redundancy is ~3%, not the estimated ~12% (research-log.md was incorrectly included in scope)

### Fixed
- Composite: 93.1% → 98.1% (+5.0pp) — seven metrics improved this run (PPR, CLT, NPPC, CMSR, RLSM, RI, HET)

---

## v1.5.0 - 2026-03-22 - Dependency Scan Addition

### Added
- 5 new custom metrics: Help Content Currency (MX15), Pattern Experimental Validation Rate (MX16), Research Log Navigability Score (MX17), Hypothesis Recurrence Rate (MX18), Metric Definition Cross-File Consistency (MX19, moonshot 2×)
- Step 0 (Pre-Experiment Dependency Scan) added to Phase 4: checks all pending hypotheses for file overlap before applying any change; overlapping hypotheses run sequentially with metric re-check between them
- P10 (Failure Mode Registry) and P11 (File Role Stratification) added to help.md with full detail sections and summary table rows
- P8 Persona Rotation marked [corrective — applies when PPF < 100] in p3-hypothesize.md
- Corrective-pattern exemption added to MX16 PEV methodology: patterns with a trigger condition that has never been true are scored N/A and excluded from the denominator
- Three novel patterns documented: NP4 (Content Synchronisation Audit), NP5 (Corrective-Pattern Applicability Classification), NP6 (Pre-Experiment Dependency Scan)

### Changed
- M3 IAR help.md entry: normalisation direction now explicit ("Score = 100 − ambiguity%")
- p1-audit.md: two weak modals scoped ("should not" → "must not"; "Consider whether... should" → "check whether... would")
- p5-report.md: "should be promoted" → "Promote any" (seed candidate step)

### Fixed
- Composite: 96.7% → 98.0% (+1.3pp) — five metrics improved this run

---

## v1.4.0 - 2026-03-22 - Persona Experiment Framework

### Added
- M14 — Persona-Phase Fit Score (PPF): new seed metric measuring whether phases have appropriately matched personas; applies when persona system is present; includes persona staleness check (missing files score 0.0, speciated parents score 0.5)
- M15 — Persona Richness Score (PRS): new seed metric scoring each persona against the 14-point Richness Rubric; Unique Talent and Failure Mode are required fields (worth 2pts each); personas missing both score ≤71%
- P8 (Persona Rotation) and P9 (Persona Speciation) added to Design Patterns
- P10 (Failure Mode Registry) and P11 (File Role Stratification) promoted from run 3 novel patterns — these were confirmed in run 3 with seed-candidate status but not yet incorporated
- `[persona experiment]` hypothesis sub-type in p3-hypothesize.md: rotation / speciation / distillation / gap-fill modes with 3 upfront quality markers, spot-check execution, and combined structural + spot-check confirmation rule
- Persona staleness check in Phase 1 (p1-audit.md): detects broken load directive references and speciated parents
- Persona experiment failure mode recovery paths in Phase 4: malformed persona file, ambiguous spot-check markers, evolve command unavailable
- 5 new custom metrics: Persona Experiment Cycle Completeness (MX10), Phase Boundary Sharpness (MX11), Hypothesis Template Completeness (MX12), Cross-Run Learning Transfer (MX13, moonshot 2×), Spot-Check Protocol Completeness (MX14)
- `/personas evolve` command: four modes — audit (scores personas on Richness Rubric + cognitive gap analysis), speciate (fork into 2–3 focused variants), distil (sharpen using evidence from run logs), new (gap-fill creation)
- personas/AGENTS.md updated: required fields tables for persona.md and soul.md; Unique Talent and Failure Mode marked mandatory
- First persona distillation: Pulse, Keeper, and Arden distilled using 4 runs of research-log evidence; each gained Unique Talent and Failure Mode sections, plus 1 evidence-based DO rule

### Changed
- p3-hypothesize.md range reference updated from "P1–P7" to "P1–P11"
- Direction fields added to M14 and M15 definitions (completing all 15 seed metrics to the 4-field specification)
- SKILL.md metric range updated to "M1–M15, P1–P11"

### Fixed
- Composite: 86.8% → 97.4% (+10.6pp) — seven metrics improved this run

---

## v1.3.0 - 2026-03-22 - Help Command Addition

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

## v1.2.0 - 2026-03-22 - Phase Split

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

## v1.1.0 - 2026-03-22 - TTL Policy Addition

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

## v1.0.0 - 2026-03-22 - Initial Release

### Added
- Initial release
- optimise command: full 5-phase optimisation loop
- 12 metrics covering intent traceability, efficiency, quality, safety, and freshness
- 5 reusable design patterns extracted from kanban/ideation/personas research
- Universal vs. workflow-specific metric categorisation
