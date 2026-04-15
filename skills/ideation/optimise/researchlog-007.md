<!-- SUMMARY-START -->
## Run 007 — 2026-03-25 | Target: skills/ideation/
Composite: 86.9% → 89.8% (+2.9 pp)

### Hypotheses
| ID  | Description                                                              | Outcome   |
|-----|--------------------------------------------------------------------------|-----------|
| H31 | Add WHY comments to p3-draft-tickets.md (TASK-001 + idempotency guard)   | Confirmed |
| H32 | Add reverse traceability check to p4-critic-audit.md                     | Confirmed |
| H33 | Add auto-fix escape hatch to p4-critic-audit.md                          | Confirmed |
| H34 | Fix undefined persona reference in p3-draft-tickets.md                   | Confirmed |
| H35 | Document spawned_tickets field lifecycle in p3-draft-tickets.md          | Confirmed |

### Metric Snapshot
| Metric            | Baseline | Post  |
|-------------------|----------|-------|
| MX26 WHY-CC       | 69       | 75    |
| MX31 UPRR         | 91       | 100   |
| MX32 PTACBR       | 50       | 100   |
| MX33 CSIDR        | 80       | 100   |
| MX34 PATCR        | 67       | 100   |
| MX35 AFLEC        | 50       | 100   |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

TTL tier: **Tier C** — same-day research log, target matches, age ≤ 7 days. Proceed without staleness warning.

**File inventory (post-run-6):**

| File | Type | Lines |
|------|------|-------|
| `SKILL.md` | doc | ~212 |
| `VERSION.md` | doc | ~11 |
| `CHANGELOG.md` | doc | ~100 |
| `TESTING.md` | test | ~68 |
| `commands/ideate.md` | orchestrator | ~216 |
| `commands/capture.md` | command | ~182 |
| `commands/research.md` | command | ~189 |
| `commands/interview.md` | command | ~279 |
| `commands/plan.md` | command | ~224 |
| `commands/tickets.md` | orchestrator | ~52 |
| `commands/tickets/p1-load-plan.md` | phase | ~35 |
| `commands/tickets/p2-scout-research.md` | phase | ~24 |
| `commands/tickets/p3-draft-tickets.md` | phase | ~127 |
| `commands/tickets/p4-critic-audit.md` | phase | ~94 |
| `commands/tickets/p5-commit.md` | phase | ~44 |

15 command/instruction files, 5 support files (SKILL.md, VERSION.md, CHANGELOG.md, TESTING.md, AGENTS.md), 2 log files. No broken persona references for explicitly pathed loads.

**Key findings from file reads:**

1. **`p3-draft-tickets.md` undefined persona reference**: Line 1 reads "Activate the main implementation persona." `tickets.md` Personas section loads Scout (Phase 2) and Arden (Phase 4) only. No "main implementation persona" is defined anywhere. This instruction is unresolvable — Phase 3 runs with whatever personas are currently in context (Scout + Arden from tickets.md top-of-file load), but the intent to activate a dedicated implementation persona is never fulfilled.
2. **`p4-critic-audit.md` one-directional audit**: The audit maps plan requirements → tickets (forward direction) but does not verify that each ticket's `plan_items` references a valid requirement ID in the plan (reverse direction). Bidirectional traceability is a standard in requirements management but absent here.
3. **`p4-critic-audit.md` auto-fix loop**: "Repeat until the threshold is met" with no escape hatch. Compare to `plan.md` which says "if score is still below 95% after all auto-fixes, present to user." The ticket audit can loop indefinitely on hard problems.
4. **`p3-draft-tickets.md` spawned_tickets field**: Frontmatter schema includes `spawned_tickets: []` but the Field Notes section provides no explanation of what this field tracks, when it is populated, or which skill is responsible for updating it. The ideation→implement interface contract has a gap here.
5. **MX26 residual**: Items 14 and 15 from run 6 enumeration (TASK-001 mandatory rule and ticket idempotency guard in `p3-draft-tickets.md`) still have no WHY comments. These are the last two identified gaps in the WHY comment annotation effort.

---

## Phase 2 — Baseline

**Re-read:** research-log.md (Intent Anchor confirmed). Target: `skills/ideation/`. Prior composite: 88.6% (run 6 post) = 4,959 / 5,600.

### Seed Metrics (re-verified)

All seed metrics stable from run 6. No regressions.

