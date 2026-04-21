<!-- SUMMARY-START -->
## Run 027 — 2026-04-22 | Target: skills/bump-dependencies/

Composite: 89.4% → 93.2% (+3.8 pp)

### Hypotheses
| ID   | Description | Outcome |
|------|-------------|---------|
| H108 | Add zero-alias guard to Phase 7 preamble | Confirmed |
| H109 | Add secondary IS_PROACTIVE confirmation (Phase 7 + Phase 8) | Confirmed |
| H110 | Add branch-position verification to Phase 8 Step E before force-push | Confirmed |
| H111 | Add remediation hash collection instruction to Wave 2 | Confirmed |
| H112 | Persist cross-bump check result to manifest and Phase 5 scoring | Confirmed |

### Metric Snapshot
| Metric | Baseline | Post |
|--------|----------|------|
| Phase 7 Preamble Zero-Alias Coverage (MX111) | 0 | 100 |
| IS_PROACTIVE Secondary Confirmation Coverage (MX112) | 0 | 100 |
| Phase 8 Step E Branch-Position Verification (MX113) | 0 | 100 |
| Wave 2 Remediation Hash Collection Instruction (MX114) | 0 | 100 |
| Phase 1b Cross-Bump Check Result Persistence (MX115) | 0 | 100 |
| Composite | 89.4% | 93.2% |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

**Target:** `skills/bump-dependencies/`
**Files:** 41 total (11 command, 4 support, 26 optimise logs)
**Token estimate:** ~24,000 tokens (instruction files only)

### Cross-Run Context (from researchlog-026.md)

Previous composite: 89.0% → 93.0% (+4.0pp, 126 metrics, 152×)
H103–H107: all Confirmed — excluded from this run.
H1–H107: all confirmed or disconfirmed across runs 001–026. Excluded from this run.

Run 026 performed a fresh full read of all 11 command files and targeted 5 gaps:
partial-pending CI state (H103), push_failed PR description visibility (H104),
manifest persistence (H105), commit message data boundary (H106), and 7-day
supply-chain signal for PR-review mode (H107). All confirmed.

### Feature Inventory
Unchanged from Runs 024–026.
- Multi-phase pipeline: yes (11 phases)
- Persona system: yes (Ink, Echo, Rook, Arden — 4 personas)
- Subagent invocations: yes (Wave 1 and Wave 3 — parallel per-alias agents)
- Multi-session orchestration: yes (/tmp session brief + manifest + consolidation summary)
- Parallel execution: yes (Wave 1 and Wave 3 concurrent per-alias agents)
- Cached artifacts: yes (session brief, manifest, consolidation summary)

### Persona Staleness Check
All 4 personas confirmed present and current per Run 025. No broken references.

### Excluded from this run
H1–H107: all confirmed or disconfirmed across runs 001–026. See respective run logs.

### Files
Command (11): bump-dependencies.md, p0-bump.md, p1-parse.md, p1b-split-commits.md,
  p2-investigate.md, p3-impact.md, p4-remediate.md, p5-verdict.md, p6-comment.md,
  p7-summary.md, p8-consolidate.md
Support (4): SKILL.md, AGENTS.md, VERSION.md, CHANGELOG.md
Optimise logs (26): researchlog-001 through researchlog-026

### Structural Gaps Identified (Full Audit)

1. **Phase 7 preamble — no case for zero aliases reviewed.**
   Phase 7's opening section has three implicit cases: (1) exactly one alias reviewed
   with integration tests passing, (2) exactly one alias reviewed with integration tests
   failing, and (3) two or more aliases. When ALL aliases were blocked or had push
   failures (zero aliases reviewed), no case applies. The "two or more" path would
   fire if the manifest had multiple entries, causing Phase 7 to post a summary comment
   to a potentially already-closed proactive PR — Phase 8 already posted a closing
   comment in that scenario. The redundant post is not harmful but produces confusing
   output: a full summary comment on a closed PR whose Phase 8 closing comment already
   covered the blocking reasons.

