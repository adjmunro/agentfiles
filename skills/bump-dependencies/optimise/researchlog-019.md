<!-- SUMMARY-START -->
## Run 019 — 2026-04-15 | Target: skills/bump-dependencies/
Composite: 87.1% → 91.5% (+4.4 pp)

### Hypotheses
| ID  | Description                                                               | Outcome   |
|-----|---------------------------------------------------------------------------|-----------|
| H69 | Delete orphaned BUMP_BRANCH when user resumes existing PR                 | Confirmed |
| H70 | Add merged C.4 entry annotation to PR body bump table                     | Confirmed |
| H71 | Add --paginate to Phase 2 GitHub Releases API calls                       | Confirmed |
| H72 | Anchor Phase 5 data-source note to Phase 2's exact record format          | Confirmed |
| H73 | Add version drift clause to Step C.5 deduplication                        | Confirmed |

### Metric Snapshot
| Metric                                                        | Baseline | Post  |
|---------------------------------------------------------------|----------|-------|
| Cross-Run Orphaned Branch Cleanup (MX69)                      | 0        | 100   |
| Merged C.4 Entry PR Body Representation (MX70)                | 0        | 100   |
| Phase 2 GitHub Releases Pagination Coverage (MX71)            | 0        | 100   |
| Phase 5 Intermediate Version Source Anchor Precision (MX72)   | 0        | 100   |
| C.4/C.1 Version Drift Handling (MX73)                         | 0        | 100   |
| Composite                                                     | 87.1%    | 91.5% |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

**Pulse (Analytics) active.**

**Target:** `skills/bump-dependencies/`
**Files:** 22 total (11 command, 4 support, 7 logs/archives)
**Token estimate:** ~32,800 tokens (instruction files ~18,800 after H64–H68 additions; support/logs ~14,000)

> Tier C — target matches, log dated 2026-04-15 (≤7 days). Proceeding to Run 17.

### Feature Inventory
Unchanged from Run 16. Multi-phase pipeline ✓, persona system ✓, subagents ✓, parallel execution ✓, cached artifacts ✓.

### Changes Since Run 16
1. **H64**: `--paginate` added to Phase 0 Step D bare-SHA non-match fallback tag lookup.
2. **H65**: New Step C.5 cross-source deduplication added between C.4 and D in p0-bump.md.
3. **H66**: Phase 7 Step B scoped for single-alias failing integration tests path.
4. **H67**: Phase 0 Step H amended with title-pattern cross-run proactive PR deduplication check.
5. **H68**: Phase 5 Step C amended with data-source note for intermediate version list.
6. **Version bumped to 4.11.0**.

### Structural Gaps Introduced or Exposed by H64–H68
- **H67 orphaned branch**: Phase 0 Step H pushes BUMP_BRANCH before the title-pattern check. If the user elects to reuse an existing PR, the newly-pushed BUMP_BRANCH becomes an orphaned remote branch. No deletion instruction is provided.
- **H65 merged entry PR body**: Step C.5 folds C.4 variables into C.1 alias entries; Step H PR body template addresses standalone C.4 rows (`<varName> (<script-file>)`) but gives no guidance for merged entries. A reviewer reading the PR body would not know that a TOML alias row also updates a build script variable.
- **Phase 2 API pagination**: Multi-Version Span Detection uses `gh api repos/<owner>/<repo>/releases?per_page=100` without `--paginate`; the changelog fallback lookup uses `per_page=50` without `--paginate`. For repositories with more than 50–100 releases, intermediate versions may be missed. This is the same gap that MX64 addressed in Phase 0 Step D, now present in Phase 2.
- **Phase 5 anchor imprecision**: H68 data-source note says "read the multi-version span section for the enumerated intermediate release list." Phase 2 does not produce a named section — it produces a `Multi-version span detected: <old> → <new> via <v1>, <v2>, ..., <new>` record. The cross-reference label drifts from the actual format.
- **C.4/C.1 version drift**: Step C.5 folds C.4 variables into C.1 alias entries when coordinates match. No instruction covers the case where the two sources have different current version strings (e.g., TOML says `1.0.0` but the build script variable says `0.9.0`). The dedup step silently proceeds, and the old-version recorded in the commit message would be ambiguous.

