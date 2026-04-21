<!-- SUMMARY-START -->
## Run 024 — 2026-04-21 | Target: skills/bump-dependencies/

Composite: 88.8% → 92.4% (+3.6 pp)

### Hypotheses
| ID  | Description                                                                              | Outcome   |
|-----|------------------------------------------------------------------------------------------|-----------|
| H93 | Add non-interactive default to Phase 0 Step H existing-PR block                         | Confirmed |
| H94 | Add version downgrade row to Phase 5 scoring matrix                                     | Confirmed |
| H95 | Add `git reset --hard` failure handling to Phase 8 Step A                               | Confirmed |
| H96 | Add ecosystem-to-function routing rule to Phase 0 Step D batch script                   | Confirmed |
| H97 | Add version enumeration terminal fallback to Phase 2 Pass A                             | Confirmed |

### Metric Snapshot
| Metric                                                              | Baseline | Post |
|---------------------------------------------------------------------|----------|------|
| Phase 0 Step H Non-Interactive Default (MX95)                       | 0        | 100  |
| Phase 5 Downgrade Scoring Coverage (MX96)                           | 0        | 100  |
| Phase 8 Step A Reset Error Handling (MX97)                          | 0        | 100  |
| Phase 0 Batch Script Ecosystem Routing Rule (MX98)                  | 0        | 100  |
| Phase 1b Step D Non-Interactive Clarity (MX99)                      | 100      | 100  |
| Phase 2 Pass A Version Enumeration Fallback (MX100)                 | 0        | 100  |
| Composite                                                           | 88.8%    | 92.4%|
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

**Target:** `skills/bump-dependencies/`
**Files:** 38 total (11 command, 4 support, 23 optimise logs)
**Token estimate:** ~22,000 tokens (instruction files only)

### Cross-Run Context (from researchlog-023.md)
Previous composite: 88.3% → 92.0% (+3.7pp, 111 metrics, 135×)
H88–H92: all Confirmed — excluded from this run.
Moonshots: MX34, MX38, MX43, MX49, MX78 — architectural scope, unchanged.

Run 023 recommended a targeted re-read of Phase 0 and Phase 2 edge cases.
This run performs a fresh full-audit read of all 11 command files.

### Feature Inventory
- Multi-phase pipeline: yes (11 phases)
- Persona system: yes (Ink, Echo, Rook, Arden — 4 personas)
- Subagent invocations: yes (Wave 1 and Wave 3 — parallel per-alias agents)
- Multi-session orchestration: yes (/tmp session brief + consolidation summary)
- Parallel execution: yes (Wave 1 and Wave 3 concurrent per-alias agents)
- Cached artifacts: yes (session brief, manifest, consolidation summary)

### Persona Staleness Check
All 4 personas confirmed present and current per Run 023. No broken references.

### Excluded from this run
H1–H92: all confirmed or disconfirmed across runs 001–023. See respective run logs.

### Files
Command (11): bump-dependencies.md, p0-bump.md, p1-parse.md, p1b-split-commits.md,
  p2-investigate.md, p3-impact.md, p4-remediate.md, p5-verdict.md, p6-comment.md,
  p7-summary.md, p8-consolidate.md
Support (4): SKILL.md, AGENTS.md, VERSION.md, CHANGELOG.md
Optimise logs (23): researchlog-001 through researchlog-023

### Structural Gaps Identified During Fresh Full Audit

1. **Phase 0 Step H: no default for non-responsive user when existing proactive PR found.**
   Step H detects an existing proactive bump PR and asks "Proceed to create a new PR for
   today, or resume the existing one?" It handles "If the user chooses the existing PR" and
   "If the user chooses to create a new PR" — but has no else branch for the case where the
   session is non-interactive (sub-agent, CI context) or the user does not respond. Phase 1b
   Step D has an equivalent pattern and handles it explicitly with "If there is no interactive
   channel… proceed immediately." Phase 0 Step H is missing this clause entirely.

2. **Phase 1b Step D: no skip path when the non-interactive clause fires and the PR is
   already single-alias (splitting is vacuously not needed but Step D still runs).**
   The "proceed immediately" non-interactive clause could cause an agent to commit to a
   split plan for a PR that has only one alias. The confusion arises because Step D is only
   reached if Step C determined that at least one non-atomic commit exists — but in edge cases
   (single alias, already atomic, but still reaching Step D due to spec ambiguity), the
   "proceed immediately" path lacks a sanity check. This is a lower-priority gap since Step C
   would normally prevent reaching Step D for already-atomic commits.

