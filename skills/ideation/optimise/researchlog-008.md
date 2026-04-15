<!-- SUMMARY-START -->
## Run 008 — 2026-03-25 | Target: skills/ideation/
Composite: 85.7% → 90.9% (+5.2 pp)

### Hypotheses
| ID  | Description                                                                    | Outcome   |
|-----|--------------------------------------------------------------------------------|-----------|
| H36 | Add Research Confidence consumption rule to interview.md                       | Confirmed |
| H37 | Fix p4-critic-audit.md escape hatch option (b) — points to wrong re-entry     | Confirmed |
| H38 | Fix SKILL.md Nine-Step table — Steps 6 and 9 reference stale file locations    | Confirmed |
| H39 | Standardise STOP/WARN recovery messages across command files                   | Confirmed |
| H40 | Add WHY comments to 5 unannotated blocks in p4-critic-audit.md and ideate.md  | Confirmed |

### Metric Snapshot
| Metric            | Baseline | Post  |
|-------------------|----------|-------|
| MX26 WHY-CC       | 75       | 91    |
| MX36 SSRA         | 78       | 100   |
| MX37 ATCR         | 100      | 100   |
| MX38 RCSCR        | 0        | 100   |
| MX39 FSMC         | 69       | 100   |
| MX40 TAFRC        | 17       | 100   |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

TTL tier: **Tier C** — same-day research log, target matches, age ≤ 7 days. Proceed without staleness warning.

**Research log archival:** Runs 3–5 archived to `research-log-archive-runs3-5.md` before starting run 8. Log was approaching the 15,000-token threshold (~14,400 tokens post run 7).

**File inventory (post-run-7):**

| File | Type | Lines |
|------|------|-------|
| `SKILL.md` | doc | ~212 |
| `VERSION.md` | doc | ~11 |
| `CHANGELOG.md` | doc | ~103 |
| `TESTING.md` | test | ~68 |
| `commands/ideate.md` | orchestrator | ~218 |
| `commands/capture.md` | command | ~182 |
| `commands/research.md` | command | ~189 |
| `commands/interview.md` | command | ~282 |
| `commands/plan.md` | command | ~224 |
| `commands/tickets.md` | orchestrator | ~52 |
| `commands/tickets/p1-load-plan.md` | phase | ~35 |
| `commands/tickets/p2-scout-research.md` | phase | ~24 |
| `commands/tickets/p3-draft-tickets.md` | phase | ~133 |
| `commands/tickets/p4-critic-audit.md` | phase | ~110 |
| `commands/tickets/p5-commit.md` | phase | ~44 |

**Key findings from file reads:**

1. **SKILL.md step reference accuracy**: The Nine-Step Ideation Flow table has 2 stale references. Step 6 ("Validate with User") cites `commands/plan.md` (validation section) — but validation has been in `ideate.md` Phase 6 since H21/run 5. Step 9 ("Hard Stop Gate") cites `commands/tickets.md` (promotion section) — but promotion was moved to `ideate.md` Phase 8 in H21/run 5. Both references are 3 optimise runs out of date.

2. **interview.md does not consume the Research Confidence signal**: H28 (run 6) added a required `## Research Confidence` section to research.md. The producer was updated but the consumer was not — interview.md's Phase 2 confidence rules still contain no reference to the Research Confidence section. HIGH-confidence recommendations can still be derived from Low-confidence research sections, defeating the purpose of the signal.

3. **p4-critic-audit.md escape hatch option (b) is broken**: The 3-pass escape hatch (H33/run 7) offers option (b): "Return to plan.md to revise the plan before re-running tickets." Following this literally invokes plan.md directly, but plan.md's Phase 2 re-entry guard detects the existing audit section and skips redrafting. The correct path requires using ideate.md's "Add more" loop (not direct plan.md invocation) plus deleting 03-refinement/ contents before re-running tickets — neither of which is mentioned.

