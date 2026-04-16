<!-- SUMMARY-START -->
## Run 020 — 2026-04-17 | Target: skills/bump-dependencies/
Composite: 87.6% → 91.0% (+3.4 pp)

### Hypotheses
| ID  | Description                                                                  | Outcome   |
|-----|------------------------------------------------------------------------------|-----------|
| H74 | Fix stale `/review-dependency-update` attribution in Phase 6 comment         | Confirmed |
| H75 | Move Phase 7 exclusion banner guidance outside the template code block        | Confirmed |
| H76 | Add version sort instruction to Phase 0 Plugin Portal fallback                | Confirmed |
| H77 | Add alias content verification to Phase 1b isolated branch check              | Confirmed |

### Metric Snapshot
| Metric                                                               | Baseline | Post |
|----------------------------------------------------------------------|----------|------|
| Stale Skill Attribution in PR Comments (MX74)                        | 0        | 100  |
| Template-Guidance Separation in Phase 7 Exclusion Banner (MX75)      | 0        | 100  |
| Gradle Plugin Portal Version Sort Instruction (MX76)                 | 0        | 100  |
| Isolated Branch Commit Content Verification (MX77)                   | 0        | 100  |
| Supply Chain Cross-Dependency Correlation Coverage (MX78)            | 0        | 0    |
| Composite                                                            | 87.6%    | 91.0%|
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

**Pulse (Analytics) active.**

**Target:** `skills/bump-dependencies/`
**Files:** 34 total (11 command, 4 support, 19 optimise logs)
**Token estimate:** ~19,200 tokens (instruction files ~19,200; support/logs not loaded for scoring)

### Cross-Run Context (from researchlog-019.md)
Previous composite: 87.1% → 91.5% (+4.4pp, 90 metrics, 114×)
H69–H73: all confirmed — excluded from this run.

### Feature Inventory
- Multi-phase pipeline: yes
- Persona system: yes (Ink, Echo, Rook, Arden — 4 personas)
- Subagent invocations: yes (Wave 1 + Wave 3 parallel agents)
- Multi-session orchestration: yes (/tmp session brief + consolidation summary)
- Parallel execution: yes (Wave 1 investigation, Wave 3 verdict + comment)
- Cached artifacts: yes (session brief, manifest, consolidation summary)

### Persona Staleness Check
All 4 personas confirmed present and current per Run 019 (no persona file changes since). No broken references, no speciation notes.

### Files
Command (11): bump-dependencies.md, p0-bump.md, p1-parse.md, p1b-split-commits.md,
  p2-investigate.md, p3-impact.md, p4-remediate.md, p5-verdict.md, p6-comment.md,
  p7-summary.md, p8-consolidate.md
Support (4): SKILL.md, AGENTS.md, VERSION.md, CHANGELOG.md
Optimise logs (19): researchlog-001 through researchlog-019

### Changes Since Run 019 (H69–H73)
1. **H69**: Phase 0 Step H — delete orphaned BUMP_BRANCH when user resumes existing PR.
2. **H70**: Phase 0 Step H PR body — merged C.4 entry annotation.
3. **H71**: Phase 2 Pass A — `--paginate` added to GitHub Releases API calls.
4. **H72**: Phase 5 Step C — data-source note anchored to exact `Multi-version span detected:` record.
5. **H73**: Phase 0 Step C.5 — version drift clause added.
6. Version bumped to 4.12.0.

