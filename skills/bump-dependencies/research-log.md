## Archive: see research-log-archive-2026-04-14.md for runs prior to 2026-04-14 (Runs 1–8)
Prior target: `skills/review-dependency-update/` — same skill, renamed at v4.0.0.
Prior final composite (Run 8): **93.6%** (44 metrics, 66× weight). All at 100 except RI=98, HTC=95, CLE=94.

---

## Custom Metrics — 2026-04-14 (Run 9)

**Pulse (Analytics) active.**

MX-OQ series: SKIP — bump-dependencies does not produce `.kanban/` subjects.
HCU (P12 target): SKIP — no parallel help/reference file in this skill.
PEV (P13 target): SKIP — no confirmed experiment data in new research-log.
EIS (P14 target): SKIP — no multi-hypothesis Phase 4 sessions on record.

### MX30 — Pre-Release Version Filter Coverage (PVFC) [custom]
**Measures:** Whether all four version lookup paths in Phase 0 Step D explicitly exclude pre-release versions. A proactive bump to an `-alpha`, `-beta`, `-rc`, or similar version would undermine the skill's core promise of safe, stable updates.
**Why seeds miss it:** MX9 (Pre-Release Version Handling) measures Phase 2's handling of version range edge cases in investigation — not whether Phase 0's discovery step excludes pre-releases before bumping. No existing metric measures version quality in Phase 0's lookup step.
**Methodology:** Enumerate the four version lookup paths in Phase 0 Step D (Maven batch, Gradle Plugin Portal, GitHub Actions GraphQL, Gradle wrapper). For each, check whether there is an explicit instruction to exclude pre-release versions. PVFC = paths with explicit pre-release exclusion / 4.
- Maven batch: no pre-release exclusion specified ✗
- Gradle Plugin Portal: no pre-release exclusion specified ✗
- GitHub Actions GraphQL: no `isPrerelease: false` filter or equivalent ✗
- Gradle wrapper: "Filter to stable releases only (exclude `-rc`, `-milestone`, `-nightly` suffixes)" ✓
Raw: 1/4. **Normalised: 25.**
**Direction:** ↑ higher is better
**Weight:** 2× — bumping to a pre-release is a correctness failure that directly contradicts the skill's stated purpose
**Normalisation:** rate × 100

### MX31 — Proactive PR Deduplication Guard (PPDG) [custom]
**Measures:** Whether Phase 0 checks for an existing open PR from the same bump branch before creating a new one. Running `/bump-dependencies` twice in rapid succession produces two identical open PRs — a confusing state that requires manual cleanup.
**Why seeds miss it:** No existing metric measures idempotency of the PR creation step. MX17 (Branch Naming Collision Guard) checks that isolated review branches include the PR number; it does not check whether the top-level proactive PR is created only once. RPC checks recovery paths for errors; it does not check for pre-condition validation before writes.
**Methodology:** Inspect Phase 0 Step H. Check whether it includes any guard against creating a duplicate PR — e.g., `gh pr list --head <BUMP_BRANCH>` check before `gh pr create`. Raw: 0/1 (no check present). **Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1× — creates duplicate PRs but not a safety or correctness risk; easily cleaned up manually
**Normalisation:** rate × 100

### MX32 — Phase 0 Cross-File Table Dependency Stability (CTDS) [custom]
**Measures:** Whether Phase 0's reference to Phase 2's changelog source table includes a structural anchor (e.g., a section header name) that survives refactoring of p2-investigate.md. The current instruction says "read only the table section — do not execute Phase 2" without specifying which section header to navigate to.
**Why seeds miss it:** IOT (Intent-to-Output Traceability) measures whether phases re-read prior artifacts; it does not measure the structural stability of cross-file references. MX3 (Phase File Navigation Completeness) checks that each phase file ends with a `→ Next` pointer; it does not check the robustness of in-phase cross-file references.
**Methodology:** Inspect Phase 0 Step E. Check whether the reference to "the Kotlin/Android primary sources table in `phases/p2-investigate.md`" includes a section header anchor or equivalent structural locator. Raw: 0/1 (anchor absent). **Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1× — the reference works today; the structural risk is about future resilience after refactoring
**Normalisation:** rate × 100

### MX33 — Version Monotonicity Guard (VMG) [custom]
**Measures:** Whether Phase 0 explicitly protects against downgrading a dependency already at a version higher than the newest safe release. This can occur when a developer manually bumps to a version published fewer than seven days ago — Phase 0's `safe_latest` would then be older than the current version, and without an explicit comparison guard, the skill could attempt a downgrade.
**Why seeds miss it:** No existing metric measures whether the skill validates version direction before writing. MX9 measures Phase 2's version span handling; it does not apply to Phase 0's discovery step. The skip condition "if safe_latest ≤ current_version, skip" is implicit in the phrase "safe update available" but never stated as a rule.
**Methodology:** Inspect Phase 0 Step F. Check whether there is an explicit instruction to compare `safe_latest` against `current_version` and skip the dependency if `safe_latest ≤ current_version`. Raw: 0/1 (no explicit comparison). Partial credit: the phrase "safe update available" implies `safe_latest > current_version` for a reasonable agent. **Normalised: 50.**
**Direction:** ↑ higher is better
**Weight:** 2× — an unintended downgrade could break a build that was working; the fix is a one-line explicit comparison
**Normalisation:** rate × 100

### MX34 — Temporal Safety Window Consistency (TSWC) [custom, moonshot]
**Measures:** Whether the 7-day safety window in Phase 0 is calculated consistently across all dependencies. `BUMP_DATE` is set once at Phase 0 Step A. If Phase 0 runs long enough to cross midnight, later dependencies have their safety windows calculated against a date that is now "yesterday" — a version published 6 days ago (unsafe) could appear to be 7 days old (safe) relative to BUMP_DATE.

