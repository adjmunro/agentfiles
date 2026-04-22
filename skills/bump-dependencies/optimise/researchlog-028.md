<!-- SUMMARY-START -->
## Run 028 — 2026-04-22 | Target: skills/bump-dependencies/

Composite: 89.2% → 93.5% (+4.3 pp)

### Hypotheses
| ID   | Description | Outcome |
|------|-------------|---------|
| H113 | Add CI-failure branch to Phase 3 routing | Confirmed |
| H114 | Add absent-verdict guard to Phase 8 Step B | Confirmed |
| H115 | Add proactive-PR detection method to Phase 5 | Confirmed |
| H116 | Add orphaned-commit disclosure to Phase 0 Step H/I | Confirmed |
| H117 | Add CI-failure sections to Phase 3 table and Phase 4 header | Confirmed |

### Metric Snapshot
| Metric | Baseline | Post |
|--------|----------|------|
| Phase 3 Routing CI-Failure Branch (MX116) | 0 | 100 |
| Phase 8 Step B Absent-Verdict Guard (MX117) | 0 | 100 |
| Phase 5 Proactive-PR Detection Method (MX118) | 0 | 100 |
| Phase 0 Step H Orphaned-Commit Disclosure (MX119) | 0 | 100 |
| CI-Failure Pipeline End-to-End Completeness (MX120) | 0 | 100 |
| Composite | 89.2% | 93.5% |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

**Target:** `skills/bump-dependencies/`
**Files:** 42 total (11 command, 4 support, 27 optimise logs)
**Token estimate:** ~20,000 tokens (instruction files only)

### Cross-Run Context (from researchlog-027.md)

Previous composite: 89.4% → 93.2% (+3.8pp)
H108–H112: all Confirmed — excluded from this run.
H1–H112: all confirmed or disconfirmed across runs 001–027. Excluded from this run.

Run 027 targeted 5 edge-state gaps: Phase 7 zero-alias case (H108), IS_PROACTIVE secondary confirmation (H109), Phase 8 Step E branch-position verification (H110), Wave 2 remediation hash collection (H111), and Phase 1b cross-bump check result persistence (H112). All confirmed.

### Feature Inventory
Unchanged from Runs 025–027.
- Multi-phase pipeline: yes (11 phases across 10 command files + orchestrator)
- Persona system: yes (Ink, Echo, Rook, Arden — 4 personas)
- Subagent invocations: yes (Wave 1 and Wave 3 — parallel per-alias agents)
- Multi-session orchestration: yes (/tmp session brief + manifest + consolidation summary)
- Parallel execution: yes (Wave 1 and Wave 3 concurrent per-alias agents)
- Cached artifacts: yes (session brief, manifest, consolidation summary)

### Persona Staleness Check
All 4 personas confirmed present per Run 025. No broken references.

### Excluded from this run
H1–H112: all confirmed or disconfirmed across runs 001–027. See respective run logs.

### Files
Command (11): bump-dependencies.md, p0-bump.md, p1-parse.md, p1b-split-commits.md,
  p2-investigate.md, p3-impact.md, p4-remediate.md, p5-verdict.md, p6-comment.md,
  p7-summary.md, p8-consolidate.md
Support (4): SKILL.md, AGENTS.md, VERSION.md, CHANGELOG.md
Optimise logs (27): researchlog-001 through researchlog-027

---

### Structural Gaps Identified (Full Audit)

1. **Phase 3 `→ Next` routing — no CI-failure branch.**
   Phase 3's terminal routing directive: "If actionable usages were found (must-fix
   items), read `phases/p4-remediate.md` and execute it. If no actionable usages, skip
   to `phases/p5-verdict.md`." This binary branch has no case for: "no Phase 3
   actionable usages, BUT Phase 1 Step G recorded CI failures classified as API break,
   Migration required, or Deprecation became removal." Phase 4 Step A.1 was added
   precisely to handle CI-failure remediation — but Step A.1 is unreachable when Phase 3
   finds nothing. The per-bump agent will skip to Phase 5, apply the "+4 CI failing;
   unresolved" scoring signal, and post a comment saying the CI failure was not addressed
   — even though Phase 4 Step A.1 is fully capable of addressing it.

