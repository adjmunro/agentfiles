<!-- SUMMARY-START -->
## Run 025 — 2026-04-22 | Target: skills/bump-dependencies/

Composite: 89.6% → 92.6% (+3.0 pp)

### Hypotheses
| ID  | Description                                                               | Outcome   |
|-----|---------------------------------------------------------------------------|-----------|
| H98 | Clarify actionable/advisory classification for all symbol categories in Phase 3 Step A | Confirmed |
| H99 | Add all-pending Phase 1 CI state row to Phase 5 scoring matrix            | Confirmed |
| H100 | Add enumeration failure propagation note to Phase 3 Step D impact table  | Confirmed |
| H101 | Add alias filename sanitisation instruction to Phase 6 Step B             | Confirmed |
| H102 | Define `<short-hash>` source in Phase 6 Step A comment header             | Confirmed |

### Metric Snapshot
| Metric                                          | Baseline | Post |
|-------------------------------------------------|----------|------|
| Phase 3 Step A Symbol Classification Completeness (MX101) | 50  | 100  |
| Phase 5 All-Pending Phase 1 CI State Coverage (MX102)     | 0   | 100  |
| Phase 3 Enumeration Failure Impact Table Propagation (MX103) | 0 | 100  |
| Phase 6 Step B Alias Filename Sanitisation (MX104)        | 0   | 100  |
| Phase 6 Step A Commit Hash Source Clarity (MX105)         | 0   | 100  |
| Composite                                       | 89.6%    | 92.6% |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

**Target:** `skills/bump-dependencies/`
**Files:** 39 total (11 command, 4 support, 24 optimise logs)
**Token estimate:** ~22,500 tokens (instruction files only)

### Cross-Run Context (from researchlog-024.md)
Previous composite: 88.8% → 92.4% (+3.6pp, 116 metrics, 141×)
H93–H97: all Confirmed — excluded from this run.
Moonshots: MX34, MX38, MX43, MX49, MX78 — architectural scope, unchanged.

Run 024 recommended targeted re-read of Phase 3 (code impact mapping) and Phase 6
(comment posting) as comparatively under-audited phases. This run implements that
recommendation.

### Feature Inventory
Unchanged from Run 024.
- Multi-phase pipeline: yes (11 phases)
- Persona system: yes (Ink, Echo, Rook, Arden — 4 personas)
- Subagent invocations: yes (Wave 1 and Wave 3 — parallel per-alias agents)
- Multi-session orchestration: yes (/tmp session brief + consolidation summary)
- Parallel execution: yes (Wave 1 and Wave 3 concurrent per-alias agents)
- Cached artifacts: yes (session brief, manifest, consolidation summary)

### Persona Staleness Check
All 4 personas confirmed present and current per Run 024. No broken references.

### Excluded from this run
H1–H97: all confirmed or disconfirmed across runs 001–024. See respective run logs.

### Files
Command (11): bump-dependencies.md, p0-bump.md, p1-parse.md, p1b-split-commits.md,
  p2-investigate.md, p3-impact.md, p4-remediate.md, p5-verdict.md, p6-comment.md,
  p7-summary.md, p8-consolidate.md
Support (4): SKILL.md, AGENTS.md, VERSION.md, CHANGELOG.md
Optimise logs (24): researchlog-001 through researchlog-024

### Structural Gaps Identified (Phase 3 and Phase 6 fresh audit)

1. **Phase 3 Step A — actionable/advisory classification incomplete.**
   Step A lists four symbol categories with varying modal verbs: "must find and replace"
   (removed APIs), "should find and migrate" (deprecated APIs), "must verify usage"
   (changed signatures), and no label (CVE patterns). Phase 4's trigger condition is
   "if actionable usages were found (must-fix items)" and Phase 5 awards a −1 credit
   for "all actionable usages fully remediated." Both depend on a consistent definition
   of actionable. Only two of the four categories are unambiguously labelled — "must
   verify usage" and CVE-pattern usages are underspecified: verification may reveal no
   required code change (→ advisory) or a required change (→ actionable), and the
   category label provides no guidance on when to classify each way.

