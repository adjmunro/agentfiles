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


---

## Audit — 2026-04-14 (Run 11)

**Pulse (Analytics) active.**

**Target:** `skills/bump-dependencies/`
**Files:** 21 total (11 command, 4 support, 6 logs/archives)
**Token estimate:** ~29,500 tokens

> Tier C — target matches, log is from today (≤7 days). Archive completed before this run (live log ~5,700 tokens). Proceeding.

### Feature Inventory
Unchanged from Run 10. Multi-phase pipeline ✓, persona system ✓, subagents ✓, parallel execution ✓, cached artifacts ✓.

### Changes Since Run 10
1. **H41**: p1–p6 orchestrator comment headers corrected to `bump-dependencies.md`.
2. **H42**: Composite-build glob added to Step C.
3. **H43**: Skip-category summary added to Step H PR body template.
4. **H44**: Gradle wrapper example added to Step G.
5. **Version bumped to 4.5.0**.

### Remaining structural gaps identified in Run 10 Phase 5
- Step C lists root Gradle build scripts as a source type but has no extraction step (Step C.4 absent).
- Step D batch script has no recovery instruction for individual `fetch_*` call failures.
- BOM alias handling: Step C.1 notes "unresolved and skip" but no downstream guidance.
- Pre-bump base branch CI state: not checked before Phase 0 begins (moonshot).

### Persona Staleness Check
All 4 personas confirmed present and current (unchanged).

---

## Custom Metrics — 2026-04-14 (Run 11)

**Pulse (Analytics) active.**

EIS: 100 (carries forward from Run 10). PEV: 40 (carries forward).

### MX40 — Phase 0 Root Build Script Extraction Coverage (RBSEC) [custom]
**Measures:** Whether Phase 0 provides explicit version-extraction instructions for root Gradle build scripts (a declared source type in Step C).
**Why seeds miss it:** M4 WCS measures persona wiring, not instruction completeness. No prior metric checks whether every source type in Step C has a corresponding extraction step (C.1 for TOML, C.2 for Actions, C.3 for wrapper — root build scripts have no C.4).
**Methodology:** Check Step C's source type table. For each declared source type, verify a corresponding extraction section exists.
- Gradle version catalogue → Step C.1 ✓
- GitHub Actions → Step C.2 ✓
- Local composite actions → Step C.2 ✓ (same section)
- Gradle wrapper → Step C.3 ✓
- Root Gradle build scripts → no extraction section ✗
Raw: 4/5 source types with extraction steps. **Normalised: 80.**
**Direction:** ↑ higher is better
**Weight:** 1× — any project with root-level version declarations will have them silently skipped
**Normalisation:** rate × 100

### MX41 — Batch Lookup Partial Failure Recovery (BPFR) [custom]
**Measures:** Whether Step D specifies recovery behaviour when individual `fetch_maven`, `fetch_plugin`, or `fetch_action` calls in the batch script fail (network error, API rate limit, malformed response).
**Why seeds miss it:** RPC covers Phase 0 recovery paths for precondition failures (non-GitHub remote, unauthenticated gh, dirty working tree). It does not cover mid-execution API failures within the batch script. The P16 pattern (Generated Batch Script) assumes batch success; partial failures are a known failure mode of batch approaches.
**Methodology:** Inspect Step D. Check whether there is any instruction for handling a fetch function that returns no output or a non-zero exit code. Raw: 0/1. **Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1× — partial batch failures leave some dependencies unchecked without notification; the PR would appear to cover all dependencies
**Normalisation:** present / absent × 100

### MX42 — BOM Alias Downstream Impact Coverage (BADC) [custom]
**Measures:** Whether Step C.1 provides guidance on what to do with BOM aliases beyond recording them as "unresolved." BOMs control transitive dependency versions; a stale BOM could mask outdated transitive dependencies invisible to the direct-dependency scan.
**Why seeds miss it:** No prior metric measures handling of indirect/BOM-managed versions. MX9 (Pre-Release Version Handling, Phase 2) covers version range edge cases in investigation, not Phase 0 discovery.
**Methodology:** Inspect Step C.1's treatment of BOM aliases. Check whether there is any instruction beyond "note it as unresolved and skip it."
- Unresolved are noted and skipped ✓ (partial)
- Downstream guidance (flag for manual review, note in PR body, or recommend Phase 2 investigation): none ✗
Raw: 0.5/1. **Normalised: 50.**
**Direction:** ↑ higher is better
**Weight:** 1× — BOMs are common in Android projects; missing coverage is a latent gap
**Normalisation:** rate × 100

