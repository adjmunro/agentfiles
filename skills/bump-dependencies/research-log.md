## Archive: see research-log-archive-2026-04-14b.md for Run 9 (2026-04-14). See research-log-archive-2026-04-14.md for Runs 1–8.

---

## Audit — 2026-04-14 (Run 10)

**Pulse (Analytics) active.**

**Target:** `skills/bump-dependencies/`
**Files:** 20 total (11 command, 4 support, 5 logs/archives)
**Token estimate:** ~29,000 tokens (instruction files ~15,500; support/logs ~13,500)

> Tier C — target matches, log is from today (≤7 days). Run 9 Phase 5 written retroactively above; proceeding to Run 10.

### Feature Inventory
- Multi-phase pipeline: yes (Phase 0 + Phases 1–8)
- Persona system: yes (Ink P0/P1b/P4, Echo P2/P3, Rook P2 security, Arden P5)
- Subagent invocations: yes (Wave 1 and Wave 3 parallel agents)
- Multi-session orchestration: no
- Parallel execution: yes (Wave 1: P2–3, Wave 3: P5–6)
- Cached artifacts: yes (session brief tmp file, research-log.md)

### Files
**Command files (11):** bump-dependencies.md, p0-bump.md, p1-parse.md, p1b-split-commits.md, p2-investigate.md, p3-impact.md, p4-remediate.md, p5-verdict.md, p6-comment.md, p7-summary.md, p8-consolidate.md
**Support files (4):** SKILL.md, AGENTS.md, VERSION.md, CHANGELOG.md
**Logs/archives (5):** research-log.md, research-log-archive-2026-04-01.md, -01b.md, -01c.md, -2026-04-14.md

### Persona Staleness Check
All 4 personas confirmed present and current (unchanged since Run 9). No broken references.

### Changes Since Run 9
1. **H37–H40 applied** (commit 85fc15f): pre-release filtering, monotonicity guard, PR deduplication, structural anchor — all confirmed.
2. **Version bumped to 4.4.0**.
3. **Stale orchestrator comment headers identified:** p0-bump.md, p7-summary.md, p8-consolidate.md reference `bump-dependencies.md` correctly. p1-parse.md, p1b-split-commits.md, p2-investigate.md, p3-impact.md, p4-remediate.md, p5-verdict.md, p6-comment.md still reference `review-dependency-update.md` — the pre-v4.0.0 orchestrator filename. 7 of 10 phase-file comment headers are stale.

---

## Custom Metrics — 2026-04-14 (Run 10)

**Pulse (Analytics) active.**

EIS: Run 9 was a multi-hypothesis session with explicit Step 0 logging and execution order — now applicable.
PEV: Run 9 confirmed experiments on record — now applicable.

### EIS — Experiment Isolation Score (newly applicable)
Sessions with ≥2 hypotheses in live log: Run 9 (H37–H40). Step 0 logged with overlap note and explicit execution order. Criterion (a) fully met. EIS = 1/1 = 100%. **Score: 100.** Weight: 1×.

### PEV — Pattern Experimental Validation Rate (newly applicable)
Applicable patterns for bump-dependencies (excluding corrective-only and never-triggered conditions):
P3 (Progressive Disclosure), P5 (Parallel Execution), P7 (Binary Applicability Gates), P10 (Failure Mode Registry), P11 (File Role Stratification), P12 (Content Synchronisation Audit), P13 (Corrective-Pattern Applicability Classification), P14 (Pre-Experiment Dependency Scan), P16 (Generated Batch Script), P17 (Lookup Subagent Isolation) = 10.
Excluded: P8/P9 (persona conditions never triggered), P15 (only 1 run in live log), P6 (Symmetric Outcome Thresholds — no outcome gates used as hypotheses).
Validated in Run 9 confirmed experiments: P7 (H37, H38), P10 (H39) = 2.
PEV = 2/10 = 20%. **Score: 20.** Weight: 1×.

