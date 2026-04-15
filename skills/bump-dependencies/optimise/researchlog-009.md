<!-- SUMMARY-START -->
## Run 009 — 2026-04-01 | Target: skills/review-dependency-update/
Composite: 89.3% → 93.3% (+4.0 pp)

### Hypotheses
| ID  | Description                               | Outcome   |
|-----|-------------------------------------------|-----------|
| H33 | Ecosystem Prerequisite Gate in Phase 1    | Confirmed |
| H34 | Wave 3 Return Contract Completeness       | Confirmed |

### Metric Snapshot
| Metric                                | Baseline | Post |
|---------------------------------------|----------|------|
| Ecosystem Prerequisite Gate           | 0        | 100  |
| Sub-Agent Return Contract Completeness| 50       | 100  |
| Composite                             | 89.3%    | 93.3% |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

**Target:** skills/review-dependency-update/
**Files:** 14 total (10 command, 4 support)
**Token estimate:** ~12,700 tokens (slight growth from Run 6 additions)

### Feature Inventory
- Multi-phase pipeline: yes
- Persona system: yes
- Subagent invocations: yes
- Multi-session orchestration: no
- Parallel execution: yes
- Cached artifacts: yes

### Files
**Command files (10):** review-dependency-update.md, p1-parse.md, p1b-split-commits.md, p2-investigate.md, p3-impact.md, p4-remediate.md, p5-verdict.md, p6-comment.md, p7-summary.md, p8-consolidate.md
**Support files (4):** SKILL.md, AGENTS.md, VERSION.md, CHANGELOG.md

### TTL Check
Prior log date 2026-04-01, today 2026-04-01 (same day, Run 7) → Tier C — used as-is.

### Prior Run Summary
Run 5 and Run 6 both closed at 93.0% composite (5,579 / 6,000). Three deliberate-design gaps remain:
- **HTC=95:** one intentional Phase 1b Step D confirmation gate; retained across all six prior runs.
- **CLE=94:** structural overhead from persona file loading in sub-agents; not addressable by instruction change.
- **RI=98:** three `--force-with-lease` explanation instances across p1b, p4, p8; each scoped to its phase context; justified residual.

All other 37 metrics are at 100. Run 6 produced +0.1 pp composite improvement (one measurement correction + real fix that cancelled out). The 7% gap is attributable to the three deliberate design choices above plus potential undiscovered instruction gaps.

### Focus for Run 7
Per user instruction: think creatively about what a real-world agent would fail on when executing this skill for the first time on an unfamiliar repo. Custom metrics only if a genuine unmeasured gap exists. No padding.

### Notes
Persona (Pulse) not found — proceeding without. Log exceeds 15,000-token threshold (estimated ~26,000 tokens) — archival will be performed in Phase 5 after the current run is complete.

---

## Phase 2 — Baseline

**Persona note:** Pulse (Analytics) persona not found. Proceeding without persona.

### Custom Metrics Introduced

### MX26 — Sub-Agent Return Contract Completeness (SARCC) [custom]
**Measures:** Whether each Wave dispatch prompt explicitly instructs sub-agents to include their result data as the final line of their output message, so the orchestrator's primary data-collection path does not silently fall through to the fallback.
**Why seeds miss it:** MX2 (Agent Prompt Completeness) measures whether sub-agents receive all information needed to *execute* their phases. It does not measure whether agents are told what to *return*. A sub-agent that executes Phases 5 and 6 correctly but returns no verdict block defeats the orchestrator's primary collection mechanism — the fallback (`gh pr view --json comments`) adds a network round-trip and can only retrieve posted comments, not pre-posting verdict data.
**Methodology:** For each Wave dispatch prompt template (Wave 1, Wave 3), check whether the prompt includes an explicit instruction to return result data as the final line/block of the agent's output. SARCC = prompts with explicit return instruction / total dispatch prompts.
**Direction:** ↑ higher is better
**Weight:** 1× (reliability of primary path; the fallback makes this a quality gap rather than a failure gap)
**Normalisation:** rate × 100

### MX27 — Ecosystem Prerequisite Gate (EPG) [custom, moonshot]
**Measures:** Whether Phase 1 includes an upfront verification that the required tooling (GitHub CLI `gh`, git) is present, authenticated, and compatible with the target repository's hosting platform, before committing to the GitHub-specific workflow. Borrows from pre-flight checklist methodology in safety-critical systems — any tool whose absence causes systematic failure should be explicitly verified before the procedure begins.
**Why seeds miss it:** No seed metric measures tool prerequisite coverage. Seeds measure instruction clarity and structure — not whether the workflow would fail silently on a system where `gh` is not installed or not authenticated. A first-time agent on a fresh developer machine or a GitLab-hosted project would encounter a cascade of cryptic `gh` errors with no prescribed diagnostic.
**Methodology:** Check Phase 1 Step A for: (a) an explicit check that the remote URL is github.com (or explicitly documents that the skill requires GitHub); (b) a `gh auth status` check (or equivalent) before the first `gh` call; (c) a prescribed stop condition if the prerequisites are not met. EPG = checks present / 3.
**Direction:** ↑ higher is better
**Weight:** 2× (a missing prerequisite gate causes systematic failure on any non-GitHub repo or unauthenticated session; this is a "first-time agent on unfamiliar machine" failure that no other metric captures)
**Normalisation:** rate × 100

