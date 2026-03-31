## Audit — 2026-03-31

**Target:** skills/review-dependency-update/
**Files:** 12 total (8 command, 4 support)
**Token estimate:** ~8,400 tokens

### Feature Inventory
- Multi-phase pipeline: yes
- Persona system: yes
- Subagent invocations: yes
- Multi-session orchestration: no
- Parallel execution: yes
- Cached artifacts: yes (atomic commit manifest written by Phase 1b; read by orchestrator for Wave dispatch)

### Files

**Command files (8):**
- `commands/review-dependency-update.md` — orchestrator / dispatcher (~800 tokens)
- `commands/phases/p1-parse.md` — Phase 1: PR parsing and session brief (~500 tokens)
- `commands/phases/p1b-split-commits.md` — Phase 1b: atomic commit splitting (~1,200 tokens)
- `commands/phases/p2-investigate.md` — Phase 2: changelog + security investigation (~900 tokens)
- `commands/phases/p3-impact.md` — Phase 3: codebase impact mapping (~500 tokens)
- `commands/phases/p4-remediate.md` — Phase 4: remediation commits (~700 tokens)
- `commands/phases/p5-verdict.md` — Phase 5: risk scoring and verdict (~700 tokens)
- `commands/phases/p6-comment.md` — Phase 6: PR comment posting (~300 tokens)

**Support files (4):**
- `SKILL.md` — skill description and overview
- `AGENTS.md` — commit conventions and versioning rules
- `VERSION.md` — current version (1.3.0)
- `CHANGELOG.md` — version history

### Persona References (from orchestrator `review-dependency-update.md`)

Paths declared: `../../personas/<dir>/persona.md` (relative to `commands/`)
Resolved to: `/Users/adjmunro/Developer/agentfiles/skills/personas/<dir>/persona.md`

| Persona | File | Exists? | soul.md? |
|---|---|---|---|
| Echo (Examiner) | `skills/personas/examiner/persona.md` | YES | YES |
| Rook (Adversary) | `skills/personas/adversarial/persona.md` | YES | YES |
| Ink (Commit Curator) | `skills/personas/ink/persona.md` | YES | YES |
| Arden (Critic) | `skills/personas/critic/persona.md` | YES | YES |

All persona references resolve correctly. No broken references.

### Persona Staleness Check
No speciated children detected for any of the four personas (adversarial, examiner, ink, critic). No staleness warnings.

---

## Custom Metrics — 2026-03-31

### MX1 — Changelog Source Coverage (CSC) [custom]
**Measures:** Whether the Kotlin/Android library changelog source table in p2-investigate.md covers the packages most commonly encountered in real projects
**Why seeds miss it:** No seed metric measures whether the workflow's knowledge base (lookup tables) is complete — seeds measure instruction quality, not domain coverage
**Methodology:** Enumerate all library families in the p2 table. Count common Kotlin/Android libraries from established ecosystem lists (AndroidX, Jetpack, Gradle plugins, popular third-party). CSC = covered / (covered + known-missing)
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

### MX2 — Agent Prompt Completeness (APC) [custom]
**Measures:** Whether the sub-agent prompt templates in the orchestrator provide all context needed to execute phases without additional lookups
**Why seeds miss it:** M7 (SAS) checks whether subagent tasks are appropriate, not whether the prompts contain sufficient information. An appropriate but under-specified prompt produces incomplete output.
**Methodology:** For each Wave dispatch prompt template, enumerate all information fields a sub-agent needs to execute its assigned phases (PR context, bump context, navigation, constraints). APC = present fields / required fields
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

### MX3 — Phase File Navigation Completeness (PNC) [custom]
**Measures:** Whether every phase file ends with a correct `→ Next:` directive pointing to the correct next file
**Why seeds miss it:** M1 (IOT) measures whether phases read prior artifacts; it does not check whether phases have forward navigation directives. A phase without a `→ Next:` line silently halts the pipeline.
**Methodology:** Count all phase files (including orchestrator). For each, check: (a) has a `→ Next:` or `→ Done.` line at the bottom, (b) the path/instruction is correct relative to the phase's role. PNC = phases with correct navigation / total phases
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

### MX4 — Verdict Scoring Calibration (VSC) [custom, moonshot]
**Measures:** Internal consistency of the risk scoring matrix — whether tier boundaries are reachable by realistic signal combinations, whether the matrix is symmetric, and whether signal weights are ordered appropriately
**Why seeds miss it:** No seed metric evaluates whether the workflow's *scoring system* is internally consistent. A well-structured instruction can contain a calibration error that the agent will apply faithfully every time.
**Methodology:** Five structural checks: (1) tier ranges contiguous with no gaps; (2) all signals are distinct non-overlapping conditions; (3) minimum/maximum scores per tier reachable by real combinations; (4) major-version-bump-alone calibration (does it land in the correct tier?); (5) presence of risk-reduction signals (symmetry). VSC = passing checks / 5
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