### Persona Staleness Check
All 4 personas confirmed present and current (Ink, Echo, Rook, Arden — unchanged).

---

## Phase 2 — Baseline

**Pulse (Analytics) active.**

EIS: 100 (carries forward). PEV: ~56 (carries forward).

### MX69 — Cross-Run Orphaned Branch Cleanup (CROB) [custom]
**Measures:** Whether Phase 0 Step H includes an explicit instruction to delete the newly-pushed BUMP_BRANCH from the remote when the user elects to reuse an existing PR from the cross-run deduplication check.
**Why seeds miss it:** No seed metric measures cleanup completeness for ephemeral branches. P10 (Failure Mode Registry) targets RPC, not branch lifecycle management. H67 introduced the check but the cleanup path was not part of the hypothesis.
**Methodology:** Inspect Phase 0 Step H, "If user chooses existing PR" branch. Current instruction: "record its number as the PR number for this run and proceed directly to Step I without further bumps." No `git push origin --delete <BUMP_BRANCH>` instruction present. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** cleanup_instruction_present × 100

### MX70 — Merged C.4 Entry PR Body Representation (MEPBR) [custom]
**Measures:** Whether Phase 0 Step H's PR body bump table note includes guidance for merged C.4 entries (C.4 variables folded into C.1 alias entries via Step C.5), so the PR body accurately reflects that both the TOML alias and the build script variable were updated in the same commit.
**Why seeds miss it:** M1 IOT measures phase-to-phase artifact reuse; it does not measure whether a phase's output template is complete for all code paths. H65 created Step C.5 but the PR body template was not updated to reflect merged entries.
**Methodology:** Inspect Phase 0 Step H PR body bump table note. Current: "for root build script variable bumps (Step C.4) use `<varName> (<script-file>)` as the Dependency value." This covers standalone C.4 rows only. No guidance for entries folded into C.1 via C.5. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** merged_entry_guidance_present × 100

### MX71 — Phase 2 GitHub Releases Pagination Coverage (P2GRPC) [custom]
**Measures:** Whether Phase 2's GitHub Releases API calls (multi-version span detection and changelog fallback lookup) use `--paginate` to ensure all releases are enumerated for repositories with more than 50–100 releases.
**Why seeds miss it:** MX64 addressed this gap only in Phase 0 Step D. Phase 2 contains two independent GitHub Releases API calls that were not in scope for H64. No seed metric measures pagination completeness in API calls.
**Methodology:** Inspect Phase 2 Pass A. (a) Multi-Version Span Detection: `gh api repos/<owner>/<repo>/releases?per_page=100` — no `--paginate` flag. (b) Changelog fallback lookup: `gh api repos/<owner>/<repo>/releases?per_page=50` — no `--paginate` flag. Two unpaginated calls present. Raw: 0/2 → 0.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** (paginated_calls / total_calls) × 100

### MX72 — Phase 5 Intermediate Version Source Anchor Precision (P5IVP) [custom]
**Measures:** Whether Phase 5 Step C's data-source note references Phase 2's exact output format for the intermediate version list ("`Multi-version span detected:`" record) rather than a vague section label ("multi-version span section").
**Why seeds miss it:** P18 (Cross-File Structural Anchor) targets HCU and IAR; MX72 is the Phase-5-specific instance of this gap. H68 added the data-source note but used a vague section label rather than the exact record prefix from Phase 2.
**Methodology:** Inspect Phase 5 Step C data-source note: "read the multi-version span section for the enumerated intermediate release list." Phase 2 Multi-Version Span Detection output format: "Multi-version span detected: <old> → <new> via <v1>, <v2>, ..., <new>". The note uses "section" — Phase 2 does not produce a named section header; it produces a freeform record. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** exact_format_anchor_present × 100