2. **Phase 8 Step B — no case for absent Phase 5 verdict (silent Wave 3 agent failure).**
   Phase 8 Step B checks two skip conditions before merging an isolated branch:
   (a) `push_failed: true` and (b) "Phase 5 returned BLOCK or the agent reported it
   could not remediate." There is no third case: "Phase 5 verdict not received at all"
   (Wave 3 agent crashed silently or returned before completing Phase 5). If a Wave 3
   agent fails silently, its alias has no verdict in the orchestrator's context and no
   Phase 6 comment in the PR. Phase 8 Step B would find neither `push_failed: true` nor
   a BLOCK verdict for it — so it would proceed to merge the alias without review. The
   fallback for retrieving verdict data in Phase 7 Step A (checking posted Phase 6
   comments) correctly handles missing comments, but Phase 8 Step B has no equivalent
   check.

3. **Phase 5 — "Phase 0 created this PR" detection method absent.**
   The scoring matrix note for "New version published < 7 days before PR creation date"
   states: "Do NOT apply this signal if Phase 0 created this PR (the 7-day window was
   already enforced at bump time)." Phase 5 runs as a per-bump sub-agent with only the
   session brief and agent prompt for context — it does not have access to a stored
   IS_PROACTIVE flag. No detection method is specified for how the agent should determine
   whether Phase 0 created the PR. The necessary signal (PR title prefix and head branch
   name) is available in the session brief (written by Phase 1 Step E) and the agent
   prompt, but the note does not point to it. An agent without this instruction would
   either always apply or never apply the +1 signal for proactive PRs.

4. **Phase 0 Step H — "existing PR" path produces a misleading Step I summary.**
   When a user selects an existing PR in Step H, the skill: (a) deletes `BUMP_BRANCH`
   from the remote (`git push origin --delete <BUMP_BRANCH>`), (b) checks out the base
   branch, and (c) proceeds to Step I. Step I's output template is a "Proactive Bump
   Summary" table listing all bumps discovered and committed in the current run. But on
   the "existing PR" path, those commits were never included in the existing PR — they
   were orphaned on the now-deleted BUMP_BRANCH. A user who committed 5 bumps and then
   chose the existing PR will see a summary showing 5 completed bumps, with a PR number
   for an existing PR that contains none of them. No disclosure note exists in Step I to
   warn that the listed bumps were discarded.

5. **Phase 3 impact table — no "CI Failures Not Addressed" section when Phase 4 is skipped.**
   When Phase 3 finds no actionable usages and routes directly to Phase 5, the agent
   produces an impact table with "Actionable usages (must fix): 0". If Phase 1 Step G
   recorded CI failures for this bump, those failures are scored by Phase 5 (+4 unresolved)
   and surfaced in the Phase 6 comment's "CI Status" section. But the Phase 3 impact table
   has no place to record "CI failures exist but are not addressed because Phase 4 was
   not triggered." The reviewer reading Phase 6's comment sees a CI failure penalised in
   the score but gets no explanation of why Phase 4 didn't attempt to fix it. Phase 4's
   header comment ("Active when: Phase 3 found actionable usages (must-fix items)") also
   excludes CI failures from its activation condition, making the gap structural rather
   than incidental.

---

## Phase 2 — Baseline

Re-read run log Phase 1 — confirmed: target `skills/bump-dependencies/`, 11 command
files, 5 structural gaps identified.

### Inherited Metrics
All 131 metrics from Run 027 carry forward at post-experiment values.
Inherited weighted sum: ~14,725 (158×)
(Run 027 post composite: 93.2%)

### Custom Metric Discovery — New Metrics (MX116–MX120)

**Prior run log check**: MX1–MX115 defined across runs 001–027. MX116+ available.

---