Borrows from "time-of-check to time-of-use" (TOCTOU) in security engineering: the time at which a property is checked may differ from the time at which it is relied upon.
**Why seeds miss it:** No existing metric measures temporal consistency within a single-phase execution. All prior metrics treat phases as instantaneous. This is the first metric to recognise that Phase 0 is a multi-step operation where the real-time clock matters.
**Methodology:** Inspect Phase 0 Step A and Step D. Check whether the safety window uses `BUMP_DATE` (set once) or real current time per dependency. Raw: 0/1 — BUMP_DATE is static throughout Phase 0. **Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1× — practical risk window is narrow (requires >5 minutes and a midnight crossing); theoretically real, practically rare
**Normalisation:** rate × 100

---

## Baseline — 2026-04-14 (Run 9)

**Pulse (Analytics) active.**

### Scope Expansion Note
Phase 0 adds ~4,000 tokens and 7 new weight units (MX30–MX34) to the scoring surface. The baseline drop from 93.6% (Run 8) to 85.3% (Run 9) is primarily a measurement artefact from scope expansion — the PR-review pipeline (Phases 1–8) is unchanged and all 44 prior metrics re-verify at their Run 8 final values.

### Inherited Metrics (44 from Run 8 post-experiment, re-verified)
All carry forward at Run 8 final values. Key re-verification findings:
- **M1 IOT (100):** Phase 0 is the root generator; Phases 1–8 all explicitly re-read session brief or prior output. ✓
- **M5 RI (98):** Phase 0 and Phase 1 both have prerequisite checks (git remote + gh auth) — each is an independent entry-point guard, not removable duplication. Retained at 98.
- **M8 HTC (95):** One touchpoint (Phase 1b Step D). Phase 0 has no human touchpoints. ✓
- **M10 CLE (94):** Phase 0 references Phase 2's changelog table section (partial load). Structural overhead unchanged. ✓
- **M14 PPF (100):** Phase 0 assigns Ink for commit curation — full cognitive fit. ✓
- **RPC (100):** Phase 0 adds well-specified recovery paths: non-GitHub remote, unauthenticated gh, uncommitted working tree, branch name collision, no safe updates available. ✓
- **MX1–MX29 (all 100):** Phase 0 does not touch the metric domains covered by these. ✓

### Full Composite (49 metrics)

| Metric | Source | Normalised | Weight | Weighted |
|---|---|---|---|---|
| Intent-to-Output Traceability | seed | 100 | 2× | 200 |
| Directive Density | seed | 100 | 1× | 100 |
| Instruction Ambiguity Rate | seed | 100 | 1× | 100 |
| Wiring Completeness Score | seed | 100 | 1× | 100 |
| Redundancy Index | seed | 98 | 1× | 98 |
| AC Concreteness | seed | 100 | 2× | 200 |
| Subagent Alignment Score | seed | 100 | 1× | 100 |
| Human Touchpoint Count | seed | 95 | 2× | 190 |
| Context Loading Efficiency | seed | 94 | 2× | 188 |
| Parallelisation Safety Score | seed | 100 | 1× | 100 |
| Information Freshness Score | seed | 100 | 2× | 200 |
| Instruction Token Efficiency | seed | 99 | 1× | 99 |
| Persona-Phase Fit Score | seed | 100 | 1× | 100 |
| Persona Richness Score | seed | 100 | 1× | 100 |
| Recovery Path Completeness | custom (RPC) | 100 | 1× | 100 |
| Changelog Source Coverage | custom (MX1) | 100 | 1× | 100 |
| Agent Prompt Completeness | custom (MX2) | 100 | 1× | 100 |
| Phase File Navigation Completeness | custom (MX3) | 100 | 1× | 100 |
| Verdict Scoring Calibration | custom (MX4) | 100 | 1× | 100 |
| Cross-Bump Context Isolation | custom (MX5) | 100 | 1× | 100 |
| Comment Template Completeness | custom (MX6) | 100 | 1× | 100 |
| Fallback Path Fidelity | custom (MX7) | 100 | 1× | 100 |
| Pipeline Diagram Accuracy | custom (MX8) | 100 | 1× | 100 |
| Pre-Release Version Handling (Phase 2) | custom (MX9) | 100 | 1× | 100 |
| Adversarial Prompt Resistance | custom (MX10) | 100 | 2× | 200 |
| Source Commit Inspection Coverage | custom (MX11) | 100 | 2× | 200 |
| Deep Lockfile Diffing Coverage | custom (MX12) | 100 | 1× | 100 |
| Git Tag Signing Verification | custom (MX13) | 100 | 2× | 200 |
| Registry Artifact Signing Coverage | custom (MX14) | 100 | 2× | 200 |
| Security Pass Completeness Score | custom (MX15) | 100 | 2× | 200 |
| Isolated Branch Lifecycle Completeness | custom (MX16) | 100 | 2× | 200 |
| Branch Naming Collision Guard | custom (MX17) | 100 | 1× | 100 |
| Consolidation Partial-Failure Recovery | custom (MX18) | 100 | 2× | 200 |
| Sub-Agent Branch Context Fidelity | custom (MX19) | 100 | 1× | 100 |
| Consolidation-to-Summary Data Handoff | custom (MX20) | 100 | 2× | 200 |
| Null-Manifest Edge Case Coverage | custom (MX21) | 100 | 2× | 200 |
| Skipped-Alias Reporting Completeness | custom (MX22) | 100 | 1× | 100 |
| Bisect State Recovery | custom (MX23) | 100 | 1× | 100 |
| Verdict Plain-English Specificity | custom (MX24) | 100 | 1× | 100 |
| Consolidation Summary Persistence | custom (MX25) | 100 | 2× | 200 |
| Sub-Agent Return Contract Completeness | custom (MX26) | 100 | 1× | 100 |
| Ecosystem Prerequisite Gate | custom (MX27) | 100 | 2× | 200 |
| Temp File Path Safety Score | custom (MX28) | 100 | 1× | 100 |
| Codebase Search Ecosystem Completeness | custom (MX29) | 100 | 2× | 200 |
| Pre-Release Version Filter Coverage | custom (MX30) | 25 | 2× | 50 |
| Proactive PR Deduplication Guard | custom (MX31) | 0 | 1× | 0 |
| Phase 0 Cross-File Table Dep. Stability | custom (MX32) | 0 | 1× | 0 |
| Version Monotonicity Guard | custom (MX33) | 50 | 2× | 100 |
| Temporal Safety Window Consistency | custom (MX34) | 0 | 1× | 0 |
| **TOTAL** | | | **73×** | **6,229** |