2. **IS_PROACTIVE detection relies on title alone — no secondary confirmation.**
   Phase 7 Step A and Phase 8 Steps B and E.1 all derive `IS_PROACTIVE` from a single
   signal: PR title starts with `chore(deps): bump outdated dependencies`. Phase 0 sets
   this title format, but it can also be set manually. If a human creates a PR with this
   title format against a non-`deps/auto-bump-` branch, `IS_PROACTIVE=true` would be
   incorrectly set. In Phase 8 Step B (all-skipped path), an incorrect `IS_PROACTIVE`
   would cause the skill to close and delete the branch of a human-authored PR. This is
   a correctness risk, not just a documentation gap. Phase 0 always creates the branch
   with the prefix `deps/auto-bump-<date>` — that branch name is a reliable secondary
   signal available via `gh pr view --json headRefName` and is already fetched in the
   all-skipped path check.

3. **Phase 8 Step E — no branch-position verification before force-push.**
   Phase 8 Step D (bisect on integration test failure) checks out individual merge
   commits in a loop, then returns to `<head-branch>` before continuing. Step E then
   force-pushes `origin <head-branch>`. If Step D's final `git checkout <head-branch>`
   was missed or failed silently, Step E's `git push --force-with-lease origin
   <head-branch>` would run from a detached HEAD, causing the push to fail or (in edge
   cases) push the wrong commit. Phase 8 Step A has an explicit verification pattern:
   `git branch --show-current` followed by a hard stop if the result is unexpected.
   Step E has no equivalent check before the force-push.

4. **Wave 2 section — no explicit instruction to collect remediation hashes for Wave 3.**
   The orchestrator's Wave 2 section runs Phase 4 sequentially for each bump and then
   dispatches Wave 3 agents. The Wave 3 agent prompt template includes the placeholder
   `Phase 4 remediation commits for your bump: <comma-separated hashes, or "none">`.
   The Wave 2 section does not include an explicit instruction to record and accumulate
   each alias's Phase 4 remediation commit hashes during the sequential execution, for
   use in Wave 3 dispatch. The data is in the orchestrator context (Phase 4 Step E
   Remediation Summary includes commit hashes), but without an explicit instruction,
   orchestrators running long Wave 2 sequences may lose or skip this accumulation step,
   producing `none` for all aliases even when remediations were applied.

5. **Phase 1b Step G — cross-bump compatibility check result not persisted.**
   Phase 1b Step G verifies known version-constraint relationships (e.g., Kotlin + KSP
   major.minor must match, AGP + Kotlin compatibility). The check result (pass/fail,
   violated pairs) is not written to the manifest or session brief. Each alias's entry
   in the manifest carries `cross_bump_constraints` (the constraint definition) but no
   `cross_bump_check_result`. If a constraint violation is detected, the finding lives
   only in the orchestrator's context — it does not propagate to per-bump agents in
   Wave 1 or Phase 5's scoring. An incompatible Kotlin/KSP pair would produce a build
   failure eventually (surfaced in CI), but Phase 5 has no prescribed signal for "a
   cross-bump constraint was violated at Phase 1b time." The compatibility check is a
   proactive quality gate whose results are discarded rather than routed downstream.

---

## Phase 2 — Baseline

Re-read run log Phase 1 — confirmed: target `skills/bump-dependencies/`, 11 command files,
five structural gaps identified.

### Inherited Metrics
All 126 metrics from Run 026 carry forward at post-experiment values.
Inherited weighted sum: ~14,125 (152×)
(Run 026 post composite: 93.0%)

### Custom Metric Discovery — New Metrics (MX111–MX115)

**Prior run log check**: scanned run logs for `### MX` sections. MX1–MX110 already
defined across runs 001–026. MX111+ available for new definitions.

---

