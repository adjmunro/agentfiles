# Skill Optimisation Research Log

## Archive: see research-log-archive-2026-03-22.md for runs prior to run 4
## Archive: see research-log-archive-2026-03-27.md for runs 4–5

---

## Audit — 2026-03-27 (run 6)

**Target:** skills/personas
**Files:** 20 persona pairs (40 persona files — Sage + Poise added in run 5), 2 command files, 5 support files, 1 research log
**Token estimate:** ~24,000 tokens

### Research Log TTL Check

Research log written 2026-03-26 (run 5); today is 2026-03-27 — 1 day old. Target matches (skills/personas). **Tier C — use as-is.** No regeneration needed.

### Feature Inventory

- Multi-phase pipeline: no
- Persona system: yes (20 persona pairs — 2 new since run 5: Sage/pedagogical, Poise/negotiation)
- Subagent invocations: no
- Multi-session orchestration: no
- Parallel execution: no
- Cached artifacts: no

### Files

**Command files:** summon.md (~750t), evolve.md (~2,550t)

**Persona files (20 pairs):** analytics, strategist, critic, builder, designer, examiner, advocate, scout, scribe, release, documentation, adversarial, synthesis, temporal, interrogator, debugger, architect, verifier, pedagogical, negotiation — all persona.md + soul.md present, all mandatory fields confirmed.

**Support files:** SKILL.md (~620t), AGENTS.md (~525t), VERSION.md (~25t), CHANGELOG.md (~480t), TESTING.md (~700t)

### Persona Staleness Check

- All 20 persona directories exist; both files present in each.
- Sage and Poise (added run 5) — created 2026-03-26, 1 day old. PVD impact: +2 low-version personas.
- No personas deleted or renamed since run 5.

### Issues Discovered During Audit

**Issue 1 — SQS regression (99→ from 100):** Sage (pedagogical/soul.md) Opinion 1: "Simple is the hardest register to produce" — scores mixed on Non-obviousness (known in design circles). Poise (negotiation/soul.md) Opinion 1: "Consensus is overrated" — scores mixed on Non-obviousness (widely accepted management sentiment). Both new personas hold SQS=9/10, pulling library mean below 100.

**Issue 2 — PPCC degradation (89):** Four of the 18 WTS complement-pair references added in run 5 (H15) describe the cited persona's failure mode imprecisely:
- `critic/persona.md`: "Vale (which defends but may **minimise genuine problems**)" — Vale's FM is about misdirected rebuttals, not minimisation (0.5 PPCC)
- `critic/persona.md`: "when **Echo has stayed close to acceptance criteria and missed emergent scope**" — Echo's FM is about over-documentation on simple tickets (0.5 PPCC)
- `strategist/persona.md`: "when **Helm has over-standardised a straightforward change**" — Helm's FM is about checklist rigidity blocking legitimate urgent shipping (0.5 PPCC)
- `strategist/persona.md`: "when **Kira has delivered to a spec that a reframe would have improved**" — Kira's FM describes context-obsolescence, not reframe opportunity (0.5 PPCC)

**Issue 3 — NPQP degradation (50):** Both run-5 new personas score SQS=9/10, below the library median of 10/10. New-persona quality parity score is 50 (2/4 scoring criteria met).

---

## Baseline — 2026-03-27 (run 6)

**Opening composite:** 95.0% (54× weight, 5,128/5,400)

