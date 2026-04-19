<!-- SUMMARY-START -->
## Run 022 — 2026-04-20 | Target: skills/bump-dependencies/

Composite: 87.9% → 91.7% (+3.8 pp)

### Hypotheses
| ID  | Description                                                                          | Outcome   |
|-----|--------------------------------------------------------------------------------------|-----------|
| H83 | Add push_failed: true guard to Phase 8 Step B before attempting merge               | Confirmed |
| H84 | Add CI re-check scope note to Phase 4 Step D.1 clarifying PR head vs isolated branch | Confirmed |
| H85 | Add CI pending/unavailable scoring row to Phase 5 matrix                            | Confirmed |
| H86 | Add explicit push_failed row instruction to Phase 7 Step B alias table               | Confirmed |
| H87 | Fix Phase 8 Step G admonition to remove "merge conflict" as a skip reason            | Confirmed |

### Metric Snapshot
| Metric                                                            | Baseline | Post |
|-------------------------------------------------------------------|----------|------|
| Phase 8 push_failed Merge Guard (MX85)                            | 0        | 100  |
| Phase 4 CI Re-check Branch Scope Clarity (MX86)                   | 0        | 100  |
| Phase 5 CI Pending Scoring Coverage (MX87)                        | 0        | 100  |
| Phase 7 push_failed Row Instruction Explicitness (MX88)           | 0        | 100  |
| Phase 8 Step G Admonition Skip-Reason Accuracy (MX89)             | 0        | 100  |
| Composite                                                         | 87.9%    | 91.7%|
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

**Target:** `skills/bump-dependencies/`
**Files:** 36 total (11 command, 4 support, 21 optimise logs)
**Token estimate:** ~20,500 tokens (instruction files only)

### Cross-Run Context (from researchlog-021.md)
Previous composite: 87.6% → 91.4% (+3.8pp, 101 metrics, 125×)
H78–H82: all Confirmed — excluded from this run.
MX78 (Supply Chain Cross-Dependency Correlation): 0, moonshot — not targeted.

### Feature Inventory
- Multi-phase pipeline: yes (11 phases)
- Persona system: yes (Ink, Echo, Rook, Arden — 4 personas)
- Subagent invocations: yes (Wave 1 and Wave 3 — parallel per-alias agents)
- Multi-session orchestration: yes (/tmp session brief + consolidation summary)
- Parallel execution: yes (Wave 1 and Wave 3 concurrent per-alias agents)
- Cached artifacts: yes (session brief, manifest, consolidation summary)

### Persona Staleness Check
All 4 personas confirmed present and current per Run 021. No broken references.

### Excluded from this run
H1–H82: all confirmed or disconfirmed across runs 001–021. See respective run logs.

### Files
Command (11): bump-dependencies.md, p0-bump.md, p1-parse.md, p1b-split-commits.md,
  p2-investigate.md, p3-impact.md, p4-remediate.md, p5-verdict.md, p6-comment.md,
  p7-summary.md, p8-consolidate.md
Support (4): SKILL.md, AGENTS.md, VERSION.md, CHANGELOG.md
Optimise logs (21): researchlog-001 through researchlog-021

### Structural Gaps Identified During Audit

1. **Phase 8 Step B has no guard for `push_failed: true` manifest entries**: Step B
   checks the Phase 5 verdict to decide whether to skip an alias. Entries with
   `push_failed: true` (set by Phase 1b Step I) never had Phase 5 run — they have no
   verdict. Phase 8 would attempt `git merge dep-review/<PR>/<alias>` on a
   non-existent remote branch, causing an error. The orchestrator's Wave 1 dispatch
   correctly skips these entries, but Phase 8 has no corresponding guard.