### MX111 — Phase 7 Preamble Zero-Alias Coverage [custom]
**Measures:** Whether Phase 7's preamble has an explicit case for "zero aliases reviewed"
(all aliases blocked or push-failed), preventing the skill from posting a redundant summary
comment to a closed proactive PR that Phase 8 already handled.
**Why seeds miss it:** M6 ACC measures concreteness of acceptance criteria but not
completeness of case coverage in conditional dispatch logic. M3 IAR catches ambiguous
modals but not missing branches. The gap is structural: the preamble handles 1 and ≥2
aliases, but the 0-alias case (all-blocked) is unhandled and falls into the ≥2 path.
**Methodology:** Inspect p7-summary.md preamble. Check whether an explicit "zero aliases
reviewed" case is present before the "exactly one alias" case. Current state: no such
case. The preamble jumps from "single alias" to "two or more" — zero is not handled.
Raw: 0/1 (no zero-alias case).
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** zero_alias_case_present × 100
**Score: 0**

---

### MX112 — IS_PROACTIVE Secondary Confirmation Coverage [custom]
**Measures:** Whether the IS_PROACTIVE detection in Phase 7 Step A, Phase 8 Step B
(all-skipped path), and Phase 8 Step E.1 has a secondary confirmation beyond PR title
match — specifically, whether the PR's head branch name starts with `deps/auto-bump-`
(the branch prefix Phase 0 always creates).
**Why seeds miss it:** M11 PSS covers parallel mutation guards but not single-signal
detection correctness. No seed metric measures whether a binary flag derived from a
single data source has a secondary confirmation. This is a correctness gap with
consequence: incorrect IS_PROACTIVE=true in Phase 8 Step B would close a human-authored
PR and delete its branch.
**Methodology:** Inspect p7-summary.md Step A, p8-consolidate.md Step B all-skipped path,
and p8-consolidate.md Step E.1. Check whether each occurrence of IS_PROACTIVE detection
uses both title AND branch name. Current state: all three locations use title only.
Raw: 0/3 sites updated → 0/1 (all sites must be updated for full credit).
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** all_sites_updated × 100
**Score: 0**

---

### MX113 — Phase 8 Step E Branch-Position Verification Before Force-Push [custom]
**Measures:** Whether Phase 8 Step E (force-push the PR head branch) includes an explicit
`git branch --show-current` verification that the local repository is on `<head-branch>`
before running `git push --force-with-lease`, analogous to the verification in Step A.
**Why seeds miss it:** M9 CDR measures session re-anchor but not within-phase safety
checks. M6 ACC measures stop conditions but not pre-action state verification steps.
The gap is that Step D (bisect) can leave the repo in a detached HEAD state, and Step E
has no guard against running a force-push from that state.
**Methodology:** Inspect p8-consolidate.md Step E. Check whether a `git branch
--show-current` verification exists before the `git push --force-with-lease` command.
Current state: no such verification. Step E proceeds directly to push. Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** verification_present × 100
**Score: 0**

---

### MX114 — Wave 2 Remediation Hash Collection Instruction [custom]
**Measures:** Whether the orchestrator's Wave 2 section explicitly instructs the
orchestrator to record each alias's Phase 4 remediation commit hashes during sequential
execution, for subsequent use in Wave 3 agent dispatch (the `Phase 4 remediation commits
for your bump` field in the Wave 3 agent prompt).
**Why seeds miss it:** M1 IOT measures whether phases re-read prior artifacts, but the
gap here is that the accumulation instruction is missing from the orchestrator, not from
a phase file. M9 CDR measures session re-anchoring, not within-wave data collection.
The gap is orchestration-level: data produced in Wave 2 (Phase 4 commit hashes) is
consumed in Wave 3 dispatch but the handoff instruction is absent.
**Methodology:** Inspect bump-dependencies.md Wave 2 section. Check whether an explicit
instruction exists to collect and record Phase 4 remediation commit hashes per alias
after each sequential Phase 4 run. Current state: Wave 2 says "run Phase 4 in manifest
order" but does not say "record remediation commit hashes for Wave 3 dispatch."
Raw: 0/1.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** collection_instruction_present × 100
**Score: 0**

---

