## Archive: see research-log-archive-2026-04-14c.md for Runs 10–11 (2026-04-14). See research-log-archive-2026-04-14b.md for Run 9 (2026-04-14). See research-log-archive-2026-04-14.md for Runs 1–8.

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
**Why seeds miss it:** No seed metric measures post-termination state cleanup for early exit paths. This borrows a reliability-engineering concept — "clean exit state" — and applies it as a scorable property of an agentic documentation workflow. A workflow that terminates early and leaves behind unreferenced remote branches has a non-trivial cleanup debt that accumulates across failed runs.
**Methodology:** Inspect Phase 8 all-skipped early exit and Step F. Step F deletes isolated branches (`dep-review/<PR-number>/<alias>`) and the local PR head branch. Step F's cleanup note says "The remote was updated by Step E" — but in the all-skipped path, Step E is skipped. Step F contains no `git push origin --delete <head-branch>` command for the all-skipped path. Raw: 0/1.
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
**Pattern applied:** P7 — Binary Applicability Gates (adds a deterministic condition — integration test pass/fail — to the single-alias skip)
**Risk level:** low
**Risk note:** Additive conditional; the existing skip path is preserved for the passing case. Agents on single-alias PRs with passing integration tests continue to skip the summary comment as before.

### H60 — Standardise multi-version span threshold to ≥2 intermediate versions
**Problem observed:** MX60 = 0. Phase 5 scoring matrix row reads "Multi-version span (≥3 intermediate versions skipped)", but Phase 5's explanatory note says "at least two releases not previously reviewed" (≥2 intermediate), and Phase 2 defines a multi-version span as "two or more versions in the range" (≥2 intermediate). The matrix row is the outlier; all other definitions agree on ≥2.
**Change proposed:** In p5-verdict.md, replace the scoring matrix row "Multi-version span (≥3 intermediate versions skipped)" with "Multi-version span (≥2 intermediate versions traversed — see Phase 2 definition)". Also remove the parenthetical "i.e., old → new spans at least two releases not previously reviewed" from the explanatory note (it is now redundant with the matrix row) and replace with a cross-reference: "Threshold aligns with Phase 2 Multi-Version Span Detection: two or more released versions strictly between old and new."
**Targets:** Multi-Version Span Threshold Consistency (MX60): 0 → 100 (+100pp)
**Predicted improvement:** MX60 +100pp (1× = +100 weighted)
**Pattern applied:** P6 — Symmetric Outcome Thresholds (unifies contradictory threshold definitions to a single concrete value)
**Risk level:** low
**Risk note:** The matrix row change lowers the trigger threshold from ≥3 to ≥2 intermediate versions. In practice this means upgrades that skip exactly 2 releases (e.g., 1.0→1.3) now trigger the +1 signal where they previously would not. This is the intended behaviour per Phase 2's definition and the note's parenthetical.