2. **Phase 5 scoring matrix — no row for all-pending Phase 1 CI state.**
   Phase 1 Step G (introduced in 4.16.0/Run 023) now records a third CI state:
   "CI status: pending — no results yet" when all checks are still in progress (distinct
   from "passing" and "one or more failing"). Phase 5 scoring matrix does not have a
   row for this state. "CI was passing at Phase 1 (or no CI configured) | 0" does not
   cover it. The "+2 re-check result pending or unavailable at Phase 5 time" row
   applies to Phase 4's re-check pending, not Phase 1's initial pending state.
   An agent scoring a dependency where Phase 1 recorded all-pending CI has no
   prescribed signal — it will improvise (likely applying 0 or misapplying +2).

3. **Phase 3 Step D — enumeration failure warning not propagated to impact table.**
   H97 (Run 024) added an explicit terminal fallback to Phase 2 Pass A: when all
   five enumeration strategies fail, the agent records "Intermediate version
   enumeration failed — assuming single-version span" and proceeds. Phase 3's Step D
   impact table template has no field for this warning. A reviewer reading only the
   Phase 6 PR comment (which includes the verdict block and the impact table) has no
   way to know that intermediate releases were not investigated. The warning lives in
   the Phase 2 investigation report, which is not published to the PR.

4. **Phase 6 Step B — slash in alias breaks temp file path.**
   Phase 6 Step B uses `/tmp/dep-review-<PR-number>-<alias>.md` as the temp file name.
   GitHub Actions aliases are `owner/action` format (e.g., `actions/checkout`). A file
   named `/tmp/dep-review-1234-actions/checkout.md` would fail: the shell would
   interpret `actions/` as a subdirectory, which does not exist under `/tmp/`. No
   instruction sanitises the alias before constructing the path. Every Phase 6 comment
   for a GitHub Actions bump would fail at Step B.

5. **Phase 6 Step A — `<short-hash>` source undefined.**
   The PR comment header template uses `<short-hash>` as a placeholder with no
   definition of which commit to use. At Phase 6 time, the isolated branch has: (1) the
   original cherry-picked bump commit from Phase 1b, (2) any Phase 4 remediation
   commits. Current HEAD is the last commit on the branch. An agent using HEAD would
   cite a remediation commit hash in the header rather than the bump commit that
   initiated the review — misleading to reviewers tracing the bump to its origin.

---

## Phase 2 — Baseline

Re-read run log Phase 1 — confirmed: target `skills/bump-dependencies/`, 11 command files,
focus on Phase 3 and Phase 6.

### Inherited Metrics
All 116 metrics from Run 024 carry forward at post-experiment values:
- Inherited weighted sum: ~13,025 (141×)

### Custom Metric Discovery — New Metrics (MX101–MX105)

**Prior run log check**: scanned run logs for `### MX` sections. MX1–MX100 already
defined. MX101+ available for new definitions.

---

### MX101 — Phase 3 Step A Symbol Classification Completeness [custom]
**Measures:** Whether all four symbol-category entries in Phase 3 Step A are
unambiguously classified as actionable (must fix — triggers Phase 4) or advisory
(should migrate — does not trigger Phase 4 but appears in impact table).
**Why seeds miss it:** M3 IAR catches ambiguous modal verbs but not missing
classification labels on otherwise well-specified categories. M6 ACC measures
acceptance criteria concreteness but not the completeness of a classification
taxonomy that downstream phases depend on.
**Methodology:** Read Phase 3 Step A. For each of the four symbol categories,
determine whether the description unambiguously indicates actionable or advisory.
Scoring: (1) Removed APIs — "must find and replace" → actionable ✓;
(2) Deprecated APIs — "should find and migrate" → advisory ✓;
(3) Changed signatures — "must verify usage" → no classification (verification
may or may not require a code change) ✗;
(4) CVE patterns — no classification label ✗. Raw: 2/4 = 0.5.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** (classified_categories / total_categories) × 100
**Score: 50**

---