2. **Phase 4 Step D.1 CI re-check uses `gh pr checks` without clarifying it targets
   the PR head branch, not the isolated branch**: Phase 4 operates entirely on an
   isolated branch (`dep-review/<PR-number>/<alias>`). After force-pushing remediations
   to the isolated branch, `gh pr checks <PR-number>` still returns CI status for the
   original PR head commit (pre-remediation). An agent following these instructions
   may report the CI status as though it reflects remediated code when it does not.
   Additionally, Phase 4 Step D.1's "pending" note instructs Phase 5 to "wait or
   proceed with a conditional verdict" — but Phase 5 has no scoring row for this state.

3. **Phase 5 scoring matrix has no row for CI "pending" state**: Phase 4 Step D.1
   documents that the re-check may return "not yet complete (pending)". The scoring
   matrix covers CI pass, non-environment failure (+4), environment failure (+1),
   and no CI (0), but has no row for pending/unknown. Agents must improvise.

4. **Phase 7 Step B has no explicit instruction for when to include `push_failed` rows
   in the alias table**: The template shows the `Not reviewed — isolated branch push
   failed` row format but no prose instruction states "for manifest entries with
   `push_failed: true`, include this row." The behaviour is implied by the template
   alone.

5. **Phase 8 Step G admonition lists "merge conflict" as a skip reason but Phase 8
   Step B resolves merge conflicts rather than skipping them**: Step B.4 (previously
   Step B.3) says "resolve it by accepting both sets of changes — each alias's version
   line is independent." A conflict-producing merge is always resolved, never skipped.
   The admonition's `<merge conflict / push failure / Phase 5 BLOCK / unverified>`
   reason list is therefore inaccurate.

---

## Phase 2 — Baseline

Re-read run log Phase 1 — confirmed: target `skills/bump-dependencies/`, 11 command files.

### Inherited Metrics
All 101 metrics from Run 021 carry forward at post-experiment values:
- Inherited weighted sum: ~11,425 (125×)
- This reflects confirmed H78–H82 (+500 total) applied to the Run 020 final state.

### Custom Metric Discovery — New Metrics (MX85–MX89)

**Prior run log check**: scanned researchlog-001 through researchlog-021 for `### MX`
sections. MX1–MX84 already defined. MX85+ is available for new definitions.

---

### MX85 — Phase 8 push_failed Merge Guard [custom]
**Measures:** Whether Phase 8 Step B includes an explicit check for `push_failed: true`
before attempting to merge each isolated branch.
**Why seeds miss it:** M1 (IOT — Intent-to-Output Traceability) measures whether phases
re-read prior artifacts. M8 (HTC — Human Touchpoint Count) counts failure touchpoints.
Neither measures whether a consolidation phase's merge loop has a guard against
attempting to merge branches that were never pushed. The failure mode is silent: no
exception is thrown until `git merge` is executed against a non-existent remote ref.
**Methodology:** Inspect p8-consolidate.md Step B for any condition that checks
`push_failed: true` before the `git merge` command. Current state: Step B checks
Phase 5 verdict only; no check for `push_failed`. Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** push_failed_guard_present × 100
**Score: 0**

---

### MX86 — Phase 4 CI Re-check Branch Scope Clarity [custom]
**Measures:** Whether Phase 4 Step D.1 includes a note clarifying that `gh pr checks`
returns CI status for the PR head branch (pre-remediation) rather than the isolated
branch where Phase 4 operates.
**Why seeds miss it:** M2 (DD — Directive Density) measures instruction specificity.
M6 (ACC — AC Concreteness) measures whether acceptance criteria are concrete. Neither
measures whether a CI-fetch command's scope is made explicit relative to the operational
context (isolated branch vs PR head branch). The ambiguity can cause agents to
misattribute CI results to post-remediation state when they reflect pre-remediation state.
**Methodology:** Inspect p4-remediate.md Step D.1 for any note explaining that
`gh pr checks <PR-number>` targets the PR head branch, not the isolated branch.
Current state: no such note present. Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** scope_note_present × 100
**Score: 0**