3. **Phase 5 scoring matrix: no row for version downgrades.**
   Phase 1 Step D explicitly identifies `downgrade` as a change type alongside `upgrade`,
   `new addition`, and `removal`. Phase 5's scoring matrix has rows for major/minor/patch
   bumps but no row for the case where `change_type = downgrade`. An agent scoring a
   downgrade has no prescribed signal — it would improvise (likely applying 0 points, treating
   it as a patch, or applying the major/minor/patch row for the magnitude of the downward jump).
   The correct signal is unclear but the absence of a rule is a definite gap.

4. **Phase 8 Step A: no error handling for `git reset --hard` leaving a conflicted tree.**
   The step instructs `git reset --hard origin/<base-branch>` to rewind the PR head branch.
   There is no prescribed action if this command fails (e.g., merge conflict from a prior
   abandoned run, or a detached HEAD state). If the reset fails silently or partially, all
   subsequent merges in Step B would operate on a corrupted tree. Step E's force-push would
   compound the damage. The only post-reset verification is confirming the branch name and
   that the log matches base — but this check does not detect mid-tree corruption.

5. **Phase 0 Step D batch script: no rule for whether a Gradle plugin alias uses `fetch_plugin`
   or `fetch_maven` in the generated batch.**
   Step C.1 parses `[plugins]` entries to extract plugin IDs and records them with
   `ecosystem: gradle-plugin`. Step D says "Generate a shell script from the full list of
   Maven and Gradle plugin dependencies" and the example shows both `fetch_maven` and
   `fetch_plugin` calls. However there is no explicit mapping rule: "if ecosystem =
   gradle-plugin, use fetch_plugin; if ecosystem = maven, use fetch_maven." An agent
   generating the batch script must infer this — and could incorrectly query Maven Central
   for a plugin that is only on the Gradle Plugin Portal (or vice versa for plugins that
   are also published to Maven Central, like AGP or Kotlin).

---

## Phase 2 — Baseline

Re-read run log Phase 1 — confirmed: target `skills/bump-dependencies/`, 11 command files.

### Inherited Metrics
All 111 metrics from Run 023 carry forward at post-experiment values:
- Inherited weighted sum: ~12,425 (135×)
- This reflects confirmed H88–H92 (+500 total) applied to the Run 022 final state.

### Custom Metric Discovery — New Metrics (MX95–MX100)

**Prior run log check**: scanned researchlog-001 through researchlog-023 for `### MX`
sections. MX1–MX94 already defined. MX95+ is available for new definitions.

---

### MX95 — Phase 0 Step H Non-Interactive Default [custom]
**Measures:** Whether Phase 0 Step H includes an explicit default action for the case
where the session is non-interactive (sub-agent, CI, no user response) when an existing
proactive bump PR is detected.
**Why seeds miss it:** M8 (HTC — Human Touchpoint Count) measures points requiring
human input but does not measure whether a missing else-branch causes an agent to
stall or behave unpredictably when input is unavailable. M3 (IAR — Instruction
Ambiguity Rate) would flag the absent branch only if it contained a scoped directive;
a missing branch is an omission, not an ambiguous instruction.
**Methodology:** Inspect p0-bump.md Step H for a clause handling "no interactive
channel" or "non-interactive context" in the existing-PR detection block. Current
state: two cases only (choose existing, choose new). No default. Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** non_interactive_default_present × 100
**Score: 0**

---

### MX96 — Phase 5 Downgrade Scoring Coverage [custom]
**Measures:** Whether the Phase 5 scoring matrix includes an explicit row for the
`downgrade` change type identified in Phase 1 Step D.
**Why seeds miss it:** M6 (ACC — AC Concreteness) measures whether acceptance criteria
are measurable without interpretation but does not audit whether all input states that
a prior phase can produce are covered by the scoring logic. M3 (IAR) would only catch
the gap if an existing row used ambiguous language — a missing row is an omission.
**Methodology:** Inspect p5-verdict.md Step A scoring matrix for any row explicitly
covering version downgrades. Current state: rows for major bump, minor bump, patch bump,
CVEs, licence changes, Rook findings, CI states — no downgrade row. Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** downgrade_row_present × 100
**Score: 0**

---