4. **STOP/WARN message inconsistency**: interview.md Phase 1 STOP uses `/ideation capture` (wrong prefix); interview.md Phase 1 WARN uses `/ideation research` (wrong prefix). plan.md Phase 1 STOPs use "Run capture (Step 1) first" (no slash command). Consistent format established by: research.md ("`/ideate` (capture step)" ✓), p1-load-plan.md ("`/ideate` through Step N" ✓). 4 of 13 STOP/WARN messages are inconsistent.

5. **WHY comments missing from p4-critic-audit.md non-obvious blocks**: Four blocks added in runs 2 and 7 carry no inline WHY rationale: Reverse Traceability Check (H32/run 7), auto-fix "never ask permission" mandate, 3-pass escape hatch (H33/run 7), and Audit Block idempotency guard. Also: ideate.md Phase 7 plan audit precondition has no WHY comment.

---

## Phase 2 — Baseline

**Re-read:** research-log.md (Intent Anchor confirmed). Target: `skills/ideation/`. Prior composite: 89.8% (run 7 post) = 5,565 / 6,200.

### Seed Metrics (re-verified)

All seed metrics stable from run 7. No regressions.

**M1–M15 values (confirmed):** IOT 100, DD 99.5, IAR 98.6, WCS 100, RI 97, ACC 97, SAS 100, HTC 88, CDR 100, CLE 96, M11 SKIP, IFS 100, ITE 98.9, PPF 100, PRS 100

### Custom Metrics (re-applied)

MX1–MX35 unchanged from run 7 post.

### New Custom Metric Definitions (run 8)

#### MX36 — SKILL.md Step Reference Accuracy (SSRA) [custom]
**Measures:** What fraction of the Nine-Step Ideation Flow table entries in SKILL.md reference the correct command file for their step's actual implementation.
**Why seeds miss it:** MX12 (SMFC) measures state machine diagram fidelity; no metric measures accuracy of the prose command-file citations in the step table. The table is the primary developer navigation aid — stale references send developers to the wrong file.
**Methodology:** Enumerate all 9 rows. For each, verify the cited command file is the file that actually implements that step. Score = correct_references / 9.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

#### MX37 — Audit Threshold Consistency Rate (ATCR) [custom]
**Measures:** Whether all audit gates in the skill use the same quality threshold (95%) consistently, with no gate using a different value without explicit justification.
**Why seeds miss it:** M6 (ACC) measures whether stop conditions exist; no metric tracks cross-gate consistency of the specific threshold value. Inconsistent thresholds create an uneven quality floor — tickets could pass a lower bar than the plan they implement.
**Methodology:** Enumerate all audit threshold references across skill files. Verify each states 95%. Score = consistent_thresholds / total_thresholds.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

#### MX38 — Research Confidence Signal Consumption Rate (RCSCR) [custom]
**Measures:** Whether interview.md's Phase 2 confidence assignment logic explicitly consumes the `## Research Confidence` section produced by research.md (H28/run 6), such that Low-confidence research sections override recommendation confidence levels.
**Why seeds miss it:** MX30 (RSCS) measured whether the confidence signal is *produced* (reached 100% in run 6). No metric measured whether the downstream consumer *uses* that signal. A signal produced but never consumed has zero effect on output quality. This is the producer→consumer link metric.
**Methodology:** Score 1 if interview.md's confidence rules reference the Research Confidence section and specify how Low ratings affect recommendation confidence. Score 0 otherwise.
**Direction:** ↑ higher is better
**Weight:** 2× — a signal produced but not consumed is equivalent to MX30=0% from the output perspective
**Normalisation:** binary × 100

#### MX39 — FAIL-path Stop Message Consistency (FSMC) [custom]
**Measures:** What fraction of STOP and WARN recovery messages across skill command files reference the `/ideate` command (or consistent equivalent) to guide users back to the correct entry point.
**Why seeds miss it:** M6 (ACC) measures whether stop conditions exist; no metric measures whether the recovery instruction within the stop message is actionable. "Run capture first" is less actionable than "Run `/ideate` (Step 1: Capture) first" in a multi-skill environment with multiple entry points.
**Methodology:** Enumerate all STOP/WARN messages across command files. Classify: Actionable (references `/ideate` + step) or Vague. Score = actionable / total.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