### MX102 — Phase 5 All-Pending Phase 1 CI State Coverage [custom]
**Measures:** Whether Phase 5 Step A scoring matrix includes an explicit row for the
case where Phase 1 Step G recorded "CI status: pending — no results yet" (all checks
still in progress, none completed or failed).
**Why seeds miss it:** M6 ACC measures concreteness of existing criteria but not
coverage of all input states a prior phase can produce. The all-pending state is a
distinct Phase 1 output introduced in 4.16.0 — no seed metric monitors inter-phase
state coverage.
**Methodology:** Inspect p5-verdict.md Step A scoring matrix. Count rows covering CI
states at Phase 1 time: (1) "CI was passing at Phase 1 (or no CI configured)" ✓;
(2) "CI was failing at Phase 1; all failures now resolved" ✓; (3) "CI was failing at
Phase 1; failures remain unresolved (non-environment)" ✓; (4) "CI was failing at
Phase 1; failures remain unresolved (test environment issue only)" ✓; (5) "CI was
failing at Phase 1; re-check result pending or unavailable at Phase 5 time" ✓.
All-pending Phase 1 state: not covered ✗. Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** all_pending_row_present × 100
**Score: 0**

---

### MX103 — Phase 3 Enumeration Failure Impact Table Propagation [custom]
**Measures:** Whether Phase 3 Step D's impact table template includes a field or
instruction for surfacing Phase 2 Pass A enumeration failure warnings (that
intermediate release impact may be incomplete).
**Why seeds miss it:** M1 IOT measures whether phases re-read prior-phase artifacts
but not whether all relevant warnings within those artifacts are propagated through
to published outputs. The warning lives in the Phase 2 investigation report (not
published to the PR); the impact table is the only Phase 3 output that survives
to PR comment level via Phase 6.
**Methodology:** Inspect p3-impact.md Step D for any field, instruction, or template
row covering the case where Phase 2 recorded "Intermediate version enumeration
failed — assuming single-version span." Current state: no such field. Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** propagation_instruction_present × 100
**Score: 0**

---

### MX104 — Phase 6 Step B Alias Filename Sanitisation [custom]
**Measures:** Whether Phase 6 Step B sanitises the alias before using it as part of
the temp file name, to prevent path-separator failures for aliases that contain
slashes (e.g., GitHub Actions `owner/action` format).
**Why seeds miss it:** M11 PSS measures parallel mutation guards for git operations
but not shell-path safety of temp file naming. M7 SAS measures subagent task
appropriateness, not file-operation edge cases within a single phase.
**Methodology:** Inspect p6-comment.md Step B. Check whether the temp file name
construction (`/tmp/dep-review-<PR-number>-<alias>.md`) includes a sanitisation
step (e.g., replace `/` with `-`) for the alias component. Current state: no
sanitisation instruction. A GitHub Actions alias like `actions/checkout` would
produce `/tmp/dep-review-<PR>-actions/checkout.md` — treated as a path into a
non-existent `actions/` subdirectory. Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** sanitisation_instruction_present × 100
**Score: 0**

---

### MX105 — Phase 6 Step A Commit Hash Source Clarity [custom, moonshot]
**Measures:** Whether Phase 6 Step A explicitly defines which commit SHA to use as
`<short-hash>` in the PR comment header — specifically, whether it is the original
cherry-picked bump commit (Phase 1b origin) or the current HEAD of the isolated
branch (which may be a Phase 4 remediation commit).
**Why seeds miss it:** M3 IAR catches weak modals but not undefined placeholders.
The moonshot: treating `<short-hash>` as an implicit contract between phases —
Phase 6 is the consumer of a value set by Phase 1b and Phase 4, but the contract is
never made explicit. Applying interface-design thinking: every placeholder in a
published output should have a named source.
**Methodology:** Inspect p6-comment.md Step A for a definition or annotation of
`<short-hash>`. Current state: placeholder with no source annotation. An agent
using current HEAD would cite the last remediation commit rather than the bump
commit, potentially confusing reviewers. Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** source_defined × 100
**Score: 0**

---

### New Metrics This Run

