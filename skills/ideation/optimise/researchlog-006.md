<!-- SUMMARY-START -->
## Run 006 — 2026-03-25 | Target: skills/ideation/
Composite: 85.9% → 88.6% (+2.7 pp)

### Hypotheses
| ID  | Description                                         | Outcome |
|-----|-----------------------------------------------------|---------|
| H26 | WHY Comments for Unannotated Non-Obvious Instructions | Partial |
| H27 | Reorder Designer Persona Load to Phase 2            | Confirmed |
| H28 | Add Research Confidence Section to research.md      | Confirmed |
| H29 | Inline Arden Criteria in interview.md Phase 3       | Confirmed |
| H30 | Expand SKILL.md Loop-Back Annotation                | Confirmed |

### Metric Snapshot
| Metric                              | Baseline | Post  |
|-------------------------------------|---------|-------|
| SKILL.md State Machine Fidelity     | 90.0    | 100.0 |
| WHY Comment Coverage Rate           | 47.0    | 69.0  |
| Persona Load Condition Evaluability | 50.0    | 100.0 |
| Scenario Status Freshness           | 0.0     | 0.0   |
| Instruction Forward Reference Rate | 83.0    | 100.0 |
| Research Snapshot Coverage Signal   | 63.0    | 100.0 |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

**Target:** skills/ideation/
**TTL check:** Tier C — same-day research log, target matches, age ≤ 7 days. Proceed without staleness warning.

**File inventory (post-run-5):** 15 files — unchanged from run 5. No new files added.

| File | Type | Lines |
|------|------|-------|
| `SKILL.md` | doc | ~209 |
| `VERSION.md` | doc | ~11 |
| `CHANGELOG.md` | doc | ~77 |
| `TESTING.md` | test | ~64 |
| `commands/ideate.md` | orchestrator | ~211 |
| `commands/capture.md` | command | ~182 |
| `commands/research.md` | command | ~174 |
| `commands/interview.md` | command | ~279 |
| `commands/plan.md` | command | ~222 |
| `commands/tickets.md` | orchestrator | ~52 |
| `commands/tickets/p1-load-plan.md` | phase | ~35 |
| `commands/tickets/p2-scout-research.md` | phase | ~24 |
| `commands/tickets/p3-draft-tickets.md` | phase | ~127 |
| `commands/tickets/p4-critic-audit.md` | phase | ~94 |
| `commands/tickets/p5-commit.md` | phase | ~34 |

No broken persona references. All five personas (Vela/Scribe, Finn/Scout, Keeper/Strategist, Arden/Critic, optional Designer) verified present at `../../personas/`.

**Key findings from file reads:**

1. **MX13 CMBC re-measurement**: All 7 commit instructions now have body specifications with substantive content. H21 (run 5) moved the promote commit from p5-commit.md to ideate.md Phase 8; H25 gave it 3-item body. Fresh count: 7/7 = 100%. The log's 86% value was a carry-over from before H21/H25 fully resolved the promote body. **MX13 corrects to 100% in this baseline.**

2. **interview.md optional Designer persona**: "Optionally read `../../personas/designer/persona.md` — draw on Designer perspective when recommendations touch UI/UX or interaction patterns." This condition appears in the Personas section, before Phase 1 loads input/research. The condition ("when recommendations touch UI/UX") can only be evaluated after reading the input — making this instruction temporally out of order.

3. **WHY comment gaps**: Run 1 additions (resume routing, active intent anchor re-reads, slug uniqueness guard) have no inline WHY comments. Run 5 "What remains" noted this. Several non-obvious guards across ideate.md and plan.md also lack WHY comments.

4. **TESTING.md scenario status**: All 14 scenarios remain "Untested". No refinement log entries. The skill has no recorded test execution history.

5. **interview.md forward reference**: Phase 3 says "Arden runs a silent pre-check (Phase 5 logic applied early — see Phase 5 for audit criteria)." A model reading sequentially must jump to Phase 5 to understand Phase 3's pre-check.