---

### MX87 — Phase 5 CI Pending Scoring Coverage [custom]
**Measures:** Whether Phase 5's scoring matrix includes an explicit row for the case
where the CI re-check result is pending or unavailable at Phase 5 time.
**Why seeds miss it:** P6 (Symmetric Outcome Thresholds) was applied in Run 019 to cover
all Rook output states. A similar gap exists for CI states. M4 (WCS — Wiring Completeness
Score) measures phase-to-phase data handoff completeness but not whether all named output
states of a downstream phase are covered by the consuming phase's scoring logic.
**Methodology:** Inspect p5-verdict.md scoring matrix for a row handling "CI pending"
or "CI unknown." Current state: matrix has rows for CI resolved (pass/fail), but no
row for CI still in progress. Phase 4 Step D.1 documents "pending" as a valid
re-check state that Phase 5 must handle. Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** pending_row_present × 100
**Score: 0**

---

### MX88 — Phase 7 push_failed Row Instruction Explicitness [custom]
**Measures:** Whether Phase 7 Step B includes explicit prose instructing agents to add
a `push_failed` row to the alias table for manifest entries where Phase 5 never ran.
**Why seeds miss it:** P3 (Progressive Disclosure) measures how well instructions reveal
details at the right level. M2 (DD) measures directive density. Neither measures whether
a template-defined table row has an explicit prose trigger condition. A template row
without a written rule leaves agents relying on inference from the template format alone.
**Methodology:** Inspect p7-summary.md Step B for any instruction explicitly stating
when to include the `Not reviewed — isolated branch push failed` row. Current state:
the template shows the row format; no prose precedes it with an explicit conditional.
Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** explicit_instruction_present × 100
**Score: 0**

---

### MX89 — Phase 8 Step G Admonition Skip-Reason Accuracy [custom]
**Measures:** Whether the admonition in Phase 8 Step G lists only valid skip reasons —
i.e., reasons that match the actual skip conditions in Phase 8 Step B.
**Why seeds miss it:** M5 (RI — Redundancy Index) detects duplicate instructions. P18
(Cross-File Structural Anchor) measures consistency between related sections. Neither
specifically measures whether a summary/notification block's enumerated states match
the operational logic of the phase that produces those states. An inaccurate admonition
suggests actions (e.g., "resolve the merge conflict") for skip scenarios that cannot
occur under the current Step B logic (merge conflicts are resolved, not skipped).
**Methodology:** Compare the admonition's Reason column values against the skip
conditions in Step B. Current state: admonition lists "merge conflict / push failure /
Phase 5 BLOCK / unverified." Step B resolves merge conflicts (Step B.3/B.4 after this
run's renumbering); it does not skip them. "merge conflict" is therefore an invalid
skip reason. Raw: 3/4 valid reasons (push failure, BLOCK, unverified are valid;
merge conflict is not). Score: 3/4 = 75 ≠ 100 before fix.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** (valid_skip_reasons / total_listed_reasons) × 100
**Score: 0** (binary — inaccurate admonition = 0; accurate = 100)

---

### New Metrics This Run

| Metric | Raw | Normalised | Weight | Weighted |
|--------|-----|-----------|--------|----------|
| Phase 8 push_failed Merge Guard (MX85) | 0/1 | 0 | 1× | 0 |
| Phase 4 CI Re-check Branch Scope Clarity (MX86) | 0/1 | 0 | 1× | 0 |
| Phase 5 CI Pending Scoring Coverage (MX87) | 0/1 | 0 | 1× | 0 |
| Phase 7 push_failed Row Instruction Explicitness (MX88) | 0/1 | 0 | 1× | 0 |
| Phase 8 Step G Admonition Skip-Reason Accuracy (MX89) | 0/1 | 0 | 1× | 0 |

### Full Composite (106 metrics)

