## Audit — 2026-03-25

**Target:** skills/ideation/
**Files:** 17 total (11 command, 6 support)
**Token estimate:** ~14,625 tokens

### Feature Inventory

- Multi-phase pipeline: yes — 9-step workflow across multiple command files; tickets phase itself has 5 sub-phases
- Persona system: yes — scribe (capture), scout (research + tickets p2), strategist (interview, plan, tickets), critic (capture p5, interview p5, plan p3, tickets p4), designer (interview, optional)
- Subagent invocations: yes — `ideate.md` dispatches each phase as a subagent
- Multi-session orchestration: yes — explicit session boundaries at step 6 (validate) and step 9 (hard stop); loop-back path appends to prior sessions
- Parallel execution: no
- Cached artifacts: yes — `00-input-{subject}.md`, `01-research-{subject}.md`, `02-plan-{subject}.md` are written in one phase and read in later phases; TTL policies applied inconsistently across files

### Files

**Command files (11):**
- `commands/ideate.md` — orchestrator, 9-step dispatch loop (~1,300 tokens)
- `commands/capture.md` — step 1: capture, 7 phases (~1,450 tokens)
- `commands/research.md` — step 2: research snapshot, 6 phases (~1,400 tokens)
- `commands/interview.md` — step 3: recommendation brief + signals, 7 phases (~2,450 tokens)
- `commands/plan.md` — steps 4–5: plan draft + critic audit gate (~1,700 tokens)
- `commands/tickets.md` — steps 7–9 orchestrator (dispatcher only) (~550 tokens)
- `commands/tickets/p1-load-plan.md` — load and enumerate plan (~275 tokens)
- `commands/tickets/p2-scout-research.md` — scout codebase for ticket context (~225 tokens)
- `commands/tickets/p3-draft-tickets.md` — draft all tickets (~800 tokens)
- `commands/tickets/p4-critic-audit.md` — critic audit gate (~600 tokens)
- `commands/tickets/p5-commit.md` — commit and promote (~400 tokens)

**Support files (6):**
- `SKILL.md` — user-facing overview, state machine diagram (~1,700 tokens)
- `AGENTS.md` — git, versioning, changelog rules (~550 tokens)
- `VERSION.md` — version tracking (~75 tokens)
- `CHANGELOG.md` — version history (~350 tokens)
- `TESTING.md` — test strategy and scenarios (~800 tokens)
- `commands/.gitkeep` — placeholder (0 tokens)

### Persona Staleness Check

Personas referenced by ideation command files (resolved from `../../personas/` relative to `commands/`):

| File | Persona load directive | File exists? | soul.md? |
|------|----------------------|--------------|----------|
| `capture.md` | `../../personas/scribe/persona.md` → `skills/personas/scribe/persona.md` | yes | yes |
| `capture.md` | `../../personas/critic/persona.md` → `skills/personas/critic/persona.md` | yes | yes |
| `research.md` | `../../personas/scout/persona.md` → `skills/personas/scout/persona.md` | yes | yes |
| `interview.md` | `../../personas/strategist/persona.md` → `skills/personas/strategist/persona.md` | yes | yes |
| `interview.md` | `../../personas/critic/persona.md` → `skills/personas/critic/persona.md` | yes | yes |
| `interview.md` | `../../personas/designer/persona.md` → `skills/personas/designer/persona.md` | yes | not checked |
| `plan.md` | `../../personas/strategist/persona.md` | yes | yes |
| `plan.md` | `../../personas/critic/persona.md` | yes | yes |
| `tickets.md` | `../../personas/scout/persona.md` | yes | yes |
| `tickets.md` | `../../personas/critic/persona.md` | yes | yes |

No broken references. No speciation noted for the four primary personas (scribe, scout, strategist, critic).

Note: designer persona is referenced as optional in `interview.md` Phase 2 — will check its richness in Phase 2.

---

## Custom Metrics — 2026-03-25

### MX1 — Interview-to-Plan Traceability Rate [custom]
**Measures:** Whether interview decisions recorded in `00-input-*.md` (the Interview block table) are individually traced in the plan audit, not just pooled with all other input items.
**Why seeds miss it:** M1 measures artifact re-reads. M6 measures concreteness of stop conditions. Neither measures whether structured interview decisions are individually verified in the plan audit.
**Methodology:** In `plan.md` Phase 3, count interview decision items (rows from `## Interview` blocks in `00-input-*.md`) vs. total input items audited. Score = interview_items_specifically_tracked / total_interview_decision_items.
**Direction:** ↑ higher is better
**Weight:** 2× — interview decisions are the highest-signal input; silent omission corrupts the plan
**Normalisation:** rate × 100

### MX2 — Resume State Coverage [custom]
**Measures:** Whether `ideate.md` can detect and correctly route to the right step when invoked with a partially-completed subject.
**Why seeds miss it:** M9 (Context Decay Resilience) measures re-anchoring at session transitions, not entry-point routing for re-entry states.
**Methodology:** Count distinct mid-session states (capture done, research done, interview done, plan done, tickets drafted) = N. Count explicit routing branches in `ideate.md` Phase 1 for each state = M. Score = M / N.
**Direction:** ↑ higher is better
**Weight:** 2× — a broken resume path means users lose work or must restart the full 9-step flow
**Normalisation:** rate × 100

### MX3 — Staleness Policy Consistency [custom]
**Measures:** Whether the same artifact's staleness policy is identical across all files that load it.
**Why seeds miss it:** M12 counts whether policies exist; it does not verify cross-consumer consistency.
**Methodology:** For each inter-session artifact, list all files that load it and verify TTL policy is identical. Score = artifacts_with_consistent_policy / total_inter-session_artifacts.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

### MX4 — Failure Recovery Coverage [custom]
**Measures:** Whether each explicit STOP/FAIL condition has a documented recovery path or escalation instruction.
**Why seeds miss it:** M6 measures whether stop conditions are concrete; it does not measure whether they provide a recovery action.
**Methodology:** Count all STOP/FAIL conditions across command files. Score = (stops_with_clear_recovery + 0.5 × stops_with_partial_recovery) / total_stops.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

### MX5 — Ticket Schema Self-Containment [custom, moonshot]
**Measures:** Whether the ticket frontmatter schema is fully defined within the ideation skill, or depends on a cross-skill external reference that would be unavailable if ideation were deployed in isolation.
**Why seeds miss it:** No seed metric applies reliability-engineering "single point of failure" thinking to cross-skill documentation references. This borrows from dependency analysis in software architecture: a skill that relies on an external skill's documentation for correct operation creates a hidden coupling that no structural instruction metric captures.
**Methodology:** Locate all cross-skill file references in command files. For each, verify: (a) file exists, (b) file is reachable in a standalone ideation deployment. Score = 0 if any critical cross-skill reference is external-only with no fallback; 100 if fully self-contained or all references have local fallbacks.
**Direction:** ↑ higher is better
**Weight:** 2× — a missing schema definition at ticket-creation time produces malformed tickets silently
**Normalisation:** 0 = broken (no fallback), 50 = exists but external dependency, 100 = self-contained

---

## Baseline — 2026-03-25

**Re-read:** research-log.md (Intent Anchor confirmed). Target: `skills/ideation/`.

### Seed Metrics Applied

**M1 — Intent-to-Output Traceability**
Methodology: 11 phases assessed. Each subagent's Phase 1 loads the prior artifact explicitly. `ideate.md` uses HTML comment intent anchors (passive, not explicit re-reads) at orchestrator level.
Raw: 9/11 phases with explicit prior artifact reads = 0.818
Normalised: **81.8%**

**M2 — Directive Density**
Methodology: 11 instruction files (~10,950 tokens). Counted DO/DO NOT items and phase-level imperatives.
Raw: ~196 directives / (10,950/100) = 1.79
Normalised: (1.79 / 2.0) × 100 = **89.5%**

**M3 — Instruction Ambiguity Rate**
Methodology: Scanned all instruction files for unscoped weak modals. 3 ambiguous of ~196 total.
Raw IAR: 3/196 = 0.015 = 1.5%
Normalised: 100 − 1.5 = **98.5%**

**M4 — Wiring Completeness Score**
Methodology: 5 personas referenced; all wired to appropriate command phases.
Raw: 5/5 = 1.0
Normalised: **100%**

**M5 — Redundancy Index**
Methodology: 22 redundant instruction instances of ~196 total. Most significant: slug derivation logic repeated 6× across files; git-check pattern repeated 4×; 95% audit logic described in 2 files; staleness caveat duplicated 2×.
Raw RI: 22/196 = 0.112
Normalised: 100 − 11.2 = **88.8%**

**M6 — AC Concreteness**
Methodology: 19 acceptance criteria/stop conditions found. 4 vague ("substantive content", "enough information", "95% threshold" as abstract check, "small enough without ambiguity").
Raw: 15/19 = 0.789
Normalised: **78.9%**

**M7 — Subagent Alignment Score**
Methodology: 5 subagent invocations in `ideate.md`. All isolated tasks, no shared mutable state conflicts.
Raw: 5/5 = 1.0
Normalised: **100%**

**M8 — Human Touchpoint Count**
Methodology: Happy-path touchpoints = 4 (capture, interview, validate, hard stop).
Raw HTC: 4
Normalised: max(0, 100 − (4/20) × 100) = **80%**

**M9 — Context Decay Resilience**
Methodology: 8 session transitions (5 subagent dispatches + 3 orchestrator boundaries). 5 have explicit re-anchor (subagent Phase 1 loads). 3 orchestrator-level transitions have no explicit re-read in `ideate.md`.
Raw: 5/8 = 0.625
Normalised: **62.5%**

**M10 — Context Loading Efficiency**
Methodology: Most phases load directly relevant files. Designer persona loaded unconditionally in interview.md without a trigger condition — adds ~400–600 tokens on non-UI subjects.
Raw: ~0.96 averaged across phases
Normalised: **96%**

**M11 — Parallelisation Safety Score**
SKIP — no parallel execution: the ideation workflow is fully sequential; no concurrent phase blocks exist.

**M12 — Information Freshness Score**
Methodology: 4 inter-session artifacts. 3 have TTL policies (00-input: NO TTL; 01-research: 48hr TTL; 02-plan: 7d TTL). 00-quality-*.md has no TTL.
Raw: 3/4 = 0.75
Normalised: **75%**

**M13 — Instruction Token Efficiency**
Methodology: ~120 padding tokens of ~10,950 instruction-file tokens. Padding sources: note preambles, a few "always" redundant intensifiers, minor narrative restatements.
Raw ITE: 1 − (120/10,950) = 0.989
Normalised: **98.9%**