### MX115 — Phase 1b Cross-Bump Check Result Persistence [custom, moonshot]
**Measures:** Whether Phase 1b Step G's cross-bump compatibility check result (pass/fail,
list of violated pairs) is written to the atomic commit manifest and/or session brief, so
that per-bump Wave 1 agents and Phase 5 scoring can act on it — specifically, whether
Phase 5's scoring matrix has a signal for "cross-bump constraint violation detected at
Phase 1b."
**Why seeds miss it:** M12 IFS measures freshness for existing persisted artifacts, but
this gap is that the check result is never persisted at all. No seed metric measures
whether a within-phase quality gate result is routed downstream. The moonshot: treating
the cross-bump compatibility check as a first-class scorable signal rather than a silent
discard — borrowing the concept of "gate result propagation" from CI systems (where test
results are attached to the artifact that triggered them, not discarded after the check).
**Methodology:** Part A — inspect p1b-split-commits.md Step G. Check whether an explicit
instruction exists to write the check result to the manifest (e.g., as a
`cross_bump_check_result` field) or session brief. Current state: Step G verifies
constraints but produces no persistent output. Raw for Part A: 0/1.
Part B — inspect p5-verdict.md scoring matrix. Check whether a row exists for
"cross-bump constraint violation detected at Phase 1b." Current state: no such row.
Raw for Part B: 0/1.
Full credit (100) requires both parts to be present.
**Direction:** ↑ higher is better
**Weight:** 2×
**Normalisation:** (part_a_present + part_b_present) / 2 × 100
**Score: 0**

---

### New Metrics This Run

| Metric | Raw | Normalised | Weight | Weighted |
|--------|-----|-----------|--------|----------|
| Phase 7 Preamble Zero-Alias Coverage (MX111) | 0/1 | 0 | 1× | 0 |
| IS_PROACTIVE Secondary Confirmation Coverage (MX112) | 0/3 | 0 | 1× | 0 |
| Phase 8 Step E Branch-Position Verification (MX113) | 0/1 | 0 | 1× | 0 |
| Wave 2 Remediation Hash Collection Instruction (MX114) | 0/1 | 0 | 1× | 0 |
| Phase 1b Cross-Bump Check Result Persistence (MX115) | 0/2 | 0 | 2× | 0 |

### Full Composite (131 metrics)

```
Inherited weighted sum: ~14,125 (152×)
New metrics weighted sum: 0 + 0 + 0 + 0 + 0 = 0 (6×)
Total: ~14,125 / 15,800 (158×)

Composite: ~14,125 / 15,800 × 100 = ~89.4%
```

*(Drop of 3.6pp from scope expansion: 6 new weight units, all scored 0.)*

### Weakest Metrics (Phase 3 candidates)
1. MX115 — Phase 1b Cross-Bump Check Result Persistence: 0 (2×) — moonshot/critical
2. MX111 — Phase 7 Preamble Zero-Alias Coverage: 0 (1×)
3. MX112 — IS_PROACTIVE Secondary Confirmation Coverage: 0 (1×)
4. MX113 — Phase 8 Step E Branch-Position Verification: 0 (1×)
5. MX114 — Wave 2 Remediation Hash Collection Instruction: 0 (1×)

---

## Phase 3 — Hypotheses

Re-read run log Phase 2 — confirmed weakest: MX111–MX115 all at 0.

### Step 0 — Pre-Experiment Dependency Scan

File targets per hypothesis:
- H108 → p7-summary.md (preamble)
- H109 → p7-summary.md (Step A) + p8-consolidate.md (Steps B and E.1)
- H110 → p8-consolidate.md (Step E)
- H111 → bump-dependencies.md (Wave 2 section)
- H112 → p1b-split-commits.md (Step G) + p5-verdict.md (scoring matrix)

Overlaps:
- H108 and H109 both modify p7-summary.md → run sequentially with re-check between them.
- H109 and H110 both modify p8-consolidate.md → run sequentially with re-check.

Execution order: H108 → H109 → (re-check p7 and p8) → H110 → H111 → H112.
(H110, H111, H112 are independent of each other but H110 shares file with H109 — run H110 after H109.)

---

### H108 — Add zero-alias guard to Phase 7 preamble

**Pre-change:** MX111 = 0 (no zero-alias case in preamble)

*(Change applied — see p7-summary.md)*