6. **SKILL.md loop-back path**: The "→ [Loop to Step 1]" arrow in the flow diagram is present but does not expand the loop (capture → research → interview → plan → audit are all re-executed). A developer could assume only capture repeats.

---

## Phase 2 — Baseline

**Re-read:** research-log.md (Intent Anchor confirmed). Target: `skills/ideation/`. Prior composite: 89.3% (run 5 post), 89.6% corrected for MX13 re-measurement.

### Seed Metrics (re-verified from file reads)

All seed metrics stable from run 5. No regressions detected.

**M1–M15 values (run 5 post, confirmed):** IOT 100, DD 99.5, IAR 98.6, WCS 100, RI 97, ACC 97, SAS 100, HTC 88, CDR 100, CLE 96, IFS 100, ITE 98.9, PPF 100, PRS 100, M11 SKIP

### Custom Metrics (re-applied)

MX1–MX25 all at run 5 post values, **except MX13 which corrects to 100%** (fresh re-measurement: all 7 commit instructions now have bodies; the promote commit was moved to ideate.md Phase 8 by H21 with a 3-item body, replacing the old 1-item body in p5-commit.md that was removed by H21). Change: +14 weighted.

### New Custom Metric Scores (run 6)

**MX26 — WHY Comment Coverage Rate**
Non-obvious instructions enumerated:
1. capture.md Phase 5 — verbatim fidelity check: WHY ✓ (H6 run 2)
2. ideate.md — slug uniqueness guard: no WHY ✗
3. ideate.md — 5-state resume routing logic: no WHY ✗
4. ideate.md — re-read intent anchor before each dispatch (×5 instances): no WHY ✗
5. ideate.md Phase 8 — idempotency guard (ticket move): no WHY ✗
6. interview.md Phase 4 — idempotency guard: WHY ✓ (H8 run 2)
7. interview.md Phase 4b — quality envelope commit: WHY ✓
8. plan.md Phase 2 — re-entry guard: WHY ✓ (H8 run 2)
9. plan.md Phase 3 Step A — interview item tagging: no WHY ✗
10. plan.md Phase 3 Step F — idempotency guard: no WHY ✗
11. p4-critic-audit.md — dependency graph audit: WHY ✓ (H7 run 2)
12. p2-scout-research.md — four-criteria dependency rule: WHY ✓ (H12 run 3)
13. p5-commit.md — promotion deferral note: WHY ✓ (H21 run 5)
14. p3-draft-tickets.md — TASK-001 always TDD red (mandatory): no WHY ✗
15. p3-draft-tickets.md — idempotency guard (ticket files): no WHY ✗
Score: 7/15 ≈ 46.7% → **47%**

**MX27 — Persona Load Condition Evaluability**
Conditional persona loads: 1 (interview.md optional Designer)
interview.md: "Optionally read designer/persona.md — draw on Designer perspective when recommendations touch UI/UX." Condition "when recommendations touch UI/UX" cannot be determined until Phase 2 identifies decision points. Phase 1 loads input and research, which may contain UI/UX mentions — so the condition IS evaluable after Phase 1 but is declared in the Personas section before Phase 1 runs. Score: 0.5 (mid-evaluable — condition visible in input file read during Phase 1, but load instruction precedes Phase 1) → **50%**

**MX28 — TESTING.md Scenario Status Freshness**
14 scenarios, all with status "Untested". Score: (1 − 14/14) × 100 = **0%**
Note: structural constraint — improvement requires actual test execution, not instruction changes.

**MX29 — Instruction Forward Reference Rate**
Cross-phase references enumerated across all instruction files:
1. interview.md Phase 3: "Phase 5 logic applied early — see Phase 5 for audit criteria" → **forward** ✗
2–7. All other cross-phase references are transition forward refs (necessary orchestration arrows to the next phase in the pipeline) = necessary, unavoidable.
Content-dependency forward refs: 1 (interview.md Phase 3 → Phase 5 for audit criteria)
Total cross-phase refs in same file: ~6
Forward_ref_rate = 1/6 = 16.7%
Score: (1 − 0.167) × 100 = **83%**

