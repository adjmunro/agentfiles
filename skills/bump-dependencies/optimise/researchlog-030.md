<!-- SUMMARY-START -->
## Run 030 — 2026-04-22 | Target: skills/bump-dependencies/

Composite: 91.4% → 93.9% (+2.5 pp)

### Hypotheses
| ID   | Description | Outcome |
|------|-------------|---------|
| H122 | Fix duplicate step number in Phase 8 Step B (merge step renumbered 3→4) | Confirmed |
| H123 | Add local branch cleanup to Phase 0 Step H existing-PR path | Confirmed |
| H124 | Add CI data-source provenance note to Phase 5 verdict block template | Confirmed |
| H125 | Add Phase 4 scope exclusion to Phase 5 "+2 CI pending" note | Confirmed |

### Metric Snapshot
| Metric | Baseline | Post |
|--------|----------|------|
| Phase 8 Step B Item Numbering Integrity (MX125) | 0 | 100 |
| Phase 0 Orphaned Local Branch Cleanup (MX126) | 0 | 100 |
| Phase 5 CI Data-Source Provenance in Verdict (MX127) | 0 | 100 |
| Phase 5 CI-Pending Row Scope Disambiguation (MX128) | 0 | 100 |
| Git Branch Lifecycle Completeness (MX129) | 67 | 100 |
| Composite | 91.4% | 93.9% |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

**Target:** `skills/bump-dependencies/`
**Files:** 44 total (11 command, 4 support, 29 optimise logs)
**Token estimate:** ~21,000 tokens (instruction files only)

### Cross-Run Context (from researchlog-029.md)
Previous composite: 90.7% → 93.7% (+3.0pp, 140 metrics, 170×)
H118–H121: all Confirmed — excluded from this run.
H1–H121: all confirmed or disconfirmed across runs 001–029. Excluded from this run.

Run 029 targeted: Phase 4 Step D.1 partially-pending re-check coverage (H118), Phase 5
partially-pending CI signal (H119), Phase 8 Step E.1 exclusion table (H120), Phase 5
multi-version span enumeration-failure signal (H121). All 4 confirmed.

### Feature Inventory
Unchanged from prior runs.
- Multi-phase pipeline: yes
- Persona system: yes (Ink, Echo, Rook, Arden)
- Subagent invocations: yes (Wave 1, Wave 3)
- Multi-session orchestration: yes
- Parallel execution: yes
- Cached artifacts: yes

### Persona Staleness Check
All 4 personas confirmed present. No broken references.

### Excluded from this run
H1–H121: all confirmed or disconfirmed across runs 001–029.

### Files
Command (11): bump-dependencies.md, p0-bump.md, p1-parse.md, p1b-split-commits.md,
  p2-investigate.md, p3-impact.md, p4-remediate.md, p5-verdict.md, p6-comment.md,
  p7-summary.md, p8-consolidate.md
Support (4): SKILL.md, AGENTS.md, VERSION.md, CHANGELOG.md
Optimise logs (29): researchlog-001 through researchlog-029

### Structural Gaps Identified

1. **Phase 8 Step B duplicate item "3."**: Run 028 (H114) added an absent-verdict guard as
   item 3 in Phase 8 Step B without renumbering the existing items. The step list now reads
   1, 2, 3 (absent-verdict check), 3 (merge step), 4 (conflict resolution), 5 (record).
   The merge step — the primary action of the loop — shares its number with the immediately
   preceding guard check.

2. **Phase 0 Step H orphaned local branch**: When the user chooses to resume an existing PR,
   the code deletes the remote BUMP_BRANCH (`git push origin --delete`) and checks out the base
   branch, but never runs `git branch -D <BUMP_BRANCH>`. Repeated daily runs produce an
   accumulating set of orphaned local `deps/auto-bump-<date>` branches.

3. **Phase 5 verdict block lacks CI data-source provenance**: Phase 4 Step D.1 (updated by
   H84, Run 022) notes that `gh pr checks` returns CI status for the PR head branch
   (pre-remediation), not the isolated branch, and instructs the agent to record the data
   source in the Remediation Summary. However, Phase 5 Step C's verdict block template
   (`#### CI Status`) has no corresponding instruction to disclose the data-source scope to
   the human reviewer in the generated PR comment.