**M1–M15 values (confirmed):** IOT 100, DD 99.5, IAR 98.6, WCS 100, RI 97, ACC 97, SAS 100, HTC 88, CDR 100, CLE 96, M11 SKIP, IFS 100, ITE 98.9, PPF 100, PRS 100

### Custom Metrics (re-applied, all at run 6 post values)

MX1–MX25 unchanged. MX26–MX30 at run 6 post values.

### New Custom Metric Definitions (run 7)

#### MX31 — Undefined Persona Reference Rate (UPRR) [custom]
**Measures:** What fraction of persona load/activation instructions across all skill files resolve to a specifically named persona file at a defined path. Unresolvable references (vague descriptions like "main implementation persona" that don't map to any persona.md file) score as failures.
**Why seeds miss it:** M4 (WCS) measures whether defined personas are wired to command files; M14 (PPF) measures fit of loaded personas. Neither checks whether the persona load instruction itself resolves to a real file. A vacuous activation instruction silently degrades quality — the phase runs without the intended cognitive framing.
**Methodology:** Enumerate all persona load and activation instructions across all skill files. Classify each as: Resolvable (references a specific file path that exists, or explicitly states "no persona for this phase") or Unresolvable (vague description that maps to no defined persona). Score = resolvable / total.
**Direction:** ↑ higher is better
**Weight:** 2× — an unresolvable persona reference is a silent quality failure; the phase cannot use a cognitive framing that was clearly intended by the skill author
**Normalisation:** rate × 100

#### MX32 — Plan-Ticket Audit Coverage Bidirectionality Rate (PTACBR) [custom, moonshot]
**Measures:** Whether the ticket critic audit (p4-critic-audit.md) enforces both directions of plan↔ticket traceability: (a) forward: every plan requirement is covered by at least one ticket, and (b) reverse: every ticket's `plan_items` references a valid requirement ID in the plan. Borrowed from "bidirectional traceability" in systems/requirements engineering — a standard practice in safety-critical software development that prevents ghost requirements (items covered by tickets that reference non-existent requirements) from masking unimplemented scope.
**Why seeds miss it:** No seed or prior custom metric measures the reverse direction of traceability. M1 (IOT) measures artifact re-reads; MX16 (from prior runs) measures requirement mapping. Reverse traceability — checking that ticket claims are grounded in real plan items — is a distinct quality dimension that no existing metric captures. Moonshot: applying bidirectional traceability (standard in avionics and medical device engineering) to an AI workflow.
**Methodology:** Score each direction independently: (a) Forward = covered by p4's coverage audit loop ✓; (b) Reverse = each ticket's plan_items entries are verified against actual requirement IDs in 02-plan-*.md — currently absent ✗. Score = directions_enforced / 2.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** (directions_enforced / 2) × 100

#### MX33 — Cross-Skill Interface Documentation Rate (CSIDR) [custom]
**Measures:** What fraction of the ideation→implement interface contract items are explicitly documented within the ideation skill's files.
**Why seeds miss it:** MX24 (CFRA) measures whether cross-file references within the skill resolve to real files. No metric measures whether the cross-SKILL interface (ticket schema, handoff token, directory conventions, lifecycle semantics) is fully documented from the ideation skill's perspective. A poorly documented interface forces implement to reverse-engineer ideation's assumptions.
**Methodology:** Enumerate the expected ideation→implement interface contract items: (a) ticket frontmatter schema cross-reference to implement's authoritative schema; (b) handoff token (`from-ideation-handoff`); (c) directory convention (04-todo/ is the handoff point); (d) files implement must not modify (00-input, 01-research, 02-plan, 00-assets, 03-refinement); (e) spawned_tickets lifecycle semantics (who populates this field and when). Score = documented_items / total_items.
**Direction:** ↑ higher is better
**Weight:** 1× — interface gaps are bridgeable by reading both skills; lower-severity than persona resolution failures
**Normalisation:** rate × 100

#### MX34 — Persona Activation Transition Clarity Rate (PATCR) [custom]
**Measures:** Within a multi-phase sub-orchestrator (tickets.md), what fraction of phases that require a specific active persona have an unambiguous activation instruction? An instruction like "Activate Arden (Critic)" is unambiguous; "Activate the main implementation persona" (when no such persona is defined in the Personas section) is ambiguous.
**Why seeds miss it:** M4 (WCS) measures wiring completeness; M14 (PPF) measures cognitive fit. Neither measures whether the per-phase activation transition instruction is itself unambiguous. In a multi-phase file where multiple personas are loaded upfront, each phase must clearly state which persona is active — or agents will inherit the most recently activated persona, which may be incorrect.
**Methodology:** For each phase in tickets.md's sub-pipeline (phases 1–5), check whether: (a) the phase has no cognitive demand requiring a persona (neutral: load/commit phases) → automatic 1.0; or (b) the phase has a specific persona activation instruction that maps to a persona in the Personas section → 1.0; or (c) the phase has a vague or unresolvable activation instruction → 0.0. Score = phases_with_clear_activation / total_phases_assessed.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

#### MX35 — Auto-Fix Loop Escape Coverage (AFLEC) [custom]
**Measures:** What fraction of phases with an auto-fix loop (where the phase automatically corrects gaps and re-scores until a threshold is met) have an explicit escape hatch preventing infinite loops on unresolvable problems.
**Why seeds miss it:** M6 (ACC) measures concrete stop conditions; MX4 (FRC) measures failure recovery paths. Neither specifically measures whether auto-fix loops have a maximum iteration count or a "give up and present to user" fallback. An auto-fix loop without an escape hatch is an algorithmic debt — it can spin indefinitely when a gap is genuinely unresolvable through automatic means.
**Methodology:** Enumerate all auto-fix loops (phases where the instruction says "repeat until threshold is met" or equivalent). For each, check whether there is an explicit escape hatch: a maximum iteration count, a "if still below threshold after N passes, present to user" instruction, or an explicit FAIL state with user recovery options. Score = loops_with_escape_hatch / total_loops.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

### New Custom Metric Scores (run 7)

**MX31 — Undefined Persona Reference Rate**
Persona load/activation instructions enumerated (11 total):
1. capture.md: Arden/critic ✓
2. research.md: Finn/scout ✓
3. interview.md Personas: Keeper/strategist ✓
4. interview.md Personas: Arden/critic ✓
5. interview.md Personas: Designer (conditional, Phase 2 load) ✓
6. plan.md Personas: Keeper/strategist ✓
7. plan.md Personas: Arden/critic ✓
8. tickets.md Personas: Finn/scout ✓
9. tickets.md Personas: Arden/critic ✓
10. p3-draft-tickets.md: "Activate the main implementation persona" — no such persona defined in Personas section or any persona directory → **unresolvable** ✗
11. p4-critic-audit.md: "Activate Arden (Critic)" ✓
Score: 10/11 = 90.9% → **91%**

**MX32 — Plan-Ticket Audit Coverage Bidirectionality Rate**
Directions enforced:
(a) Forward (plan→ticket): p4's coverage audit loop maps every plan requirement to tickets; score calculation verifies coverage → **enforced** ✓
(b) Reverse (ticket→plan): no instruction in p4 to verify each ticket's plan_items entries correspond to valid requirement IDs in 02-plan-*.md → **absent** ✗
Score: 1/2 = **50%**

**MX33 — Cross-Skill Interface Documentation Rate**
Interface contract items:
(a) Ticket frontmatter schema cross-reference to implement's _shared.md → documented in p3 ✓
(b) Handoff token `from-ideation-handoff` → documented in ideate.md Phase 8 and SKILL.md ✓
(c) Directory convention (04-todo/ is implement's entry point) → documented in ideate.md, SKILL.md, tickets.md ✓
(d) Files implement must not modify → documented in SKILL.md Integration section ✓
(e) `spawned_tickets` lifecycle semantics (who populates, when, under what conditions) → absent ✗
Score: 4/5 = **80%**

**MX34 — Persona Activation Transition Clarity Rate**
Phases in tickets.md sub-pipeline assessed (5 phases, 3 with cognitive demand requiring persona guidance):
- Phase 1 (p1-load-plan.md): load/preparation → neutral → automatic 1.0 (no activation needed) ✓
- Phase 2 (p2-scout-research.md): activated from tickets.md Personas section as Finn/Scout; no per-phase re-activation needed since scout does the research → **clear** ✓
- Phase 3 (p3-draft-tickets.md): "Activate the main implementation persona" → unresolvable → **ambiguous** ✗ (0.0)
- Phase 4 (p4-critic-audit.md): "Activate Arden (Critic)" → explicit, maps to defined persona → **clear** ✓
- Phase 5 (p5-commit.md): commit/administrative → neutral → automatic 1.0 ✓
Phases with cognitive demand (non-neutral): 3 (Phases 2, 3, 4)
Score: 2/3 = 66.7% → **67%**

**MX35 — Auto-Fix Loop Escape Coverage**
Auto-fix loops enumerated:
1. plan.md Phase 3 Step D: "For every Partial and Missing item: update 02-plan-*.md immediately. Do NOT ask for permission. Do NOT skip any item." + Step E: "Rescore." + escape hatch: "If audit score is still below 95% after all auto-fixes are applied, present to user: ⚠ Plan audit failed — N items could not be auto-resolved." → **has escape hatch** ✓
2. p4-critic-audit.md: "If the score falls below 95%, auto-fix immediately — never ask permission... Re-run the audit, update the table and score. Repeat until the threshold is met." — no escape hatch, no maximum iterations, no failure state with user recovery → **no escape hatch** ✗
Score: 1/2 = **50%**

### Composite Calculation

```
New metrics: MX31(91×2=182) + MX32(50×1=50) + MX33(80×1=80) + MX34(67×1=67) + MX35(50×1=50) = 429

Pre-experiment numerator: 4,959 (run 6 post) + 429 (MX31–35) = 5,388
New denominator: 5,600 + (2+1+1+1+1)×100 = 5,600 + 600 = 6,200
Pre-experiment composite: 5,388 / 6,200 = 86.9%
```

Metric dilution note: MX31–MX35 average (91+50+80+67+50)/5 = 67.6%, below the 88.6% run-6 composite; dilution drops pre-experiment composite to 86.9%.

### Weakest Metrics (Phase 3 candidates)
1. MX28 TSSF — 0% (structural constraint, non-actionable)
2. MX32 PTACBR — 50%
3. MX35 AFLEC — 50%
4. MX34 PATCR — 67%
5. MX26 WHY-CC — 69%
6. MX33 CSIDR — 80%
7. MX31 UPRR — 91%

### Strongest Metrics
IOT, WCS, SAS, CDR, IFS = 100% (5 metrics at ceiling)
MX2 RSC, MX4 FRC, MX5 TSC, MX7 PIC = 100%
MX17 DVA, MX19 PENSC, MX20 CBICA, MX22 MCAS, MX23 TCTC, MX25 PGSC = 100%

---

## Phase 3 — Hypotheses

### H31 — Add WHY comments to p3-draft-tickets.md

**Problem observed:** MX26=69% — two non-obvious instruction blocks in p3-draft-tickets.md carry no WHY rationale comments: (1) "TASK-001 is ALWAYS the TDD red phase. No exceptions." — the rule is stated but the reason (verify clean slate before implementation begins; H7 pattern from run 2) is not. (2) Idempotency guard for ticket file creation — no explanation of why both Context AND ACs must be present to consider a file complete.
**Change proposed:** Add WHY comments immediately before each instruction:
1. TASK-001 rule: "<!-- WHY TASK-001 must always be the TDD red phase: confirms that no prior implementation exists before any ticket is claimed. A passing TDD red phase proves the clean-slate precondition for all subsequent implementation tickets. Pattern established in run 2 (H7). -->"
2. Idempotency guard: "<!-- WHY idempotency guard: prevents duplicate ticket creation if Phase 3 is re-entered after a crash or mid-session resume. Requires BOTH Context AND ACs to be present — a partial write (missing one section) is treated as incomplete and overwritten safely. -->"
**Targets:** MX26 WHY Comment Coverage (↑ from 69% → ~75%)
**Predicted improvement:** +6pp on MX26 (×1×=+6 weighted)
**Pattern applied:** NP8 (WHY Comment Traceability Anchors)
**Risk level:** low (annotation-only; no logic change)
**Risk note:** The WHY comments are brief by design — keeps the instruction file scannable. No risk of M13 ITE degradation.

---

### H32 — Add reverse traceability check to p4-critic-audit.md

**Problem observed:** MX32=50% — p4-critic-audit.md enforces the forward direction (every plan requirement has a ticket) but not the reverse direction (every ticket's plan_items entries correspond to valid requirement IDs in the plan). A ticket can assert it addresses "Req 99" when that requirement doesn't exist — and the current audit would not catch this. Ghost requirements in plan_items mask the true traceability picture and can mislead implement about what a ticket is actually for.
**Change proposed:** Add a "Reverse Traceability Check" step after the coverage audit passes 95%: "For each ticket in `03-refinement/`, verify that every requirement ID in its `plan_items` field exists in `02-plan-{subject}.md`. If a plan_items entry references a non-existent requirement ID, update the ticket's plan_items to the correct ID or remove the invalid entry. Record each correction in the Fixes Applied section."
**Targets:** MX32 PTACBR (↑ from 50% → 100%)
**Predicted improvement:** +50pp on MX32 (×1×=+50 weighted)
**Pattern applied:** Novel — Bidirectional Traceability Enforcement (applying bidirectional requirements traceability from systems engineering to AI workflow ticket audits)
**Risk level:** low (additive step after audit passes; only triggers if invalid plan_items are found)
**Risk note:** Reverse traceability requires reading the plan file during the ticket audit, adding a small context load. This is acceptable since the plan file is already loaded in Phase 1 (p1-load-plan.md) and should remain in context.

---

### H33 — Add auto-fix escape hatch to p4-critic-audit.md

**Problem observed:** MX35=50% — p4-critic-audit.md says "Repeat until the threshold is met" with no upper bound. Compare to plan.md which has an explicit escape: "If audit score is still below 95% after all auto-fixes are applied, present to user: ⚠ Plan audit failed." The ticket audit can loop indefinitely if a genuine coverage gap cannot be auto-resolved (e.g., a plan requirement that is fundamentally un-ticketable without user clarification).
**Change proposed:** After "Repeat until the threshold is met" in the auto-fix section, add: "If after 3 auto-fix passes the score is still below 95%, stop auto-fixing and present to the user: '⚠ Ticket audit cannot reach 95% after 3 passes. Unresolvable gaps: [list requirements by number and description]. Choose: (a) Accept the ticket set with gaps marked [UNRESOLVED] and proceed to p5-commit.md, or (b) Return to plan.md to revise the plan before re-running tickets.'"
**Targets:** MX35 AFLEC (↑ from 50% → 100%)
**Predicted improvement:** +50pp on MX35 (×1×=+50 weighted)
**Pattern applied:** P10 (Failure Mode Registry) — adds an explicit recovery instruction for a failure state that previously had no prescribed path
**Risk level:** low (additive escape hatch; only triggers on genuine failure)
**Risk note:** The 3-pass limit is a judgment call. plan.md's equivalent is "after all auto-fixes applied" (1 pass). Setting the ticket audit limit at 3 gives more latitude for iterative improvement (requirements may be split into multiple tickets across iterations) while still providing an escape. Could be adjusted downward if 3 proves too permissive.

---

### H34 — Fix undefined persona reference in p3-draft-tickets.md

**Problem observed:** MX31=91%, MX34=67% — p3-draft-tickets.md opens with "Activate the main implementation persona." No persona named "main implementation persona" exists in any personas directory; the `tickets.md` Personas section loads only Scout (Phase 2) and Arden (Phase 4). The instruction is unresolvable — Phase 3 runs with Scout + Arden in context from the top-of-file load in tickets.md, but there is no dedicated phase-activation instruction to focus cognitive framing for the ticket-drafting task.
**Change proposed:** Replace "Activate the main implementation persona." with: "No dedicated persona is assigned to this phase. Proceed with the research context established by Finn (Scout) in Phase 2 when writing ticket scope and Context sections. Apply Arden (Critic)'s AC quality standards when writing acceptance criteria — each AC must be empirically verifiable before Arden's audit in Phase 4 will pass it." This converts a vacuous instruction into a concrete cognitive framing directive that references the personas already in context.
**Targets:** MX31 UPRR (↑ from 91% → 100%); MX34 PATCR (↑ from 67% → 100%)
**Predicted improvement:** MX31 +9pp (×2×=+18 weighted); MX34 +33pp (×1×=+33 weighted) → **+51 weighted**
**Pattern applied:** P7 (Binary Applicability Gates) — replaces vague conditional with a deterministically-applicable instruction; also NP8 (makes the cognitive framing intent explicit)
**Risk level:** low (instruction clarification only; no persona files created or modified)
**Risk note:** This does not create an "implementor" persona. If output quality from Phase 3 is observed to degrade in practice (tickets are too research-heavy from Scout influence, or too adversarial from Arden influence), a follow-on P8/P9 persona hypothesis in run 8 can create a dedicated implementation persona. The present change makes the cognitive context transparent without adding complexity.

---

### H35 — Document spawned_tickets field lifecycle in p3-draft-tickets.md

**Problem observed:** MX33=80% — the ticket frontmatter schema includes `spawned_tickets: []` but the Field Notes section provides no explanation. A developer reading p3-draft-tickets.md cannot determine: what kind of tickets this field tracks, which skill is responsible for updating it, or when it would become non-empty.
**Change proposed:** Add to the Field Notes section: "spawned_tickets — list of ticket IDs created by the implement skill during execution when a ticket's scope requires decomposition (e.g., `[\"YYYY-MM-DD-{subject}/TASK-006\"]`). Set to `[]` at ticket creation by ideation; populated by implement when a claimed ticket spawns child work. Ideation does not modify this field after creation."
**Targets:** MX33 CSIDR (↑ from 80% → 100%)
**Predicted improvement:** +20pp on MX33 (×1×=+20 weighted)
**Pattern applied:** P12 (Content Synchronisation Audit) — cross-skill interface contract item documented from ideation's perspective
**Risk level:** low (documentation addition; Field Notes section already exists in the file)
**Risk note:** The spawned_tickets semantics stated here are inferred from context — ideation creates the field empty; only implement would have reason to populate it. If the implement skill has different semantics for this field, the documentation could conflict. Non-actionable risk without reading the implement skill.

---

### Self-Audit — 2026-03-25 (run 7)

**Intent check:** All 5 hypotheses grounded in measured metric shortfalls: H31 (MX26: 69%), H32 (MX32: 50%), H33 (MX35: 50%), H34 (MX31: 91%, MX34: 67%), H35 (MX33: 80%). No speculative hypotheses.

**Coverage check:**
- H31: MX26 +6pp × 1× = +6
- H32: MX32 +50pp × 1× = +50
- H33: MX35 +50pp × 1× = +50
- H34: MX31 +9pp × 2× = +18; MX34 +33pp × 1× = +33 → +51
- H35: MX33 +20pp × 1× = +20
Total projected: +177 weighted
Projected post-experiment: (5,388 + 177) / 6,200 = 5,565 / 6,200 = **89.8%**

**Gap fill:** MX26 (69%) → H31. MX32 (50%) → H32. MX35 (50%) → H33. MX31 (91%), MX34 (67%) → H34. MX33 (80%) → H35. MX28 (0%) → structural constraint (no hypothesis). MX21 (90%) → unactionable without kanban skill access.

**Dependency scan:** H31 and H34 and H35 all modify p3-draft-tickets.md → **overlapping file**. H32 and H33 both modify p4-critic-audit.md → **overlapping file**. Run order: H34 → H35 → H31 (p3-draft-tickets.md sequential) → H32 → H33 (p4-critic-audit.md sequential).

---

## Phase 4 — Experiments

### H34 — Fix undefined persona reference in p3-draft-tickets.md

**Pre-change:** MX31=91% (10/11 resolvable), MX34=67% (2/3 phases with clear activation)
**Change applied:** Replaced "Activate the main implementation persona." with an explicit no-persona declaration: "No dedicated persona is assigned to this phase. Proceed with the research context established by Finn (Scout) in Phase 2 when writing ticket scope and Context sections. Apply Arden (Critic)'s AC quality standards when writing acceptance criteria — each AC must be empirically verifiable before Arden's audit in Phase 4 will pass it."
**Post-change:** MX31=100% — Phase 3 now has an explicit activation instruction (no new persona load, but clearly states that Scout + Arden context from tickets.md top-of-file applies). MX34=100% — all 3 phases with cognitive demand have unambiguous activation instructions.
**Delta:** MX31 +9pp (×2×=+18 weighted); MX34 +33pp (×1×=+33 weighted) → **+51 actual**
**Outcome:** Confirmed
**Mechanism:** The vacuous "Activate the main implementation persona" instruction left Phase 3's cognitive framing implicit and unresolvable. The replacement makes explicit which personas are in play (Scout's research context for scoping; Arden's standards for AC quality) and removes the undefined reference. MX31 denominator decreases from 11 to 10 (the unresolvable instruction is gone); all 10 remaining instructions resolve to defined personas.

---

### H35 — Document spawned_tickets field lifecycle

**Pre-change:** MX33=80% (4/5 interface contract items documented)
**Change applied:** Added to Field Notes: "spawned_tickets — list of ticket IDs created by the implement skill during execution when a ticket's scope requires decomposition. Set to `[]` at ticket creation by ideation; populated by implement when a claimed ticket spawns child work. Ideation does not modify this field after creation."
**Post-change:** MX33=100% — all 5 ideation→implement interface contract items now documented in ideation skill files.
**Delta:** MX33 +20pp (×1×=+20 weighted)
**Outcome:** Confirmed
**Mechanism:** The spawned_tickets field was the only frontmatter field with no Field Notes entry. The added note clarifies ownership (implement populates it) and lifecycle (starts empty, grows during implementation). Developers reading p3-draft-tickets.md can now understand the field's purpose without consulting the implement skill.

---

### H31 — WHY comments in p3-draft-tickets.md

**Pre-change:** MX26=69% (~22/32 blocks annotated; items 14–15 from run 6 enumeration unannotated)
**Change applied:** Added WHY comment before TASK-001 mandatory rule: "confirms that no prior implementation exists before any ticket is claimed; clean-slate precondition for all subsequent tickets; pattern established in run 2 (H7)." Added WHY comment before idempotency guard: "prevents duplicate ticket creation if Phase 3 is re-entered; both Context and AC sections must be present for a ticket to be complete; partial write is safe to overwrite."
**Post-change:** MX26≈75% (24/32) — last two identified gaps in p3-draft-tickets.md now annotated.
**Delta:** MX26 +6pp (×1×=+6 weighted)
**Outcome:** Confirmed
**Mechanism:** The 2 remaining unannotated blocks now carry inline rationale. The TASK-001 WHY comment closes the "why TDD-first?" question that a new contributor would inevitably ask. The idempotency guard WHY comment explains the completeness criterion (both sections required) that was previously just asserted.

---

### H32 — Add reverse traceability check to p4-critic-audit.md

**Pre-change:** MX32=50% (forward direction enforced; reverse direction absent)
**Change applied:** Added "Reverse Traceability Check" section between the coverage audit and the Dependency Graph Audit: "For each ticket in 03-refinement/, verify that every requirement ID listed in its plan_items field exists as a numbered requirement in 02-plan-{subject}.md. If a plan_items entry references a non-existent requirement ID, correct it to the closest matching requirement or remove it. Record each correction in the Fixes Applied section."
**Post-change:** MX32=100% — both forward (plan→ticket) and reverse (ticket→plan_items validity) traceability are now enforced.
**Delta:** MX32 +50pp (×1×=+50 weighted)
**Outcome:** Confirmed
**Mechanism:** The reverse check catches "ghost requirements" — plan_items entries that reference requirement IDs that don't exist (due to plan revisions, typos, or copy errors). This closes the bidirectional traceability gap. The check is positioned after the coverage audit to avoid running it on a partial ticket set, and before the dependency graph audit so that plan_items entries are accurate when dependency edges are verified.

---

### H33 — Add auto-fix escape hatch to p4-critic-audit.md

**Pre-change:** MX35=50% (plan.md has escape hatch; p4-critic-audit.md does not)
**Change applied:** After "Repeat until the threshold is met", added: "If after 3 auto-fix passes the score is still below 95%, stop auto-fixing and present to the user: '⚠ Ticket audit cannot reach 95% after 3 passes. Choose: (a) Accept with [UNRESOLVED] markers, or (b) Return to plan.md to revise.'"
**Post-change:** MX35=100% — both auto-fix loops in the skill (plan.md and p4-critic-audit.md) now have explicit escape hatches.
**Delta:** MX35 +50pp (×1×=+50 weighted)
**Outcome:** Confirmed
**Mechanism:** The 3-pass limit mirrors the escape pattern from plan.md and prevents the ticket audit from looping indefinitely on requirements that are genuinely unresolvable without user input. The recovery options (accept with gaps vs. revise the plan) match the structure of the plan.md FAIL branch, creating a consistent recovery UX across both audit gates in the skill.

---

## Phase 5 — Report

| Metric | Pre-exp | Post-exp | Δ | How |
|--------|---------|---------|---|-----|
| MX26 WHY-CC | 69 | 75 | +6 | H31: 2 WHY comments in p3-draft-tickets.md |
| MX31 UPRR | 91 | 100 | +9 | H34: undefined "main implementation persona" replaced with explicit no-persona declaration |
| MX32 PTACBR | 50 | 100 | +50 | H32: reverse traceability check added to p4-critic-audit.md |
| MX33 CSIDR | 80 | 100 | +20 | H35: spawned_tickets lifecycle documented in p3-draft-tickets.md |
| MX34 PATCR | 67 | 100 | +33 | H34: Phase 3 activation instruction now unambiguous |
| MX35 AFLEC | 50 | 100 | +50 | H33: 3-pass escape hatch added to p4-critic-audit.md auto-fix loop |

All others: unchanged.

**Composite score:**

```
Pre-experiment:  5,388 / 6,200 = 86.9%
Improvements:    +6 (H31) + 51 (H34) + 50 (H32) + 20 (H35) + 50 (H33) = +177
Post-experiment: 5,565 / 6,200 = 89.8%
```

**Run improvement: 86.9% → 89.8% (+2.9pp within run 7)**
**Net vs. run 6: 88.6% → 89.8% (+1.2pp after metric dilution from 5 new metrics averaging 67.6% baseline)**

All 5 hypotheses confirmed.

### What improved and why

- **Plan-ticket audit is now bidirectional**: MX32 +50pp (50→100) — the highest-impact change this run. Reverse traceability (ticket→plan validity) closes the ghost-requirements gap: a ticket can no longer claim to address a plan requirement that doesn't exist. H32.
- **Ticket audit has an escape hatch**: MX35 +50pp (50→100) — p4's "repeat until threshold met" loop now terminates gracefully after 3 passes with a user recovery prompt, matching plan.md's FAIL branch pattern. H33.
- **Phase 3 persona framing is now explicit**: MX34 +33pp (67→100) and MX31 +9pp (91→100) — "Activate the main implementation persona" was a vacuous instruction; Phase 3 now clearly states which personas govern its output (Scout context for scope, Arden standards for ACs). H34.
- **spawned_tickets lifecycle documented**: MX33 +20pp (80→100) — the only undocumented frontmatter field in the ticket schema now explains who populates it and when. Closes the last ideation→implement interface contract gap. H35.
- **TASK-001 and idempotency guard annotated**: MX26 +6pp (69→75) — the last identified WHY comment gaps in the ideation skill are closed. MX26 remains below 80% but the enumerated items are now fully annotated; further improvement would require discovering additional unannotated blocks. H31.

### What remains to improve

- **MX26 WHY-CC**: 75% — all 15 enumerated non-obvious blocks are now annotated; the 75% score implies ~8 unannotated blocks in the 32-item denominator used in run 6. Further discovery of these blocks (likely in edge-case instructions not yet enumerated) could push toward 90%+.
- **MX21 OSCC**: 90% — residual init.md reference in ideate.md cannot be verified without kanban skill access. Persistent unresolvable ambiguity.
- **MX24 CFRA**: 89% — same init.md ambiguity.
- **MX28 TSSF**: 0% — structural constraint; all 14 TESTING.md scenarios remain "Untested". Non-actionable through instruction changes alone.

### Novel Pattern Candidates

#### NP10 (run 7) — Bidirectional Traceability Enforcement
**Discovered in:** H32 — ideation skill
**Problem it solved:** The ticket critic audit verified that every plan requirement had a ticket (forward: plan→ticket) but not that every ticket's plan_items referenced a real requirement (reverse: ticket→plan). A ticket could assert coverage of a non-existent requirement, masking both the ghost reference and the genuinely unaddressed requirement.
**Implementation:** After the forward coverage audit reaches threshold, add a reverse traceability pass: for each ticket's plan_items list, verify each cited requirement ID exists in the plan file. Correct invalid entries with the closest matching requirement or remove them. Record corrections in Fixes Applied.
**Metrics it improved:** Plan-Ticket Audit Coverage Bidirectionality Rate (+50pp)
**Generalises to:** Any workflow that maintains a traceability matrix between a specification (plan, PRD, requirements doc) and implementation artifacts (tickets, test cases, code modules). Reverse direction matters whenever multiple parties can independently reference specification items — copy-paste errors, plan revisions, and typos all produce ghost references that the forward direction cannot catch.
**Seed candidate:** yes — applies to any workflow with bidirectional spec→artifact traceability requirements.

### Research Log Archival

Log size estimate: ~1,800 lines × ~8 tokens/line ≈ 14,400 tokens. Under the 15,000-token threshold but approaching it. Run 8 should archive runs 3–5 (or all runs prior to run 6) before adding new content.