| Metric | Raw | Normalised | Weight | Weighted |
|--------|-----|-----------|--------|----------|
| Phase 3 Step A Symbol Classification Completeness (MX101) | 2/4 | 50 | 1× | 50 |
| Phase 5 All-Pending Phase 1 CI State Coverage (MX102) | 0/1 | 0 | 1× | 0 |
| Phase 3 Enumeration Failure Impact Table Propagation (MX103) | 0/1 | 0 | 1× | 0 |
| Phase 6 Step B Alias Filename Sanitisation (MX104) | 0/1 | 0 | 1× | 0 |
| Phase 6 Step A Commit Hash Source Clarity (MX105) | 0/1 | 0 | 1× | 0 |

### Full Composite (121 metrics)

```
Inherited weighted sum: ~13,025 (141×)
New metrics weighted sum: 50 + 0 + 0 + 0 + 0 = 50 (5×)
Total: ~13,075 / 14,600 (146×)

Composite: ~13,075 / 14,600 × 100 = ~89.6%
```

*(Drop of 2.8pp from scope expansion: 5 new weight units, only 50 scored.)*

### Weakest Metrics (Phase 3 candidates)
1. MX102 — Phase 5 All-Pending Phase 1 CI State Coverage: 0 (1×)
2. MX103 — Phase 3 Enumeration Failure Impact Table Propagation: 0 (1×)
3. MX104 — Phase 6 Step B Alias Filename Sanitisation: 0 (1×)
4. MX105 — Phase 6 Step A Commit Hash Source Clarity: 0 (1×, moonshot)
5. MX101 — Phase 3 Step A Symbol Classification Completeness: 50 (1×)

---

## Phase 3 — Hypotheses

Re-read run log Phase 2 — confirmed weakest: MX101 (50), MX102–MX105 (all 0).

### Step 0 — Pre-Experiment Dependency Scan
H98 → p3-impact.md (Step A)
H99 → p5-verdict.md (Step A — scoring matrix)
H100 → p3-impact.md (Step D)
H101 → p6-comment.md (Step B)
H102 → p6-comment.md (Step A)

Overlaps: H98 and H100 both modify p3-impact.md → run sequentially with re-check.
H101 and H102 both modify p6-comment.md → run sequentially with re-check.
H99 is independent of all others.
Execution order: H98 → H100 → (re-check p3) → H99 → H102 → H101 → (re-check p6).

---

### H98 — Clarify Phase 3 Step A actionable/advisory classification

**Problem observed:** MX101 = 50. Step A lists four symbol categories but only two
are unambiguously classified: "must find and replace" (removed APIs = actionable)
and "should find and migrate" (deprecated APIs = advisory). "Must verify usage"
(changed signatures) and CVE-pattern search have no explicit label. Phase 4 triggers
on "actionable usages (must-fix items)" and Phase 5 credits "all actionable usages
fully remediated." Agents making different judgements about whether a changed-signature
usage or found CVE pattern is actionable produce inconsistent Phase 4 and Phase 5
outputs.
**Change proposed:** In p3-impact.md Step A, add classification guidance after the
four-category list: "For the impact table in Step D, classify each found usage as
**actionable (must fix)** or **advisory (should migrate)**: Removed APIs and CVE
patterns found in active use are always actionable. Deprecated APIs are advisory.
Changed-signature usages are actionable if a code change is required to maintain
correct behaviour after the bump; advisory if the usage is unaffected."
**Targets:** Phase 3 Step A Symbol Classification Completeness (MX101): 50 → 100 (+50pp)
**Predicted improvement:** +50 weighted (1×)
**Pattern applied:** P6 — Symmetric Outcome Thresholds (extends classification to
cover all four input categories with explicit actionable/advisory labels)
**Risk level:** low
**Risk note:** Additive guidance paragraph. Does not change the search steps or the
impact table format — only clarifies how to label found usages.

---

### H99 — Add all-pending Phase 1 CI state to Phase 5 scoring matrix