4. **Phase 5 "+2 CI pending" note scope ambiguity**: The "Note on CI pending" block states
   the +2 signal applies "when Phase 4 Step D.1 recorded the CI re-check as 'not yet complete
   (pending)' OR when the re-check could not be performed." The phrase "re-check could not be
   performed" is technically satisfied when Phase 4 was not triggered at all — but that case
   should apply the +1 precautionary partially-pending row, not +2. The disambiguation is
   handled by the adjacent "Note on partially-pending Phase 1 CI" (added by H119, Run 029),
   but the "+2" note itself still lacks an explicit Phase 4 scope exclusion.

---

## Phase 2 — Baseline

### Inherited Metrics
All 140 metrics from Run 029 carry forward at post-experiment values.
Inherited weighted sum: ~15,925 (170×)
(Run 029 post composite: 93.7%)

### Custom Metric Discovery — New Metrics (MX125–MX129)

Prior run log check: MX1–MX124 defined across runs 001–029. MX125+ available.

---

#### MX125 — Phase 8 Step B Item Numbering Integrity (BINI) [custom]

**Measures:** Whether the numbered items in Phase 8 Step B use unique, non-duplicate
step numbers throughout the list.
**Why seeds miss it:** No seed metric measures document-level formatting errors in
numbered lists. M3 (IAR) measures ambiguity in instruction wording; M6 (ACC) measures
concreteness of acceptance criteria. Neither detects a structural navigation error where
two adjacent steps share the same number, causing an agent to conflate or skip the
duplicate-numbered step.
**Methodology:** Inspect p8-consolidate.md Step B. Count distinct step numbers and total
steps. Current state: items 1, 2, 3 (absent-verdict), 3 (merge), 4, 5 — the number 3
appears twice. Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** unique_numbering_present × 100
**Score: 0**

---

#### MX126 — Phase 0 Orphaned Local Branch Cleanup (OLBC) [custom]

**Measures:** Whether Phase 0 Step H's "user chooses existing PR" path includes an
instruction to delete BUMP_BRANCH locally (not just remotely) before proceeding.
**Why seeds miss it:** No seed metric measures branch lifecycle completeness — specifically,
whether every branch created by the skill has delete instructions covering both remote and
local in every exit path. M8 (HTC) counts human touchpoints; M11 (PSS) measures parallel
mutation safety. Neither covers branch cleanup completeness.
**Methodology:** Inspect p0-bump.md Step H, "If the user chooses the existing PR" block.
Check whether `git branch -D <BUMP_BRANCH>` (or equivalent) appears alongside `git push
origin --delete <BUMP_BRANCH>`. Current state: remote delete present; local delete absent. Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** local_cleanup_present × 100
**Score: 0**

---

#### MX127 — Phase 5 CI Data-Source Provenance in Verdict (CDSP) [custom]

**Measures:** Whether Phase 5 Step C's verdict block template instructs the agent to
disclose the CI data-source scope (PR head branch vs. isolated branch) when reporting
CI status in the generated PR comment.
**Why seeds miss it:** M6 (ACC) measures concreteness of acceptance criteria. No seed metric
measures whether AI-generated output blocks include provenance disclosure instructions when
the underlying data source is counter-intuitive. Phase 4 records the data source internally
(per H84, Run 022) but Phase 5 has no instruction to surface it to the human reviewer.
**Methodology:** Inspect p5-verdict.md Step C verdict block template, `#### CI Status`
section (lines 251–254). Check for an instruction to note the CI data-source when Phase 4
Step D.1 used PR head branch data. Current state: format line lists four options with no
provenance note. Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** provenance_instruction_present × 100
**Score: 0**

---

#### MX128 — Phase 5 CI-Pending "+2" Row Scope Disambiguation (PRSD) [custom]

**Measures:** Whether the "Note on CI pending" block for the "+2 pending" scoring row
includes an explicit clause stating it applies only when Phase 4 ran for this alias.
**Why seeds miss it:** M3 (IAR) measures ambiguity via weak modal verbs. The ambiguity
here is a logical-scope gap: the note's "re-check could not be performed" clause is
technically true when Phase 4 was not triggered, but that case should apply the +1
precautionary row, not +2. The adjacent "Note on partially-pending Phase 1 CI" (H119,
Run 029) provides disambiguation at the row level, but the "+2" note itself lacks the
exclusion. No seed metric measures whether Note blocks are scoped precisely enough to
prevent cross-row application errors.
**Methodology:** Inspect p5-verdict.md "Note on CI pending" block (lines 95–100). Check
for explicit language limiting the note to cases where "Phase 4 ran" or excluding
"Phase 4 was not triggered." Current state: no such exclusion clause. Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** exclusion_clause_present × 100
**Score: 0**