**Composite: 6,229 / (73 × 100) × 100 = 85.3%**

*(Inherited 44-metric basis: 6,179 / 6,600 × 100 = 93.6% — unchanged from Run 8. The 8.3pp composite drop is entirely attributable to Phase 0 scope expansion: 7 new weight units at 0–50 scores.)*

### Weakest Metrics (Phase 3 candidates)
1. Proactive PR Deduplication Guard — 0 (1×)
2. Phase 0 Cross-File Table Dependency Stability — 0 (1×)
3. Temporal Safety Window Consistency — 0 (1×, moonshot)
4. Pre-Release Version Filter Coverage — 25 (2×) — highest urgency given 2× weight
5. Version Monotonicity Guard — 50 (2×)

---

## Experiments — 2026-04-14 (Run 9)

**Keeper (Strategist) active.**

### Step 0 — Pre-Experiment Dependency Scan
H37 modifies p0-bump.md Step D.
H38 modifies p0-bump.md Step F.
H39 modifies p0-bump.md Step H.
H40 modifies p0-bump.md Step E.

H37 and H38 both modify p0-bump.md, different steps — run sequentially. H39 and H40 modify different steps with no content overlap — can follow in any order.
Execution order: H37 → H38 → H39 → H40.

### H37 — Phase 0 Pre-Release Version Filtering
**Problem observed:** Pre-Release Version Filter Coverage = 25. Phase 0 Step D explicitly filters pre-releases for the Gradle wrapper only. Maven, Gradle Plugin Portal, and GitHub Actions paths have no equivalent filter. A proactive bump could install an `-alpha` or `-rc` version.
**Change proposed:** Add explicit pre-release exclusion to each unfiltered lookup path in Phase 0 Step D: (1) Maven batch parse: filter out versions matching `-alpha`, `-beta`, `-rc`, `-SNAPSHOT`, `-M`, `-milestone` suffixes before selecting safe_latest; (2) Gradle Plugin Portal fallback maven-metadata.xml parse: same suffix exclusion; (3) GitHub Actions GraphQL: add "skip releases where `isPrerelease: true`" to release selection.
**Targets:** Pre-Release Version Filter Coverage (↑, from 25 to 100)
**Predicted improvement:** MX30 +75pp (2× → +150 weighted points)
**Pattern applied:** P7 — Binary Applicability Gates
**Risk level:** low
**Risk note:** Additive filter only; the only change is that a pre-release version that was previously the newest entry would be skipped in favour of the next older stable entry.

### H38 — Version Monotonicity Explicit Guard
**Problem observed:** Version Monotonicity Guard = 50. Phase 0 Step F uses "safe update available" without defining this to require `safe_latest > current_version`. An agent could attempt a downgrade when a dependency has been manually bumped above the 7-day threshold.
**Change proposed:** Add an explicit comparison step to Phase 0 Step F: before applying any edit, check whether `safe_latest > current_version`. If not, skip and record under a new "Skipped (already ahead of safe latest)" row in the Step I summary. Add a definitional note: "'safe update available' means `safe_latest > current_version` AND `safe_latest` was published more than seven days ago."
**Targets:** Version Monotonicity Guard (↑, from 50 to 100)
**Predicted improvement:** MX33 +50pp (2× → +100 weighted points)
**Pattern applied:** P7 — Binary Applicability Gates
**Risk level:** low
**Risk note:** No behavioural change for the common case. The new skip condition only fires when a project has manually advanced a dependency beyond the 7-day safety threshold.

### H39 — Proactive PR Deduplication Guard
**Problem observed:** Proactive PR Deduplication Guard = 0. Phase 0 Step H calls `gh pr create` unconditionally. A second run on the same day produces a second open PR.
**Change proposed:** Add a pre-creation check to Phase 0 Step H: run `gh pr list --head <BUMP_BRANCH> --repo <owner/repo> --json number,url` before `gh pr create`. If an open PR already exists, print its URL and skip creation: "PR already exists for this branch (#<number>). Proceeding with the existing PR."
**Targets:** Proactive PR Deduplication Guard (↑, from 0 to 100)
**Predicted improvement:** MX31 +100pp (1× → +100 weighted points)
**Pattern applied:** P10 — Failure Mode Registry
**Risk level:** low
**Risk note:** One extra API call; the happy path (no existing PR) is unaffected.

### H40 — Phase 0 Cross-File Table Structural Anchor
**Problem observed:** Phase 0 Cross-File Table Dependency Stability = 0. Phase 0 Step E says "read only the table section" without specifying the section header. Ambiguous after any restructuring of p2-investigate.md.
**Change proposed:** Update Phase 0 Step E to name the specific section: replace "read only the table section" with "navigate to the `### Kotlin/Android primary sources` section heading in that file".
**Targets:** Phase 0 Cross-File Table Dependency Stability (↑, from 0 to 100)
**Predicted improvement:** MX32 +100pp (1× → +100 weighted points)
**Pattern applied:** novel — Cross-File Structural Anchor
**Risk level:** low
**Risk note:** The section header `### Kotlin/Android primary sources` is stable and has been present since Phase 2 was written.