### MX5 — Cross-Bump Context Isolation (CCI) [custom]
**Measures:** Whether per-bump subagents are structurally prevented from contaminating each other's verdicts
**Why seeds miss it:** M11 (PSS) checks for concurrent-write safety; it does not check for context bleed — a situation where Agent A's findings could influence Agent B's verdict even with correct concurrency guards.
**Methodology:** For each isolation boundary in the parallel dispatch design, check whether the mechanism (prompt scoping, file naming, explicit "one bump only" directives, sequential Phase 4) prevents contamination. CCI = isolation mechanisms present / total required isolation points
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

---

## Baseline — 2026-03-31

**Persona note:** Pulse (Analytics) persona not found at expected path (`../../../personas/analytics/persona.md` from optimise phase dir). Proceeding without persona.

Seed metrics applied: Intent-to-Output Traceability, Directive Density, Instruction Ambiguity Rate, Wiring Completeness Score, Redundancy Index, AC Concreteness, Subagent Alignment Score, Human Touchpoint Count, Context Decay Resilience, Context Loading Efficiency, Parallelisation Safety Score, Instruction Token Efficiency, Persona-Phase Fit Score, Persona Richness Score

Seed metrics skipped: Information Freshness Score (M12) — no inter-session artifacts with temporal gap; all artifact hand-offs are intra-session

MX-OQ series: SKIP — no `.kanban/.archive/` in target directory

Pattern series: RPC (P10 not previously applied, but conditional branches exist — evaluated anyway); HCU — SKIP no help file; PEV — SKIP no prior experiments; EIS — SKIP no prior multi-hypothesis sessions

Custom metrics: Changelog Source Coverage (MX1), Agent Prompt Completeness (MX2), Phase File Navigation Completeness (MX3), Verdict Scoring Calibration (MX4), Cross-Bump Context Isolation (MX5)

| Metric | Source | Raw | Normalised | Weight | Weighted |
|---|---|---|---|---|---|
| Intent-to-Output Traceability | seed | 1.0 | 100 | 2× | 200 |
| Directive Density | seed | 2.71 | 100 | 1× | 100 |
| Instruction Ambiguity Rate | seed | 0.0 | 100 | 1× | 100 |
| Wiring Completeness Score | seed | 1.0 | 100 | 1× | 100 |
| Redundancy Index | seed | 0.02 | 98 | 1× | 98 |
| AC Concreteness | seed | 0.82 | 82 | 2× | 164 |
| Subagent Alignment Score | seed | 1.0 | 100 | 1× | 100 |
| Human Touchpoint Count | seed | 1 (interactive) | 95 | 2× | 190 |
| Context Decay Resilience | seed | 0.0 | 0 | 2× | 0 |
| Context Loading Efficiency | seed | 0.93 | 93 | 2× | 186 |
| Parallelisation Safety Score | seed | 1.0 | 100 | 1× | 100 |
| Instruction Token Efficiency | seed | 0.986 | 99 | 1× | 99 |
| Persona-Phase Fit Score | seed | 1.0 | 100 | 1× | 100 |
| Persona Richness Score | seed | 1.0 | 100 | 1× | 100 |
| Recovery Path Completeness | custom (RPC) | 1.0 | 100 | 1× | 100 |
| Changelog Source Coverage | custom (MX1) | 0.48 | 48 | 1× | 48 |
| Agent Prompt Completeness | custom (MX2) | 0.79 | 79 | 1× | 79 |
| Phase File Navigation Completeness | custom (MX3) | 1.0 | 100 | 1× | 100 |
| Verdict Scoring Calibration | custom (MX4) | 0.6 | 60 | 1× | 60 |
| Cross-Bump Context Isolation | custom (MX5) | 0.86 | 86 | 1× | 86 |
| **TOTAL** | | | | **25×** | **2,110** |

**Composite: 2,110 / (25 × 100) × 100 = 84.4%**

### Weakest metrics (Phase 3 candidates)
1. Context Decay Resilience — 0 (2× weight): wave sub-agents receive no intent re-anchor
2. Changelog Source Coverage — 48 (1×): ~15 common Kotlin/Android libraries absent from p2 lookup table
3. Verdict Scoring Calibration — 60 (1×): major-bump-alone scores as Low; no risk-reduction signals; one-directional matrix

### Strongest metrics
1. Intent-to-Output Traceability — 100
2. Directive Density — 100
3. Instruction Ambiguity Rate — 100
4. Wiring Completeness Score — 100
5. Phase File Navigation Completeness — 100

---

## Experiments — 2026-03-31