### MX43 — Pre-Bump Base Branch CI Health Check (PBBCI) [custom, moonshot]
**Measures:** Whether Phase 0 checks that CI is currently passing on the base branch before creating bump commits. If the base branch is red when Phase 0 runs, Phase 1's CI failure triage will falsely attribute pre-existing failures to the bump. A single CI-status check at the start of Phase 0 would allow Phase 1 to distinguish pre-existing failures from bump-induced ones.

Borrows from "baseline measurement" in A/B testing: any experiment result is only meaningful relative to a clean control baseline. A CI check before Phase 0 is the dependency-bump equivalent of confirming the control group is healthy before running the experiment.
**Methodology:** Inspect Phase 0 Step A. Check whether there is any instruction to check CI status on the base branch. Raw: 0/1. **Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1× — practical impact moderate; Phase 1 triage could still distinguish failures by date, but pre-Phase-0 CI state is never captured
**Normalisation:** present / absent × 100

### MX44 — Step G Commit Body Ecosystem Specificity (CBES) [custom]
**Measures:** Whether Step G's commit body instruction specifies which dependency ecosystems provide release descriptions in their API responses (making the "if immediately available" clause unambiguous). The GitHub Actions GraphQL response includes release descriptions; Maven and Gradle Plugin Portal APIs do not.
**Why seeds miss it:** M6 ACC measures whether acceptance criteria are concrete; it scored Step G's "if immediately available" language as passing (the condition is testable). The gap is that without knowing which APIs provide descriptions, an agent must trial-and-error per ecosystem.
**Methodology:** Inspect Step G's commit body guidance. Check whether it names which ecosystems provide API-returned release descriptions.
- General conditional instruction: ✓ (present)
- Ecosystem-specific note (GitHub Actions yes, Maven/Gradle Portal no, Gradle wrapper no): ✗
Raw: 0.5/1. **Normalised: 75.**
**Direction:** ↑ higher is better
**Weight:** 1× — minor guidance gap; the conditional language already handles the case correctly
**Normalisation:** rate × 100

---

## Baseline — 2026-04-14 (Run 11)

**Pulse (Analytics) active.**

### Inherited Metrics
All 56 metrics carry forward at Run 10 post-experiment values (7,219/8,000 = 90.2%). No instruction file changes since Run 10 affect any inherited metric.

### New Metrics This Run

| Metric | Score | Weight | Weighted |
|---|---|---|---|
| Phase 0 Root Build Script Extraction Coverage (MX40) | 80 | 1× | 80 |
| Batch Lookup Partial Failure Recovery (MX41) | 0 | 1× | 0 |
| BOM Alias Downstream Impact Coverage (MX42) | 50 | 1× | 50 |
| Pre-Bump Base Branch CI Health Check (MX43) | 0 | 1× | 0 |
| Step G Commit Body Ecosystem Specificity (MX44) | 75 | 1× | 75 |

### Full Composite (61 metrics)

Inherited weighted sum: 7,219 (80×)
New metrics weighted sum: 80 + 0 + 50 + 0 + 75 = 205 (5×)
Total: **7,424 / 8,500 (85×)**

**Composite: 7,424 / 8,500 × 100 = 87.3%**

### Weakest Metrics
1. MX41 — Batch Lookup Partial Failure Recovery: 0 (1×)
2. MX43 — Pre-Bump Base Branch CI Health Check: 0 (1×, moonshot)
3. MX42 — BOM Alias Downstream Impact Coverage: 50 (1×)
4. MX38 — Changelog URL Annotation Freshness Risk: 0 (1×, moonshot)
5. MX34 — Temporal Safety Window Consistency: 0 (1×, moonshot)

---

## Hypotheses — 2026-04-14 (Run 11)

*Keeper (Strategist) active.*

### Step 0 — Pre-Experiment Dependency Scan
H45 modifies p0-bump.md Step C (adds Step C.4).
H46 modifies p0-bump.md Step D (adds failure recovery note).
H47 modifies p0-bump.md Step C.1 (extends BOM alias handling).
H48 modifies p0-bump.md Step G (adds ecosystem specificity).

H45, H46, H47, H48 all modify p0-bump.md (different sections) — run sequentially with metric re-check between each.
Execution order: H45 → H46 → H47 → H48.

