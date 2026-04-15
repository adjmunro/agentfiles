## Archive: see research-log-archive-2026-04-15.md for Runs 12–14 (2026-04-15). See research-log-archive-2026-04-14c.md for Runs 10–11 (2026-04-14). See research-log-archive-2026-04-14b.md for Run 9 (2026-04-14). See research-log-archive-2026-04-14.md for Runs 1–8.

---

## Audit — 2026-04-15 (Run 16)

**Pulse (Analytics) active.**

**Target:** `skills/bump-dependencies/`
**Files:** 22 total (11 command, 4 support, 7 logs/archives)
**Token estimate:** ~32,200 tokens (instruction files ~18,200 after H59–H63 additions; support/logs ~14,000)

> Tier C — target matches, log dated 2026-04-15 (≤7 days). Proceeding to Run 16.

### Feature Inventory
Unchanged from Run 15. Multi-phase pipeline ✓, persona system ✓, subagents ✓, parallel execution ✓, cached artifacts ✓.

### Changes Since Run 15
1. **H59**: Phase 7 single-alias skip condition amended — conditional on Phase 8 integration test result (pass or no tests run → skip Steps B–C; tests failed → proceed to Steps B–C to surface bisect finding).
2. **H60**: Phase 5 scoring matrix row updated: "Multi-version span (≥3 intermediate versions skipped)" → "Multi-version span (≥2 intermediate versions traversed — see Phase 2 definition)". Explanatory note cross-references Phase 2 instead of contradictory parenthetical.
3. **H61**: Phase 0 Step D bare-SHA non-match fallback added: targeted `git/refs/tags` API call, annotated-tag dereference step, conservative `unknown` treatment with upgrade.
4. **H62**: Phase 8 Step F expanded — all-skipped early exit now deletes the remote PR head branch to prevent dangling `deps/auto-bump-<date>` branches.
5. **H63**: Phase 0 Step H PR body bump table extended with C.4 variable format note (`<varName> (<script-file>)`).
6. **Version bumped to 4.10.0**.

### Structural Gaps Introduced or Exposed by H59–H63
- Phase 0 Step D bare-SHA non-match fallback (H61) calls `gh api repos/<owner>/<action>/git/refs/tags --jq '...'` without the `--paginate` flag. GitHub's REST API returns only the first 30 results by default. For actions with more than 30 releases, the target SHA may not appear in the first page; the fallback would incorrectly conclude it is unresolvable and record the version as `unknown`.
- Phase 0 Steps C.1 and C.4 may independently discover the same dependency: C.1 collects TOML aliases by Maven coordinates, C.4 collects root build script variables and resolves them to coordinates. If both resolve to the same `group:artifact`, no deduplication step is specified before Step D. The same dependency could receive two separate lookup + bump + commit sequences.
- Phase 7's H59 addition routes single-alias PRs with failing integration tests through Steps B–C. Step B's comment template is designed for multi-alias PRs and includes the full alias table, overall verdict, remediations, and warnings — duplicating nearly all content already in the Phase 6 comment. No scope-narrowing instruction limits the comment to only new Phase 8 data (integration test result and bisect finding) for the single-alias case.
- Phase 0 Step H deduplication check is branch-specific (`--head <BUMP_BRANCH>`). If a prior run's proactive PR (on `deps/auto-bump-<older-date>`) is still open when the skill runs again, the check misses it and creates a second open proactive PR. No title-based or broader cross-run deduplication is specified.
- Phase 5 Step C verdict block template includes `| multi — <count> intermediate versions traversed: <v1>, <v2>, ...` but Phase 5 gives no instruction on where to retrieve the intermediate version list. An agent executing Phase 5 as a subagent would not know to read Phase 2's multi-version span detection data.

### Persona Staleness Check
All 4 personas confirmed present and current (Ink, Echo, Rook, Arden — unchanged).

---

## Custom Metrics — 2026-04-15 (Run 16)

**Pulse (Analytics) active.**

EIS: 100 (carries forward). PEV: ~56 (carries forward).

### MX64 — Bare-SHA Fallback Pagination Coverage (BSF_PC) [custom]
**Measures:** Whether Phase 0 Step D's bare-SHA non-match fallback uses `--paginate` when calling `gh api repos/<owner>/<action>/git/refs/tags` to ensure all tags are searched across multiple pages.
**Why seeds miss it:** No seed metric measures pagination completeness in API calls. H61 added the fallback but the pagination gap was not detected in Run 15.
**Methodology:** Inspect Phase 0 Step D bare-SHA non-match fallback. Current API call: `gh api repos/<owner>/<action>/git/refs/tags --jq '.[] | select(.object.sha == "<sha>") | .ref'`. No `--paginate` flag present. GitHub REST API returns 30 results per page by default. Actions with more than 30 releases (e.g., `actions/checkout`, `actions/setup-java`) would have older SHAs outside the first page; the fallback would fail to match and incorrectly record the version as `unknown`. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** paginate_flag_present × 100

### MX65 — Cross-Source Dependency Deduplication (CSDD) [custom]
**Measures:** Whether Phase 0 specifies a deduplication step between the Step C.1 TOML alias list and the Step C.4 root build script variable list to prevent the same Maven coordinates from entering the lookup and bump pipeline twice.
**Why seeds miss it:** M5 RI measures duplicate instructions across files; it does not measure structural redundancy in dependency discovery within a phase. No seed metric detects missing dedup gates in data collection pipelines.
**Methodology:** Inspect Phase 0 Steps C.1 and C.4. C.1 collects all TOML aliases and resolves them to Maven `group:artifact` coordinates. C.4 resolves root build script variables to coordinates. If both discover the same `group:artifact`, no instruction merges or deduplicates the two lists before Step D lookup. Step F's bundling note addresses commit bundling for known-linked pairs but does not prevent separate commits for coordinates-matched pairs where the alias name differs. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** dedup_step_present × 100

### MX66 — Single-Alias Failing Tests Comment Scope (SAFC) [custom]
**Measures:** Whether Phase 7's single-alias failing integration tests path (H59) includes instruction to narrow the summary comment scope to only Phase 8 data (integration test result and bisect finding), rather than using the full multi-alias template that duplicates Phase 6 content.
**Why seeds miss it:** MX59 measured whether the routing conditional existed. MX66 measures whether the new code path has appropriately scoped output. M1 IOT measures inter-phase data flow; it does not measure whether a phase's output is over-broad for a specific execution path.
**Methodology:** Inspect Phase 7 Step B. The instruction says "Keep the comment short. The per-bump detail is in the comments above — this comment is a navigator, not a repeat." However, the step then presents a single template covering the full alias table, overall verdict, integration test result, remediations applied, worth a closer look, and needs human action. No instruction distinguishes the single-alias failing integration tests path from the multi-alias path. For a single-alias PR, Phase 6 already contains the verdict, breaking changes, security, CI status, and remediations. Only the Phase 8 data is new. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** scope_narrowing_present × 100