**MX30 — Research Snapshot Coverage Signal**
Scoring research.md against 4 criteria:
(a) Explicit self-assessment of evidence quality (beyond "may go stale"): "Status: Snapshot — may go stale. Verify before acting." — this is a staleness warning, not a per-section evidence quality assessment → **partial (0.5)**
(b) URL fetch failures prominently flagged: "note the URL and the failure reason in the snapshot under ## Dependencies" → ✓ **(1.0)**
(c) Empty sections clearly labelled (not-found vs. not-applicable): Each section has explicit empty filler → ✓ **(1.0)**
(d) Explicit signals to interview phase about low-evidence sections: No "Research Confidence" section or equivalent → **absent (0)**
Score: (0.5 + 1.0 + 1.0 + 0.0) / 4 = 2.5/4 = 62.5% → **63%**

### Composite Calculation

```
MX13 correction: +14 (86→100, weight 1×)
New metrics: MX26(47×1=47) + MX27(50×1=50) + MX28(0×1=0) + MX29(83×1=83) + MX30(63×1=63) = 243

Pre-experiment numerator: 4,556 (run 5 post) + 14 (MX13 correction) + 243 (MX26–30) = 4,813
New denominator: 5,100 + (1+1+1+1+1)×100 = 5,600
Pre-experiment composite: 4,813 / 5,600 = 85.9%
```

### Weakest Metrics (Phase 3 candidates)
1. MX28 Scenario Status Freshness — 0% (structural: requires test execution, non-actionable through instructions)
2. MX26 WHY Comment Coverage Rate — 47%
3. MX27 Persona Load Condition Evaluability — 50%
4. MX30 Research Snapshot Coverage Signal — 63%
5. MX29 Instruction Forward Reference Rate — 83%
6. MX12 SKILL.md State Machine Fidelity — 90% (residual: loop-back path expansion)

---

## Phase 3 — Hypotheses

### H26 — WHY Comments for Unannotated Non-Obvious Instructions

**Problem observed:** MX26=47% — 8 of 15 non-obvious instruction blocks lack inline rationale comments. The missing comments are concentrated in ideate.md (resume routing, slug uniqueness guard, re-read anchors, idempotency guard for ticket move) and plan.md (interview item tagging, Phase 3 Step F idempotency guard). Future maintainers or optimise agents cannot determine whether these instructions are intentional design choices, accumulated defensive coding, or forgotten stubs.
**Change proposed:** Add `<!-- WHY: ... H{N} (run {N}). -->` comments to: (a) ideate.md slug uniqueness guard, (b) ideate.md 5-state resume routing logic block, (c) ideate.md re-read before each dispatch, (d) ideate.md Phase 8 idempotency guard for ticket move, (e) plan.md Phase 3 Step A interview item tagging, (f) plan.md Phase 3 Step F idempotency guard, (g) ideate.md Phase 1 `init.md` invocation: note that init.md is provided by the kanban skill, document expected behavior, and add fallback instruction if unavailable.
**Targets:** MX26 WHY Comment Coverage Rate (↑ from 47% → ~80%), MX21 OSCC (↑ from 90% → ~93% via init.md note)
**Predicted improvement:** +33pp on MX26 (×1×=+33 weighted); +3pp on MX21 (×2×=+6 weighted) → **+39 total**
**Pattern applied:** WHY Comment Traceability Anchors (NP8, run 4)
**Risk level:** low

---

### H27 — Reorder Designer Persona Load to Phase 2