### MX97 — Phase 8 Step A Reset Error Handling [custom]
**Measures:** Whether Phase 8 Step A includes a prescribed action for a failed or
partial `git reset --hard` before proceeding to the merge loop in Step B.
**Why seeds miss it:** RPC (Recovery Path Completeness) measures whether conditional
branches have prescribed recovery paths. The `git reset --hard` failure is not listed
as a conditional branch in any metric enumeration because the instruction does not
acknowledge failure as a possibility — it is an implicit gap. M1 (IOT — Intent-to-Output
Traceability) measures phase-to-phase artefact reads but not git state integrity between
steps.
**Methodology:** Inspect p8-consolidate.md Step A for any error-handling clause after
`git reset --hard origin/<base-branch>`. Current state: verification only confirms
branch name and log match; no failure clause. Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** reset_error_handling_present × 100
**Score: 0**

---

### MX98 — Phase 0 Batch Script Ecosystem Routing Rule [custom]
**Measures:** Whether Phase 0 Step D includes an explicit rule specifying that
`gradle-plugin` ecosystem entries use `fetch_plugin` and `maven` ecosystem entries
use `fetch_maven` when generating the batch lookup script.
**Why seeds miss it:** M2 (DD — Directive Density) counts DO/DO NOT directives but
not the presence of an explicit routing table. M3 (IAR) would catch an ambiguous
instruction only if one existed — this is an absent instruction, not an ambiguous one.
The gap is detectable only by checking whether the batch-script generation instruction
has a complete mapping of ecosystem → fetch function.
**Methodology:** Inspect p0-bump.md Step D for an explicit routing rule: "if ecosystem
= gradle-plugin, use fetch_plugin; if ecosystem = maven, use fetch_maven." Current
state: no such rule — the example shows both calls but provides no mapping. Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** routing_rule_present × 100
**Score: 0**

---

### MX99 — Phase 1b Step D Non-Interactive Clarity [custom]
**Measures:** Whether Phase 1b Step D's non-interactive clause explicitly says the agent
should proceed with the split plan as-is (not attempt further confirmation) and continue
to Step E.
**Why seeds miss it:** This is a narrower variant of the pattern measured by MX95. The
instruction exists but is ambiguous in the edge case where the plan may be for a PR that
should have been caught as already-atomic in Step C. Unlike MX95 (a fully missing clause),
this is a present-but-incomplete instruction — closer to an IAR scope.
**Methodology:** Re-read p1b-split-commits.md Step D. The non-interactive clause says
"print the plan and proceed immediately without waiting for confirmation." This is
sufficiently clear for the normal case (non-atomic commits, non-interactive channel).
Rescoring: the instruction is present and actionable. Raw: 1/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** clause_present_and_actionable × 100
**Score: 100**

*(Removed from candidate list — already scores 100. No hypothesis needed.)*

---

### MX100 — Phase 2 Pass A Version Enumeration Fallback Completeness [custom, moonshot]
**Measures:** Whether Phase 2 Pass A's multi-version span detection covers all four
enumeration strategies (npm, Maven/GitHub Releases, PyPI, Cargo/crates.io) with a
prescribed fallback when all fail — specifically whether there is a stated behaviour when
none of the four APIs returns usable version data.
**Why seeds miss it:** M10 (CLE — Context Loading Efficiency) measures whether loaded
context is relevant but not whether all enumeration paths have coverage. M3 (IAR) does
not measure missing else-branches in fallback chains. The moonshot angle: treating the
enumeration chain as a fault-tolerant system and applying the software engineering concept
of "last-resort handler" — an explicit terminal fallback that fires when every strategy
in a chain has been exhausted without a result.
**Methodology:** Inspect p2-investigate.md Pass A for a terminal fallback clause after all
four enumeration strategies (npm, Maven Central, PyPI, Cargo) are exhausted. The file
currently ends the version enumeration section with "All subsequent steps in this phase
must aggregate data across every version in the span, not just the final release." No
terminal fallback for the case where the intermediate version list cannot be determined.
Compare: Pass A does say "If no changelog is locatable after all attempts, record:
'Changelog not found'" — but this is for the changelog URL, not for the version list
itself. Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** terminal_fallback_present × 100
**Score: 0**

---

### New Metrics This Run

