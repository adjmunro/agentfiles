<!-- SUMMARY-START -->
## Run 011 — 2026-04-14 | Target: skills/bump-dependencies/
Composite: 85.3% → 91.5% (+6.2 pp)

### Hypotheses
| ID  | Description                                        | Outcome   |
|-----|----------------------------------------------------|-----------|
| H37 | Phase 0 Pre-Release Version Filtering              | Confirmed |
| H38 | Version Monotonicity Explicit Guard                | Confirmed |
| H39 | Proactive PR Deduplication Guard                   | Confirmed |
| H40 | Phase 0 Cross-File Table Structural Anchor         | Confirmed |

### Metric Snapshot
| Metric                                        | Baseline | Post |
|-----------------------------------------------|----------|------|
| Pre-Release Version Filter Coverage           | 25       | 100  |
| Proactive PR Deduplication Guard              | 0        | 100  |
| Phase 0 Cross-File Table Dep. Stability       | 0        | 100  |
| Version Monotonicity Guard                    | 50       | 100  |
| Composite                                     | 85.3%    | 91.5% |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

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

## Phase 2 — Baseline

**Pulse (Analytics) active.**

### Scope Expansion Note
Phase 0 adds ~4,000 tokens and 7 new weight units (MX30–MX34) to the scoring surface. The baseline drop from 93.6% (Run 8) to 85.3% (Run 9) is primarily a measurement artefact from scope expansion — the PR-review pipeline (Phases 1–8) is unchanged and all 44 prior metrics re-verify at their Run 8 final values.

### Custom Metrics Introduced

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

## Phase 3 — Hypotheses

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

---

## Phase 4 — Experiments

**Arden (Critic) active for re-measurement.**

All four experiments applied in commit `85fc15f` on branch `optimize/bump-dependencies-2026-04-14`.

### H37 — Phase 0 Pre-Release Version Filtering
**Pre-change:** MX30 = 25 (1/4 lookup paths filtered)
**Post-change:** MX30 = 100 (4/4 lookup paths filtered)
- Maven batch: explicit `-alpha/-beta/-rc/-SNAPSHOT/-M[0-9]/-milestone` exclusion added ✓
- Gradle Plugin Portal fallback: same exclusion applied to maven-metadata.xml parse ✓
- GitHub Actions GraphQL: `isPrerelease` field requested; skip rule added to parse step ✓
- Gradle wrapper: "Filter to stable releases only" unchanged ✓
**Delta:** MX30 +75pp (2× → +150 weighted points)
**Result:** confirmed

### H38 — Version Monotonicity Explicit Guard
**Pre-change:** MX33 = 50 (implicit; "safe update available" undefinded)
**Post-change:** MX33 = 100 (Step F requires explicit `safe_latest > current_version` comparison; skip row added to Step I)
**Delta:** MX33 +50pp (2× → +100 weighted points)
**Result:** confirmed

### H39 — Proactive PR Deduplication Guard
**Pre-change:** MX31 = 0 (no check; `gh pr create` unconditional)
**Post-change:** MX31 = 100 (Step H now runs `gh pr list --head <BUMP_BRANCH> --state open` before `gh pr create`; existing PR reused and creation skipped)
**Delta:** MX31 +100pp (1× → +100 weighted points)
**Result:** confirmed

### H40 — Phase 0 Cross-File Table Structural Anchor
**Pre-change:** MX32 = 0 (reference by description only)
**Post-change:** MX32 = 100 (Step E now names the precise section heading: "navigate to the `### Kotlin/Android primary sources` section heading in that file")
**Delta:** MX32 +100pp (1× → +100 weighted points)
**Result:** confirmed

### MX34 — Temporal Safety Window Consistency (not addressed)
Not addressed. Moonshot: negligible real-world impact. Remains at 0 (1× = 0 weighted).

## Experiment Summary
- Confirmed: H37, H38, H39, H40
- Partial: (none)
- Disconfirmed: (none)

---

## Phase 5 — Report

| Metric | Baseline | Post | Delta | Status |
|---|---|---|---|---|
| Pre-Release Version Filter Coverage (MX30) | 25 | 100 | +75 | ↑ |
| Proactive PR Deduplication Guard (MX31) | 0 | 100 | +100 | ↑ |
| Phase 0 Cross-File Table Dep. Stability (MX32) | 0 | 100 | +100 | ↑ |
| Version Monotonicity Guard (MX33) | 50 | 100 | +50 | ↑ |
| Temporal Safety Window Consistency (MX34) | 0 | 0 | — | moonshot |
| **Composite** | **85.3%** | **91.5%** | **+6.2 pp** | |

*New total weighted score: 6,229 + 150 + 100 + 100 + 100 = 6,679*
*Post-experiment composite: 6,679 / (73 × 100) × 100 = 91.5%*

### What improved and why

- **Pre-Release Version Filter Coverage**: 25 → 100 (+75pp, 2× weight) — explicit pre-release exclusion added to Maven, Gradle Plugin Portal, and GitHub Actions lookup paths in Phase 0 Step D.
- **Proactive PR Deduplication Guard**: 0 → 100 (+100pp) — `gh pr list --head` check added before `gh pr create` in Step H.
- **Phase 0 Cross-File Table Dependency Stability**: 0 → 100 (+100pp) — section heading anchor `### Kotlin/Android primary sources` added to Phase 0 Step E reference.
- **Version Monotonicity Guard**: 50 → 100 (+50pp, 2× weight) — explicit `safe_latest > current_version` comparison added to Step F before any file edit.

### What remains to improve

- **Redundancy Index** — 98. Phase 0 and Phase 1 both have prerequisite checks (git remote + gh auth) — each is an independent entry-point guard, acceptable duplication.
- **Human Touchpoint Count** — 95. One Phase 1b touchpoint is required by the workflow.
- **Context Loading Efficiency** — 94. Phase 0 partial-loads Phase 2; already near optimum.
- **Temporal Safety Window Consistency** — 0 (moonshot). Not actionable without overcomplicated design.