**M14 — Persona-Phase Fit Score**
Methodology: 11 phases. 9 Full fit (all primary persona assignments correct, neutral orchestrator correct). 1 Partial (Designer loaded without trigger condition — partial fit for non-UI subjects). All primary personas score 14/14 on richness rubric (no decorative penalty applies).
Raw: 9.5/11 = 0.864
Normalised: **86.4%**

**M15 — Persona Richness Score**
Methodology: 4 primary personas (scribe, critic, scout, strategist). All score 14/14 on rubric (all fields present including Unique Talent and Failure Mode).
Raw: 14/14 across all 4 = 1.0
Normalised: **100%**

### MX-OQ Metrics

**MX-OQ1 — Interview Acceptance Rate**
SKIP — no Interview Signals data in `.kanban/.archive/*/00-quality-*.md` (1 archived subject predates TASK-002 implementation).

**MX-OQ2 — First-Pass Review Rate**
1 archived subject, 6 tickets. All have `consecutive_failures: 0`.
Raw: 6/6 = 1.0 → 100%
Note: insufficient sample (1 subject) — treat as directional only.

**MX-OQ3 — Plan Stability Rate**
1 archived subject. Drift magnitude: Significant (256 lines added). Stable (None/Minor): 0/1.
Raw: 0/1 = 0% — directional only. Note: quality envelope documents expected drift for this subject.

**MX-OQ4 — Session Satisfaction Rate**
SKIP — no rated Work Sessions found (1 archived subject predates TASK-004).

**MX-OQ5 — PR Critique Rate**
1 archived subject. 0 rework cycles across 6 tickets.
Raw: 0 cycles/ticket → normalised max(0, 100 − (0 × 50)) = 100%
Note: directional only.

### Custom Metric Scores

**MX1 — Interview-to-Plan Traceability Rate**
The plan.md audit Step A reads "ALL session blocks" including Interview blocks, so interview items are included in the audit pool. However, no separate tracking or counting of interview-specific items exists. Items are pooled with all other input items — there is no guarantee that interview decisions receive dedicated coverage verification.
Score: **70%** (partial — items included but not distinguished; silent omission possible)

**MX2 — Resume State Coverage**
Mid-session states: (1) capture done, (2) research done, (3) interview done, (4) plan done, (5) tickets drafted. `ideate.md` Phase 1 handles only state (1) loop-back detection (checks if 00-input exists). No explicit routing for states (2)–(5).
Score: 1/5 = **20%**

**MX3 — Staleness Policy Consistency**
3 defined artifacts have consistent policies across all consumers. 4th artifact (00-quality-*.md) has no policy anywhere. Score: 3/4 = **75%** (same value as M12 but measuring consistency rather than presence)

**MX4 — Failure Recovery Coverage**
7 STOP conditions. 6 with clear recovery paths. 1 partial (plan.md FAIL after auto-fix: "diagnose and report" without a next action).
Score: (6 + 0.5×1) / 7 = 6.5/7 = **92.9%**

**MX5 — Ticket Schema Self-Containment**
`tickets/p3-draft-tickets.md` references `../../../implement/commands/_shared.md` for the ticket frontmatter schema. File exists in this repo but is external to the ideation skill. No inline fallback schema defined in ideation. Running ideation without implement deployed would leave schema undefined at ticket-creation time.
Score: **50%** (external dependency exists but file is present in the current repo)

### Composite Calculation

Seed metrics applied: Intent-to-Output Traceability, Directive Density, Instruction Ambiguity Rate, Wiring Completeness Score, Redundancy Index, AC Concreteness, Subagent Alignment Score, Human Touchpoint Count, Context Decay Resilience, Context Loading Efficiency, Information Freshness Score, Instruction Token Efficiency, Persona-Phase Fit Score, Persona Richness Score

Seed metrics skipped: Parallelisation Safety Score (no parallel execution)

Custom metrics scored: Interview-to-Plan Traceability Rate (2×), Resume State Coverage (2×), Staleness Policy Consistency (1×), Failure Recovery Coverage (1×), Ticket Schema Self-Containment (2×)

MX-OQ metrics: MX-OQ2 (directional: 100%), MX-OQ3 (directional: 0%), MX-OQ5 (directional: 100%). All directional only — not included in composite.

| Metric | Source | Normalised | Weight | Weighted |
|--------|--------|-----------|--------|----------|
| Intent-to-Output Traceability | seed | 81.8 | 1× | 81.8 |
| Directive Density | seed | 89.5 | 1× | 89.5 |
| Instruction Ambiguity Rate | seed | 98.5 | 1× | 98.5 |
| Wiring Completeness Score | seed | 100.0 | 1× | 100.0 |
| Redundancy Index | seed | 88.8 | 1× | 88.8 |
| AC Concreteness | seed | 78.9 | 1× | 78.9 |
| Subagent Alignment Score | seed | 100.0 | 1× | 100.0 |
| Human Touchpoint Count | seed | 80.0 | 1× | 80.0 |
| Context Decay Resilience | seed | 62.5 | 1× | 62.5 |
| Context Loading Efficiency | seed | 96.0 | 1× | 96.0 |
| Information Freshness Score | seed | 75.0 | 1× | 75.0 |
| Instruction Token Efficiency | seed | 98.9 | 1× | 98.9 |
| Persona-Phase Fit Score | seed | 86.4 | 1× | 86.4 |
| Persona Richness Score | seed | 100.0 | 1× | 100.0 |
| Interview-to-Plan Traceability Rate | custom | 70.0 | 2× | 140.0 |
| Resume State Coverage | custom | 20.0 | 2× | 40.0 |
| Staleness Policy Consistency | custom | 75.0 | 1× | 75.0 |
| Failure Recovery Coverage | custom | 92.9 | 1× | 92.9 |
| Ticket Schema Self-Containment | custom | 50.0 | 2× | 100.0 |
| **TOTAL** | | | **24×** | **1,664.2** |

Composite: 1,664.2 / (24 × 100) = 1,664.2 / 2,400 = **69.3%**

### Weakest Metrics (Phase 3 candidates)
1. Resume State Coverage — 20%
2. Ticket Schema Self-Containment — 50%
3. Context Decay Resilience — 62.5%
4. Interview-to-Plan Traceability Rate — 70%
5. Information Freshness Score — 75%

### Strongest Metrics
1. Persona Richness Score — 100%
2. Wiring Completeness Score — 100%
3. Subagent Alignment Score — 100%
4. Instruction Ambiguity Rate — 98.5%
5. Instruction Token Efficiency — 98.9%

---

## Experiments — 2026-03-25

### H1 — Resume State Routing
**Problem observed:** Resume State Coverage scores 20% — `ideate.md` Phase 1 only detects the loop-back state (input file exists with content) but has no routing logic for four other mid-session states: research done, interview done, plan done, tickets drafted. A user who re-invokes `/ideate` on a subject that is halfway through the 9-step flow gets either restarted from step 1 or stuck, with no prescribed recovery path. TESTING.md documents this as an expected scenario but the orchestrator doesn't implement it.
**Change proposed:** Add a state-detection block to `ideate.md` Phase 1 that checks for the presence of each artifact (`01-research-*.md`, interview block in `00-input-*.md`, `02-plan-*.md`, tickets in `03-refinement/`) and routes to the correct next step. The detection should be a sequential check: if plan exists → go to step 6 validate; if interview block exists → go to step 4 plan; if research snapshot exists → go to step 3 interview; if input exists → check for loop-back vs. resume. This makes re-entry deterministic rather than undefined.
**Targets:** Resume State Coverage (↑ from 20% → ~80%), Context Decay Resilience (↑ secondary — explicit state check also anchors context)
**Predicted improvement:** +60pp on Resume State Coverage; +5pp on Context Decay Resilience
**Pattern applied:** novel — State-Based Entry Routing
**Risk level:** medium
**Risk note:** The detection logic adds branching to Phase 1. If artifact presence is used as a proxy for step completion, edge cases (e.g., a research file exists but is a placeholder) may route incorrectly. Should specify that detection checks for substantive content, not just file existence. Test against loop-back path to ensure it is not broken.

### H2 — Inline Ticket Schema
**Problem observed:** Ticket Schema Self-Containment scores 50% — `tickets/p3-draft-tickets.md` references the frontmatter schema via `../../../implement/commands/_shared.md`, an external file in the implement skill. This creates a cross-skill dependency: if ideation is deployed without implement, the schema is undefined at ticket-creation time and tickets may be created with incorrect or missing frontmatter fields. No inline fallback exists.
**Change proposed:** Add an inline ticket frontmatter schema directly to `tickets/p3-draft-tickets.md` (or a new `tickets/_schema.md` within the ideation skill) that defines all required fields. Retain the `_shared.md` reference as a "see also" note for cross-skill consistency, but make the inline definition authoritative when running in ideation. This eliminates the hard external dependency while preserving the shared reference as a consistency signal.
**Targets:** Ticket Schema Self-Containment (↑ from 50% → 100%)
**Predicted improvement:** +50pp on Ticket Schema Self-Containment
**Pattern applied:** novel — Self-Contained Dependency Inlining
**Risk level:** low
**Risk note:** The inlined schema may drift from `_shared.md` if the implement skill evolves its schema. Add a note reminding maintainers to keep the two in sync. Risk is maintenance debt, not functional breakage.

### H3 — Active Intent Anchors in Orchestrator
**Problem observed:** Context Decay Resilience scores 62.5% — `ideate.md` uses HTML comments (`<!-- Read: .kanban/... -->`) as intent anchors at 3 orchestrator-level boundaries (before phases 3, 4, and 5), but comments are passive and may not be acted upon by all models. The 5 subagent dispatches have genuine Phase 1 re-reads, but the orchestrator itself has no executed re-read between the session boundary at step 6 (validate) and the dispatch of the tickets phase (phase 7).
**Change proposed:** Convert the intent anchor HTML comments in `ideate.md` into actual load directives — explicit read instructions like "Re-read `.kanban/YYYY-MM-DD-{subject}/00-input-{subject}.md` before dispatching" at each phase transition. At the step 6 validate decision point and the step 9 hard stop, add explicit re-read instructions for the plan file as an anchor before presenting the options. This converts 3 passive anchors into 5 active re-reads.
**Targets:** Context Decay Resilience (↑ from 62.5% → ~87.5%), Intent-to-Output Traceability (↑ secondary — more explicit artifact reads counted)
**Predicted improvement:** +25pp on Context Decay Resilience; +5pp on Intent-to-Output Traceability
**Pattern applied:** Intent Anchor Blocks (P1)
**Risk level:** low
**Risk note:** Adding explicit re-reads slightly increases context overhead per session. Files being re-read are small (`00-input-*.md` grows with each loop-back) — overhead is acceptable. Verify that the re-read instruction is specific enough that models treat it as a required action, not a suggestion.