| Metric | Raw | Normalised | Weight | Weighted |
|--------|-----|-----------|--------|----------|
| Phase 0 Step H Non-Interactive Default (MX95) | 0/1 | 0 | 1× | 0 |
| Phase 5 Downgrade Scoring Coverage (MX96) | 0/1 | 0 | 1× | 0 |
| Phase 8 Step A Reset Error Handling (MX97) | 0/1 | 0 | 1× | 0 |
| Phase 0 Batch Script Ecosystem Routing Rule (MX98) | 0/1 | 0 | 1× | 0 |
| Phase 1b Step D Non-Interactive Clarity (MX99) | 1/1 | 100 | 1× | 100 |
| Phase 2 Pass A Version Enumeration Fallback (MX100) | 0/1 | 0 | 1× | 0 |

*(MX99 scores 100 — no hypothesis needed. Added to inherited sum.)*

### Full Composite (116 metrics)

```
Inherited weighted sum: ~12,425 (135×)
MX99 (new, scores 100): +100 (1×)
New metrics at 0 (MX95, MX96, MX97, MX98, MX100): 0 (5×)
Total: ~12,525 / 14,100 (141×)

Composite: ~12,525 / 14,100 × 100 = ~88.8%
```

*(Scope expansion of 6 new weight units. MX99 scores 100 immediately — net +100.
Net baseline movement from Run 023 post: ~92.0% → ~88.8% due to scope expansion
of 5 new zero-scoring metrics.)*

### Weakest Metrics (Phase 3 candidates)
1. MX95 — Phase 0 Step H Non-Interactive Default: 0 (1×)
2. MX96 — Phase 5 Downgrade Scoring Coverage: 0 (1×)
3. MX97 — Phase 8 Step A Reset Error Handling: 0 (1×)
4. MX98 — Phase 0 Batch Script Ecosystem Routing Rule: 0 (1×)
5. MX100 — Phase 2 Pass A Version Enumeration Fallback: 0 (1×)

---

## Phase 3 — Hypotheses

Re-read run log Phase 2 — confirmed weakest: MX95, MX96, MX97, MX98, MX100 (all 0).

### H93 — Add non-interactive default to Phase 0 Step H

**Problem observed:** MX95 = 0. Phase 0 Step H detects an existing proactive bump PR and
asks the user to choose between resuming it or creating a new one. The two conditional
branches handle "user chooses existing" and "user chooses new PR" — but there is no clause
for the case where the agent has no interactive channel to the user (e.g., running as a
sub-agent dispatched by an orchestrator, in a CI pipeline, or in a context where no user
response arrives). Phase 1b Step D has the identical pattern and handles it correctly
("If there is no interactive channel… print the plan and proceed immediately"). Phase 0
Step H is missing this equivalent clause. In a non-interactive run the agent would stall
indefinitely or behave unpredictably.
**Change proposed:** In p0-bump.md Step H, after the two conditional branches, add a
third branch: "If there is no interactive channel to the user — for example, this is
running as a sub-agent, in a CI context, or in a non-interactive session — proceed with
creating a new PR without waiting for confirmation." Mirror the phrasing pattern used in
Phase 1b Step D.
**Targets:** Phase 0 Step H Non-Interactive Default (MX95): 0 → 100 (+100pp)
**Predicted improvement:** +100 weighted (1×)
**Pattern applied:** P7 — Binary Applicability Gates (makes the condition deterministically
derivable: interactive channel present yes/no → await input yes/no)
**Risk level:** low
**Risk note:** Additive third branch. Does not change either existing path.

---

### H94 — Add downgrade row to Phase 5 scoring matrix

**Problem observed:** MX96 = 0. Phase 1 Step D identifies `downgrade` as an explicit
change type alongside `upgrade`, `new addition`, and `removal`. Phase 5's scoring
matrix covers major/minor/patch upgrades, CVEs, licence changes, Rook signals, and CI
states — but has no row for a version downgrade. An agent scoring a downgraded dependency
has no prescribed signal. It would either apply 0 (treating it as a patch), apply the
magnitude row for the downward jump, or improvise. In all cases the output is
non-deterministic and may understate risk (downgrades often indicate a known regression or
incompatibility in the newer version — a signal in itself).
**Change proposed:** In p5-verdict.md Step A scoring matrix, add a new row:
`| Version downgrade | +2 |` with a brief note that a downgrade signals a regression in
the newer version or a deliberate rollback, and that the reviewer should check the
changelog for the reason. Position it immediately after the patch version bump row.
**Targets:** Phase 5 Downgrade Scoring Coverage (MX96): 0 → 100 (+100pp)
**Predicted improvement:** +100 weighted (1×)
**Pattern applied:** P6 — Symmetric Outcome Thresholds (extends the scoring matrix to
cover all direction variants of a version change: upgrade ↑ and downgrade ↓)
**Risk level:** low
**Risk note:** Additive row. Does not change scoring for any existing signal. The +2
value is a conservative midpoint — a downgrade is at minimum as notable as a minor
upgrade but not necessarily as risky as a major one.