#### MX40 — Ticket Audit Failure Recovery Clarity (TAFRC) [custom]
**Measures:** How clearly p4-critic-audit.md's escape hatch option (b) describes the actual recovery steps when the ticket audit cannot reach 95% — specifically whether it names the correct re-entry mechanism, addresses the plan.md re-entry guard conflict, and specifies 03-refinement/ cleanup.
**Why seeds miss it:** MX4 (FRC) measures whether failure recovery instructions exist; no metric measures whether they are accurate and complete. An escape hatch pointing to the wrong mechanism is actively harmful — a user following option (b) literally would invoke plan.md directly, which skips redrafting due to the re-entry guard.
**Methodology:** Score against 6 clarity criteria: (a) names `/ideate` "Add more" as correct re-entry; (b) does not instruct direct plan.md invocation; (c) addresses re-entry guard conflict (implicitly or explicitly); (d) specifies 03-refinement/ cleanup; (e) specifies re-running from Step 7; (f) both recovery options clearly distinguishable. Score = criteria_met / 6 × 100.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** criteria_met / 6 × 100

### New Custom Metric Scores (run 8)

**MX36 — SKILL.md Step Reference Accuracy**
Nine-step table verified:
1. Capture → `commands/capture.md` ✓
2. Research → `commands/research.md` ✓
3. Interview → `commands/interview.md` ✓
4. Write Plan → `commands/plan.md` ✓
5. Audit Plan → `commands/plan.md` (audit gate section) ✓
6. Validate with User → `commands/plan.md` (validation section) ✗ — validation is in `ideate.md` Phase 6
7. Write Tickets → `commands/tickets.md` ✓
8. Audit Tickets → `commands/tickets.md` (audit gate section) ✓
9. Hard Stop Gate → `commands/tickets.md` (promotion section) ✗ — promotion is in `ideate.md` Phase 8
Score: 7/9 = 77.8% → **78%**

**MX37 — Audit Threshold Consistency Rate**
1. plan.md Phase 3: 95% ✓
2. p4-critic-audit.md: 95% ✓
3. interview.md Phase 3/5: 95% ✓
Score: 3/3 = **100%**

**MX38 — Research Confidence Signal Consumption Rate**
interview.md Phase 2 confidence rules: `HIGH` (direct evidence) and `UNCERTAIN` (no clear evidence). No reference to `## Research Confidence` section or Low-confidence research sections.
Score: **0%**

**MX39 — FAIL-path Stop Message Consistency**
STOP/WARN messages enumerated (13 total):
1. research.md STOP (missing input): "Run `/ideate` (capture step) first" → actionable ✓
2. interview.md STOP (missing input): "Run `/ideation capture` first" → vague ✗
3. interview.md WARN (missing research): "Run `/ideation research` first" → vague ✗
4. plan.md STOP (file missing): "Run capture (Step 1) first" → vague ✗
5. plan.md STOP (empty content): "Run capture (Step 1) first" → vague ✗
6. p1-load-plan.md STOP (no plan): "Run `/ideate` through Step 6 first" → actionable ✓
7. p1-load-plan.md STOP (no audit): "Run `/ideate` through Step 5 first" → actionable ✓
8–13. capture.md, ideate.md, tickets.md STOP messages: actionable ✓ ×6
Score: 9/13 = 69.2% → **69%**

**MX40 — Ticket Audit Failure Recovery Clarity**
Escape hatch option (b) scored against 6 criteria:
(a) Names `/ideate` or "Add more" as re-entry → absent ✗
(b) Does not instruct direct plan.md invocation → fails (says "Return to plan.md") ✗
(c) Addresses plan.md re-entry guard → absent ✗
(d) Specifies 03-refinement/ cleanup → absent ✗
(e) Specifies re-running from Step 7 → absent ✗
(f) Both recovery options clearly distinguishable → ✓
Score: 1/6 = 16.7% → **17%**

### Composite Calculation