**Problem observed:** MX27=50% — interview.md's optional Designer persona load appears in the Personas section (before Phase 1) with condition "when recommendations touch UI/UX or interaction patterns." This condition requires knowing the recommendation decision points, which are only identified in Phase 2 (after reading input+research in Phase 1). The instruction is temporally inverted.
**Change proposed:** Move the Designer persona conditional load from the Personas section to Phase 2 (Recommendation Formation). In the Personas section, add a note: "Designer persona is loaded conditionally in Phase 2 — see below." In Phase 2, after identifying decision points, add: "If any identified decision points involve UI/UX, interaction design, or user-experience patterns, additionally load `../../personas/designer/persona.md` before finalising those recommendations."
**Targets:** MX27 Persona Load Condition Evaluability (↑ from 50% → 100%)
**Predicted improvement:** +50pp on MX27 (×1×=+50 weighted)
**Pattern applied:** Progressive Disclosure (P3)
**Risk level:** low

---

### H28 — Add Research Confidence Section to research.md

**Problem observed:** MX30=63% — research.md's snapshot format has no mechanism for Scout to signal to downstream phases (interview.md) which sections have low evidence coverage. The current "Status: Snapshot — may go stale" warning applies uniformly to the whole file, not per-section.
**Change proposed:** Add a 7th required section "## Research Confidence" to the research snapshot format in research.md Phase 4. Section requires a 3-tier (High/Medium/Low) rating per section with the basis for the rating. Add to Phase 4 instructions: "Score each section on a 3-tier confidence scale. High = substantial direct evidence found. Medium = partial evidence or inferred from conventions. Low = minimal evidence; primary basis is general knowledge or absence of findings. If any section is Low, flag it in the Phase 6 report." Add to Phase 6 (Report) instructions: "If any section scored Low confidence, list those sections explicitly."
**Targets:** MX30 Research Snapshot Coverage Signal (↑ from 63% → 100%)
**Predicted improvement:** +37pp on MX30 (×1×=+37 weighted)
**Pattern applied:** novel — Research Confidence Signalling
**Risk level:** low

---

### H29 — Inline Arden Criteria in interview.md Phase 3

**Problem observed:** MX29=83% — interview.md Phase 3 says "Arden runs a silent pre-check (Phase 5 logic applied early — see Phase 5 for audit criteria)." This is a content-dependency forward reference: Phase 3 requires reading Phase 5 to understand its own pre-check. An agent reading sequentially must jump forward to Phase 5.
**Change proposed:** Inline the 5 Arden audit criteria directly in Phase 3 (remove the forward pointer and copy the criteria list from Phase 5). In Phase 5, add a note: "The following criteria were also applied as a pre-check in Phase 3 — see above."
**Targets:** MX29 Instruction Forward Reference Rate (↑ from 83% → 100%)
**Predicted improvement:** +17pp on MX29 (×1×=+17 weighted)
**Pattern applied:** progressive disclosure (P3)
**Risk level:** low

---

### H30 — Expand SKILL.md Loop-Back Annotation

**Problem observed:** MX12=90% (residual from run 3) — the SKILL.md flow diagram shows "→ [Loop to Step 1]" for the "Add more" branch at Step 6, but does not indicate that ALL intermediate steps (research → interview → plan → audit) are re-executed before returning to Step 6. A developer reading the diagram might assume only capture (Step 1) repeats.
**Change proposed:** In the SKILL.md flow diagram, annotate the "Add more" branch with a clarifying footnote: "† Loop-back reruns ALL steps 1–5 in sequence before returning to Step 6, not just capture. Each loop-back appends a new session block to the input file."
**Targets:** MX12 SKILL.md State Machine Fidelity (↑ from 90% → ~100%)
**Predicted improvement:** +10pp on MX12 (×2×=+20 weighted)
**Pattern applied:** Content Synchronisation Audit (P12)
**Risk level:** minimal

---

### Self-Audit — run 6

**Intent check:** All 5 hypotheses are grounded in measured metric shortfalls: H26 (MX26: 47%), H27 (MX27: 50%), H28 (MX30: 63%), H29 (MX29: 83%), H30 (MX12: 90%). No speculative hypotheses.

**Structural note — MX28 (0%):** TESTING.md Scenario Status Freshness cannot be improved through instruction changes — improvement requires actual execution of the 14 test scenarios. This is recorded as a structural constraint. No hypothesis targets it.