### MX73 — C.4/C.1 Version Drift Handling (C4C1VD) [custom, moonshot]
**Measures:** Whether Step C.5 specifies what to do when a C.4 variable resolves to the same Maven coordinates as a C.1 TOML alias but has a different current version string — a version drift scenario that could produce an ambiguous "old version" in the bump commit message and may indicate a stale or out-of-sync build script.
**Why seeds miss it:** This borrows a reliability-engineering concept — source-of-truth conflict resolution — and treats it as a scorable property of the deduplication step. No seed metric measures disambiguation logic in data collection pipelines. The scenario is rare but has no prescribed recovery path; an agent encountering it would improvise.
**Methodology:** Inspect Phase 0 Step C.5. Current instruction: "compare the Step C.4 variable list against the Step C.1 alias list by resolved Maven coordinates." No instruction covers the version drift case (C.4 version ≠ C.1 version). Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1× (moonshot)
**Normalisation:** drift_handling_present × 100

### Inherited Metrics
All 85 metrics carry forward at Run 16 post-experiment values (~9,929/10,900 = ~91.1%). No instruction file changes between Run 16 final and this run's audit affect any inherited metric.

### New Metrics This Run

| Metric | Score | Weight | Weighted |
|---|---|---|---|
| Cross-Run Orphaned Branch Cleanup (MX69) | 0 | 1× | 0 |
| Merged C.4 Entry PR Body Representation (MX70) | 0 | 1× | 0 |
| Phase 2 GitHub Releases Pagination Coverage (MX71) | 0 | 1× | 0 |
| Phase 5 Intermediate Version Source Anchor Precision (MX72) | 0 | 1× | 0 |
| C.4/C.1 Version Drift Handling (MX73) | 0 | 1× | 0 |

### Full Composite (90 metrics)

Inherited weighted sum: ~9,929 (109×)
New metrics weighted sum: 0 + 0 + 0 + 0 + 0 = 0 (5×)
Total: **~9,929 / 11,400 (114×)**

**Composite: ~9,929 / 11,400 × 100 = ~87.1%**

*(Drop of ~4.0pp from scope expansion: 5 new weight units at 0.)*

### Weakest Metrics (Phase 3 candidates)
1. MX69 — Cross-Run Orphaned Branch Cleanup: 0 (1×)
2. MX70 — Merged C.4 Entry PR Body Representation: 0 (1×)
3. MX71 — Phase 2 GitHub Releases Pagination Coverage: 0 (1×)
4. MX72 — Phase 5 Intermediate Version Source Anchor Precision: 0 (1×)
5. MX73 — C.4/C.1 Version Drift Handling: 0 (1×, moonshot)

---

## Phase 3 — Hypotheses

*Keeper (Strategist) active.*

### Step 0 — Pre-Experiment Dependency Scan
H69 modifies p0-bump.md (Step H — "If user chooses existing PR" branch).
H70 modifies p0-bump.md (Step H — PR body bump table note).
H71 modifies p2-investigate.md (two API call lines in Pass A).
H72 modifies p5-verdict.md (Step C data-source note).
H73 modifies p0-bump.md (Step C.5 — version drift clause).

File overlaps: H69, H70, H73 all modify p0-bump.md → running sequentially with metric re-check between them.
H71 (p2 only) and H72 (p5 only) are independent of each other and of H69/H70/H73.
Execution order: H71 → H72 → H69 → (re-check) → H70 → (re-check) → H73.