```
New metrics: MX36(78×1=78) + MX37(100×1=100) + MX38(0×2=0) + MX39(69×1=69) + MX40(17×1=17) = 264

Pre-experiment numerator: 5,565 (run 7 post) + 264 (MX36–40) = 5,829
New denominator: 6,200 + (1+1+2+1+1)×100 = 6,200 + 600 = 6,800
Pre-experiment composite: 5,829 / 6,800 = 85.7%
```

Metric dilution note: MX36–MX40 average (78+100+0+69+17)/5 = 52.8%, well below the 89.8% run-7 composite; dilution drops pre-experiment composite to 85.7%.

### Weakest Metrics (Phase 3 candidates)
1. MX38 RCSCR — 0%
2. MX28 TSSF — 0% (structural constraint, non-actionable)
3. MX40 TAFRC — 17%
4. MX39 FSMC — 69%
5. MX26 WHY-CC — 75%
6. MX36 SSRA — 78%

---

## Phase 3 — Hypotheses

### H36 — Add Research Confidence consumption to interview.md

**Problem observed:** MX38=0% — interview.md Phase 2 assigns confidence based on whether the research snapshot provides direct evidence. This logic was written before H28 (run 6) added the `## Research Confidence` section. Scout now writes per-section confidence ratings (High/Medium/Low) but Keeper never reads them. A recommendation about "Relevant Patterns" could be assigned HIGH if a pattern is mentioned, even if Scout rated that section Low-confidence.
**Change proposed:** Add a third confidence rule to Phase 2 after HIGH/UNCERTAIN: "Research Confidence override: check the `## Research Confidence` section in `01-research-{subject}.md`. For any recommendation derived primarily from a section rated Low, override its confidence to UNCERTAIN — regardless of other evidence. A Low-confidence section is primarily inference or general knowledge; treat it as if no codebase evidence exists for that area."
**Targets:** MX38 RCSCR (↑ from 0% → 100%)
**Predicted improvement:** +100pp on MX38 (×2×=+200 weighted)
**Pattern applied:** Novel — Research Confidence Propagation: when a producer phase writes an evidence quality signal, downstream consumers must explicitly check and act on that signal; a signal produced but not consumed has zero effect on output quality (NP11)
**Risk level:** low (additive rule; only activates when Low-confidence sections are present)

---

### H37 — Fix p4-critic-audit.md escape hatch option (b)

**Problem observed:** MX40=17% — option (b) says "Return to plan.md to revise the plan before re-running tickets." This is wrong: plan.md's re-entry guard detects the existing audit section and skips Phase 2 (plan redrafting). Recovery requires: (1) ideate.md's "Add more" loop, not direct plan.md invocation; (2) deleting 03-refinement/ before re-running tickets.
**Change proposed:** Replace option (b) with: "Revise the plan — return to `/ideate` and select 'Add more' at Step 6 to re-run the full capture → research → interview → plan → audit cycle; then delete the existing `03-refinement/` ticket files and re-run tickets from Step 7."
**Targets:** MX40 TAFRC (↑ from 17% → 100%)
**Predicted improvement:** +83pp on MX40 (×1×=+83 weighted)
**Pattern applied:** P10 (Failure Mode Registry) — accurate and complete recovery instructions for a failure state
**Risk level:** low (corrects wrong instructions to right ones; no logic change)

---

### H38 — Fix SKILL.md step reference table

**Problem observed:** MX36=78% — Steps 6 and 9 reference stale file locations. Step 6 → `commands/plan.md` (validation section) should be `commands/ideate.md` (Phase 6). Step 9 → `commands/tickets.md` (promotion section) should be `commands/ideate.md` (Phase 8). Both stale since H21/run 5.
**Change proposed:** Update Step 6 to `commands/ideate.md (Phase 6)`. Update Step 9 to `commands/ideate.md (Phase 8)`.
**Targets:** MX36 SSRA (↑ from 78% → 100%)
**Predicted improvement:** +22pp on MX36 (×1×=+22 weighted)
**Pattern applied:** P12 (Content Synchronisation Audit)
**Risk level:** minimal (documentation-only)

---

### H39 — Standardise STOP/WARN recovery messages