### Self-Audit Results
- **Intent check:** all four hypotheses target metrics below 100. ✓
- **Coverage check:** projected composite = (6,229 + 150 + 100 + 100 + 100) / 7,300 × 100 = **91.5%**. Below 95%.
- **Gap fill:** remaining sub-100 after hypotheses: RI=98 (deliberate), HTC=95 (deliberate), CLE=94 (structural), MX34=0 (moonshot — temporal drift requires a midnight crossing during Phase 0; practical risk negligible). No further actionable hypotheses.

### Recommendation Brief

Based on baseline measurement, the following experiments are queued.

1. **Phase 0 pre-release filtering** — Maven, Gradle Plugin Portal, and GitHub Actions version lookups do not exclude pre-release versions; adding explicit filters ensures Phase 0 never bumps to an `-alpha`, `-beta`, or `-rc` release.
2. **Version direction guard** — Phase 0 does not explicitly state that a "safe update" requires the new version to be newer than the current one; adding a comparison step prevents unintended downgrades of manually-advanced dependencies.
3. **Proactive PR deduplication** — Phase 0 creates a PR unconditionally on every run; a one-line `gh pr list` check prevents duplicate open PRs when the skill is run twice before the first PR is reviewed.
4. **Cross-file table anchor** — Phase 0 references Phase 2's changelog source table by description rather than by section header; naming the specific section header makes the reference stable to future refactoring.

---

## Audit — 2026-04-14 (Run 9)

**Pulse (Analytics) active.**

**Target:** skills/bump-dependencies/
**Files:** 15 total (11 command, 4 support)
**Token estimate:** ~25,000 tokens (~92% growth from Run 8 — new Phase 0 adds ~4,000 tokens; orchestrator rewritten with full wave protocol)

### Feature Inventory
- Multi-phase pipeline: yes
- Persona system: yes
- Subagent invocations: yes
- Multi-session orchestration: no
- Parallel execution: yes
- Cached artifacts: yes

### Files
**Command files (11):** bump-dependencies.md, p0-bump.md, p1-parse.md, p1b-split-commits.md, p2-investigate.md, p3-impact.md, p4-remediate.md, p5-verdict.md, p6-comment.md, p7-summary.md, p8-consolidate.md
**Support files (4):** SKILL.md, AGENTS.md, VERSION.md, CHANGELOG.md

### TTL Check
Tier A — target path mismatch (`review-dependency-update/` ≠ `bump-dependencies/`). Existing log archived to `research-log-archive-2026-04-14.md`. Starting fresh.

**Historical note:** This is the same skill, renamed at v4.0.0 (`feat(bump-deps): rename to bump-dependencies, add proactive bump mode`). Prior 44-metric baseline is historically valid but all metrics must be re-scored — Phase 0 is entirely new content and the orchestrator was substantially rewritten.

### Persona Staleness Check
All four personas referenced by the orchestrator confirmed present:
- `../../personas/examiner/persona.md` → `skills/personas/examiner/persona.md` ✓ (soul.md present)
- `../../personas/adversarial/persona.md` → `skills/personas/adversarial/persona.md` ✓ (soul.md present)
- `../../personas/ink/persona.md` → `skills/personas/ink/persona.md` ✓ (soul.md present)
- `../../personas/critic/persona.md` → `skills/personas/critic/persona.md` ✓ (soul.md present)

No broken references. No speciation markers (no `## Origin` section in any soul.md).

### Structural Changes Since Run 8
1. **New Phase 0 (p0-bump.md):** ~3,800 tokens of new proactive discovery and bump logic — version catalogue scanning, batch API lookups for Maven/Gradle/GitHub Actions/Gradle Wrapper, changelog URL annotation, atomic commit per dependency, PR creation. Entirely new; not measured in Runs 1–8.
2. **Orchestrator rewritten (bump-dependencies.md):** expanded from `review-dependency-update.md` to include dual-mode dispatch, full wave protocol (Wave 1–5), parallel dispatch blocks, and Phase 8/7 consolidation instructions. Token size roughly doubled.
3. **Stale orchestrator comments:** p1-parse.md:2 and p1b-split-commits.md:2 still read `<!-- Part of: review-dependency-update.md orchestrator -->` — cosmetic residue from the rename.
4. **AGENTS.md note vs. skill behaviour:** AGENTS.md states "Never force push. This is a hard rule with no exceptions." This applies to development commits to the agentfiles repo. The skill itself executes force-pushes on target repos (Phase 1b Step F, Phase 4 Step F, Phase 8 Step E). The distinction is clear in context but could confuse a developer reading AGENTS.md without knowing the skill's execution model.

---

## Custom Metrics — 2026-04-14 (Run 9)

**Pulse (Analytics) active.**

MX-OQ series: SKIP — bump-dependencies does not produce `.kanban/` subjects.
HCU (P12 target): SKIP — no parallel help/reference file in this skill.
PEV (P13 target): SKIP — no confirmed experiment data in new research-log.
EIS (P14 target): SKIP — no multi-hypothesis Phase 4 sessions on record.