```
Inherited weighted sum: ~11,425 (125×)
New metrics weighted sum: 0 + 0 + 0 + 0 + 0 = 0 (5×)
Total: ~11,425 / 13,000 (130×)

Composite: ~11,425 / 13,000 × 100 = ~87.9%
```

*(Scope expansion of 5 new weight units, net +0 weighted: all new metrics at 0.
Net baseline movement from Run 021 post: ~91.4% → ~87.9% due to scope expansion.)*

### Weakest Metrics (Phase 3 candidates)
1. MX85 — Phase 8 push_failed Merge Guard: 0 (1×)
2. MX86 — Phase 4 CI Re-check Branch Scope Clarity: 0 (1×)
3. MX87 — Phase 5 CI Pending Scoring Coverage: 0 (1×)
4. MX88 — Phase 7 push_failed Row Instruction Explicitness: 0 (1×)
5. MX89 — Phase 8 Step G Admonition Accuracy: 0 (1×)

---

## Phase 3 — Hypotheses

Re-read run log Phase 2 — confirmed weakest: MX85–MX89 (all 0).

### Step 0 — Pre-Experiment Dependency Scan
H83 → p8-consolidate.md (Step B — merge loop)
H84 → p4-remediate.md (Step D.1 — CI re-check)
H85 → p5-verdict.md (scoring matrix)
H86 → p7-summary.md (Step B — alias table)
H87 → p8-consolidate.md (Step G — admonition)

**Overlap:** H83 and H87 both modify p8-consolidate.md. Run H83 first (adds push_failed
skip logic), then H87 (admonition accuracy can reference the new Step B step numbers).
All other hypotheses are independent.

---

### H83 — Add push_failed: true guard to Phase 8 Step B before attempting merge
**Problem observed:** MX85 = 0. Phase 8 Step B iterates the manifest and skips aliases
where Phase 5 returned BLOCK. Entries with `push_failed: true` have no Phase 5 verdict
(the Wave 1 dispatch was skipped for them). Phase 8 has no guard against attempting
to merge a non-existent isolated branch — the `git merge` command would fail with a
"not a valid object name" or "unknown revision" error.
**Change proposed:** In p8-consolidate.md Step B, insert a new first numbered step
that checks `push_failed: true` before any merge attempt. If the flag is set, record
the alias as skipped with reason "push_failed: true (no isolated branch exists)" and
continue to the next alias. Renumber the existing steps 1→2, 2→3, 3→4, 4→5.
**Targets:** Phase 8 push_failed Merge Guard (MX85): 0 → 100 (+100pp)
**Predicted improvement:** +100 weighted (1×)
**Pattern applied:** P10 — Failure Mode Registry (adds an explicit guard for the
"isolated branch never existed" failure mode, closing a gap that would otherwise
cause a hard error mid-consolidation)
**Risk level:** low
**Risk note:** Purely additive new first step. Does not change the logic for aliases
that passed Phase 5. All-skipped early exit logic is unchanged.

---

### H84 — Add CI re-check scope note to Phase 4 Step D.1
**Problem observed:** MX86 = 0. Phase 4 Step D.1 instructs agents to run
`gh pr checks <PR-number>` to re-check CI after pushing remediations to the isolated
branch. This command returns CI for the PR head branch commit, not the isolated branch.
Agents using these instructions may report CI status as post-remediation when it is
actually pre-remediation. Additionally, Phase 4's "pending" note tells Phase 5 to
"wait or proceed with a conditional verdict" but Phase 5 had no scoring row for this.
**Change proposed:** In p4-remediate.md Step D.1, add a blockquote note after the
`gh pr checks` command explaining: (a) the command targets the PR head branch commit
not the isolated branch; (b) agents must record the data source in Step E; (c) if
the project runs CI on `dep-review/*` branches, check the isolated branch run directly.
Also update the "pending" bullet to cross-reference Phase 5's new "+2 pending" row
(added in H85).
**Targets:** Phase 4 CI Re-check Branch Scope Clarity (MX86): 0 → 100 (+100pp)
**Predicted improvement:** +100 weighted (1×)
**Pattern applied:** P18 — Cross-File Structural Anchor (clarifies the scope boundary
between the PR head branch and isolated branch, anchoring Step D.1's CI data to its
actual operational context)
**Risk level:** low
**Risk note:** Documentation-only change. No logic altered. The note cannot cause
incorrect behaviour — it only clarifies what the existing command returns.