**Problem observed:** MX39=69% — 4 of 13 messages use inconsistent formats: interview.md uses `/ideation capture` and `/ideation research` (wrong prefix); plan.md uses "Run capture (Step 1) first" (no slash command). Consistent format: research.md uses "/ideate (capture step)"; p1-load-plan.md uses "/ideate through Step N".
**Change proposed:** interview.md STOP → `/ideate` (Step 1: Capture); interview.md WARN → `/ideate` (Step 2: Research); plan.md STOPs (×2) → "Run `/ideate` (Step 1: Capture) first".
**Targets:** MX39 FSMC (↑ from 69% → 100%)
**Predicted improvement:** +31pp on MX39 (×1×=+31 weighted)
**Pattern applied:** P5 (Conditional Load Positioning) + content standardisation
**Risk level:** low (message text only; `/ideation` was an old command prefix)

---

### H40 — WHY comments for unannotated p4-critic-audit.md and ideate.md blocks

**Problem observed:** MX26=75% — 5 non-obvious blocks have no WHY rationale: (1) Reverse Traceability Check in p4 (H32/run 7); (2) auto-fix "never ask permission" in p4; (3) 3-pass escape hatch in p4 (H33/run 7); (4) Audit Block idempotency guard in p4; (5) Phase 7 plan audit precondition in ideate.md.
**Change proposed:** Add WHY comments to all 5 blocks (see experiment results for exact text).
**Targets:** MX26 WHY-CC (↑ from 75% → ~91%)
**Predicted improvement:** +10pp on MX26 (×1×=+10 weighted) — conservative; actual improvement depends on whether denominator grows during annotation
**Pattern applied:** NP8 (WHY Comment Traceability Anchors)
**Risk level:** low (annotation-only; no logic change)

---

### Self-Audit — 2026-03-25 (run 8)

**Intent check:** All 5 hypotheses grounded in measured metric shortfalls: H36 (MX38: 0%), H37 (MX40: 17%), H38 (MX36: 78%), H39 (MX39: 69%), H40 (MX26: 75%). No speculative hypotheses.

**Coverage check:**
- H36: MX38 +100pp × 2× = +200
- H37: MX40 +83pp × 1× = +83
- H38: MX36 +22pp × 1× = +22
- H39: MX39 +31pp × 1× = +31
- H40: MX26 +10pp × 1× = +10
Total projected: +346 weighted

Projected post-experiment: (5,829 + 346) / 6,800 = 6,175 / 6,800 = **90.8%**

**Gap fill:** MX38 (0%) → H36. MX40 (17%) → H37. MX36 (78%) → H38. MX39 (69%) → H39. MX26 (75%) → H40. MX28 (0%) → structural constraint. MX21/MX24 → unactionable without kanban skill access.

**Dependency scan:** H38 (SKILL.md) and H37+H40 (p4-critic-audit.md) and H39 plan.md portion are independent. H36 + H39 both modify interview.md → overlapping. H37 + H40 both modify p4-critic-audit.md → overlapping. Run order: H38 → H39 (plan.md) → H36 + H39 (interview.md, sequential) → H37 + H40 (p4-critic-audit.md, sequential) → H40 (ideate.md).

---

## Phase 4 — Experiments

### H36 — Research Confidence consumption in interview.md

**Pre-change:** MX38=0%
**Change applied:** Added Research Confidence override rule to Phase 2 confidence rules in interview.md: "Before finalising confidence levels, check the `## Research Confidence` section in `01-research-{subject}.md`. For any recommendation derived primarily from a section rated Low, override its confidence to UNCERTAIN — regardless of other evidence."
**Post-change:** MX38=100% — the producer→consumer link for the Research Confidence signal is now complete.
**Delta:** MX38 +100pp (×2×=+200 weighted)
**Outcome:** Confirmed
**Mechanism:** H28 (run 6) created the Research Confidence section so downstream phases could calibrate confidence. Without a consumption rule in interview.md, the signal had zero effect — Keeper could still assign HIGH confidence to recommendations derived from Low-confidence sections. The override rule closes the producer→consumer gap.

---