### MX30 — Pre-Release Version Filter Coverage (PVFC) [custom]
**Measures:** Whether all four version lookup paths in Phase 0 Step D explicitly exclude pre-release versions. A proactive bump to an `-alpha`, `-beta`, `-rc`, or similar version would undermine the skill's core promise of safe, stable updates.
**Why seeds miss it:** MX9 (Pre-Release Version Handling) measures Phase 2's handling of version range edge cases in investigation — not whether Phase 0's discovery step excludes pre-releases before bumping. No existing metric measures version quality in Phase 0's lookup step.
**Methodology:** Enumerate the four version lookup paths in Phase 0 Step D (Maven batch, Gradle Plugin Portal, GitHub Actions GraphQL, Gradle wrapper). For each, check whether there is an explicit instruction to exclude pre-release versions. PVFC = paths with explicit pre-release exclusion / 4.
- Maven batch: no pre-release exclusion specified ✗
- Gradle Plugin Portal: no pre-release exclusion specified ✗
- GitHub Actions GraphQL: no `isPrerelease: false` filter or equivalent ✗
- Gradle wrapper: "Filter to stable releases only (exclude `-rc`, `-milestone`, `-nightly` suffixes)" ✓
Raw: 1/4. **Normalised: 25.**
**Direction:** ↑ higher is better
**Weight:** 2× — bumping to a pre-release is a correctness failure that directly contradicts the skill's stated purpose
**Normalisation:** rate × 100

### MX31 — Proactive PR Deduplication Guard (PPDG) [custom]
**Measures:** Whether Phase 0 checks for an existing open PR from the same bump branch before creating a new one. Running `/bump-dependencies` twice in rapid succession produces two identical open PRs — a confusing state that requires manual cleanup.
**Why seeds miss it:** No existing metric measures idempotency of the PR creation step. MX17 (Branch Naming Collision Guard) checks that isolated review branches include the PR number; it does not check whether the top-level proactive PR is created only once. RPC checks recovery paths for errors; it does not check for pre-condition validation before writes.
**Methodology:** Inspect Phase 0 Step H. Check whether it includes any guard against creating a duplicate PR — e.g., `gh pr list --head <BUMP_BRANCH>` check before `gh pr create`. Raw: 0/1 (no check present). **Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1× — creates duplicate PRs but not a safety or correctness risk; easily cleaned up manually
**Normalisation:** rate × 100

### MX32 — Phase 0 Cross-File Table Dependency Stability (CTDS) [custom]
**Measures:** Whether Phase 0's reference to Phase 2's changelog source table includes a structural anchor (e.g., a section header name) that survives refactoring of p2-investigate.md. The current instruction says "read only the table section — do not execute Phase 2" without specifying which section header to navigate to.
**Why seeds miss it:** IOT (Intent-to-Output Traceability) measures whether phases re-read prior artifacts; it does not measure the structural stability of cross-file references. MX3 (Phase File Navigation Completeness) checks that each phase file ends with a `→ Next` pointer; it does not check the robustness of in-phase cross-file references.
**Methodology:** Inspect Phase 0 Step E. Check whether the reference to "the Kotlin/Android primary sources table in `phases/p2-investigate.md`" includes a section header anchor or equivalent structural locator. Raw: 0/1 (anchor absent). **Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1× — the reference works today; the structural risk is about future resilience after refactoring
**Normalisation:** rate × 100

### MX33 — Version Monotonicity Guard (VMG) [custom]
**Measures:** Whether Phase 0 explicitly protects against downgrading a dependency already at a version higher than the newest safe release. This can occur when a developer manually bumps to a version published fewer than seven days ago — Phase 0's `safe_latest` would then be older than the current version, and without an explicit comparison guard, the skill could attempt a downgrade.
**Why seeds miss it:** No existing metric measures whether the skill validates version direction before writing. MX9 measures Phase 2's version span handling; it does not apply to Phase 0's discovery step. The skip condition "if safe_latest ≤ current_version, skip" is implicit in the phrase "safe update available" but never stated as a rule.
**Methodology:** Inspect Phase 0 Step F. Check whether there is an explicit instruction to compare `safe_latest` against `current_version` and skip the dependency if `safe_latest ≤ current_version`. Raw: 0/1 (no explicit comparison). Partial credit: the phrase "safe update available" implies `safe_latest > current_version` for a reasonable agent. **Normalised: 50.**
**Direction:** ↑ higher is better
**Weight:** 2× — an unintended downgrade could break a build that was working; the fix is a one-line explicit comparison
**Normalisation:** rate × 100

### MX34 — Temporal Safety Window Consistency (TSWC) [custom, moonshot]
**Measures:** Whether the 7-day safety window in Phase 0 is calculated consistently across all dependencies. `BUMP_DATE` is set once at Phase 0 Step A. If Phase 0 runs long enough to cross midnight, later dependencies have their safety windows calculated against a date that is now "yesterday" — a version published 6 days ago (unsafe) could appear to be 7 days old (safe) relative to BUMP_DATE.

Borrows from "time-of-check to time-of-use" (TOCTOU) in security engineering: the time at which a property is checked may differ from the time at which it is relied upon.
**Why seeds miss it:** No existing metric measures temporal consistency within a single-phase execution. All prior metrics treat phases as instantaneous. This is the first metric to recognise that Phase 0 is a multi-step operation where the real-time clock matters.
**Methodology:** Inspect Phase 0 Step A and Step D. Check whether the safety window uses `BUMP_DATE` (set once) or real current time per dependency. Raw: 0/1 — BUMP_DATE is static throughout Phase 0. **Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1× — practical risk window is narrow (requires >5 minutes and a midnight crossing); theoretically real, practically rare
**Normalisation:** rate × 100

---

## Baseline — 2026-04-14 (Run 9)

**Pulse (Analytics) active.**

### Scope Expansion Note
Phase 0 adds ~4,000 tokens and 7 new weight units (MX30–MX34) to the scoring surface. The baseline drop from 93.6% (Run 8) to 85.3% (Run 9) is primarily a measurement artefact from scope expansion — the PR-review pipeline (Phases 1–8) is unchanged and all 44 prior metrics re-verify at their Run 8 final values.