---

#### MX129 — Git Branch Lifecycle Completeness (GBLC) [custom, moonshot]

**Measures:** For every git branch the skill creates, whether every exit path from that
branch's use includes both remote AND local delete instructions. Borrows the
"garbage collection completeness" concept from memory management: every allocated resource
must be freed on every exit path — not just the happy path.
**Why seeds miss it:** No seed metric measures resource lifecycle completeness across all
exit paths. M11 (PSS) measures concurrency safety of mutations; M8 (HTC) counts human
touchpoints. Neither applies the "all exit paths must clean up" invariant from memory
management to git branch resources.
**Methodology:** Enumerate all git branches created by the skill. For each, check whether
every exit path includes both `git push origin --delete` (remote) and `git branch -D`
(local):
- BUMP_BRANCH (created P0 Step B):
  - Normal path (new PR, PR head branch is BUMP_BRANCH): P8 Step F deletes local + remote
    preserved as PR head → intentional, correct ✓
  - Existing PR path: remote deleted (Step H), local NOT deleted ✗
- Isolated branches (dep-review/<PR>/<alias>): P8 Step F deletes both remote and local ✓
- Local PR head checkout: P8 Step F deletes local; remote preserved (intentional) ✓
Score per branch lifecycle: BUMP_BRANCH = 0.5 (one exit path missing local delete),
  isolated branches = 1.0, PR head = 1.0. Average: (0.5 + 1.0 + 1.0) / 3 = 0.83.
**Raw: 0.83.** **Normalised: 83.**
**Direction:** ↑ higher is better
**Weight:** 1× (moonshot — informational)
**Normalisation:** avg_branch_lifecycle_score × 100

---

### New Metric Scores

| Metric | Raw | Normalised | Weight | Weighted |
|---|---|---|---|---|
| Phase 8 Step B Item Numbering Integrity (MX125) | 0/1 | 0 | 1× | 0 |
| Phase 0 Orphaned Local Branch Cleanup (MX126) | 0/1 | 0 | 1× | 0 |
| Phase 5 CI Data-Source Provenance in Verdict (MX127) | 0/1 | 0 | 1× | 0 |
| Phase 5 CI-Pending Row Scope Disambiguation (MX128) | 0/1 | 0 | 1× | 0 |
| Git Branch Lifecycle Completeness (MX129) | 0.83 | 83 | 1× | 83 |

### Full Composite (145 metrics)

```
Inherited weighted sum: ~15,925 (170×)
New metrics weighted sum: 0+0+0+0+83 = 83 (5×)
Total: ~16,008 / 17,500 (175×)

Composite: ~16,008 / 17,500 × 100 = ~91.5%
```

*(Drop of 2.2pp from scope expansion: 5 new weight units, four at 0, one at 83.)*

### Weakest Metrics (Phase 3 candidates)
1. MX125 — Phase 8 Step B Item Numbering Integrity: 0 (1×)
2. MX126 — Phase 0 Orphaned Local Branch Cleanup: 0 (1×)
3. MX127 — Phase 5 CI Data-Source Provenance in Verdict: 0 (1×)
4. MX128 — Phase 5 CI-Pending Row Scope Disambiguation: 0 (1×)
5. MX129 — Git Branch Lifecycle Completeness: 83 (moonshot — MX126 fix will bring to 100)

---

## Phase 3 — Hypotheses

### Step 0 — Pre-Experiment Dependency Scan

- H122 → p8-consolidate.md (Step B numbering)
- H123 → p0-bump.md (Step H existing-PR block)
- H124 → p5-verdict.md (Step C verdict block template)
- H125 → p5-verdict.md (Note on CI pending)

Overlaps: H124 and H125 both modify p5-verdict.md — run sequentially with re-check between.
All other hypotheses are independent.

Execution order: H122 → H123 → H124 → H125.

---

### H122 — Fix duplicate step number in Phase 8 Step B