### H45 — Add Step C.4 for root build script version extraction
**Problem observed:** MX40 = 80. Step C lists root Gradle build scripts as a source type but has no corresponding extraction step. An agent reading Step C hits Step C.1/C.2/C.3 for three source types but finds nothing for root build scripts.
**Change proposed:** Add Step C.4 immediately after Step C.3: scan root build scripts for top-level version variable declarations (Kotlin DSL `val name = "X.Y.Z"` and Groovy `ext.name = "X.Y.Z"` / `ext { name = "X.Y.Z" }`). For each candidate, search the file to determine what dependency it controls. If identifiable, record with `ecosystem: maven` or `gradle-plugin`; if not, record as unresolved.
**Targets:** Phase 0 Root Build Script Extraction Coverage (MX40): 80 → 100 (+20pp)
**Predicted improvement:** MX40 +20pp (1× = +20 weighted)
**Pattern applied:** P3 — Progressive Disclosure (extends the existing C.1/C.2/C.3 per-source-type pattern)
**Risk level:** low
**Risk note:** Additive; does not modify existing extraction steps. Root build script versions are a legacy pattern in modern Android projects; the catch-all step handles them without breaking projects that don't have them.

### H46 — Add batch lookup partial failure recovery to Step D
**Problem observed:** MX41 = 0. Step D's batch script runs `fetch_*` functions concurrently with `&` and `wait`. If individual fetch calls fail (network error, API timeout, rate limit), they produce no output. The parse step then finds no entry for that dependency — silently treating it as up-to-date rather than flagging it as a lookup failure.
**Change proposed:** Add a recovery note to Step D immediately after the "Parse the output" paragraph: "If a dependency is absent from the batch output (no row for its coordinates), record it as **Skipped (lookup failed)** in the Step I summary and exclude it from this run's bumps. Do not stop Phase 0 for a single lookup failure — continue with the remaining dependencies."
**Targets:** Batch Lookup Partial Failure Recovery (MX41): 0 → 100 (+100pp)
**Predicted improvement:** MX41 +100pp (1× = +100 weighted); PEV: P16 newly validated (+10 → score 50)
**Pattern applied:** P16 — Generated Batch Script (this recovery note is the canonical failure-mode companion for the P16 pattern)
**Risk level:** low
**Risk note:** Additive — the normal path (all fetches succeed) is unaffected

### H47 — Add downstream guidance for BOM alias handling
**Problem observed:** MX42 = 50. Step C.1 tells the agent to "note it as unresolved and skip it" for BOM aliases, but provides no guidance on whether to flag them for the reviewer or investigate them in Phase 2.
**Change proposed:** Extend the BOM alias handling instruction in Step C.1: after "note it as **unresolved** and skip it", add "Include unresolved (BOM/indirect) aliases in the Step I summary under 'Skipped (unresolved)'. A reviewer should verify that BOM-managed transitive dependencies are not outdated."
**Targets:** BOM Alias Downstream Impact Coverage (MX42): 50 → 100 (+50pp)
**Predicted improvement:** MX42 +50pp (1× = +50 weighted)
**Pattern applied:** P10 — Failure Mode Registry (surfaces the gap to reviewers rather than silently absorbing it)
**Risk level:** low
**Risk note:** Additive — extends the existing "record as unresolved" instruction; no change to resolution logic

### H48 — Add ecosystem-specific commit body guidance to Step G
**Problem observed:** MX44 = 75. Step G's commit body instruction says "may include the changelog URL and a one-sentence summary if immediately available from the API response." This is technically correct but doesn't specify which ecosystems provide API-returned descriptions — requiring agents to discover this empirically.
**Change proposed:** Add an ecosystem note to Step G's commit body guidance: "Note: GitHub Actions GraphQL responses include release description text — use it for the summary sentence. Maven search (solrsearch) and the Gradle Plugin Portal API do not include release descriptions — for these ecosystems, include only the changelog URL."
**Targets:** Step G Commit Body Ecosystem Specificity (MX44): 75 → 100 (+25pp)
**Predicted improvement:** MX44 +25pp (1× = +25 weighted)
**Pattern applied:** P7 — Binary Applicability Gates (explicit per-ecosystem rule eliminates the ambiguity)
**Risk level:** low
**Risk note:** Informational addendum — does not change what gets committed, only clarifies which ecosystems supply rich API responses