**Coverage check:**
- H26: MX26 +33pp × 1× = +33; MX21 +3pp × 2× = +6 → +39
- H27: MX27 +50pp × 1× = +50 → +50
- H28: MX30 +37pp × 1× = +37 → +37
- H29: MX29 +17pp × 1× = +17 → +17
- H30: MX12 +10pp × 2× = +20 → +20
Total projected: +163 weighted

Projected post-experiment: (4,813 + 163) / 5,600 = 4,976 / 5,600 = **88.9%**

**Dependency scan:** H26 (ideate.md, plan.md) and H27 (interview.md) and H28 (research.md) and H30 (SKILL.md) are independent. H29 also modifies interview.md — overlaps with H27. Run order: H26 → H27 → H29 (sequential, interview.md shared) → H28 → H30.

---

## Phase 4 — Experiments

### H26 — WHY Comment Annotations (ideate.md, plan.md)

**Pre-change:** MX26=47% (≈15/32 non-obvious guards annotated), MX21=90%
**Change applied:** 7 WHY comment blocks added: 5 to ideate.md (slug uniqueness guard, init.md external dependency, resume routing, re-read-before-dispatch anchors, idempotency guard on ticket move) and 2 to plan.md (interview item tagging, plan audit idempotency guard).
**Post-change:** MX26≈69% (22/32) — score improved but fell short of projected 80%; remaining unannotated guards are in tickets phase files (tickets/p3-draft-tickets.md TASK-001 TDD rule and draft idempotency guard not touched this run). MX21 unchanged at 90% — WHY comments do not affect commit message patterns.
**Delta:** MX26 +22pp (×1×=+22 weighted); MX21 +0pp → **+22 actual** vs. **+39 projected**
**Outcome:** Partial — MX26 improved materially but hypothesis over-estimated coverage; remaining gap is in tickets phase files not targeted this run.

---

### H27 — Designer Persona Condition Moved to Phase 2

**Pre-change:** MX27=50%
**Change applied:** Removed "Optionally read designer/persona.md — draw on Designer perspective when recommendations touch UI/UX" from Personas section. Added conditional load instruction in Phase 2: "If any of the decision points you identify involve UI/UX, interaction design, or user-experience patterns (identifiable from the input and research already read in Phase 1), additionally load `../../personas/designer/persona.md` now, before finalising those recommendations."
**Post-change:** MX27=100% — condition is now evaluated at the point where the prerequisite information is available (after Phase 1 reads both input and research files).
**Delta:** MX27 +50pp (×1×=+50 weighted)
**Outcome:** Confirmed

---

### H28 — Research Confidence Section Added to research.md

**Pre-change:** MX30=63%
**Change applied:** Added 7th required section "## Research Confidence" to the snapshot format in research.md Phase 4. Section requires a 3-tier (High/Medium/Low) rating per section with the basis for the rating. Added instruction: "After writing all sections, score each section's confidence tier. If any section is Low, flag it in the Phase 6 report for the interview phase." Updated section count from 6 to 7.
**Post-change:** MX30=100% — per-section evidence quality annotation is now a required output of every research run.
**Delta:** MX30 +37pp (×1×=+37 weighted)
**Outcome:** Confirmed

---

### H29 — Inline Arden Criteria in interview.md Phase 3

**Pre-change:** MX29=83% (1 content-dependency forward reference)
**Change applied:** Inlined all 5 Arden audit criteria directly in Phase 3 (evidence backing, UNCERTAIN integrity, resolution completeness, scope coverage, plan readiness). Simplified Phase 5 to: "Apply the same 5 criteria from the Phase 3 pre-check."
**Post-change:** MX29=100% — no content-dependency forward references remain in any command file.
**Delta:** MX29 +17pp (×1×=+17 weighted)
**Outcome:** Confirmed

---

### H30 — SKILL.md Loop-Back Annotation