### Inherited Scores
All 40 metrics from Run 6 final values are inherited unchanged. New metrics MX26 and MX27 scored fresh.

**MX26 — Sub-Agent Return Contract Completeness:**
- Wave 1 dispatch prompt: "Return your Phase 3 impact table (actionable usages count, advisory count, files affected)." ✓ — explicit return instruction.
- Wave 3 dispatch prompt: "Execute Phases 5 and 6 only. Post your own PR comment at the end." ✗ — no instruction to return the Phase 5 verdict block as final output. The orchestrator's Wave 5 preamble says "require each Wave 3 agent to return its Phase 5 verdict block as the final line of its output message" — but this instruction is addressed to the orchestrator, not to the sub-agents. The agents dispatched by Wave 3 never receive it.
Raw: 1/2. **Normalised: 50.**

**MX27 — Ecosystem Prerequisite Gate:**
- (a) Phase 1 Step A: parses SSH or HTTPS remote URL — no check whether the host is github.com; no note that the skill requires GitHub. ✗
- (b) No `gh auth status` check anywhere in Phase 1. ✗
- (c) No prescribed stop condition if prerequisites are not met. ✗
Raw: 0/3. **Normalised: 0.**

### Full Composite (42 metrics)

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
| Context Decay Resilience | seed | 100 | 2× | 200 |
| Context Loading Efficiency | seed | 94 | 2× | 188 |
| Parallelisation Safety Score | seed | 100 | 1× | 100 |
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
| Pre-Release Version Handling | custom (MX9) | 100 | 1× | 100 |
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
| Sub-Agent Return Contract Completeness | custom (MX26) | 50 | 1× | 50 |
| Ecosystem Prerequisite Gate | custom (MX27) | 0 | 2× | 0 |
| **TOTAL** | | | **63×** | **5,629** |

**Composite: 5,629 / (63 × 100) × 100 = 89.3%**

*(On the 40-metric basis from Run 6, the skill remains at 93.0%. New metrics add 3 weight units at low scores.)*

### Weakest metrics (Phase 3 candidates)
1. Ecosystem Prerequisite Gate — 0 (2× weight) — no GitHub compatibility check, no `gh auth` verification
2. Sub-Agent Return Contract Completeness — 50 (1× weight) — Wave 3 dispatch missing return instruction
3. Human Touchpoint Count — 95 (2× weight) — intentional design gate; deliberate choice retained
4. Context Loading Efficiency — 94 (2× weight) — structural overhead; not addressable by instruction change
5. Redundancy Index — 98 (1× weight) — justified residual cross-file repetition

### Strongest metrics (unchanged)
All 100-scoring metrics from Run 6 remain stable. MX24, MX25 remain at 100.

---

## Phase 3 — Hypotheses

### Step 0 — Pre-Experiment Dependency Scan
H33 modifies p1-parse.md.
H34 modifies review-dependency-update.md.

No overlaps. Proceed in order: H33 → H34.

### H33 — Ecosystem Prerequisite Gate in Phase 1
**Problem observed:** Ecosystem Prerequisite Gate = 0. Phase 1 uses `gh` CLI (GitHub-only) throughout but never checks that the remote is github.com or that `gh` is authenticated. A first-time agent on a GitLab repo or an unauthenticated machine fails silently at the first `gh pr view` call with no prescribed recovery.
**Change proposed:** Add a prerequisite check block to Phase 1 Step A after parsing `owner/repo`: (a) verify the remote URL domain is github.com; (b) run `gh auth status`; (c) stop with a clear advisory if either check fails.
**Targets:** Ecosystem Prerequisite Gate (↑, from 0 to 100)
**Predicted improvement:** MX27 +100pp (2× → +200 weighted points)
**Pattern applied:** novel — Prerequisite Gate
**Risk level:** low
**Risk note:** Additive check only; happy path unchanged.

### H34 — Wave 3 Return Contract Completeness
**Problem observed:** Sub-Agent Return Contract Completeness = 50. The Wave 3 dispatch prompt does not instruct sub-agents to return their Phase 5 verdict block. The orchestrator's primary collection mechanism silently falls to the `gh pr view --json comments` fallback.
**Change proposed:** Add explicit return instruction to the Wave 3 agent dispatch prompt: "Return your Phase 5 verdict block as the final line of your output message before completing."
**Targets:** Sub-Agent Return Contract Completeness (↑, from 50 to 100)
**Predicted improvement:** MX26 +50pp (1× → +50 weighted points)
**Pattern applied:** P1 — Intent Anchor Blocks (extended to sub-agent return contracts)
**Risk level:** low
**Risk note:** Does not affect what agents execute; only what they surface at completion.