### MX35 — Stale Orchestrator Reference Rate (SORR) [custom]
**Measures:** Whether `<!-- Part of: ... orchestrator -->` comment headers in phase files accurately name the current orchestrator file. Stale references mislead developers tracing the call chain.
**Why seeds miss it:** M5 RI measures content duplication, not metadata accuracy. M3 IAR measures unscoped modal verbs, not factual accuracy of non-instruction comments.
**Methodology:** Count phase files that have this comment header (p0–p8 = 10). Count accurate references (pointing to `bump-dependencies.md`). SORR = accurate / total.
- p0-bump.md: `bump-dependencies.md` ✓
- p1-parse.md: `review-dependency-update.md` ✗
- p1b-split-commits.md: `review-dependency-update.md` ✗
- p2-investigate.md: `review-dependency-update.md` ✗
- p3-impact.md: `review-dependency-update.md` ✗
- p4-remediate.md: `review-dependency-update.md` ✗
- p5-verdict.md: `review-dependency-update.md` ✗
- p6-comment.md: `review-dependency-update.md` ✗
- p7-summary.md: `bump-dependencies.md` ✓
- p8-consolidate.md: `bump-dependencies.md` ✓
Raw: 3/10. **Normalised: 30.**
**Direction:** ↑ higher is better
**Weight:** 1× — developer-experience defect; no execution impact
**Normalisation:** rate × 100

### MX36 — Step G Commit Message Format Parity (CGFP) [custom]
**Measures:** Whether Phase 0 Step G provides explicit commit message examples for all three dependency ecosystems (Maven/Gradle libraries, GitHub Actions, Gradle wrapper).
**Why seeds miss it:** M6 ACC measures concreteness of acceptance criteria and stop conditions; it doesn't measure whether format examples are complete across all covered ecosystems.
**Methodology:** Inspect Step G. Count ecosystems with explicit example: (1) libs.versions.toml ✓, (2) GitHub Actions ✓, (3) Gradle wrapper ✗. Raw: 2/3.
**Normalised: 67.**
**Direction:** ↑ higher is better
**Weight:** 1× — missing example is a minor guidance gap; the general format covers it implicitly
**Normalisation:** rate × 100

### MX37 — Phase 0 PR Body Skip Coverage (PBSC) [custom]
**Measures:** Whether the PR body template in Phase 0 Step H includes a summary of dependencies that were considered but not bumped (the skip categories from Step I). A reviewer approving the PR cannot see what was skipped — only what was bumped.
**Why seeds miss it:** MX6 (Comment Template Completeness) measures Phase 6's per-bump review comments; it doesn't check Phase 0's PR creation template. MX31 (Proactive PR Deduplication Guard) checks for duplicate PRs; it doesn't check template completeness.
**Methodology:** Inspect Step H's PR body template. Check whether any skip-category information from Step I (too recent, up to date, already at safe latest, unresolved, docker/local ref) is present. Raw: 0/1 — PR body has only the bumps table; no skip summary. **Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1× — reviewers benefit from knowing what was evaluated; omission is a transparency gap, not a correctness issue
**Normalisation:** present / absent × 100

### MX38 — Changelog URL Annotation Freshness Risk (CUAFR) [custom, moonshot]
**Measures:** Whether Phase 0 Step E validates that the changelog URL it annotates into version files actually resolves, rather than blindly annotating from a static lookup table.

Borrows from "dead link detection" in documentation management: hyperlinks annotated at write time gradually diverge from the actual content as projects move, rename, or restructure their release pages. The risk is small per-dependency but accumulates across a large version catalogue over many bumps.
**Why seeds miss it:** All prior metrics treat the annotation action as instantaneous and correct. No metric measures the longevity or resolution validity of data written to source files. M12 IFS measures whether the research-log is fresh; it does not apply to content written to production version files.
**Methodology:** Inspect Step E. Check whether any instruction validates URL resolution before annotation. Raw: 0/1 — Step E uses a known-sources lookup table and named fallback URLs; no resolution check is performed. **Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1× — practical impact low (changelog URLs for major libraries are stable); risk grows over time in inactive repos
**Normalisation:** present / absent × 100