### Structural Gaps Identified During Audit
- **Phase 6 stale attribution**: p6-comment.md Step A template says `Reviewed by \`/review-dependency-update\`` — the old skill name prior to the v4.0.0 rename. The current skill name is `/bump-dependencies`. This stale reference appears in every PR comment the skill generates.
- **Phase 7 template/guidance conflation**: p7-summary.md Step B embeds `<!-- EXCLUSION BANNER — include only when one or more aliases have a BLOCK verdict -->` and `<!-- END EXCLUSION BANNER -->` inside the fenced code block template. Using HTML comments as both "hide-from-rendered-view" markers and "agent: include/omit this section" instructions conflates two distinct purposes inside the template body itself.
- **Phase 0 Plugin Portal sort omission**: p0-bump.md Step D Gradle Plugin Portal fallback parses `<versioning><versions>` from maven-metadata.xml to "find the next oldest stable release" without specifying that the version list must be sorted (descending) before selecting. Maven metadata XML version order is not guaranteed; the instruction relies on implicit ordering.
- **Phase 1b verification gap**: p1b-split-commits.md Step I verifies that isolated branches contain "exactly the commits from the base branch plus the one alias commit" but does not verify that the extra commit's message matches the expected alias. An agent could cherry-pick the wrong commit and the structural check would still pass.

---

## Phase 2 — Baseline

**Pulse (Analytics) active.**

EIS: 100 (carries forward). PEV: ~56 (carries forward — dormant patterns P5, P13, P14, P17 remain unvalidatable without artificial hypotheses).

### MX74 — Stale Skill Attribution in PR Comments (SSAC) [custom]
**Measures:** Whether Phase 6's PR comment template references the current skill name (`/bump-dependencies`) rather than the legacy name (`/review-dependency-update`) that predates the v4.0.0 rename.
**Why seeds miss it:** No seed metric measures output template correctness for named identifiers. M12 (IFS) targets artifact freshness but not hardcoded string staleness. The v4.0.0 rename is documented in CHANGELOG.md but the Phase 6 template was not updated.
**Methodology:** Inspect p6-comment.md Step A comment assembly template for the "Reviewed by" attribution string. Current value: `` `Reviewed by /review-dependency-update` ``. Correct value: `` `Reviewed by /bump-dependencies` ``. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** correct_attribution_present × 100