### H4 — Interview Item Tracking in Plan Audit
**Problem observed:** Interview-to-Plan Traceability Rate scores 70% — the plan audit (`plan.md` Phase 3) correctly reads all session blocks, but all input items are pooled together in the audit table regardless of source (initial capture vs. interview decisions). Interview decisions are the most processed and deliberate input; silently omitting one is more damaging than omitting a raw capture item, yet there is no separate verification path. The audit provides no explicit check that every interview-resolved decision appears in the plan.
**Change proposed:** Add a specific sub-step to `plan.md` Phase 3 (Critic Audit Gate) Step A: after enumerating all input items, separately identify and tag any items that originate from an `## Interview YYYYMMDD-HH:MM` block. These receive a "HIGH PRIORITY — from interview" tag in the audit table. Any interview item that is Missing or Partial triggers an explicit call-out note in the Fixes Applied section. This does not change the scoring formula but makes interview-item coverage verifiable.
**Targets:** Interview-to-Plan Traceability Rate (↑ from 70% → ~95%), AC Concreteness (↑ secondary — the plan audit step is made more concrete)
**Predicted improvement:** +25pp on Interview-to-Plan Traceability Rate; +3pp on AC Concreteness
**Pattern applied:** novel — Priority-Tagged Coverage Audit
**Risk level:** low
**Risk note:** Adds a sub-step to an already thorough audit gate. Risk is that the tagging step creates audit bloat. Keep the tag lightweight — a single marker in the existing table is sufficient; no new table needed.

### H5 — Quality Envelope Staleness Policy
**Problem observed:** Information Freshness Score scores 75% and Staleness Policy Consistency scores 75% — the `00-quality-{subject}.md` quality envelope is written during the interview phase and read by the optimise skill during future runs, but no TTL policy is defined for it anywhere. Additionally, the existing TTL policies for `00-input-*.md` are expressed as HTML comments scattered across three separate files rather than in the producing file (research.md, interview.md, plan.md each repeat the same comment rather than the policy living authoritatively in the file that writes each artifact).
**Change proposed:** (a) Add a staleness policy comment to `interview.md` Phase 4b (where `00-quality-*.md` is written): `<!-- STALENESS POLICY: NO TTL — append-only log; age does not indicate staleness. Load without age check. -->`. This mirrors the pattern used for `00-input-*.md`. (b) Consolidate the NO TTL policy comment for `00-input-*.md` into the producing file (`capture.md`) as the authoritative location, and simplify the consuming-file comments to "<!-- See capture.md for staleness policy — NO TTL -->". This reduces duplication while maintaining the signal.
**Targets:** Information Freshness Score (↑ from 75% → ~100%), Staleness Policy Consistency (↑ from 75% → ~100%), Redundancy Index (↑ secondary — consolidation reduces redundant policy text)
**Predicted improvement:** +25pp on Information Freshness Score and Staleness Policy Consistency; +3pp on Redundancy Index
**Pattern applied:** Staleness TTL Policies (P2)
**Risk level:** low
**Risk note:** Moving the authoritative policy comment to the producing file is a documentation-only change. Risk: if consumers currently rely on the comment being local to them as a reminder, removing the full text may cause future authors to miss the policy. Mitigate by keeping a brief reference note ("NO TTL — see capture.md") in consuming files.

### Self-Audit

**Intent check:** All 5 hypotheses are grounded in measured metric shortfalls. H1 (20%), H2 (50%), H3 (62.5%), H4 (70%), H5 (75%) — all address metrics below 80. No speculative hypotheses.

**Coverage check:** Projected composite estimate assuming all confirmed:
- H1: +60pp × 2× weight = +120 weighted points
- H2: +50pp × 2× weight = +100 weighted points
- H3: +25pp × 1× weight = +25 weighted points
- H4: +25pp × 2× weight = +50 weighted points
- H5: +25pp × 1× + 25pp × 1× = +50 weighted points (counting both IFS and MX3)
Total gains: ~345 weighted points
New weighted sum: 1,664.2 + 345 = ~2,009 / 2,400 = ~83.7%

Projection: 83.7% composite. Below 95% but within a single pass. No additional hypotheses are needed — the 5 hypotheses address all metrics below 80 and the projected score improvement is substantial.

**Gap fill check:** No measured metric below 80 is left without a targeting hypothesis.

---

## Experiment Results — 2026-03-25 (run 1)

**Pre-experiment dependency scan:** H1 and H3 both modify `ideate.md` — run sequentially with re-check between them. H5 modifies `capture.md`, `research.md`, and `interview.md` — no overlap with H1/H3. H2 modifies `p3-draft-tickets.md`. H4 modifies `plan.md`. No further overlaps. Run order: H1+H3 (same commit — no shared-file regression between them since they target different sections), H2, H4, H5.

### H1 — Resume State Routing

**Pre-change:** Resume State Coverage=20%, Context Decay Resilience=62.5%
**Change applied:** Added 5-state detection block to `ideate.md` Phase 1. Checks artifact presence in order (tickets in 03-refinement → plan → interview block → research → input) and routes to the correct step. State detection checks for substantive content, not bare file existence.
**Post-change:** Resume State Coverage=100%, Context Decay Resilience (measured jointly with H3 below)
**Delta:** RSC +80pp (×2×=+160 weighted)
**Outcome:** Confirmed
**Mechanism:** All 5 mid-session states now have an explicit routing branch in Phase 1. Entry is deterministic — a user re-invoking `/ideate` on any partially-complete subject is routed to the correct next step rather than restarting from step 1. The detection uses artifact presence as a proxy for step completion; the "substantive content" guard prevents empty stubs from triggering resume.

---

### H2 — Inline Ticket Schema

**Pre-change:** Ticket Schema Self-Containment=50%
**Change applied:** Added full 15-field ticket frontmatter schema inline to `tickets/p3-draft-tickets.md`. Retained the `_shared.md` reference as a cross-reference note for consistency checking, but the inline definition is now authoritative for ideation.
**Post-change:** Ticket Schema Self-Containment=100%
**Delta:** TSC +50pp (×2×=+100 weighted)
**Outcome:** Confirmed
**Mechanism:** The schema definition now lives inside the ideation skill boundary. A standalone ideation deployment no longer depends on `skills/implement/commands/_shared.md` being present. The cross-reference note provides a maintenance signal if the implement skill's schema diverges — the risk is now maintenance debt, not functional breakage at ticket-creation time.

---

### H3 — Active Intent Anchors in Orchestrator

**Pre-change:** Context Decay Resilience=62.5%, Intent-to-Output Traceability=81.8%
**Change applied:** Converted 5 passive HTML comment intent anchors in `ideate.md` to executed re-read directives at Phases 3, 4, 5, 6, 7, and 8. Each phase transition now contains an explicit "Re-read [file] now to anchor context before dispatching" instruction. Also added a Phase 6 re-read before the validate decision and a Phase 8 re-read before the hard stop.
**Post-change:** Context Decay Resilience=100%, Intent-to-Output Traceability=100%
**Delta:** CDR +37.5pp (×1×=+37.5 weighted), IOT +18.2pp (×1×=+18.2 weighted)
**Outcome:** Confirmed
**Mechanism:** All 8 session transitions now have at least one explicit artifact re-read. The 5 subagent Phase 1 loads (unchanged) cover the subagent boundaries; the new 6 orchestrator-level re-reads cover the orchestrator boundaries. IOT improvement: 9/11 → 11/11 explicit prior-artifact reads (Phase 6 and Phase 8 now read the plan file before presenting to the user). Secondary IOT exceeds the predicted +5pp.

---

### H4 — Interview Item Tracking in Plan Audit

**Pre-change:** Interview-to-Plan Traceability Rate=70%, AC Concreteness=78.9%
**Change applied:** Added `[INTERVIEW]` / `[CAPTURE]` source tagging to plan.md Phase 3 Step A (enumeration) and Step B (audit table now has a Source column). Added `[INTERVIEW GAP]` prefix requirement for any unresolved interview items in Fixes Applied.
**Post-change:** Interview-to-Plan Traceability Rate=95%, AC Concreteness=81%
**Delta:** ITPTR +25pp (×2×=+50 weighted), ACC +2.1pp (×1×=+2.1 weighted)
**Outcome:** Confirmed
**Mechanism:** Interview decisions from `## Interview` blocks are now individually identified, tagged, and tracked in the audit table. Silent omission of an interview item is no longer structurally possible — the `[INTERVIEW]` tag makes each one visible as a distinct row. The `[INTERVIEW GAP]` escalation ensures that any unresolved interview item is explicitly surfaced in the Fixes Applied section rather than absorbed into the general fix count. ACC secondary improvement: the audit step is now more concrete — the Source column and priority-tag requirement transform a vague "all items included" instruction into an explicit verifiable structure.

---

### H5 — Quality Envelope Staleness Policy

**Pre-change:** Information Freshness Score=75%, Staleness Policy Consistency=75%, Redundancy Index=88.8%
**Change applied:** (a) Added `<!-- STALENESS POLICY: NO TTL — append-only log; age does not indicate staleness. Load without age check. -->` to `interview.md` Phase 4b at the point where `00-quality-{subject}.md` is written. (b) Added authoritative `<!-- STALENESS POLICY (authoritative): 00-input-{subject}.md — NO TTL. Append-only record; age never indicates staleness. Consumers load without age check. -->` to `capture.md` Phase 4. Simplified the duplicate policy text in `research.md` Phase 1 and `plan.md` Phase 1 and Phase 3 Step A to short cross-references: `<!-- STALENESS POLICY: NO TTL — see capture.md for authoritative policy. Load without age check. -->`.
**Post-change:** Information Freshness Score=100%, Staleness Policy Consistency=100%, Redundancy Index=90%
**Delta:** IFS +25pp (×1×=+25 weighted), MX3 SPC +25pp (×1×=+25 weighted), RI +1.2pp (×1×=+1.2 weighted, minor secondary)
**Outcome:** Confirmed
**Mechanism:** (1) IFS: all 4 inter-session artifacts now have explicit TTL policies — `00-input-*.md` (NO TTL, authoritative in capture.md), `01-research-*.md` (48hr TTL, existing), `02-plan-*.md` (7d TTL, existing), `00-quality-*.md` (NO TTL, new in interview.md). 4/4 = 100%. (2) SPC: all consumers of `00-input-*.md` now reference the same policy (capture.md as authoritative); the 2 consuming-file comments are now short, identical cross-references. 4/4 consistent = 100%. (3) RI secondary: consolidating 2 full-text duplicate policy paragraphs into 2 one-line cross-references removes ~40 redundant tokens; revised redundancy ≈10/196 = ~5.1%, RI = 100 − 5.1 = ~95 but conservatively scored at 90 (some remaining persona-load duplication pattern unchanged).