### H69 — Delete orphaned BUMP_BRANCH when user resumes existing PR
**Problem observed:** MX69 = 0. Phase 0 Step H pushes BUMP_BRANCH before the title-pattern cross-run check. If the user elects to reuse an existing PR, BUMP_BRANCH is now an orphaned remote branch (`deps/auto-bump-<BUMP_DATE>`) with no PR attached. No cleanup instruction is given.
**Change proposed:** In p0-bump.md Step H, in the "If user chooses existing PR" branch, after "record its number as the PR number for this run", add: delete the newly-pushed BUMP_BRANCH from remote (`git push origin --delete <BUMP_BRANCH> 2>/dev/null || true`) and check out the base branch locally before proceeding to Step I.
**Targets:** Cross-Run Orphaned Branch Cleanup (MX69): 0 → 100 (+100pp)
**Predicted improvement:** MX69 +100pp (1× = +100 weighted)
**Pattern applied:** P10 — Failure Mode Registry (closes an unhandled branch lifecycle failure mode)
**Risk level:** low
**Risk note:** Deletion is `2>/dev/null || true` so it fails silently if the branch doesn't exist or the push was never made. Additive only.

### H70 — Add merged C.4 entry annotation to PR body bump table
**Problem observed:** MX70 = 0. Step H PR body bump table note addresses standalone C.4 rows but not C.5 merged entries. A reviewer reading the PR body would not know that a TOML alias commit also updates a build script variable.
**Change proposed:** In p0-bump.md Step H PR body bump table note, append guidance: when a C.4 variable was merged into a C.1 alias entry (per Step C.5), annotate the TOML alias row with a parenthetical, e.g. `kotlin (also updates \`kotlinVersion\` in \`build.gradle.kts\`)`.
**Targets:** Merged C.4 Entry PR Body Representation (MX70): 0 → 100 (+100pp)
**Predicted improvement:** MX70 +100pp (1× = +100 weighted)
**Pattern applied:** P12 — Content Synchronisation Audit (Step H PR body template updated to reflect new C.5 code path introduced by H65)
**Risk level:** low
**Risk note:** Additive annotation to the PR body note. The base template structure is unchanged.

### H71 — Add --paginate to Phase 2 GitHub Releases API calls
**Problem observed:** MX71 = 0. Phase 2 Pass A Multi-Version Span Detection uses `gh api repos/<owner>/<repo>/releases?per_page=100` and the changelog fallback uses `per_page=50`, both without `--paginate`. For packages with more than 50–100 releases, intermediate versions are missed and the span may be under-counted.
**Change proposed:** In p2-investigate.md Pass A, (a) add `--paginate` to the Multi-Version Span Detection API call; (b) add `--paginate` to the changelog fallback API call.
**Targets:** Phase 2 GitHub Releases Pagination Coverage (MX71): 0 → 100 (+100pp)
**Predicted improvement:** MX71 +100pp (1× = +100 weighted)
**Pattern applied:** P10 — Failure Mode Registry (closes the pagination-induced missed-versions failure mode, same root cause as H64)
**Risk level:** low
**Risk note:** `--paginate` is a standard `gh api` flag. Slightly more API calls for packages with many releases but functionally correct. `per_page=100` can be kept alongside `--paginate` to minimise the number of pages fetched.

### H72 — Anchor Phase 5 data-source note to Phase 2's exact record format
**Problem observed:** MX72 = 0. Phase 5 Step C data-source note says "read the multi-version span section for the enumerated intermediate release list." Phase 2 does not produce a named section — it produces a `Multi-version span detected:` record. An agent searching for a "section" may fail to locate the record.
**Change proposed:** In p5-verdict.md Step C data-source note, replace "read the multi-version span section for the enumerated intermediate release list" with "look for the 'Multi-version span detected:' record, which lists the intermediate versions in the format '<old> → <new> via <v1>, <v2>, ...'".
**Targets:** Phase 5 Intermediate Version Source Anchor Precision (MX72): 0 → 100 (+100pp)
**Predicted improvement:** MX72 +100pp (1× = +100 weighted)
**Pattern applied:** P18 — Cross-File Structural Anchor (use exact record prefix from Phase 2 output rather than vague section label)
**Risk level:** low
**Risk note:** Pure text clarification. The data source itself (Phase 2 Pass A) is unchanged.