---

### H85 — Add CI pending/unavailable scoring row to Phase 5 matrix
**Problem observed:** MX87 = 0. Phase 4 Step D.1 explicitly names "not yet complete
(pending)" as a valid CI re-check state and tells Phase 5 to "wait or proceed with a
conditional verdict." Phase 5 has no scoring row for this state — agents must improvise
a score contribution for pending CI, producing inconsistent risk assessments.
**Change proposed:** In p5-verdict.md scoring matrix, add a new row: "CI was failing
at Phase 1; re-check result pending or unavailable at Phase 5 time: +2". Add a note
block explaining that +2 is a precautionary mid-point and that the +4 or +1 unresolved
signals should not be applied simultaneously — re-score with the appropriate row once
the final CI result is known.
**Targets:** Phase 5 CI Pending Scoring Coverage (MX87): 0 → 100 (+100pp)
**Predicted improvement:** +100 weighted (1×)
**Pattern applied:** P6 — Symmetric Outcome Thresholds (extends the CI scoring block
to cover all named output states of the Phase 4 re-check: resolved, unresolved, and
pending)
**Risk level:** low
**Risk note:** +2 is intentionally conservative — lower than the confirmed-failure
signals (+4/+1), higher than resolved (0). It biases toward caution, which is the
preferred failure mode for a security-focused skill.

---

### H86 — Add explicit push_failed row instruction to Phase 7 Step B alias table
**Problem observed:** MX88 = 0. Phase 7 Step B's template shows the format for a
`push_failed` alias row (`| \`<alias>\` | — | **Not reviewed — isolated branch push
failed** |`) but no prose instruction states when to include it. Agents must infer
the inclusion rule from the template format alone, which is fragile under context
pressure or summarisation.
**Change proposed:** In p7-summary.md Step B, add two explicit bullet points before
the alias table template: one for standard verdict rows and one for `push_failed: true`
rows, each stating its trigger condition clearly.
**Targets:** Phase 7 push_failed Row Instruction Explicitness (MX88): 0 → 100 (+100pp)
**Predicted improvement:** +100 weighted (1×)
**Pattern applied:** P3 — Progressive Disclosure (adds an explicit conditional rule
before the template so agents have a stated trigger rather than a template-inferred one)
**Risk level:** low
**Risk note:** Purely additive prose. Does not change the template content.

---