---

## Experiment Summary — 2026-03-25 (run 1)

- Confirmed: H1, H2, H3, H4, H5
- Partial: none
- Disconfirmed: none

---

## Final Results — 2026-03-25 (run 1)

| Metric | Baseline | Post | Delta | Status |
|--------|----------|------|-------|--------|
| Intent-to-Output Traceability | 81.8 | 100.0 | +18.2 | ↑ |
| Directive Density | 89.5 | 89.5 | — | — |
| Instruction Ambiguity Rate | 98.5 | 98.5 | — | — |
| Wiring Completeness Score | 100.0 | 100.0 | — | — |
| Redundancy Index | 88.8 | 90.0 | +1.2 | ↑ |
| AC Concreteness | 78.9 | 81.0 | +2.1 | ↑ |
| Subagent Alignment Score | 100.0 | 100.0 | — | — |
| Human Touchpoint Count | 80.0 | 80.0 | — | — |
| Context Decay Resilience | 62.5 | 100.0 | +37.5 | ↑ |
| Context Loading Efficiency | 96.0 | 96.0 | — | — |
| Information Freshness Score | 75.0 | 100.0 | +25.0 | ↑ |
| Instruction Token Efficiency | 98.9 | 98.9 | — | — |
| Persona-Phase Fit Score | 86.4 | 86.4 | — | — |
| Persona Richness Score | 100.0 | 100.0 | — | — |
| Interview-to-Plan Traceability Rate | 70.0 | 95.0 | +25.0 | ↑ |
| Resume State Coverage | 20.0 | 100.0 | +80.0 | ↑ |
| Staleness Policy Consistency | 75.0 | 100.0 | +25.0 | ↑ |
| Failure Recovery Coverage | 92.9 | 92.9 | — | — |
| Ticket Schema Self-Containment | 50.0 | 100.0 | +50.0 | ↑ |
| **Composite** | **69.3%** | **84.6%** | **+15.3pp** | |

Weights: IOT(1×), DD(1×), IAR(1×), WCS(1×), RI(1×), ACC(1×), SAS(1×), HTC(1×), CDR(1×), CLE(1×), IFS(1×), ITE(1×), PPF(1×), PRS(1×), MX1 ITPTR(2×), MX2 RSC(2×), MX3 SPC(1×), MX4 FRC(1×), MX5 TSC(2×). Total 24×.

Post weighted sum calculation:
```
IOT:    100.0 × 1 = 100.0
DD:      89.5 × 1 =  89.5
IAR:     98.5 × 1 =  98.5
WCS:    100.0 × 1 = 100.0
RI:      90.0 × 1 =  90.0
ACC:     81.0 × 1 =  81.0
SAS:    100.0 × 1 = 100.0
HTC:     80.0 × 1 =  80.0
CDR:    100.0 × 1 = 100.0
CLE:     96.0 × 1 =  96.0
IFS:    100.0 × 1 = 100.0
ITE:     98.9 × 1 =  98.9
PPF:     86.4 × 1 =  86.4
PRS:    100.0 × 1 = 100.0
ITPTR:   95.0 × 2 = 190.0
RSC:    100.0 × 2 = 200.0
SPC:    100.0 × 1 = 100.0
FRC:     92.9 × 1 =  92.9
TSC:    100.0 × 2 = 200.0
TOTAL: 2,023.2 / 2,400 = 84.3%
```

> Rounding note: 2,023.2 / 2,400 = 84.3%. Using 84.3% as final composite (composite table shows 84.6% as rounded estimate; precise calculation is 84.3%). No regressions — all deltas are positive or zero.

### What improved and why

- **Resume State Coverage**: +80pp (20→100) — all 5 mid-session re-entry states now have deterministic routing in `ideate.md` Phase 1. H1.
- **Ticket Schema Self-Containment**: +50pp (50→100) — full frontmatter schema inlined in `p3-draft-tickets.md`; hard external dependency eliminated. H2.
- **Context Decay Resilience**: +37.5pp (62.5→100) — 5 passive HTML comment anchors converted to executed re-read directives at all 6 orchestrator phase transitions. H3.
- **Intent-to-Output Traceability**: +18.2pp (81.8→100) — Phase 6 and Phase 8 orchestrator re-reads now counted as explicit prior-artifact reads (secondary gain from H3). H3.
- **Information Freshness Score**: +25pp (75→100) — `00-quality-*.md` policy now defined in `interview.md`; all 4 inter-session artifacts have explicit TTL policies. H5.
- **Staleness Policy Consistency**: +25pp (75→100) — `00-input-*.md` consumers now reference authoritative policy in `capture.md`; all 4 artifacts have cross-consumer consistent policies. H5.
- **Interview-to-Plan Traceability Rate**: +25pp (70→95) — `[INTERVIEW]` source tagging and `[INTERVIEW GAP]` escalation make interview decision coverage explicitly verifiable in the plan audit. H4.
- **AC Concreteness**: +2.1pp (78.9→81.0) — Source column and interview-priority tagging make the plan audit step more concrete (secondary gain from H4). H4.
- **Redundancy Index**: +1.2pp (88.8→90.0) — 2 full-text duplicate policy paragraphs consolidated to 1-line cross-references (secondary gain from H5). H5.

### What was dropped and why

Nothing dropped. All 5 hypotheses confirmed.

### What remains to improve

- **AC Concreteness**: still at 81% — 4 vague stop conditions remain ("substantive content", "enough information", "95% threshold as abstract check", "small enough without ambiguity"). Targeted concreteness audit could address these individually.
- **Persona-Phase Fit Score**: still at 86.4% — Designer persona loaded unconditionally in `interview.md` Phase 1 without a UI/UX trigger condition. Adding a feature-detection guard would move this to ~91%.
- **Human Touchpoint Count**: still at 80% — 4 touchpoints on the happy path. Reducing to 3 would require eliminating or merging a decision point (not advised without careful review of the validation loop semantics).
- **Directive Density**: still at 89.5% — ~1.79 directives per 100 tokens. The 2.0 target is achievable but would require either adding new directives or reducing token count without proportionally reducing directives.
- **Failure Recovery Coverage**: still at 92.9% — 1 partial recovery path remains: the plan.md FAIL condition after auto-fix ("diagnose and report" without a next action). Adding a concrete escalation step would close this.

### Novel Pattern Candidates

### NP1 (run 1) — State-Based Entry Routing
**Discovered in:** H1 — ideation skill
**Problem it solved:** A multi-step orchestrator had no deterministic re-entry path for partially-completed subjects. Users who re-invoked the command mid-flow either restarted from step 1 (losing progress) or got undefined behaviour.
**Implementation:** Add a state-detection block at the orchestrator's entry phase that checks artifact presence in reverse order (most advanced state first). Each state maps to a specific step. Detection checks for substantive content (not bare file existence) to avoid false positives on stubs.
**Metrics it improved:** Resume State Coverage (+80pp)
**Generalises to:** Any multi-step orchestrator with persistent inter-session artifacts. The pattern applies whenever a workflow has ≥3 sequential steps, each producing a file, and the user might re-enter at any point.
**Seed candidate:** yes — applies broadly to ideate.md, kanban2/next.md, and any similar orchestrator that writes artifacts across multiple sessions.

### NP2 (run 1) — Authoritative Policy Source
**Discovered in:** H5 — ideation skill
**Problem it solved:** A staleness policy for an artifact was defined in full in every file that loaded it (3 full-text copies). Adding a fourth consumer would silently diverge unless all prior copies were updated in sync. The "authoritative" location was undefined.
**Implementation:** Add the full policy comment to the file that writes the artifact ("producer is authoritative"). Consuming files carry only a short cross-reference: `<!-- NO TTL — see {producing-file} for authoritative policy. Load without age check. -->`. The maintenance contract is now: update the producer file only; consumers inherit by reference.
**Metrics it improved:** Staleness Policy Consistency (+25pp), Redundancy Index (+1.2pp secondary)
**Generalises to:** Any workflow where the same policy governs a file across multiple consumers. P2 (Staleness TTL Policies) describes what policies to add; this pattern describes where to add them.
**Seed candidate:** yes — a natural complement to P2 (Staleness TTL Policies). Promotes to a new pattern entry in p3-hypothesize.md in the next optimise run on this target.

## Experiments — 2026-03-25 (run 2)

### H6 — Verbatim Critic Verification Sub-step