**Problem observed:** MX102 = 0. Phase 1 Step G (4.16.0) introduced a third CI
state: "CI status: pending — no results yet" when all checks are still in progress.
Phase 5 scoring matrix covers five CI states but not this one. An agent scoring a
dependency where Phase 1 recorded all-pending CI has no prescribed signal. It would
likely apply 0 (treating all-pending as equivalent to passing) or incorrectly apply
+2 (the Phase 4 re-check pending row, which is a different concept). An explicit row
prevents this ambiguity.
**Change proposed:** In p5-verdict.md Step A scoring matrix, add a new row:
`| CI was all-pending at Phase 1 (no checks had completed when Phase 1 ran) | 0 |`
immediately after "CI was passing at Phase 1 (or no CI configured) | 0". Add a
clarifying note: "Apply this row when Phase 1 Step G recorded 'CI status: pending —
no results yet'. This is the initial Phase 1 state, not the Phase 4 re-check state
— treat as neutral (equivalent to no CI data). Do not apply the '+2 re-check pending'
row for a Phase 1 all-pending state."
**Targets:** Phase 5 All-Pending Phase 1 CI State Coverage (MX102): 0 → 100 (+100pp)
**Predicted improvement:** +100 weighted (1×)
**Pattern applied:** P6 — Symmetric Outcome Thresholds (extends scoring matrix to
cover all states that Phase 1 Step G can produce, including the new pending state)
**Risk level:** low
**Risk note:** Additive row at 0 points — does not change scoring for any existing
state. The 0-point assignment is conservative: all-pending CI is neutral, not
penalised, since no failure signal was produced by Phase 1.

---

### H100 — Add enumeration failure propagation to Phase 3 Step D

**Problem observed:** MX103 = 0. After H97 (Run 024) added Phase 2's terminal
enumeration fallback, Phase 3 Step D impact table has no field to surface the
"Intermediate version enumeration failed" warning. Reviewers reading only the Phase 6
PR comment (which includes the impact table) cannot know that intermediate releases
were not investigated. This is a trust-chain break: Phase 2 recorded a limitation;
Phase 3 could communicate it; but the impact table is silent.
**Change proposed:** In p3-impact.md Step D, add a conditional instruction before
the impact table template: "If Phase 2 Pass A recorded 'Intermediate version
enumeration failed — assuming single-version span', add a warning to the impact
table under Summary: 'Note: intermediate version enumeration failed — impact covers
final release only. Intermediate releases may contain additional breaking changes,
deprecations, or CVEs not captured here.'" Also add a `### Enumeration Warning`
sub-entry in the Summary section of the impact table template (conditional — include
only when the warning applies).
**Targets:** Phase 3 Enumeration Failure Impact Table Propagation (MX103): 0 → 100 (+100pp)
**Predicted improvement:** +100 weighted (1×)
**Pattern applied:** P1 — Intent Anchor Blocks (ensures a key Phase 2 finding is
re-read and carried forward rather than lost at a phase boundary)
**Risk level:** low
**Risk note:** Conditional addition — has no effect when enumeration succeeds. The
warning text is informational only and does not change the verdict.

---

### H101 — Add alias filename sanitisation to Phase 6 Step B

**Problem observed:** MX104 = 0. Phase 6 Step B constructs the temp file name as
`/tmp/dep-review-<PR-number>-<alias>.md`. GitHub Actions aliases are `owner/action`
format. The slash makes the path invalid — the shell treats `owner/` as a
subdirectory of `/tmp/dep-review-<PR>-`, which does not exist. Every Phase 6 comment
for a GitHub Actions bump would fail at `cat > /tmp/...`. The fix is one line of
sanitisation before the heredoc.
**Change proposed:** In p6-comment.md Step B, add a sanitisation instruction
immediately before the temp file block: "Sanitise the alias for use in the filename:
replace any `/` characters with `-` (e.g., `actions/checkout` → `actions-checkout`).
Use the sanitised alias in both the temp file name and the `--body-file` argument."
Update the example file name accordingly: `/tmp/dep-review-<PR-number>-<alias-safe>.md`.
**Targets:** Phase 6 Step B Alias Filename Sanitisation (MX104): 0 → 100 (+100pp)
**Predicted improvement:** +100 weighted (1×)
**Pattern applied:** P10 — Failure Mode Registry (adds explicit handling for a file
operation failure mode that fires on every GitHub Actions bump)
**Risk level:** low
**Risk note:** One-line additive instruction. Sanitisation only affects the temp file
name — the PR comment content is unchanged.