### H73 — Add version drift clause to Step C.5 deduplication
**Problem observed:** MX73 = 0. Step C.5 folds C.4 variables into C.1 alias entries when coordinates match but gives no instruction for the case where the two sources have different current version strings. The dedup step silently proceeds and the commit's "old version" value would be ambiguous.
**Change proposed:** In p0-bump.md Step C.5, after the merge instruction, add a version drift clause: "If the C.4 variable and the C.1 alias list different current versions for the same coordinates, flag the discrepancy in the Step I summary note (e.g., 'Note: `kotlinVersion` in `build.gradle.kts` was at `0.9.0`; `libs.versions.toml` was at `1.0.0` — using TOML value as authoritative old version'). Use the C.1 TOML version as the authoritative old version for the bump commit message."
**Targets:** C.4/C.1 Version Drift Handling (MX73): 0 → 100 (+100pp)
**Predicted improvement:** MX73 +100pp (1× = +100 weighted)
**Pattern applied:** P10 — Failure Mode Registry (adds a recovery path for a previously unhandled edge case)
**Risk level:** low
**Risk note:** Additive clause. The TOML alias is already authoritative per the C.5 design intent; this makes the tiebreak explicit.

### Self-Audit (Keeper)
1. **Intent check:** H69 targets MX69 (0 < 100) ✓; H70 targets MX70 (0 < 100) ✓; H71 targets MX71 (0 < 100) ✓; H72 targets MX72 (0 < 100) ✓; H73 targets MX73 (0 < 100) ✓.
2. **Coverage check:**
   - H69–H73: +100 weighted each → total +500
   - Projected: (~9,929 + 500) / 11,400 = ~10,429 / 11,400 = **~91.5%** < 95%
   - Below 95%; check uncovered gaps. MX49/43/38/34 (moonshots at 0): no tractable hypothesis. PEV ~56: all hypotheses apply previously validated patterns — no new PEV credit this run. No non-moonshot metric below 80 without a hypothesis. ✓
3. **Gap fill:** No non-moonshot metric below 80 is uncovered. ✓

### Recommendation Brief

1. **Delete orphaned BUMP_BRANCH when user resumes existing PR** — Step H pushes the branch before the cross-run check; when the user opts to reuse a prior PR, no cleanup instruction removes the orphaned branch from the remote.
2. **Annotate merged C.4 entries in the PR body bump table** — when Step C.5 folds a build script variable into a TOML alias commit, the PR body row currently shows only the alias name; a reviewer cannot tell that the build script file was also updated.
3. **Add `--paginate` to Phase 2 GitHub Releases API calls** — both the multi-version span detection call and the changelog fallback call use a fixed `per_page` limit without `--paginate`; packages with more releases than the cap will have intermediate versions silently missed.
4. **Anchor Phase 5 data-source note to Phase 2's exact record format** — the note says "multi-version span section" but Phase 2 emits a `Multi-version span detected:` record, not a named section; an agent searching for a section header will not find it.
5. **Add version drift handling to the C.5 deduplication step** — if a C.4 variable and a C.1 TOML alias resolve to the same coordinates but disagree on the current version, the step gives no tiebreak instruction; the authoritative old version for the commit message is ambiguous.

---

## Phase 4 — Experiments

**Arden (Critic) active.**

**Step 0 — Pre-Experiment Dependency Scan**
H69 modifies p0-bump.md (Step H). H70 modifies p0-bump.md (Step H). H71 modifies p2-investigate.md (Pass A). H72 modifies p5-verdict.md (Step C). H73 modifies p0-bump.md (Step C.5).
File overlap: H69, H70, H73 share p0-bump.md → sequential with re-check between them.
Execution order: H71 → H72 → H69 → (re-check) → H70 → (re-check) → H73.

### H71 — Add --paginate to Phase 2 GitHub Releases API calls

**Pre-change:** MX71 (Phase 2 GitHub Releases Pagination Coverage): 0 (0/2 calls paginated)