### H61 — Add bare-SHA non-match fallback in Phase 0 Step D
**Problem observed:** MX61 = 0. Phase 0 Step D says "For bare-SHA entries with no tag comment, identify the current version by checking whether the SHA appears in the GraphQL tagCommit.oid fields already fetched — no extra API call needed if it matches." No fallback is given for when the SHA does not match any tagCommit.oid.
**Change proposed:** In p0-bump.md Step D GitHub Actions section, after "no extra API call needed if it matches.", add: "If the SHA does not match any tagCommit.oid in the GraphQL response, resolve the current version with a targeted API call: `gh api repos/<owner>/<action>/git/refs/tags --jq '.[] | select(.object.sha == \"<sha>\") | .ref'`. If no tag resolves to the SHA, record the current version as `unknown` and treat it as upgradeable — bump to the latest safe release without a version comparison guard."
**Targets:** Bare-SHA Non-Match Fallback (MX61): 0 → 100 (+100pp)
**Predicted improvement:** MX61 +100pp (1× = +100 weighted)
**Pattern applied:** P10 — Failure Mode Registry (adds an explicit recovery instruction for an unhandled API response state)
**Risk level:** low
**Risk note:** The fallback API call adds one extra round trip per unmatched SHA. In practice, unmatched bare SHAs are rare (they occur when an action's release is no longer on the most recent five returned by the GraphQL query). The conservative recovery (treat as upgradeable) matches the existing spirit of the bump: if we cannot verify the current version, we still want to ensure the dependency is at a safe known release.

### H62 — Delete remote PR head branch in Phase 8 all-skipped early exit
**Problem observed:** MX62 = 0. Phase 8's all-skipped early exit closes the proactive PR and proceeds to Step F. Step F deletes isolated branches and the local PR head branch, but its cleanup note assumes Step E ran ("The remote was updated by Step E"). In the all-skipped path, Step E is skipped — the remote `deps/auto-bump-<date>` branch is not modified or deleted, leaving it dangling on the remote after PR closure.
**Change proposed:** In p8-consolidate.md Step F, add a conditional at the end of the branch cleanup block: "If this is the all-skipped early exit (Step E was not run), also delete the remote PR head branch: `git push origin --delete <head-branch> 2>/dev/null || true`. This removes the dangling `deps/auto-bump-<date>` branch that was created by Phase 0 Step B and pushed by Phase 0 Step H but has now been superseded by the closed PR." Also update Step F's note from "The remote was updated by Step E" to "The remote head branch was updated by Step E (if it ran); if the all-skipped path was taken, the remote head branch is deleted in this step instead."
**Targets:** Proactive All-Blocked Remote Branch Cleanup (MX62): 0 → 100 (+100pp)
**Predicted improvement:** MX62 +100pp (1× = +100 weighted)
**Pattern applied:** P10 — Failure Mode Registry (adds cleanup instruction for an early exit path that leaves the repo in a non-clean state)
**Risk level:** low
**Risk note:** The remote delete command uses `|| true` so it is safe if the branch was already deleted manually. Restricted to the all-skipped proactive path — the normal Step E path is unaffected.

### H63 — Add C.4 variable format to Phase 0 Step H PR body table
**Problem observed:** MX63 = 0. Phase 0 Step H's PR body bump table template has no format for root build script variable (Step C.4) bumps. Step I gained a C.4 format note in H53 (Run 13), but Step H's parallel template was not updated.
**Change proposed:** In p0-bump.md Step H, within the PR body BODY heredoc, after the table placeholder comment "use tag names for GitHub Actions", add: "For root build script variable bumps (Step C.4 entries), use `<varName> (<script-file>)` as the Dependency column value (e.g., `kotlinVersion (build.gradle.kts)`). The Changelog column shows the URL; no inline comment is written to the source file (see Step F)."
**Targets:** Step H PR Body Format for C.4 Variables (MX63): 0 → 100 (+100pp)
**Predicted improvement:** MX63 +100pp (1× = +100 weighted)
**Pattern applied:** P12 — Content Synchronisation Audit (Step H was not updated when Step I gained C.4 format in H53/Run 13)
**Risk level:** low
**Risk note:** Additive note within the heredoc template. No change to the table structure.

### Self-Audit (Keeper)
1. **Intent check:** H59 targets MX59 (0 < 100) ✓; H60 targets MX60 (0 < 100) ✓; H61 targets MX61 (0 < 100) ✓; H62 targets MX62 (0 < 100) ✓; H63 targets MX63 (0 < 100) ✓.
2. **Coverage check:**
   - H59–H63: +100 weighted each → total +500
   - Projected: (~8,929 + 500) / 10,400 = ~9,429 / 10,400 = **~90.7%** < 95%
   - Below 95%; check uncovered gaps. MX49/43/38/34 (moonshots at 0): no tractable hypothesis. PEV ~56: H61 and H62 both apply P10 (already validated in H57, Run 14); H59 applies P7 (validated H56); H60 applies P6 (validated H55); H63 applies P12 (validated H58). No new PEV credit this run. No non-moonshot metric below 80 without a hypothesis. ✓
3. **Gap fill:** No non-moonshot metric below 80 is uncovered. ✓

### Recommendation Brief

1. **Guard Phase 7 single-alias skip with integration test result** — Phase 7 skips the PR comment for single-alias PRs but Phase 8 runs after this decision; when integration tests fail on a single-alias PR, the bisect finding has no prescribed PR comment; adding a conditional preserves the skip for passing tests while routing failures through the comment step.
2. **Standardise multi-version span threshold to ≥2 intermediate versions** — Phase 5's scoring matrix row says ≥3 intermediate but the explanatory note and Phase 2's definition both use ≥2; unifying the matrix row removes the ambiguity and lowers the threshold to match the intended behaviour.
3. **Add bare-SHA non-match fallback** — when a bare-SHA GitHub Action pin doesn't appear in the GraphQL tagCommit.oid fields, there is no prescribed next step; adding a targeted API fallback and a conservative treatment closes the unhandled state.
4. **Clean up remote head branch in all-blocked proactive exit** — when every alias is blocked and the proactive PR is closed, Step F does not delete the remote `deps/auto-bump-<date>` branch because Step E was skipped; adding an explicit delete command in Step F for the all-skipped path prevents dangling remote branches.
5. **Add C.4 variable format to Step H PR body** — root build script variable bumps have a defined identifier format in Step I but not in Step H's PR body table template; adding the same format note closes the documentation gap.

---

## Experiments — 2026-04-15 (Run 15)

**Arden (Critic) active.**

**Step 0 — Pre-Experiment Dependency Scan**
H59 modifies p7-summary.md. H60 modifies p5-verdict.md. H61 modifies p0-bump.md (Step D). H62 modifies p8-consolidate.md (Step F). H63 modifies p0-bump.md (Step H).
File overlap: H61 and H63 share p0-bump.md → sequential with re-check between them.
Execution order: H59 → H60 → H62 → H61 → (re-check) → H63.

### H59 — Guard Phase 7 skip condition with Phase 8 integration test result

**Pre-change:** MX59 (Single-Alias Phase 8 Result Surfacing): 0

**Post-change:** Phase 7 opening skip condition updated from "skip this phase entirely — proceed to Step D only" to a two-branch conditional: skip Steps B–C when integration tests passed (or no tests run); proceed to Steps B–C when integration tests failed so the bisect finding is posted as a PR comment.
- MX59: 100 (+100pp)

**Delta:** MX59 +100pp
**Secondary deltas:** M6 ACC re-checked — the new condition is deterministic (pass/fail on integration test result); minor positive but below 2pp. M3 IAR re-checked — conditional phrasing uses "if/when" not "should/may"; no new ambiguous modals. No degradation.
**Result:** confirmed
**Notes:** P7 (Binary Applicability Gates) applied — the unconditional skip replaced by a deterministic condition derivable from Phase 8 output. P7 already validated; no new PEV credit.

---

### H60 — Standardise multi-version span threshold to ≥2 intermediate versions

**Pre-change:** MX60 (Multi-Version Span Threshold Consistency): 0

**Post-change:** Phase 5 scoring matrix row changed from "Multi-version span (≥3 intermediate versions skipped)" to "Multi-version span (≥2 intermediate versions traversed — see Phase 2 definition)". Explanatory note rewritten to remove the contradictory parenthetical and cross-reference Phase 2 explicitly. All three definitions (matrix row, note, Phase 2) now agree on ≥2 intermediate versions.
- MX60: 100 (+100pp)

**Delta:** MX60 +100pp
**Secondary deltas:** M3 IAR re-checked — no change (the old parenthetical was a threshold definition, not a weak modal). M6 ACC re-checked — scoring matrix row is now a single, unambiguous threshold; minor positive below 2pp. No degradation.
**Result:** confirmed
**Notes:** P6 (Symmetric Outcome Thresholds) applied — contradictory thresholds unified to a single concrete value. P6 already validated; no new PEV credit.

---

### H61 — Add bare-SHA non-match fallback in Phase 0 Step D

**Pre-change (re-checked after H59/H60):** MX61 (Bare-SHA Non-Match Fallback): 0

**Post-change:** Phase 0 Step D GitHub Actions section extended with an explicit fallback for bare-SHA pins that do not appear in the GraphQL tagCommit.oid fields: (1) targeted `gh api repos/.../git/refs/tags` call to resolve by SHA; (2) annotated-tag dereference step if the object SHA differs from commit SHA; (3) conservative "record as unknown, treat as upgradeable" path if still unresolved.
- MX61: 100 (+100pp)

**Delta:** MX61 +100pp
**Secondary deltas:** RPC (Recovery Path Completeness) re-checked — the bare-SHA non-match is a new conditional branch with an explicit prescribed path; RPC improves if this branch was not previously accounted for (likely). No degradation.
**Result:** confirmed
**Notes:** P10 (Failure Mode Registry) applied — adds recovery instruction for a previously unhandled API response state. P10 already validated in this workflow (H57, Run 14); no new PEV credit.

---

### H62 — Delete remote PR head branch in Phase 8 all-skipped early exit

**Pre-change:** MX62 (Proactive All-Blocked Remote Branch Cleanup): 0

**Post-change:** Phase 8 Step F expanded with a conditional at the end of the branch cleanup block: if the all-skipped early exit was taken (Step E not run), issue `git push origin --delete <head-branch> 2>/dev/null || true` to remove the dangling remote `deps/auto-bump-<date>` branch. Step F's cleanup note updated to distinguish the two paths (Step E ran vs. all-skipped).
- MX62: 100 (+100pp)

**Delta:** MX62 +100pp
**Secondary deltas:** RPC re-checked — the all-skipped path gained explicit cleanup coverage. No degradation.
**Result:** confirmed
**Notes:** P10 (Failure Mode Registry) applied — adds a cleanup instruction for an early exit path that previously left the repository in a non-clean state. No new PEV credit (P10 already validated).

---

### H63 — Add C.4 variable format to Phase 0 Step H PR body table

**Pre-change (re-checked after H61):** MX63 (Step H PR Body Format for C.4 Variables): 0

**Post-change:** Phase 0 Step H PR body heredoc table placeholder extended with a format note for Step C.4 entries: `<varName> (<script-file>)` identifier, Changelog column for the URL, no inline comment to the source file (matching Step F and Step I).
- MX63: 100 (+100pp)

**Delta:** MX63 +100pp
**Secondary deltas:** M3 IAR re-checked — the added format note uses imperative language with no weak modals. No degradation.
**Result:** confirmed
**Notes:** P12 (Content Synchronisation Audit) applied — Step H was not updated when Step I gained C.4 format in H53 (Run 13). P12 already validated; no new PEV credit.

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
- Multi-Version Span Threshold Consistency (+100pp): Phase 5 scoring matrix row updated to ≥2 intermediate versions, aligning with Phase 2 and Phase 5's own explanatory note; single unambiguous threshold now used throughout.
- Bare-SHA Non-Match Fallback (+100pp): Phase 0 Step D now handles the case where a bare-SHA pin does not appear in the GraphQL response — fallback API call, annotated-tag dereference, and conservative upgrade path all specified.
- Proactive All-Blocked Remote Branch Cleanup (+100pp): Phase 8 Step F now deletes the remote PR head branch when the all-skipped early exit path is taken, eliminating dangling `deps/auto-bump-<date>` branches after proactive PR closure.
- Step H PR Body Format for C.4 Variables (+100pp): PR body bump table template now includes the `<varName> (<script-file>)` format note for root build script variable entries, closing the content synchronisation gap with Step I.

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

### Archive Check
Live log size after this run: Run 15 (~380 lines) + Run 14 (~250 lines) + Run 13 (~258 lines) ≈ 888 lines × ~12 tokens/line ≈ **~10,700 tokens**. Under the 15,000-token threshold — no archive needed.

---

## Audit — 2026-04-15 (Run 14)

**Pulse (Analytics) active.**

**Target:** `skills/bump-dependencies/`
**Files:** 22 total (11 command, 4 support, 7 logs/archives)
**Token estimate:** ~31,500 tokens (instruction files ~17,700 after H53–H54 additions; support/logs ~13,800)

> Tier C — target matches, log dated 2026-04-15 (≤7 days). Proceeding to Run 14.

### Feature Inventory
Unchanged from Run 13. Multi-phase pipeline ✓, persona system ✓, subagents ✓, parallel execution ✓, cached artifacts ✓.

### Changes Since Run 13
1. **H53**: Step I table placeholder updated `<alias/action>` → `<alias/action/var>`; root build script variable format note added (`<varName> (<script-file>)`).
2. **H54**: Step D safety window formula made explicit: "`release_date ≤ (BUMP_DATE − 7 days)`; anchor is always `BUMP_DATE` — not the time the batch script runs."
3. **Version bumped to 4.8.0**.

### Structural gaps introduced or exposed by H53–H54
- Phase 0 Step H creates the proactive PR with title `chore(deps): bump outdated dependencies (<BUMP_DATE>)` — including a date suffix. Phase 7 and Phase 8 detect proactive mode by checking if the title "matches `chore(deps): bump outdated dependencies`" — no match operator specified. Agents interpreting this as exact equality would fail to detect proactive mode.
- Wave 3 non-agent fallback instructs the agent to "run Phases 2–6 fully sequentially." If Wave 1 also ran without agents (Phases 2–3 sequentially), Phases 2–3 would be executed twice per bump. No guard distinguishes the two scenarios.
- Wave 1 parallel dispatch collects impact tables from agents but provides no recovery path if an agent fails to return one (silent failure or crash).
- Step G ordering list covers `libs.versions.toml`, GitHub Actions, and Gradle wrapper. Root build script variables (Step C.4) with no corresponding TOML alias have no explicit position in this ordering.

### Persona Staleness Check
All 4 personas confirmed present and current (Ink, Echo, Rook, Arden — unchanged).

---

## Custom Metrics — 2026-04-15 (Run 14)

**Pulse (Analytics) active.**

EIS: 100 (carries forward). PEV: 50 (carries forward).

### MX55 — Proactive PR Title Pattern Consistency (PTPC) [custom]
**Measures:** Whether the detection pattern used in Phase 7 and Phase 8 for proactive-mode identification uses an explicit match operator that correctly matches the date-suffixed title created by Phase 0 Step H.
**Why seeds miss it:** M3 IAR measures "should/may/might" ambiguity, not match-operator ambiguity. M6 ACC measures concreteness of acceptance criteria but not detection conditions embedded in branch logic.
**Methodology:** Compare Phase 0 Step H title (`chore(deps): bump outdated dependencies (<BUMP_DATE>)`) against detection patterns in Phase 7 ("if the title matches `chore(deps): bump outdated dependencies`") and Phase 8 (two instances). Check whether an explicit operator (startswith, contains, exact equality) is stated. Current: "matches" — no operator specified. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** explicit_operator_present × 100

### MX56 — Wave 3 Non-Agent Fallback Non-Redundancy (W3NANR) [custom]
**Measures:** Whether the Wave 3 non-agent fallback correctly avoids re-executing Phases 2–3 when Wave 1's non-agent path already ran them.
**Why seeds miss it:** M3 IAR does not measure structural redundancy between parallel conditional branches. M5 RI measures duplicate instructions across files, not logically contradictory fallback paths within one document.
**Methodology:** Inspect bump-dependencies.md Wave 1 non-agent path ("run Phases 2–3 sequentially") and Wave 3 non-agent path ("run Phases 2–6 fully sequentially"). Check for a guard distinguishing whether Wave 1 already ran Phases 2–3. Current: no guard. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** guard_present × 100

### MX57 — Wave 1 Agent Completion Guard (WACG) [custom, moonshot]
**Measures:** Whether the orchestrator has an explicit recovery instruction for the case where a Wave 1 agent fails to return its Phase 3 impact table (silent failure, crash, or missing return statement).
**Why seeds miss it:** M7 SAS measures whether subagent task delegation is appropriate; it does not measure fault tolerance. No seed metric measures recovery paths for sub-agent failure. This borrows a reliability-engineering concept (explicit fault recovery) and applies it to a documentation workflow — measuring agent-crash resilience as a scorable property.
**Methodology:** Inspect bump-dependencies.md Wave 1 parallel dispatch section for a recovery instruction covering silent agent failure. Current: "collect impact tables before proceeding to Wave 2" — no recovery path specified. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** recovery_path_present × 100

### MX58 — Step G Root Build Script Ordering (RBSO) [custom]
**Measures:** Whether Step G's commit ordering list explicitly positions root build script variable bumps (Step C.4) that have no corresponding `libs.versions.toml` alias.
**Why seeds miss it:** MX50 (Step I Root Build Script Representation) measured the output template. MX58 measures the upstream ordering: Step F says to bundle C.4 edits with corresponding TOML alias commits, but makes no provision for standalone C.4 bumps (variables with no TOML alias). Step G's ordering list does not include them.
**Methodology:** Inspect Step G ordering list. Current: (1) libs.versions.toml, (2) GitHub Actions, (3) Gradle wrapper. No entry for standalone C.4 bumps. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** ordering_entry_present × 100

---

## Baseline — 2026-04-15 (Run 14)

**Pulse (Analytics) active.**

### Inherited Metrics
All 71 metrics carry forward at Run 13 post-experiment values (8,529/9,500 = 89.8%). No instruction file changes between Run 13 final and this run's audit affect any inherited metric.

### New Metrics This Run

| Metric | Score | Weight | Weighted |
|---|---|---|---|
| Proactive PR Title Pattern Consistency (MX55) | 0 | 1× | 0 |
| Wave 3 Non-Agent Fallback Non-Redundancy (MX56) | 0 | 1× | 0 |
| Wave 1 Agent Completion Guard (MX57) | 0 | 1× | 0 |
| Step G Root Build Script Ordering (MX58) | 0 | 1× | 0 |

### Full Composite (75 metrics)

Inherited weighted sum: 8,529 (95×)
New metrics weighted sum: 0 + 0 + 0 + 0 = 0 (4×)
Total: **8,529 / 9,900 (99×)**

**Composite: 8,529 / 9,900 × 100 = 86.2%**

*(Drop of 3.6pp from scope expansion: 4 new weight units at 0.)*

### Weakest Metrics (Phase 3 candidates)
1. MX55 — Proactive PR Title Pattern Consistency: 0 (1×)
2. MX56 — Wave 3 Non-Agent Fallback Non-Redundancy: 0 (1×)
3. MX57 — Wave 1 Agent Completion Guard: 0 (1×, moonshot)
4. MX58 — Step G Root Build Script Ordering: 0 (1×)

---

## Hypotheses — 2026-04-15 (Run 14)

*Keeper (Strategist) active.*

### Step 0 — Pre-Experiment Dependency Scan
H55 modifies p7-summary.md and p8-consolidate.md.
H56 modifies bump-dependencies.md (Wave 3 non-agent fallback).
H57 modifies bump-dependencies.md (Wave 1 dispatch recovery).
H58 modifies p0-bump.md (Step G ordering).

File overlap: H56 and H57 both modify bump-dependencies.md → running sequentially with re-check between them.
H55 (p7+p8 only) and H58 (p0-bump only) are independent of each other and of H56/H57.
Execution order: H55 → H56 → (re-check) → H57 → (re-check) → H58.

### H55 — Clarify proactive PR title match operator
**Problem observed:** MX55 = 0. Phase 0 Step H creates a PR titled `chore(deps): bump outdated dependencies (<BUMP_DATE>)`. Phase 7 Step A and Phase 8 (two locations) detect proactive mode by checking if the title "matches `chore(deps): bump outdated dependencies`" with no operator specified. Agents interpreting "matches" as exact equality would fail to detect proactive mode, silently skipping proactive-only behaviour in Phase 7 and Phase 8.
**Change proposed:** In p7-summary.md and p8-consolidate.md, change "matches `chore(deps): bump outdated dependencies`" (all three occurrences) to "starts with `chore(deps): bump outdated dependencies`".
**Targets:** Proactive PR Title Pattern Consistency (MX55): 0 → 100 (+100pp)
**Predicted improvement:** MX55 +100pp (1× = +100 weighted)
**Pattern applied:** P6 — Symmetric Outcome Thresholds (replaces ambiguous match condition with a concrete, unambiguous operator)
**Risk level:** low
**Risk note:** Wording change only. No behaviour change for agents that already interpret "matches" as prefix/substring. Agents that interpret it as exact equality gain correctness.

### H56 — Guard Wave 3 non-agent fallback against Phase 2–3 re-execution
**Problem observed:** MX56 = 0. Wave 1's non-agent path runs Phases 2–3 sequentially. Wave 3's non-agent path then runs "Phases 2–6 fully sequentially" — which re-executes Phases 2–3 already completed in Wave 1. No guard distinguishes whether Wave 1 already ran them.
**Change proposed:** In bump-dependencies.md Wave 3 non-agent fallback, replace "run Phases 2–6 fully sequentially" with "run Phases 4–6 sequentially (skip to Phase 4 if Wave 1 already ran Phases 2–3 without agents; run from Phase 2 only if this is the first execution and Wave 1 was not run separately)".
**Targets:** Wave 3 Non-Agent Fallback Non-Redundancy (MX56): 0 → 100 (+100pp)
**Predicted improvement:** MX56 +100pp (1× = +100 weighted)
**Pattern applied:** P7 — Binary Applicability Gates (adds a deterministic condition to distinguish which phases to run in the Wave 3 fallback)
**Risk level:** low
**Risk note:** Additive clarification; the primary agent-dispatch path is unaffected. Only the non-agent fallback changes.

### H57 — Add Wave 1 agent failure recovery path
**Problem observed:** MX57 = 0. Wave 1 parallel dispatch tells agents to return their Phase 3 impact table but specifies no recovery action if an agent fails to return one. An orphaned impact table leaves the orchestrator with no prescribed next action for that alias.
**Change proposed:** In bump-dependencies.md Wave 1 dispatch section, add after the agent prompt block: "After all agents complete: verify that a Phase 3 impact table was received for every dispatched alias. If any agent did not return (silent failure or crash), treat that alias as having unknown must-fix status — flag it in the manifest and run Phase 4 manually for it before proceeding to Wave 3."
**Targets:** Wave 1 Agent Completion Guard (MX57): 0 → 100 (+100pp); Pattern Experimental Validation Rate (PEV): +~12pp secondary (if P10 was applicable-but-unvalidated in prior runs)
**Predicted improvement:** MX57 +100pp (1× = +100 weighted); PEV secondary ~+12 (1×)
**Pattern applied:** P10 — Failure Mode Registry (adds an explicit recovery instruction for a previously unhandled agent-failure state)
**Risk level:** low
**Risk note:** Additive instruction. The conservative recovery path (treat unknown as must-fix) may occasionally trigger unnecessary Phase 4 work, but prevents missed remediations.

### H58 — Add standalone C.4 entry to Step G ordering
**Problem observed:** MX58 = 0. Step G's commit ordering (1: TOML, 2: Actions, 3: wrapper) omits root build script variables (Step C.4) that have no corresponding TOML alias. Step F handles C.4 bumps with a TOML counterpart (bundle them together) but standalone C.4 bumps have no prescribed commit position.
**Change proposed:** Add a fourth entry to Step G's ordering list: "4. Root build script variables (Step C.4) with no corresponding `libs.versions.toml` alias — alphabetical by variable name, immediately after TOML entries."
**Targets:** Step G Root Build Script Ordering (MX58): 0 → 100 (+100pp)
**Predicted improvement:** MX58 +100pp (1× = +100 weighted)
**Pattern applied:** P12 — Content Synchronisation Audit (Step F was updated in H49 with C.4 editing rules; Step G's ordering was not updated in the same pass)
**Risk level:** low
**Risk note:** Additive entry only. No change to the bundling rule in Step F for C.4 bumps that have a TOML counterpart.

### Self-Audit (Keeper)
1. **Intent check:** H55 targets MX55 (0 < 100) ✓; H56 targets MX56 (0 < 100) ✓; H57 targets MX57 (0 < 100) ✓; H58 targets MX58 (0 < 100) ✓.
2. **Coverage check:**
   - H55–H58: +100 weighted each → total +400; PEV secondary ~+12
   - Projected: (8,529 + 412) / 9,900 = 8,941 / 9,900 = **90.2%** < 95%
3. **Gap fill:** MX49 = 0 (moonshot — deduplication logic complexity exceeds benefit, carries forward). MX43 = 0 (moonshot). MX38 = 0 (moonshot). MX34 = 0 (moonshot). PEV = 50 (structural; H57 applies P10 which may add 1 validated pattern; no other tractable hypothesis). No non-moonshot metric below 80 without a hypothesis. ✓

### Recommendation Brief

1. **Clarify proactive PR title match operator** — Phase 0 creates a date-suffixed PR title but Phase 7 and Phase 8 use "matches" without specifying the operator; changing to "starts with" eliminates ambiguity for agents that interpret matching strictly.
2. **Guard Wave 3 non-agent fallback** — the sequential fallback for Wave 3 currently re-runs Phases 2–3 that Wave 1 may have already completed; adding a conditional clarifies which phases to run based on prior execution.
3. **Add Wave 1 agent failure recovery** — if a parallel agent crashes without returning an impact table, the orchestrator currently has no prescribed next action; adding a conservative recovery path (treat unknown as must-fix) prevents missed remediations.
4. **Add standalone C.4 bumps to Step G ordering** — root build script variables without a TOML counterpart have no prescribed commit position in Step G's ordering list; adding an explicit entry after TOML entries completes the coverage.

---

## Experiments — 2026-04-15 (Run 14)

**Arden (Critic) active.**

**Step 0 — Pre-Experiment Dependency Scan**
H55 modifies p7-summary.md and p8-consolidate.md. H56 modifies bump-dependencies.md (Wave 3). H57 modifies bump-dependencies.md (Wave 1). H58 modifies p0-bump.md.
File overlap: H56 and H57 share bump-dependencies.md → sequential with re-check.
Execution order: H55 → H56 → (re-check) → H57 → (re-check) → H58.

---

### H55 — Clarify proactive PR title match operator

**Pre-change:** MX55 (Proactive PR Title Pattern Consistency): 0

**Post-change:** Three occurrences of "matches `chore(deps): bump outdated dependencies`" updated to "starts with" — one in p7-summary.md Step A, two in p8-consolidate.md (Step B all-skipped path and Step E.1 skip condition).
- MX55: 100 (+100pp)

**Delta:** MX55 +100pp
**Secondary deltas:** M3 IAR re-checked — "starts with" is more concrete than "matches" but M3 measures "should/may/might" constructs; no countable change. M6 ACC re-checked — detection condition now has an explicit operator; minor positive but below 2pp. No degradation.
**Result:** confirmed
**Notes:** P6 (Symmetric Outcome Thresholds) applied — ambiguous "matches" replaced with concrete operator "starts with". P6 already validated; no new PEV credit.

---

### H56 — Guard Wave 3 non-agent fallback

**Pre-change (re-checked after H55):** MX56 (Wave 3 Non-Agent Fallback Non-Redundancy): 0

**Post-change:** Wave 3 non-agent fallback updated from "run Phases 2–6 fully sequentially" to "run Phases 4–6 sequentially; start from Phase 2 only if Wave 1 was also non-agent and Phases 2–3 were not yet run." The guard is deterministic: the executing agent knows whether Wave 1 was run without agents (it was the agent doing the running).
- MX56: 100 (+100pp)

**Delta:** MX56 +100pp
**Secondary deltas:** M3 IAR re-checked — conditional clause is deterministic; no ambiguity introduced. No degradation.
**Result:** confirmed
**Notes:** P7 (Binary Applicability Gates) applied — adds a deterministic condition distinguishing the two non-agent execution scenarios. P7 already validated; no new PEV credit.

---

### H57 — Add Wave 1 agent failure recovery path

**Pre-change (re-checked after H56):** MX57 (Wave 1 Agent Completion Guard): 0; PEV: 50

**Post-change:** Recovery instruction added after Wave 1 agent dispatch: "After all agents complete (or sequential runs finish): verify that a Phase 3 impact table was received for every dispatched alias. If any agent did not return one (silent failure or crash), treat that alias as having unknown must-fix status — flag it explicitly in the manifest and run Phase 4 manually for it before proceeding to Wave 3."
- MX57: 100 (+100pp)
- PEV: 50 → ~56 (+~6pp) — P10 (Failure Mode Registry) confirmed for the first time on this workflow; exact delta depends on total applicable pattern count in archived runs.

**Delta:** MX57 +100pp; PEV +~6pp secondary
**Secondary deltas:** RPC (Recovery Path Completeness) re-checked — the Wave 1 silent-failure branch is a new conditional branch with an explicit prescribed action; RPC improves if this branch was previously unaccounted. No degradation.
**Result:** confirmed
**Notes:** P10 (Failure Mode Registry) applied — adds explicit recovery instruction for a previously unhandled agent-failure state. First confirmed application of P10 to this workflow (not in visible run history; archives may differ — delta noted as approximate).

---

### H58 — Add standalone C.4 entry to Step G ordering

**Pre-change:** MX58 (Step G Root Build Script Ordering): 0

**Post-change:** Step G ordering updated: item 2 added for "Root build script variables (Step C.4) with no corresponding `libs.versions.toml` alias — alphabetical by variable name, immediately after TOML entries". GitHub Actions renumbered to 3; Gradle wrapper renumbered to 4. Parenthetical note added: "those that share a TOML alias are already bundled in step 1" to prevent double-counting.
- MX58: 100 (+100pp)

**Delta:** MX58 +100pp
**Secondary deltas:** M3 IAR re-checked — new entry uses imperative language with no weak modals. M6 ACC re-checked — list entry is concrete (named ordering position). No degradation.
**Result:** confirmed
**Notes:** P12 (Content Synchronisation Audit) applied — Step G's ordering was not updated when Step F gained C.4 editing rules in H49 (Run 12). P12 already validated; no new PEV credit.

---

## Experiment Summary
- Confirmed: H55, H56, H57, H58
- Partial: none
- Disconfirmed: none

---

## Final Results — 2026-04-15 (Run 14)

### Post-Experiment Re-Measurement

| Metric | Baseline | Post | Delta | Weight | Weighted Δ |
|---|---|---|---|---|---|
| All inherited metrics (71) | 8,529 | 8,529 | 0 | 95× | 0 |
| Proactive PR Title Pattern Consistency (MX55) | 0 | 100 | +100 | 1× | +100 |
| Wave 3 Non-Agent Fallback Non-Redundancy (MX56) | 0 | 100 | +100 | 1× | +100 |
| Wave 1 Agent Completion Guard (MX57) | 0 | 100 | +100 | 1× | +100 |
| Step G Root Build Script Ordering (MX58) | 0 | 100 | +100 | 1× | +100 |
| Pattern Experimental Validation Rate (PEV) | 50 | ~56 | +~6 | 1× | +~6 |
| **TOTAL** | **8,529** | **~8,935** | **+~406** | **99×** | **+~406** |

> PEV delta is approximate — exact value depends on total applicable pattern count in archived runs (1–11). Primary metric deltas are exact.

**Post-experiment composite: ~8,935 / 9,900 × 100 = ~90.3%**
*(Using exact primary deltas only, without PEV secondary: 8,929 / 9,900 = 90.2%.)*

### Composite History

| | Score | Metrics | Weight |
|---|---|---|---|
| Run 12 final | 89.2% | 66 | 90× |
| Run 13 baseline | 87.7% | 71 | 95× |
| Run 13 final | 89.8% | 71 | 95× |
| Run 14 baseline | 86.2% | 75 | 99× |
| **Run 14 final** | **~90.2%** | **75** | **99×** |

Delta this run: +4.0pp (primary only).

### What improved and why
- Proactive PR Title Pattern Consistency (+100pp): "matches" replaced with "starts with" in all three proactive-mode detection locations — agents that interpret "matches" as exact equality now correctly detect the date-suffixed PR title.
- Wave 3 Non-Agent Fallback Non-Redundancy (+100pp): explicit guard added to Wave 3 fallback — agents no longer re-run Phases 2–3 when Wave 1 already completed them sequentially.
- Wave 1 Agent Completion Guard (+100pp): recovery instruction added for silent agent failure — unknown must-fix status is now handled conservatively rather than silently dropped.
- Step G Root Build Script Ordering (+100pp): standalone C.4 bumps (no TOML alias counterpart) now have an explicit commit position (item 2, after TOML, before Actions).

### What was dropped
Nothing — all four hypotheses confirmed.

### What remains to improve
- Multi-Catalogue Dependency Deduplication Coverage (MX49): 0 — moonshot; carries forward from Runs 11–14.
- Pre-Bump Base Branch CI Health Check (MX43): 0 — moonshot; carries forward.
- Changelog URL Annotation Freshness Risk (MX38): 0 — moonshot; carries forward.
- Temporal Safety Window Consistency (MX34): 0 — moonshot; carries forward.
- Pattern Experimental Validation Rate (PEV): ~56 — structural; H57 applied P10 (first-time confirmation). Dormant patterns (P5, P11, P13, P14, P17) remain unvalidatable without artificial hypotheses.

### Novel Patterns Observed
None this run. H55 applied P6; H56 applied P7; H57 applied P10; H58 applied P12.

### Archive Check
Live log size after this run: Run 14 (~250 lines) + Run 13 (~258 lines) + Run 12 (~300 lines estimated) ≈ 808 lines × ~12 tokens/line ≈ **~9,700 tokens**. Under the 15,000-token threshold — no archive needed.

---

## Audit — 2026-04-15 (Run 13)

**Pulse (Analytics) active.**

**Target:** `skills/bump-dependencies/`
**Files:** 22 total (11 command, 4 support, 7 logs/archives)
**Token estimate:** ~31,000 tokens (instruction files ~17,500 after H49–H52 additions; support/logs ~13,500)

> Tier C — target matches, log dated 2026-04-14 (≤7 days). Proceeding to Run 13.

### Feature Inventory
Unchanged from Run 12. Multi-phase pipeline ✓, persona system ✓, subagents ✓, parallel execution ✓, cached artifacts ✓.

### Changes Since Run 12
1. **H49**: Root build script editing rules added to Step F (p0-bump.md).
2. **H50**: P18 (Cross-File Structural Anchor) promoted to p3-hypothesize.md.
3. **H51**: Integration failure push rationale added to Phase 8 Step D.
4. **H52**: Automated mode detection clarified in Phase 1b Step D.
5. **Version bumped to 4.7.0**.

### Structural gaps introduced or exposed by H49–H52
- Step F (H49) directs changelog URLs for root build script bumps to Step I — but Step I's table placeholder (`<alias/action>`) provides no format for variable-name identifiers (e.g., `kotlinVersion (build.gradle.kts)`). Agents have no prescribed identifier format for C.4-derived entries.
- Step D's 7-day safety window is described qualitatively ("older than seven days") per source type; the anchor (`BUMP_DATE`) is named once at the top but no arithmetic formula is given. An agent anchoring the comparison to "now" rather than BUMP_DATE would produce an incorrect cutoff across date boundaries.

### Persona Staleness Check
All 4 personas confirmed present and current (Ink, Echo, Rook, Arden — unchanged).

---

## Custom Metrics — 2026-04-15 (Run 13)

**Pulse (Analytics) active.**

EIS: 100 (carries forward). PEV: 50 (carries forward).

### MX50 — Step I Root Build Script Representation (RSBR) [custom]
**Measures:** Whether Step I's summary table template provides explicit identifier format guidance for root build script variable bumps discovered in Step C.4.
**Why seeds miss it:** MX45 measured whether Step F had editing rules for each Step C source type. It did not check whether Step I's output template accommodated C.4-derived entries. M6 ACC scores existing acceptance criteria as concrete — it does not detect a missing template row type.
**Methodology:** Inspect Step I. Check whether the table placeholder and/or accompanying notes give a format for root build script variable entries. Step F (H49) says "changelog URL captured in Step I summary" — implying C.4 entries must appear there. Current placeholder: `| <alias/action> |`. Root script variables: `kotlinVersion`, `compileSdkVersion`, etc. No mention of format in Step I. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1× — agents reaching Step I with a C.4 entry have no prescribed identifier format; inconsistent representations are the predictable result
**Normalisation:** present / absent × 100

### MX51 — Phase 1b Step D Timeout Coherence (PDTC) [custom]
**Measures:** Whether the 60-second timeout in Phase 1b Step D composes coherently with the automated-mode condition added in H52, rather than creating a redundant or contradictory fallback path.
**Why seeds miss it:** H52 fixed MX48 (automated mode detection). M3 IAR scores the individual conditions as non-ambiguous. Neither metric checks whether two fallback conditions for the "no user response" scenario contradict or overlap.
**Methodology:** Inspect Step D for both the 60-second timeout and the H52 automated-mode condition. Check whether the three bullets address logically distinct scenarios: (1) interactive user who may not respond in 60s → proceed after timeout; (2) user requests change → revise; (3) no interactive channel (subagent, CI) → proceed immediately. These target different audiences and do not contradict. Raw: 1/1.
**Normalised: 100.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** coherent / incoherent × 100

### MX52 — Phase 7 Integration Test Handoff Completeness (ITHC) [custom]
**Measures:** Whether Phase 7 Step A explicitly instructs the agent to retrieve and surface the Phase 8 bisect result and integration test finding in the summary comment.
**Why seeds miss it:** H51 documented Phase 8's rationale for continuing to push after a failing integration test. M7 HTC counts human touchpoints — it does not measure whether downstream phases receive and surface findings from earlier phases.
**Methodology:** Inspect Phase 7 Step A and Step B. Step A: "Also retrieve the Phase 8 consolidation summary (read `/tmp/dep-review-<PR-number>-consolidation-summary.md`): Integration test result (PASS / FAIL, suite name, counts); Bisect findings, if any." Step B template: "If failed: regression introduced by `<alias>` — see bisect findings in Phase 8." Both retrieval and surfacing are explicit. Raw: 1/1.
**Normalised: 100.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** complete / incomplete × 100

### MX53 — Cross-Phase Persona Continuity (CPPC) [custom]
**Measures:** Whether the Personas section in bump-dependencies.md accurately reflects the persona load directives in each phase file, with no orphaned or contradictory assignments.
**Why seeds miss it:** M4 WCS measures whether each persona is loaded in at least one phase. M14 PPF measures per-phase cognitive fit. Neither measures whether the orchestrator's Personas section is internally consistent with what the phase files actually load.
**Methodology:** Compare orchestrator Personas section (Ink→0,1b,4; Echo→2,3; Rook→2 security; Arden→5) against phase files: p0-bump.md loads Ink ✓; p1b loads Ink ✓; p2 loads Echo+Rook ✓; p3 loads Echo ✓; p4 loads Ink ✓; p5 loads Arden ✓. Phases 6, 7, 8 load no persona — consistent with orchestrator omission. Raw: 1/1.
**Normalised: 100.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** consistent / inconsistent × 100

### MX54 — Safety Window Date Anchor Explicitness (SWDAE) [custom, moonshot]
**Measures:** Whether Step D expresses the 7-day safety cutoff as an explicit arithmetic formula (`release_date ≤ BUMP_DATE − 7 days`) rather than a qualitative description ("older than seven days"), to prevent agents from anchoring the comparison to "now" rather than BUMP_DATE.
**Why seeds miss it:** MX34 (Temporal Safety Window Consistency) measured whether the 7-day window was consistently referenced across multiple files. MX54 asks a different question: is the formula sufficiently explicit that an agent reading a source-type subsection in isolation cannot silently use the wrong anchor? "Older than seven days" is unambiguous in isolation but does not name BUMP_DATE; the anchor instruction appears only at the top of the section.
**Methodology:** Inspect Step D opening. Check for an explicit formula. Current text: "Calculate 'seven days ago' relative to `BUMP_DATE`." No arithmetic expression present. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1× — silent anchor drift is unlikely in most runs but becomes possible when Phase 0 crosses a UTC midnight; explicit formula eliminates the ambiguity at zero instruction cost
**Normalisation:** present / absent × 100

---

## Baseline — 2026-04-15 (Run 13)

**Pulse (Analytics) active.**

### Inherited Metrics
All 66 metrics carry forward at Run 12 post-experiment values (8,029/9,000 = 89.2%). No instruction file changes since Run 12 affect any inherited metric.

### New Metrics This Run

| Metric | Score | Weight | Weighted |
|---|---|---|---|
| Step I Root Build Script Representation (MX50) | 0 | 1× | 0 |
| Phase 1b Timeout Coherence (MX51) | 100 | 1× | 100 |
| Phase 7 Integration Test Handoff Completeness (MX52) | 100 | 1× | 100 |
| Cross-Phase Persona Continuity (MX53) | 100 | 1× | 100 |
| Safety Window Date Anchor Explicitness (MX54) | 0 | 1× | 0 |

### Full Composite (71 metrics)

Inherited weighted sum: 8,029 (90×)
New metrics weighted sum: 0 + 100 + 100 + 100 + 0 = 300 (5×)
Total: **8,329 / 9,500 (95×)**

**Composite: 8,329 / 9,500 × 100 = 87.7%**

*(Drop of 1.5pp from scope expansion: 5 new weight units at 0–100; MX50 and MX54 score 0.)*

### Weakest Metrics (Phase 3 candidates)
1. MX50 — Step I Root Build Script Representation: 0 (1×)
2. MX54 — Safety Window Date Anchor Explicitness: 0 (1×, moonshot)
3. MX49 — Multi-Catalogue Dependency Deduplication Coverage: 0 (1×, moonshot, carries forward)

---

## Hypotheses — 2026-04-15 (Run 13)

*Keeper (Strategist) active.*

### Step 0 — Pre-Experiment Dependency Scan
H53 modifies p0-bump.md Step I (adds root build script format note).
H54 modifies p0-bump.md Step D (adds explicit formula).

File overlap — both hypotheses modify p0-bump.md. Running sequentially with re-check between each.
Execution order: H53 → H54.

### H53 — Add root build script identifier format to Step I
**Problem observed:** MX50 = 0. Step F (H49) explicitly states "the changelog URL is captured in the Step I summary" for root build script bumps — but Step I's table uses `<alias/action>` as its only row placeholder. Root build script variables (e.g., `kotlinVersion`, `compileSdkVersion`) do not fit the alias or action identifier spaces; agents have no prescribed format and will produce inconsistent representations.
**Change proposed:** Update the table row placeholder to `<alias/action/var>` and add a clarifying note immediately after the table: root build script variable bumps appear as `<varName> (<script-file>)` in the Dependency column, with a reference to Step F.
**Targets:** Step I Root Build Script Representation (MX50): 0 → 100 (+100pp)
**Predicted improvement:** MX50 +100pp (1× = +100 weighted)
**Pattern applied:** P12 — Content Synchronisation Audit (H49 updated Step F without updating Step I's output template)
**Risk level:** low
**Risk note:** Additive note only; placeholder rename from `<alias/action>` to `<alias/action/var>` is non-breaking. Cross-reference to Step F is by step name, not line number — stable to future edits.

### H54 — Add explicit safety window formula to Step D [moonshot]
**Problem observed:** MX54 = 0. Step D's 7-day safety rule is expressed as "older than seven days" per source-type subsection, with the anchor (`BUMP_DATE`) named once at the top. No explicit arithmetic formula is given. An agent reading a subsection in isolation could anchor the comparison to "now" (script execution time) rather than BUMP_DATE — producing an incorrect cutoff if Phase 0 runs across a UTC date boundary.
**Change proposed:** Replace "Calculate 'seven days ago' relative to `BUMP_DATE`." with an explicit formula at the top of Step D: "A version is safe when `release_date ≤ (BUMP_DATE − 7 days)`. The anchor is always `BUMP_DATE` (set in Step A) — not the time the batch script runs."
**Targets:** Safety Window Date Anchor Explicitness (MX54): 0 → 100 (+100pp)
**Predicted improvement:** MX54 +100pp (1× = +100 weighted)
**Pattern applied:** P6 — Symmetric Outcome Thresholds (adds concrete arithmetic expression to the safety threshold)
**Risk level:** low
**Risk note:** Wording change at the opening of Step D only; no changes to batch script templates or per-source-type comparison descriptions.

### Self-Audit (Keeper)
1. **Intent check:** H53 targets MX50 (0 < 100) ✓; H54 targets MX54 (0 < 100) ✓. Both address sub-100 metrics. ✓
2. **Coverage check:**
   - H53: +100 weighted
   - H54: +100 weighted
   - Projected: (8,329 + 200) / 9,500 = 8,529 / 9,500 = **89.8%** < 95%
3. **Gap fill:** MX49 = 0 (moonshot — deduplication logic complexity exceeds benefit). MX43 = 0 (moonshot). MX38 = 0 (moonshot). MX34 = 0 (moonshot). PEV = 50 (structural — H53 applies P12 [already validated], H54 applies P6 [already validated]; no tractable hypothesis available for the 5 dormant patterns). No non-moonshot metric below 80 without a hypothesis. ✓

### Recommendation Brief

1. **Add root build script identifier format to Step I** — Step F sends root build script changelog URLs to Step I but the table template has no prescribed format for variable-name identifiers like `kotlinVersion (build.gradle.kts)`.
2. **Add explicit date anchor formula to Step D** — the 7-day safety window names the anchor once but expresses each comparison qualitatively; an explicit formula (`release_date ≤ BUMP_DATE − 7 days`) eliminates the risk of incorrect anchor drift.

---

## Experiments — 2026-04-15 (Run 13)

**Arden (Critic) active.**

**Step 0 — Pre-Experiment Dependency Scan**
H53 modifies p0-bump.md Step I only. H54 modifies p0-bump.md Step D only. File overlap — running sequentially.
Execution order: H53 → H54.

---

### H53 — Add root build script identifier format to Step I

**Pre-change:** MX50 (Step I Root Build Script Representation): 0

**Post-change:** Table row placeholder updated from `<alias/action>` to `<alias/action/var>`. Clarifying note added immediately after the table specifying the format for root build script variable entries: `<varName> (<script-file>)`, e.g., `kotlinVersion (build.gradle.kts)`, with a cross-reference to Step F.
- MX50: 100 (+100pp)

**Delta:** MX50 +100pp
**Secondary deltas:** M3 IAR re-checked — additive note, no ambiguity introduced. M6 ACC re-checked — note is concrete (named format with example). No degradation.
**Result:** confirmed
**Notes:** P12 (Content Synchronisation Audit) applied — Step I's template was out of sync with Step F's routing instruction. P12 already validated (Run 10 H41); no new PEV credit.

---

### H54 — Add explicit safety window formula to Step D

**Pre-change (re-checked after H53):** MX54 (Safety Window Date Anchor Explicitness): 0

**Post-change:** Opening instruction replaced with: "A version is safe when `release_date ≤ (BUMP_DATE − 7 days)`. The anchor is always `BUMP_DATE` (set in Step A) — not the time the batch script runs."
- MX54: 100 (+100pp)

**Delta:** MX54 +100pp
**Secondary deltas:** M3 IAR re-checked — formula is deterministic and unambiguous. No degradation.
**Result:** confirmed
**Notes:** P6 (Symmetric Outcome Thresholds) applied — qualitative "older than seven days" description replaced with a concrete arithmetic expression. P6 already validated; no new PEV credit.

---

## Experiment Summary
- Confirmed: H53, H54
- Partial: none
- Disconfirmed: none

---

## Final Results — 2026-04-15 (Run 13)

### Post-Experiment Re-Measurement

| Metric | Baseline | Post | Delta | Weight | Weighted Δ |
|---|---|---|---|---|---|
| All inherited metrics (66) | 8,029 | 8,029 | 0 | 90× | 0 |
| Step I Root Build Script Representation (MX50) | 0 | 100 | +100 | 1× | +100 |
| Phase 1b Timeout Coherence (MX51) | 100 | 100 | — | 1× | 0 |
| Phase 7 Integration Test Handoff Completeness (MX52) | 100 | 100 | — | 1× | 0 |
| Cross-Phase Persona Continuity (MX53) | 100 | 100 | — | 1× | 0 |
| Safety Window Date Anchor Explicitness (MX54) | 0 | 100 | +100 | 1× | +100 |
| **TOTAL** | **8,329** | **8,529** | **+200** | **95×** | **+200** |

**Post-experiment composite: 8,529 / 9,500 × 100 = 89.8%**

### Composite History

| | Score | Metrics | Weight |
|---|---|---|---|
| Run 11 final | 89.8% | 61 | 85× |
| Run 12 baseline | 85.6% | 66 | 90× |
| Run 12 final | 89.2% | 66 | 90× |
| Run 13 baseline | 87.7% | 71 | 95× |
| **Run 13 final** | **89.8%** | **71** | **95×** |

Delta this run: +2.1pp.

### What improved and why
- Step I Root Build Script Representation (+100pp): identifier format for C.4 variable-name entries documented — agents now have a prescribed format (`<varName> (<script-file>)`) rather than inferring one from the TOML/Actions placeholder.
- Safety Window Date Anchor Explicitness (+100pp): arithmetic formula added to Step D — anchor ambiguity between BUMP_DATE and "now" eliminated.

### What was dropped
Nothing — both hypotheses confirmed.

### What remains to improve
- Multi-Catalogue Dependency Deduplication Coverage (MX49): 0 — moonshot; carries forward from Runs 11–13.
- Pre-Bump Base Branch CI Health Check (MX43): 0 — moonshot; carries forward.
- Changelog URL Annotation Freshness Risk (MX38): 0 — moonshot; carries forward.
- Temporal Safety Window Consistency (MX34): 0 — moonshot; carries forward.
- Pattern Experimental Validation Rate (PEV): 50 — structural; H53 applied P12 (already validated), H54 applied P6 (already validated). Dormant patterns (P5, P11, P13, P14, P17) embedded in workflow architecture; no artificial hypotheses.

### Novel Patterns Observed
None this run. H53 applied P12; H54 applied P6.

### Archive Check
Live log size after this run: ~8,200 tokens. Under the 15,000-token threshold — no archive needed.

---

---

## Audit — 2026-04-14 (Run 12)

**Pulse (Analytics) active.**

**Target:** `skills/bump-dependencies/`
**Files:** 22 total (11 command, 4 support, 7 logs/archives)
**Token estimate:** ~30,500 tokens (instruction files ~17,000; support/logs ~13,500)

> Tier C — target matches, archive completed this session (research-log reset). Proceeding to Run 12.

### Feature Inventory
Unchanged from Run 11. Multi-phase pipeline ✓, persona system ✓, subagents ✓, parallel execution ✓, cached artifacts ✓.

### Changes Since Run 11
1. **H45**: Step C.4 added to p0-bump.md for root build script version extraction.
2. **H46**: Batch lookup partial failure recovery added to Step D.
3. **H47**: BOM alias downstream guidance added to Step C.1.
4. **H48**: Ecosystem-specific commit body note added to Step G.
5. **Version bumped to 4.6.0**.

### Structural gaps introduced or exposed by H45–H48
- Step C.4 (H45) adds extraction logic for root build script versions. Step F has editing rules for TOML (C.1), Actions (C.2), and wrapper (C.3) — but no editing rules for root build scripts (C.4). Discovered versions cannot be applied without guidance.
- Phase 8 Step D bisect: after identifying a regression introducer, the instruction to "return to HEAD" is followed immediately by Step E (force-push). The rationale for pushing despite failing integration tests is implicit rather than stated.
- Phase 1b Step D automated mode: "if operating in a fully automated mode with no user present" — no detection method defined; agents cannot reliably determine which condition applies.
- P18 (Cross-File Structural Anchor) identified in Run 9 H40, noted as pending promotion in Runs 10 and 11. Still not in p3-hypothesize.md pattern library.

### Persona Staleness Check
All 4 personas confirmed present and current (Ink, Echo, Rook, Arden — unchanged).

---

## Custom Metrics — 2026-04-14 (Run 12)

**Pulse (Analytics) active.**

EIS: 100 (carries forward). PEV: 50 (carries forward).

### MX45 — Step F Source-Type Editing Rule Coverage (FSEC) [custom]
**Measures:** Whether Phase 0 Step F provides explicit editing rules for every source type that Step C can discover. Step C defines four source types (TOML catalogue, GitHub Actions, Gradle wrapper, root build scripts). Step F should have a corresponding editing section for each.
**Why seeds miss it:** M6 ACC measures concreteness of stop conditions and acceptance criteria. It scores each existing Step F sub-section as concrete, but does not detect missing sub-sections (a coverage gap, not a clarity gap). MX40 measured whether Step C had extraction steps for every source type — but did not check whether Step F had corresponding bump application rules.
**Methodology:** Count Step C source types: TOML ✓, Actions ✓, wrapper ✓, root scripts ✓ = 4. Count Step F editing rule sections: `### libs.versions.toml — editing rules` ✓, `### GitHub Actions — editing rules` ✓, `### gradle-wrapper.properties — editing rules` ✓, root build scripts — absent ✗. Raw: 3/4.
**Normalised: 75.**
**Direction:** ↑ higher is better
**Weight:** 1× — any root-build-script version discovered in Step C.4 cannot be applied; the agent must infer or skip it
**Normalisation:** rate × 100

### MX46 — Novel Pattern Promotion Currency (NPPC) [custom]
**Measures:** How many novel patterns logged as seed candidates in prior run Final Results sections have been promoted to `skills/optimise/commands/phases/p3-hypothesize.md`.
**Why seeds miss it:** M12 IFS measures whether the research-log is fresh. PEV measures whether existing seed patterns have been validated. Neither tracks whether newly discovered patterns have been written back into the seed library for future runs.
**Methodology:** Count novel patterns marked "pending promotion" in live or archived run logs. Count how many appear in p3-hypothesize.md. From Run 9 H40: P18 (Cross-File Structural Anchor) — logged as "pending promotion" in Runs 9, 10, and 11. Search p3-hypothesize.md for P18 or "Cross-File Structural Anchor": absent. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1× — stale pattern candidates reduce the quality of future hypothesis formation; three consecutive runs have noted this
**Normalisation:** rate × 100

### MX47 — Phase 8 Integration Failure Push Rationale (IFPR) [custom]
**Measures:** Whether Phase 8 Step D explicitly states that the force-push in Step E proceeds even when integration tests are still failing after bisect, and why (human review via Phase 7 summary comment).
**Why seeds miss it:** M7 HTC counts human decision touchpoints; it doesn't measure whether the rationale for proceeding past a failure is documented. RPC (Recovery Path Coverage) measures whether failure modes have recovery instructions, but the push-despite-failure path is not a recovery; it is deliberate forward progress.
**Methodology:** Inspect Phase 8 Step D. Check whether any sentence explicitly states: (a) that Phase 8 continues to Step E after bisect regardless of test result, and (b) why (Phase 7 will surface the finding; human decides on exclusion). Raw: 0/1 — Step D says "return to HEAD" and the flow continues to Step E implicitly; no explicit statement of intent or rationale.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1× — without explicit guidance, an agent may abort Phase 8 or attempt to fix the integration failure rather than continuing to push and letting Phase 7 surface the finding
**Normalisation:** present / absent × 100

### MX48 — Phase 1b Automated Mode Detection Clarity (AMDC) [custom]
**Measures:** Whether Phase 1b Step D's automated-mode fallback condition is operationally defined — i.e., whether an agent can determine at runtime which condition ("fully automated mode with no user present") applies.
**Why seeds miss it:** M3 IAR measures vague modal verbs and unscoped conditions. Step D's condition is a concrete trigger ("if operating in a fully automated mode with no user present"), which IAR would score as non-ambiguous. The gap is that the trigger describes an agent-context property with no detection method — the agent cannot determine from its environment alone whether it is "in a fully automated mode." The 60-second timeout and the automated-mode path address the same scenario but do not compose clearly.
**Methodology:** Inspect Step D. Check whether "fully automated mode" or "no user present" is defined by reference to a detectable runtime property (e.g., running as a subagent, CI context). Raw: 0/1 — condition is stated but no detection method is given.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1× — agents in automated pipelines (CI, subagent dispatch) need a clear signal; the 60-second fallback is impractical in those contexts
**Normalisation:** present / absent × 100

### MX49 — Multi-Catalogue Dependency Deduplication Coverage (MCDC) [custom, moonshot]
**Measures:** Whether Phase 0 provides guidance for handling duplicate version alias names across multiple `libs.versions.toml` files discovered by the composite-build glob added in H42. If two catalogues both define `kotlin = "1.9.0"`, Step D would generate two batch fetch calls for the same coordinates; Step F would attempt two edits.
**Why seeds miss it:** MX39 (Version Catalogue Discovery Completeness) measured whether Step C could find non-standard catalogue paths — it did not measure whether the subsequent processing steps handle the case where two catalogues share an alias. This gap was latent before H42; H42's broad glob makes it reachable.
**Methodology:** Inspect Step C and Step D for deduplication instructions. Step C says "Add any found at non-standard paths to the source file list" — no deduplication guidance. Step D generates one batch entry per resolved alias per source file — no cross-file deduplication. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1× — duplicate alias names across catalogues are uncommon in practice (most composite builds share a single root catalogue); but the instruction gap means duplicate fetch calls and potentially conflicting edits if they do occur
**Normalisation:** present / absent × 100

---

## Baseline — 2026-04-14 (Run 12)

**Pulse (Analytics) active.**

### Inherited Metrics
All 61 metrics carry forward at Run 11 post-experiment values (7,629/8,500 = 89.8%). No instruction file changes since Run 11 affect any inherited metric.

### New Metrics This Run

| Metric | Score | Weight | Weighted |
|---|---|---|---|
| Step F Source-Type Editing Rule Coverage (MX45) | 75 | 1× | 75 |
| Novel Pattern Promotion Currency (MX46) | 0 | 1× | 0 |
| Phase 8 Integration Failure Push Rationale (MX47) | 0 | 1× | 0 |
| Phase 1b Automated Mode Detection Clarity (MX48) | 0 | 1× | 0 |
| Multi-Catalogue Dependency Deduplication Coverage (MX49) | 0 | 1× | 0 |

### Full Composite (66 metrics)

Inherited weighted sum: 7,629 (85×)
New metrics weighted sum: 75 + 0 + 0 + 0 + 0 = 75 (5×)
Total: **7,704 / 9,000 (90×)**

**Composite: 7,704 / 9,000 × 100 = 85.6%**

*(Inherited 61-metric basis: 89.8% — unchanged. Drop of 4.2pp is entirely from scope expansion: 5 new weight units at 0–75 scores.)*

### Weakest Metrics (Phase 3 candidates)
1. MX46 — Novel Pattern Promotion Currency: 0 (1×)
2. MX47 — Phase 8 Integration Failure Push Rationale: 0 (1×)
3. MX48 — Phase 1b Automated Mode Detection Clarity: 0 (1×)
4. MX49 — Multi-Catalogue Dependency Deduplication Coverage: 0 (1×, moonshot)
5. MX45 — Step F Source-Type Editing Rule Coverage: 75 (1×)

---

## Hypotheses — 2026-04-14 (Run 12)

*Keeper (Strategist) active.*

### Step 0 — Pre-Experiment Dependency Scan
H49 modifies p0-bump.md Step F (adds root build script editing rules).
H50 modifies skills/optimise/commands/phases/p3-hypothesize.md (adds P18 pattern).
H51 modifies p8-consolidate.md Step D (adds integration failure push rationale).
H52 modifies p1b-split-commits.md Step D (clarifies automated mode detection).

No file overlaps — H49, H50, H51, H52 each modify a different file. All four can run in any order; running sequentially with re-check between each for correctness.
Execution order: H49 → H50 → H51 → H52.

### H49 — Add root build script editing rules to Step F
**Problem observed:** MX45 = 75. Step C.4 (added in H45) enables discovery and version extraction for root build scripts. Step D can look up safe versions for them. But Step F has no editing rules for applying bumps to Kotlin DSL (`val name = "X.Y.Z"`) or Groovy DSL (`ext.name = "X.Y.Z"`) variable declarations. An agent reaching Step F with a root build script entry has no prescribed edit to make.
**Change proposed:** Add a `### Root Gradle build scripts — editing rules` section to Step F, after the `### gradle-wrapper.properties — editing rules` section. Specify: locate each variable declaration identified in Step C.4; update the version string in place (Kotlin DSL: `val <name> = "<new>"`, Groovy DSL: `ext.<name> = "<new>"` or block value); do not add a trailing comment (build script parsing may reject it); include the changelog URL in the Step I summary and PR body instead; include this edit in the same atomic commit as any corresponding TOML alias if it controls the same dependency.
**Targets:** Step F Source-Type Editing Rule Coverage (MX45): 75 → 100 (+25pp)
**Predicted improvement:** MX45 +25pp (1× = +25 weighted)
**Pattern applied:** P3 — Progressive Disclosure (extends the existing per-source-type editing rule sequence)
**Risk level:** low
**Risk note:** Additive — new section only; no existing editing rules modified. Affects only projects with root-level version declarations (uncommon in modern Android projects).

### H50 — Promote P18 (Cross-File Structural Anchor) to p3-hypothesize.md
**Problem observed:** MX46 = 0. The Cross-File Structural Anchor pattern was introduced in Run 9 H40 and has been noted as a "seed candidate pending promotion" in three consecutive run Final Results sections (Runs 9, 10, 11). It has not been added to the optimise skill's pattern library.
**Change proposed:** Add `#### P18 — Cross-File Structural Anchor` to `skills/optimise/commands/phases/p3-hypothesize.md`, after the P17 section. Content: for workflows where one instruction file references a named section in another file, use the exact section heading as the reference anchor rather than a content description. Section headings are stable, searchable, and survive prose edits; content descriptions drift and become ambiguous. Targets: HCU (↑), IAR (↓).
**Targets:** Novel Pattern Promotion Currency (MX46): 0 → 100 (+100pp)
**Predicted improvement:** MX46 +100pp (1× = +100 weighted)
**Pattern applied:** P12 — Content Synchronisation Audit (pattern library out of sync with logged discoveries)
**Risk level:** low
**Risk note:** Additive to p3-hypothesize.md — no existing patterns modified. The pattern describes an already-validated behaviour (used in p0-bump.md Step E to reference a section in p2-investigate.md).

### H51 — Add integration failure push rationale to Phase 8 Step D
**Problem observed:** MX47 = 0. Phase 8 Step D ends by instructing the agent to "return to the HEAD of the consolidated branch." Step E then force-pushes. The transition is implicit: the force-push proceeds even if the integration test suite is still failing. An agent without this context might abort Phase 8 or attempt to remediate the integration failure rather than push and let Phase 7 surface the finding.
**Change proposed:** Add an explicit continuation note at the end of Phase 8 Step D, after "Return to the HEAD of the consolidated branch": "Phase 8 proceeds to Step E (force-push) regardless of the integration test result. The consolidated branch is pushed so the PR is available for human review — Phase 7's summary comment will surface the regression finding and the bisect result. Do not abort Phase 8 or attempt to fix the integration failure here; the human decides whether to exclude the regression-introducing alias."
**Targets:** Phase 8 Integration Failure Push Rationale (MX47): 0 → 100 (+100pp)
**Predicted improvement:** MX47 +100pp (1× = +100 weighted)
**Pattern applied:** P10 — Failure Mode Registry (documents the prescribed response to a specific failure path)
**Risk level:** low
**Risk note:** Documentation-only addendum; no execution logic changed. Clarifies existing implicit behaviour.

### H52 — Clarify automated mode detection in Phase 1b Step D
**Problem observed:** MX48 = 0. Phase 1b Step D says "if operating in a fully automated mode with no user present, print the plan and proceed immediately." Neither "fully automated mode" nor "no user present" maps to a runtime-detectable property. The 60-second timeout ("if the user does not respond within 60 seconds") attempts to handle the same scenario but is impractical in agent contexts where there is no actual timer or interactive session.
**Change proposed:** Replace "If operating in a fully automated mode with no user present, print the plan and proceed immediately." with: "If there is no interactive channel to the user — for example, this agent is running as a subagent dispatched by an orchestrator, or in a non-interactive CI context — print the plan and proceed immediately without waiting for confirmation."
**Targets:** Phase 1b Automated Mode Detection Clarity (MX48): 0 → 100 (+100pp)
**Predicted improvement:** MX48 +100pp (1× = +100 weighted)
**Pattern applied:** P7 — Binary Applicability Gates (replaces vague context condition with runtime-observable property)
**Risk level:** low
**Risk note:** Wording change only; no execution logic changed. Preserves the intent of the original instruction.

### Self-Audit (Keeper)
1. **Intent check:** H49 targets MX45 (75 < 100) ✓; H50 targets MX46 (0 < 100) ✓; H51 targets MX47 (0 < 100) ✓; H52 targets MX48 (0 < 100) ✓. All four target sub-100 metrics. ✓
2. **Coverage check:**
   - H49: +25 weighted
   - H50: +100 weighted
   - H51: +100 weighted
   - H52: +100 weighted
   - Projected: (7,704 + 25 + 100 + 100 + 100) / 9,000 = 8,029/9,000 = **89.2%** < 95%
3. **Gap fill:** MX49 = 0 (moonshot — duplicate alias names across composite-build catalogues are uncommon in practice; adding deduplication logic to Step D would significantly complicate the batch script for a rare scenario). MX43 = 0 (moonshot — carries forward from Run 11). MX38 = 0 (moonshot). MX34 = 0 (moonshot). PEV = 50 (structural — H49 applies P3 [already validated], H50 applies P12 [already validated], H51 applies P10 [already validated], H52 applies P7 [already validated]; no new PEV credit from any of these. Remaining unvalidated patterns — P5, P11, P13, P14, P17 — are embedded in the workflow architecture; artificial hypotheses would degrade clarity). No non-moonshot metric below 80 remains without a hypothesis. ✓

### Recommendation Brief

1. **Add root build script editing rules to Step F** — Step C.4 can discover versions in root build scripts and Step D can look up safe replacements, but Step F has no editing rules for applying those bumps; discovered versions are silently stranded.
2. **Promote P18 (Cross-File Structural Anchor) to the optimise pattern library** — identified in Run 9, noted as pending for three consecutive runs; the pattern is already used in practice and belongs in the seed library.
3. **Add integration failure push rationale to Phase 8 Step D** — after bisect, Phase 8 continues to force-push even with failing tests; without an explicit rationale, agents may abort or attempt to fix the failure rather than letting Phase 7 surface the finding.
4. **Clarify automated mode detection in Phase 1b Step D** — the current "fully automated mode with no user present" condition has no runtime-detectable definition; replacing it with a concrete context check (subagent dispatch, CI context) eliminates the ambiguity.

---


---

## Experiments — 2026-04-14 (Run 12)

**Arden (Critic) active.**

**Step 0 — Pre-Experiment Dependency Scan**
H49 modifies p0-bump.md Step F only. H50 modifies p3-hypothesize.md only. H51 modifies p8-consolidate.md only. H52 modifies p1b-split-commits.md only. No file overlaps across any pair of hypotheses — all four can run independently. Running sequentially for traceability.
Execution order: H49 → H50 → H51 → H52.

---

### H49 — Add root build script editing rules to Step F

**Pre-change:** MX45 (Step F Source-Type Editing Rule Coverage): 75 (3/4 source types)

**Post-change:** `### Root Gradle build scripts — editing rules` section added to Step F, after the Gradle wrapper section. Covers Kotlin DSL (`val <name> = "<new>"`) and Groovy DSL (`ext.<name> = "<new>"` and `ext { }` block). Confirms no trailing comment (to avoid `buildSrc` parsing issues). Notes changelog URL goes in Step I summary and PR body instead. Advises co-committing with corresponding TOML alias if same dependency.
- MX45: 100 (+25pp)

**Delta:** MX45 +25pp
**Secondary deltas:** M3 re-checked — additive section, no ambiguity introduced. M6 ACC re-checked — new rules are concrete (named DSL patterns, explicit no-comment rule). No degradation.
**Result:** confirmed
**Notes:** P3 (Progressive Disclosure) applied — extends the existing per-source-type editing rule sequence. P3 already validated (Run 10 H42); no new PEV credit.

---

### H50 — Promote P18 (Cross-File Structural Anchor) to p3-hypothesize.md

**Pre-change (re-checked after H49):** MX46 (Novel Pattern Promotion Currency): 0

**Post-change:** `#### P18 — Cross-File Structural Anchor` added to p3-hypothesize.md after P17. Header reference updated from "P1–P14" to "P1–P18". P18 documents the use of exact section heading names as cross-file reference anchors.
- MX46: 100 (+100pp)

**Delta:** MX46 +100pp
**Secondary deltas:** M12 HCU re-checked — p3-hypothesize.md now reflects all confirmed novel patterns; no new out-of-sync entries. No degradation.
**Result:** confirmed
**Notes:** P12 (Content Synchronisation Audit) applied — pattern library out of sync with logged discoveries for 3 runs. P12 already validated (Run 10 H41); no new PEV credit.

---

### H51 — Add integration failure push rationale to Phase 8 Step D

**Pre-change (re-checked after H50):** MX47 (Phase 8 Integration Failure Push Rationale): 0

**Post-change:** Continuation note added at the end of Phase 8 Step D: "Phase 8 proceeds to Step E (force-push) regardless of the integration test result. The consolidated branch is pushed so the PR is available for human review — Phase 7's summary comment will surface the regression finding and the bisect result. Do not abort Phase 8 or attempt to fix the integration failure here; the human decides whether to exclude the regression-introducing alias."
- MX47: 100 (+100pp)

**Delta:** MX47 +100pp
**Secondary deltas:** M7 HTC re-checked — no new touchpoint added (push proceeds without asking). No degradation.
**Result:** confirmed
**Notes:** P10 (Failure Mode Registry) applied — documents the prescribed forward path for the bisect-finds-regression failure mode. P10 already validated; no new PEV credit.

---

### H52 — Clarify automated mode detection in Phase 1b Step D

**Pre-change (re-checked after H51):** MX48 (Phase 1b Automated Mode Detection Clarity): 0

**Post-change:** "If operating in a fully automated mode with no user present" replaced with "If there is no interactive channel to the user — for example, this agent is running as a subagent dispatched by an orchestrator, or in a non-interactive CI context — print the plan and proceed immediately without waiting for confirmation."
- MX48: 100 (+100pp)

**Delta:** MX48 +100pp
**Secondary deltas:** M3 IAR re-checked — replaced phrase now refers to runtime-observable context properties (subagent dispatch, CI context) rather than a vague mode label. IAR unchanged (already high). No degradation.
**Result:** confirmed
**Notes:** P7 (Binary Applicability Gates) applied — replaces vague context condition with concrete runtime-observable properties. P7 already validated; no new PEV credit.

---

## Experiment Summary
- Confirmed: H49, H50, H51, H52
- Partial: none
- Disconfirmed: none

---

## Final Results — 2026-04-14 (Run 12)

### Post-Experiment Re-Measurement

| Metric | Baseline | Post | Delta | Weight | Weighted Δ |
|---|---|---|---|---|---|
| All inherited metrics (61) | 7,629 | 7,629 | 0 | 85× | 0 |
| Step F Source-Type Editing Rule Coverage (MX45) | 75 | 100 | +25 | 1× | +25 |
| Novel Pattern Promotion Currency (MX46) | 0 | 100 | +100 | 1× | +100 |
| Phase 8 Integration Failure Push Rationale (MX47) | 0 | 100 | +100 | 1× | +100 |
| Phase 1b Automated Mode Detection Clarity (MX48) | 0 | 100 | +100 | 1× | +100 |
| Multi-Catalogue Dependency Deduplication Coverage (MX49) | 0 | 0 | — | 1× | 0 |
| **TOTAL** | **7,704** | **8,029** | **+325** | **90×** | **+325** |

**Post-experiment composite: 8,029 / 9,000 × 100 = 89.2%**

### Composite History

| | Score | Metrics | Weight |
|---|---|---|---|
| Run 10 final | 90.2% | 56 | 80× |
| Run 11 baseline | 87.3% | 61 | 85× |
| Run 11 final | 89.8% | 61 | 85× |
| Run 12 baseline | 85.6% | 66 | 90× |
| **Run 12 final** | **89.2%** | **66** | **90×** |

Delta this run: +3.6pp.

### What improved and why
- Phase 8 Integration Failure Push Rationale (+100pp): continuation note added to Step D — agents now have an explicit rationale for proceeding to Step E after bisect, preventing premature abort or self-directed remediation.
- Phase 1b Automated Mode Detection Clarity (+100pp): vague "fully automated mode" condition replaced with runtime-observable context properties (subagent dispatch, CI context).
- Novel Pattern Promotion Currency (+100pp): P18 (Cross-File Structural Anchor) promoted to p3-hypothesize.md after three consecutive runs as a pending candidate.
- Step F Source-Type Editing Rule Coverage (+25pp): root build script editing rules added — all four Step C source types now have corresponding Step F editing guidance.

### What was dropped
Nothing — all four hypotheses confirmed.

### What remains to improve
- Multi-Catalogue Dependency Deduplication Coverage (MX49): 0 — moonshot; duplicate alias names across composite-build catalogues are uncommon in practice; adding cross-file deduplication to Step D would significantly complicate the batch script for a rare edge case.
- Pre-Bump Base Branch CI Health Check (MX43): 0 — moonshot; carries forward from Run 11. Adding a CI check to Step A without a decision gate would only surface as a warning, not prevent false failure attribution.
- Changelog URL Annotation Freshness Risk (MX38): 0 — moonshot (dead-link accumulation).
- Temporal Safety Window Consistency (MX34): 0 — moonshot (TOCTOU at midnight).
- Pattern Experimental Validation Rate (PEV): 50 — structural; H49–H52 applied already-validated patterns (P3, P12, P10, P7); remaining 5 unvalidated patterns (P5, P11, P13, P14, P17) are embedded in the workflow architecture.

### Novel Patterns Observed
None this run. H49–H52 applied existing patterns (P3, P12, P10, P7).

### Archive Check
Live log size after this run: ~5,200 tokens. Well under the 15,000-token threshold — no archive needed.

---