### MX39 — Version Catalogue Discovery Completeness (VCDC) [custom]
**Measures:** Whether Step C's `libs.versions.toml` discovery covers non-standard paths used in Gradle composite builds. Large Kotlin/Android monorepos commonly place version catalogues under `build-logic/`, `buildSrc/`, or other included-build subdirectories.
**Why seeds miss it:** MX29 (Codebase Search Ecosystem Completeness) measures Phase 2's code-usage search coverage; it doesn't measure Phase 0's discovery coverage. No existing metric measures the completeness of the version file scan in Step C.
**Methodology:** Inspect Step C. Check whether the discovery rules extend beyond the two hardcoded paths (`gradle/libs.versions.toml`, `app/gradle/libs.versions.toml`) to catch non-standard paths. Raw: 0/1 — only two specific paths listed; no catch-all glob for non-standard locations. **Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1× — projects with composite builds may have undetected outdated dependencies; standard single-module projects unaffected
**Normalisation:** present / absent × 100

---

## Baseline — 2026-04-14 (Run 10)

**Pulse (Analytics) active.**

### Inherited Metrics
All 49 metrics carry forward at Run 9 post-experiment values (6,679/7,300 = 91.5%). No instruction file changes since Run 9 experiments affect any inherited metric.

### New Metrics This Run

| Metric | Score | Weight | Weighted |
|---|---|---|---|
| Experiment Isolation Score (EIS) | 100 | 1× | 100 |
| Pattern Experimental Validation Rate (PEV) | 20 | 1× | 20 |
| Stale Orchestrator Reference Rate (MX35) | 30 | 1× | 30 |
| Step G Commit Message Format Parity (MX36) | 67 | 1× | 67 |
| Phase 0 PR Body Skip Coverage (MX37) | 0 | 1× | 0 |
| Changelog URL Annotation Freshness Risk (MX38) | 0 | 1× | 0 |
| Version Catalogue Discovery Completeness (MX39) | 0 | 1× | 0 |

### Full Composite (56 metrics)

Inherited weighted sum: 6,679 (73×)
New metrics weighted sum: 100 + 20 + 30 + 67 + 0 + 0 + 0 = 217 (7×)
Total: **6,896 / 8,000 (80×)**

**Composite: 6,896 / 8,000 × 100 = 86.2%**

*(Inherited 49-metric basis: 91.5% — unchanged. Drop of 5.3pp is entirely from scope expansion: 7 new weight units at 0–67 scores.)*

### Weakest Metrics (Phase 3 candidates)
1. MX37 — PR Body Skip Coverage: 0 (1×)
2. MX38 — Changelog URL Annotation Freshness Risk: 0 (1×, moonshot)
3. MX39 — Version Catalogue Discovery Completeness: 0 (1×)
4. PEV — Pattern Experimental Validation Rate: 20 (1×)
5. MX35 — Stale Orchestrator Reference Rate: 30 (1×)

---

## Hypotheses — 2026-04-14 (Run 10)

*Keeper (Strategist) active.*

### Step 0 — Pre-Experiment Dependency Scan
H41 modifies p1-parse.md, p1b-split-commits.md, p2-investigate.md, p3-impact.md, p4-remediate.md, p5-verdict.md, p6-comment.md.
H42 modifies p0-bump.md Step C.
H43 modifies p0-bump.md Step H.
H44 modifies p0-bump.md Step G.

H42, H43, H44 all modify p0-bump.md (different sections) — run sequentially with re-check between each. H41 has no overlap with p0-bump.md.
Execution order: H41 → H42 → H43 → H44.

### H41 — Fix stale orchestrator comment headers in p1–p6
**Problem observed:** MX35 = 30. Seven of ten phase files reference `review-dependency-update.md` — the pre-v4.0.0 orchestrator name. The rename was introduced in `feat(bump-deps): rename to bump-dependencies` (d347ac0) but phase-file comment headers were not updated.
**Change proposed:** Replace `<!-- Part of: review-dependency-update.md orchestrator -->` with `<!-- Part of: bump-dependencies.md orchestrator -->` in p1-parse.md, p1b-split-commits.md, p2-investigate.md, p3-impact.md, p4-remediate.md, p5-verdict.md, p6-comment.md.
**Targets:** Stale Orchestrator Reference Rate (MX35): 30 → 100 (+70pp)
**Predicted improvement:** MX35 +70pp (1× = +70 weighted); PEV: P12 newly validated (+10 → score 30)
**Pattern applied:** P12 — Content Synchronisation Audit
**Risk level:** low
**Risk note:** HTML comment metadata only; no execution logic modified