Note: composite opened lower than run 5 final (95.9%) because 4 new metrics were added this run — NPQP=50 and PPCC=89 revealed previously unmeasured gaps; SQS opened at 99 (regression from run 5's 100 due to Sage/Poise additions).

### Metric Table

```
| Metric | Score | Weight | Weighted Score | Notes |
|--------|-------|--------|----------------|-------|
| IOT    | 65    | 1×     | 65             | Structural ceiling ~75; no new intra-run re-reads possible |
| DD     | 100   | 1×     | 100            | All 20 persona pairs present, both commands documented |
| IAR    | 100   | 1×     | 100            | All run 5 hypotheses confirmed; no regressions |
| WCS    | 100   | 1×     | 100            | All 20 personas in summon.md and evolve.md rosters |
| RI     | 95    | 1×     | 95             | Stable |
| ACC    | 94    | 1×     | 94             | Stable |
| HTC    | 95    | 1×     | 95             | Stable |
| CLE    | 95    | 1×     | 95             | Stable |
| ITE    | 95    | 1×     | 95             | Stable |
| PPF    | 100   | 1×     | 100            | All 3 personas active in evolve.md modes |
| PRS    | 100   | 1×     | 100            | All 20 persona pairs score 14/14 |
| MIC    | 100   | 1×     | 100            | Run 1 custom — stable |
| FPC    | 100   | 1×     | 100            | Run 1 custom — stable |
| CFRV   | 100   | 1×     | 100            | Run 1 custom — stable |
| PSA    | 100   | 1×     | 100            | Run 1 custom — stable |
| ECR    | 100   | 1×     | 100            | Run 1 custom — stable |
| PCC    | 100   | 2×     | 200            | Run 2 custom — all 20 cognitive modes covered |
| SQS    | 99    | 2×     | 198            | Run 2 custom — Sage+Poise Opinion Non-obviousness = mixed (9/10 each) |
| UTCU   | 95    | 1×     | 95             | Run 3 custom — stable |
| SRCA   | 92    | 1×     | 92             | Run 3 custom — stable |
| DMSC   | 100   | 1×     | 100            | Run 3 custom — stable |
| PHSC   | 100   | 1×     | 100            | Run 3 custom — stable |
| CDA    | 100   | 1×     | 100            | Run 4 custom — stable |
| TLBC   | 100   | 1×     | 100            | Run 4 custom — stable |
| PVC    | 95    | 1×     | 95             | Run 4 custom — stable |
| PEBS   | 100   | 1×     | 100            | Run 4 custom — stable |
| FMCS   | 86    | 1×     | 86             | Run 4 custom — stable; needs re-measurement at 20 personas |
| TSCR   | 25    | 1×     | 25             | Run 5 custom — 6 command scenarios remain untested |
| EMPAC  | 95    | 1×     | 95             | Run 5 custom — stable |
| PVD    | 61    | 1×     | 61             | Run 5 custom — 9 young personas (≤5 days old) |
| AGD    | 100   | 1×     | 100            | Run 5 custom — all 20 taxonomy slots filled |
| PCDS   | 100   | 2×     | 200            | Run 5 custom — all 18 complement pairs documented in WTS |
| NPQP   | 50    | 1×     | 50             | NEW — new personas below library median SQS |
| WTTS   | 100   | 1×     | 100            | NEW — all 20 personas in TESTING.md per-persona table |
| LCMU   | 100   | 1×     | 100            | NEW — library count matches cognitive taxonomy count (20/20) |
| PPCC   | 89    | 2×     | 178            | NEW — 4 of 18 WTS complement references imprecisely describe cited FM |
```

**Total: 5,128 / 5,400 (54× weight) = 95.0%**

### New Metrics Defined This Run

**NPQP — New-Persona Quality Parity** (weight 1×)
Definition: Of the most recently added persona(s), what proportion score at or above the library median SQS? Score = (count at/above median) / (count added in last run) × 100. Measures whether library growth maintains quality standards.
Baseline: 50 (0 of 2 new personas at library median SQS=10/10 — both score 9/10).

**WTTS — Workflow Test Table Sync** (weight 1×)
Definition: What proportion of current personas appear as rows in TESTING.md's per-persona table? Score = (personas in table) / (total personas) × 100. Measures whether the testing artefact tracks the live library.
Baseline: 100 (20/20 personas in table — Sage and Poise added to TESTING.md in run 5 H17).

**LCMU — Library Count / Mode Uniqueness** (weight 1×)
Definition: Does the persona count equal the number of distinct cognitive modes in the taxonomy (1 persona per mode)? Score = 100 if count matches and no duplicates; subtract 5 per redundant mode. Measures whether library growth is filling gaps rather than duplicating covered modes.
Baseline: 100 (20 personas, 20 distinct taxonomy modes).

**PPCC — Persona-to-Persona Citation Coherence** (weight 2×)
Definition: Of all WTS cross-references that name another persona's failure mode scenario, what proportion accurately describe the cited persona's actual Failure Mode text? Score = (sum of accuracy scores) / (count of references) × 100, where 1.0 = accurate, 0.5 = partially accurate, 0.0 = inaccurate. Measures whether the inter-persona wiring added by NP6 (Failure Mode Guardrail Documentation) is semantically correct.
Baseline: 89 (16/18 references accurate; 4 references score 0.5 — Vale FM imprecise in Arden WTS, Echo FM imprecise in Arden WTS, Helm FM imprecise in Keeper WTS, Kira FM imprecise in Keeper WTS).

Score calculation: (14 × 1.0 + 4 × 0.5) / 18 × 100 = (14 + 2) / 18 × 100 = 88.9 ≈ 89.

---

## Hypotheses — 2026-03-27 (run 6)

**H19 — Sharpen Sage + Poise Opinion Non-obviousness (NPQP + SQS)**

Prediction: Replace Opinion 1 in `pedagogical/soul.md` and Opinion 1 in `negotiation/soul.md` with opinions that score 2/2 on Non-obviousness (would not be held by a thoughtful person who had never read the library). Expected outcome: NPQP 50→100 (+50pp × 1 weight = +50 weighted); SQS 99→100 (+1pp × 2 weight = +2 weighted). Total: +52 weighted.

Proposed replacement for Sage Opinion 1: "The most dangerous explanation is the one that leaves the reader feeling certain. Confidence without understanding generates misapplication that is harder to correct than the original confusion — a reader who knows they don't understand something will ask; a reader who confidently holds the wrong model won't."

Proposed replacement for Poise Opinion 1: "The most valuable artefact a trade-off analysis produces is the deliberation record — what options were considered and rejected, and why. In six months, when the winning option develops a problem, the team that documented why they ruled out alternatives can revisit the decision in minutes. The team that didn't will re-litigate from scratch."

Evidence: Both replacements are distinctive because they are counter-intuitive: the Sage opinion inverts the usual "clarity = good" framing (clarity is dangerous if it produces false certainty); the Poise opinion redirects attention from the decision itself to the decision record as the primary artefact. Neither would be held by default — they require experience with failure modes of explanation and decision-making respectively.

**H20 — Fix 4 WTS Complement-Reference Descriptions (PPCC)**

Prediction: Correct the 4 imprecise WTS cross-references in `critic/persona.md` and `strategist/persona.md` to accurately paraphrase the cited persona's actual Failure Mode text. Expected outcome: PPCC 89→100 (+11pp × 2 weight = +22 weighted).

Proposed edits:

*critic/persona.md WTS — Vale reference:*
`"Vale (which defends but may minimise genuine problems)"` → `"Vale (which defends but may close a genuine concern with a technically sound but misdirected rebuttal)"`
Evidence: Vale's FM: "A reviewer who raised a genuine flaw but received a well-cited, off-target evidence response is worse than an unresolved comment — the flaw is now documented as addressed."

*critic/persona.md WTS — Echo reference:*
`"when Echo has stayed close to acceptance criteria and missed emergent scope"` → `"when Echo has produced a disproportionately long evidence table for a simple ticket and the scoring feels stalled"`
Evidence: Echo's FM describes over-documentation on simple tickets, not missed scope.

*strategist/persona.md WTS — Helm reference:*
`"when Helm has over-standardised a straightforward change"` → `"when Helm's readiness checklist is blocking a legitimate 'ship now, document later' decision"`
Evidence: Helm's FM: "The readiness checklist becomes a blocker for legitimate 'ship now, document later' decisions."

*strategist/persona.md WTS — Kira reference:*
`"when Kira has delivered to a spec that a reframe would have improved"` → `"when Kira has implemented a spec that context has since made obsolete"`
Evidence: Kira's FM describes delivering to a spec that "context has made obsolete."

**Expected composite after H19 + H20:** 5,128 + 52 + 22 = 5,202 / 5,400 = 96.3% (+1.3pp)

**Auto loop threshold:** > 95% — already above at opening (95.0%). Loop will complete after confirming both hypotheses, as composite will reach 96.3%.

---

## Experiments — 2026-03-27 (run 6)

### H19 — Sharpen Sage + Poise Opinion Non-obviousness

**Files changed:**
- `pedagogical/soul.md` — Opinion 1 replaced
- `negotiation/soul.md` — Opinion 1 replaced

**Before / After:**

*Sage Opinion 1 (before):* "Simple is the hardest register to produce. Anyone who thinks making something simple is easier than making it complex has not tried to do both at the professional level."

*Sage Opinion 1 (after):* "The most dangerous explanation is the one that leaves the reader feeling certain. Confidence without understanding generates misapplication that is harder to correct than the original confusion — a reader who knows they don't understand something will ask; a reader who confidently holds the wrong model won't."

*Poise Opinion 1 (before):* "Consensus is overrated. The best decisions often disappoint someone — and the person making them needs to be willing to own that rather than seeking approval from everyone before committing."

*Poise Opinion 1 (after):* "The most valuable artefact a trade-off analysis produces is the deliberation record — what options were considered and rejected, and why. In six months, when the winning option develops a problem, the team that documented why they ruled out alternatives can revisit the decision in minutes. The team that didn't will re-litigate from scratch."

**Measurement:**

SQS — Sage: Non-obviousness 2/2 (inverts the usual "clarity = good" framing; dangerous certainty is counter-intuitive). Poise: Non-obviousness 2/2 (redirects from the decision to the deliberation record as the primary artefact; distinctive because it focuses on a future reader, not the present decision-maker). Both personas now score 10/10.

Library SQS: All 20 personas score 10/10. SQS = 100. **+1pp from 99. ✓ Confirmed.**
NPQP: Both new personas (Sage, Poise) now at library median (10/10). NPQP = 100. **+50pp from 50. ✓ Confirmed.**

Secondary deltas: none material.

### H20 — Fix 4 WTS Complement-Reference Descriptions

**Files changed:**
- `critic/persona.md` — 2 WTS references updated
- `strategist/persona.md` — 2 WTS references updated

**Before / After:**

*Arden WTS — Vale (before):* "Vale (which defends but may minimise genuine problems)"
*Arden WTS — Vale (after):* "Vale (which defends but may close a genuine concern with a technically sound but misdirected rebuttal)"

*Arden WTS — Echo (before):* "And when Echo has stayed close to acceptance criteria and missed emergent scope."
*Arden WTS — Echo (after):* "And when Echo has produced a disproportionately long evidence table for a simple ticket and the scoring feels stalled."

*Keeper WTS — Helm (before):* "when Helm has over-standardised a straightforward change"
*Keeper WTS — Helm (after):* "when Helm's readiness checklist is blocking a legitimate 'ship now, document later' decision"

*Keeper WTS — Kira (before):* "when Kira has delivered to a spec that a reframe would have improved"
*Keeper WTS — Kira (after):* "when Kira has implemented a spec that context has since made obsolete"

**Measurement:**

PPCC re-score: 18 WTS references. 18/18 now score 1.0 (each accurately paraphrases the cited persona's actual Failure Mode section — verified against advocate/persona.md, examiner/persona.md, release/persona.md, builder/persona.md at time of run). PPCC = 100. **+11pp from 89. ✓ Confirmed.**

Secondary deltas: PCDS re-checked — the 4 corrected references are still semantically valid trigger conditions (Arden still covers Vale's FM scenario; Keeper still covers Helm's FM scenario). PCDS remains 100. No regression.

---

## Report — 2026-03-27 (run 6)

```
| Metric | Before | After | Delta | Weight | Weighted Δ |
|--------|--------|-------|-------|--------|------------|
| SQS    | 99     | 100   | +1    | 2×     | +2         |
| NPQP   | 50     | 100   | +50   | 1×     | +50        |
| PPCC   | 89     | 100   | +11   | 2×     | +22        |
| TOTAL  | 5,128/5,400 | 5,202/5,400 | +74 | 54× | +74 |

Composite: 5,128/5,400 = 95.0% → 5,202/5,400 = 96.3% (+1.3pp)
```

**All 2 hypotheses confirmed. No regressions.**

Largest movers:
1. H19 NPQP +50pp (+50 weighted) — Sage and Poise opinions sharpened to non-obvious; both new personas now at library median SQS; growth-quality discipline established
2. H20 PPCC +11pp (×2=+22 weighted) — 4 imprecise WTS complement-references corrected; inter-persona wiring is now semantically accurate against actual Failure Mode text, not paraphrase
3. H19 SQS +1pp (×2=+2 weighted) — library-wide Opinion Non-obviousness returns to 100 after Sage/Poise additions

Remaining gaps for run 7+:
- IOT=65 — structural ceiling ~75; no further movement without adding pipeline stages
- SRCA=92 — 8% gap between AGENTS.md schema and evolve.md rubric; targeted audit needed
- PVD=61 — 9 young personas (all ≤5 days old); distillation candidates once real usage evidence accumulates
- FMCS=86 — needs re-measurement at 20 personas (190 pairs); 4 partial pairs from run 4 unresolved
- TSCR=25 — 6 command-execution test scenarios remain untested

**Auto loop threshold: composite 96.3% > 95% → loop complete.**