---

### H102 — Define `<short-hash>` source in Phase 6 Step A

**Problem observed:** MX105 = 0. The PR comment header uses `<short-hash>` as a
placeholder with no definition. At Phase 6 time the isolated branch may have: (1) the
original cherry-picked bump commit from Phase 1b, and (2) zero or more Phase 4
remediation commits. An agent using `git rev-parse --short HEAD` would cite the last
remediation commit — a fix commit, not the bump commit that initiated the review.
Reviewers tracing the comment back to the original change would be misdirected.
**Change proposed:** In p6-comment.md Step A, annotate the `<short-hash>` placeholder:
"Use the short hash of the original bump commit — the commit cherry-picked to the
isolated branch in Phase 1b Step I. This is the first (and, for proactive mode, only
pre-remediation) commit on `dep-review/<PR-number>/<alias>` beyond the base branch
tip. Phase 4 remediation commits are listed separately in the footer line; do not
use a remediation commit hash here."
**Targets:** Phase 6 Step A Commit Hash Source Clarity (MX105): 0 → 100 (+100pp)
**Predicted improvement:** +100 weighted (1×)
**Pattern applied:** P18 — Cross-File Structural Anchor (names the exact source
phase and step for a data item used in a downstream phase output)
**Risk level:** low
**Risk note:** Additive annotation. Does not change comment structure or content —
only specifies which SHA to use.

---

### Self-Audit (Keeper)

1. **Intent check:** H98 targets MX101 (50) ✓; H99 targets MX102 (0) ✓; H100 targets
   MX103 (0) ✓; H101 targets MX104 (0) ✓; H102 targets MX105 (0) ✓. All five metrics
   are below 100. ✓
2. **Coverage check:**
   - H98: +50 weighted; H99–H102: +100 each = +400 weighted. Total: +450.
   - Projected: (~13,075 + 450) / 14,600 = 13,525 / 14,600 = **~92.6%** < 95%
   - Below 95%. Remaining moonshots (MX34, MX38, MX43, MX49, MX78) are at 0 —
     architectural scope; no tractable instruction-file hypothesis available.
     No non-moonshot metric below 80 is uncovered. ✓
3. **Gap fill:** All non-moonshot metrics below 100 have hypotheses. ✓

### Recommendation Brief

Based on baseline measurement, the following experiments are queued.

1. **Clarify actionable/advisory classification in Phase 3 Step A** — "must verify
   usage" (changed signatures) and CVE-pattern usages have no explicit classification;
   agents make inconsistent must-fix determinations that propagate to Phase 4 and Phase 5.
2. **Add all-pending Phase 1 CI row to Phase 5 scoring matrix** — Phase 1 Step G now
   produces a third state ("pending — no results yet") with no prescribed Phase 5 signal;
   agents either apply 0 or misapply the Phase 4 re-check pending +2 row.
3. **Propagate enumeration failure warning through Phase 3 impact table** — when Phase 2
   records "intermediate version enumeration failed," Phase 3's impact table is silent
   about the limitation; PR reviewers have no indication that intermediate releases were
   not investigated.
4. **Add alias filename sanitisation to Phase 6 Step B** — GitHub Actions aliases
   contain a slash (`owner/action`) that makes the temp file path invalid; every Phase 6
   comment for a GitHub Actions bump would fail at the file write step.
5. **Define the `<short-hash>` source in Phase 6 Step A** — the placeholder is undefined;
   an agent using the current isolated branch HEAD would cite a Phase 4 remediation commit
   rather than the original bump commit, misleading PR reviewers.

---

## Phase 4 — Experiments

Re-read Phase 3 — approved hypotheses: H98, H99, H100, H101, H102.
File overlap: H98 and H100 modify p3-impact.md; H101 and H102 modify p6-comment.md.
Execution order: H98 → H100 → (p3 re-check) → H99 → H102 → H101 → (p6 re-check).

---

### H98 — Clarify Phase 3 Step A classification guidance