**Post-change:** MX111 = 100 (zero-alias case added before single-alias case)
**Delta:** MX111 +100pp
**Result:** confirmed
**Notes:** Added an explicit "zero aliases reviewed" case at the top of the preamble,
directing to skip Steps B and C (no summary comment) for both proactive and external PRs.
For proactive PRs, Phase 8 already posted a closing comment; for external PRs, only
Step D (user report) runs. No interaction with existing single-alias or multi-alias paths.

---

### H109 — Add secondary IS_PROACTIVE confirmation

**Pre-change:** MX112 = 0 (title-only detection at all 3 sites)

*(Change applied — see p7-summary.md Step A, p8-consolidate.md Steps B and E.1)*

**Post-change:** MX112 = 100 (all 3 sites use title AND headRefName)
**Delta:** MX112 +100pp
**Result:** confirmed
**Notes:** Updated all three IS_PROACTIVE detection sites to fetch `headRefName` alongside
`title` and require both conditions. The guard is now: title starts with `chore(deps):
bump outdated dependencies` AND head branch starts with `deps/auto-bump-`. Purely additive
for correctly-formed proactive PRs. The change prevents Phase 8 Step B from closing a
human-authored PR whose title happens to match the proactive format.

---

### H110 — Add branch-position verification to Phase 8 Step E

**Pre-change:** MX113 = 0 (no branch check before force-push)

*(Change applied — see p8-consolidate.md Step E)*

**Post-change:** MX113 = 100 (branch-position check added before force-push)
**Delta:** MX113 +100pp
**Result:** confirmed
**Notes:** Added `git branch --show-current` verification before the `git push --force-with-lease`
command in Step E, with an explicit stop-and-report instruction if the output is not `<head-branch>`
(including empty string for detached HEAD). This mirrors the existing Step A guard pattern.

---

### H111 — Add remediation hash collection instruction to Wave 2

**Pre-change:** MX114 = 0 (no accumulator instruction in Wave 2)

*(Change applied — see bump-dependencies.md Wave 2 section)*

**Post-change:** MX114 = 100 (explicit accumulator instruction added)
**Delta:** MX114 +100pp
**Result:** confirmed
**Notes:** Added a post-Phase-4 accumulation step to Wave 2: after each Phase 4 run,
extract remediation commit hashes from the Remediation Summary (Step E) and record them
in a named accumulator keyed by alias. The accumulator is explicitly referenced as the
source for the Wave 3 dispatch `Phase 4 remediation commits for your bump` field.

---

### H112 — Persist cross-bump check result to manifest and Phase 5 scoring

**Pre-change:** MX115 = 0 (check result not persisted; no Phase 5 signal)

*(Change applied — see p1b-split-commits.md Step G and Step H, p5-verdict.md)*

**Post-change:** MX115 = 100 (Part A: manifest + session brief write added; Part B: Phase 5 scoring row added)
**Delta:** MX115 +100pp (× 2 weight = +200 weighted)
**Result:** confirmed
**Notes:** Three-part change:
1. p1b-split-commits.md Step G: added instruction to record `cross_bump_check_result`
   and `violated_constraints` at the end of the check, appending to both the manifest
   and the session brief (with fallback if the brief write fails).
2. p1b-split-commits.md Step H: extended the per-entry manifest schema to include the
   two new fields.
3. p5-verdict.md: added scoring row `+3` for `violation_detected` cross-bump result,
   with a note distinguishing it from `unverified` (advisory only) and `n/a` (no signal).

---

### Re-check after H109 and H110 (shared file p8-consolidate.md)

Both changes target different locations in p8-consolidate.md (Steps B and E.1 for H109,
Step E for H110). No interaction detected. MX112 and MX113 both score 100 post-change.

Re-check after H108 and H109 (shared file p7-summary.md):
H108 targets the preamble, H109 targets Step A. No interaction detected. MX111 and
MX112 both score 100 post-change.

---

## Experiment Summary
- Confirmed: H108, H109, H110, H111, H112
- Partial: none
- Disconfirmed: none

---

## Phase 5 — Report

### Final Results — 2026-04-22