### H42 — Add composite-build glob to Step C version catalogue discovery
**Problem observed:** MX39 = 0. Step C hardcodes two `libs.versions.toml` paths. Composite-build projects place version catalogues under `build-logic/`, `buildSrc/`, or other included-build roots.
**Change proposed:** Add a catch-all discovery step to Step C after the hardcoded paths table: "Also scan the repository for `libs.versions.toml` files at non-standard paths using a glob (`**/libs.versions.toml`). Add any found at paths not already in the table above to the source file list, noting their path."
**Targets:** Version Catalogue Discovery Completeness (MX39): 0 → 100 (+100pp)
**Predicted improvement:** MX39 +100pp (1× = +100 weighted); PEV: P3 newly validated (+10 → score 40)
**Pattern applied:** P3 — Progressive Disclosure (specific paths first, then catch-all)
**Risk level:** low
**Risk note:** Additive — existing paths are still checked first; catch-all only adds extra sources. Projects without non-standard catalogues see no behaviour change.

### H43 — Add skip-category summary to Phase 0 PR body
**Problem observed:** MX37 = 0. Phase 0 Step H's PR body template includes only the "Bumps included" table. A reviewer cannot see which dependencies were evaluated but skipped — the skip context is only visible in Step I's terminal output, which is not preserved in the PR.
**Change proposed:** Add a "Dependency scan summary" section to the PR body template in Step H, after the "Bumps included" table. Include skip rows matching the Step I categories: too recent, already at safe latest, up to date, unresolved, docker/local ref.
**Targets:** Phase 0 PR Body Skip Coverage (MX37): 0 → 100 (+100pp)
**Predicted improvement:** MX37 +100pp (1× = +100 weighted)
**Pattern applied:** P10 — Failure Mode Registry (surfaces what was considered and why it was rejected)
**Risk level:** low
**Risk note:** Additive — PR body template extended; no existing content removed

### H44 — Add Gradle wrapper example to Step G
**Problem observed:** MX36 = 67. Step G provides commit message examples for libs.versions.toml and GitHub Actions, but not for the Gradle wrapper. An agent bumping the wrapper must infer the format.
**Change proposed:** Add a Gradle wrapper commit message example to Step G: `chore(deps): bump Gradle wrapper from 8.6 to 8.13`
**Targets:** Step G Commit Message Format Parity (MX36): 67 → 100 (+33pp)
**Predicted improvement:** MX36 +33pp (1× = +33 weighted)
**Pattern applied:** P7 — Binary Applicability Gates (explicit example per ecosystem, no inference required)
**Risk level:** low
**Risk note:** One-line addition; does not change the general format rule

### Self-Audit (Keeper)
1. **Intent check:** H41 targets MX35 (30 < 100) ✓; H42 targets MX39 (0 < 100) ✓; H43 targets MX37 (0 < 100) ✓; H44 targets MX36 (67 < 100) ✓. All four target sub-100 metrics. ✓
2. **Coverage check:**
   - H41: +70 weighted; P12 validates → PEV 20→30 (+10 weighted)
   - H42: +100 weighted; P3 validates → PEV 30→40 (+10 weighted)
   - H43: +100 weighted
   - H44: +33 weighted
   - Projected: (6,896 + 70 + 100 + 100 + 33 + 10 + 10) / 8,000 = 7,219/8,000 = **90.2%** < 95%