### H37 — Fix escape hatch option (b) in p4-critic-audit.md

**Pre-change:** MX40=17% (option b pointed to plan.md directly; re-entry guard would block redrafting; no cleanup or re-run instructions)
**Change applied:** Replaced "Return to plan.md to revise the plan before re-running tickets" with: "Revise the plan — return to `/ideate` and select 'Add more' at Step 6 to re-run the full capture → research → interview → plan → audit cycle; then delete the existing `03-refinement/` ticket files and re-run tickets from Step 7." Also added 3-pass escape hatch WHY comment (H40 overlap).
**Post-change:** MX40=100% — all 6 criteria met: (a) names `/ideate` "Add more" ✓, (b) no direct plan.md invocation ✓, (c) re-entry guard addressed via full cycle ✓, (d) 03-refinement/ cleanup specified ✓, (e) Step 7 re-run specified ✓, (f) options distinguishable ✓.
**Delta:** MX40 +83pp (×1×=+83 weighted)
**Outcome:** Confirmed
**Mechanism:** The original "Return to plan.md" instruction was written as shorthand but failed to account for the re-entry guard. The corrected instruction names the exact mechanism and cleanup steps, making the recovery path unambiguous and executable.

---

### H38 — Fix SKILL.md step reference table

**Pre-change:** MX36=78%
**Change applied:** Step 6: `commands/plan.md` (validation section) → `commands/ideate.md` (Phase 6). Step 9: `commands/tickets.md` (promotion section) → `commands/ideate.md` (Phase 8).
**Post-change:** MX36=100% — all 9 rows in the Nine-Step table reference the correct implementing file.
**Delta:** MX36 +22pp (×1×=+22 weighted)
**Outcome:** Confirmed
**Mechanism:** Both steps had stale references from H21 (run 5) when validation and promotion were moved to ideate.md. The SKILL.md table was not updated at the time.

---

### H39 — Standardise STOP/WARN recovery messages

**Pre-change:** MX39=69%
**Change applied:** interview.md: `/ideation capture` → `/ideate` (Step 1: Capture); `/ideation research` → `/ideate` (Step 2: Research). plan.md: "Run capture (Step 1) first" → "Run `/ideate` (Step 1: Capture) first" (×2).
**Post-change:** MX39=100% — all 13 STOP/WARN recovery messages reference `/ideate` consistently.
**Delta:** MX39 +31pp (×1×=+31 weighted)
**Outcome:** Confirmed
**Mechanism:** `/ideation` was an older command format; `/ideate` is the canonical current form per SKILL.md. plan.md's messages predated the slash command naming convention entirely.

---

### H40 — WHY comments for p4-critic-audit.md and ideate.md

**Pre-change:** MX26=75% (~24/32 annotated)
**Change applied:** Added 5 WHY comments: (1) p4 Reverse Traceability Check — explains ghost-requirements gap that forward-only audit misses (H32/run 7); (2) p4 auto-fix "never ask permission" — explains why permission-asking defeats the quality gate purpose; (3) p4 3-pass escape hatch — explains why 3 passes rather than 1 or infinite (H33/run 7); (4) p4 Audit Block idempotency guard — explains duplicate-audit-block failure mode on crash-resume; (5) ideate.md Phase 7 plan audit precondition — explains why audited plan is required before ticket dispatch.
**Post-change:** MX26≈91% (29/32) — all 5 targeted blocks now annotated.
**Delta:** MX26 +16pp (×1×=+16 weighted)
**Outcome:** Confirmed — better than projected (+16 actual vs. +10 projected; all 5 blocks annotated including the ideate.md precondition)
**Mechanism:** The WHY comments make design intent auditable across run boundaries: the Reverse Traceability Check WHY traces to H32; the escape hatch WHY explains the 3-pass choice; the precondition WHY explains the ordering constraint. Future optimise runs can distinguish intentional design from accumulated defensive coding.

---

## Phase 5 — Report

