# Research Log — skills/summary/

Target: `/Users/adjmunro/Developer/agentfiles/skills/summary/`
Run started: 2026-03-27
Mode: auto (stop when composite > 95%)

---

## Iteration 1

### Phase 1 — Audit

**File inventory:**

| File | Classification |
|------|---------------|
| `commands/summary.md` | Command file — 5-phase pipeline logic (~263 lines) |
| `SKILL.md` | Support file — user-facing overview |
| `AGENTS.md` | Support file — commit conventions, scope, DO/DO NOT |
| `TESTING.md` | Support file — test scenarios and refinement log |
| `VERSION.md` | Support file — current version (1.0.0) |
| `CHANGELOG.md` | Support file — change history |

**Feature inventory:**

| Feature | Present |
|---------|---------|
| Multi-phase pipeline | YES — 5 phases |
| Persona system | YES — Arc, Loom, Ward |
| Subagent invocations | NO |
| Multi-session orchestration | NO |
| Parallel/concurrent execution | NO |
| Cached/persisted artifacts | NO |

**Persona staleness check:**

| Persona | File path | Exists | Soul.md referenced | Soul.md loaded in command |
|---------|-----------|--------|--------------------|--------------------------|
| Arc (Sequencer) | `skills/personas/temporal/persona.md` | YES | YES | NO |
| Loom (Synthesist) | `skills/personas/synthesis/persona.md` | YES | YES | NO |
| Ward (Documentation) | `skills/personas/documentation/persona.md` | YES | YES | NO |

**Speciation:** none — all three are single-variant personas.

**Estimated tokens:** ~3,500 across all files.

---

### Phase 2 — Baseline Measurement

#### Applied Metrics