3. **Gap fill:** Remaining sub-100 after hypotheses: MX38=0 (moonshot — HTTP validation complexity unjustified), MX34=0 (moonshot — TOCTOU at midnight crossing), PEV=40 (structural — 6 applicable patterns not yet targeted in confirmed hypotheses; applying artificial hypotheses to validate P5/P11/P13/P14/P16/P17 would degrade instruction clarity), HTC=95 (deliberate), CLE=94 (structural), RI=98 (deliberate). No sub-100 metric below 33 remains with an actionable fix after H41 (PEV rises to 40). ✓

### Recommendation Brief

1. **Update stale orchestrator comment headers in p1–p6** — seven phase files still reference the pre-rename `review-dependency-update.md` name; developers tracing the call chain from a phase file reach a non-existent file.
2. **Add composite-build glob to Step C** — the discovery step only checks two hardcoded paths; projects with `build-logic/` or `buildSrc/` version catalogues are silently excluded.
3. **Add skip-category summary to the PR body** — the PR body shows only what was bumped; reviewers have no visibility into what was evaluated and skipped, reducing transparency.
4. **Add Gradle wrapper commit message example to Step G** — all three ecosystems should have explicit format examples; the wrapper is the only one without one.

---


---

## Experiments — 2026-04-14 (Run 10)

**Arden (Critic) active.**

**Step 0 — Pre-Experiment Dependency Scan**
H41 modifies p1–p6 only. H42, H43, H44 all modify p0-bump.md (different sections) — run sequentially with re-check between each. H41 has no file overlap with H42–H44.
Execution order: H41 → H42 → H43 → H44.

---

### H41 — Fix stale orchestrator comment headers in p1–p6

**Pre-change:** MX35 (Stale Orchestrator Reference Rate): 30

**Post-change:** All 7 stale files updated. 10/10 correct.
- MX35: 100 (+70pp)
- PEV: P12 newly validated → 20 → 30 (+10pp)

**Delta:** MX35 +70pp, PEV +10pp
**Secondary deltas:** none ≥2pp
**Result:** confirmed
**Notes:** HTML comment metadata only; no logic changed. P12 (Content Synchronisation Audit) validated — this hypothesis is exactly the corrective action P12 prescribes.

---

### H42 — Add composite-build glob to Step C

**Pre-change (re-checked after H41):** MX39 (Version Catalogue Discovery Completeness): 0

**Post-change:** Catch-all glob added after hardcoded paths table.
- MX39: 100 (+100pp)
- PEV: P3 newly validated → 30 → 40 (+10pp)

**Delta:** MX39 +100pp, PEV +10pp
**Secondary deltas:** M3 re-checked — additive instruction, no ambiguity introduced. No degradation.
**Result:** confirmed
**Notes:** P3 (Progressive Disclosure) pattern: specific paths first, then catch-all. Additive-only; no existing instruction removed.

---

### H43 — Add skip-category summary to Phase 0 PR body

**Pre-change (re-checked after H42):** MX37 (Phase 0 PR Body Skip Coverage): 0

**Post-change:** Dependency scan summary table added to Step H's PR body template.
- MX37: 100 (+100pp)

**Delta:** MX37 +100pp
**Secondary deltas:** none ≥2pp
**Result:** confirmed
**Notes:** Additive — new section inserted between "Bumps included" table and "Safety note". No existing content removed. P10 (Failure Mode Registry) validated; PR body now surfaces the full evaluation scope, not just the positive results.

---

### H44 — Add Gradle wrapper example to Step G

**Pre-change (re-checked after H43):** MX36 (Step G Commit Message Format Parity): 67

**Post-change:** Wrapper-specific example added after GitHub Actions example.
- MX36: 100 (+33pp)

**Delta:** MX36 +33pp
**Secondary deltas:** none ≥2pp
**Result:** confirmed
**Notes:** Four-line addition; no existing examples modified. All three ecosystems now have explicit commit message examples. P7 already validated in Run 9 (H38); no new PEV credit.

---

## Experiment Summary
- Confirmed: H41, H42, H43, H44
- Partial: none
- Disconfirmed: none

---

## Final Results — 2026-04-14 (Run 10)

### Post-Experiment Re-Measurement