### Self-Audit (Keeper)
1. **Intent check:** H45 targets MX40 (80 < 100) ✓; H46 targets MX41 (0 < 100) ✓; H47 targets MX42 (50 < 100) ✓; H48 targets MX44 (75 < 100) ✓. ✓
2. **Coverage check:**
   - H45: +20 weighted
   - H46: +100 weighted; P16 newly validated → PEV 40→50 (+10 weighted)
   - H47: +50 weighted
   - H48: +25 weighted
   - Projected: (7,424 + 20 + 100 + 10 + 50 + 25) / 8,500 = 7,629/8,500 = **89.8%** < 95%
3. **Gap fill:** MX43=0 (moonshot — adding a touchpoint would degrade HTC; read-only CI check would add a Step A API call but without a decision gate; not actionable without redesign), MX38=0 (moonshot), MX34=0 (moonshot), PEV=50 (structural — 5 patterns now validated; P5/P11/P13/P14/P17 not yet validated in isolated confirmed hypotheses; artificially applying them would degrade clarity). All sub-80 metrics have hypotheses targeting them: MX41 (0), MX42 (50) — both targeted by H46/H47. MX43=0 (moonshot exempt). After experiments: no metric below 33 with an actionable fix remaining. ✓

### Recommendation Brief

1. **Add Step C.4 for root build scripts** — root Gradle build scripts are a declared source type in Step C but have no extraction step; agents will skip them silently rather than flag the gap.
2. **Add batch partial failure recovery** — if individual API lookups fail during the batch script, dependencies are silently excluded from the bump run with no indication in the summary; a one-line recovery note prevents silent omissions.
3. **Add BOM alias downstream guidance** — BOM aliases are currently noted as "unresolved and skip" with no instruction to surface them in the output; a reviewer note ensures the gap is visible.
4. **Add ecosystem-specific API note to Step G** — clarifying which APIs provide release descriptions removes the need for agents to trial-and-error per ecosystem.

---


---

## Experiments — 2026-04-14 (Run 11)

**Arden (Critic) active.**

**Step 0 — Pre-Experiment Dependency Scan**
H45, H46, H47, H48 all modify p0-bump.md (different sections). No cross-hypothesis file overlap beyond p0-bump.md itself. Running sequentially with re-check between each.
Execution order: H45 → H46 → H47 → H48.

---

### H45 — Add Step C.4 for root build script version extraction

**Pre-change:** MX40 (Root Build Script Extraction Coverage): 80 (4/5 source types covered)

**Post-change:** Step C.4 added. Kotlin DSL `val name = "X.Y.Z"` and Groovy `ext.name = "X.Y.Z"` / `ext {}` block patterns covered. 5/5 source types now have extraction steps.
- MX40: 100 (+20pp)

**Delta:** MX40 +20pp
**Secondary deltas:** M3 re-checked — additive instructions, no ambiguity introduced. No degradation.
**Result:** confirmed
**Notes:** P3 (Progressive Disclosure) applied — extends the existing C.1/C.2/C.3 pattern. P3 already validated (Run 10 H42); no new PEV credit.

---

### H46 — Add batch lookup partial failure recovery

**Pre-change (re-checked after H45):** MX41 (Batch Lookup Partial Failure Recovery): 0

**Post-change:**
- Recovery note added to Step D: absent coordinates → Skipped (lookup failed)
- "Skipped (lookup failed)" row added to Step I summary and PR body skip table

MX41: 100 (+100pp). PEV: P16 newly validated → 40→50 (+10pp).

**Delta:** MX41 +100pp, PEV +10pp
**Secondary deltas:** MX37 re-checked — PR body skip table now has 6 categories instead of 5; still fully covering all skip paths → 100 (unchanged). No degradation.
**Result:** confirmed
**Notes:** P16 (Generated Batch Script) validated — this recovery note is the canonical failure-mode companion to the batch pattern itself. P16 becomes the fifth validated pattern in the live log.

---

### H47 — Add downstream guidance for BOM alias handling

**Pre-change (re-checked after H46):** MX42 (BOM Alias Downstream Impact Coverage): 50

**Post-change:** Step C.1 BOM alias note extended — "Include it in the Step I summary under 'Skipped (unresolved)' and add a note in the PR body row: 'BOM/indirect — transitive dependency versions not checked; manual review recommended.'"
- MX42: 100 (+50pp)

**Delta:** MX42 +50pp
**Secondary deltas:** M6 ACC re-checked — new note is concrete (named row, named message) → 100 (unchanged).
**Result:** confirmed
**Notes:** P10 (Failure Mode Registry) applied — surfaces the gap to reviewers. P10 already validated (Run 9 H39); no new PEV credit.

---