**Problem observed:** MX125 = 0. Phase 8 Step B has items 1, 2, 3 (absent-verdict check),
3 (merge step), 4 (conflict resolution), 5 (record result). The merge step — the primary
action of the loop body — shares the number "3." with the absent-verdict guard immediately
above it. Run 028 (H114) added the absent-verdict check as item 3 without renumbering the
existing merge step. An agent reading sequentially encounters "3." twice and may conflate the
guard with the merge action.
**Change proposed:** In p8-consolidate.md Step B, renumber:
- Second "3." (merge step) → "4."
- "4." (conflict resolution) → "5."
- "5." (record result) → "6."
**Targets:** Phase 8 Step B Item Numbering Integrity (MX125): 0 → 100 (+100pp)
**Predicted improvement:** MX125 +100pp (1× = +100 weighted)
**Pattern applied:** Novel — "Step Numbering Integrity" (numbered step lists in phase files
must use unique, sequential, non-duplicate numbers; a duplicated number introduced when
a new step is inserted must trigger renumbering of all subsequent items)
**Risk level:** low
**Risk note:** Pure renumbering — no logic change. No cross-file references to specific
step numbers within Phase 8 Step B.

---

### H123 — Add local branch cleanup to Phase 0 Step H existing-PR path

**Problem observed:** MX126 = 0, MX129 = 83. Phase 0 Step H's existing-PR path deletes
the remote BUMP_BRANCH and checks out the base branch, but leaves the local branch. Each
daily proactive run creates a `deps/auto-bump-<date>` branch; when the user repeatedly
chooses to resume an existing PR, orphaned local branches accumulate.
**Change proposed:** In p0-bump.md Step H, existing-PR block, add:
`git branch -D <BUMP_BRANCH> 2>/dev/null || true`
immediately after `git checkout <base-branch>`.
**Targets:**
- Phase 0 Orphaned Local Branch Cleanup (MX126): 0 → 100 (+100pp)
- Git Branch Lifecycle Completeness (MX129): 83 → 100 (+17pp)
**Predicted improvement:** MX126 +100pp (1× = +100 weighted); MX129 +17pp (1× = +17 weighted)
**Pattern applied:** Novel — "Branch Lifecycle Completeness" (every branch created by a
skill must have delete instructions covering both remote and local in every exit path where
the branch is no longer needed; guarded with `2>/dev/null || true` for safety)
**Risk level:** low
**Risk note:** Additive instruction. The guard prevents errors if the branch was already
deleted or does not exist locally.

---

### H124 — Add CI data-source provenance note to Phase 5 verdict block

**Problem observed:** MX127 = 0. Phase 4 Step D.1 records whether its CI re-check used PR
head branch data (pre-remediation) vs. isolated branch data. But Phase 5 Step C's verdict
block template (`#### CI Status`) has no instruction to surface this to the human reviewer.
A reviewer reading "CI is still failing" in the PR comment cannot tell whether the check
reflects the pre-remediation state — where the fix has already been applied but CI hasn't
re-run on the new commits yet.
**Change proposed:** In p5-verdict.md Step C, add a note after the `#### CI Status` format
line instructing the agent: if Phase 4 Step D.1 recorded "PR head branch CI" as the data
source, append to the CI Status value: "(Note: re-check was on the PR head branch — this
reflects the pre-remediation state. Post-remediation CI will be confirmed during Phase 8
integration tests.)"
**Targets:** Phase 5 CI Data-Source Provenance in Verdict (MX127): 0 → 100 (+100pp)
**Predicted improvement:** MX127 +100pp (1× = +100 weighted)
**Pattern applied:** Novel — "Data Source Provenance Disclosure" (when an output block
surfaces data from a source that may surprise the reader, the template must include
guidance to append a provenance note stating the source and its scope limitations)
**Risk level:** low
**Risk note:** Additive note within the verdict block template. Does not alter scoring logic.

---

### H125 — Add Phase 4 scope exclusion to Phase 5 "+2 CI pending" note