### Self-Audit Results
- Intent check: both hypotheses target metrics below 100 ✓
- Coverage check: projected composite ≈ 5,879 / 6,300 = 93.3% — below 95%, but remaining gap (HTC=95, CLE=94, RI=98) is all deliberate design choices with no actionable hypothesis
- Gap fill: all metrics below 80 have a hypothesis ✓

---

## Phase 4 — Experiments

### H33 — Ecosystem Prerequisite Gate in Phase 1
**Pre-change:** MX27 = 0 (no GitHub check, no auth check, no stop conditions)
**Post-change:** MX27 = 100 (3/3 checks present: domain check + stop, `gh auth status` + stop, advisory messages)
**Delta:** MX27 +100pp (2× → +200 weighted points)
**Result:** confirmed
**Notes:** Phase 1 Step A now has a prerequisite check block before the first `gh` call. Non-GitHub remote URLs stop with a host-specific advisory. Unauthenticated sessions stop with the `gh auth login` instruction. Secondary checks: IAR unchanged (all new conditions are scoped); ITE unchanged (no padding); M2 DD unchanged.

### H34 — Wave 3 Return Contract Completeness
**Pre-change:** MX26 = 50 (Wave 1 has return instruction; Wave 3 does not)
**Post-change:** MX26 = 100 (both Wave prompts have explicit return instructions)
**Delta:** MX26 +50pp (1× → +50 weighted points)
**Result:** confirmed
**Notes:** Wave 3 dispatch prompt now ends with "Return your Phase 5 verdict block as the final line of your output message." The orchestrator's Wave 5 collection logic now matches the sub-agent output contract. Secondary checks: no other metrics affected.

## Experiment Summary
- Confirmed: H33, H34
- Partial: (none)
- Disconfirmed: (none)

---

## Phase 5 — Report

| Metric | Baseline (Run 7) | Post | Delta | Status |
|---|---|---|---|---|
| Ecosystem Prerequisite Gate | 0 | 100 | +100 | ↑ |
| Sub-Agent Return Contract Completeness | 50 | 100 | +50 | ↑ |
| **Composite** | **89.3%** | **93.3%** | **+4.0 pp** | |

*Post-composite: (5,629 + 200 + 50) / (63 × 100) × 100 = 5,879 / 6,300 × 100 = 93.3%*

*Note: on the 40-metric basis from Run 6, the skill remains at 93.0%. The new metrics add 3 weight units; both reach 100 post-experiment.*

### What improved and why

- **Ecosystem Prerequisite Gate**: 0 → 100 (+100pp, 2× weight) — Phase 1 Step A now runs a pre-flight check for GitHub hosting and `gh` authentication before any API calls, eliminating silent failures on non-GitHub repos and unauthenticated sessions.
- **Sub-Agent Return Contract Completeness**: 50 → 100 (+50pp) — Wave 3 dispatch prompt now explicitly instructs sub-agents to return their Phase 5 verdict block as final output, closing the gap between what the orchestrator expects to collect and what agents were told to provide.

### What was dropped and why

Nothing was dropped. Both hypotheses confirmed.

### What remains to improve

- **Redundancy Index** — 98. Three `--force-with-lease` explanation instances across p1b, p4, p8. Justified residual; each is scoped to its phase context. Deliberate design choice retained.
- **Context Loading Efficiency** — 94. Structural overhead from persona file loading in sub-agents. Not addressable without changing the execution model.
- **Human Touchpoint Count** — 95. One intentional touchpoint: Phase 1b Step D confirmation gate. Deliberate design choice retained across all seven runs.

### Novel Pattern Candidates

### NP11 — Prerequisite Gate
**Discovered in:** skills/review-dependency-update
**Problem it solved:** A skill that relies on a specific tool (GitHub CLI) and hosting platform (github.com) had no upfront verification that those prerequisites were met. A first-time agent on a non-GitHub repository or unauthenticated machine would fail silently at the first tool call with no diagnostic.
**Implementation:** Phase 1 Step A: verify remote URL is github.com, run `gh auth status`, stop with a plain-language advisory if either check fails.
**Metrics it improved:** Ecosystem Prerequisite Gate (+100pp)
**Generalises to:** Any skill that depends on a specific tool, hosting platform, or authentication context. The principle: a workflow with unavoidable hard dependencies on external tools should verify those dependencies at the entry point, before any other work begins.
**Seed candidate:** yes — proposed as P24 — Prerequisite Gate. Applicable to any skill that: (1) uses a platform-specific CLI (gh, gcloud, aws, etc.), (2) requires authentication, (3) assumes a particular repo host or environment configuration.