| ID | Name | Score | Weight | Weighted Score | Notes |
|----|------|-------|--------|----------------|-------|
| M1 | Intent-to-Output Traceability | 55 | 1 | 55 | No explicit re-anchor directives at phase boundaries; SCOPE_REF/MODE established in Phase 1 but subsequent phases assume persistence |
| M2 | Directive Density | 72 | 1 | 72 | ~35 imperatives across ~2,000 instruction tokens; good density but Phase 3 synthesis guidance is more explanatory than directive |
| M3 | Instruction Ambiguity Rate | 88 | 1 | 88 | ~4 weak modals/vague thresholds: "aim for one paragraph," "if the file was not changed enough," "each item should be" — IAR ≈ 12% |
| M4 | Wiring Completeness Score | 80 | 1 | 80 | All 3 personas loaded and used; soul.md referenced in each persona file but not explicitly loaded by the command |
| M5 | Redundancy Index | 90 | 1 | 90 | 3–4 rules duplicated between AGENTS.md and commands/summary.md; different audiences so partial intentional overlap |
| M6 | Acceptance Criteria Concreteness | 62 | 1 | 62 | Many step-level instructions are concrete but overall "done" state is undefined; no measurable success threshold for the skill run |
| M8 | Human Touchpoint Count | 95 | 1 | 95 | 0 non-error human touchpoints; only stops are explicit abort conditions on invalid input |
| M10 | Context Loading Efficiency | 70 | 1 | 70 | All 3 personas loaded upfront; ~30% of loaded persona tokens are "When to summon" and DO NOT sections not relevant during execution |
| M13 | Instruction Token Efficiency | 93 | 1 | 93 | Very lean prose; ~5% padding — phase intro lines repeat persona names, minor ceremony |
| M14 | Persona-Phase Fit Score | 71 | 1 | 71 | Phase 5 (Output) has no persona (0.0 fit); Phase 4 Ward assignment is partial (kanban scanning is adjacent but not Ward's core domain); Phase 2 Loom assignment is partial (Phase 2 gathers, Phase 3 synthesises) |
| M15 | Persona Richness Score | 87 | 1 | 87 | All 3 personas have Purpose, DO, DO NOT, When to summon, and Failure Mode — but no explicit "Unique Talent" section; averaging 13/15 per persona |

#### Skipped Metrics

| ID | Name | Reason Skipped |
|----|------|----------------|
| M7 | Subagent Alignment Score | No subagent invocations in this skill |
| M9 | Context Decay Resilience | Single-session workflow; no multi-session orchestration |
| M11 | Parallelisation Safety Score | No parallel/concurrent execution patterns |
| M12 | Information Freshness Score | No inter-session cached artifacts |

#### Custom Metrics (MX)

| ID | Name | Score | Weight | Weighted Score | Notes |
|----|------|-------|--------|----------------|-------|
| MX-1 | Ref Resolution Failure Rate | 75 | 1 | 75 | Error handling table covers unresolvable refs and missing git; upstream tracking fallback exists; no coverage for detached HEAD or shallow clones |
| MX-2 | Source Domain Coverage Score | 60 | 1 | 60 | Phase 2 reading steps are conditional on what changed — if only git commits changed, synthesis may proceed from a single source domain without flagging reduced coverage |
| MX-3 | Output Section Completeness Rate | 75 | 1 | 75 | Phase 5 mandates all 5 sections; error handling provides fallback text; "no files changed" path omits sections 2–5 without per-section fallbacks |
| MX-4 | Why-Section Depth Score | 55 | 1 | 55 | **(Moonshot — borrowed from journalism's "5 Ws" quality rubric)** Why section falls back to a single placeholder if no commit bodies or CHANGELOG rationale exists; no minimum depth requirement or quality gate before proceeding |
| MX-5 | Persona Transition Clarity Score | 65 | 1 | 65 | Ward inserted mid-Phase 2 (Step 5) with no explicit "return to Loom" signal; Phase 5 has no persona active and no explicit note that it is persona-free |

#### Composite Score

```
Sum of weighted scores: 55+72+88+80+90+62+95+70+93+71+87+75+60+75+55+65 = 1,193
Total weight units: 16
Composite = 1,193 / (16 × 100) × 100 = 74.6%
```

**Baseline composite: 74.6%**

**3 Weakest metrics:**
1. M1 Intent-to-Output Traceability: **55** — no inter-phase re-anchoring
2. MX-4 Why-Section Depth Score: **55** — no quality gate on the Why section
3. MX-2 Source Domain Coverage Score: **60** — single-domain synthesis not flagged

**3 Strongest metrics:**
1. M8 Human Touchpoint Count: **95** — near-fully autonomous
2. M13 Instruction Token Efficiency: **93** — lean, direct prose
3. M5 Redundancy Index: **90** — low duplication across files

---

### Phase 3 — Hypotheses

#### H1 — Intent Anchor Between Phases

**Problem observed:** M1 (Intent-to-Output Traceability) scored 55. Phases 2–5 rely on `SCOPE_REF` and `MODE` set in Phase 1 but contain no explicit directive to re-read or re-state these values at phase entry. In a long session, context drift could cause later phases to lose the established boundary.
**Change proposed:** Add an explicit Intent Anchor Block at the start of Phase 2 and Phase 3. Each block re-states `SCOPE_REF` and `MODE` and confirms that prior phase output is intact before proceeding.
**Targets:** Intent-to-Output Traceability ↑
**Predicted improvement:** +20 pp (55 → 75)
**Pattern applied:** P1 — Intent Anchor Blocks
**Risk level:** low
**Risk note:** Adding anchor language increases file length slightly; risk of over-anchoring is low given the skill is 5 phases.

---

#### H2 — Why-Section Quality Gate

**Problem observed:** MX-4 (Why-Section Depth Score) scored 55 and M6 (Acceptance Criteria Concreteness) scored 62. The Why section has no minimum depth requirement — if commit bodies and CHANGELOG rationale are absent, the output is a single placeholder sentence with no actionable guidance.
**Change proposed:** Add a quality gate to Phase 3 Step 4: if the Why section would contain only the fallback placeholder, require a note identifying which commits are missing bodies, and recommend the author enrich them before re-running. This converts a silent degradation into an explicit diagnostic signal.
**Targets:** MX-4 Why-Section Depth Score ↑, M6 Acceptance Criteria Concreteness ↑
**Predicted improvement:** MX-4 +25 pp (55 → 80), M6 +5 pp (62 → 67)
**Pattern applied:** P6 — Symmetric Outcome Thresholds
**Risk level:** low
**Risk note:** Surfacing missing commit bodies may feel noisy; risk is that users feel judged on commit hygiene. The note should be framed as diagnostic, not prescriptive.

---

#### H3 — Phase 5 Persona Assignment

**Problem observed:** M14 (Persona-Phase Fit Score) scored 71. Phase 5 (Output assembly) has no active persona, scoring 0.0 fit. The output assembly step would benefit from an editorial lens to ensure coherence and reviewer-appropriateness.
**Change proposed:** Assign Ward (Documentation) to Phase 5 with the directive: "Ward (Documentation) is active. Assemble sections in the defined order. Write for the next person reading this — assume no prior context about this branch or session."
**Targets:** Persona-Phase Fit Score ↑
**Predicted improvement:** Phase 5 fit 0.0 → 0.75 (Ward is a partial fit for output assembly — her "write for the next person" directive aligns with the goal); PPF 71 → 77
**Pattern applied:** P8 — Persona Rotation (gap-fill variant)
**Risk level:** low
**Risk note:** Ward may over-focus on documentation accuracy at the expense of editorial flow; acceptable trade-off.

---

#### H4 — Source Domain Coverage Guard

**Problem observed:** MX-2 (Source Domain Coverage Score) scored 60. Phase 2 reading steps are conditional on what changed — if only git commits changed and no CHANGELOG or instruction files were modified, synthesis in Phase 3 proceeds from a single source domain without flagging this reduction.
**Change proposed:** Add a source domain tally to the end of Phase 2: count how many of the three domains (commit messages, CHANGELOG entries, instruction files) yielded data. If only one domain contributed, include a note in the Context block: "Source coverage: commit messages only — no CHANGELOG entries or instruction file changes in this range."
**Targets:** MX-2 Source Domain Coverage Score ↑
**Predicted improvement:** +20 pp (60 → 80)
**Pattern applied:** P7 — Binary Applicability Gates
**Risk level:** low
**Risk note:** The domain tally adds a small step to Phase 2; risk of cluttering the Context block if coverage note appears when all 3 domains are available (should only fire when reduced).

---

#### H5 — Persona Transition Clarity

**Problem observed:** MX-5 (Persona Transition Clarity Score) scored 65. Ward activates mid-Phase 2 (Step 5) without an explicit return signal to Loom after that step. Phase 5 has no active persona and no explicit note that it is persona-free.
**Change proposed:** (a) After Phase 2 Step 5, add: "*Loom (Synthesist) resumes for Phase 3.*" (b) At Phase 5 entry, add: "*No persona is active for output assembly — follow section structure exactly.*"
**Targets:** MX-5 Persona Transition Clarity Score ↑, M14 Persona-Phase Fit Score ↑
**Predicted improvement:** MX-5 +20 pp (65 → 85); M14 minor secondary lift (+2 pp)
**Pattern applied:** P8 — Persona Rotation (handoff clarification)
**Risk level:** low
**Risk note:** Cosmetic; primary risk is cluttering the command file with transition markers, but each is one short line.

---

#### H6 — Progressive Persona Loading

**Problem observed:** M10 (Context Loading Efficiency) scored 70. All three persona files are loaded upfront at command entry. Arc is only relevant in Phase 1, Loom in Phases 2–3, Ward in Phase 2 Step 5 and Phase 4. Preloading all three loads "When to summon" and DO NOT sections that are not relevant at execution time.
**Change proposed:** Restructure the persona load directive from a global preload to phase-level progressive disclosure: load Arc at Phase 1 entry, Loom at Phase 2 entry, Ward at Phase 2 Step 5 entry. Remove the global "Read each file before proceeding" block.
**Targets:** Context Loading Efficiency ↑
**Predicted improvement:** +15 pp (70 → 85)
**Pattern applied:** P3 — Progressive Disclosure
**Risk level:** medium
**Risk note:** Progressive loading breaks the single "read all personas first" mental model. An agent that skips ahead to Phase 2 without reading Phase 1 could miss the Arc load. This risk is acceptable because the phase boundary is already an explicit context anchor.

---

#### Self-Audit

**Intent check:** No hypothesis targets a metric already at 100. ✓

**Coverage check:** Projected composite after all hypotheses confirmed:
- M1: 55 → 75 (+20)
- MX-4: 55 → 80 (+25)
- M6: 62 → 67 (+5)
- M14: 71 → 77 (+6)
- MX-2: 60 → 80 (+20)
- MX-5: 65 → 85 (+20)
- M10: 70 → 85 (+15)

Projected sum: 1193 + 20+25+5+6+20+20+15 = 1193 + 111 = 1,304
Projected composite: 1,304 / 1,600 = 81.5%

Still below 95% — further iterations will be needed in auto mode.

**Gap fill:** Every metric below 80 has at least one hypothesis. ✓

---

#### Recommendation Brief

Six experiments are proposed:

1. **Intent anchoring** — phases 2 and 3 will re-state the git ref boundary before doing any work, so that even in a long session the established scope is never lost.
2. **Why-section quality gate** — if the "Why" section would only produce a placeholder because commits have no message bodies, the skill will flag which commits are missing context and prompt the author to add it.
3. **Phase 5 persona** — the output assembly phase currently has no active persona; assigning Ward ("write for the next person, assume no prior context") will make the assembled report more reviewer-ready.
4. **Source domain coverage notice** — when only commit messages are available (no changelogs or instruction file changes), the skill will note this in the Context block rather than silently synthesising from a single source.
5. **Persona handoff markers** — two single-line transitions (Ward → Loom after Phase 2 Step 5; "no persona active" at Phase 5 entry) to remove ambiguity about which cognitive mode is in effect.
6. **Progressive persona loading** — rather than reading all three personas at the start, each persona is loaded at the phase where it first becomes active, keeping earlier phases lean.

---