### MX116 — Phase 3 Routing CI-Failure Branch [custom]
**Measures:** Whether Phase 3's `→ Next` routing directive includes a CI-failure
branch — specifically, whether it triggers Phase 4 when Phase 1 Step G recorded CI
failures classified as API break, Migration required, or Deprecation became removal,
even if Phase 3 found zero actionable usages.
**Why seeds miss it:** M1 IOT measures whether outputs chain into inputs; it detects
wiring gaps where a phase explicitly reads a prior phase's output. But this gap is a
routing-logic omission, not a broken read — Phase 3 simply doesn't check CI status
before deciding to skip Phase 4. M6 ACC measures acceptance criteria concreteness but
not routing completeness for conditional branch coverage.
**Methodology:** Inspect p3-impact.md `→ Next` line. Check whether a CI-failure
condition exists alongside the "actionable usages" condition. Current state: binary
branch only — "if actionable usages → Phase 4; else → Phase 5". No CI-failure branch.
Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** ci_failure_branch_present × 100
**Score: 0**

---

### MX117 — Phase 8 Step B Absent-Verdict Guard [custom]
**Measures:** Whether Phase 8 Step B has an explicit case for an alias where Phase 5
produced no verdict (silent Wave 3 agent failure) — preventing the alias from being
merged without review.
**Why seeds miss it:** M11 PSS (Parallelisation Safety) measures whether concurrent
operations have mutual exclusion guards for shared resources. But silent agent failure
is a fault-tolerance gap, not a race condition. M9 CDR (Context Decay Resilience) covers
session re-anchoring, not agent failure handling. The gap is that Step B's skip logic
is not exhaustive: it handles `push_failed: true` and explicit BLOCK verdicts but not
the "no verdict at all" state.
**Methodology:** Inspect p8-consolidate.md Step B. Count the distinct skip conditions.
Current state: two conditions — `push_failed: true` and BLOCK/unverified. No third
condition for absent verdict. Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 2×
**Normalisation:** absent_verdict_guard_present × 100
**Score: 0**

---

### MX118 — Phase 5 Proactive-PR Detection Method [custom]
**Measures:** Whether Phase 5's scoring matrix note for "New version published < 7 days
before PR creation date" includes an explicit detection method for determining whether
Phase 0 created this PR — e.g., "check if PR title starts with `chore(deps): bump
outdated dependencies` AND head branch starts with `deps/auto-bump-`" — rather than
leaving it as an unanchored "if Phase 0 created this PR."
**Why seeds miss it:** M3 IAR (Instruction Ambiguity Rate) catches modals and
conditionals without resolution paths. This note uses a conditional without giving
the agent a resolution path: "Do NOT apply this signal if Phase 0 created this PR"
requires the agent to know whether Phase 0 created the PR, but no check is specified.
M3 would flag this as ambiguous; it has not been caught by prior runs because the note
is phrased as a declarative rule rather than an instruction.
**Methodology:** Inspect p5-verdict.md scoring matrix note for the 7-day publication
signal. Check whether a detection method is specified alongside the rule. Current state:
rule present, detection method absent. Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** detection_method_present × 100
**Score: 0**

---

### MX119 — Phase 0 Step H Orphaned-Commit Disclosure [custom]
**Measures:** Whether Phase 0 Step H's "user chooses existing PR" path includes an
explicit disclosure (in Step I's output or in Step H itself) that the bump commits made
in the current run to BUMP_BRANCH were orphaned and are not included in the chosen
existing PR.
**Why seeds miss it:** M6 ACC measures concreteness of acceptance criteria. M3 IAR
catches ambiguities. Neither covers misleading output — where the instruction is
unambiguous but produces output that is factually accurate (the bumps were committed)
yet contextually misleading (they are not in the PR). This is an M13 (Instruction Token
Efficiency) variant: the output is more informative than helpful.
**Methodology:** Inspect p0-bump.md Step H and Step I. Check for any disclosure note
in the "existing PR" path that warns the user the newly-committed bumps are not in the
existing PR. Current state: Step H deletes BUMP_BRANCH silently; Step I produces a
full bump table without any qualification. Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** orphaned_commit_disclosure_present × 100
**Score: 0**

---

### MX120 — CI-Failure Pipeline End-to-End Completeness [custom, moonshot]
**Measures:** Whether the CI-failure remediation path is structurally complete across
Phase 3 and Phase 4: (Part A) Phase 3's impact table template includes a "CI Failures
Not Addressed" section when Phase 4 is skipped despite CI failures existing; (Part B)
Phase 4's header activation comment explicitly lists CI failures as an independent
trigger alongside "Phase 3 found actionable usages." Without both parts, CI failures
can fall through the pipeline without being surfaced in Phase 3's output OR acknowledged
as a trigger in Phase 4's header — leaving a structural gap that persists even after
MX116's routing fix.
**Why seeds miss it:** No seed metric traces data provenance across routing decisions.
M1 IOT measures whether outputs chain into inputs — but it does not measure whether a
routing decision (skip Phase 4) causes information from Phase 1 to vanish from Phase 3's
output. The moonshot framing: treating CI-failure remediation as a first-class pipeline
route — not an addendum to Phase 4's Step A.1 — by ensuring both the impact table and
the phase activation condition are updated.
**Methodology:** Part A — inspect p3-impact.md impact table template (Step D). Check
whether a "CI Failures Not Addressed" or equivalent section exists for the case where
Phase 4 is skipped. Current state: no such section; the template ends at "Summary."
Raw for Part A: 0/1.
Part B — inspect p4-remediate.md header comment. Check whether "Active when:" includes
CI failures as an explicit trigger. Current state: "Active when: Phase 3 found
actionable usages (must-fix items)" only. Raw for Part B: 0/1.
Full credit (100) requires both parts.
**Direction:** ↑ higher is better
**Weight:** 2×
**Normalisation:** (part_a_present + part_b_present) / 2 × 100
**Score: 0**

---

### New Metrics This Run

| Metric | Raw | Normalised | Weight | Weighted |
|--------|-----|-----------|--------|----------|
| Phase 3 Routing CI-Failure Branch (MX116) | 0/1 | 0 | 1× | 0 |
| Phase 8 Step B Absent-Verdict Guard (MX117) | 0/1 | 0 | 2× | 0 |
| Phase 5 Proactive-PR Detection Method (MX118) | 0/1 | 0 | 1× | 0 |
| Phase 0 Step H Orphaned-Commit Disclosure (MX119) | 0/1 | 0 | 1× | 0 |
| CI-Failure Pipeline End-to-End Completeness (MX120) | 0/2 | 0 | 2× | 0 |

### Full Composite (136 metrics)

```
Inherited weighted sum: ~14,725 (158×)
New metrics weighted sum: 0+0+0+0+0 = 0 (7×)
Total: ~14,725 / 16,500 (165×)