### H1 — Sub-Agent Intent Re-anchor
**Problem observed:** Context Decay Resilience = 0. Neither Wave 1 nor Wave 3 agent prompts include an instruction to re-read the original session brief before executing phases. Sub-agents dispatched with only bump-level context have no anchor to the PR's original framing if their session drifts.
**Change proposed:** Add a re-anchor instruction to both Wave 1 and Wave 3 dispatch prompt templates in `commands/review-dependency-update.md`. Specifically: prepend "Re-read the session brief (PR metadata: title, author, date, all bumps list) before beginning Phase 2" to Wave 1, and add the same instruction to Wave 3. The session brief from Phase 1 Step E should be referenced as the canonical intent artifact.
**Targets:** Context Decay Resilience (↑, from 0 toward 100)
**Predicted improvement:** CDR +80–90pp (2 session transitions covered by re-anchor instruction → CDR = 2/2 = 100)
**Pattern applied:** P1 — Intent Anchor Blocks
**Risk level:** low
**Risk note:** Adding re-anchor instruction increases per-agent prompt length slightly. If the session brief is not written to a file (it's printed to user only), agents may have no persistent artifact to re-read. Mitigation: also instruct Phase 1 to write the session brief to a temp file.

### H2 — Changelog Table Expansion
**Problem observed:** Changelog Source Coverage = 48. Approximately 15 common Kotlin/Android libraries are absent from the p2 lookup table, including Lifecycle, WorkManager, DataStore, Navigation (library), Firebase, Play Services, Paging, and popular test/utility libraries.
**Change proposed:** Add missing high-frequency library families to the Kotlin/Android primary sources table in `commands/phases/p2-investigate.md`. Target entries: AndroidX Lifecycle, WorkManager, DataStore, Navigation (library), Paging, Accompanist, Firebase (core + Crashlytics + Analytics), Play Services, Glide, MockK, Timber.
**Targets:** Changelog Source Coverage (↑, from 48 to ~75)
**Predicted improvement:** CSC +27pp (11 entries added → 25/29 ≈ 86% → normalised 86; but additional known-missing count may also be revised)
**Pattern applied:** novel — Domain Knowledge Refresh (adding domain-specific lookup entries to keep a knowledge table current)
**Risk level:** low
**Risk note:** Table may grow long; if coverage is too broad, it dilutes the "primary sources" signal. Mitigate by limiting additions to the top-frequency libraries (>50% of real Android projects).

### H3 — Scoring Matrix Symmetry Fix
**Problem observed:** Verdict Scoring Calibration = 60. Two calibration issues: (1) major version bump alone scores as Low risk (max 2 points), which understates the risk of a major bump with no other information; (2) the matrix is one-directional — no signals reduce risk, so a fully-remediated clean upgrade scores the same as an unexamined one.
**Change proposed:** In `commands/phases/p5-verdict.md`, add two changes to the scoring matrix: (a) add a signal "Major version bump with no changelog found" at +3 (differentiated from plain major bump +2 — if the changelog is also unavailable, risk is higher); (b) add a negative signal "All actionable usages fully remediated by Phase 4 (zero skipped)" at −1 (up to a floor of 0). Also add a note clarifying that minor and patch bumps with comprehensive changelogs that show zero breaking changes may use the patch tier for scoring purposes.
**Targets:** Verdict Scoring Calibration (↑, from 60 toward 80)
**Predicted improvement:** VSC +20pp (3 of 5 structural checks pass → 5/5 = 100, but matrix additions add complexity; realistic target: 4/5 = 80)
**Pattern applied:** P6 — Symmetric Outcome Thresholds (extending to include risk-reduction signals alongside risk-increase signals)
**Risk level:** medium
**Risk note:** Adding a negative signal changes the score for existing verdicts. A well-remediated PR could shift from Medium to Low. This is a feature (better calibration), not a bug — but test that the floor is 0 and the reduction is small (−1 max).

### H4 — AC Concreteness: Subjective Qualifiers
**Problem observed:** AC Concreteness = 82. Two vague qualifiers reduce the score: p4 Step C uses "low-risk and well-documented" (subjective), and p2 Pass B uses "relevant to our usage" for bug fixes (subjective).
**Change proposed:** In `commands/phases/p4-remediate.md` Step C, replace "low-risk and well-documented" with a concrete two-part test: "the migration requires changing ≤3 call sites AND the replacement API is documented in the changelog with a code example." In `commands/phases/p2-investigate.md` Pass B, replace "relevant to our usage" for bug fixes with: "a fix for a bug that would affect code in this codebase if it triggered (i.e., the affected API is used, or the bug involves a type/behaviour our code relies on)."
**Targets:** AC Concreteness (↑, from 82 toward 91)
**Predicted improvement:** ACC +9pp (2 vague ACs → concrete: 11/11 = 100; but new language introduces new borderline cases, so target 10/11 = 91)
**Pattern applied:** P7 — Binary Applicability Gates (replacing subjective judgment conditions with concrete measurable tests)
**Risk level:** low
**Risk note:** The ≤3 call-sites threshold for advisory migrations is a heuristic. If a project has 4 call sites that are trivially identical, the agent should still migrate. Add "OR all call sites are structurally identical (copy-paste)" to avoid blocking reasonable migrations.

### H5 — Agent Prompt: Missing Context Fields
**Problem observed:** Agent Prompt Completeness = 79. Three fields are absent from the Wave 1/3 per-bump prompt template: (a) ecosystem label for the bump, (b) PR title (context for verdict framing), (c) cross-bump constraints for this specific bump's alias pair.
**Change proposed:** In `commands/review-dependency-update.md` Wave 1 dispatch prompt template, add: `Ecosystem: <ecosystem>` (from Phase 1 session brief), `PR title: <title>`, and `Cross-bump constraints for this alias: <constraint notes from manifest, or "none">`. Apply the same additions to the Wave 3 prompt.
**Targets:** Agent Prompt Completeness (↑, from 79 toward 93), Cross-Bump Context Isolation (↑, from 86 toward 93)
**Predicted improvement:** APC +14pp; CCI +7pp
**Pattern applied:** novel — Prompt Context Completeness (ensuring all context a sub-agent needs is explicitly included in its dispatch prompt rather than requiring in-session lookups)
**Risk level:** low
**Risk note:** Prompt length increases. Cross-bump constraints may be "none" for most bumps — that's fine; the field should be present even when empty to confirm the agent has been informed of the check result.

### H6 — Session Brief Persistence for Re-anchor
**Problem observed:** H1 proposes a CDR re-anchor but the session brief from Phase 1 is currently only printed to the user (console), not written to a file. A sub-agent cannot re-read a console output from a parent session.
**Change proposed:** In `commands/phases/p1-parse.md` Step E, add an instruction to write the session brief to a temp file: `Write to /tmp/dep-review-<PR-number>-session-brief.md`. In `commands/review-dependency-update.md` Wave 1 and Wave 3 prompts, add: `Re-read /tmp/dep-review-<PR-number>-session-brief.md before beginning your phases.` This makes H1's re-anchor instruction executable rather than aspirational.
**Targets:** Context Decay Resilience (↑, from 0 to 100 — enables H1's re-anchor to be effective), Agent Prompt Completeness (↑, as the brief path provides the re-anchor mechanism)
**Predicted improvement:** CDR +100pp (the re-anchor is now concretely realisable: 2/2 session transitions anchored)
**Pattern applied:** P2 — Staleness TTL Policies (brief file is Tier C — canonical, does not expire for the duration of the PR review session)
**Risk level:** low
**Risk note:** /tmp files may not persist across machine restarts; for long-running reviews this is acceptable (the session is expected to complete in one sitting). Add a note: "If the file is not found (e.g. session was resumed after restart), re-run Phase 1 to regenerate it."

---

## Recommendation Brief

Based on baseline measurement, the following experiments are queued.

1. **Session Brief Persistence** — Phase 1 currently prints the PR summary to the console only; sub-agents dispatched in later waves cannot re-read it. Writing the brief to a temp file and referencing it in dispatch prompts enables all sub-agents to re-anchor to the original PR context, closing the Context Decay Resilience gap (currently 0).

2. **Changelog Table Expansion** — The investigation phase's Kotlin/Android library lookup table covers 14 library families but is missing approximately 15 high-frequency entries (Lifecycle, WorkManager, DataStore, Firebase, etc.). Adding the most common missing entries brings coverage from 48% to approximately 75–86%.

3. **Scoring Matrix Symmetry** — The risk scoring matrix has no risk-reduction signals: a thoroughly-remediated upgrade scores the same as an unexamined one. Adding a small negative signal for fully-remediated PRs and clarifying the major-bump-alone case improves calibration symmetry.

4. **Concrete Advisory Migration Threshold** — Two acceptance criteria use subjective language ("low-risk", "relevant to usage"). Replacing both with concrete measurable tests (call-site count + documented replacement; API-in-use check) improves AC Concreteness.

5. **Agent Prompt Context Fields** — Each per-bump sub-agent's dispatch prompt is missing the ecosystem label, PR title, and its alias's cross-bump constraints. Adding these three fields ensures agents have all context needed without requiring additional lookups.

6. **Sub-Agent Intent Re-anchor** — (Enabled by experiment 1) Once the session brief is persisted to a file, adding a re-read instruction to Wave 1 and Wave 3 dispatch prompts brings Context Decay Resilience from 0 to 100.