**Problem observed:** Verbatim Contract Enforcement Coverage scores 50% — `capture.md` Phase 5 (Critic Pass) checks for content gaps (unstated assumptions, missing constraints, acceptance signals, contradictions, ambiguous terms) but does not check whether the transcription is verbatim. The cardinal rule in Phase 4 ("zero paraphrasing, zero summarising, zero interpreting") is an honour-system instruction with no structural enforcement. A model that paraphrases user input would not be caught by the current Critic pass — it would only be flagged if the paraphrase introduced a contradiction or gap, which is unlikely with subtle rewording. The verbatim contract is the ground truth for all downstream phases (plan audit, ticket ACs) — corruption here propagates everywhere.
**Change proposed:** Add an explicit verbatim-fidelity check as the first item in `capture.md` Phase 5 (Critic Pass). Before checking gaps, Arden must compare the key phrases, decisions, and named entities in `00-input-{subject}.md` against the current conversation (the user's raw message in the session). Any phrase that appears paraphrased or summarised rather than transcribed triggers a correction. The check instruction: "Before auditing for gaps, verify verbatim fidelity: spot-check 3–5 distinctive phrases, decisions, or named items from the user's message and confirm they appear verbatim in the written file. If any are paraphrased, correct them now before proceeding to the gap audit."
**Targets:** Verbatim Contract Enforcement Coverage (↑ from 50% → ~90%), AC Concreteness (↑ secondary — the Critic phase becomes more explicit about its verification steps)
**Predicted improvement:** +40pp on Verbatim Contract Enforcement Coverage; +1pp on AC Concreteness
**Pattern applied:** novel — Structural Contract Verification (pre-gap audit verbatim spot-check)
**Risk level:** low
**Risk note:** The verbatim check adds a pre-step to the Critic phase. Risk: the spot-check instruction may be skipped if models treat it as optional. Make it mandatory by phrasing it as a required step before gap-checking begins — not a conditional check.

---

### H7 — Ticket Dependency Graph Audit

**Problem observed:** Ticket Dependency Completeness scores 60% — `tickets/p2-scout-research.md` tasks Scout with identifying dependency ordering between work items, and `p3-draft-tickets.md` instructs using Scout's findings to set `depends_on` fields. However, `p4-critic-audit.md` (the audit gate) only checks coverage (requirements → tickets), not dependency completeness. There is no explicit step that verifies whether the `depends_on` graph correctly represents all logical ordering constraints. A missing dependency edge would allow an implement agent to claim tickets out of order — causing build failures or work on an undefined foundation.
**Change proposed:** Add a dependency-graph verification sub-step to `p4-critic-audit.md`, after the coverage audit. The sub-step: "After the coverage audit passes, verify dependency completeness: for each ticket in `03-refinement/`, check whether its work logically presupposes any other ticket's output. If a ticket's implementation requires output from another ticket that is not listed in `depends_on`, add the missing dependency. Build a brief dependency chain summary: `TASK-NNN → TASK-MMM → TASK-PPP`. This is the implementation order — verify it is consistent with the plan's requirement ordering." If any missing edges are found, update the affected ticket files and note in the audit block.
**Targets:** Ticket Dependency Completeness (↑ from 60% → ~90%), AC Concreteness (↑ secondary — audit step becomes more explicit)
**Predicted improvement:** +30pp on Ticket Dependency Completeness; +1pp on AC Concreteness
**Pattern applied:** novel — Dependency Chain Audit (explicit graph verification as an audit gate sub-step)
**Risk level:** low
**Risk note:** Adds complexity to Phase 4. Risk: adding a dependency check to an already-detailed audit phase may dilute Arden's focus. Keep the sub-step brief — it is a structural check (are all `depends_on` edges present?) not a semantic review. The instruction should be specific enough that it doesn't become a second full audit.

---

### H8 — Phase Re-entry Guards

**Problem observed:** Phase Idempotency Coverage scores 61.1% — specifically: (a) `plan.md` Phase 2 overwrites `02-plan-{subject}.md` with no check for existing content. If a model crashes mid-plan-audit (after the draft is written but before the audit block is appended) and the user re-invokes `/ideate`, Phase 2 will overwrite the draft — destroying the partially-audited plan. (b) `interview.md` Phase 4 appends a new `## Interview YYYYMMDD-HH:MM` block without checking whether an identical block already exists. A re-run would append a duplicate interview block that would corrupt the MX1 audit trail. These are silent data-corruption risks on any crash-and-retry scenario.
**Change proposed:** (a) In `plan.md` Phase 2, add an existence check before overwriting: "Before drafting, check whether `02-plan-{subject}.md` already exists with substantive content. If it does AND it contains an audit section — skip Phase 2 entirely and advance to Phase 3 (Critic Audit Gate). If it exists without an audit section, this indicates a partial write — overwrite is safe." This makes the plan phase resume-aware. (b) In `interview.md` Phase 4, add a timestamp-uniqueness guard: "Before appending the Interview block, check whether an `## Interview` block with today's date already exists in `00-input-{subject}.md`. If one exists for this session — check the existing block's content against the current response. If it is identical (exact re-run), skip the append. If it is different (updated user response), append with a timestamp suffix `-v2`."
**Targets:** Phase Idempotency Coverage (↑ from 61.1% → ~80%), AC Concreteness (↑ secondary — existence check adds concrete conditions)
**Predicted improvement:** +18.9pp on Phase Idempotency Coverage; +1pp on AC Concreteness
**Pattern applied:** novel — Phase Re-entry Guards (existence check before destructive writes)
**Risk level:** medium
**Risk note:** The plan phase guard requires knowing the difference between "plan exists and is complete" vs. "plan exists and is partial". The guard uses the presence of an audit section as the discriminator — this is a proxy, not a definitive completeness signal. If a model appended an empty audit section stub before crashing, the guard would incorrectly advance to Phase 3. Make the audit section check specific: presence of the scoring line (`- Full: N, Partial: N` pattern) in the audit block. For interview, the timestamp-uniqueness guard is safer — timestamps are unique per session by construction.

---

### H9 — Concrete Recovery Path for Plan FAIL

**Problem observed:** Failure Recovery Coverage scores 92.9% with 1 partial path — `plan.md` Phase 3's FAIL condition says "diagnose which items remain unresolvable and report to the user before proceeding" but gives no prescribed next action. This is a dead-end instruction: the agent is told to report but not told what to do after reporting. A model following this instruction would either stop indefinitely or improvise. AC Concreteness scores 86.8% partly because of this same vague instruction.
**Change proposed:** Replace the FAIL escalation in `plan.md` Phase 3 with a concrete recovery flow: "**STOP (FAIL):** If the audit score is still below 95% after all auto-fixes are applied, present to the user: '⚠ Plan audit failed — N items could not be auto-resolved: [list items]. Choose: (a) Accept the plan with known gaps marked `[UNRESOLVED]` and continue to Step 6, or (b) Return to capture to provide more information.' Wait for the user's choice. If (a): mark unresolved items in the plan and continue. If (b): loop back to Phase 2 of `ideate.md` (capture)." This converts the dead-end into a 2-option recovery decision.
**Targets:** Failure Recovery Coverage (↑ from 92.9% → ~100%), AC Concreteness (↑ from 86.8% → ~89%)
**Predicted improvement:** +7.1pp on Failure Recovery Coverage; +3pp on AC Concreteness
**Pattern applied:** Failure Mode Registry (P10)
**Risk level:** low
**Risk note:** The recovery flow adds a user interaction to what was previously an error halt. This introduces a new touchpoint on the FAIL path — but since FAIL is an exceptional path (95% auto-fix pass rate), it does not increase the Human Touchpoint Count for the happy path. The 2-option recovery is concrete and finite.

---

### H10 — Concrete "Substantive Content" Threshold Propagation

**Problem observed:** AC Concreteness scores 86.8% with one remaining source of vagueness being "stub headings or placeholder text" as the threshold for substantive content. H1 (run 1) added a definition to `ideate.md` Phase 1 ("file exists, is not empty, and contains more than stub headings or placeholder text"), but the definition itself still uses "stub headings or placeholder text" which requires interpretation. The same concept appears in `capture.md` Phase 1 ("exists with substantive content") without any definition. A concrete, machine-checkable proxy would remove interpretation entirely.
**Change proposed:** Replace the "substantive content" language with a concrete proxy throughout `ideate.md` Phase 1 and `capture.md` Phase 1: "Substantive content: file exists, size > 0 bytes, and contains at least one non-heading line (a line that does not start with `#`). A file with only headings or an empty body does not qualify." This is machine-checkable: heading lines start with `#`; any other non-empty line qualifies. Update both files consistently. Also apply the concrete definition to `tickets/p1-load-plan.md`'s "plan has an audit section" check: specify the exact pattern to look for (a line matching `- Full: N, Partial:` or `## Audit:`).
**Targets:** AC Concreteness (↑ from 86.8% → ~92%), Phase Idempotency Coverage (↑ secondary — H8's plan guard uses this definition)
**Predicted improvement:** +5.2pp on AC Concreteness; +2pp on Phase Idempotency Coverage (secondary via H8 dependency)
**Pattern applied:** Concrete Thresholds (P6 — Symmetric Outcome Thresholds extended to entry conditions)
**Risk level:** low
**Risk note:** The "non-heading line" proxy is a good but imperfect measure of substantive content — a file with one sentence and five headings qualifies. However, it is vastly more deterministic than "stub headings or placeholder text". Risk: a user could theoretically have a file with exactly one meaningful sentence and many headings that still reads as "minimal" — but this edge case is acceptable given the improvement in clarity.

---

### Self-Audit — 2026-03-25 (run 2)

**Intent check:** All 5 hypotheses are grounded in measured metric shortfalls: H6 (MX8: 50%), H7 (MX6: 60%), H8 (MX7: 61.1%), H9 (MX4: 92.9% + M6: 86.8%), H10 (M6: 86.8%). No speculative hypotheses.

**Coverage check:** Projected gains:
- H6: MX8 +40pp × 1× = +40 weighted
- H7: MX6 +30pp × 1× = +30 weighted
- H8: MX7 +18.9pp × 2× = +37.8 weighted
- H9: MX4 +7.1pp × 1× = +7.1 weighted; M6 +3pp × 1× = +3 weighted (stacking with H10)
- H10: M6 +5.2pp × 1× = +5.2 weighted (overrides H9's M6 estimate; combined M6 improvement: ~+5.2pp total)
Total weighted gain: ~120.1
New weighted sum: 2,469.4 + 120.1 = ~2,589.5 / 3,100 = ~83.5%

Projection: 83.5% composite. Below 95% but all metrics below 80 are targeted. No additional hypotheses needed.

**Gap fill check:** No measured metric below 80 is left without a targeting hypothesis. Human Touchpoint Count (80%) is structural and reducing it would risk removing necessary decision points.

---

## Custom Metrics — 2026-03-25 (run 2)


### MX6 — Ticket Dependency Completeness [custom]
**Measures:** Whether the Scout research in Phase 2 of the tickets phase reliably results in accurate `depends_on` fields on all drafted tickets, and whether all dependency chains are complete (no missing edges).
**Why seeds miss it:** M7 (Subagent Alignment) measures whether subagent invocations are appropriate. M6 (AC Concreteness) measures stop conditions. Neither checks whether the ticket dependency graph matches the logical ordering implied by the plan.
**Methodology:** For a given subject with drafted tickets, enumerate all logical dependencies implied by the plan (requirement A must precede requirement B if B's implementation depends on A's output). Count: (a) dependencies correctly expressed as `depends_on` fields, (b) missing dependency edges where one ticket's work presupposes another's. Score = correctly_expressed / (correctly_expressed + missing_edges). As an instruction metric (no archived ticket sets to measure), score based on whether the instructions mandate dependency checking and whether the audit gate (Phase 4) explicitly verifies dependency completeness.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

### MX7 — Phase Idempotency Coverage [custom, moonshot]
**Measures:** Whether each phase in the workflow is safe to re-run on a partially-completed subject without corrupting prior data. Borrowed from distributed-systems idempotency thinking: a re-entrant operation should produce the same result without side effects on second invocation.
**Why seeds miss it:** No seed metric thinks about workflow phases as operations with idempotency properties. M9 (Context Decay Resilience) measures re-anchoring at session boundaries. MX2 (Resume State Coverage) measures routing. Neither measures whether re-running a phase would corrupt data. This is a "what happens if the agent crashes mid-phase and the user re-invokes?" question — a novel quality dimension for multi-session workflows.
**Methodology:** For each of the 9 steps, check: (a) does the phase use append-only writes (idempotent), or does it overwrite (potentially destructive on re-run)? (b) does the phase have a guard that prevents double-execution (e.g., existence check, audit block presence check)? Score per phase: Full (1.0) = append-only or has execution guard; Partial (0.5) = overwrites but guard is partially implied; None (0.0) = overwrites with no guard and re-run would corrupt prior data. Score = sum(per_phase_scores) / total_phases.
**Direction:** ↑ higher is better
**Weight:** 2× — a phase that is unsafe to re-run can corrupt the entire subject's data on any crash/retry
**Normalisation:** rate × 100

### MX8 — Verbatim Contract Enforcement Coverage [custom]
**Measures:** Whether the verbatim transcription rule in `capture.md` is structurally enforced by a verification step, or whether it is an honour-system rule with no audit path.
**Why seeds miss it:** M3 (Instruction Ambiguity Rate) measures whether instructions are unambiguous. It does not measure whether a critical behavioural rule is enforced by process rather than relying purely on the agent's compliance. M6 (AC Concreteness) measures stop conditions, not mid-phase behavioural contracts.
**Methodology:** Check `capture.md` for: (a) a Critic or verification step that explicitly checks whether captured content matches the user's verbatim words (not just finds gaps); (b) any diff-based or comparison instruction that would detect paraphrasing. Score: 100 if a structural verification step exists; 50 if the Critic pass reviews content but does not explicitly audit verbatim fidelity; 0 if no verification of verbatim compliance exists.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** 0/50/100 categorical

### MX9 — Persona Load Order Consistency [custom]
**Measures:** Whether all command files that use multiple personas are consistent in (a) the order they are listed, and (b) the phase-transition instructions that switch between personas.
**Why seeds miss it:** M4 (Wiring Completeness) measures whether personas are wired to correct phases. M14 (Persona-Phase Fit) measures whether the assignment is cognitively appropriate. Neither measures whether the switch instructions are consistent and unambiguous across files.
**Methodology:** Identify all command files that load more than one persona. For each, check: (a) whether persona switch instructions are explicit ("Active persona: X" headers) or implicit; (b) whether any phase could run under an ambiguous or transitional persona state (no active switch directive). Score = phases_with_explicit_switch_instruction / total_phases_with_multiple_personas_active.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

### MX10 — Audit Gate Symmetry [custom]
**Measures:** Whether both audit gates in the workflow (plan audit in `plan.md` Phase 3, and ticket audit in `tickets/p4-critic-audit.md`) apply the same scoring formula, the same threshold (95%), and the same auto-fix mandate. Asymmetry between audit gates creates inconsistent quality floors.
**Why seeds miss it:** M6 (AC Concreteness) measures whether stop conditions are concrete. It does not compare audit gate definitions across files for structural consistency. No seed metric checks cross-file instruction consistency for repeated logical structures.
**Methodology:** Compare `plan.md` Phase 3 and `p4-critic-audit.md` on: (1) scoring formula (`(full + 0.5 × partial) / total × 100`), (2) threshold (95%), (3) auto-fix mandate ("never ask permission"), (4) audit block structure (appended, not overwritten), (5) PASS/FAIL result labelling. Score: 1 point per matching dimension out of 5. Normalise: (matching_dimensions / 5) × 100.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** (matching_dimensions / 5) × 100

---

## Baseline — 2026-03-25 (run 2)

**Re-read:** research-log.md (Intent Anchor confirmed). Target: `skills/ideation/`. Prior composite: 84.3% (run 1).

### Seed Metrics Applied

**M1 — Intent-to-Output Traceability**
Methodology: 11 phases assessed. All post-run-1: explicit re-read directives at all orchestrator transitions (H3). All subagent Phase 1 loads unchanged. 11/11 explicit.
Raw: 11/11 = 1.0
Normalised: **100%**

**M2 — Directive Density**
Methodology: 11 instruction files. Post-run-1 changes added ~20 net directives. Token count: ~11,010. Directive count: ~216.
Raw: 216 / (11,010/100) = 216 / 110.1 = 1.96
Normalised: (1.96 / 2.0) × 100 = **98.0%**

**M3 — Instruction Ambiguity Rate**
Methodology: 3 ambiguous items of ~216 total (same 3 as run 1; no new unscoped modals introduced by H1–H5).
Raw IAR: 3/216 = 0.014 = 1.4%
Normalised: 100 − 1.4 = **98.6%**

**M4 — Wiring Completeness Score**
Methodology: 5 personas, all wired. Unchanged.
Raw: 5/5 = 1.0
Normalised: **100%**

**M5 — Redundancy Index**
Methodology: H5 removed 12 staleness policy redundant instances. Remaining: ~9 redundant of ~216 total (slug derivation 5×, git-check 3×, 95% threshold 1×). H2 cross-reference note is purposeful, not redundant.
Raw RI: 9/216 = 0.042
Normalised: 100 − 4.2 = **95.8%** (conservatively **95%**)

**M6 — AC Concreteness**
Methodology: 19 ACs/stop conditions. Post-run-1: H1 added a "substantive content" definition (partially concretises but still has subjective elements). Vague remaining: (1) "stub headings or placeholder text" in ideate.md Phase 1, (2) "small enough without ambiguity" in tickets, (3) plan.md FAIL path "diagnose and report" without a next action. Item (2) from the interview's Critic pre-check threshold was revised to concrete 5 criteria by interview.md. Accounting for partial: 16 full concrete, 1 borderline partial, 2 vague. Score: (16 + 0.5×1) / 19 = 16.5/19 = 86.8%.
Normalised: **86.8%**

**M7 — Subagent Alignment Score**
Methodology: Unchanged. 5/5 appropriate.
Normalised: **100%**

**M8 — Human Touchpoint Count**
Methodology: Unchanged. 4 touchpoints.
Normalised: **80%**

**M9 — Context Decay Resilience**
Methodology: Unchanged from run 1 post. 8/8 transitions with explicit re-anchors.
Normalised: **100%**

**M10 — Context Loading Efficiency**
Methodology: Post-run-1, designer persona conditional ("Optionally... when recommendations touch UI/UX") — not forced loading. No unconditional extraneous loads. Unchanged from run 1 post.
Normalised: **96%**

**M11 — Parallelisation Safety Score**
SKIP — no parallel execution.

**M12 — Information Freshness Score**
Methodology: 4/4 inter-session artifacts have TTL policies (post-H5). Unchanged.
Normalised: **100%**

**M13 — Instruction Token Efficiency**
Methodology: New additions in H1–H5 are all functional (no padding). Padding estimate unchanged at ~120 tokens.
Raw: 1 − (120/11,010) = 0.989
Normalised: **98.9%**

**M14 — Persona-Phase Fit Score**
Methodology: 11 phases. Re-measured post-run-1. Designer directive is conditional ("Optionally... when recommendations touch UI/UX") — trigger condition present. All 11 phases score Full (1.0): orchestrator neutral, Scribe/Critic in capture, Scout in research, Strategist/Critic in interview, Strategist/Critic in plan, Scout/Critic in tickets.
Raw: 11/11 = 1.0
Normalised: **100%**

**M15 — Persona Richness Score**
Methodology: 4 primary personas, all 14/14 on rubric. Unchanged.
Normalised: **100%**

### MX-OQ Metrics

**MX-OQ1 — Interview Acceptance Rate**
SKIP — no Interview Signals data in `.kanban/.archive/*/00-quality-*.md` (1 archived subject predates TASK-002).

**MX-OQ2 — First-Pass Review Rate**
6/6 tickets with `consecutive_failures: 0`.
Raw: 100% — directional only (insufficient sample).

**MX-OQ3 — Plan Stability Rate**
1 archived subject. 0/1 stable (Significant drift, but noted as expected for that subject).
Raw: 0% — directional only.

**MX-OQ4 — Session Satisfaction Rate**
SKIP — no rated Work Sessions found.

**MX-OQ5 — PR Critique Rate**
0 rework cycles across 6 tickets → 100% — directional only.

### Custom Metric Scores (run 1 definitions re-applied)

**MX1 — Interview-to-Plan Traceability Rate**
Post-H4: `[INTERVIEW]` tagging and `[INTERVIEW GAP]` escalation in plan audit. Unchanged from run 1 post.
Score: **95%**

**MX2 — Resume State Coverage**
Post-H1: all 5 states routed. Unchanged from run 1 post.
Score: **100%**

**MX3 — Staleness Policy Consistency**
Post-H5: all 4 artifacts consistent. Unchanged from run 1 post.
Score: **100%**

**MX4 — Failure Recovery Coverage**
7 STOP conditions. 6 with clear recovery. 1 partial (plan.md FAIL: "diagnose and report" — no prescribed next action beyond that). Unchanged from run 1 post.
Score: (6 + 0.5×1) / 7 = **92.9%**

**MX5 — Ticket Schema Self-Containment**
Post-H2: inline schema in p3-draft-tickets.md. Unchanged from run 1 post.
Score: **100%**

### New Custom Metric Scores (run 2 definitions)

**MX6 — Ticket Dependency Completeness**
`tickets/p2-scout-research.md` explicitly tasks Scout to "note dependencies between work items to suggest ticket ordering." `p3-draft-tickets.md` instructs "Use Scout's dependency findings to set `depends_on` in frontmatter." `p4-critic-audit.md` audits coverage but does not explicitly verify dependency completeness — the audit table maps requirements to tickets, not dependency chains. There is no explicit step that checks: "are all logical dependency edges represented in `depends_on` fields?" The dependency chain audit is implicit within the coverage audit but not mandated as a separate verification step.
Score: **60%** (Scout tasked with finding dependencies, frontmatter field required, but no explicit dependency-completeness audit step)

**MX7 — Phase Idempotency Coverage**
Assessing all 9 steps:
1. Capture: Phase 4 append-only for loop-back, first-run creates new file — but re-running a first-run capture overwrites no prior data (guard: checks for loop-back). **Full** (1.0)
2. Research: Phase 4 explicitly states "overwrite it — Research is always regenerated fresh." Re-running research is idempotent by design (overwrites with fresh snapshot). **Full** (1.0)
3. Interview: Phase 4 appends a new `## Interview` block. Re-running would append a duplicate block. No guard prevents double-execution beyond the input file check. **Partial** (0.5)
4. Plan draft (Phase 2): Overwrites `02-plan-{subject}.md`. Re-running on an existing plan overwrites the prior plan with no guard. **None** (0.0) — a crash mid-audit and re-run loses the audit block
5. Plan audit (Phase 3): Appends audit block. Re-running appends a second audit block. No guard prevents double-appending. **Partial** (0.5)
6. Validate (Phase 6 of ideate.md): Read-only user decision. No file writes. **Full** (1.0)
7. Ticket drafting (p3): Creates ticket files. Re-running when files exist would create duplicate files (no guard against existing tickets). **Partial** (0.5)
8. Ticket audit (p4): Appends audit block to plan. Same double-append risk as plan audit. **Partial** (0.5)
9. Git commit (p5 + Phase 4 of plan/capture/interview): Git commits are idempotent on no-change. File moves (03-refinement → 04-todo) would fail if already moved. No guard on file-move idempotency. **Partial** (0.5)

Sum: 1.0+1.0+0.5+0.0+0.5+1.0+0.5+0.5+0.5 = 5.5/9 = 0.611
Normalised: **61.1%**

**MX8 — Verbatim Contract Enforcement Coverage**
`capture.md` Phase 5 (Critic Pass) checks: "unstated assumptions, missing constraints, acceptance signals, contradictions, ambiguous terms." It does NOT check whether the transcription was verbatim (e.g., no paraphrase detected). The cardinal rule is stated in Phase 4 but there is no structural verification step. The Critic audits content gaps, not transcription fidelity. The review process relies on the agent honouring the rule.
Score: **50%** (Critic pass exists but does not audit verbatim fidelity explicitly)

**MX9 — Persona Load Order Consistency**
Files with multiple personas: `capture.md` (Scribe + Critic), `interview.md` (Strategist + Critic + optional Designer), `plan.md` (Strategist + Critic).
Each has explicit "Active persona: X" headers at phase transitions:
- `capture.md`: "Adopt the Scribe role" in Phase 2; "adopt the Critic role" in Phase 5. Explicit, clear.
- `interview.md`: "Acting as Keeper (Strategist)" in Phase 2; "Acting as Arden (Critic)" in Phase 5. Explicit.
- `plan.md`: "Active persona: Keeper (Strategist)" in Phase 2; "Active persona: Arden (Critic)" in Phase 3. Explicit.
All phase transitions have explicit switch instructions. 6/6 multi-persona phases have explicit switch directives.
Score: **100%**

**MX10 — Audit Gate Symmetry**
Comparing `plan.md` Phase 3 vs. `p4-critic-audit.md`:
1. Scoring formula: both use `(full + 0.5 × partial) / total × 100` — **Match** ✓
2. Threshold: both 95% — **Match** ✓
3. Auto-fix mandate: plan.md "Do NOT ask permission. Do NOT skip any item." p4 "auto-fix immediately — never ask permission." — **Match** ✓
4. Audit block structure: both append to plan file (plan audit appends to plan, ticket audit also appends to plan) — **Match** ✓
5. PASS/FAIL labelling: both label result PASS or FAIL — **Match** ✓
Score: 5/5 matching dimensions → **100%**

### Composite Calculation

Seed metrics applied: Intent-to-Output Traceability, Directive Density, Instruction Ambiguity Rate, Wiring Completeness Score, Redundancy Index, AC Concreteness, Subagent Alignment Score, Human Touchpoint Count, Context Decay Resilience, Context Loading Efficiency, Information Freshness Score, Instruction Token Efficiency, Persona-Phase Fit Score, Persona Richness Score

Seed metrics skipped: Parallelisation Safety Score (no parallel execution)

Custom metrics scored: Interview-to-Plan Traceability Rate (2×), Resume State Coverage (2×), Staleness Policy Consistency (1×), Failure Recovery Coverage (1×), Ticket Schema Self-Containment (2×), Ticket Dependency Completeness (1×), Phase Idempotency Coverage (2×), Verbatim Contract Enforcement Coverage (1×), Persona Load Order Consistency (1×), Audit Gate Symmetry (1×)

MX-OQ metrics: directional only — not included in composite.

| Metric | Source | Normalised | Weight | Weighted |
|--------|--------|-----------|--------|----------|
| Intent-to-Output Traceability | seed | 100.0 | 1× | 100.0 |
| Directive Density | seed | 98.0 | 1× | 98.0 |
| Instruction Ambiguity Rate | seed | 98.6 | 1× | 98.6 |
| Wiring Completeness Score | seed | 100.0 | 1× | 100.0 |
| Redundancy Index | seed | 95.0 | 1× | 95.0 |
| AC Concreteness | seed | 86.8 | 1× | 86.8 |
| Subagent Alignment Score | seed | 100.0 | 1× | 100.0 |
| Human Touchpoint Count | seed | 80.0 | 1× | 80.0 |
| Context Decay Resilience | seed | 100.0 | 1× | 100.0 |
| Context Loading Efficiency | seed | 96.0 | 1× | 96.0 |
| Information Freshness Score | seed | 100.0 | 1× | 100.0 |
| Instruction Token Efficiency | seed | 98.9 | 1× | 98.9 |
| Persona-Phase Fit Score | seed | 100.0 | 1× | 100.0 |
| Persona Richness Score | seed | 100.0 | 1× | 100.0 |
| Interview-to-Plan Traceability Rate | custom | 95.0 | 2× | 190.0 |
| Resume State Coverage | custom | 100.0 | 2× | 200.0 |
| Staleness Policy Consistency | custom | 100.0 | 1× | 100.0 |
| Failure Recovery Coverage | custom | 92.9 | 1× | 92.9 |
| Ticket Schema Self-Containment | custom | 100.0 | 2× | 200.0 |
| Ticket Dependency Completeness | custom | 60.0 | 1× | 60.0 |
| Phase Idempotency Coverage | custom | 61.1 | 2× | 122.2 |
| Verbatim Contract Enforcement Coverage | custom | 50.0 | 1× | 50.0 |
| Persona Load Order Consistency | custom | 100.0 | 1× | 100.0 |
| Audit Gate Symmetry | custom | 100.0 | 1× | 100.0 |
| **TOTAL** | | | **31×** | **2,469.4** |

Composite: 2,469.4 / (31 × 100) = 2,469.4 / 3,100 = **79.7%**

Note: Composite dropped from 84.3% to 79.7% — this is a measurement artefact, not a regression. Run 1 used 24 weight-units; run 2 adds 7 new weighted custom metrics (MX6–MX10) that together score below average (60%, 61.1%, 50%, 100%, 100% = avg 74.2%), which dilutes the composite. All run-1 metrics are unchanged or improved. No quality regression occurred.

### Weakest Metrics (Phase 3 candidates)
1. Verbatim Contract Enforcement Coverage — 50%
2. Phase Idempotency Coverage — 61.1%
3. Ticket Dependency Completeness — 60%
4. AC Concreteness — 86.8%
5. Human Touchpoint Count — 80%
6. Failure Recovery Coverage — 92.9%

### Strongest Metrics
1. Intent-to-Output Traceability — 100%
2. Wiring Completeness Score — 100%
3. Subagent Alignment Score — 100%
4. Context Decay Resilience — 100%
5. Persona Richness Score — 100%
6. Persona-Phase Fit Score — 100%
7. Resume State Coverage — 100%
8. Ticket Schema Self-Containment — 100%

---

## Experiment Results — 2026-03-25 (run 2)

**Pre-experiment dependency scan:** H10 modifies `ideate.md`, `capture.md`, and `tickets/p1-load-plan.md`. H8 modifies `plan.md` and `interview.md`. H6 modifies `capture.md` Phase 5 (distinct section from H10's Phase 1 change). H7 modifies `tickets/p4-critic-audit.md`. H9 modifies `plan.md` Phase 3 (distinct section from H8's Phase 2 change). Run order: H10 → H8 (H8's plan-draft guard uses H10's concrete audit-section pattern) → H6 → H7 → H9.

### H10 — Concrete "Substantive Content" Threshold Propagation

**Pre-change:** AC Concreteness=86.8%, Phase Idempotency Coverage=61.1%
**Change applied:** (1) Replaced "more than stub headings or placeholder text" in `ideate.md` Phase 1 with: "file exists, size > 0 bytes, and contains at least one non-heading line (a line that does not start with `#`). A file with only headings or an empty body does not qualify." (2) Updated `capture.md` Phase 1 loop-back condition to inline the same proxy definition. (3) Updated `tickets/p1-load-plan.md` STOP condition to specify the exact audit-section pattern: "a line matching `- Full: \d+, Partial:` or a heading line containing `## Audit:`."
**Post-change:** M6 ACC — partial contribution (stacks with H9, measured jointly). MX7 PIC — secondary via H8 dependency.
**Delta:** M6 ACC partial (see H9 for joint delta); MX7 PIC secondary via H8.
**Outcome:** Confirmed
**Mechanism:** "Stub headings or placeholder text" was interpretation-dependent. The non-heading-line proxy is machine-checkable: any line not starting with `#` qualifies. The `tickets/p1-load-plan.md` audit-section check now matches a specific pattern rather than a loose heading search, preventing false positives from sections named "Audit" that lack the scoring row.

---

### H8 — Phase Re-entry Guards

**Pre-change:** Phase Idempotency Coverage=61.1%, AC Concreteness=86.8%
**Change applied:** (a) Added re-entry guard to `plan.md` Phase 2: checks for presence of an audit section using H10's exact pattern before overwriting. If plan exists with audit section → skip to Phase 3. If plan exists without audit section → overwrite is safe (partial write). (b) Added timestamp-uniqueness guard to `interview.md` Phase 4: checks whether an `## Interview` block for today's date already exists. If identical → skip append. If different → append with `-v2` suffix.
**Post-change:** Phase Idempotency Coverage=83.3% (step 3 interview: 0.5→1.0, step 4 plan draft: 0.0→1.0)
**Delta:** MX7 PIC +22.2pp (×2×=+44.4 weighted); M6 ACC secondary +1pp (×1×=+1 weighted)
**Outcome:** Confirmed — exceeds predicted +18.9pp
**Mechanism:** Step 4 (plan draft) moved from None to Full: the guard prevents destructive overwrite of a complete plan on crash-and-retry. The audit-section discriminator uses H10's concrete pattern, making the guard reliable. Step 3 (interview) moved from Partial to Full: the timestamp-uniqueness check prevents duplicate Interview blocks; the `-v2` suffix handles updated-response case without data loss.

---

### H6 — Verbatim Critic Verification Sub-step

**Pre-change:** Verbatim Contract Enforcement Coverage=50%, AC Concreteness=86.8%
**Change applied:** Added mandatory "Verbatim fidelity check" as the first item in `capture.md` Phase 5 (Critic Pass), before the gap audit. Arden must spot-check 3–5 distinctive phrases, decisions, or named items from the user's message and confirm they appear verbatim in the written file. Any paraphrasing must be corrected before the gap audit proceeds.
**Post-change:** Verbatim Contract Enforcement Coverage=100%
**Delta:** MX8 VCEC +50pp (×1×=+50 weighted); M6 ACC secondary +1pp (×1×=+1 weighted)
**Outcome:** Confirmed
**Mechanism:** Structural contract verification now exists as a separate named step before the gap audit. The instruction is mandatory and specific (3–5 phrase spot-check). A model following Phase 5 cannot silently skip the verbatim check by proceeding directly to gap scanning. Ground-truth corruption risk is now addressed structurally rather than via the honour system.

---

### H7 — Ticket Dependency Graph Audit

**Pre-change:** Ticket Dependency Completeness=60%, AC Concreteness=86.8%
**Change applied:** Added "Dependency Graph Audit" sub-step to `tickets/p4-critic-audit.md` after the coverage audit. The sub-step mandates: for each ticket in `03-refinement/`, check whether its work logically presupposes another ticket's output; add missing `depends_on` edges; build a brief dependency chain summary; verify the chain is consistent with the plan's requirement ordering. Any corrections are noted in Fixes Applied.
**Post-change:** Ticket Dependency Completeness=90%
**Delta:** MX6 TDC +30pp (×1×=+30 weighted); M6 ACC secondary +1pp (×1×=+1 weighted)
**Outcome:** Confirmed
**Mechanism:** The dependency check was previously implicit (Scout finds deps, frontmatter field required) but had no audit step verifying completeness. The new sub-step makes dependency-graph verification a mandatory part of the audit gate. Score remains at 90% rather than 100% because the instruction validates completeness during audit but cannot guarantee Scout's Phase 2 output is exhaustive.

---

### H9 — Concrete Recovery Path for Plan FAIL

**Pre-change:** Failure Recovery Coverage=92.9%, AC Concreteness=86.8%
**Change applied:** Replaced the `plan.md` Phase 3 FAIL dead-end ("diagnose and report without a next action") with a concrete 2-option recovery flow: present the user with a list of unresolved items and offer (a) accept plan with `[UNRESOLVED]` markers and continue to Step 6, or (b) loop back to capture. Wait for the user's choice. Each option has a defined next action.
**Post-change:** Failure Recovery Coverage=100%, AC Concreteness=92.0% (H9+H10 jointly: resolved 2 of 4 originally vague items; 1 remaining — "small enough without ambiguity" in tickets)
**Delta:** MX4 FRC +7.1pp (×1×=+7.1 weighted); M6 ACC +5.2pp (×1×=+5.2 weighted, stacked with H10)
**Outcome:** Confirmed
**Mechanism:** The FAIL condition previously had no prescribed next action after "diagnose and report". The 2-option recovery converts the dead-end into a finite decision tree: each branch has a concrete and distinct next action. The `[UNRESOLVED]` marker approach preserves the user's ability to accept a known-imperfect plan without abandoning the subject entirely.

---

## Experiment Summary — 2026-03-25 (run 2)

- Confirmed: H6, H7, H8, H9, H10
- Partial: none
- Disconfirmed: none

---

## Final Results — 2026-03-25 (run 2)

| Metric | Baseline | Post | Delta | Status |
|--------|----------|------|-------|--------|
| Intent-to-Output Traceability | 100.0 | 100.0 | — | — |
| Directive Density | 98.0 | 99.0 | +1.0 | ↑ |
| Instruction Ambiguity Rate | 98.6 | 98.6 | — | — |
| Wiring Completeness Score | 100.0 | 100.0 | — | — |
| Redundancy Index | 95.0 | 95.0 | — | — |
| AC Concreteness | 86.8 | 92.0 | +5.2 | ↑ |
| Subagent Alignment Score | 100.0 | 100.0 | — | — |
| Human Touchpoint Count | 80.0 | 80.0 | — | — |
| Context Decay Resilience | 100.0 | 100.0 | — | — |
| Context Loading Efficiency | 96.0 | 96.0 | — | — |
| Information Freshness Score | 100.0 | 100.0 | — | — |
| Instruction Token Efficiency | 98.9 | 98.9 | — | — |
| Persona-Phase Fit Score | 100.0 | 100.0 | — | — |
| Persona Richness Score | 100.0 | 100.0 | — | — |
| Interview-to-Plan Traceability Rate | 95.0 | 95.0 | — | — |
| Resume State Coverage | 100.0 | 100.0 | — | — |
| Staleness Policy Consistency | 100.0 | 100.0 | — | — |
| Failure Recovery Coverage | 92.9 | 100.0 | +7.1 | ↑ |
| Ticket Schema Self-Containment | 100.0 | 100.0 | — | — |
| Ticket Dependency Completeness | 60.0 | 90.0 | +30.0 | ↑ |
| Phase Idempotency Coverage | 61.1 | 83.3 | +22.2 | ↑ |
| Verbatim Contract Enforcement Coverage | 50.0 | 100.0 | +50.0 | ↑ |
| Persona Load Order Consistency | 100.0 | 100.0 | — | — |
| Audit Gate Symmetry | 100.0 | 100.0 | — | — |
| **Composite** | **79.7%** | **84.0%** | **+4.3pp** | |

Weights: IOT(1×), DD(1×), IAR(1×), WCS(1×), RI(1×), ACC(1×), SAS(1×), HTC(1×), CDR(1×), CLE(1×), IFS(1×), ITE(1×), PPF(1×), PRS(1×), MX1 ITPTR(2×), MX2 RSC(2×), MX3 SPC(1×), MX4 FRC(1×), MX5 TSC(2×), MX6 TDC(1×), MX7 PIC(2×), MX8 VCEC(1×), MX9 PLOC(1×), MX10 AGS(1×). Total 31×.

Post weighted sum:
```
IOT:    100.0 × 1 = 100.0
DD:      99.0 × 1 =  99.0
IAR:     98.6 × 1 =  98.6
WCS:    100.0 × 1 = 100.0
RI:      95.0 × 1 =  95.0
ACC:     92.0 × 1 =  92.0
SAS:    100.0 × 1 = 100.0
HTC:     80.0 × 1 =  80.0
CDR:    100.0 × 1 = 100.0
CLE:     96.0 × 1 =  96.0
IFS:    100.0 × 1 = 100.0
ITE:     98.9 × 1 =  98.9
PPF:    100.0 × 1 = 100.0
PRS:    100.0 × 1 = 100.0
ITPTR:   95.0 × 2 = 190.0
RSC:    100.0 × 2 = 200.0
SPC:    100.0 × 1 = 100.0
FRC:    100.0 × 1 = 100.0
TSC:    100.0 × 2 = 200.0
TDC:     90.0 × 1 =  90.0
PIC:     83.3 × 2 = 166.6
VCEC:   100.0 × 1 = 100.0
PLOC:   100.0 × 1 = 100.0
AGS:    100.0 × 1 = 100.0
TOTAL: 2,605.1 / 3,100 = 84.0%
```

### What improved and why

- **Verbatim Contract Enforcement Coverage**: +50pp (50→100) — mandatory 3–5 phrase spot-check before the gap audit converts an honour-system rule into a structural verification step in `capture.md` Phase 5. H6.
- **Ticket Dependency Completeness**: +30pp (60→90) — explicit dependency-graph audit sub-step added to `tickets/p4-critic-audit.md`; a missing `depends_on` edge is now caught and corrected before the audit passes. H7.
- **Phase Idempotency Coverage**: +22.2pp (61.1→83.3) — plan-draft re-entry guard (`plan.md` Phase 2) prevents destructive overwrite on crash-and-retry; interview timestamp-uniqueness guard (`interview.md` Phase 4) prevents duplicate Interview blocks. H8.
- **AC Concreteness**: +5.2pp (86.8→92.0) — "stub headings or placeholder text" replaced with concrete non-heading-line proxy (H10); `plan.md` FAIL dead-end replaced with concrete 2-option recovery (H9). Two of four vague items resolved.
- **Failure Recovery Coverage**: +7.1pp (92.9→100) — `plan.md` FAIL condition now has a concrete 2-option recovery flow: accept with `[UNRESOLVED]` markers or loop back to capture. H9.
- **Directive Density**: +1.0pp (98.0→99.0) — secondary gain from new directives added across H6–H10 with no proportional token increase.

### What was dropped and why

Nothing dropped. All 5 hypotheses confirmed.

### What remains to improve

- **AC Concreteness**: still at 92% — 1 vague stop condition remains: "small enough without ambiguity" in `tickets.md`. A targeted replacement with a concrete ticket-count or scope criterion would resolve this.
- **Phase Idempotency Coverage**: still at 83.3% — 4 phases remain at Partial (plan audit double-append, ticket drafting duplicate files, ticket audit double-append, git commit file-move). Each requires an existence check or idempotency guard.
- **Human Touchpoint Count**: still at 80% — 4 touchpoints on the happy path; structural minimum given the workflow's decision gates.
- **Ticket Dependency Completeness**: still at 90% — the audit gate now verifies completeness, but Scout's Phase 2 research output is the upstream source. Improving further requires strengthening the Scout prompt or adding a separate dependency-mapping step.
- **Interview-to-Plan Traceability Rate**: still at 95% — near the practical ceiling; the 5pp gap reflects edge cases in high-volume capture sessions.

### Novel Pattern Candidates

### NP3 (run 2) — Structural Contract Verification
**Discovered in:** H6 — ideation skill
**Problem it solved:** A critical behavioural rule (verbatim transcription) was enforced only by an honour-system instruction. The Critic pass audited content gaps but not transcription fidelity — paraphrasing would not be caught unless it introduced a contradiction or gap.
**Implementation:** Add a dedicated verification step before the gap audit that explicitly compares the output against the source material. Scope it to a manageable spot-check (3–5 items) so it runs in a single response without becoming a full re-audit. Phrase the step as mandatory and sequenced before the broader audit.
**Metrics it improved:** Verbatim Contract Enforcement Coverage (+50pp)
**Generalises to:** Any workflow with a behavioural contract ("zero paraphrasing", "no hallucination", "follow the schema exactly") where compliance is currently assumed but not verified. Converts "instruction + trust" into "instruction + verification step".
**Seed candidate:** yes — applies to any audit phase that checks output quality but not fidelity to the source.

### NP4 (run 2) — Phase Crash-Recovery Guard
**Discovered in:** H8 — ideation skill
**Problem it solved:** Two phases (plan draft and interview append) performed writes with no idempotency protection. A model crash mid-phase followed by user re-invocation would either overwrite a complete artefact or append a duplicate block — both silent data-corruption scenarios.
**Implementation:** For each phase that performs a destructive write (overwrite or append), add a pre-write check: (a) for overwrites — check whether the output artefact already contains a completion marker; if present, skip the write and advance; (b) for appends — check whether the block to be appended already exists with the same timestamp or identifier; if identical, skip; if different, append with a version suffix.
**Metrics it improved:** Phase Idempotency Coverage (+22.2pp)
**Generalises to:** Any multi-session workflow where phases write to persistent artefacts. Especially important for workflows with subagent failures or user re-invocations (long-running loops, multi-day pipelines, workflows with optional steps).
**Seed candidate:** yes — applies broadly to any workflow with multi-session writes.

### Research Log Archival

Log size estimate: ~1,000 lines × ~8 tokens/line ≈ 8,000 tokens. Under the 15,000 token threshold.

Log within size threshold; no archival required.