| Metric | Baseline | Post | Delta | Status |
|--------|----------|------|-------|--------|
| Phase 7 Preamble Zero-Alias Coverage (MX111) | 0 | 100 | +100 | ↑ |
| IS_PROACTIVE Secondary Confirmation Coverage (MX112) | 0 | 100 | +100 | ↑ |
| Phase 8 Step E Branch-Position Verification (MX113) | 0 | 100 | +100 | ↑ |
| Wave 2 Remediation Hash Collection Instruction (MX114) | 0 | 100 | +100 | ↑ |
| Phase 1b Cross-Bump Check Result Persistence (MX115) | 0 | 100 | +100 | ↑ |
| **Composite** | **89.4%** | **93.2%** | **+3.8 pp** | |

Calculation:
- Inherited weighted sum: ~14,125 (152×)
- New metrics post sum: 100+100+100+100+(100×2) = 600 (6×)
- Total post: ~14,725 / 15,800 × 100 = ~93.2%

**What improved and why:**
- Phase 7 Preamble Zero-Alias Coverage (+100pp): Added an explicit zero-alias case at
  the top of Phase 7's preamble, preventing a redundant summary comment when Phase 8
  already handled the all-blocked outcome.
- IS_PROACTIVE Secondary Confirmation Coverage (+100pp): Extended IS_PROACTIVE detection
  at all three sites (Phase 7 Step A, Phase 8 Steps B and E.1) to require both title and
  branch name, preventing Phase 8 from closing a human-authored PR that happens to use the
  proactive title format.
- Phase 8 Step E Branch-Position Verification (+100pp): Added a `git branch --show-current`
  check before the force-push in Step E, mirroring Step A's pattern and guarding against
  force-pushing from detached HEAD after bisect.
- Wave 2 Remediation Hash Collection Instruction (+100pp): Added explicit accumulator
  instruction to Wave 2 so remediation commit hashes are reliably passed to Wave 3 agents.
- Phase 1b Cross-Bump Check Result Persistence (+100pp, weight 2×): Persisted the
  cross-bump compatibility check result to the manifest and session brief, and added a
  Phase 5 scoring signal (+3 for `violation_detected`), routing a proactive quality gate's
  findings into the review verdict.

**What was dropped and why:** Nothing dropped — all 5 hypotheses confirmed.

**What remains to improve:**
- The composite sits at ~93.2%. The ~7pp gap consists of moonshot architectural metrics
  (MX34, MX38, MX43, MX49, MX78) and measurement noise in estimated seed metrics.
- Suggested next hypothesis: Phase 0 Step H "user chooses existing PR" path discards
  the new bumps from the current run (commits orphaned on the deleted BUMP_BRANCH). The
  instruction says "proceed directly to Step I without further bumps" but does not
  explicitly note that new bumps are discarded. A user choosing the existing PR may
  expect the new bumps to be included — an explicit notice would close this expectation gap.

### Novel Pattern Candidates

The H112 "Downstream Result Propagation" hypothesis used a novel pattern:

```markdown
## Novel Patterns Discovered — 2026-04-22 (Run 027)

### NP3 — Downstream Result Propagation
**Discovered in:** bump-dependencies skill
**Problem it solved:** A within-phase quality gate (Phase 1b Step G cross-bump
compatibility check) produced a pass/fail result but discarded it immediately.
Downstream phases (Phase 5 scoring) had no signal for a violation that was detected
at check time.
**Implementation:** Extended the quality gate instruction to write its result to the
manifest (per-alias field) and session brief (aggregate section), then added a
corresponding Phase 5 scoring row that reads from the manifest field.
**Metrics it improved:** Phase 1b Cross-Bump Check Result Persistence (MX115)
**Generalises to:** Any workflow where a quality gate or validation check produces a
result that is used only locally and then discarded. The pattern applies whenever:
(a) a check runs in an early phase, (b) its result would inform a later phase's
scoring or routing, and (c) no durable artifact carries the result between phases.
Treating gate results as first-class artifacts — written to a manifest or shared
brief — makes multi-phase workflows more resilient to context loss and enables
downstream attribution of findings.
**Seed candidate:** yes — applicable to any multi-phase workflow with early
validation gates whose results are consumed downstream.
```