**Pre-change:** MX101 = 50 (2/4 categories classified)
**Change applied** to `p3-impact.md` Step A: added a classification paragraph after the
four-category list specifying that removed APIs and CVE patterns in active use are
always actionable; deprecated APIs are advisory; changed-signature usages are actionable
only if a code change is required to maintain correct behaviour, advisory otherwise. Added
a sentence clarifying that this classification drives Phase 4 and Phase 5 scoring.
**MX101 re-check:** all four symbol categories now have unambiguous actionable/advisory
labels. Raw: 4/4. **Score: 50 → 100 (+50pp) ✓**
**Secondary deltas:** M3 IAR re-checked — new paragraph uses declarative language with no
weak modals. No degradation.
**Result:** confirmed
**Notes:** P6 (Symmetric Outcome Thresholds) applied — classification extended to all
four input categories.

---

### H100 — Add enumeration failure propagation to Phase 3 Step D

**Pre-change:** MX103 = 0
**Change applied** to `p3-impact.md` Step D: added a conditional `### Enumeration Warning`
section to the impact table template with an instruction to include the warning only when
Phase 2 recorded "Intermediate version enumeration failed — assuming single-version span";
section is to be omitted entirely when enumeration succeeded.
**MX103 re-check:** Step D impact table now has an explicit propagation field for the Phase 2
enumeration failure warning. Raw: 1/1. **Score: 0 → 100 (+100pp) ✓**
**Secondary deltas:** M1 IOT re-checked — Phase 3 now explicitly re-reads Phase 2's
enumeration warning and surfaces it in the output. No degradation.
**Result:** confirmed
**Notes:** P1 (Intent Anchor Blocks) applied — Phase 2 enumeration warning is anchored
in the Phase 3 output rather than lost at the phase boundary.

---

### p3-impact.md re-check

MX101: 100 ✓, MX103: 100 ✓. No regressions observed.

---

### H99 — Add all-pending CI row to Phase 5 scoring matrix

**Pre-change:** MX102 = 0
**Change applied** to `p5-verdict.md` Step A scoring matrix: added
`| CI was all-pending at Phase 1 (no checks had completed when Phase 1 ran) | 0 |`
immediately after the "CI was passing at Phase 1 (or no CI configured) | 0" row.
Added a clarifying note explaining the difference between this row (Phase 1 initial
pending state — neutral) and the "+2 re-check pending" row (Phase 4 re-check state —
precautionary penalty).
**MX102 re-check:** scoring matrix now covers all four Phase 1 CI states (passing, all-pending,
failing-resolved, failing-unresolved). Raw: 1/1. **Score: 0 → 100 (+100pp) ✓**
**Secondary deltas:** M6 ACC re-checked — new row is concrete (0 points, named state).
No degradation.
**Result:** confirmed
**Notes:** P6 (Symmetric Outcome Thresholds) applied — scoring matrix extended to cover
the third Phase 1 CI state introduced in 4.16.0.

---

### H102 — Define `<short-hash>` source in Phase 6 Step A

**Pre-change:** MX105 = 0
**Change applied** to `p6-comment.md` Step A: added a blockquote immediately before the
comment template specifying that `<short-hash>` is the original bump commit cherry-picked
in Phase 1b Step I (first commit on the isolated branch beyond base), not the current HEAD
(which may be a Phase 4 remediation commit); remediation commits are listed separately in
the footer line.
**MX105 re-check:** `<short-hash>` source is now explicitly defined by named phase and step.
Raw: 1/1. **Score: 0 → 100 (+100pp) ✓**
**Secondary deltas:** M3 IAR re-checked — blockquote uses imperative language with no
weak modals. No degradation.
**Result:** confirmed
**Notes:** P18 (Cross-File Structural Anchor) applied — data item source named by phase
and step rather than left as an undefined placeholder.

---

### H101 — Add alias sanitisation to Phase 6 Step B