**Problem observed:** MX128 = 0. The "Note on CI pending" block states the +2 signal
applies "when Phase 4 Step D.1 recorded the CI re-check as 'not yet complete (pending)'
OR when the re-check could not be performed." "Re-check could not be performed" is
technically true when Phase 4 was not triggered at all — yet that case should apply the
+1 precautionary partially-pending row, not +2. The adjacent "Note on partially-pending
Phase 1 CI" (H119, Run 029) provides the correct routing for that case, but the "+2"
note itself lacks an explicit "Phase 4 must have run" scope exclusion.
**Change proposed:** Append to p5-verdict.md "Note on CI pending": "This note applies
only when Phase 4 ran for this alias (it was triggered by actionable usages or CI
failures). If Phase 4 was not triggered, apply the '+1 precautionary' partially-pending
row instead — not +2."
**Targets:** Phase 5 CI-Pending Row Scope Disambiguation (MX128): 0 → 100 (+100pp)
**Predicted improvement:** MX128 +100pp (1× = +100 weighted)
**Pattern applied:** P7 — Binary Applicability Gates (ambiguous scope condition "re-check
could not be performed" replaced with a deterministic binary gate: "did Phase 4 run for
this alias?")
**Risk level:** low
**Risk note:** Additive exclusion clause. The +2 signal and its application are unchanged;
only its applicability scope is made explicit.

---

### Self-Audit

1. **Intent check:**
   - H122 → MX125 (0 < 100) ✓
   - H123 → MX126 (0 < 100), MX129 (83 < 100) ✓
   - H124 → MX127 (0 < 100) ✓
   - H125 → MX128 (0 < 100) ✓

2. **Coverage check:**
   - Baseline weighted sum: ~16,008 (175×)
   - H122: +100; H123: +100+17=+117; H124: +100; H125: +100 → total +417
   - Projected: (~16,008 + 417) / 17,500 = ~16,425 / 17,500 = **~93.9%** < 95%
   - Below 95%. Check uncovered gaps:
     - MX129 now 100 after H123 ✓
     - Moonshots at 0 (MX78, MX49, MX43, MX38, MX34): architectural, no tractable fix ✓
     - PEV (~56): H122 and H123 apply novel patterns; won't promote to seeds this run ✓
     - No non-moonshot metric below 80 lacks a hypothesis after H122–H125 ✓

3. **Gap fill:** all four zero-scoring non-moonshot metrics covered. ✓

### Recommendation Brief

1. **Fix duplicate step number in Phase 8 Step B** — the merge step (primary loop action)
   and the absent-verdict guard both carry the number "3.", introduced when Run 028 inserted
   the absent-verdict check without renumbering subsequent steps.
2. **Clean up the local BUMP_BRANCH when resuming an existing PR** — the skill deletes the
   remote branch but leaves an orphaned local branch from each daily run.
3. **Disclose CI re-check data source in Phase 5 verdict comment** — when Phase 4's re-check
   used PR head branch data (pre-remediation), the verdict block should note this so reviewers
   know the failing CI check may not reflect the fixed state.
4. **Restrict the "+2 CI pending" scoring note to cases where Phase 4 ran** — the current
   phrasing "re-check could not be performed" is true even when Phase 4 was never triggered,
   which should use the +1 precautionary row instead.

---

## Phase 4 — Experiments

### Step 0 — Pre-Experiment Dependency Scan
H122 → p8-consolidate.md. H123 → p0-bump.md. H124 and H125 → p5-verdict.md (sequential).
Execution order: H122 → H123 → H124 → H125.

---

### H122 — Fix duplicate step number in Phase 8 Step B

**Pre-change:** MX125 = 0 (two items numbered "3." in Step B)

*(p8-consolidate.md Step B renumbered — see file edits)*

**Post-change:** Step B now reads 1, 2, 3 (absent-verdict), 4 (merge), 5 (conflict), 6 (record).
- MX125: 100 (+100pp)

**Delta:** MX125 +100pp
**Secondary deltas:** M3 IAR — no new ambiguity introduced. No degradation.
**Result:** confirmed
**Notes:** Novel pattern — "Step Numbering Integrity." When a new step is inserted into
a numbered list, all subsequent items must be renumbered.

---

### H123 — Add local branch cleanup to Phase 0 Step H existing-PR path

**Pre-change:** MX126 = 0, MX129 = 83 (BUMP_BRANCH local cleanup missing in existing-PR path)

*(p0-bump.md Step H existing-PR block amended — see file edits)*

**Post-change:** `git branch -D <BUMP_BRANCH> 2>/dev/null || true` added after
`git checkout <base-branch>` in the existing-PR path. Every exit path for BUMP_BRANCH
now has both remote and local delete instructions.
- MX126: 100 (+100pp)
- MX129: 100 (+17pp) — BUMP_BRANCH lifecycle now complete across all exit paths

**Delta:** MX126 +100pp, MX129 +17pp
**Secondary deltas:** RPC re-checked — existing-PR exit path now has a complete branch
lifecycle. Positive. No degradation.
**Result:** confirmed
**Notes:** Novel pattern — "Branch Lifecycle Completeness."

---

### H124 — Add CI data-source provenance note to Phase 5 verdict block

**Pre-change:** MX127 = 0 (no provenance note in verdict block CI Status section)

*(p5-verdict.md Step C amended — see file edits)*

**Post-change:** After the `#### CI Status` format line, a note instructs the agent to
append a provenance parenthetical when Phase 4 Step D.1 used PR head branch CI data.
- MX127: 100 (+100pp)

**Delta:** MX127 +100pp
**Secondary deltas:** M6 ACC re-checked — the CI Status section now has a concrete
condition determining when the provenance note is added. Positive. No degradation.
**Result:** confirmed
**Notes:** Novel pattern — "Data Source Provenance Disclosure."

---

### H125 — Add Phase 4 scope exclusion to Phase 5 "+2 CI pending" note

**Pre-change:** MX128 = 0 (no explicit Phase 4 scope exclusion in "+2 pending" note)

*(p5-verdict.md "Note on CI pending" amended — see file edits)*

**Post-change:** "Note on CI pending" now ends with: "This note applies only when Phase 4
ran for this alias. If Phase 4 was not triggered, apply the '+1 precautionary'
partially-pending row instead — not +2."
- MX128: 100 (+100pp)

**Delta:** MX128 +100pp
**Secondary deltas:** M3 IAR re-checked — the "+2 pending" note is now unambiguously scoped.
Positive. No degradation.
**Result:** confirmed
**Notes:** P7 (Binary Applicability Gates) applied.

---

## Experiment Summary (Run 030)
- Confirmed: H122, H123, H124, H125
- Partial: none
- Disconfirmed: none

---

## Phase 5 — Report

| Metric | Baseline | Post | Delta | Weight | Weighted Δ |
|---|---|---|---|---|---|
| All inherited metrics (140) | ~15,925 | ~15,925 | 0 | 170× | 0 |
| Phase 8 Step B Item Numbering Integrity (MX125) | 0 | 100 | +100 | 1× | +100 |
| Phase 0 Orphaned Local Branch Cleanup (MX126) | 0 | 100 | +100 | 1× | +100 |
| Phase 5 CI Data-Source Provenance in Verdict (MX127) | 0 | 100 | +100 | 1× | +100 |
| Phase 5 CI-Pending Row Scope Disambiguation (MX128) | 0 | 100 | +100 | 1× | +100 |
| Git Branch Lifecycle Completeness (MX129) | 83 | 100 | +17 | 1× | +17 |
| **TOTAL** | **~16,008** | **~16,425** | **+417** | **175×** | **+417** |

**Post-experiment composite: ~16,425 / 17,500 × 100 = ~93.9%**

### Composite History

| | Score | Metrics | Weight |
|---|---|---|---|
| Run 029 final | ~93.7% | 140 | 170× |
| Run 030 baseline | ~91.5% | 145 | 175× |
| **Run 030 final** | **~93.9%** | **145** | **175×** |

Delta this run: +2.4pp (all primary metrics exact; MX129 improvement is +17pp weighted).

### What improved and why
- **Phase 8 Step B Item Numbering Integrity (+100pp):** Step B now has unique sequential
  numbers — the merge step is "4.", conflict resolution is "5.", record result is "6."
  An agent reading the loop no longer encounters "3." twice.
- **Phase 0 Orphaned Local Branch Cleanup (+100pp):** The existing-PR exit path now
  includes `git branch -D <BUMP_BRANCH>` to clean up the local branch, preventing orphaned
  `deps/auto-bump-<date>` branches from accumulating on repeated daily runs.
- **Phase 5 CI Data-Source Provenance in Verdict (+100pp):** The verdict block template
  now instructs the agent to append a provenance note when the CI re-check data came from
  the PR head branch (pre-remediation state), giving human reviewers the context needed
  to correctly interpret a "CI still failing" report.
- **Phase 5 CI-Pending Row Scope Disambiguation (+100pp):** The "+2 CI pending" note now
  explicitly states it applies only when Phase 4 ran, preventing misapplication to cases
  where Phase 4 was not triggered and the +1 precautionary row should apply instead.
- **Git Branch Lifecycle Completeness (+17pp):** BUMP_BRANCH now has complete lifecycle
  coverage across all exit paths (MX126 fix brought the existing-PR path from incomplete
  to complete, raising the moonshot metric from 83 to 100).

### What was dropped
Nothing — all four hypotheses confirmed.

### What remains to improve
- Pattern Experimental Validation Rate (PEV): ~56 — dormant seed patterns (P5, P13, P14,
  P17) remain unvalidatable; novel patterns from this run (Step Numbering Integrity,
  Branch Lifecycle Completeness, Data Source Provenance Disclosure) are candidates for
  seed promotion. PEV increases when they are added to the seed library.
- Moonshots at 0 (MX78, MX49, MX43, MX38, MX34): architectural scope; no tractable
  single-run fix.

### Novel Pattern Candidates

## Novel Patterns Discovered — 2026-04-22

### NP4 — Step Numbering Integrity
**Discovered in:** skills/bump-dependencies/ (Phase 8 Step B)
**Problem it solved:** When H114 (Run 028) inserted an absent-verdict guard as item 3 in
Phase 8 Step B, the existing item 3 (merge step) was not renumbered, producing a duplicate
"3." An agent encountering the duplicate cannot determine which step 3 is the primary action.
**Implementation:** When a new step is inserted into a numbered list in a phase file, all
subsequent items must be renumbered to preserve unique sequential numbering. During review
of any phase file edit that inserts a numbered step, verify the full list is renumbered.
**Metrics it improved:** Phase 8 Step B Item Numbering Integrity (MX125)
**Generalises to:** Any multi-step phase file with numbered action lists. Particularly
relevant when steps are added by successive optimization runs without a full-list review.
**Seed candidate:** yes — a simple, verifiable invariant applicable to any phase file.

### NP5 — Branch Lifecycle Completeness
**Discovered in:** skills/bump-dependencies/ (Phase 0 Step H existing-PR path)
**Problem it solved:** The existing-PR path deleted the remote BUMP_BRANCH but left the
local branch, producing orphaned local branches from each daily run.
**Implementation:** For every git branch created by a phase, every exit path where the
branch is no longer needed must include both remote delete (`git push origin --delete
<branch> 2>/dev/null || true`) and local delete (`git branch -D <branch> 2>/dev/null || true`).
Exceptions: branches that intentionally persist (e.g., the PR head branch on the remote,
which is the PR body) are noted explicitly as "preserved — intentional."
**Metrics it improved:** Phase 0 Orphaned Local Branch Cleanup (MX126), Git Branch
Lifecycle Completeness (MX129)
**Generalises to:** Any skill that creates git branches — Phase 1b isolated branches,
Phase 0 BUMP_BRANCH, and any future git-workflow skill. Phase 8 Step F already implements
this pattern for isolated branches; this run extends it to BUMP_BRANCH.
**Seed candidate:** yes — a concrete, checkable invariant for git-workflow skills.

### NP6 — Data Source Provenance Disclosure
**Discovered in:** skills/bump-dependencies/ (Phase 5 verdict block, CI Status section)
**Problem it solved:** Phase 4 records whether its CI re-check used PR head branch data
(pre-remediation) vs. isolated branch data. Phase 5 had no instruction to surface this
limitation in the generated PR comment, leaving reviewers unable to correctly interpret
a "CI still failing" report when the failure reflects the pre-fix state.
**Implementation:** When an output block surfaces data from a source that may be
counter-intuitive to the reader (e.g., CI data from before a fix was applied), the
template for that block must include guidance to append a provenance note: what data
source was used and why the result may differ from what the reader expects.
**Metrics it improved:** Phase 5 CI Data-Source Provenance in Verdict (MX127)
**Generalises to:** Any skill that generates reports referencing data whose source is
non-obvious — cached API responses, CI data from a branch that predates a fix, test
results from a stale snapshot. The note should state both the source and the mismatch risk.
**Seed candidate:** yes — provenance disclosure is a general output-quality pattern for
any reporting skill where the data source is non-obvious.