### Inherited Metrics (44 from Run 8 post-experiment, re-verified)
All carry forward at Run 8 final values. Key re-verification findings:
- **M1 IOT (100):** Phase 0 is the root generator; Phases 1–8 all explicitly re-read session brief or prior output. ✓
- **M5 RI (98):** Phase 0 and Phase 1 both have prerequisite checks (git remote + gh auth) — each is an independent entry-point guard, not removable duplication. Retained at 98.
- **M8 HTC (95):** One touchpoint (Phase 1b Step D). Phase 0 has no human touchpoints. ✓
- **M10 CLE (94):** Phase 0 references Phase 2's changelog table section (partial load). Structural overhead unchanged. ✓
- **M14 PPF (100):** Phase 0 assigns Ink for commit curation — full cognitive fit. ✓
- **RPC (100):** Phase 0 adds well-specified recovery paths: non-GitHub remote, unauthenticated gh, uncommitted working tree, branch name collision, no safe updates available. ✓
- **MX1–MX29 (all 100):** Phase 0 does not touch the metric domains covered by these. ✓

### Full Composite (49 metrics)

| Metric | Source | Normalised | Weight | Weighted |
|---|---|---|---|---|
| Intent-to-Output Traceability | seed | 100 | 2× | 200 |
| Directive Density | seed | 100 | 1× | 100 |
| Instruction Ambiguity Rate | seed | 100 | 1× | 100 |
| Wiring Completeness Score | seed | 100 | 1× | 100 |
| Redundancy Index | seed | 98 | 1× | 98 |
| AC Concreteness | seed | 100 | 2× | 200 |
| Subagent Alignment Score | seed | 100 | 1× | 100 |
| Human Touchpoint Count | seed | 95 | 2× | 190 |
| Context Loading Efficiency | seed | 94 | 2× | 188 |
| Parallelisation Safety Score | seed | 100 | 1× | 100 |
| Information Freshness Score | seed | 100 | 2× | 200 |
| Instruction Token Efficiency | seed | 99 | 1× | 99 |
| Persona-Phase Fit Score | seed | 100 | 1× | 100 |
| Persona Richness Score | seed | 100 | 1× | 100 |
| Recovery Path Completeness | custom (RPC) | 100 | 1× | 100 |
| Changelog Source Coverage | custom (MX1) | 100 | 1× | 100 |
| Agent Prompt Completeness | custom (MX2) | 100 | 1× | 100 |
| Phase File Navigation Completeness | custom (MX3) | 100 | 1× | 100 |
| Verdict Scoring Calibration | custom (MX4) | 100 | 1× | 100 |
| Cross-Bump Context Isolation | custom (MX5) | 100 | 1× | 100 |
| Comment Template Completeness | custom (MX6) | 100 | 1× | 100 |
| Fallback Path Fidelity | custom (MX7) | 100 | 1× | 100 |
| Pipeline Diagram Accuracy | custom (MX8) | 100 | 1× | 100 |
| Pre-Release Version Handling (Phase 2) | custom (MX9) | 100 | 1× | 100 |
| Adversarial Prompt Resistance | custom (MX10) | 100 | 2× | 200 |
| Source Commit Inspection Coverage | custom (MX11) | 100 | 2× | 200 |
| Deep Lockfile Diffing Coverage | custom (MX12) | 100 | 1× | 100 |
| Git Tag Signing Verification | custom (MX13) | 100 | 2× | 200 |
| Registry Artifact Signing Coverage | custom (MX14) | 100 | 2× | 200 |
| Security Pass Completeness Score | custom (MX15) | 100 | 2× | 200 |
| Isolated Branch Lifecycle Completeness | custom (MX16) | 100 | 2× | 200 |
| Branch Naming Collision Guard | custom (MX17) | 100 | 1× | 100 |
| Consolidation Partial-Failure Recovery | custom (MX18) | 100 | 2× | 200 |
| Sub-Agent Branch Context Fidelity | custom (MX19) | 100 | 1× | 100 |
| Consolidation-to-Summary Data Handoff | custom (MX20) | 100 | 2× | 200 |
| Null-Manifest Edge Case Coverage | custom (MX21) | 100 | 2× | 200 |
| Skipped-Alias Reporting Completeness | custom (MX22) | 100 | 1× | 100 |
| Bisect State Recovery | custom (MX23) | 100 | 1× | 100 |
| Verdict Plain-English Specificity | custom (MX24) | 100 | 1× | 100 |
| Consolidation Summary Persistence | custom (MX25) | 100 | 2× | 200 |
| Sub-Agent Return Contract Completeness | custom (MX26) | 100 | 1× | 100 |
| Ecosystem Prerequisite Gate | custom (MX27) | 100 | 2× | 200 |
| Temp File Path Safety Score | custom (MX28) | 100 | 1× | 100 |
| Codebase Search Ecosystem Completeness | custom (MX29) | 100 | 2× | 200 |
| Pre-Release Version Filter Coverage | custom (MX30) | 25 | 2× | 50 |
| Proactive PR Deduplication Guard | custom (MX31) | 0 | 1× | 0 |
| Phase 0 Cross-File Table Dep. Stability | custom (MX32) | 0 | 1× | 0 |
| Version Monotonicity Guard | custom (MX33) | 50 | 2× | 100 |
| Temporal Safety Window Consistency | custom (MX34) | 0 | 1× | 0 |
| **TOTAL** | | | **73×** | **6,229** |

**Composite: 6,229 / (73 × 100) × 100 = 85.3%**