### H87 — Fix Phase 8 Step G admonition to remove "merge conflict" as a skip reason
**Problem observed:** MX89 = 0. The admonition in Phase 8 Step G lists
"merge conflict / push failure / Phase 5 BLOCK / unverified" as possible skip reasons.
Phase 8 Step B (as of H83's fix) resolves merge conflicts by accepting both sets of
changes — it does not skip conflict-producing merges. "merge conflict" is therefore
not a valid skip reason; including it misleads agents into prescribing a "resolve the
conflict" action for a scenario that the pipeline already handles automatically.
**Change proposed:** In p8-consolidate.md Step G, update the admonition's Reason
column to `<push_failed: true / Phase 5 BLOCK / unverified>` and remove the
"Merge conflict" next-steps bullet. Update the "Push failure" bullet to reference
the specific `push_failed: true` flag and Phase 1b Step I for resolution context.
Also update the "Skipped Alias Groups" label to mention `push_failed: true` as a
skip reason alongside BLOCK and unverified.
**Targets:** Phase 8 Step G Admonition Skip-Reason Accuracy (MX89): 0 → 100 (+100pp)
**Predicted improvement:** +100 weighted (1×)
**Pattern applied:** P12 — Content Synchronisation Audit (aligns the admonition's
enumerated states with the actual skip conditions in Step B, closing the intra-file
inconsistency introduced when H81 added the admonition in Run 021)
**Risk level:** low
**Risk note:** Text-only change to an informational admonition. Does not alter
pipeline logic.

---

### Self-Audit (Keeper)
1. **Intent check:** H83 targets MX85 (0) ✓; H84 targets MX86 (0) ✓; H85 targets
   MX87 (0) ✓; H86 targets MX88 (0) ✓; H87 targets MX89 (0) ✓.
2. **Coverage check:**
   - H83–H87: +100 each (5×) = +500 weighted
   - Total predicted gain: +500
   - Projected: (~11,425 + 500) / 13,000 = ~11,925 / 13,000 = **~91.7%** < 95%
   - Below 95%. Remaining moonshots: MX34, MX38, MX43, MX49, MX78 (all architectural
     or observability-gap moonshots; no tractable hypothesis). No non-moonshot metric
     below 80 without a hypothesis. ✓
3. **Gap fill:** All non-moonshot metrics below 100 covered. ✓

H83 and H87 both modify p8-consolidate.md — run H83 first, H87 second.

### Recommendation Brief

1. **Add a push_failed guard to Phase 8's merge loop** — Phase 8 currently attempts to merge any alias without checking whether the isolated branch exists; a push_failed entry from Phase 1b will trigger a hard git error mid-consolidation.
2. **Clarify Phase 4's CI re-check scope** — `gh pr checks` targets the PR head branch, not the isolated branch; agents need to know the data is pre-remediation and record the source.
3. **Add a CI pending row to Phase 5's scoring matrix** — Phase 4 documents "pending" as a valid re-check outcome but Phase 5 has no prescribed score for it.
4. **Add explicit push_failed row trigger to Phase 7** — the alias table template shows the row format but doesn't tell agents when to use it.
5. **Fix the Phase 8 consolidation summary admonition** — "merge conflict" is listed as a skip reason but conflicts are always resolved; the admonition prescribes an unnecessary manual action.

---

## Phase 4 — Experiments

Re-read Phase 3 — approved hypotheses: H83, H84, H85, H86, H87.
File overlap: H83 and H87 both modify p8-consolidate.md — run H83 first.
Execution order: H83 → H87 → H85 → H84 → H86.

---

### H83 — Add push_failed: true guard to Phase 8 Step B

**Change applied** to `p8-consolidate.md` Step B:
- Inserted new step 1: "Check for a failed branch push. If `push_failed: true`, skip
  immediately — the branch does not exist on the remote and cannot be merged."
- Renumbered old steps 1→2, 2→3, 3→4, 4→5.

**MX85 re-check:** Phase 8 Step B now has an explicit `push_failed: true` check as
the first step in the merge loop. Raw: 1/1. **Score: 0 → 100 ✓**

---

### H87 — Fix Phase 8 Step G admonition skip-reason accuracy

**Change applied** to `p8-consolidate.md` Step G:
- Updated "Skipped Alias Groups" label to mention `push_failed: true` alongside BLOCK
  and unverified.
- Changed Reason column from `<merge conflict / push failure / Phase 5 BLOCK /
  unverified>` to `<push_failed: true / Phase 5 BLOCK / unverified>`.
- Removed "Merge conflict" next-steps bullet.
- Updated "Push failure" bullet to reference `push_failed: true` flag and Phase 1b
  Step I.

**MX89 re-check:** Admonition now lists only valid skip reasons (push_failed: true,
Phase 5 BLOCK, unverified). "merge conflict" removed. Raw: 3/3 valid. **Score: 0 → 100 ✓**

---

### H85 — Add CI pending/unavailable scoring row to Phase 5 matrix

**Change applied** to `p5-verdict.md` scoring matrix:
- Added new row: `| CI was failing at Phase 1; re-check result pending or unavailable
  at Phase 5 time | +2 |` between the "+1 test environment" and "CI passing (0)" rows.
- Added a "Note on CI pending" blockquote explaining +2 as a precautionary mid-point
  and the instruction not to simultaneously apply +4 or +1 unresolved signals.

**MX87 re-check:** Scoring matrix now has a row for pending/unavailable CI. Raw: 1/1.
**Score: 0 → 100 ✓**

---

### H84 — Add CI re-check scope note to Phase 4 Step D.1

**Change applied** to `p4-remediate.md` Step D.1:
- Added blockquote note after the `gh pr checks` command explaining: `gh pr checks`
  targets the PR head branch commit (pre-remediation), not the isolated branch;
  agents must record the data source ("PR head branch CI" or "isolated branch CI")
  in Step E's CI Status After Remediation table.
- Updated the "pending" bullet to cross-reference Phase 5's new "+2 pending" row
  rather than telling Phase 5 to "wait or proceed with a conditional verdict."

**MX86 re-check:** Step D.1 now has a note clarifying the scope of `gh pr checks`.
Raw: 1/1. **Score: 0 → 100 ✓**

---

### H86 — Add explicit push_failed row instruction to Phase 7 Step B

**Change applied** to `p7-summary.md` Step B:
- Added two bullet points before the alias table template:
  - "For each alias where Phase 5 produced a verdict: add a standard row."
  - "For each alias with `push_failed: true` (Phase 5 never ran): add a row with `—`
    in Old → New and `Not reviewed — isolated branch push failed` as the verdict."

**MX88 re-check:** Step B now has explicit prose instructing when to include
`push_failed` rows. Raw: 1/1. **Score: 0 → 100 ✓**

---

### Post-Experiment Composite

```
Inherited weighted sum:  ~11,425 (125×)
New metrics post-scores: 100 + 100 + 100 + 100 + 100 = 500 (5×)
Total: ~11,925 / 13,000 (130×)

Composite: ~11,925 / 13,000 × 100 = ~91.7%
```

---

## Phase 5 — Report

### Run Summary

| Field | Value |
|---|---|
| Run | 022 |
| Date | 2026-04-20 |
| Target | `skills/bump-dependencies/` |
| Hypotheses tested | 5 (H83–H87) |
| Confirmed | 5 |
| Disconfirmed | 0 |
| Composite movement | 87.9% → 91.7% (+3.8 pp) |
| Version bump | 4.14.0 → 4.15.0 (minor) |

### Confirmed Hypotheses

| ID | Change | Metric | Gain |
|---|---|---|---|
| H83 | Phase 8 Step B push_failed guard | MX85: 0→100 | +100 |
| H84 | Phase 4 Step D.1 CI scope note | MX86: 0→100 | +100 |
| H85 | Phase 5 CI pending scoring row | MX87: 0→100 | +100 |
| H86 | Phase 7 push_failed row instruction | MX88: 0→100 | +100 |
| H87 | Phase 8 Step G admonition accuracy | MX89: 0→100 | +100 |

### Novel Patterns Discovered
None. H83 applied P10, H84 applied P18, H85 applied P6, H86 applied P3,
H87 applied P12. All patterns are existing seed patterns.

### Moonshot Status
MX34, MX38, MX43, MX49, MX78 remain at 0 — architectural scope, no tractable
hypothesis. No change to moonshot list.

### Next-Run Candidates
No non-moonshot metrics currently below 100. The skill is at 91.7% composite.
Further gains require either moonshot architectural changes (cross-dependency
correlation, cross-run deduplication) or discovery of new instruction gaps in
future reads. A fresh full-audit read of all 11 command files is recommended
for the next run.