| Metric | Pre-exp | Post-exp | Δ | How |
|--------|---------|---------|---|-----|
| MX26 WHY-CC | 75 | 91 | +16 | H40: 5 WHY comments in p4-critic-audit.md + ideate.md Phase 7 |
| MX36 SSRA | 78 | 100 | +22 | H38: Steps 6 and 9 in SKILL.md table corrected to ideate.md |
| MX37 ATCR | 100 | 100 | 0 | Baseline ceiling |
| MX38 RCSCR | 0 | 100 | +100 | H36: Research Confidence override rule added to interview.md Phase 2 |
| MX39 FSMC | 69 | 100 | +31 | H39: 4 STOP/WARN messages standardised to `/ideate` format |
| MX40 TAFRC | 17 | 100 | +83 | H37: escape hatch option (b) corrected to ideate.md "Add more" loop |

All others: unchanged.

**Composite score:**

```
Pre-experiment:  5,829 / 6,800 = 85.7%
Improvements:    +200 (H36) + 83 (H37) + 22 (H38) + 31 (H39) + 16 (H40) = +352
Post-experiment: 6,181 / 6,800 = 90.9%
```

**Run improvement: 85.7% → 90.9% (+5.2pp within run 8)**
**Net vs. run 7: 89.8% → 90.9% (+1.1pp after metric dilution from 5 new metrics averaging 52.8% baseline)**

All 5 hypotheses confirmed.

### What improved and why

- **Research Confidence signal finally consumed**: MX38 +100pp (0→100) — highest-impact change this run (×2× weight). H28 (run 6) created the signal; H36 closes the producer→consumer link 2 runs later. interview.md now explicitly overrides recommendation confidence for Low-confidence research sections. NP11.
- **Ticket audit failure recovery now actionable**: MX40 +83pp (17→100) — option (b) in the escape hatch previously pointed to the wrong file. The correction names the `/ideate` "Add more" loop and specifies 03-refinement/ cleanup. H37.
- **p4-critic-audit.md WHY annotation completed**: MX26 +16pp (75→91) — all 5 targeted unannotated blocks now carry rationale comments. Better than projected (+16 vs. +10) because all 5 targets were completed, including the ideate.md Phase 7 precondition. H40.
- **All STOP/WARN messages consistent**: MX39 +31pp (69→100) — 4 messages using old or vague command formats standardised to `/ideate`. H39.
- **SKILL.md step table fully accurate**: MX36 +22pp (78→100) — Steps 6 and 9 were pointing to stale file locations since H21/run 5. H38.

### What remains to improve

- **MX26 WHY-CC**: 91% (29/32) — 3 unannotated blocks remain; further improvement requires enumerating them.
- **MX21 OSCC**: 90% — residual init.md reference unresolvable without kanban skill access.
- **MX24 CFRA**: 89% — same init.md ambiguity.
- **MX28 TSSF**: 0% — structural constraint; requires actual test execution, non-actionable through instruction changes.

### Novel Pattern Candidates

#### NP11 (run 8) — Research Confidence Propagation
**Discovered in:** H36 — ideation skill
**Problem it solved:** H28 (run 6) added a Research Confidence signal to research.md so downstream phases could calibrate confidence. But without a consumption rule in interview.md, the signal was produced but never used — Keeper could still assign HIGH confidence to recommendations derived from Low-confidence research sections.
**Implementation:** After adding a confidence-signalling section to a producer phase, add a corresponding consumption rule in the downstream consumer phase that explicitly checks the signal and propagates it to output quality decisions (Low confidence in research → UNCERTAIN recommendation in interview).
**Metrics it improved:** Research Confidence Signal Consumption Rate (+100pp, ×2× weight)
**Generalises to:** Any multi-phase workflow where one phase produces a quality signal for downstream phases — e.g., a linting phase producing severity ratings that a review phase should check before approving. Completeness of the signal is insufficient; the downstream phase must explicitly consume it.
**Seed candidate:** yes — applies to any workflow with producer-consumer signal chains where signal quality affects downstream output quality.

### Research Log Archival

Log size estimate post-run-8: ~900 lines × ~8 tokens/line ≈ 7,200 tokens. Well within the 15,000-token threshold — no archival needed for run 9.