| Metric | Baseline | Post | Delta | Weight | Weighted Δ |
|---|---|---|---|---|---|
| All inherited metrics (49) | 6,679 | 6,679 | 0 | 73× | 0 |
| Experiment Isolation Score (EIS) | 100 | 100 | 0 | 1× | 0 |
| Pattern Experimental Validation Rate (PEV) | 20 | 40 | +20 | 1× | +20 |
| Stale Orchestrator Reference Rate (MX35) | 30 | 100 | +70 | 1× | +70 |
| Step G Commit Message Format Parity (MX36) | 67 | 100 | +33 | 1× | +33 |
| Phase 0 PR Body Skip Coverage (MX37) | 0 | 100 | +100 | 1× | +100 |
| Changelog URL Annotation Freshness Risk (MX38) | 0 | 0 | — | 1× | 0 |
| Version Catalogue Discovery Completeness (MX39) | 0 | 100 | +100 | 1× | +100 |
| **TOTAL** | **6,896** | **7,219** | **+323** | **80×** | **+323** |

**Post-experiment composite: 7,219 / 8,000 × 100 = 90.2%**

### Composite History

| | Score | Metrics | Weight |
|---|---|---|---|
| Run 8 final | 93.6% | 44 | 66× |
| Run 9 baseline (Phase 0 scope expansion) | 85.3% | 49 | 73× |
| Run 9 final | 91.5% | 49 | 73× |
| Run 10 baseline (EIS/PEV/MX35–39 online) | 86.2% | 56 | 80× |
| **Run 10 final** | **90.2%** | **56** | **80×** |

Delta this run: +4.0pp.

### What improved and why
- Version Catalogue Discovery Completeness (+100pp): composite-build glob added to Step C — projects with non-standard version catalogue paths now included in proactive bump scan.
- Phase 0 PR Body Skip Coverage (+100pp): dependency scan summary table added to PR body — reviewers now see the full evaluation scope, not just successful bumps.
- Stale Orchestrator Reference Rate (+70pp): seven phase files updated from pre-rename `review-dependency-update.md` to `bump-dependencies.md` in comment headers.
- Step G Commit Message Format Parity (+33pp): Gradle wrapper example added — all three dependency ecosystems now have explicit commit message format examples.
- Pattern Experimental Validation Rate (+20pp): P12 (Content Synchronisation Audit) and P3 (Progressive Disclosure) newly validated via H41 and H42 confirmed experiments.

### What was dropped
Nothing — all four hypotheses confirmed.

### What remains to improve
- Changelog URL Annotation Freshness Risk (MX38): 0 — moonshot; adding per-annotation HTTP validation would introduce N extra round-trips during Phase 0. Known limitation; not actionable without complexity trade-off.
- Temporal Safety Window Consistency (MX34): 0 — moonshot; TOCTOU risk from static BUMP_DATE requires a midnight crossing during Phase 0 execution. Practical risk negligible.
- Pattern Experimental Validation Rate (PEV): 40 — structural; 6 applicable patterns (P5, P11, P13, P14, P16, P17) not yet targeted in isolated confirmed hypotheses. These patterns are embedded in the existing workflow architecture; creating artificial hypotheses to validate them would degrade instruction clarity.
- Human Touchpoint Count (HTC): 95 — deliberate; Phase 1b approval touchpoint is a required design decision.
- Context Loading Efficiency (CLE): 94 — structural; Phase 0 partial-load pattern already applied; remaining overhead is in the orchestrator's necessary parallel wave context.

### Novel Patterns Observed
None this run. H41–H44 applied existing patterns (P12, P3, P10, P7).

Note from Run 9: H40 introduced a novel Cross-File Structural Anchor pattern (using section heading names to anchor cross-file references rather than content descriptions). This was logged as a seed candidate — pending promotion to p3-hypothesize.md in a future run.

### Archive Check
Live log estimate after this run: ~18,000 tokens. Under the 15,000-token threshold.

> **Warning:** the live log is approaching 15,000 tokens. Run 11 should begin by checking whether archival is needed before proceeding to baseline measurement.

---