---

### H95 — Add reset failure handling to Phase 8 Step A

**Problem observed:** MX97 = 0. Phase 8 Step A instructs `git reset --hard origin/<base-branch>`
to rewind the PR head branch. The post-reset verification checks only that the branch name
and the log tip match the base — it does not prescribe an action if the `git reset --hard`
command itself fails (non-zero exit) or if the working tree is left in an unexpected state
(e.g., from a prior abandoned run, a detached HEAD, or uncommitted changes left by another
phase). If the reset fails silently, all subsequent `git merge --no-ff` calls in Step B
would operate on a corrupted tree, and the force-push in Step E would propagate that
corruption to the remote PR head branch.
**Change proposed:** In p8-consolidate.md Step A, after the `git reset --hard` command,
add an explicit failure check: "If `git reset --hard` exits with a non-zero code or the
subsequent log check shows the tip does not match `origin/<base-branch>`, stop immediately
and report: 'Phase 8 Step A reset failed — PR head branch is in an unexpected state.
Inspect the local branch manually, resolve any conflicts or uncommitted changes, and
re-run Phase 8.'"
**Targets:** Phase 8 Step A Reset Error Handling (MX97): 0 → 100 (+100pp)
**Predicted improvement:** +100 weighted (1×)
**Pattern applied:** P10 — Failure Mode Registry (adds a recovery path for the git reset
failure mode, which currently has no prescribed next action)
**Risk level:** low
**Risk note:** Stop-and-report pattern consistent with other force-push failure handling
in this skill. Does not change the happy path.

---

### H96 — Add ecosystem-to-function routing rule to Phase 0 Step D

**Problem observed:** MX98 = 0. Phase 0 Step C.1 records each resolved dependency with
`ecosystem: maven` or `ecosystem: gradle-plugin`. Step D says "Generate a shell script
from the full list of Maven and Gradle plugin dependencies" and the example shows both
`fetch_maven` and `fetch_plugin` calls — but there is no explicit rule mapping
`ecosystem = gradle-plugin → fetch_plugin` and `ecosystem = maven → fetch_maven`. An
agent generating the batch script must infer this mapping from the example alone. For
plugins published to both Maven Central and the Gradle Plugin Portal (e.g., AGP, Kotlin
plugin), an agent may pick the wrong fetch function, returning no version data or the
wrong version from a non-authoritative registry.
**Change proposed:** In p0-bump.md Step D, immediately before the batch script example,
add two sentences: "For each dependency: if `ecosystem = gradle-plugin`, use `fetch_plugin`
with the plugin ID. If `ecosystem = maven`, use `fetch_maven` with `group` and `artifact`."
**Targets:** Phase 0 Batch Script Ecosystem Routing Rule (MX98): 0 → 100 (+100pp)
**Predicted improvement:** +100 weighted (1×)
**Pattern applied:** P7 — Binary Applicability Gates (replaces inferred routing with an
explicit yes/no rule derivable from the ecosystem field set in Step C)
**Risk level:** low
**Risk note:** Two additive sentences. Does not change the batch script structure or
either fetch function's behaviour.

---

### H97 — Add version enumeration terminal fallback to Phase 2 Pass A