Composite: ~14,725 / 16,500 × 100 = ~89.2%
```

*(Drop of 4.0pp from scope expansion: 7 new weight units, all scored 0.)*

### Weakest Metrics (Phase 3 candidates)
1. MX117 — Phase 8 Step B Absent-Verdict Guard: 0 (2×) — safety-critical
2. MX120 — CI-Failure Pipeline End-to-End Completeness: 0 (2×) — moonshot
3. MX116 — Phase 3 Routing CI-Failure Branch: 0 (1×)
4. MX118 — Phase 5 Proactive-PR Detection Method: 0 (1×)
5. MX119 — Phase 0 Step H Orphaned-Commit Disclosure: 0 (1×)

---

## Phase 3 — Hypotheses

Re-read run log Phase 2 — confirmed weakest: MX116–MX120 all at 0.

### Step 0 — Pre-Experiment Dependency Scan

File targets per hypothesis:
- H113 → p3-impact.md (`→ Next` routing line)
- H114 → p8-consolidate.md (Step B skip conditions)
- H115 → p5-verdict.md (7-day scoring note)
- H116 → p0-bump.md (Step H and Step I)
- H117 → p3-impact.md (Step D template) + p4-remediate.md (header comment)

Overlaps:
- H113 and H117 both modify p3-impact.md → run sequentially with re-check between them.

Execution order: H113 → (p3-impact.md re-check) → H117 → H114 → H115 → H116
(H114, H115, H116 are independent of each other and of H117.)

---

### H113 — Add CI-failure branch to Phase 3 routing

**Targets:** MX116
**Pre-change:** MX116 = 0 (binary routing — no CI-failure branch)

**Planned change:** Update p3-impact.md `→ Next` to add a third branch:
"If actionable usages were found (must-fix items) OR Phase 1 Step G recorded CI
failures classified as API break, Migration required, or Deprecation became removal:
read `phases/p4-remediate.md` and execute it. If no actionable usages AND no
CI failures requiring remediation: skip to `phases/p5-verdict.md`."

---

### H117 — Add CI-failure sections to Phase 3 impact table and Phase 4 header

**Targets:** MX120 (Part A: Phase 3 table; Part B: Phase 4 header)
**Pre-change:** MX120 = 0 (neither part present)

**Planned change (Part A):** Update p3-impact.md Step D impact table template to
include a "CI Failures Not Addressed (Phase 4 not triggered)" section that appears
when Phase 4 is not being triggered for this alias. This section lists CI failures
from Phase 1 Step G that will be scored by Phase 5 but were not remediated.

**Planned change (Part B):** Update p4-remediate.md header comment to read:
"Active when: Phase 3 found actionable usages (must-fix items) OR Phase 1 Step G
recorded CI failures classified as API break, Migration required, or Deprecation
became removal."

---

### H114 — Add absent-verdict guard to Phase 8 Step B

**Targets:** MX117
**Pre-change:** MX117 = 0 (two skip conditions, no absent-verdict case)

**Planned change:** Add a third skip condition to Phase 8 Step B: if Phase 5 verdict
data for this alias is not present in the orchestrator context AND not in the posted
Phase 6 PR comments (checked via `gh pr view --json comments`), skip the merge and
record as "unverified (no Phase 5 verdict received — Wave 3 agent may have failed
silently)."

---

### H115 — Add proactive-PR detection method to Phase 5

**Targets:** MX118
**Pre-change:** MX118 = 0 (rule present, no detection method)

**Planned change:** Update p5-verdict.md's scoring matrix note to add: "To determine
whether Phase 0 created this PR: check the PR title and head branch name from the
session brief (`/tmp/dep-review-<PR-number>-session-brief.md`) or the agent prompt
context. Phase 0 sets both a specific title prefix (`chore(deps): bump outdated
dependencies`) and a branch prefix (`deps/auto-bump-`). If BOTH are present, treat
as proactive and do not apply this signal."

---

### H116 — Add orphaned-commit disclosure to Phase 0 Step H/I

**Targets:** MX119
**Pre-change:** MX119 = 0 (no disclosure)

**Planned change:** In Phase 0 Step H, add a disclosure immediately before the
"proceed to Step I" instruction on the "user chooses existing PR" path:
"Note: the bump commits made in this run to `<BUMP_BRANCH>` are NOT included in
PR #<existing-number>. They were discarded when the branch was deleted. The existing
PR's content and review state are unchanged."

Also update Step I to clearly distinguish between two output scenarios:
- Normal path: show the full bump table
- Existing-PR path: note that the table below shows bumps that were committed and then
  discarded, and that the PR number refers to the existing PR

---

### Self-Audit

1. **Intent check**: MX116–MX120 all at 0 — no score-100 duplicates. All hypotheses proceed.
2. **Coverage check**: All 5 metrics have a hypothesis. Each confirms → composite rises.
3. **Gap fill**: No metrics below 80 without a hypothesis (new metrics are all at 0 and covered).

### Phase 3 — Hypotheses Summary

| ID | Description | Targets | Files |
|----|-------------|---------|-------|
| H113 | Add CI-failure branch to Phase 3 routing | MX116 | p3-impact.md |
| H114 | Add absent-verdict guard to Phase 8 Step B | MX117 | p8-consolidate.md |
| H115 | Add proactive-PR detection method to Phase 5 | MX118 | p5-verdict.md |
| H116 | Add orphaned-commit disclosure to Phase 0 Step H/I | MX119 | p0-bump.md |
| H117 | Add CI-failure sections to Phase 3 table and Phase 4 header | MX120 | p3-impact.md, p4-remediate.md |

---

## Phase 4 — Experiments

### Step 0 — Pre-Experiment Dependency Scan (carried forward from Phase 3)
H113 and H117 share p3-impact.md → run sequentially with re-check between them.
Execution order: H113 → H117 → H114 → H115 → H116.

### H113 — Add CI-failure branch to Phase 3 routing

**Pre-change:** MX116 = 0 (binary routing — no CI-failure branch in `→ Next`)
**Post-change:** MX116 = 100 (CI-failure branch added to routing directive)
**Delta:** MX116 +100pp
**Result:** confirmed
**Notes:** Updated p3-impact.md `→ Next` to add a third branch: Phase 4 is triggered
when Phase 1 Step G recorded any CI failures classified as API break, Migration
required, or Deprecation became removal — regardless of whether Phase 3 found
actionable usages. Skip-to-Phase-5 path now explicitly requires BOTH no actionable
usages AND no CI failures requiring remediation. Added a `> Why:` rationale so agents
understand the intent. No interaction with H117 (which targets the Step D template
and Phase 4 header, not the `→ Next` line).

### H117 — Add CI-failure sections to Phase 3 table and Phase 4 header

**Pre-change:** MX120 = 0/2 (neither Part A nor Part B present)
**Post-change:** MX120 = 100 (both parts applied)
**Delta:** MX120 +100pp (× 2 weight = +200 weighted)
**Result:** confirmed
**Notes:** Two-part change:
1. p3-impact.md Step D: added a "CI Failures Not Addressed" section to the impact
   table template. Appears only when CI failures exist but Phase 4 is not triggered.
   Produces an explicit table of unaddressed failures so the reviewer understands why
   Phase 4 was skipped and what the Phase 5 +4 scoring penalty refers to. Conditional
   guard ("Include this section ONLY when both conditions hold") prevents it from
   cluttering impact tables where Phase 4 ran.
2. p4-remediate.md header: updated "Active when:" to list CI failures as an explicit
   second activation trigger. Updated "Skip this phase entirely if:" symmetrically.

Re-check after H113 and H117 (shared file p3-impact.md):
H113 targeted the `→ Next` line; H117 targeted the Step D template. No interaction.
MX116 and MX120 both score 100 post-change.

### H114 — Add absent-verdict guard to Phase 8 Step B

**Pre-change:** MX117 = 0 (two skip conditions, no absent-verdict case)
**Post-change:** MX117 = 100 (third skip condition added)
**Delta:** MX117 +100pp (× 2 weight = +200 weighted)
**Result:** confirmed
**Notes:** Added Step B condition 3: if no Phase 5 verdict in orchestrator context AND
no Phase 6 comment for the alias exists in the PR (checked via `gh pr view --json
comments` with a `startswith` filter on the Phase 6 comment prefix), skip the merge
and flag as "unverified (no Phase 5 verdict received — Wave 3 agent may have failed
silently)." Detection method is consistent with the Phase 6 comment prefix established
in p6-comment.md Step A ("## Dependency Review: `<alias>`").

### H115 — Add proactive-PR detection method to Phase 5

**Pre-change:** MX118 = 0 (rule present, no detection method)
**Post-change:** MX118 = 100 (detection method added)
**Delta:** MX118 +100pp
**Result:** confirmed
**Notes:** Added a sub-note to Phase 5's 7-day publication signal specifying that the
agent checks BOTH the PR title prefix (`chore(deps): bump outdated dependencies`) AND
the head branch prefix (`deps/auto-bump-`) from the session brief or prompt context.
Both conditions must hold for the signal to be suppressed. Consistent with the
IS_PROACTIVE detection pattern established in Phase 7 Step A and Phase 8 Step B (H109).

### H116 — Add orphaned-commit disclosure to Phase 0 Step H/I

**Pre-change:** MX119 = 0 (no disclosure)
**Post-change:** MX119 = 100 (disclosure added to Step H and Step I)
**Delta:** MX119 +100pp
**Result:** confirmed
**Notes:** Two-part change:
1. p0-bump.md Step H: added an "Important:" note immediately before "proceed to Step I"
   on the "user chooses existing PR" path, stating that BUMP_BRANCH commits were
   discarded and the existing PR is unchanged.
2. p0-bump.md Step I: added a conditional ⚠️ preamble (fires only on the existing-PR
   path) clarifying that the bump table below refers to discarded commits.

### Experiment Summary
- Confirmed: H113, H117, H114, H115, H116
- Partial: none
- Disconfirmed: none

---

## Phase 5 — Report

### Final Results — 2026-04-22

| Metric | Baseline | Post | Delta | Status |
|--------|----------|------|-------|--------|
| Phase 3 Routing CI-Failure Branch (MX116) | 0 | 100 | +100 | ↑ |
| Phase 8 Step B Absent-Verdict Guard (MX117) | 0 | 100 | +100 | ↑ |
| Phase 5 Proactive-PR Detection Method (MX118) | 0 | 100 | +100 | ↑ |
| Phase 0 Step H Orphaned-Commit Disclosure (MX119) | 0 | 100 | +100 | ↑ |
| CI-Failure Pipeline End-to-End Completeness (MX120) | 0 | 100 | +100 | ↑ |
| **Composite** | **89.2%** | **93.5%** | **+4.3 pp** | |

Calculation:
- Inherited weighted sum: ~14,725 (158×)
- New metrics post sum: 100(1×) + 100(2×) + 100(1×) + 100(1×) + 100(2×) = 700 (7×)
- Total post: ~15,425 / 16,500 × 100 = ~93.5%

**What improved and why:**
- Phase 3 Routing CI-Failure Branch (+100pp): Added CI-failure branch to Phase 3's
  routing so Phase 4 Step A.1 is reachable for CI-failure-only scenarios. Previously,
  CI failures classified as API break, Migration required, or Deprecation became
  removal were scored by Phase 5 but never remediated.
- Phase 8 Step B Absent-Verdict Guard (+100pp, weight 2×): Added a third skip
  condition detecting silent Wave 3 agent failures via PR comment presence check,
  preventing unreviewed aliases from being merged.
- Phase 5 Proactive-PR Detection Method (+100pp): Added explicit detection instructions
  (title prefix + branch prefix) making the 7-day supply-chain signal conditionally
  suppressible by sub-agents without a stored IS_PROACTIVE flag.
- Phase 0 Step H Orphaned-Commit Disclosure (+100pp): Added two-part disclosure — a
  note in Step H and a ⚠️ banner in Step I — so users know bumps committed to
  BUMP_BRANCH were discarded when they chose an existing PR.
- CI-Failure Pipeline End-to-End Completeness (+100pp, weight 2×): Completed the
  CI-failure path by adding: (a) a "CI Failures Not Addressed" section to Phase 3's
  impact table when Phase 4 is skipped despite CI failures; (b) an updated Phase 4
  header explicitly listing CI failures as an activation trigger.

**What was dropped and why:** Nothing dropped — all 5 hypotheses confirmed.

**What remains to improve:**
- Composite sits at ~93.5%. The remaining ~6.5pp gap consists primarily of
  architectural moonshot metrics requiring pipeline restructuring.
- Suggested next hypothesis: Phase 8 Step F cleanup instruction says "Repeat for each
  alias in the manifest (merged and skipped alike)" without specifying that a failed
  remote delete should be surfaced in the consolidation summary rather than silently
  ignored by `2>/dev/null || true`.

### Novel Pattern Candidates

H114 used a novel pattern — querying PR comments as a verdict-presence oracle:

```markdown
## Novel Patterns Discovered — 2026-04-22 (Run 028)

### NP4 — Posted-Artifact Presence Check
**Discovered in:** bump-dependencies skill (Phase 8 Step B)
**Problem it solved:** A silent Wave 3 sub-agent failure left an alias with no Phase 5
verdict in the orchestrator's context. The orchestrator had no way to distinguish
"verdict not yet received" from "Phase 5 returned APPROVE" without querying an
external signal.
**Implementation:** Query the PR's posted comments via `gh pr view --json comments`
filtered by the Phase 6 comment prefix. A missing comment means the sub-agent failed
to complete; the alias is skipped rather than silently merged.
**Metrics it improved:** Phase 8 Step B Absent-Verdict Guard (MX117)
**Generalises to:** Any multi-agent workflow where sub-agents post an artifact to a
shared, queryable store (PR comments, a database, a temp file) as a side-effect of
completing their work. The orchestrator uses artifact presence as a completion
signal — treating the store as a fault-detection layer rather than relying solely on
in-context return values.
**Seed candidate:** yes — applicable to any orchestrator-sub-agent pattern where
sub-agents produce queryable external artifacts as completion evidence.
```