*(Inherited 44-metric basis: 6,179 / 6,600 × 100 = 93.6% — unchanged from Run 8. The 8.3pp composite drop is entirely attributable to Phase 0 scope expansion: 7 new weight units at 0–50 scores.)*

### Weakest Metrics (Phase 3 candidates)
1. Proactive PR Deduplication Guard — 0 (1×)
2. Phase 0 Cross-File Table Dependency Stability — 0 (1×)
3. Temporal Safety Window Consistency — 0 (1×, moonshot)
4. Pre-Release Version Filter Coverage — 25 (2×) — highest urgency given 2× weight
5. Version Monotonicity Guard — 50 (2×)

---

## Experiments — 2026-04-14 (Run 9)

**Keeper (Strategist) active.**

### Step 0 — Pre-Experiment Dependency Scan
H37 modifies p0-bump.md Step D.
H38 modifies p0-bump.md Step F.
H39 modifies p0-bump.md Step H.
H40 modifies p0-bump.md Step E.

H37 and H38 both modify p0-bump.md, different steps — run sequentially. H39 and H40 modify different steps with no content overlap — can follow in any order.
Execution order: H37 → H38 → H39 → H40.

### H37 — Phase 0 Pre-Release Version Filtering
**Problem observed:** Pre-Release Version Filter Coverage = 25. Phase 0 Step D explicitly filters pre-releases for the Gradle wrapper only. Maven, Gradle Plugin Portal, and GitHub Actions paths have no equivalent filter. A proactive bump could install an `-alpha` or `-rc` version.
**Change proposed:** Add explicit pre-release exclusion to each unfiltered lookup path in Phase 0 Step D: (1) Maven batch parse: filter out versions matching `-alpha`, `-beta`, `-rc`, `-SNAPSHOT`, `-M`, `-milestone` suffixes before selecting safe_latest; (2) Gradle Plugin Portal fallback maven-metadata.xml parse: same suffix exclusion; (3) GitHub Actions GraphQL: add "skip releases where `isPrerelease: true`" to release selection.
**Targets:** Pre-Release Version Filter Coverage (↑, from 25 to 100)
**Predicted improvement:** MX30 +75pp (2× → +150 weighted points)
**Pattern applied:** P7 — Binary Applicability Gates
**Risk level:** low
**Risk note:** Additive filter only; the only change is that a pre-release version that was previously the newest entry would be skipped in favour of the next older stable entry.

### H38 — Version Monotonicity Explicit Guard
**Problem observed:** Version Monotonicity Guard = 50. Phase 0 Step F uses "safe update available" without defining this to require `safe_latest > current_version`. An agent could attempt a downgrade when a dependency has been manually bumped above the 7-day threshold.
**Change proposed:** Add an explicit comparison step to Phase 0 Step F: before applying any edit, check whether `safe_latest > current_version`. If not, skip and record under a new "Skipped (already ahead of safe latest)" row in the Step I summary. Add a definitional note: "'safe update available' means `safe_latest > current_version` AND `safe_latest` was published more than seven days ago."
**Targets:** Version Monotonicity Guard (↑, from 50 to 100)
**Predicted improvement:** MX33 +50pp (2× → +100 weighted points)
**Pattern applied:** P7 — Binary Applicability Gates
**Risk level:** low
**Risk note:** No behavioural change for the common case. The new skip condition only fires when a project has manually advanced a dependency beyond the 7-day safety threshold.

### H39 — Proactive PR Deduplication Guard
**Problem observed:** Proactive PR Deduplication Guard = 0. Phase 0 Step H calls `gh pr create` unconditionally. A second run on the same day produces a second open PR.
**Change proposed:** Add a pre-creation check to Phase 0 Step H: run `gh pr list --head <BUMP_BRANCH> --repo <owner/repo> --json number,url` before `gh pr create`. If an open PR already exists, print its URL and skip creation: "PR already exists for this branch (#<number>). Proceeding with the existing PR."
**Targets:** Proactive PR Deduplication Guard (↑, from 0 to 100)
**Predicted improvement:** MX31 +100pp (1× → +100 weighted points)
**Pattern applied:** P10 — Failure Mode Registry
**Risk level:** low
**Risk note:** One extra API call; the happy path (no existing PR) is unaffected.

### H40 — Phase 0 Cross-File Table Structural Anchor
**Problem observed:** Phase 0 Cross-File Table Dependency Stability = 0. Phase 0 Step E says "read only the table section" without specifying the section header. Ambiguous after any restructuring of p2-investigate.md.
**Change proposed:** Update Phase 0 Step E to name the specific section: replace "read only the table section" with "navigate to the `### Kotlin/Android primary sources` section heading in that file".
**Targets:** Phase 0 Cross-File Table Dependency Stability (↑, from 0 to 100)
**Predicted improvement:** MX32 +100pp (1× → +100 weighted points)
**Pattern applied:** novel — Cross-File Structural Anchor
**Risk level:** low
**Risk note:** The section header `### Kotlin/Android primary sources` is stable and has been present since Phase 2 was written.

### Self-Audit Results
- **Intent check:** all four hypotheses target metrics below 100. ✓
- **Coverage check:** projected composite = (6,229 + 150 + 100 + 100 + 100) / 7,300 × 100 = **91.5%**. Below 95%.
- **Gap fill:** remaining sub-100 after hypotheses: RI=98 (deliberate), HTC=95 (deliberate), CLE=94 (structural), MX34=0 (moonshot — temporal drift requires a midnight crossing during Phase 0; practical risk negligible). No further actionable hypotheses.

### Recommendation Brief

Based on baseline measurement, the following experiments are queued.