**Pre-change:** MX104 = 0
**Change applied** to `p6-comment.md` Step B: added a prose sanitisation instruction
and a `ALIAS_SAFE=$(echo "<alias>" | tr '/' '-')` variable before the heredoc; updated
temp file name and `--body-file` argument to use `${ALIAS_SAFE}` instead of `<alias>`;
provided an example (`actions/checkout` → `actions-checkout`).
**MX104 re-check:** Step B now sanitises the alias before constructing the temp file path.
Raw: 1/1. **Score: 0 → 100 (+100pp) ✓**
**Secondary deltas:** M11 PSS re-checked — sanitisation applies to sequential file
operations; no parallel mutation conflict introduced. No degradation.
**Result:** confirmed
**Notes:** P10 (Failure Mode Registry) applied — GitHub Actions slash-alias failure mode
now has an explicit recovery instruction (sanitisation before use).

---

### p6-comment.md re-check

MX104: 100 ✓, MX105: 100 ✓. No regressions observed.

---

### Post-Experiment Composite

```
Inherited weighted sum:  ~13,025 (141×)
New metrics post-scores: 100 + 100 + 100 + 100 + 100 = 500 (5×)
Total: ~13,525 / 14,600 (146×)

Composite: ~13,525 / 14,600 × 100 = ~92.6%
```

---

## Phase 5 — Report

| Metric | Baseline | Post | Delta | Weight | Weighted Δ |
|---|---|---|---|---|---|
| All inherited metrics (116) | ~13,025 | ~13,025 | 0 | 141× | 0 |
| Phase 3 Step A Symbol Classification Completeness (MX101) | 50 | 100 | +50 | 1× | +50 |
| Phase 5 All-Pending Phase 1 CI State Coverage (MX102) | 0 | 100 | +100 | 1× | +100 |
| Phase 3 Enumeration Failure Impact Table Propagation (MX103) | 0 | 100 | +100 | 1× | +100 |
| Phase 6 Step B Alias Filename Sanitisation (MX104) | 0 | 100 | +100 | 1× | +100 |
| Phase 6 Step A Commit Hash Source Clarity (MX105) | 0 | 100 | +100 | 1× | +100 |
| **TOTAL** | **~13,075** | **~13,525** | **+450** | **146×** | **+450** |

**Post-experiment composite: ~13,525 / 14,600 × 100 = ~92.6%**

### What improved and why
- Phase 3 Step A Symbol Classification Completeness (+50pp): classification paragraph
  added after the four-category list — all four symbol types now have unambiguous
  actionable/advisory labels, giving Phase 4 and Phase 5 a consistent must-fix count basis.
- Phase 5 All-Pending Phase 1 CI State Coverage (+100pp): "CI was all-pending at Phase 1 | 0"
  row added with a clarifying note — agents no longer improvise or misapply the Phase 4
  re-check +2 row when Phase 1 recorded all-pending CI.
- Phase 3 Enumeration Failure Impact Table Propagation (+100pp): conditional
  `### Enumeration Warning` section added to the Step D template — the Phase 2 enumeration
  fallback warning now appears in the published impact table where PR reviewers can see it.
- Phase 6 Step B Alias Filename Sanitisation (+100pp): `tr '/' '-'` sanitisation added —
  GitHub Actions aliases (`owner/action`) no longer produce an invalid temp file path,
  fixing a failure that would have affected every GitHub Actions bump.
- Phase 6 Step A Commit Hash Source Clarity (+100pp): blockquote annotation added before
  the comment template — agents now know to use the Phase 1b cherry-pick commit SHA, not
  the current isolated branch HEAD.

### What was dropped
Nothing — all five hypotheses confirmed.

### What remains to improve
- Multi-Catalogue Dependency Deduplication Coverage (MX49): 0 — moonshot; carries forward.
- Pre-Bump Base Branch CI Health Check (MX43): 0 — moonshot; carries forward.
- Changelog URL Annotation Freshness Risk (MX38): 0 — moonshot; carries forward.
- Temporal Safety Window Consistency (MX34): 0 — moonshot; carries forward.
- Phase 7 / Phase 8 Cross-Reference Accuracy (MX78): 0 — moonshot; carries forward.

### Novel Patterns Observed
None this run. H98 applied P6; H99 applied P6; H100 applied P1; H101 applied P10; H102
applied P18.

## Experiment Summary
- Confirmed: H98, H99, H100, H101, H102
- Partial: none
- Disconfirmed: none