**Post-change:** Phase 2 Pass A amended at two points:
1. Multi-Version Span Detection: `gh api repos/<owner>/<repo>/releases?per_page=100` → `gh api repos/<owner>/<repo>/releases?per_page=100 --paginate`
2. Changelog fallback lookup: `gh api repos/<owner>/<repo>/releases?per_page=50` → `gh api repos/<owner>/<repo>/releases?per_page=100 --paginate` (also standardised `per_page` to 100 to reduce page count)
- MX71: 100 (+100pp)

**Delta:** MX71 +100pp
**Secondary deltas:** RPC re-checked — both Phase 2 API calls now have complete coverage. No degradation.
**Result:** confirmed
**Notes:** P10 (Failure Mode Registry) applied — same root cause as H64 (Phase 0 Step D pagination gap), now closed in Phase 2. P10 already validated; no new PEV credit.

### H72 — Anchor Phase 5 data-source note to Phase 2's exact record format

**Pre-change:** MX72 (Phase 5 Intermediate Version Source Anchor Precision): 0

**Post-change:** Phase 5 Step C data-source note updated to replace "read the multi-version span section for the enumerated intermediate release list" with "look for the 'Multi-version span detected:' record, which lists the intermediate versions in the format '<old> → <new> via <v1>, <v2>, ...'". The exact record prefix from Phase 2's output is now used as the anchor.
- MX72: 100 (+100pp)

**Delta:** MX72 +100pp
**Secondary deltas:** M3 IAR re-checked — the note now uses a deterministic cross-reference ("look for the 'Multi-version span detected:' record") rather than a vague label ("section"). Minor positive. No degradation.
**Result:** confirmed
**Notes:** P18 (Cross-File Structural Anchor) applied — exact record prefix used rather than vague section label. P18 previously validated; no new PEV credit.

### H69 — Delete orphaned BUMP_BRANCH when user resumes existing PR

**Pre-change (re-checked after H71/H72):** MX69 (Cross-Run Orphaned Branch Cleanup): 0

**Post-change:** Phase 0 Step H "If user chooses existing PR" branch amended. After "record its number as the PR number for this run", added: delete the newly-pushed BUMP_BRANCH from remote and check out the base branch locally before proceeding to Step I.
- MX69: 100 (+100pp)

**Delta:** MX69 +100pp
**Secondary deltas:** RPC re-checked — the branch lifecycle failure mode is now closed. No degradation.
**Result:** confirmed
**Notes:** P10 (Failure Mode Registry) applied — closes the orphaned-branch failure mode introduced by H67. P10 already validated; no new PEV credit.

### H70 — Add merged C.4 entry annotation to PR body bump table

**Pre-change (re-checked after H69):** MX70 (Merged C.4 Entry PR Body Representation): 0

**Post-change:** Phase 0 Step H PR body bump table note extended. After the existing guidance for standalone C.4 rows, added: when a C.4 variable was merged into a C.1 alias entry via Step C.5, annotate the alias row with a parenthetical (e.g. `kotlin (also updates \`kotlinVersion\` in \`build.gradle.kts\`)`).
- MX70: 100 (+100pp)

**Delta:** MX70 +100pp
**Secondary deltas:** M1 IOT re-checked — the PR body now traces both the TOML alias and the merged build script variable. No degradation.
**Result:** confirmed
**Notes:** P12 (Content Synchronisation Audit) applied — Step H PR body template updated to reflect the C.5 code path introduced by H65. P12 already validated; no new PEV credit.

### H73 — Add version drift clause to Step C.5 deduplication

**Pre-change (re-checked after H70):** MX73 (C.4/C.1 Version Drift Handling): 0

**Post-change:** Phase 0 Step C.5 extended with a version drift clause: if the C.4 variable and the C.1 alias resolve to the same coordinates but list different current version strings, the TOML value is used as the authoritative old version for the bump commit message, and the discrepancy is noted in the Step I summary.
- MX73: 100 (+100pp)