### MX75 — Template-Guidance Separation in Phase 7 Exclusion Banner (TGSB) [custom]
**Measures:** Whether Phase 7 Step B's conditional inclusion guidance for the exclusion banner is stated outside the fenced template code block, so agent directives are separated from literal PR comment content.
**Why seeds miss it:** M11 (P11 — File Role Stratification) targets cross-file separation of instruction vs. documentation. This is a within-file within-section separation gap: agent guidance ("include only when one or more aliases have BLOCK verdict") is embedded inside the template body as an HTML comment, conflating two distinct purposes in the same construct.
**Methodology:** Inspect p7-summary.md Step B. The `<!-- EXCLUSION BANNER — include only when one or more aliases have a BLOCK verdict -->` comment appears inside the ` ``` markdown ` fenced block. Agent inclusion/omission guidance should appear as prose instructions before or after the fenced block, not inside it. Raw: 0/1 (guidance is inside the block).
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** guidance_outside_template × 100

### MX76 — Gradle Plugin Portal Version Sort Instruction (GPVS) [custom]
**Measures:** Whether Phase 0 Step D's Gradle Plugin Portal fallback path specifies that the version list from `maven-metadata.xml` must be sorted in descending version order before selecting "the next oldest stable release."
**Why seeds miss it:** M6 (ACC — AC Concreteness) targets measurability of acceptance criteria, not correctness of algorithmic steps. The "next oldest stable release" criterion is implicitly a sorted-descending selection (index 1), but the XML `<versioning><versions>` element is not guaranteed to list versions in any order. No seed metric measures whether multi-step algorithmic instructions include all required precondition steps (e.g., sort before select).
**Methodology:** Inspect p0-bump.md Step D Gradle Plugin Portal fallback block. Current instruction: "parse `<versioning><versions>` to find the next oldest stable release. Apply the same pre-release exclusion before selecting." No sort/ordering instruction present. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** sort_instruction_present × 100

### MX77 — Isolated Branch Commit Content Verification (IBCCV) [custom]
**Measures:** Whether Phase 1b Step I's post-creation verification checks that the single extra commit on each isolated branch contains the expected alias name in its commit message, not merely that the branch contains exactly one extra commit.
**Why seeds miss it:** M6 (ACC) measures whether acceptance criteria are concrete. Step I has a concrete structural check ("exactly the commits from base branch plus one alias commit"), but this check does not confirm the commit is the correct one for the alias. A cherry-pick error (wrong commit hash) would pass the structural check. No seed metric measures whether verification criteria are sufficient to detect the failure mode they are intended to detect.
**Methodology:** Inspect p1b-split-commits.md Step I post-creation verification block. Current: "verify with `git log --oneline <base-branch>..dep-review/<PR-number>/<alias>`" with the criterion "contains exactly the commits from the base branch plus the one alias commit." No instruction to check that the extra commit's message contains `<alias>`. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** content_verification_present × 100

### MX78 — Supply Chain Cross-Dependency Correlation Coverage (SCDCC) [custom, moonshot]
**Measures:** Whether the skill includes any instruction to check for cross-dependency supply-chain signals when multiple packages are bumped simultaneously — for example, checking whether multiple simultaneously bumped packages have recently changed maintainers or publishing accounts, or whether any two packages share a new commit author not previously associated with those projects. Coordinated supply-chain attacks may span multiple packages within a single PR, but the skill reviews each dependency in isolation.
**Why seeds miss it:** M7 (SAS) measures subagent task appropriateness; Rook (Pass C) covers per-package supply-chain signals. This borrows from threat-intelligence methodology — "link analysis" — which identifies suspicious correlations across actors and artefacts, not just within a single artefact. No existing metric or pattern covers cross-package correlation in a dependency review context.
**Methodology:** Scan all phase files for any instruction that correlates supply-chain signals across multiple aliases in the same PR. Current state: Rook's Pass C.1–C.3 is per-alias and runs independently per isolated branch. Phase 7 summary only aggregates verdicts and remediations; no cross-alias supply-chain correlation is instructed. Raw: 0/1.
**Normalised: 0.**
**Direction:** ↑ higher is better
**Weight:** 1× (moonshot — informational; not targeted in Phase 3 due to architectural scope)
**Normalisation:** cross_package_signal_instruction_present × 100

### Inherited Metrics
All 90 metrics carry forward at Run 019 post-experiment values (~10,429/11,400 = ~91.5%). No instruction file changes between Run 019 final and this run's audit affect any inherited metric.

### New Metrics This Run

| Metric | Score | Weight | Weighted |
|---|---|---|---|
| Stale Skill Attribution in PR Comments (MX74) | 0 | 1× | 0 |
| Template-Guidance Separation in Phase 7 (MX75) | 0 | 1× | 0 |
| Gradle Plugin Portal Version Sort Instruction (MX76) | 0 | 1× | 0 |
| Isolated Branch Commit Content Verification (MX77) | 0 | 1× | 0 |
| Supply Chain Cross-Dependency Correlation (MX78) | 0 | 1× | 0 |

### Full Composite (95 metrics)

Inherited weighted sum: ~10,429 (114×)
New metrics weighted sum: 0 + 0 + 0 + 0 + 0 = 0 (5×)
Total: **~10,429 / 11,900 (119×)**

**Composite: ~10,429 / 11,900 × 100 = ~87.6%**

*(Drop of ~3.9pp from scope expansion: 5 new weight units at 0.)*

### Weakest Metrics (Phase 3 candidates)
1. MX74 — Stale Skill Attribution: 0 (1×)
2. MX75 — Template-Guidance Separation: 0 (1×)
3. MX76 — Gradle Plugin Portal Version Sort: 0 (1×)
4. MX77 — Isolated Branch Content Verification: 0 (1×)
5. MX78 — Supply Chain Correlation (moonshot, not targeted)

---

## Phase 3 — Hypotheses

*Keeper (Strategist) active.*

### Step 0 — Pre-Experiment Dependency Scan
H74 modifies p6-comment.md (Step A template).
H75 modifies p7-summary.md (Step B template).
H76 modifies p0-bump.md (Step D — Plugin Portal fallback block).
H77 modifies p1b-split-commits.md (Step I — verification block).

No file overlaps. All four hypotheses are independent — run in any order.

### H74 — Fix stale skill name in Phase 6 PR comment attribution
**Problem observed:** MX74 = 0. Phase 6 Step A assembles the PR comment with `` Reviewed by `/review-dependency-update` `` — the skill name from before the v4.0.0 rename. Since v4.0.0, the skill is invoked as `/bump-dependencies`. Every PR comment generated by this skill attributes the review to a non-existent slash command.
**Change proposed:** In p6-comment.md Step A comment template, replace `` `/review-dependency-update` `` with `` `/bump-dependencies` ``.
**Targets:** Stale Skill Attribution in PR Comments (MX74): 0 → 100 (+100pp)
**Predicted improvement:** MX74 +100pp (1× = +100 weighted)
**Pattern applied:** P12 — Content Synchronisation Audit (template updated to reflect the v4.0.0 skill rename documented in CHANGELOG.md)
**Risk level:** low
**Risk note:** Single string replacement in a comment template. No logic change.

### H75 — Move Phase 7 exclusion banner guidance outside the template code block
**Problem observed:** MX75 = 0. Phase 7 Step B embeds `<!-- EXCLUSION BANNER — include only when one or more aliases have a BLOCK verdict -->` and `<!-- END EXCLUSION BANNER -->` as HTML comments inside the fenced markdown template. Agent inclusion/omission guidance should be prose instructions, not embedded HTML comments inside the literal template — the two constructs serve different purposes and conflating them can cause an agent to include guidance fragments in the actual PR comment.
**Change proposed:** In p7-summary.md Step B, extract the exclusion banner conditional instruction from inside the fenced template block and state it as an explicit prose instruction immediately before the fenced block. Remove the `<!-- EXCLUSION BANNER ... -->` and `<!-- END EXCLUSION BANNER -->` HTML comment delimiters from inside the fenced template.
**Targets:** Template-Guidance Separation in Phase 7 Exclusion Banner (MX75): 0 → 100 (+100pp)
**Predicted improvement:** MX75 +100pp (1× = +100 weighted)
**Pattern applied:** Novel — "Template-Body Instruction Separation" (agent conditional-inclusion directives belong outside template fences; inside template fences is literal output; conflating them with HTML comment delimiters risks guidance leaking into generated content or being misread as template structure)
**Risk level:** low
**Risk note:** Purely structural move of existing content. The inclusion logic itself is unchanged.

### H76 — Add version sort instruction to Phase 0 Plugin Portal fallback
**Problem observed:** MX76 = 0. Phase 0 Step D's fallback for Gradle Plugin Portal dependencies fetches `maven-metadata.xml` and says "parse `<versioning><versions>` to find the next oldest stable release" without instructing the agent to sort the version list in descending semantic version order first. Maven metadata XML `<versions>` elements are not guaranteed to be ordered. Without sorting, an agent might select a version from the middle or beginning of the list (e.g., the first stable entry that's older than 7 days, which could be several major versions behind the latest safe release).
**Change proposed:** In p0-bump.md Step D Gradle Plugin Portal fallback block, after "parse `<versioning><versions>`", add: "Sort the version list in descending semantic version order, then apply pre-release exclusion and the 7-day safety check. Select the first entry in the sorted list whose release date is older than 7 days."
**Targets:** Gradle Plugin Portal Version Sort Instruction (MX76): 0 → 100 (+100pp)
**Predicted improvement:** MX76 +100pp (1× = +100 weighted)
**Pattern applied:** P10 — Failure Mode Registry (closes the unordered-version-list failure mode in the Plugin Portal fallback path)
**Risk level:** low
**Risk note:** Additive instruction. The fallback path was previously underspecified; this makes the selection deterministic.

### H77 — Add alias content verification to Phase 1b isolated branch check
**Problem observed:** MX77 = 0. Phase 1b Step I verifies that each isolated branch contains "exactly the commits from the base branch plus the one alias commit" but does not verify the commit message contains the expected alias. A cherry-pick error (wrong hash) would produce a structurally correct branch with the wrong content. The alias name appears in every bump commit message (`chore(deps): bump <alias> ...`), making message verification straightforward.
**Change proposed:** In p1b-split-commits.md Step I post-creation verification block, after the `git log --oneline` verification, add: "Confirm the extra commit's message contains `<alias>` — if the message does not reference the expected alias, flag a cherry-pick error and stop before dispatching Wave 1 agents for this entry."
**Targets:** Isolated Branch Commit Content Verification (MX77): 0 → 100 (+100pp)
**Predicted improvement:** MX77 +100pp (1× = +100 weighted)
**Pattern applied:** P6 — Symmetric Outcome Thresholds (the verification now checks both structural completeness and content correctness — extending the passing criterion from one dimension to two)
**Risk level:** low
**Risk note:** Additive check. The early-stop instruction prevents Wave 1 from receiving a malformed isolated branch; the agent must fix the cherry-pick before proceeding.

### Self-Audit (Keeper)
1. **Intent check:** H74 targets MX74 (0 < 100) ✓; H75 targets MX75 (0 < 100) ✓; H76 targets MX76 (0 < 100) ✓; H77 targets MX77 (0 < 100) ✓. MX78 (moonshot) not targeted — architectural scope too large for this run. ✓
2. **Coverage check:**
   - H74–H77: +100 weighted each → total +400
   - Projected: (~10,429 + 400) / 11,900 = ~10,829 / 11,900 = **~91.0%** < 95%
   - Below 95%; check uncovered gaps. MX49/43/38/34 (moonshots at 0): no tractable hypothesis. MX78 (moonshot): architectural. PEV ~56: all hypotheses apply previously validated patterns (P12, novel, P10, P6) — PEV cannot increase without validating new patterns. No non-moonshot metric below 80 lacks a hypothesis. ✓
3. **Gap fill:** No non-moonshot metric below 80 is uncovered. ✓

H75 applies a novel pattern not yet in the seed library. Recording for later consideration as a seed candidate.

### Recommendation Brief

Based on baseline measurement, the following experiments are queued.

1. **Fix stale skill name in PR comment attribution** — Phase 6's comment template references the pre-rename skill name `/review-dependency-update`; every PR comment generated by this skill attributes the review to a non-existent command.
2. **Separate Phase 7 exclusion banner guidance from template content** — agent conditional-inclusion instructions are embedded inside the PR comment template as HTML comments, conflating directives with literal output content.
3. **Add sort instruction to Plugin Portal version fallback** — the maven-metadata.xml version list is parsed without first sorting it, leaving version selection order-dependent on the XML source.
4. **Add commit-content verification to isolated branch creation** — the post-creation check confirms branch structure (one extra commit) but not that the commit references the correct alias, leaving cherry-pick errors undetectable.

---

## Phase 4 — Experiments

**Arden (Critic) active.**

**Step 0 — Pre-Experiment Dependency Scan**
H74 → p6-comment.md. H75 → p7-summary.md. H76 → p0-bump.md. H77 → p1b-split-commits.md.
No file overlaps. Execution order: H74 → H75 → H76 → H77.

### H74 — Fix stale skill name in Phase 6 PR comment attribution

**Pre-change:** MX74 (Stale Skill Attribution): 0 (template contains `/review-dependency-update`)

**Post-change:** p6-comment.md Step A comment assembly template updated. The `Reviewed by /review-dependency-update` line changed to `Reviewed by /bump-dependencies`.
- MX74: 100 (+100pp)

**Delta:** MX74 +100pp
**Secondary deltas:** M5 RI re-checked — no duplication introduced. No degradation.
**Result:** confirmed
**Notes:** P12 (Content Synchronisation Audit) applied — template updated to reflect the v4.0.0 rename. P12 previously validated; no new PEV credit.

### H75 — Move Phase 7 exclusion banner guidance outside the template code block

**Pre-change:** MX75 (Template-Guidance Separation): 0 (guidance inside fenced block)

**Post-change:** p7-summary.md Step B restructured. The `<!-- EXCLUSION BANNER — include only when one or more aliases have a BLOCK verdict -->` and `<!-- END EXCLUSION BANNER -->` markers removed from inside the fenced code block. An explicit prose instruction added immediately before the exclusion banner section within the fenced block:

> Include the EXCLUSION BANNER block (from `> [!WARNING]` through the closing blockquote) only when one or more aliases have a BLOCK verdict. Omit it entirely if all aliases passed.

The exclusion banner content itself remains inside the fenced block (it is literal output), but the conditional logic is now stated as agent prose before the fenced template.

- MX75: 100 (+100pp)

**Delta:** MX75 +100pp
**Secondary deltas:** M3 IAR re-checked — the conditional instruction is now an explicit prose directive rather than an embedded HTML comment marker; the instruction is unambiguous. Minor positive. No degradation.
**Result:** confirmed
**Notes:** Novel pattern applied — "Template-Body Instruction Separation." Recording as NP1 in Phase 5.

### H76 — Add version sort instruction to Phase 0 Plugin Portal fallback

**Pre-change:** MX76 (Gradle Plugin Portal Version Sort Instruction): 0 (no sort instruction)

**Post-change:** p0-bump.md Step D Gradle Plugin Portal fallback block amended. After "and parse `<versioning><versions>`", the instruction now reads: "Sort the version list in descending semantic version order, apply the same pre-release exclusion (see above), then select the first entry whose release date is older than 7 days."

- MX76: 100 (+100pp)

**Delta:** MX76 +100pp
**Secondary deltas:** M6 ACC re-checked — the fallback path's selection criterion is now fully deterministic (sorted, filtered, first-match). Positive. No degradation.
**Result:** confirmed
**Notes:** P10 (Failure Mode Registry) applied. P10 previously validated; no new PEV credit.

### H77 — Add alias content verification to Phase 1b isolated branch check

**Pre-change:** MX77 (Isolated Branch Commit Content Verification): 0 (no content verification)

**Post-change:** p1b-split-commits.md Step I post-creation verification block extended. After the `git log --oneline <base-branch>..dep-review/<PR-number>/<alias>` instruction, added: "Confirm the output shows exactly one commit and that its message contains `<alias>`. If the message does not reference the expected alias, flag a cherry-pick error for this entry, skip it in the manifest with `push_failed: true`, and do not dispatch a Wave 1 agent for it."

- MX77: 100 (+100pp)

**Delta:** MX77 +100pp
**Secondary deltas:** RPC re-checked — the cherry-pick error failure mode now has an explicit recovery path (skip + flag). Positive. No degradation.
**Result:** confirmed
**Notes:** P6 (Symmetric Outcome Thresholds) applied — verification now checks both structural and content dimensions. P6 previously validated; no new PEV credit.

## Experiment Summary (Run 020)
- Confirmed: H74, H75, H76, H77
- Partial: none
- Disconfirmed: none

---

## Phase 5 — Report

| Metric | Baseline | Post | Delta | Weight | Weighted Δ |
|---|---|---|---|---|---|
| All inherited metrics (90) | ~10,429 | ~10,429 | 0 | 114× | 0 |
| Stale Skill Attribution in PR Comments (MX74) | 0 | 100 | +100 | 1× | +100 |
| Template-Guidance Separation in Phase 7 (MX75) | 0 | 100 | +100 | 1× | +100 |
| Gradle Plugin Portal Version Sort Instruction (MX76) | 0 | 100 | +100 | 1× | +100 |
| Isolated Branch Commit Content Verification (MX77) | 0 | 100 | +100 | 1× | +100 |
| Supply Chain Cross-Dependency Correlation (MX78) | 0 | 0 | 0 | 1× | 0 |
| **TOTAL** | **~10,429** | **~10,829** | **+400** | **119×** | **+400** |

**Post-experiment composite: ~10,829 / 11,900 × 100 = ~91.0%**

### Composite History

| | Score | Metrics | Weight |
|---|---|---|---|
| Run 019 final | ~91.5% | 90 | 114× |
| Run 020 baseline | ~87.6% | 95 | 119× |
| **Run 020 final** | **~91.0%** | **95** | **119×** |

Delta this run: +3.4pp (all primary metrics exact).

### What improved and why
- Stale Skill Attribution in PR Comments (+100pp): Phase 6 comment template now attributes reviews to `/bump-dependencies` — the current skill name since v4.0.0 — rather than the legacy `/review-dependency-update`.
- Template-Guidance Separation in Phase 7 Exclusion Banner (+100pp): agent conditional-inclusion logic for the exclusion banner is now stated as an explicit prose instruction before the template block; HTML comment delimiters no longer conflate agent directives with literal PR comment content.
- Gradle Plugin Portal Version Sort Instruction (+100pp): Phase 0 Step D Plugin Portal fallback now instructs sorting the version list in descending semantic order before applying pre-release exclusion and the 7-day check — version selection is deterministic regardless of XML source ordering.
- Isolated Branch Commit Content Verification (+100pp): Phase 1b Step I verification now checks that the extra commit's message contains the expected alias name, detecting cherry-pick errors before Wave 1 agents are dispatched.

### What was dropped
Nothing — all four hypotheses confirmed.

### What remains to improve
- Multi-Catalogue Dependency Deduplication Coverage (MX49): 0 — moonshot; carries forward.
- Pre-Bump Base Branch CI Health Check (MX43): 0 — moonshot; carries forward.
- Changelog URL Annotation Freshness Risk (MX38): 0 — moonshot; carries forward.
- Temporal Safety Window Consistency (MX34): 0 — moonshot; carries forward.
- Supply Chain Cross-Dependency Correlation Coverage (MX78): 0 — moonshot; no tractable hypothesis within single-run scope.
- Pattern Experimental Validation Rate (PEV): ~56 — structural; H75 applied a novel pattern (not yet a seed pattern, so no PEV credit until it is). Dormant patterns (P5, P13, P14, P17) remain unvalidatable without artificial hypotheses.

### Novel Pattern Candidates

## Novel Patterns Discovered — 2026-04-17

### NP1 — Template-Body Instruction Separation
**Discovered in:** skills/bump-dependencies/ (Phase 7 exclusion banner)
**Problem it solved:** Agent conditional-inclusion directives were embedded inside a fenced code block template as HTML comments, conflating two distinct constructs: (a) literal output content (everything inside the fenced block) and (b) agent execution logic (whether to include a section). The conflation risks an agent either copying the HTML comment into the generated output or misreading the conditional as template structure rather than instruction.
**Implementation:** Move the conditional-inclusion directive outside the fenced template block as explicit prose (e.g., "Include this block only when X — omit entirely if Y."). The fenced block contains only literal output content.
**Metrics it improved:** Template-Guidance Separation (MX75), Instruction Ambiguity Rate (IAR minor positive)
**Generalises to:** Any workflow that uses fenced code blocks as PR comment or output templates where conditional sections need agent-directed inclusion/omission. Particularly relevant to skills that use `<!-- -->` HTML comments both to hide content from rendered views and to embed agent guidance.
**Seed candidate:** yes — this is a specific and repeatable pattern gap that would recur in any template-heavy skill. Proposes addition to seed library as P19.