### MX67 — Cross-Run Proactive PR Deduplication (CRPPD) [custom, moonshot]
**Measures:** Whether Phase 0 Step H's deduplication check covers open proactive bump PRs created by prior skill runs (which may use different BUMP_BRANCH values, e.g. `deps/auto-bump-2026-04-14` still open when `deps/auto-bump-2026-04-15` would be created).
**Why seeds miss it:** No seed metric measures cross-run state continuity. This borrows a reliability-engineering concept — idempotent automation — and applies it as a scorable property: proactive automation that accumulates multiple open PRs per repository creates reviewer confusion and duplicates effort.
**Methodology:** Inspect Phase 0 Step H deduplication check: `gh pr list --repo <owner/repo> --head <BUMP_BRANCH> --state open --json number,title`. This checks for PRs on the exact BUMP_BRANCH for the current day. If the skill ran yesterday and that PR is still open (branch: `deps/auto-bump-2026-04-14`), the check finds nothing and creates a second open proactive PR. No broader title-based or pattern-based check is specified. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1× (moonshot — requires a different detection strategy: title-based search rather than branch-specific filter, plus user confirmation logic)
**Normalisation:** cross_run_check_present × 100

### MX68 — Phase 5 Intermediate Version List Data Source (IVLDS) [custom]
**Measures:** Whether Phase 5 Step C specifies where to retrieve the intermediate version list required by the verdict block template's multi-version span line (`<v1>, <v2>, ...`).
**Why seeds miss it:** M1 IOT measures whether phases consume prior phase artifacts in aggregate; it does not measure whether a specific template field has an explicit data-source instruction. P1 (Intent Anchor Blocks) is the pattern that would fix this; its absence is not captured by any seed metric.
**Methodology:** Inspect Phase 5 Step C verdict block template. The version span line reads: `| multi — <count> intermediate versions traversed: <v1>, <v2>, ...`. Phase 5 Step A and Step B give no instruction on where to obtain the intermediate version list. Phase 2 Pass A performs multi-version span detection and identifies intermediate versions; Phase 1 Step E writes a session brief with version span detection. Neither is cross-referenced from Phase 5 Step C. An agent executing Phase 5 as a subagent would not know to read Phase 2's investigation report for this data. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** data_source_specified × 100

---

## Baseline — 2026-04-15 (Run 16)

**Pulse (Analytics) active.**

### Inherited Metrics
All 80 metrics carry forward at Run 15 post-experiment values (~9,429/10,400 = ~90.7%). No instruction file changes between Run 15 final and this run's audit affect any inherited metric.

### New Metrics This Run

| Metric | Score | Weight | Weighted |
|---|---|---|---|
| Bare-SHA Fallback Pagination Coverage (MX64) | 0 | 1× | 0 |
| Cross-Source Dependency Deduplication (MX65) | 0 | 1× | 0 |
| Single-Alias Failing Tests Comment Scope (MX66) | 0 | 1× | 0 |
| Cross-Run Proactive PR Deduplication (MX67) | 0 | 1× | 0 |
| Phase 5 Intermediate Version List Data Source (MX68) | 0 | 1× | 0 |

### Full Composite (85 metrics)

Inherited weighted sum: ~9,429 (104×)
New metrics weighted sum: 0 + 0 + 0 + 0 + 0 = 0 (5×)
Total: **~9,429 / 10,900 (109×)**

**Composite: ~9,429 / 10,900 × 100 = ~86.5%**

*(Drop of ~4.2pp from scope expansion: 5 new weight units at 0.)*

### Weakest Metrics (Phase 3 candidates)
1. MX64 — Bare-SHA Fallback Pagination Coverage: 0 (1×)
2. MX65 — Cross-Source Dependency Deduplication: 0 (1×)
3. MX66 — Single-Alias Failing Tests Comment Scope: 0 (1×)
4. MX67 — Cross-Run Proactive PR Deduplication: 0 (1×, moonshot)
5. MX68 — Phase 5 Intermediate Version List Data Source: 0 (1×)

---

## Hypotheses — 2026-04-15 (Run 16)

*Keeper (Strategist) active.*

### Step 0 — Pre-Experiment Dependency Scan
H64 modifies p0-bump.md (Step D).
H65 modifies p0-bump.md (Step C.5 — new dedup section between C.4 and D).
H66 modifies p7-summary.md (Step B).
H67 modifies p0-bump.md (Step H).
H68 modifies p5-verdict.md (Step C).

File overlaps: H64, H65, H67 all modify p0-bump.md → running sequentially with metric re-check between them.
H66 (p7 only) and H68 (p5 only) are independent of each other and of H64/H65/H67.
Execution order: H66 → H68 → H64 → (re-check) → H65 → (re-check) → H67.