1. **Phase 0 pre-release filtering** — Maven, Gradle Plugin Portal, and GitHub Actions version lookups do not exclude pre-release versions; adding explicit filters ensures Phase 0 never bumps to an `-alpha`, `-beta`, or `-rc` release.
2. **Version direction guard** — Phase 0 does not explicitly state that a "safe update" requires the new version to be newer than the current one; adding a comparison step prevents unintended downgrades of manually-advanced dependencies.
3. **Proactive PR deduplication** — Phase 0 creates a PR unconditionally on every run; a one-line `gh pr list` check prevents duplicate open PRs when the skill is run twice before the first PR is reviewed.
4. **Cross-file table anchor** — Phase 0 references Phase 2's changelog source table by description rather than by section header; naming the specific section header makes the reference stable to future refactoring.

---


## Post-Experiment Re-Measurement — 2026-04-14 (Run 9)

**Arden (Critic) active for re-measurement.**

All four experiments applied in commit `85fc15f` on branch `optimize/bump-dependencies-2026-04-14`.

### MX30 — Pre-Release Version Filter Coverage (post H37)

- Maven batch: explicit `-alpha/-beta/-rc/-SNAPSHOT/-M[0-9]/-milestone` exclusion added ✓
- Gradle Plugin Portal fallback: same exclusion applied to maven-metadata.xml parse ✓
- GitHub Actions GraphQL: `isPrerelease` field requested; skip rule added to parse step ✓
- Gradle wrapper: "Filter to stable releases only" unchanged ✓

Raw: 4/4. **Normalised: 100.** Weighted: 200. Δ: +150.

### MX31 — Proactive PR Deduplication Guard (post H39)

- Step H now runs `gh pr list --head <BUMP_BRANCH> --state open` before `gh pr create`. If a PR exists, it is reused and creation is skipped. ✓

Raw: 1/1. **Normalised: 100.** Weighted: 100. Δ: +100.

### MX32 — Phase 0 Cross-File Table Dependency Stability (post H40)

- Step E now names the precise section heading: "navigate to the `### Kotlin/Android primary sources` section heading in that file". ✓

Raw: 1/1. **Normalised: 100.** Weighted: 100. Δ: +100.

### MX33 — Version Monotonicity Guard (post H38)

- Step F now requires an explicit `safe_latest > current_version` comparison before any file edit. If `safe_latest ≤ current_version`, dependency is skipped with a dedicated row in Step I. ✓

Raw: 1/1. **Normalised: 100.** Weighted: 200. Δ: +100.

### MX34 — Temporal Safety Window Consistency (unchanged)

Not addressed. Moonshot: negligible real-world impact. Remains at 0 (1× = 0 weighted).

### Post-Experiment Composite

| Metric | Before | After | Δ weighted |
|---|---|---|---|
| MX30 Pre-Release Filter Coverage | 25 (50) | 100 (200) | +150 |
| MX31 PR Deduplication Guard | 0 (0) | 100 (100) | +100 |
| MX32 Cross-File Table Stability | 0 (0) | 100 (100) | +100 |
| MX33 Version Monotonicity Guard | 50 (100) | 100 (200) | +100 |
| MX34 Temporal Safety Window | 0 (0) | 0 (0) | — |

**New total weighted score: 6,229 + 150 + 100 + 100 + 100 = 6,679**
**Post-experiment composite: 6,679 / (73 × 100) × 100 = 91.5%**

Predicted: 91.5% — Actual: 91.5% ✓ Prediction confirmed exactly.

Remaining sub-100 metrics:
- RI = 98 (deliberate — Phase 0 and Phase 1 both have prerequisite checks; acceptable duplication)
- HTC = 95 (deliberate — one Phase 1b touchpoint is required by the workflow)
- CLE = 94 (structural — Phase 0 partial-loads Phase 2; already near optimum)
- MX34 = 0 (moonshot — not actionable without overcomplicated design)

No further actionable hypotheses. Phase 4 complete.

---

## Final Results — 2026-04-14 (Run 9 retroactive)

*(Phase 5 report not written at session end — retroactive summary.)*

| Metric | Baseline | Post | Delta | Status |
|---|---|---|---|---|
| Pre-Release Version Filter Coverage (MX30) | 25 | 100 | +75 | ↑ |
| Proactive PR Deduplication Guard (MX31) | 0 | 100 | +100 | ↑ |
| Phase 0 Cross-File Table Dependency Stability (MX32) | 0 | 100 | +100 | ↑ |
| Version Monotonicity Guard (MX33) | 50 | 100 | +50 | ↑ |
| Temporal Safety Window Consistency (MX34) | 0 | 0 | — | moonshot |
| **Composite** | 85.3% | 91.5% | +6.2pp | |

Confirmed: H37, H38, H39, H40. Partial: none. Dropped: none.

What improved and why:
- Pre-Release Version Filter Coverage (+75pp): explicit pre-release exclusion added to Maven, Gradle Plugin Portal, and GitHub Actions lookup paths in Phase 0 Step D.
- PR Deduplication Guard (+100pp): `gh pr list --head` check added before `gh pr create` in Step H.
- Cross-File Table Dependency Stability (+100pp): section heading anchor `### Kotlin/Android primary sources` added to Phase 0 Step E reference.
- Version Monotonicity Guard (+50pp): explicit `safe_latest > current_version` comparison added to Step F before any file edit.

What remains to improve:
- Temporal Safety Window Consistency (MX34): 0 — TOCTOU risk from static BUMP_DATE; moonshot, not actionable without complexity trade-off.
- Human Touchpoint Count (M8 · HTC): 95 — deliberate; Phase 1b approval touchpoint is a required design decision.
- Context Loading Efficiency (M10 · CLE): 94 — structural; Phase 0 partial-load already in place.

Novel patterns: H40 introduced Cross-File Structural Anchor (novel) — seed candidate pending promotion.

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