### H48 — Add ecosystem-specific commit body guidance

**Pre-change (re-checked after H47):** MX44 (Step G Commit Body Ecosystem Specificity): 75

**Post-change:** Ecosystem note added: GitHub Actions GraphQL → descriptions available; Maven/Gradle Portal/wrapper → descriptions not available.
- MX44: 100 (+25pp)

**Delta:** MX44 +25pp
**Secondary deltas:** none ≥2pp
**Result:** confirmed
**Notes:** P7 (Binary Applicability Gates) applied — ecosystem-specific rule eliminates trial-and-error. P7 already validated; no new PEV credit.

---

## Experiment Summary
- Confirmed: H45, H46, H47, H48
- Partial: none
- Disconfirmed: none

---

## Final Results — 2026-04-14 (Run 11)

### Post-Experiment Re-Measurement

| Metric | Baseline | Post | Delta | Weight | Weighted Δ |
|---|---|---|---|---|---|
| All inherited metrics (56) | 7,219 | 7,219 | 0 | 80× | 0 |
| Phase 0 Root Build Script Extraction Coverage (MX40) | 80 | 100 | +20 | 1× | +20 |
| Batch Lookup Partial Failure Recovery (MX41) | 0 | 100 | +100 | 1× | +100 |
| BOM Alias Downstream Impact Coverage (MX42) | 50 | 100 | +50 | 1× | +50 |
| Pre-Bump Base Branch CI Health Check (MX43) | 0 | 0 | — | 1× | 0 |
| Step G Commit Body Ecosystem Specificity (MX44) | 75 | 100 | +25 | 1× | +25 |
| Pattern Experimental Validation Rate (PEV) | 40 | 50 | +10 | 1× | +10 |
| **TOTAL** | **7,424** | **7,629** | **+205** | **85×** | **+205** |

**Post-experiment composite: 7,629 / 8,500 × 100 = 89.8%**

### Composite History

| | Score | Metrics | Weight |
|---|---|---|---|
| Run 9 final | 91.5% | 49 | 73× |
| Run 10 baseline | 86.2% | 56 | 80× |
| Run 10 final | 90.2% | 56 | 80× |
| Run 11 baseline | 87.3% | 61 | 85× |
| **Run 11 final** | **89.8%** | **61** | **85×** |

Delta this run: +2.5pp.

### What improved and why
- Batch Lookup Partial Failure Recovery (+100pp): recovery note added to Step D — silent API failures now surface as "Skipped (lookup failed)" rather than appearing as up-to-date.
- BOM Alias Downstream Impact Coverage (+50pp): BOM aliases now flagged in PR body with manual review recommendation — transitive dependency gaps are no longer invisible.
- Step G Commit Body Ecosystem Specificity (+25pp): explicit note on which APIs provide release descriptions eliminates per-ecosystem trial-and-error.
- Phase 0 Root Build Script Extraction Coverage (+20pp): Step C.4 added — root build script version declarations now have defined extraction logic.
- Pattern Experimental Validation Rate (+10pp): P16 (Generated Batch Script) newly validated via H46 — PEV now 50% (5/10 applicable patterns confirmed).

### What was dropped
Nothing — all four hypotheses confirmed.

### What remains to improve
- Pre-Bump Base Branch CI Health Check (MX43): 0 — moonshot; a pre-Phase-0 CI status check would add a `gh run list` call to Step A but without a user decision gate it would only surface as a warning, not prevent false failure attribution. Deferred pending a design decision on whether to add a human touchpoint.
- Changelog URL Annotation Freshness Risk (MX38): 0 — moonshot (dead-link accumulation over time).
- Temporal Safety Window Consistency (MX34): 0 — moonshot (TOCTOU at midnight).
- Pattern Experimental Validation Rate (PEV): 50 — structural; 5 patterns now validated (P3, P7, P10, P12, P16); remaining 5 (P5, P11, P13, P14, P17) are embedded in the workflow design rather than isolated hypothesis targets.

### Novel Patterns Observed
None this run. H45–H48 applied existing patterns (P3, P16, P10, P7).

**Promotion pending (from Run 9 H40):** Cross-File Structural Anchor — a novel pattern for using section heading names as cross-file reference anchors rather than content descriptions. Identified as seed candidate in Run 9. Still pending promotion to `skills/optimise/commands/phases/p3-hypothesize.md`.

### Archive Check
Live log size after this run: ~15,000 tokens (estimated). At the threshold — Run 12 should archive before proceeding.

---