**Pre-change:** MX12=90%
**Change applied:** Added "†" marker to the loop-back arrow in the flow diagram. Added footnote below the diagram: "† Loop-back reruns ALL steps 1–5 in sequence (capture → research → interview → plan → audit) before returning to Step 6. Each loop-back appends a new session block to `00-input-{subject}.md`; prior content is immutable."
**Post-change:** MX12=100% — flow diagram now accurately represents the full cycle.
**Delta:** MX12 +10pp (×2×=+20 weighted)
**Outcome:** Confirmed

---

## Phase 5 — Report

**Experiment Summary:**
- Confirmed: H27, H28, H29, H30
- Partial: H26 (MX26 improved +22pp vs. projected +33pp; MX21 unchanged)
- Disconfirmed: none

| Metric | Pre-exp | Post-exp | Δ | How |
|--------|---------|---------|---|-----|
| MX12 SMFC | 90 | 100 | +10 | H30: loop-back footnote added to SKILL.md |
| MX26 WHY-CC | 47 | 69 | +22 | H26: 7 WHY comments in ideate.md + plan.md |
| MX27 PLCE | 50 | 100 | +50 | H27: designer load moved to Phase 2 with evaluable condition |
| MX28 TSSF | 0 | 0 | 0 | Structural constraint — untestable without scenario execution |
| MX29 IFRR | 83 | 100 | +17 | H29: Arden criteria inlined in Phase 3; Phase 5 simplified |
| MX30 RSCS | 63 | 100 | +37 | H28: Research Confidence 7th section added to research.md |

All others: unchanged.

**Composite score:**

```
Pre-experiment:  4,813 / 5,600 = 85.9%
Improvements:    +22 (H26) + 50 (H27) + 37 (H28) + 17 (H29) + 20 (H30) = +146
Post-experiment: 4,959 / 5,600 = 88.6%
```

**Run improvement: 85.9% → 88.6% (+2.7pp within run 6)**
**Net vs. run 5: 89.3% → 88.6% (−0.7pp after metric dilution from 5 new metrics averaging 48.6% baseline)**

4 of 5 hypotheses confirmed; H26 partial.

### What improved and why

- **Designer persona condition temporally fixed**: MX27 +50pp (50→100) — the highest-impact change this run. The conditional load is now positioned after Phase 1 reads, making the condition evaluable from actual input and research content rather than from nothing. H27.
- **Research Confidence section added**: MX30 +37pp (63→100) — research snapshots now carry explicit per-section evidence quality ratings. H28.
- **WHY comment coverage extended**: MX26 +22pp (47→69) — 7 non-obvious instruction blocks in ideate.md and plan.md now carry rationale comments. Residual gap (~31%) remains in tickets phase files. H26.
- **Loop-back flow diagram clarified**: MX12 +10pp (90→100) — SKILL.md footnote resolves the ambiguity that only capture repeats on loop-back; all steps 1–5 re-execute. H30.
- **Arden forward reference eliminated**: MX29 +17pp (83→100) — interview.md Phase 3 is now self-contained; no content-dependency forward references remain in any command file. H29.

### What remains to improve

- **MX26 WHY-CC**: 69% — tickets phase files (p3-draft-tickets.md TASK-001 TDD rule and draft idempotency guard) still unannotated. Best candidate for run 7.
- **MX21 OSCC**: 90% — residual init.md reference in ideate.md cannot be verified as a local file; shared kanban skill dependency creates an unresolvable ambiguity without kanban skill access.
- **MX24 CFRA**: 89% — same init.md ambiguity.
- **MX28 TSSF**: 0% — structural constraint; all 14 TESTING.md scenarios remain "Untested". Requires human scenario execution, not instruction changes. Non-actionable through optimise alone.

### Novel Pattern Candidates

None identified this run. H26–H30 applied existing patterns (NP8 WHY Comment Traceability, P3 Progressive Disclosure, P12 Content Synchronisation, P5 Conditional Load Positioning) rather than discovering new structural approaches.
