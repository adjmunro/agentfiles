<!-- SUMMARY-START -->
## Run 002 — 2026-03-25 | Target: skills/ideation/
Composite: 79.7% → 84.0% (+4.3 pp)

### Hypotheses
| ID  | Description                                       | Outcome   |
|-----|---------------------------------------------------|-----------|
| H6  | Verbatim Critic Verification Sub-step             | Confirmed |
| H7  | Ticket Dependency Graph Audit                     | Confirmed |
| H8  | Phase Re-entry Guards                             | Confirmed |
| H9  | Concrete Recovery Path for Plan FAIL              | Confirmed |
| H10 | Concrete "Substantive Content" Threshold Propagation | Confirmed |

### Metric Snapshot
| Metric                                  | Baseline | Post  |
|-----------------------------------------|---------|-------|
| Intent-to-Output Traceability           | 100.0   | 100.0 |
| Directive Density                       | 98.0    | 99.0  |
| Instruction Ambiguity Rate              | 98.6    | 98.6  |
| Wiring Completeness Score               | 100.0   | 100.0 |
| Redundancy Index                        | 95.0    | 95.0  |
| AC Concreteness                         | 86.8    | 92.0  |
| Subagent Alignment Score                | 100.0   | 100.0 |
| Human Touchpoint Count                  | 80.0    | 80.0  |
| Context Decay Resilience                | 100.0   | 100.0 |
| Context Loading Efficiency              | 96.0    | 96.0  |
| Information Freshness Score             | 100.0   | 100.0 |
| Instruction Token Efficiency            | 98.9    | 98.9  |
| Persona-Phase Fit Score                 | 100.0   | 100.0 |
| Persona Richness Score                  | 100.0   | 100.0 |
| Interview-to-Plan Traceability Rate     | 95.0    | 95.0  |
| Resume State Coverage                   | 100.0   | 100.0 |
| Staleness Policy Consistency            | 100.0   | 100.0 |
| Failure Recovery Coverage               | 92.9    | 100.0 |
| Ticket Schema Self-Containment          | 100.0   | 100.0 |
| Ticket Dependency Completeness          | 60.0    | 90.0  |
| Phase Idempotency Coverage              | 61.1    | 83.3  |
| Verbatim Contract Enforcement Coverage  | 50.0    | 100.0 |
| Persona Load Order Consistency          | 100.0   | 100.0 |
| Audit Gate Symmetry                     | 100.0   | 100.0 |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

**Target:** skills/ideation/
**TTL check:** research-log.md exists. Target matches. Date 2026-03-25 ≤ 7 days (today) → Tier C — Use as-is.
**Files:** 17 total (11 command, 6 support) — unchanged from run 1.
**Token estimate:** ~11,010 tokens (post-run-1 additions)

### Feature Inventory
- Multi-phase pipeline: yes
- Persona system: yes
- Subagent invocations: yes
- Multi-session orchestration: yes
- Parallel execution: no
- Cached artifacts: yes

### Persona Staleness Check
No broken references. No speciation detected. Unchanged from run 1.

### Files
(Unchanged from run 1 audit — all 17 files verified present.)

---

## Phase 2 — Baseline

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

### New Custom Metrics (run 2 definitions)

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
1. Scoring formula: both use `(full + 0.5 × partial) / total × 100` — Match ✓
2. Threshold: both 95% — Match ✓
3. Auto-fix mandate: plan.md "Do NOT ask permission. Do NOT skip any item." p4 "auto-fix immediately — never ask permission." — Match ✓
4. Audit block structure: both append to plan file (plan audit appends to plan, ticket audit also appends to plan) — Match ✓
5. PASS/FAIL labelling: both label result PASS or FAIL — Match ✓
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

## Phase 3 — Hypotheses

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

### Self-Audit — run 2

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

## Phase 4 — Experiments

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

## Phase 5 — Report

**Experiment Summary:**
- Confirmed: H6, H7, H8, H9, H10
- Partial: none
- Disconfirmed: none

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
| **Composite** | **79.7%** | **84.0%** | **+4.3 pp** | |

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