**Problem observed:** MX100 = 0. Phase 2 Pass A instructs the agent to enumerate
intermediate versions using registry APIs (npm, Maven Central, PyPI, Cargo, GitHub
Releases). The multi-version span logic says: if two or more versions exist in the range,
aggregate changelog data across all of them. However, there is no terminal fallback for
the case where none of the four API strategies returns usable data and the intermediate
version list cannot be determined. The changelog fallback ("If no changelog is locatable,
record: Changelog not found") exists for Pass A's changelog fetch — but not for the
version enumeration itself. An agent that cannot enumerate intermediate versions has no
instruction: it might assume single-version span, skip aggregation, or halt.
**Change proposed:** In p2-investigate.md Pass A, after the four registry strategies, add
a terminal fallback: "If the intermediate version list cannot be determined after exhausting
all four strategies, assume a **single-version span** (apply only the final release's
changelog) and record: 'Intermediate version enumeration failed — assuming single-version
span. Manual review of intermediate releases recommended if a multi-version bump is
suspected.'"
**Targets:** Phase 2 Pass A Version Enumeration Fallback (MX100): 0 → 100 (+100pp)
**Predicted improvement:** +100 weighted (1×)
**Pattern applied:** P10 — Failure Mode Registry (adds a terminal recovery instruction for
the version-enumeration failure mode, which currently has no prescribed next action)
**Risk level:** low
**Risk note:** The fallback defaults to single-version span — the more conservative
assumption in terms of missed risk. Additive only; does not change the enumeration logic.

---

### Self-Audit (Keeper)

1. **Intent check:** H93 targets MX95 (0) ✓; H94 targets MX96 (0) ✓; H95 targets
   MX97 (0) ✓; H96 targets MX98 (0) ✓; H97 targets MX100 (0) ✓.
2. **Coverage check:**
   - H93–H97: +100 each (5×) = +500 weighted
   - Total predicted gain: +500
   - Projected: (~12,525 + 500) / 14,100 = ~13,025 / 14,100 = **~92.3%** < 95%
   - Below 95%. Remaining moonshots at 0 (MX34, MX38, MX43, MX49, MX78) — architectural
     scope, no tractable hypothesis. No non-moonshot metric below 80 without a hypothesis. ✓
3. **Gap fill:** All non-moonshot metrics below 100 covered. ✓

**Step 0 — Pre-Experiment Dependency Scan:**
H93 → p0-bump.md (Step H — existing PR block)
H94 → p5-verdict.md (Step A — scoring matrix)
H95 → p8-consolidate.md (Step A — reset + verification block)
H96 → p0-bump.md (Step D — before batch script)
H97 → p2-investigate.md (Pass A — after four strategies)

**Overlap:** H93 and H96 both modify p0-bump.md. Run H96 first (Step D — earlier in
the file), then H93 (Step H — later in the file). All other hypotheses are independent.

### Recommendation Brief

Based on baseline measurement, the following experiments are queued.

1. **Add ecosystem-to-function routing rule to Phase 0 Step D** — the batch lookup script example shows both fetch functions but provides no rule mapping the `ecosystem` field to the correct function; agents generating the script for mixed Maven/Gradle-plugin manifests must infer the mapping.
2. **Add non-interactive default to Phase 0 Step H** — when an existing proactive PR is detected, the step asks the user to choose but has no clause for non-interactive contexts; the equivalent gap in Phase 1b Step D was resolved with "print the plan and proceed immediately."
3. **Add downgrade row to Phase 5 scoring matrix** — the matrix covers all upgrade directions (major, minor, patch) but has no row for a version downgrade, leaving agents without a prescribed signal for a deliberate rollback.
4. **Add reset failure handling to Phase 8 Step A** — the `git reset --hard` command has no prescribed action on failure; a corrupted tree would propagate through all subsequent merge and force-push steps.
5. **Add version enumeration terminal fallback to Phase 2 Pass A** — the multi-version span detection has no stated behaviour when all four enumeration strategies fail; agents may silently assume single-version span or halt.

---

## Phase 4 — Experiments

Re-read Phase 3 — approved hypotheses: H93, H94, H95, H96, H97.
File overlap: H93 and H96 both modify p0-bump.md — run H96 first (Step D), then H93 (Step H).
Execution order: H96 → H93 → H94 → H95 → H97.

---

### H96 — Add ecosystem-to-function routing rule to Phase 0 Step D

**Change applied** to `p0-bump.md` Step D, immediately before the batch script example:
- Added two sentences: "For each dependency: if `ecosystem = gradle-plugin`, use
  `fetch_plugin` with the plugin ID. If `ecosystem = maven`, use `fetch_maven` with
  `group` and `artifact`."

**MX98 re-check:** Step D now has an explicit routing rule mapping the ecosystem field
to the correct fetch function. Raw: 1/1. **Score: 0 → 100 ✓**

---

### H93 — Add non-interactive default to Phase 0 Step H

**Change applied** to `p0-bump.md` Step H, added a third branch after the two existing
conditional branches:
- "If there is no interactive channel to the user — for example, this is running as a
  sub-agent, in a CI context, or in a non-interactive session — proceed with creating a
  new PR without waiting for confirmation. Continue with the branch-specific check below."

**MX95 re-check:** Step H now has three cases (choose existing, choose new, non-interactive
default). Raw: 1/1. **Score: 0 → 100 ✓**

---

### H94 — Add downgrade row to Phase 5 scoring matrix

**Change applied** to `p5-verdict.md` Step A:
- Added `| Version downgrade | +2 |` row immediately after the patch version bump row.
- Added a "Note on 'Version downgrade'" callout block after the "Note on 'Major version
  bump with no changelog found'" block, explaining the +2 signal rationale and when to
  apply it.

**MX96 re-check:** Scoring matrix now includes an explicit downgrade row. Raw: 1/1.
**Score: 0 → 100 ✓**

---

### H95 — Add reset failure handling to Phase 8 Step A

**Change applied** to `p8-consolidate.md` Step A, after the post-reset verification block:
- Added a stop-and-report clause: "If `git reset --hard` exits with a non-zero code, or
  if the subsequent log check shows the tip does not match `origin/<base-branch>`, stop
  immediately and report: 'Phase 8 Step A reset failed…' Do not proceed to Step B if the
  reset check fails."

**MX97 re-check:** Step A now has an explicit failure clause and stop instruction for the
reset failure mode. Raw: 1/1. **Score: 0 → 100 ✓**

---

### H97 — Add version enumeration terminal fallback to Phase 2 Pass A

**Change applied** to `p2-investigate.md` Pass A, added step 5 to the enumeration list:
- "If the intermediate version list cannot be determined after exhausting all five
  strategies above (npm, Maven Central, PyPI, Cargo, GitHub Releases), assume a
  single-version span and record: 'Intermediate version enumeration failed — assuming
  single-version span. Manual review of intermediate releases recommended if a
  multi-version bump is suspected.' Proceed to Pass B using only the final release's
  changelog."

**MX100 re-check:** Pass A now has an explicit terminal fallback for enumeration failure.
Raw: 1/1. **Score: 0 → 100 ✓**

---

### Post-Experiment Composite

```
Inherited weighted sum:  ~12,525 (136×, includes MX99 at 100)
New metrics post-scores: 100 + 100 + 100 + 100 + 100 = 500 (5×)
Total: ~13,025 / 14,100 (141×)

Composite: ~13,025 / 14,100 × 100 = ~92.4%
```

---

## Phase 5 — Report

### Run Summary

| Field | Value |
|---|---|
| Run | 024 |
| Date | 2026-04-21 |
| Target | `skills/bump-dependencies/` |
| Hypotheses tested | 5 (H93–H97) |
| Confirmed | 5 |
| Disconfirmed | 0 |
| Composite movement | 88.8% → 92.4% (+3.6 pp) |
| Version bump | 4.16.0 → 4.17.0 (minor) |

### Confirmed Hypotheses

| ID | Change | Metric | Gain |
|---|---|---|---|
| H93 | Phase 0 Step H non-interactive default | MX95: 0→100 | +100 |
| H94 | Phase 5 downgrade scoring row | MX96: 0→100 | +100 |
| H95 | Phase 8 Step A reset failure handling | MX97: 0→100 | +100 |
| H96 | Phase 0 Step D ecosystem routing rule | MX98: 0→100 | +100 |
| H97 | Phase 2 Pass A enumeration terminal fallback | MX100: 0→100 | +100 |

### Novel Patterns Discovered
None. H93 applied P7, H94 applied P6, H95 applied P10, H96 applied P7, H97 applied P10.
All patterns are existing seed patterns.

### Moonshot Status
MX34, MX38, MX43, MX49, MX78 remain at 0 — architectural scope, no tractable
hypothesis. No change to moonshot list.

### Next-Run Candidates
No non-moonshot metrics currently below 100. The skill is at 92.4% composite.
Further gains require moonshot architectural changes or discovery of new instruction
gaps via fresh full-audit read. A targeted re-read focusing on Phase 3 (code impact
mapping) and Phase 6 (comment posting) edge cases is recommended for the next run —
these phases are comparatively under-audited relative to their surface area.

## Experiment Summary
- Confirmed: H93, H94, H95, H96, H97
- Partial: (none)
- Disconfirmed: (none)