**Delta:** MX73 +100pp
**Secondary deltas:** M3 IAR re-checked — the tiebreak ("use the C.1 TOML version as authoritative") is deterministic. No degradation.
**Result:** confirmed
**Notes:** P10 (Failure Mode Registry) applied — adds recovery path for the version-drift edge case in the C.5 dedup step. P10 already validated; no new PEV credit.

## Experiment Summary (Run 17)
- Confirmed: H69, H70, H71, H72, H73
- Partial: none
- Disconfirmed: none

---

## Phase 5 — Report

| Metric | Baseline | Post | Delta | Weight | Weighted Δ |
|---|---|---|---|---|---|
| All inherited metrics (85) | ~9,929 | ~9,929 | 0 | 109× | 0 |
| Cross-Run Orphaned Branch Cleanup (MX69) | 0 | 100 | +100 | 1× | +100 |
| Merged C.4 Entry PR Body Representation (MX70) | 0 | 100 | +100 | 1× | +100 |
| Phase 2 GitHub Releases Pagination Coverage (MX71) | 0 | 100 | +100 | 1× | +100 |
| Phase 5 Intermediate Version Source Anchor Precision (MX72) | 0 | 100 | +100 | 1× | +100 |
| C.4/C.1 Version Drift Handling (MX73) | 0 | 100 | +100 | 1× | +100 |
| **TOTAL** | **~9,929** | **~10,429** | **+500** | **114×** | **+500** |

**Post-experiment composite: ~10,429 / 11,400 × 100 = ~91.5%**

### Composite History

| | Score | Metrics | Weight |
|---|---|---|---|
| Run 16 final | ~91.1% | 85 | 109× |
| Run 17 baseline | ~87.1% | 90 | 114× |
| **Run 17 final** | **~91.5%** | **90** | **114×** |

Delta this run: +4.4pp (all primary metrics exact).

### What improved and why
- Cross-Run Orphaned Branch Cleanup (+100pp): Step H "resume existing PR" branch now deletes the newly-pushed BUMP_BRANCH from remote — prevents dangling branches when the skill resumes a prior run.
- Merged C.4 Entry PR Body Representation (+100pp): Step H PR body bump table note now instructs annotating the TOML alias row when a C.4 variable was merged into it via Step C.5 — reviewers can see both files were updated.
- Phase 2 GitHub Releases Pagination Coverage (+100pp): both GitHub Releases API calls in Phase 2 Pass A now include `--paginate` — intermediate versions are no longer truncated at 50 or 100 results for active packages.
- Phase 5 Intermediate Version Source Anchor Precision (+100pp): Phase 5 Step C data-source note now references the exact Phase 2 output format (`Multi-version span detected:` record) — agents can reliably locate the intermediate version list.
- C.4/C.1 Version Drift Handling (+100pp): Step C.5 now has an explicit tiebreak when TOML and build script disagree on the current version — TOML is authoritative and the discrepancy is surfaced in the Step I summary.

### What was dropped
Nothing — all five hypotheses confirmed.

### What remains to improve
- Multi-Catalogue Dependency Deduplication Coverage (MX49): 0 — moonshot; carries forward from Runs 11–17.
- Pre-Bump Base Branch CI Health Check (MX43): 0 — moonshot; carries forward.
- Changelog URL Annotation Freshness Risk (MX38): 0 — moonshot; carries forward.
- Temporal Safety Window Consistency (MX34): 0 — moonshot; carries forward.
- Pattern Experimental Validation Rate (PEV): ~56 — structural; no new patterns validated this run (H69/H70/H73 applied P10; H71 applied P10; H72 applied P18 — all previously validated). Dormant patterns (P5, P13, P14, P17) remain unvalidatable without artificial hypotheses.

### Novel Patterns Observed
None this run. H69/H70/H73 applied P10; H71 applied P10; H72 applied P18.