### H64 — Add --paginate to bare-SHA fallback tag lookup
**Problem observed:** MX64 = 0. Phase 0 Step D bare-SHA non-match fallback calls `gh api repos/<owner>/<action>/git/refs/tags --jq '...'` without `--paginate`. GitHub REST API returns 30 results per page by default. Actions with more than 30 releases would not have older SHAs in the first page, causing the fallback to incorrectly conclude the SHA is unresolvable and record the version as `unknown`.
**Change proposed:** In p0-bump.md Step D bare-SHA non-match fallback, add `--paginate` to the API call: change `gh api repos/<owner>/<action>/git/refs/tags \` to `gh api repos/<owner>/<action>/git/refs/tags --paginate \`.
**Targets:** Bare-SHA Fallback Pagination Coverage (MX64): 0 → 100 (+100pp)
**Predicted improvement:** MX64 +100pp (1× = +100 weighted)
**Pattern applied:** P10 — Failure Mode Registry (closes an unhandled failure mode: SHA not found due to pagination truncation)
**Risk level:** low
**Risk note:** `--paginate` is a standard `gh api` flag; it concatenates all pages and passes the merged JSON array to `--jq`. Slightly more API calls for actions with many tags but functionally correct.

### H65 — Add cross-source coordinate deduplication step between C.4 and Step D
**Problem observed:** MX65 = 0. Phase 0 Steps C.1 and C.4 may independently discover the same dependency by Maven coordinates. No deduplication step is specified before Step D lookup. The same `group:artifact` could receive two lookup + bump + commit sequences, resulting in redundant commits and duplicate PR body rows.
**Change proposed:** After Step C.4 and before Step D in p0-bump.md, add a new Step C.5 with deduplication instruction: compare C.4 variable resolved coordinates against C.1 alias coordinates; matches are folded into the C.1 alias entry (per Step F bundling) and removed from the standalone C.4 list.
**Targets:** Cross-Source Dependency Deduplication (MX65): 0 → 100 (+100pp)
**Predicted improvement:** MX65 +100pp (1× = +100 weighted)
**Pattern applied:** P11 — File Role Stratification (TOML alias entry is authoritative when both sources resolve to the same coordinates)
**Risk level:** low
**Risk note:** Additive dedup step before lookup; the existing Step F bundling logic handles the simple linked-alias case, this extends it to coordinate-matched pairs.

### H66 — Scope-narrow Phase 7 comment for single-alias failing integration tests
**Problem observed:** MX66 = 0. Phase 7's H59 addition routes single-alias PRs with failing integration tests through Steps B–C. Step B's template covers the full alias table, overall verdict, remediations, and warnings — duplicating nearly all content already in the Phase 6 comment. The only genuinely new data for the single-alias failing case is the Phase 8 integration test result and bisect finding.
**Change proposed:** In p7-summary.md Step B, after the general "Keep the comment short" instruction, add a scoping note for the single-alias failing integration tests case: post a reduced comment limited to the integration test result, bisect finding, and "Needs human action" entry — omitting the alias table, overall verdict line, and "Worth a closer look" section.
**Targets:** Single-Alias Failing Tests Comment Scope (MX66): 0 → 100 (+100pp)
**Predicted improvement:** MX66 +100pp (1× = +100 weighted)
**Pattern applied:** P7 — Binary Applicability Gates (adds a scope gate on the comment template for the H59 path)
**Risk level:** low
**Risk note:** Additive scoping note. The full template remains active for all multi-alias cases and all single-alias passing cases.

### H67 — Add title-based cross-run proactive PR deduplication check
**Problem observed:** MX67 = 0. Phase 0 Step H dedup check is branch-specific (`--head <BUMP_BRANCH>`). A prior run's proactive PR on `deps/auto-bump-<older-date>` would not be detected. Multiple open proactive bump PRs can accumulate across runs.
**Change proposed:** In p0-bump.md Step H, before the existing branch-based dedup check, add a title-pattern check: `gh pr list --repo <owner/repo> --state open --search 'chore(deps): bump outdated dependencies in:title' --json number,title,headRefName`. If found, report to the user and ask whether to proceed or use the existing PR.
**Targets:** Cross-Run Proactive PR Deduplication (MX67): 0 → 100 (+100pp)
**Predicted improvement:** MX67 +100pp (1× = +100 weighted)
**Pattern applied:** P7 — Binary Applicability Gates (pre-creation check with deterministic user confirmation)
**Risk level:** low
**Risk note:** The title search is non-destructive. The user confirmation gate only triggers when a prior open proactive PR exists.

### H68 — Specify Phase 5 intermediate version list data source
**Problem observed:** MX68 = 0. Phase 5 Step C verdict block template requires `<v1>, <v2>, ...` intermediate versions but Phase 5 gives no instruction on where to retrieve this list. A subagent executing Phase 5 would not know to read Phase 2's multi-version span detection data.
**Change proposed:** In p5-verdict.md Step C, add a data-source note immediately before the verdict block template: the intermediate version list comes from Phase 2 Pass A (Multi-Version Span Detection); if the report is not in context, fall back to the session brief at `/tmp/dep-review-<PR-number>-session-brief.md`.
**Targets:** Phase 5 Intermediate Version List Data Source (MX68): 0 → 100 (+100pp)
**Predicted improvement:** MX68 +100pp (1× = +100 weighted)
**Pattern applied:** P1 — Intent Anchor Blocks (adds an explicit data-source anchor for a previously unanchored template field)
**Risk level:** low
**Risk note:** Additive note before the template. No change to the template structure or Phase 5 scoring logic.

### Self-Audit (Keeper)
1. **Intent check:** H64 targets MX64 (0 < 100) ✓; H65 targets MX65 (0 < 100) ✓; H66 targets MX66 (0 < 100) ✓; H67 targets MX67 (0 < 100) ✓; H68 targets MX68 (0 < 100) ✓.
2. **Coverage check:**
   - H64–H68: +100 weighted each → total +500
   - Projected: (~9,429 + 500) / 10,900 = ~9,929 / 10,900 = **~91.1%** < 95%
   - Below 95%; check uncovered gaps. MX49/43/38/34 (moonshots at 0): no tractable hypothesis. PEV ~56: all hypotheses apply previously validated patterns — no new PEV credit this run. No non-moonshot metric below 80 without a hypothesis. ✓
3. **Gap fill:** No non-moonshot metric below 80 is uncovered. ✓

### Recommendation Brief

1. **Add `--paginate` to bare-SHA fallback tag lookup** — the H61 fallback calls `gh api repos/.../git/refs/tags` without `--paginate`, returning only the first 30 results; actions with more than 30 releases would have their SHA outside page 1, causing the fallback to incorrectly record the version as `unknown`.
2. **Add cross-source coordinate deduplication before Step D** — Steps C.1 and C.4 may independently discover the same `group:artifact`, producing double lookup + bump + commit sequences; a dedup pass after C.4 that merges matching entries into the TOML alias entry prevents redundant commits.
3. **Scope-narrow Phase 7 comment for single-alias failing integration tests** — Phase 7's new H59 path runs the full multi-alias template even for single-alias PRs where Phase 6 already contains all verdict detail; the comment needs a scoping gate that limits output to only the new Phase 8 data.
4. **Add title-based cross-run proactive PR deduplication** — Step H's branch-specific dedup check misses prior runs' still-open proactive PRs on different BUMP_BRANCH values; a title-pattern search before PR creation surfaces prior open PRs and asks the user to confirm before opening a new one.
5. **Specify Phase 5 intermediate version list data source** — the verdict block template expects `<v1>, <v2>, ...` intermediate versions but Phase 5 never says to read this from Phase 2's multi-version span detection data; adding a data-source note before the template closes the gap.

---

## Experiments — 2026-04-15 (Run 16)

**Arden (Critic) active.**

**Step 0 — Pre-Experiment Dependency Scan**
H64 modifies p0-bump.md (Step D). H65 modifies p0-bump.md (new Step C.5). H66 modifies p7-summary.md (Step B). H67 modifies p0-bump.md (Step H). H68 modifies p5-verdict.md (Step C).
File overlap: H64, H65, H67 share p0-bump.md → sequential with re-check between them.
Execution order: H66 → H68 → H64 → (re-check) → H65 → (re-check) → H67.

---

### H66 — Scope-narrow Phase 7 comment for single-alias failing integration tests

**Pre-change:** MX66 (Single-Alias Failing Tests Comment Scope): 0

**Post-change:** Phase 7 Step B amended with a scoping note immediately after the general "Keep the comment short" instruction. For single-alias PRs routing through Steps B–C solely because Phase 8 integration tests failed, the comment is reduced to: integration test result, bisect finding (if any), and a "Needs human action" entry for the integration test failure. The alias table, overall verdict line, and "Worth a closer look" section are omitted — Phase 6 already contains this content.
- MX66: 100 (+100pp)

**Delta:** MX66 +100pp
**Secondary deltas:** M3 IAR re-checked — the scoping note uses imperative language ("omit", "include only"); no weak modals introduced. M6 ACC re-checked — the conditional is deterministic (single-alias AND Phase 8 failed). No degradation.
**Result:** confirmed
**Notes:** P7 (Binary Applicability Gates) applied — a scope gate added to the comment template for the new H59 execution path. P7 already validated (H56, H59); no new PEV credit.

---

### H68 — Specify Phase 5 intermediate version list data source

**Pre-change:** MX68 (Phase 5 Intermediate Version List Data Source): 0

**Post-change:** Phase 5 Step C amended with a data-source note immediately before the verdict block template. The note specifies: (a) read the intermediate version list from Phase 2 Pass A's multi-version span detection section if the investigation report is in context; (b) fall back to the session brief at `/tmp/dep-review-<PR-number>-session-brief.md` if not.
- MX68: 100 (+100pp)

**Delta:** MX68 +100pp
**Secondary deltas:** M1 IOT re-checked — Phase 5 now explicitly anchors to Phase 2 data for the intermediate version list; cross-phase traceability for this field is confirmed. Minor positive but below 2pp. M10 CDR re-checked — the session brief fallback provides a session-boundary reanchor. No degradation.
**Result:** confirmed
**Notes:** P1 (Intent Anchor Blocks) applied — explicit data-source anchor added for a previously unanchored template field. P1 already validated; no new PEV credit.

---

### H64 — Add --paginate to bare-SHA fallback tag lookup

**Pre-change (re-checked after H66/H68):** MX64 (Bare-SHA Fallback Pagination Coverage): 0

**Post-change:** Phase 0 Step D bare-SHA non-match fallback amended — `--paginate` flag added to the `gh api repos/<owner>/<action>/git/refs/tags` call. With `--paginate`, the gh CLI concatenates all pages before passing the result to `--jq`, ensuring the SHA is found even for actions with more than 30 releases.
- MX64: 100 (+100pp)

**Delta:** MX64 +100pp
**Secondary deltas:** RPC (Recovery Path Completeness) re-checked — the bare-SHA fallback now correctly handles large tag lists. No degradation.
**Result:** confirmed
**Notes:** P10 (Failure Mode Registry) applied — closes a pagination-induced failure mode in the H61 fallback. P10 already validated; no new PEV credit.

---

### H65 — Add cross-source coordinate deduplication step between C.4 and Step D

**Pre-change (re-checked after H64):** MX65 (Cross-Source Dependency Deduplication): 0

**Post-change:** Phase 0 amended with a new Step C.5 (Cross-Source Deduplication) between C.4 and D. After all source-type collection is complete, the agent compares C.4 variable resolved coordinates against C.1 alias coordinates; matches are folded into the C.1 alias entry (per existing Step F bundling) and removed from the standalone C.4 list. Merged entries are noted in the Step I summary under the TOML alias row.
- MX65: 100 (+100pp)

**Delta:** MX65 +100pp
**Secondary deltas:** M5 RI re-checked — the new dedup step explicitly prevents redundant bump sequences; RI improves for this path. M3 IAR re-checked — dedup condition ("same `group:artifact`") is deterministic. No degradation.
**Result:** confirmed
**Notes:** P11 (File Role Stratification) applied — TOML alias entry designated authoritative when both sources resolve to the same coordinates. P11 already validated; no new PEV credit.

---

### H67 — Add title-based cross-run proactive PR deduplication check

**Pre-change (re-checked after H65):** MX67 (Cross-Run Proactive PR Deduplication): 0

**Post-change:** Phase 0 Step H amended with a title-pattern search before the existing branch-based dedup check. The new check searches for any open proactive bump PR by title prefix. If found, the user is asked to confirm before proceeding — they may elect to use the existing PR (proceeding to Step I with its number) or create a new one (continuing with the existing branch-based check).
- MX67: 100 (+100pp)

**Delta:** MX67 +100pp
**Secondary deltas:** M8 HTP re-checked — a new user confirmation gate is introduced only when a prior open proactive PR is detected; appropriate and not excessive. No degradation.
**Result:** confirmed
**Notes:** P7 (Binary Applicability Gates) applied — pre-creation check with deterministic user confirmation. P7 already validated; no new PEV credit.

---

## Experiment Summary (Run 16)
- Confirmed: H64, H65, H66, H67, H68
- Partial: none
- Disconfirmed: none

---

## Final Results — 2026-04-15 (Run 16)

### Post-Experiment Re-Measurement

| Metric | Baseline | Post | Delta | Weight | Weighted Δ |
|---|---|---|---|---|---|
| All inherited metrics (80) | ~9,429 | ~9,429 | 0 | 104× | 0 |
| Bare-SHA Fallback Pagination Coverage (MX64) | 0 | 100 | +100 | 1× | +100 |
| Cross-Source Dependency Deduplication (MX65) | 0 | 100 | +100 | 1× | +100 |
| Single-Alias Failing Tests Comment Scope (MX66) | 0 | 100 | +100 | 1× | +100 |
| Cross-Run Proactive PR Deduplication (MX67) | 0 | 100 | +100 | 1× | +100 |
| Phase 5 Intermediate Version List Data Source (MX68) | 0 | 100 | +100 | 1× | +100 |
| **TOTAL** | **~9,429** | **~9,929** | **+500** | **109×** | **+500** |

**Post-experiment composite: ~9,929 / 10,900 × 100 = ~91.1%**

### Composite History

| | Score | Metrics | Weight |
|---|---|---|---|
| Run 15 final | ~90.7% | 80 | 104× |
| Run 16 baseline | ~86.5% | 85 | 109× |
| **Run 16 final** | **~91.1%** | **85** | **109×** |

Delta this run: +4.6pp (all primary metrics exact).

### What improved and why
- Bare-SHA Fallback Pagination Coverage (+100pp): `--paginate` added to the H61 bare-SHA fallback API call — ensures all tag pages are searched for actions with more than 30 releases.
- Cross-Source Dependency Deduplication (+100pp): Step C.5 dedup step added between C.4 and D — TOML alias entries are authoritative when C.1 and C.4 both resolve to the same coordinates, preventing double-bump commits.
- Single-Alias Failing Tests Comment Scope (+100pp): Phase 7 Step B now scopes the single-alias failing integration tests comment to Phase 8 data only (integration test result + bisect finding), avoiding duplication of Phase 6 content.
- Cross-Run Proactive PR Deduplication (+100pp): Phase 0 Step H now searches for open proactive PRs by title prefix before creating a new one, preventing accumulation of multiple open proactive bump PRs across runs.
- Phase 5 Intermediate Version List Data Source (+100pp): Phase 5 Step C now specifies Phase 2 Pass A as the source for the intermediate version list, with session brief as fallback — subagents can now locate this data reliably.

### What was dropped
Nothing — all five hypotheses confirmed.

### What remains to improve
- Multi-Catalogue Dependency Deduplication Coverage (MX49): 0 — moonshot; carries forward from Runs 11–16.
- Pre-Bump Base Branch CI Health Check (MX43): 0 — moonshot; carries forward.
- Changelog URL Annotation Freshness Risk (MX38): 0 — moonshot; carries forward.
- Temporal Safety Window Consistency (MX34): 0 — moonshot; carries forward.
- Pattern Experimental Validation Rate (PEV): ~56 — structural; no new patterns validated this run (H64 applied P10; H65 applied P11; H66/H67 applied P7; H68 applied P1 — all previously validated). Dormant patterns (P5, P13, P14, P17, P18) remain unvalidatable without artificial hypotheses.

### Novel Patterns Observed
None this run. H64 applied P10; H65 applied P11; H66/H67 applied P7; H68 applied P1.

### Archive Check
Runs 12–14 archived to `research-log-archive-2026-04-15.md`. Live log now contains Run 16 and Run 15 only — estimated ~11,000 tokens. Well under the 15,000-token threshold.

---

## Audit — 2026-04-15 (Run 15)

**Pulse (Analytics) active.**

**Target:** `skills/bump-dependencies/`
**Files:** 22 total (11 command, 4 support, 7 logs/archives)
**Token estimate:** ~31,600 tokens (instruction files ~17,800 after H55–H58 additions; support/logs ~13,800)

> Tier C — target matches, log dated 2026-04-15 (≤7 days). Proceeding to Run 15.

### Feature Inventory
Unchanged from Run 14. Multi-phase pipeline ✓, persona system ✓, subagents ✓, parallel execution ✓, cached artifacts ✓.

### Changes Since Run 14
1. **H55**: "matches" → "starts with" in p7-summary.md Step A and p8-consolidate.md (two locations).
2. **H56**: Wave 3 non-agent fallback guard added to bump-dependencies.md.
3. **H57**: Wave 1 agent completion recovery instruction added to bump-dependencies.md.
4. **H58**: Step G ordering list updated — standalone C.4 bumps added as item 2; Actions renumbered to 3; wrapper renumbered to 4.
5. **Version bumped to 4.9.0**.

### Structural Gaps Introduced or Exposed by H55–H58
- Phase 7 skips the PR comment (Steps B–C) when exactly one alias was reviewed, justifying this as "the Phase 6 comment already contains the full detail." But Phase 6 is posted before Phase 8 runs. For single-alias PRs where integration tests fail, the bisect finding from Phase 8 is never surfaced as a PR comment.
- Phase 5 scoring matrix names the multi-version span signal as "Multi-version span (≥3 intermediate versions skipped)". Phase 5's explanatory note says "Apply this signal when the upgrade traverses three or more intermediate versions (i.e., old → new spans at least two releases not previously reviewed)". "Three or more intermediate versions" and "at least two releases" define different thresholds. Phase 2 Multi-Version Span Detection defines a multi-version span as ≥2 versions in range (i.e., ≥2 intermediate), consistent with the Phase 5 note's parenthetical but inconsistent with the signal row text.
- Phase 0 Step D (GitHub Actions section) says "For bare-SHA entries with no tag comment, identify the current version by checking whether the SHA appears in the GraphQL tagCommit.oid fields already fetched — no extra API call needed if it matches." No fallback is given for when the SHA does not match any tagCommit.oid in the response.
- Phase 8 all-skipped early exit closes a proactive PR and calls Step F (cleanup). Step F deletes isolated branches and the local copy of the PR head branch but notes "The remote was updated by Step E." In the all-skipped path, Step E is skipped — so the remote `deps/auto-bump-<date>` head branch is never force-pushed or deleted, leaving a dangling remote branch after PR closure.
- Phase 0 Step H PR body template says "| <table rows — one per bumped dependency; use tag names for GitHub Actions>" but provides no identifier format for root build script variable (Step C.4) bumps. Step I gained a C.4 format note in H53 (Run 13), but Step H was not updated in the same pass.

### Persona Staleness Check
All 4 personas confirmed present and current (Ink, Echo, Rook, Arden — unchanged).

---

## Custom Metrics — 2026-04-15 (Run 15)

**Pulse (Analytics) active.**

EIS: 100 (carries forward). PEV: ~56 (carries forward).

### MX59 — Single-Alias Phase 8 Result Surfacing (SA_P8RS) [custom]
**Measures:** Whether Phase 7's skip condition for single-alias PRs preserves the ability to surface Phase 8 consolidation data (integration test results, bisect findings) when integration tests fail.
**Why seeds miss it:** M1 IOT measures whether phases consume prior phase artifacts, not whether a summary phase's skip condition omits data that appears only after the skip would trigger. No seed metric measures phase-skip completeness.
**Methodology:** Inspect Phase 7 skip condition. Current: "If exactly one alias was reviewed, skip this phase entirely — proceed to Step D (report to user) only." Step D prints a terminal summary (verdict, PR URL) but does not surface Phase 8 bisect findings. Phase 6 is posted before Phase 8 runs, so it cannot contain Phase 8 data. For a single-alias PR with a failing integration test, the bisect finding has no prescribed PR comment. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** condition_guards_phase_8_data × 100

### MX60 — Multi-Version Span Threshold Consistency (MVSTC) [custom]
**Measures:** Whether Phase 5's multi-version span signal defines a single, unambiguous threshold that is consistent with Phase 2's definition of a multi-version span.
**Why seeds miss it:** M3 IAR measures "should/may/might" constructs. MX60 measures a different ambiguity: contradictory numeric thresholds between a matrix signal row and its explanatory note, and between Phase 5 and Phase 2.
**Methodology:** Compare three statements: (a) Phase 5 scoring matrix row: "Multi-version span (≥3 intermediate versions skipped)"; (b) Phase 5 note: "Apply this signal when the upgrade traverses three or more intermediate versions (i.e., old → new spans at least two releases not previously reviewed)"; (c) Phase 2 Multi-Version Span Detection: "If two or more versions are in the range… this is a multi-version span." Statements (a) and (b) are internally contradictory (≥3 vs ≥2 intermediate). Statement (b) parenthetical and statement (c) agree on ≥2. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** single_consistent_threshold × 100

### MX61 — Bare-SHA Non-Match Fallback (BSNMF) [custom]
**Measures:** Whether Phase 0 Step D provides an explicit fallback instruction for GitHub Actions with bare SHA pins where the SHA does not match any tagCommit.oid in the GraphQL batch response.
**Why seeds miss it:** M10 CDR measures session-boundary reanchoring. No seed metric measures fallback completeness within a single phase step for unexpected API response states.
**Methodology:** Inspect Phase 0 Step D GitHub Actions section. Current: "For bare-SHA entries with no tag comment, identify the current version by checking whether the SHA appears in the GraphQL tagCommit.oid fields already fetched — no extra API call needed if it matches." No instruction for the non-matching case. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** fallback_present × 100

### MX62 — Proactive All-Blocked Remote Branch Cleanup (PABRBC) [custom, moonshot]
**Measures:** Whether Phase 8's all-skipped early exit path explicitly cleans up the remote PR head branch (the `deps/auto-bump-<date>` branch) after closing a proactive PR, rather than leaving it dangling on the remote.
**Why seeds miss it:** No seed metric measures post-termination state cleanup for early exit paths. This borrows a reliability-engineering concept — "clean exit state" — and applies it as a scorable property of an agentic documentation workflow.
**Methodology:** Inspect Phase 8 all-skipped early exit and Step F. Step F deletes isolated branches and the local PR head branch. Step F's cleanup note says "The remote was updated by Step E" — but in the all-skipped path, Step E is skipped. Step F contains no `git push origin --delete <head-branch>` command for the all-skipped path. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** remote_cleanup_present × 100

### MX63 — Step H PR Body Format for C.4 Variables (PBF_C4) [custom]
**Measures:** Whether Phase 0 Step H's PR body bump table template provides explicit identifier format guidance for root build script variable (Step C.4) bumps.
**Why seeds miss it:** MX50 (Run 13) measured Step I's output template for C.4 entries. MX63 measures the same gap in Step H's PR body — a parallel template that was not updated when H53 added C.4 format notes to Step I. M6 ACC does not detect missing template row types.
**Methodology:** Inspect Step H PR body heredoc. Current: "| <table rows — one per bumped dependency; use tag names for GitHub Actions>". No format specified for C.4 variable entries. Step I format (`<varName> (<script-file>)`) is not referenced here. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** format_present × 100

---

## Baseline — 2026-04-15 (Run 15)

**Pulse (Analytics) active.**

### Inherited Metrics
All 75 metrics carry forward at Run 14 post-experiment values (~8,929/9,900 = ~90.2%). No instruction file changes between Run 14 final and this run's audit affect any inherited metric.

### New Metrics This Run

| Metric | Score | Weight | Weighted |
|---|---|---|---|
| Single-Alias Phase 8 Result Surfacing (MX59) | 0 | 1× | 0 |
| Multi-Version Span Threshold Consistency (MX60) | 0 | 1× | 0 |
| Bare-SHA Non-Match Fallback (MX61) | 0 | 1× | 0 |
| Proactive All-Blocked Remote Branch Cleanup (MX62) | 0 | 1× | 0 |
| Step H PR Body Format for C.4 Variables (MX63) | 0 | 1× | 0 |

### Full Composite (80 metrics)

Inherited weighted sum: ~8,929 (99×)
New metrics weighted sum: 0 + 0 + 0 + 0 + 0 = 0 (5×)
Total: **~8,929 / 10,400 (104×)**

**Composite: ~8,929 / 10,400 × 100 = ~85.9%**

*(Drop of ~4.3pp from scope expansion: 5 new weight units at 0.)*

### Weakest Metrics (Phase 3 candidates)
1. MX59 — Single-Alias Phase 8 Result Surfacing: 0 (1×)
2. MX60 — Multi-Version Span Threshold Consistency: 0 (1×)
3. MX61 — Bare-SHA Non-Match Fallback: 0 (1×)
4. MX62 — Proactive All-Blocked Remote Branch Cleanup: 0 (1×, moonshot)
5. MX63 — Step H PR Body Format for C.4 Variables: 0 (1×)

---

## Hypotheses — 2026-04-15 (Run 15)

*Keeper (Strategist) active.*

### Step 0 — Pre-Experiment Dependency Scan
H59 modifies p7-summary.md.
H60 modifies p5-verdict.md.
H61 modifies p0-bump.md (Step D).
H62 modifies p8-consolidate.md (Step F).
H63 modifies p0-bump.md (Step H).

File overlap: H61 and H63 both modify p0-bump.md → running sequentially with metric re-check between them.
H59 (p7 only), H60 (p5 only), H62 (p8 only) are independent of each other and of H61/H63.
Execution order: H59 → H60 → H62 → H61 → (re-check) → H63.

### H59 — Guard Phase 7 skip condition with Phase 8 integration test result
**Problem observed:** MX59 = 0. Phase 7 skips the PR comment when exactly one alias was reviewed ("proceed to Step D only"). Phase 6 is posted before Phase 8 runs, so it cannot contain Phase 8 consolidation data. For single-alias PRs where integration tests fail, the bisect finding from Phase 8 has no prescribed PR comment path — it is only available in the terminal output via Step D, which does not surface bisect findings.
**Change proposed:** In p7-summary.md, amend the single-alias skip condition to: "If exactly one alias was reviewed AND Phase 8 integration tests passed (or no integration tests were run), skip Steps B and C — the Phase 6 comment already contains the full detail. If Phase 8 integration tests failed, proceed to Steps B–C to surface the bisect finding and test result before reporting to the user in Step D."
**Targets:** Single-Alias Phase 8 Result Surfacing (MX59): 0 → 100 (+100pp)
**Predicted improvement:** MX59 +100pp (1× = +100 weighted)
**Pattern applied:** P7 — Binary Applicability Gates
**Risk level:** low

### H60 — Standardise multi-version span threshold to ≥2 intermediate versions
**Problem observed:** MX60 = 0. Phase 5 scoring matrix row reads "Multi-version span (≥3 intermediate versions skipped)", but Phase 5's explanatory note says "at least two releases not previously reviewed" (≥2 intermediate), and Phase 2 defines a multi-version span as "two or more versions in the range" (≥2 intermediate). The matrix row is the outlier.
**Change proposed:** In p5-verdict.md, replace the scoring matrix row with "Multi-version span (≥2 intermediate versions traversed — see Phase 2 definition)". Update the explanatory note to cross-reference Phase 2 instead of the contradictory parenthetical.
**Targets:** Multi-Version Span Threshold Consistency (MX60): 0 → 100 (+100pp)
**Predicted improvement:** MX60 +100pp (1× = +100 weighted)
**Pattern applied:** P6 — Symmetric Outcome Thresholds
**Risk level:** low

### H61 — Add bare-SHA non-match fallback in Phase 0 Step D
**Problem observed:** MX61 = 0. Phase 0 Step D says "For bare-SHA entries with no tag comment, identify the current version by checking whether the SHA appears in the GraphQL tagCommit.oid fields already fetched — no extra API call needed if it matches." No fallback is given for when the SHA does not match any tagCommit.oid.
**Change proposed:** Add an explicit fallback: targeted `gh api repos/.../git/refs/tags` call; annotated-tag dereference step; conservative `unknown` treatment with upgrade if still unresolved.
**Targets:** Bare-SHA Non-Match Fallback (MX61): 0 → 100 (+100pp)
**Predicted improvement:** MX61 +100pp (1× = +100 weighted)
**Pattern applied:** P10 — Failure Mode Registry
**Risk level:** low

### H62 — Delete remote PR head branch in Phase 8 all-skipped early exit
**Problem observed:** MX62 = 0. Phase 8's all-skipped early exit closes the proactive PR and proceeds to Step F. Step F deletes isolated branches and the local PR head branch, but its cleanup note assumes Step E ran ("The remote was updated by Step E"). In the all-skipped path, Step E is skipped — the remote `deps/auto-bump-<date>` branch is not modified or deleted.
**Change proposed:** In p8-consolidate.md Step F, add a conditional at the end of the branch cleanup block for the all-skipped path: `git push origin --delete <head-branch> 2>/dev/null || true`.
**Targets:** Proactive All-Blocked Remote Branch Cleanup (MX62): 0 → 100 (+100pp)
**Predicted improvement:** MX62 +100pp (1× = +100 weighted)
**Pattern applied:** P10 — Failure Mode Registry
**Risk level:** low

### H63 — Add C.4 variable format to Phase 0 Step H PR body table
**Problem observed:** MX63 = 0. Phase 0 Step H's PR body bump table template has no format for root build script variable (Step C.4) bumps. Step I gained a C.4 format note in H53 (Run 13), but Step H's parallel template was not updated.
**Change proposed:** In p0-bump.md Step H, within the PR body BODY heredoc, add: "For root build script variable bumps (Step C.4 entries), use `<varName> (<script-file>)` as the Dependency column value."
**Targets:** Step H PR Body Format for C.4 Variables (MX63): 0 → 100 (+100pp)
**Predicted improvement:** MX63 +100pp (1× = +100 weighted)
**Pattern applied:** P12 — Content Synchronisation Audit
**Risk level:** low

### Self-Audit (Keeper)
1. **Intent check:** H59 targets MX59 (0 < 100) ✓; H60 targets MX60 (0 < 100) ✓; H61 targets MX61 (0 < 100) ✓; H62 targets MX62 (0 < 100) ✓; H63 targets MX63 (0 < 100) ✓.
2. **Coverage check:**
   - H59–H63: +100 weighted each → total +500
   - Projected: (~8,929 + 500) / 10,400 = ~9,429 / 10,400 = **~90.7%** < 95%
   - Below 95%; no non-moonshot metric below 80 without a hypothesis. ✓
3. **Gap fill:** No non-moonshot metric below 80 is uncovered. ✓

### Recommendation Brief

1. **Guard Phase 7 single-alias skip with integration test result** — Phase 7 skips the PR comment for single-alias PRs but Phase 8 runs after this decision; when integration tests fail on a single-alias PR, the bisect finding has no prescribed PR comment.
2. **Standardise multi-version span threshold to ≥2 intermediate versions** — Phase 5's scoring matrix row says ≥3 intermediate but the explanatory note and Phase 2's definition both use ≥2.
3. **Add bare-SHA non-match fallback** — when a bare-SHA GitHub Action pin doesn't appear in the GraphQL tagCommit.oid fields, there is no prescribed next step.
4. **Clean up remote head branch in all-blocked proactive exit** — when every alias is blocked and the proactive PR is closed, Step F does not delete the remote `deps/auto-bump-<date>` branch.
5. **Add C.4 variable format to Step H PR body** — root build script variable bumps have a defined identifier format in Step I but not in Step H's PR body table template.

---

## Experiments — 2026-04-15 (Run 15)

**Arden (Critic) active.**

**Step 0 — Pre-Experiment Dependency Scan**
H59 modifies p7-summary.md. H60 modifies p5-verdict.md. H61 modifies p0-bump.md (Step D). H62 modifies p8-consolidate.md (Step F). H63 modifies p0-bump.md (Step H).
File overlap: H61 and H63 share p0-bump.md → sequential with re-check between them.
Execution order: H59 → H60 → H62 → H61 → (re-check) → H63.

---

### H59 — Guard Phase 7 skip condition with Phase 8 integration test result

**Pre-change:** MX59 (Single-Alias Phase 8 Result Surfacing): 0

**Post-change:** Phase 7 opening skip condition updated from "skip this phase entirely — proceed to Step D only" to a two-branch conditional: skip Steps B–C when integration tests passed (or no tests run); proceed to Steps B–C when integration tests failed so the bisect finding is posted as a PR comment.
- MX59: 100 (+100pp)

**Delta:** MX59 +100pp
**Secondary deltas:** M6 ACC re-checked — the new condition is deterministic; minor positive but below 2pp. M3 IAR re-checked — conditional phrasing uses "if/when"; no new ambiguous modals. No degradation.
**Result:** confirmed
**Notes:** P7 (Binary Applicability Gates) applied. P7 already validated; no new PEV credit.

---

### H60 — Standardise multi-version span threshold to ≥2 intermediate versions

**Pre-change:** MX60 (Multi-Version Span Threshold Consistency): 0

**Post-change:** Phase 5 scoring matrix row changed from "Multi-version span (≥3 intermediate versions skipped)" to "Multi-version span (≥2 intermediate versions traversed — see Phase 2 definition)". Explanatory note rewritten to remove the contradictory parenthetical and cross-reference Phase 2 explicitly. All three definitions (matrix row, note, Phase 2) now agree on ≥2 intermediate versions.
- MX60: 100 (+100pp)

**Delta:** MX60 +100pp
**Secondary deltas:** M3 IAR re-checked — no change. M6 ACC re-checked — scoring matrix row is now a single, unambiguous threshold; minor positive below 2pp. No degradation.
**Result:** confirmed
**Notes:** P6 (Symmetric Outcome Thresholds) applied. P6 already validated; no new PEV credit.

---

### H61 — Add bare-SHA non-match fallback in Phase 0 Step D

**Pre-change (re-checked after H59/H60):** MX61 (Bare-SHA Non-Match Fallback): 0

**Post-change:** Phase 0 Step D GitHub Actions section extended with an explicit fallback for bare-SHA pins that do not appear in the GraphQL tagCommit.oid fields: (1) targeted `gh api repos/.../git/refs/tags` call to resolve by SHA; (2) annotated-tag dereference step if the object SHA differs from commit SHA; (3) conservative "record as unknown, treat as upgradeable" path if still unresolved.
- MX61: 100 (+100pp)

**Delta:** MX61 +100pp
**Secondary deltas:** RPC re-checked — the bare-SHA non-match is a new conditional branch with an explicit prescribed path. No degradation.
**Result:** confirmed
**Notes:** P10 (Failure Mode Registry) applied. P10 already validated in this workflow (H57, Run 14); no new PEV credit.

---

### H62 — Delete remote PR head branch in Phase 8 all-skipped early exit

**Pre-change:** MX62 (Proactive All-Blocked Remote Branch Cleanup): 0

**Post-change:** Phase 8 Step F expanded with a conditional at the end of the branch cleanup block: if the all-skipped early exit was taken (Step E not run), issue `git push origin --delete <head-branch> 2>/dev/null || true` to remove the dangling remote `deps/auto-bump-<date>` branch. Step F's cleanup note updated to distinguish the two paths.
- MX62: 100 (+100pp)

**Delta:** MX62 +100pp
**Secondary deltas:** RPC re-checked — the all-skipped path gained explicit cleanup coverage. No degradation.
**Result:** confirmed
**Notes:** P10 (Failure Mode Registry) applied. No new PEV credit.

---

### H63 — Add C.4 variable format to Phase 0 Step H PR body table

**Pre-change (re-checked after H61):** MX63 (Step H PR Body Format for C.4 Variables): 0

**Post-change:** Phase 0 Step H PR body heredoc table placeholder extended with a format note for Step C.4 entries: `<varName> (<script-file>)` identifier, Changelog column for the URL, no inline comment to the source file (matching Step F and Step I).
- MX63: 100 (+100pp)

**Delta:** MX63 +100pp
**Secondary deltas:** M3 IAR re-checked — the added format note uses imperative language with no weak modals. No degradation.
**Result:** confirmed
**Notes:** P12 (Content Synchronisation Audit) applied. P12 already validated; no new PEV credit.

---

## Experiment Summary (Run 15)
- Confirmed: H59, H60, H61, H62, H63
- Partial: none
- Disconfirmed: none

---

## Final Results — 2026-04-15 (Run 15)

### Post-Experiment Re-Measurement

| Metric | Baseline | Post | Delta | Weight | Weighted Δ |
|---|---|---|---|---|---|
| All inherited metrics (75) | ~8,929 | ~8,929 | 0 | 99× | 0 |
| Single-Alias Phase 8 Result Surfacing (MX59) | 0 | 100 | +100 | 1× | +100 |
| Multi-Version Span Threshold Consistency (MX60) | 0 | 100 | +100 | 1× | +100 |
| Bare-SHA Non-Match Fallback (MX61) | 0 | 100 | +100 | 1× | +100 |
| Proactive All-Blocked Remote Branch Cleanup (MX62) | 0 | 100 | +100 | 1× | +100 |
| Step H PR Body Format for C.4 Variables (MX63) | 0 | 100 | +100 | 1× | +100 |
| **TOTAL** | **~8,929** | **~9,429** | **+500** | **104×** | **+500** |

**Post-experiment composite: ~9,429 / 10,400 × 100 = ~90.7%**

### Composite History

| | Score | Metrics | Weight |
|---|---|---|---|
| Run 14 final | ~90.2% | 75 | 99× |
| Run 15 baseline | ~85.9% | 80 | 104× |
| **Run 15 final** | **~90.7%** | **80** | **104×** |

Delta this run: +4.8pp (all primary metrics exact).

### What improved and why
- Single-Alias Phase 8 Result Surfacing (+100pp): Phase 7 skip condition now branches on integration test result — failing tests route through Steps B–C so the bisect finding reaches the PR as a comment.
- Multi-Version Span Threshold Consistency (+100pp): Phase 5 scoring matrix row updated to ≥2 intermediate versions, aligning with Phase 2 and Phase 5's own explanatory note.
- Bare-SHA Non-Match Fallback (+100pp): Phase 0 Step D now handles the case where a bare-SHA pin does not appear in the GraphQL response — fallback API call, annotated-tag dereference, and conservative upgrade path all specified.
- Proactive All-Blocked Remote Branch Cleanup (+100pp): Phase 8 Step F now deletes the remote PR head branch when the all-skipped early exit path is taken.
- Step H PR Body Format for C.4 Variables (+100pp): PR body bump table template now includes the `<varName> (<script-file>)` format note for root build script variable entries.

### What was dropped
Nothing — all five hypotheses confirmed.

### What remains to improve
- Multi-Catalogue Dependency Deduplication Coverage (MX49): 0 — moonshot; carries forward from Runs 11–15.
- Pre-Bump Base Branch CI Health Check (MX43): 0 — moonshot; carries forward.
- Changelog URL Annotation Freshness Risk (MX38): 0 — moonshot; carries forward.
- Temporal Safety Window Consistency (MX34): 0 — moonshot; carries forward.
- Pattern Experimental Validation Rate (PEV): ~56 — structural; no new patterns validated this run (H59 applied P7; H60 applied P6; H61/H62 applied P10; H63 applied P12 — all previously validated). Dormant patterns (P5, P11, P13, P14, P17) remain unvalidatable without artificial hypotheses.

### Novel Patterns Observed
None this run. H59 applied P7; H60 applied P6; H61 applied P10; H62 applied P10; H63 applied P12.
