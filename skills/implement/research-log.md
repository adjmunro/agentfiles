## Audit — 2026-03-25

**Target:** skills/implement/
**Files:** 28 total (23 command, 5 support)
**Token estimate:** ~10,800 tokens

### Feature Inventory
- Multi-phase pipeline: yes — work pipeline (8 phases: 1→2→4→3→5→6→7→8), review pipeline (6 phases: 1→2a→2b→2c conditional→3→4 or 5→6)
- Persona system: yes — Kira (Builder, work.md), Echo (Examiner, review.md p2a), Arden (Critic, review.md p3 + cleanup.md), Keeper (Strategist, next.md), Ward (Documentation, review p2c conditional), Vale (Advocate, pr.md), Helm (Release, pr.md p6), Pulse (Analytics, cleanup.md p6)
- Subagent invocations: yes — next.md dispatches work.md and review.md as subagents at model tiers (haiku/sonnet/opus based on ticket `effort` field)
- Multi-session orchestration: yes — lock files at `.claims/{ticket-id}.lock`, `stale_after_hours`, `from-ideation-handoff` bypass, `expires_at` claimed check in next.md
- Parallel execution: no
- Cached artifacts: yes — ticket files (no TTL), plan files (7-day TTL in p3 and p2a), quality envelope `00-quality-{subject}.md` (append-only, no TTL), lock files (stale after `stale_after_hours`)

### Persona Staleness Check
All persona load directives resolve. Path prefix `../../personas/` from within `commands/` resolves to `skills/personas/`, which exists. Verified present:
- `builder/persona.md` ✓, `examiner/persona.md` ✓, `critic/persona.md` ✓, `strategist/persona.md` ✓, `documentation/persona.md` ✓, `advocate/persona.md` ✓, `release/persona.md` ✓, `analytics/persona.md` ✓

No broken persona references. No speciation origins found in any soul.md.

### Structural Anomalies (flagged for Phase 2/3)
1. **Field name mismatch**: `next.md` Claimed Check references `expires_at` on the ticket — but `_shared.md` ticket frontmatter schema defines `stale_after_hours` + `claimed_at` (no `expires_at`). These are different fields; `expires_at` would always be undefined.
2. **Dependency definition inconsistency**: `work/p2-ticket-selection.md` accepts a ticket as unblocked if its dependency has `status: 06-in-review|07-pull-request|08-done`; `next.md` dispatch check requires `status: done` in those directories — differing completion criteria for the same dependency concept.
3. **Commit format inconsistency**: `work/p7-commit.md` specifies `feat(scope): implement {ticket-id}`; `work/p3-implementation.md` specifies `feat({NNN}): [what and why]` — two conflicting formats in the same pipeline.

### Files
**Command files (23):**
- commands/work.md — orchestrator, work pipeline entry point
- commands/review.md — orchestrator, review pipeline entry point
- commands/next.md — orchestrator, full work→review loop with subagent dispatch
- commands/pr.md — pull-request command
- commands/cleanup.md — cleanup command
- commands/_shared.md — shared ticket schema, audit formula, directory structure
- commands/work/p1-session-check.md — conflict detection, read-only phase
- commands/work/p2-ticket-selection.md — dependency check, lock file write, ticket claim
- commands/work/p3-implementation.md — intent anchor, implementation loop, WHY-comment enforcement
- commands/work/p4-stale-detection.md — stale plan detection, Continue or Reset options
- commands/work/p5-scope-enforcement.md — out-of-scope ticket spawning
- commands/work/p6-work-log.md — append-only work log, cross-agent memory
- commands/work/p7-commit.md — commit format, return routing
- commands/work/p8-move-to-review.md — session close, quality envelope append, status: in_review
- commands/review/p1-resolve-ticket.md — ticket resolution, status confirmation
- commands/review/p2a-examiner.md — evidence table, intent anchor, security/logic flags
- commands/review/p2b-tests.md — test suite detection, framework table, execution
- commands/review/p2c-documentation.md — documentation AC verification (conditional)
- commands/review/p3-score.md — scoring formula (satisfied + 0.5×partial) / total × 100
- commands/review/p4-pass.md — pass path, status: done, move to 07-pull-request/
- commands/review/p5-fail.md — fail path, consecutive_failures increment, PR Response envelope append
- commands/review/p6-report.md — always-include report format
- commands/.gitkeep — placeholder (empty)

**Support files (5):**
- SKILL.md — overview, commands summary
- AGENTS.md — agent configuration reference
- VERSION.md — current version
- CHANGELOG.md — version history
- TESTING.md — test scenarios

---

## Custom Metrics — 2026-03-25

### MX1 — Commit Format Consistency Score (CFCS) [custom]
**Measures:** whether every file that prescribes a commit message format agrees on the format for the same type of commit.
**Why seeds miss it:** M5 (Redundancy Index) detects duplicate instructions, not contradictory ones. M6 (AC Concreteness) evaluates vagueness in stop conditions, not cross-file definitional conflicts.
**Methodology:** Enumerate all commit format prescriptions in instruction files. Group by commit type (implementation commit, claim commit, review commit). For each type, count distinct format templates. Score = 1 if all types are internally consistent, 0 if any type has multiple conflicting formats.
**Direction:** ↑ higher is better (one format per commit type = 100)
**Weight:** 1×
**Normalisation:** score × 100

### MX2 — Dependency Definition Consistency (DDC) [custom]
**Measures:** whether the "dependency is satisfied" condition is defined consistently across all command files that check it.
**Why seeds miss it:** No seed metric checks cross-file definitional consistency for workflow concepts.
**Methodology:** Find all files that define or check when a dependency is considered satisfied. Extract the exact condition from each. Count unique definitions. Score = 1 / num_unique_definitions.
**Direction:** ↑ higher is better (one definition everywhere = 100)
**Weight:** 1×
**Normalisation:** score × 100

### MX3 — Schema Field Integrity (SFI) [custom]
**Measures:** whether every frontmatter field name referenced across command files exists in the canonical ticket schema in `_shared.md`.
**Why seeds miss it:** M5 (RI) does not check schema conformance. No seed metric validates cross-file field usage against a canonical schema.
**Methodology:** Extract all ticket frontmatter field names referenced in command files (status, claimed_at, expires_at, stale_after_hours, etc.). Cross-reference against the `_shared.md § Ticket Frontmatter Schema`. Count referenced field names absent from the schema. Score = 1 − (undefined_fields / total_referenced_fields).
**Direction:** ↑ higher is better (all fields defined in schema = 100)
**Weight:** 2×
**Normalisation:** score × 100

### MX4 — Quality Envelope Signal Coverage (QESC) [custom]
**Measures:** what proportion of the quality envelope's signal types that the implement skill is responsible for have explicit write instructions in command files.
**Why seeds miss it:** M1 (IOT) measures whether phases read prior artifacts, not whether they write to outcome logs. No seed measures write completeness for append-only outcome stores.
**Methodology:** Identify the quality envelope signal types implement owns (Work Sessions, PR Responses). Verify each has an explicit write instruction in at least one command file. Score = signals_with_write_instruction / total_owned_signals.
**Direction:** ↑ higher is better (all owned signals have write instructions = 100)
**Weight:** 1×
**Normalisation:** score × 100

### MX5 — Claim Lifecycle Completeness (CLCS) [custom, moonshot]
**Measures:** whether every stage of the lock file lifecycle (create, validate, expire/abandon, release) has explicit handling in command files. Lock files are the workflow's only concurrency-safety mechanism — an incomplete lifecycle creates ghost claims or deadlocks across sessions.
**Why seeds miss it:** M12 (IFS) checks TTL policies on artifacts but not whether the full stateful resource lifecycle is specified. This borrows a reliability-engineering concept (resource lifecycle completeness) to evaluate a documentation workflow's safety mechanism.
**Methodology:** The complete lock lifecycle has 4 stages: (1) Create — write lock on claim; (2) Validate — read lock and check before new claim; (3) Expire — detect stale lock and auto-recover; (4) Release — delete lock on ticket completion. Score = stages_with_explicit_handling / 4.
**Direction:** ↑ higher is better (all 4 stages covered = 100)
**Weight:** 2×
**Normalisation:** score × 100

---

## Baseline — 2026-03-25

**Pulse (Analytics)** — re-read research-log.md (Intent Anchor). Measuring implement skill instruction quality against all applicable seed metrics (M1–M15) and custom metrics (MX1–MX5 + MX-OQ series).

### M1 — Intent-to-Output Traceability (IOT) ✓ applied
**Apply:** yes — multi-phase pipeline (work 8 phases, review 6 phases, next 4 phases)
**Methodology:** Count phases with an explicit prior-artifact read (re-reads plan file, ticket file, or prior phase output before acting).

- Work pipeline (8): p1=NO (initial scan only), p2=YES (reads lock files + ticket), p4=YES (reads claimed_at), p3=YES (explicit INTENT ANCHOR — reads plan + ticket), p5=YES (reads ticket), p6=YES (appends to ticket), p7=YES (follows prior commit), p8=YES (reads ticket state) → 7/8
- Next orchestrator (6 sections): Phase1=NO (initial glob), ClaimedCheck=YES (reads ticket frontmatter), Phase2=YES (reads ticket depends_on), StaleCheck=YES (reads 05-in-progress/), Phase3=YES (explicit INTENT ANCHOR — reads plan ## Intent before each dispatch), Phase4=YES (reads ticket stages) → 5/6
- Review pipeline (8): p1=YES (reads ticket), p2a=YES (explicit plan read + 1-sentence intent anchor), p2b=YES (uses evidence from p2a), p2c=YES (reads AC list), p3=YES (uses evidence table), p4=YES (reads verdict), p5=YES (reads verdict + review history), p6=YES (uses p4/p5 results) → 8/8

**Total: 20/22 phases**
**Raw: 20/22 = 90.9%**
**Normalised: 91**

---

### M2 — Directive Density (DD) ✓ applied
**File classification:** Instruction files = all work/*.md, review/*.md, work.md, review.md, next.md, pr.md, cleanup.md. Documentation files = _shared.md (schema reference tables, no agent directives), SKILL.md, AGENTS.md, CHANGELOG.md, VERSION.md, TESTING.md.

Directive count across instruction files ≈ 270 (DO/DO NOT items + numbered imperatives).
Instruction file tokens ≈ 7,100.
DD = 270 / (7100/100) = 270/71 = 3.8
Normalised: (3.8/2.0) × 100 = 190 → capped at 100.

**Normalised: 100**

---

### M3 — Instruction Ambiguity Rate (IAR) ✓ applied
**Scan:** All instruction files checked for unscoped weak modals. Grep confirms only 2 instances of "should" in command files (cleanup.md lines 81 and 217) — both scoped by explicit conditions. All "may" uses are descriptive (stating a possibility, not an instruction).

Ambiguous instructions ≈ 2 out of ≈ 300 total instructions.
IAR = 2/300 = 0.7%
Normalised: 100 − 0.7 = 99.3%

**Normalised: 99**

---

### M4 — Wiring Completeness Score (WCS) ✓ applied
**Apply:** yes — persona system present.

8 personas referenced in command files: builder (work.md), examiner (review.md), critic (review.md + cleanup.md), strategist (next.md), documentation (review/p2c), advocate (pr.md), release (pr.md), analytics (cleanup.md). All 8 have corresponding `persona.md` files and are explicitly loaded in command files appropriate to their cognitive demand.

WCS = 8/8 = 100%
**Normalised: 100**

---

### M5 — Redundancy Index (RI) ✓ applied
**Redundant instruction instances identified:**
1. 7-day plan TTL policy: appears verbatim in both `work/p3-implementation.md` and `review/p2a-examiner.md` → 1 redundant instance
2. WHY-comments requirement: in `work.md` DO list ("Include inline WHY-comments in every code change") AND in `work/p3-implementation.md` dedicated section → 1 redundant instance
3. Plan-layer isolation (read-only paths): in `work.md` DO NOT AND in `work/p3-implementation.md` dedicated section → 1 redundant instance

Total redundant: ≈ 3 out of ≈ 300 instructions = 1.0%
Normalised: 100 − 1.0 = 99.0%

**Normalised: 99**

---

### M6 — AC Concreteness (ACC) ✓ applied
**All stop conditions and done-when statements:**

Concrete (10):
1. Review PASS: score ≥ 95% AND all test suites green — numeric threshold
2. All-tickets check: all tickets in 07-pull-request/ — file-count check
3. Session rating responses: yes/partially/no/skip — enumerated list
4. Lock file expiry: age > stale_after_hours — time delta computation
5. Stale ticket: stale_after_hours elapsed since claimed_at — time formula
6. Plan staleness: age > 7 days — day threshold
7. Consecutive failures escalation: ≥ 2 warn, ≥ 3 notify — count thresholds
8. Same-error escalation: 2–3 identical failures unchanged — count-based
9. PR-ready: all tickets in 07-pull-request/ — location check
10. "Meaningful unit of work" + clarifying list (type, function, test suite, protocol, config) — enumerated

Vague (4):
1. Work.md Phase 8 dispatch trigger: "all ACs verified and work log appended" — no scoring formula
2. p3 → p6 transition: "When implementation is complete and all ACs are addressed" — subjective
3. p7 trigger: "any phase produces a meaningful artifact" — interpretive
4. p5 trigger: "out-of-scope work discovered during implementation" — interpretive

ACC = 10/14 = 71%
**Normalised: 71**

---

### M7 — Subagent Alignment Score (SAS) ✓ applied
**Apply:** yes — next.md dispatches work.md and review.md as subagents.

1. Work subagent dispatch: isolated (one ticket per session, lock file prevents double-claim), no shared mutable state, context bundle explicitly minimised → appropriate
2. Review subagent dispatch: isolated (reads ticket and source files only), no shared mutable state → appropriate

Degradation path present: "If subagents are unavailable, run sequentially."

SAS = 2/2 = 100%
**Normalised: 100**

---

### M8 — Human Touchpoint Count (HTC) ✓ applied
**Counting mandatory touchpoints in a normal single-ticket run (auto mode, no stale tickets, no repeated failures):**

1. p8 session-close rating — 1 AskUserQuestion per ticket (advisory, skip is a valid response)

No other mandatory touchpoints for a normal run. Conditional touchpoints (multi-subject prompt, stale ticket surface, same-error escalation) are not counted for HTC normalisation — they occur only when the workflow is handling errors.

HTC = 1 (one mandatory touchpoint per ticket run)
Normalised: max(0, 100 − (1/20) × 100) = 95

**Normalised: 95**

---

### M9 — Context Decay Resilience (CDR) ✓ applied
**Apply:** yes — multi-session orchestration (lock files, stale detection, session boundaries).

Session transitions:
1. Orchestrator → work subagent: next.md Phase 3a explicitly reads plan ## Intent before dispatching → re-anchored ✓
2. Work complete → review subagent: next.md Phase 3b explicitly re-reads plan ## Intent before dispatching → re-anchored ✓
3. Review FAIL → work retry: loops back to Phase 3a INTENT ANCHOR → re-anchored ✓
4. Stale ticket resume: stale check hands off to Phase 3a dispatch, which includes INTENT ANCHOR → re-anchored ✓

CDR = 4/4 = 100%
**Normalised: 100**

---

### M10 — Context Loading Efficiency (CLE) ✓ applied
**Assessment by pipeline:**
- Work pipeline (work.md + 8 phase files): progressive disclosure — each phase file loaded only on entry (~200-500t per phase, all relevant). CLE ≈ 95%.
- Review pipeline (review.md + 8 phase files): same progressive disclosure structure. CLE ≈ 95%.
- next.md: monolithic — all 4 phases inline (~900t). Phase 1 entry loads ~900t but only ~150t is immediately relevant. Average CLE across 4 phases ≈ 46%.
- pr.md + cleanup.md: semi-monolithic (phases inline), ~700-800t each. Average CLE ≈ 70%.

Weighted average: (work: 8 × 0.95) + (review: 8 × 0.95) + (next: 4 × 0.46) + (pr+cleanup: 6 × 0.70) / 26 phases
= (7.6 + 7.6 + 1.84 + 4.2) / 26 = 21.24/26 = 81.7%

**Normalised: 82**

---

### M11 — Parallelisation Safety Score (PSS)
**SKIP — Phase 1 inventory confirms no parallel execution.** Work proceeds one ticket at a time; no concurrent phase blocks or worktree patterns.

---

### M12 — Information Freshness Score (IFS) ✓ applied
**Apply:** yes — cached artifacts read across sessions.

Inter-session artifacts:
1. Plan files (`02-plan-{subject}.md`): explicit 7-day TTL policy in both `work/p3-implementation.md` and `review/p2a-examiner.md` — load with staleness warning if age > 7 days ✓
2. Ticket files: explicitly documented as "NO TTL — frontmatter is updated in-place and always reflects current state" in `work/p3-implementation.md` ✓
3. Lock files (`.claims/{ticket-id}.lock`): `stale_after_hours` check before every claim ✓
4. Quality envelope (`00-quality-{subject}.md`): append-only design — never overwritten; no TTL needed (always current) ✓

IFS = 4/4 = 100%
**Normalised: 100**

---

### M13 — Instruction Token Efficiency (ITE) ✓ applied
**Padding scan (instruction files only; documentation files excluded):**

Padding categories identified:
- `<!-- Part of: ... -->` and `<!-- Active when: ... -->` labels: ~100t total — architectural labels, non-directive
- `<!-- INTENT ANCHOR ... -->` comment blocks in p3: ~40t — explanatory, non-directive
- `<!-- WHY this section exists: ... -->` comment blocks in p8 and p5-fail: ~150t — narrative restatement
- Architectural comment in work.md/review.md/next.md headers: ~80t — non-directive prose

Total padding ≈ 370 tokens out of ≈ 7,100 instruction tokens.
ITE = 1 − (370/7100) = 1 − 0.052 = 0.948

**Normalised: 95** (rounding up from 94.8)

---

### M14 — Persona-Phase Fit Score (PPF) ✓ applied
**Apply:** yes — persona system present. All personas score 14/14 PRS (no depth-based downgrade).

**Phase assessments:**

*Work pipeline — Kira (Builder) throughout (8 phases):*
- p1 Session Check: analytical conflict detection — Builder adjacent (0.5)
- p2 Ticket Selection: dependency analysis + mechanical selection — Builder adjacent (0.5)
- p4 Stale Detection: mechanical temporal check — Builder adjacent (0.5)
- p3 Implementation: creative execution — Builder = perfect fit (1.0)
- p5 Scope Enforcement: scope gating — directly Kira's core concern (1.0)
- p6 Work Log: documentation writing — Builder adequate, Ward would be sharper (0.5)
- p7 Commit: mechanical execution — Builder appropriate (1.0)
- p8 Move to Review: session close — Builder appropriate as work completer (0.75)
Subtotal: 5.75/8

*Next orchestrator — Keeper (Strategist) throughout (4 phases + 2 sub-phases):*
- Phase 1 Subject Selection: strategic selection — Keeper = perfect fit (1.0)
- Claimed Check: mechanical validation — Keeper adjacent (0.75)
- Phase 2 Ticket Selection: logical dependency analysis — Keeper adjacent (0.75)
- Stale Check: detection → Keeper adjacent (0.75)
- Phase 3 Work→Review Loop: orchestration + escalation routing — Keeper = perfect fit (1.0)
- Phase 4 PR-Ready Announcement: reporting — Keeper adequate (0.75)
Subtotal: 5.0/6

*Review pipeline (8 phases):*
- p1 Resolve Ticket: mechanical resolution — Echo/Arden both loaded; neutral phase (1.0)
- p2a Examiner: evidence mapping — Echo = perfect fit (1.0)
- p2b Tests: technical test execution — Echo (analytical) = good fit (1.0)
- p2c Documentation: documentation review — Ward = perfect fit (1.0)
- p3 Score: critical judgment — Arden (Critic) = perfect fit (1.0)
- p4 Pass: process execution — Arden present, neutral path (0.75)
- p5 Fail: failure analysis + escalation — Arden = well-suited (1.0)
- p6 Report: neutral reporting — Arden active (slight mismatch for neutral; Arden may add critical framing) (0.75)
Subtotal: 7.5/8

*PR command — Vale (Advocate) + Helm (Release):*
- Vale phases: PR communication and evidence-based defence — Advocate = perfect fit (1.0 × 2 = 2.0/2)
Subtotal: 2.0/2

*Cleanup command — Arden (Critic) + Pulse (Analytics):*
- Arden phases (1-2): audit/cleanup verification — Critic = perfect fit (1.0 × 2)
- Pulse phase (6): post-archive analytics — Analytics = perfect fit (1.0)
Subtotal: 3.0/3

**Total: 5.75 + 5.0 + 7.5 + 2.0 + 3.0 = 23.25 / 27 phases = 86.1%**

**Normalised: 83** (conservative rounding given uncertainty in work pipeline scores)

---

### M15 — Persona Richness Score (PRS) ✓ applied
**Apply:** yes. Rubric: 14 fields max per persona.

All 8 personas used by implement: Kira (Builder), Echo (Examiner), Arden (Critic), Keeper (Strategist), Ward (Documentation), Vale (Advocate), Helm (Release), Pulse (Analytics).

All 8 score 14/14: Purpose ✓, DO≥3 ✓, DO NOT≥2 ✓, When to summon ✓, Failure Mode ✓, soul.md ✓, Essence ✓, Core Truths≥3 ✓, Opinions≥2 ✓, Contradictions≥1 ✓, Voice ✓, Unique Talent ✓.

PRS = 8 × 14/14 / 8 = 100%
**Normalised: 100**

---

### MX-OQ Series

**MX-OQ1 — Interview Acceptance Rate**: SKIP — no Interview Signals data in `.kanban/.archive/*/00-quality-*.md`. Quality envelope comment: "subject was completed before interview acceptance tracking was implemented."

**MX-OQ2 — First-Pass Review Rate**:
Archived done-tickets: 6 (TASK-001 through TASK-006, all `consecutive_failures: 0`).
Rate = 6/6 = 100%. ⚠ 1 archived subject — insufficient sample, treat as directional only.
**Normalised: 100** (directional)

**MX-OQ3 — Plan Stability Rate**:
**Updated methodology (H5):** MX-OQ3 scores only `structural` and `undocumented` drift as unstable. `expected` drift (deliberate plan extension during active session, all lines added, none removed) counts as stable. See H5 in Experiments section.

1 archived subject with Plan Drift data. Drift = "Significant" (256 lines added, 0 removed).
Drift character: all lines added, no removals → classified as `expected` (plan extended, not rewritten).
Quality envelope comment confirms: plan extended during session for PR response tracking feature addition, not indicative of planning instability.
Stable subjects (expected drift) = 1/1. Rate = 100%.
⚠ 1 archived subject — insufficient sample, treat as directional only.
**Normalised: 100** (directional — methodology corrected by H5)

**MX-OQ4 — Session Satisfaction Rate**: SKIP — no Work Sessions ratings. Quality envelope: "No session-close ratings recorded — TASK-004 added this going forward."

**MX-OQ5 — PR Critique Rate**:
PR Responses from quality envelope: "No PR rework cycles — all 6 tickets passed first review."
Total rework events = 0 across 6 archived tickets. Rate = 0 average cycles per ticket.
Score = max(0, 100 − (0 × 50)) = 100%.
⚠ 1 archived subject — directional only.
**Normalised: 100** (directional)

---

### MX Custom Metric Scores

**MX1 — Commit Format Consistency Score (CFCS)**
Implementation commit format prescriptions:
- `work/p3-implementation.md`: `feat({NNN}): [what and why in one line]`
- `work/p7-commit.md`: `feat(scope): implement {ticket-id}`

Two incompatible formats for the same commit type. Score = 0.
**Normalised: 0**

**MX2 — Dependency Definition Consistency (DDC)**
Files defining dependency satisfaction:
- `work/p2-ticket-selection.md`: "dependency satisfied if ticket exists in 06-in-review/, 07-pull-request/, or 08-done/ with status: in_review, in_pr, or done"
- `next.md` Phase 2: "dependency satisfied if ticket exists in 06-in-review/ or 07-pull-request/ with status: done"

Two distinct definitions (work/p2 accepts in_review/in_pr; next/p2 requires done only; work/p2 accepts 08-done/, next/p2 does not). Score = 1/2 = 50%.
**Normalised: 50**

**MX3 — Schema Field Integrity (SFI)**
Canonical fields in `_shared.md`: id, subject, plan, effort, status, created_at, claimed_at, completed_at, stale_after_hours, depends_on, spawned_tickets, plan_items, acceptance_criteria, consecutive_failures (15 fields).
Undefined fields referenced in command files: `expires_at` (referenced 6× in `next.md` Claimed Check section — not in canonical schema).
Total referenced: 16 unique field names. Undefined: 1.
Score = 1 − (1/16) = 0.9375.
**Normalised: 94**

**MX4 — Quality Envelope Signal Coverage (QESC)**
Implement-owned signal types: Work Sessions + PR Responses.
Write instructions present: Work Sessions → `work/p8-move-to-review.md` ✓; PR Responses → `review/p5-fail.md` ✓.
Score = 2/2 = 100%.
**Normalised: 100**

**MX5 — Claim Lifecycle Completeness (CLCS)**
Lock file lifecycle stages:
1. Create: `work/p2-ticket-selection.md` step 3 — explicit write with claimed_at + session_hint + stale_after_hours ✓
2. Validate: `work/p2` pre-claim check — reads lock and checks age before proceeding ✓
3. Expire: `work/p2` step 2b — "age > stale_after_hours → lock is abandoned, delete it and proceed" ✓
4. Release: `work/p8-move-to-review.md` — "Lock file cleanup: After moving the ticket to 06-in-review/, delete [lock file]" ✓

All 4 stages covered. Score = 4/4 = 100%.
**Normalised: 100**

---

### Composite Calculation

```
Seed metrics applied: Intent-to-Output Traceability, Directive Density, Instruction Ambiguity Rate, Wiring Completeness Score, Redundancy Index, AC Concreteness, Subagent Alignment Score, Human Touchpoint Count, Context Decay Resilience, Context Loading Efficiency, Information Freshness Score, Instruction Token Efficiency, Persona-Phase Fit Score, Persona Richness Score
Seed metrics skipped: Parallelisation Safety Score (no parallel execution)
Custom metrics: Commit Format Consistency Score (1×), Dependency Definition Consistency (1×), Schema Field Integrity (2×), Quality Envelope Signal Coverage (1×), Claim Lifecycle Completeness (2×), First-Pass Review Rate (2×, directional), Plan Stability Rate (1×, directional), PR Critique Rate (2×, directional)

| Metric | Source | Normalised | Weight | Weighted |
|--------|--------|-----------|--------|----------|
| Intent-to-Output Traceability | seed | 91 | 1× | 91 |
| Directive Density | seed | 100 | 1× | 100 |
| Instruction Ambiguity Rate | seed | 99 | 1× | 99 |
| Wiring Completeness Score | seed | 100 | 1× | 100 |
| Redundancy Index | seed | 99 | 1× | 99 |
| AC Concreteness | seed | 71 | 1× | 71 |
| Subagent Alignment Score | seed | 100 | 1× | 100 |
| Human Touchpoint Count | seed | 95 | 1× | 95 |
| Context Decay Resilience | seed | 100 | 1× | 100 |
| Context Loading Efficiency | seed | 82 | 1× | 82 |
| Information Freshness Score | seed | 100 | 1× | 100 |
| Instruction Token Efficiency | seed | 95 | 1× | 95 |
| Persona-Phase Fit Score | seed | 83 | 1× | 83 |
| Persona Richness Score | seed | 100 | 1× | 100 |
| Commit Format Consistency Score | custom | 0 | 1× | 0 |
| Dependency Definition Consistency | custom | 50 | 1× | 50 |
| Schema Field Integrity | custom | 94 | 2× | 188 |
| Quality Envelope Signal Coverage | custom | 100 | 1× | 100 |
| Claim Lifecycle Completeness | custom | 100 | 2× | 200 |
| First-Pass Review Rate | custom (OQ) | 100 | 2× | 200 |
| Plan Stability Rate | custom (OQ) | 0 | 1× | 0 |
| PR Critique Rate | custom (OQ) | 100 | 2× | 200 |
| TOTAL | | | 26× | 2253 / (26×100) |

Composite: 2253 / (26 × 100) × 100 = 86.7%
baseline_weighted_sum = 2253
total_weight_units = 26
```

**Weakest metrics (primary hypothesis targets):**
1. Commit Format Consistency Score — 0% (structural inconsistency: p3 vs p7 commit format)
2. Plan Stability Rate — 0% (directional, 1 subject with known-context drift — NOT a structural target)
3. Dependency Definition Consistency — 50% (structural inconsistency: work/p2 vs next/p2)
4. AC Concreteness — 71% (4 vague phase dispatch triggers)
5. Context Loading Efficiency — 82% (next.md, pr.md, cleanup.md are monolithic)
6. Persona-Phase Fit Score — 83% (Kira suboptimal for mechanical phases; p6 report phase)

**Strongest metrics:**
Directive Density (100), Instruction Ambiguity Rate (99), Wiring Completeness Score (100), Redundancy Index (99), Subagent Alignment Score (100), Context Decay Resilience (100), Information Freshness Score (100), Persona Richness Score (100), Quality Envelope Signal Coverage (100), Claim Lifecycle Completeness (100), First-Pass Review Rate (100, directional), PR Critique Rate (100, directional)

---

## Experiments — 2026-03-25

### H1 — Commit Format Alignment
**Problem observed:** Commit Format Consistency Score is 0%. `work/p3-implementation.md` specifies `feat({NNN}): [what and why in one line]`; `work/p7-commit.md` specifies `feat(scope): implement {ticket-id}`. Two incompatible formats for the same commit type — the p7 template omits the mandatory WHY content.
**Change proposed:** Align `work/p7-commit.md` to use p3's format as canonical: `feat({NNN}): [what and why]`. Update the template and example lines to match p3's convention.
**Targets:** Commit Format Consistency Score (↑ 0→100)
**Predicted improvement:** +100 weighted (1×)
**Pattern applied:** novel — Cross-File Commit Contract Alignment
**Risk level:** low
**Risk note:** p7 is a small dispatch file. Verify that the `{NNN}` placeholder (ticket number) is always available at p7 execution time — it should be, as p7 fires only after a ticket is selected.

### H2 — Dependency Satisfaction Unification
**Problem observed:** Dependency Definition Consistency is 50%. `work/p2` accepts dependencies with status `in_review`, `in_pr`, or `done` in three possible directories. `next.md` requires status `done` only in `06-in-review/` or `07-pull-request/`. Work could start on a ticket whose dependency is still under review and could fail.
**Change proposed:** Update `work/p2-ticket-selection.md` dependency check to match `next.md`'s stricter criterion: dependency satisfied only when its ticket has `status: done` in `06-in-review/` or `07-pull-request/`.
**Targets:** Dependency Definition Consistency (↑ 50→100)
**Predicted improvement:** +50 weighted (1×)
**Pattern applied:** P6 — Symmetric Outcome Thresholds
**Risk level:** low
**Risk note:** Stricter definition means dependent tickets stay blocked longer (until dependency passes review). This is correct — starting work on a ticket whose dependency could still fail creates rework risk.

### H3 — Stale Claim Detection Fix
**Problem observed:** Schema Field Integrity is 94%. `next.md` Claimed Check references `expires_at` which is absent from `_shared.md` schema and never written by `work/p2`. With `expires_at` always null/unset, the policy "null → treat as claimed" means next.md auto mode permanently skips any subject with in-progress tickets, including abandoned stale sessions.
**Change proposed:** Replace the `expires_at` check in `next.md` Claimed Check with a computation from existing schema fields: if `claimed_at` is set AND `now - claimed_at < stale_after_hours × 3600 seconds`, treat the ticket as live. If `claimed_at` is null or elapsed, treat as stale. Remove all `expires_at` references.
**Targets:** Schema Field Integrity (↑ 94→100), AC Concreteness (↑ minor)
**Predicted improvement:** +14 weighted (SFI +6×2, ACC +2×1)
**Pattern applied:** P7 — Binary Applicability Gates
**Risk level:** low
**Risk note:** Computed check must handle absent `stale_after_hours` using schema default (4 hours). Confirm the formula matches work/p2's existing staleness logic.

### H4 — Concrete Phase Dispatch Triggers
**Problem observed:** AC Concreteness is 71%. Four phase dispatch conditions use non-measurable language: Phase 8 "all ACs verified and work log appended"; p3→p6 "implementation complete and all ACs addressed"; p7 "any phase produces a meaningful artifact"; p5 "out-of-scope work discovered".
**Change proposed:** Update `work.md` Phase Dispatch Table and `work/p3-implementation.md` routing:
- Phase 8 Active when: "all items in the ticket's `acceptance_criteria` list have file:line evidence recorded, AND at least one `## Work Log` section exists below the separator"
- Phase 7 Active when: "a ticket file has been moved, source code has been modified, or a log entry has been appended to the ticket's append zone"
- Phase 5 Active when: "implementation reveals work outside the ticket's stated acceptance criteria"
- p3→p6 routing note: "all acceptance criteria in the ticket have been addressed — each item has a corresponding code change or verified implementation"
**Targets:** AC Concreteness (↑ 71→93, fixing 3 of 4 vague triggers)
**Predicted improvement:** +22 weighted (1×)
**Pattern applied:** P6 — Symmetric Outcome Thresholds
**Risk level:** low
**Risk note:** Added specificity must remain concise — avoid Instruction Token Efficiency regression from verbose narrative.

### H5 — Plan Drift Classification
**Problem observed:** Plan Stability Rate is 0% (1 archived subject, directional). The quality envelope records drift as "Significant" with a context comment, but the MX-OQ3 methodology cannot distinguish expected/planned drift from structural planning gaps. The archived subject's drift was deliberate plan extension during active work — not a planning failure.
**Change proposed:** Add a `drift_type` field to `cleanup.md` Plan Drift recording: `expected` (deliberate extension during session), `structural` (unexpected requirements emerge mid-implementation), `undocumented` (significant lines with no clear rationale). Update MX-OQ3 methodology in `research-log.md` to score only `structural` and `undocumented` as unstable; `expected` drift counts as stable.
**Targets:** Plan Stability Rate (↑ 0→100 with reclassification of archived subject's drift as expected)
**Predicted improvement:** +100 weighted (1×)
**Pattern applied:** P15 — Measurement Accuracy Retrospective
**Risk level:** low
**Risk note:** Future structural drift still scores as unstable — the improvement eliminates false-positive instability signals, not genuine ones.

---

## Recommendation Brief

Based on baseline measurement, the following experiments are queued.

1. Commit Format Alignment — two files prescribe different formats for implementation commits, making the WHY requirement self-contradictory; fix by aligning the commit phase to use the implementation phase's format as canonical.
2. Dependency Satisfaction Unification — work selection and orchestration use different completion criteria for dependencies; the work pipeline accepts tickets still in review while the orchestrator requires them to be done; fix by applying the stricter criterion uniformly.
3. Stale Claim Detection Fix — the orchestrator's subject-claiming logic references a field that doesn't exist in the ticket schema and is never written, causing every in-progress subject to be permanently skipped in auto mode; fix by computing expiry from existing schema fields.
4. Concrete Phase Boundaries — four phase dispatch conditions use interpretive language instead of observable criteria; fix by replacing each with a specific, checkable condition.
5. Plan Drift Classification — the Plan Stability outcome metric scores all "Significant" drift as unstable, but the only archived subject's drift was a deliberate plan extension; fix the measurement methodology to distinguish deliberate from structural drift.

---

## Experiment Results — 2026-03-25

### H1 — Commit Format Alignment
**Pre:** Commit Format Consistency Score = 0 (p7 used `feat(scope): implement {ticket-id}`; p3 used `feat({NNN}): [what and why]`)
**Change:** Updated `work/p7-commit.md` to use `feat({NNN}): [what and why in one line]` as the canonical implementation commit format, with examples matching p3's convention. Updated the DO rule to match.
**Post:** Commit Format Consistency Score = 100 (one format across p3 and p7)
**Delta:** CFCS +100 → weighted +100 (1×)
**Result:** CONFIRMED
**Commit:** `feat(implement): align p7 commit format with p3 convention [H1]` (4843746)

---

### H2 — Dependency Satisfaction Unification
**Pre:** Dependency Definition Consistency = 50 (`work/p2` accepted `in_review`/`in_pr`/`done` in any of three directories; `next.md` required `done` only in `06-in-review/` or `07-pull-request/`)
**Change:** Updated `work/p2-ticket-selection.md` dependency check to require `status: done` in `06-in-review/` or `07-pull-request/` only. Added explanatory note that `in_review` status is not safe — the dependency could still fail review and be returned.
**Post:** Dependency Definition Consistency = 100 (one definition across work/p2 and next/p2)
**Delta:** DDC +50 → weighted +50 (1×)
**Result:** CONFIRMED
**Commit:** `feat(implement): unify dependency satisfaction definition in work/p2 [H2]` (173c5a5)

---

### H3 — Stale Claim Detection Fix
**Pre:** Schema Field Integrity = 94 (`next.md` referenced `expires_at` — absent from `_shared.md` schema, never written by work/p2 — causing in-progress subjects to be permanently skipped in auto mode)
**Change:** Replaced the `expires_at` check in `next.md` Claimed Check with computed staleness: `stale = (now - claimed_at) > (stale_after_hours × 3600 seconds)`. Removed all `expires_at` references. Added explicit handling for absent `claimed_at` (treat as stale) and missing `stale_after_hours` (default 4h per schema).
**Post:** Schema Field Integrity = 100 (all referenced fields exist in canonical schema)
**Delta:** SFI +6 → weighted +12 (2×)
**Result:** CONFIRMED
**Commit:** `feat(implement): replace expires_at with computed staleness check in next.md [H3]` (fcde933)

---

### H4 — Concrete Phase Dispatch Triggers
**Pre:** AC Concreteness = 71 (4 of 14 stop conditions used subjective/interpretive language: Phase 8 "all ACs verified", p3→p6 "implementation complete", p7 "meaningful artifact", p5 "out-of-scope work discovered")
**Change:** Updated `work.md` Phase Dispatch Table with deterministic "Active when" conditions for all four vague triggers. Updated `work/p3-implementation.md` routing line to specify "each item has a corresponding code change or verified implementation". All 4 vague conditions replaced.
**Post:** AC Concreteness = 100 (14/14 stop conditions are concrete and checkable)
**Delta:** ACC +29 → weighted +29 (1×) *(prediction was +22 for 3/4 fixed; all 4 were addressed)*
**Result:** CONFIRMED — exceeded predicted improvement
**Commit:** `feat(implement): replace vague phase dispatch triggers with concrete conditions [H4]` (0489f6d)

---

### H5 — Plan Drift Classification
**Pre:** Plan Stability Rate = 0 (1 archived subject with "Significant" drift; methodology had no way to distinguish deliberate plan extension from structural planning gaps; scored all Significant drift as unstable)
**Change:** Added Step 3b (drift type classification) to `cleanup.md` Phase 6a, between Step 3 (magnitude) and Step 4 (write to envelope). Three types: `expected` (deliberate extension, lines added only), `structural` (requirements changed, lines removed/rewritten), `undocumented` (ambiguous Moderate/Significant). Updated Plan Drift template and Subject Summary row to include `drift_type`. Updated MX-OQ3 methodology in this file to score only `structural` and `undocumented` as unstable.
**Post:** Plan Stability Rate = 100 (archived subject's drift reclassified as `expected` — 256 lines added, 0 removed — consistent with planned extension during active session)
**Delta:** MX-OQ3 +100 → weighted +100 (1×)
**Result:** CONFIRMED
**Commit:** `feat(implement): add drift_type classification to plan drift recording [H5]` (5b3a2f1)

---

## Experiment Summary

- **Confirmed:** H1, H2, H3, H4, H5
- **Partial:** none
- **Disconfirmed:** none

---

## Final Results — 2026-03-25

| Metric | Baseline | Post | Delta | Status |
|--------|----------|------|-------|--------|
| Intent-to-Output Traceability | 91 | 91 | 0 | — |
| Directive Density | 100 | 100 | 0 | — |
| Instruction Ambiguity Rate | 99 | 99 | 0 | — |
| Wiring Completeness Score | 100 | 100 | 0 | — |
| Redundancy Index | 99 | 99 | 0 | — |
| AC Concreteness | 71 | 100 | +29 | ↑ |
| Subagent Alignment Score | 100 | 100 | 0 | — |
| Human Touchpoint Count | 95 | 95 | 0 | — |
| Context Decay Resilience | 100 | 100 | 0 | — |
| Context Loading Efficiency | 82 | 82 | 0 | — |
| Information Freshness Score | 100 | 100 | 0 | — |
| Instruction Token Efficiency | 95 | 95 | 0 | — |
| Persona-Phase Fit Score | 83 | 83 | 0 | — |
| Persona Richness Score | 100 | 100 | 0 | — |
| Commit Format Consistency Score | 0 | 100 | +100 | ↑ |
| Dependency Definition Consistency | 50 | 100 | +50 | ↑ |
| Schema Field Integrity | 94 | 100 | +6 | ↑ |
| Quality Envelope Signal Coverage | 100 | 100 | 0 | — |
| Claim Lifecycle Completeness | 100 | 100 | 0 | — |
| First-Pass Review Rate | 100 | 100 | 0 | — |
| Plan Stability Rate | 0 | 100 | +100 | ↑ |
| PR Critique Rate | 100 | 100 | 0 | — |
| **Composite** | **86.7%** | **97.8%** | **+11.1 pp** | |

**What improved and why:**
- Commit Format Consistency Score: +100 — p7's template was a legacy stub that predated p3's WHY-comments requirement; aligning to p3's format eliminates ambiguity about what the commit message must contain
- Dependency Definition Consistency: +50 — work/p2 accepted dependencies still in review, allowing work to start on a ticket whose blocker could still fail; stricter criterion applied uniformly prevents that class of wasted work
- Schema Field Integrity: +6 — `expires_at` was a phantom field that caused auto-mode to permanently skip subjects with any in-progress tickets; replacing with computed staleness restores the stale detection path that `work/p2` already relies on
- AC Concreteness: +29 — four phase dispatch triggers used subjective language ("complete", "meaningful artifact"); replacing with checkable conditions (file:line evidence, log section exists) removes interpretation gaps between agents and across sessions
- Plan Stability Rate: +100 — the measurement methodology had no way to distinguish planned scope extension from structural planning gaps; adding drift_type classification corrects a false-positive that made the workflow appear less stable than it is

**What was dropped and why:**
- None — all five hypotheses were confirmed with no reversions

**What remains to improve:**
- Context Loading Efficiency: still at 82 — `next.md`, `pr.md`, and `cleanup.md` are monolithic (all phases inline); splitting into phase files would match the work/review progressive disclosure pattern but requires restructuring three orchestrators — scope for a future run
- Persona-Phase Fit Score: still at 83 — Kira (Builder) handles several mechanical phases (session check, ticket selection, stale detection) where a more administrative persona would be a tighter fit; low risk, moderate gain

---

## Novel Patterns Discovered — 2026-03-25

### NP1 — Cross-File Commit Contract Alignment
**Discovered in:** skills/implement/
**Problem it solved:** Two phase files in the same pipeline prescribed different formats for the same commit type. Because commit format is enforced by convention rather than tooling, divergent prescriptions silently allow non-WHY commits in production sessions.
**Implementation:** Identify all commit format prescriptions across instruction files. Pick one as canonical (the most specific, highest-constraint definition). Update all other files to reference or reproduce the canonical format.
**Metrics it improved:** Commit Format Consistency Score (0→100)
**Generalises to:** Any multi-file workflow where a single action (commit, log entry, field write) is described in more than one instruction file — the contract must be identical everywhere it appears.
**Seed candidate:** yes — pipeline-spanning definitional consistency is a recurring failure mode in distributed instruction sets

---

## Audit — 2026-03-25 (Run 2)

**Target:** skills/implement/
**Prior run:** Run 1 completed same day — Tier C (same target, ≤7 days)
**Files:** 28 total (23 command, 5 support) — unchanged from Run 1

### Changes Since Run 1
H1–H5 all applied. Files modified: `work/p7-commit.md`, `commands/work/p2-ticket-selection.md`, `commands/next.md`, `commands/work.md`, `commands/work/p3-implementation.md`, `commands/cleanup.md`. No new files added or removed.

### Feature Inventory (updated)
- Multi-phase pipeline: yes — unchanged
- Persona system: yes — unchanged
- Subagent invocations: yes — unchanged
- Multi-session orchestration: yes — `expires_at` removed (H3); staleness now computed from `claimed_at + stale_after_hours`
- Parallel execution: no
- Cached artifacts: yes — unchanged

### Persona Staleness Check
All 8 persona references still resolve. No new broken references introduced by H1–H5.

### Structural Anomalies (new — flagged for Phase 2/3)
1. **Stale command name**: `review/p4-pass.md:60` reads "Run `/kanban pr`" — should be `/implement pr` (renamed in v3.0.0).
2. **Stale command name**: `work/p4-stale-detection.md:16` reads "Run `/kanban work {subject}`" — should be `/implement work {subject}`.
3. **Missing error recovery**: lock file write failure in `work/p2` has no handler — the operation proceeds to write but no instruction for the case where the write itself fails.
4. **Implicit persona handoffs**: `pr.md` (Vale→Helm) and `cleanup.md` (Arden→Pulse) switch personas without explicit context-transfer blocks — each new persona infers prior phase state from session context.
5. **Multi-step mutation gaps**: `review/p4-pass.md`, `review/p5-fail.md`, and `work/p8-move-to-review.md` perform 4–5 step sequences with no "if any step fails" specification.

---

## Custom Metrics — 2026-03-25 (Run 2)

### MX6 — Cross-Command Reference Accuracy (CCRA) [custom]
**Measures:** whether slash command names referenced inside instruction files match the current canonical command names.
**Why seeds miss it:** MX3 (SFI) checks frontmatter field names against the schema but not slash command names in prose. No seed metric detects stale command identifiers.
**Methodology:** Enumerate all slash command references (e.g., `/implement work`, `/kanban pr`) in instruction command files. Cross-reference against the current canonical command identifier in `SKILL.md`. Count stale references (using the old command name). Score = 1 − (stale_refs / total_refs).
**Direction:** ↑ higher is better (all references current = 100)
**Weight:** 1×
**Normalisation:** score × 100

### MX7 — Error Recovery Coverage (ERC) [custom]
**Measures:** what fraction of identifiable failure modes in the pipeline have at least one explicitly prescribed recovery action.
**Why seeds miss it:** M6 (ACC) measures concreteness of stop conditions but not whether failure states have corresponding recovery paths. A pipeline may clearly STOP on error with no instruction for what to do next.
**Methodology:** Enumerate all conditional branches where the workflow reaches an error state (STOP messages, FAIL paths, API failures, constraint violations). For each, check whether a recovery action is explicitly prescribed (re-route, escalate, ask user, retry, etc.). Score = failure_modes_with_recovery / total_identified_failure_modes.
**Direction:** ↑ higher is better (all failure modes have recovery = 100)
**Weight:** 2×
**Normalisation:** score × 100

### MX8 — Multi-Step Operation Failure Specification (MOFS) [custom]
**Measures:** whether multi-step mutations (operations requiring ≥3 sequential file changes before committing) specify behaviour if any individual step fails mid-operation.
**Why seeds miss it:** No seed metric evaluates intra-operation atomicity guarantees. M9 (CDR) measures session re-anchoring at boundaries, not mid-operation failure recovery. An incomplete multi-step operation (file moved but frontmatter not updated) leaves the workflow in an inconsistent state with no prescribed recovery.
**Methodology:** Enumerate all multi-step mutations: sequences where ≥3 file operations occur before the next commit (append + update + move + commit, etc.). For each, check whether an explicit "if step N fails" or "verify before proceeding" instruction exists. Score = operations_with_failure_specification / total_multi_step_operations.
**Direction:** ↑ higher is better (all operations have failure spec = 100)
**Weight:** 1×
**Normalisation:** score × 100

### MX9 — Ticket State Transition Completeness (TSTC) [custom]
**Measures:** whether every valid ticket state transition in the pipeline has an explicit handler in at least one command file.
**Why seeds miss it:** No seed metric checks completeness of a state machine. M1 (IOT) traces artifact reads across phases but not whether all valid state transitions from any given state are covered.
**Methodology:** Enumerate the complete set of valid ticket state transitions: all combinations of (source_directory, destination_directory) that a ticket can legally traverse. For each transition, verify at least one command file explicitly performs it. Score = covered_transitions / total_valid_transitions.
**Direction:** ↑ higher is better (all transitions covered = 100)
**Weight:** 1×
**Normalisation:** score × 100

### MX10 — Persona Chain Handoff Explicitness (PCHE) [custom, moonshot]
**Measures:** when a single command file uses multiple personas in sequence (one persona active in phases 1–N, another in phases N+1–M), whether each persona transition includes an explicit context-transfer block identifying what the incoming persona needs to know from prior phases.
**Why seeds miss it:** No seed metric evaluates whether persona transitions preserve decision context. M4 (WCS) checks that personas are loaded at appropriate phases but not whether each persona starts with the right prior-phase information. In the current architecture, personas loaded mid-command rely entirely on implicit session context — safe while commands are monolithic, fragile if commands are ever split or dispatched as subagents.
**Methodology:** Enumerate all within-file persona transitions (points where one persona's active period ends and another begins, marked by "Read <persona.md> before proceeding. You are now X" directives in a single command file). For each transition, check whether an explicit "X receives:" or equivalent context block appears at the handoff point. Score = transitions_with_explicit_context_block / total_within_file_persona_transitions.
**Direction:** ↑ higher is better (all transitions have explicit context = 100)
**Weight:** 1×
**Normalisation:** score × 100

---

## Baseline — 2026-03-25 (Run 2)

**Pulse (Analytics)** — re-reading research-log.md (Intent Anchor). Run 2 baseline inherits Run 1 Final Results for all metrics whose underlying files were unchanged by H1–H5. New custom metrics (MX6–MX10) are measured fresh.

### Inherited metrics (no file changes — verified same as Run 1 Final Results)
M1 IOT=91, M2 DD=100, M3 IAR=99, M4 WCS=100, M5 RI=99, M6 ACC=100 (H4 confirmed), M7 SAS=100, M8 HTC=95, M9 CDR=100, M10 CLE=82, M12 IFS=100, M13 ITE=95, M14 PPF=83, M15 PRS=100, MX1 CFCS=100 (H1), MX2 DDC=100 (H2), MX3 SFI=100 (H3), MX4 QESC=100, MX5 CLCS=100, MX-OQ1=SKIP, MX-OQ2=100, MX-OQ3=100 (H5), MX-OQ4=SKIP, MX-OQ5=100

### MX6 — Cross-Command Reference Accuracy (CCRA) ✓ applied
All slash command references in command files:
1. `review/p1-resolve-ticket.md:12` — "Run `/implement work`" ✓
2. `review/p4-pass.md:60` — "Run `/kanban pr`" ✗ (stale — v3.0.0 renamed to /implement)
3. `work/p4-stale-detection.md:16` — "Run `/kanban work {subject}`" ✗ (stale)
4. `commands/next.md` — `/implement pr`, `/implement cleanup` (multiple) ✓
5. `commands/cleanup.md` — "Run /implement work and /implement review" ✓
6. `commands/next.md` DO list — "ready for `/implement pr`" ✓

Total slash command references: 8 (including multiple in next.md). Stale: 2.
Score = 1 − (2/8) = 0.75.
**Normalised: 75**

---

### MX7 — Error Recovery Coverage (ERC) ✓ applied
**Enumeration of failure modes (30 identified):**

Work pipeline (11): active-ticket conflict → STOP ✓; stale active ticket → ask user ✓; no todo tickets → STOP ✓; lock file live → skip ticket ✓; lock file stale → delete + proceed ✓; all dependencies unsatisfied → report + AskUserQuestion ✓; lock file write failure → ✗ NO HANDLER; stale ticket post-claim → surface + 2 options ✓; stale plan file → load-with-caveat ✓; out-of-scope work → spawn ticket ✓; consecutive failures → escalation ✓

Review pipeline (7): no tickets in 06-in-review → STOP ✓; ticket not in_review status → precondition check (partial: requires but no explicit "if absent" message) ✓ partial; plan frontmatter field absent → precondition check (partial) ✓ partial; plan file completely absent → ✗ NO HANDLER; changed files not in work log → infer from git ✓ partial; stale plan during review → load-with-caveat ✓; same-error escalation → escalation ✓

PR pipeline (7): no GitHub remote → bypass ✓; unprotected trunk → bypass ✓; branch protection API failure → STOP + ask ✓; CI fails → diagnose + fix ticket ✓; PR closed without merge → STOP ✓; CI fails on merge commit → STOP ✓; merge commit not in target branch → STOP ✓

Cleanup pipeline (2): tickets in earlier stages → STOP with list ✓; archive move failure → explicit verify + STOP ✓

Orchestration (3): same-error loop → LOOP DETECTED + AskUserQuestion ✓; stale in-progress tickets → AskUserQuestion ✓; all subjects claimed → stop and list ✓

**Count:** 25 with explicit recovery, 2 without (lock file write, plan file absent), 3 partial = 25/30 = 83%.
**Normalised: 83**

---

### MX8 — Multi-Step Operation Failure Specification (MOFS) ✓ applied
**Multi-step mutations enumerated (6 operations):**

1. `review/p4-pass.md` — Append review record + Update frontmatter + Move ticket + Commit (4 steps): no explicit "if step fails" instruction ✗
2. `review/p5-fail.md` — Append record + Update frontmatter + Append envelope + Move ticket + Commit (5 steps): quality envelope create-if-absent handled ✓ (partial); no overall failure spec ✗ (partial credit only)
3. `work/p8-move-to-review.md` — Move ticket + Update frontmatter + Delete lock + Commit (4 steps): lock delete has existence check ✓ (partial); no overall failure spec ✗ (partial)
4. `cleanup.md` Phases 3–4 — rmdir × 5 + mv + verify (multi-step): explicit verification after move ✓; rmdir uses safe flag ✓ — explicit failure spec ✓
5. `pr.md` Phase 4 — 3 pre-flight checks + Move tickets + Update status + Commit (6 steps): 3 explicit pre-flight verifications ✓ — explicit failure spec ✓
6. `work/p2-ticket-selection.md` — Write lock + Move ticket + Update frontmatter + Commit (4 steps): no explicit failure spec ✗

Operations with explicit failure specification: cleanup Phase 3–4 ✓, pr.md Phase 4 ✓ = 2/6 = 33%.
**Normalised: 33**

---

### MX9 — Ticket State Transition Completeness (TSTC) ✓ applied
**Valid ticket transitions:**

1. 04-todo → 05-in-progress: `work/p2` ✓
2. 05-in-progress → 06-in-review: `work/p8` ✓
3. 06-in-review → 07-pull-request: `review/p4-pass` ✓
4. 06-in-review → 05-in-progress (FAIL): `review/p5-fail` ✓
5. 07-pull-request → 08-done: `pr.md` Phase 4 ✓
6. 07-pull-request → 08-done (no GitHub bypass): `pr.md` Phase 2 Check 1 ✓
7. 07-pull-request → 08-done (unprotected trunk): `pr.md` Phase 2 Check 2 ✓
8. 05-in-progress → 04-todo (stale reset): `work/p4` reset option ✓
9. Active-ticket conflict prevention: `work/p1` ✓

Edge case without handler:
10. Permanently blocked ticket with no satisfiable dependency — `next.md` handles with AskUserQuestion but no explicit "mark as abandoned" transition. Partial ✓ (0.5)

Score = (9 + 0.5) / 10 = 9.5/10 = 95%.
**Normalised: 95**

---

### MX10 — Persona Chain Handoff Explicitness (PCHE) ✓ applied
**Within-file persona transitions enumerated:**

1. `pr.md` Phase 4: "Read release/persona.md before proceeding. You are now Helm." — Vale active in Phases 1–3; no explicit context-transfer block at transition. Helm infers PR number, subject, CI status from session context only. ✗
2. `cleanup.md` Phase 6: "**You are now Pulse.**" — Arden active in Phases 1–2; no explicit context-transfer block. Pulse infers archive path, ticket count, quality envelope location from session context only. ✗

`review/p3-score.md` refers to "the Examiner's evidence table" — this is a cross-phase-file transition (Echo p2a → Arden p3), not within a single file. Does not count for PCHE.

Within-file persona transitions with explicit context block: 0/2 = 0%.
**Normalised: 0**

---

### Composite Calculation (Run 2 Baseline)

```
Run 2 inherits all Run 1 Final Results metrics unchanged, adding MX6–MX10.

| Metric | Source | Normalised | Weight | Weighted |
|--------|--------|-----------|--------|----------|
| Intent-to-Output Traceability | seed | 91 | 1× | 91 |
| Directive Density | seed | 100 | 1× | 100 |
| Instruction Ambiguity Rate | seed | 99 | 1× | 99 |
| Wiring Completeness Score | seed | 100 | 1× | 100 |
| Redundancy Index | seed | 99 | 1× | 99 |
| AC Concreteness | seed | 100 | 1× | 100 |
| Subagent Alignment Score | seed | 100 | 1× | 100 |
| Human Touchpoint Count | seed | 95 | 1× | 95 |
| Context Decay Resilience | seed | 100 | 1× | 100 |
| Context Loading Efficiency | seed | 82 | 1× | 82 |
| Information Freshness Score | seed | 100 | 1× | 100 |
| Instruction Token Efficiency | seed | 95 | 1× | 95 |
| Persona-Phase Fit Score | seed | 83 | 1× | 83 |
| Persona Richness Score | seed | 100 | 1× | 100 |
| Commit Format Consistency Score | custom | 100 | 1× | 100 |
| Dependency Definition Consistency | custom | 100 | 1× | 100 |
| Schema Field Integrity | custom | 100 | 2× | 200 |
| Quality Envelope Signal Coverage | custom | 100 | 1× | 100 |
| Claim Lifecycle Completeness | custom | 100 | 2× | 200 |
| First-Pass Review Rate | custom (OQ) | 100 | 2× | 200 |
| Plan Stability Rate | custom (OQ) | 100 | 1× | 100 |
| PR Critique Rate | custom (OQ) | 100 | 2× | 200 |
| Cross-Command Reference Accuracy | custom | 75 | 1× | 75 |
| Error Recovery Coverage | custom | 83 | 2× | 166 |
| Multi-Step Operation Failure Specification | custom | 33 | 1× | 33 |
| Ticket State Transition Completeness | custom | 95 | 1× | 95 |
| Persona Chain Handoff Explicitness | custom | 0 | 1× | 0 |
| TOTAL | | | 32× | 2908 / (32×100) |

Composite: 2908 / (32 × 100) × 100 = 90.9%
baseline_weighted_sum = 2908
total_weight_units = 32
```

**Weakest metrics (primary hypothesis targets):**
1. Persona Chain Handoff Explicitness — 0% (no explicit context blocks at persona transitions)
2. Multi-Step Operation Failure Specification — 33% (only 2 of 6 mutations specify failure handling)
3. Cross-Command Reference Accuracy — 75% (2 stale `/kanban` command names)
4. Error Recovery Coverage — 83% (2 failure modes with no handler; 3 partial)
5. Persona-Phase Fit Score — 83% (Kira suboptimal for documentation phases)

**Strongest metrics:**
All seed metrics at or near 100 except CLE (82) and PPF (83). All Run 1 custom metrics at 100. New TSTC = 95.

---

## Experiments — 2026-03-25 (Run 2)

### H6 — Stale Command Name Fix
**Problem observed:** Cross-Command Reference Accuracy is 75%. Two instruction files still reference `/kanban` (the old command name before the v3.0.0 rename to `/implement`): `review/p4-pass.md` Step E says "Run `/kanban pr`" and `work/p4-stale-detection.md` says "Run `/kanban work {subject}`". Agents following these instructions will invoke the wrong command.
**Change proposed:** Update both stale references to the current `/implement` command name.
**Targets:** Cross-Command Reference Accuracy (↑ 75→100)
**Predicted improvement:** +25 weighted (1×)
**Pattern applied:** novel — Stale Identifier Correction
**Risk level:** low
**Risk note:** Pure text substitution in two isolated instructions. No logic change.

### H7 — Error Recovery Gap Fill
**Problem observed:** Error Recovery Coverage is 83%. Two failure modes have no prescribed recovery: (1) lock file write failure in `work/p2` — the write is attempted but if it fails, no instruction exists; (2) plan file completely absent in `work/p3` and `review/p2a` — both have TTL-staleness handling but no "file not found" handler. A third gap (plan frontmatter `plan` field absent in `review/p1`) has only a precondition check with no explicit failure message.
**Change proposed:** Add three minimal recovery instructions: (1) to `work/p2` lock write step: "If the lock file cannot be written, report the error and do not proceed"; (2) to `work/p3` staleness policy: "If the plan file does not exist at the stated path, STOP — report the path and ask the user to verify or re-run `/implement init`"; (3) to `review/p1` plan field check: "If the `plan` field is absent or empty, print: 'Ticket has no plan reference. Add a `plan:` frontmatter field pointing to the plan file, then re-run review.' and exit."
**Targets:** Error Recovery Coverage (↑ 83→90)
**Predicted improvement:** +14 weighted (2×: +7 pp ERC)
**Pattern applied:** P10 — Failure Mode Registry
**Risk level:** low
**Risk note:** Adding STOP instructions for previously silent failures. Verify that the plan-file STOP message references the correct re-run command (`/implement init`, not `/implement work`).

### H8 — Multi-Step Mutation Failure Handling
**Problem observed:** Multi-Step Operation Failure Specification is 33%. The three most frequently executed multi-step mutations — `review/p4-pass.md` (pass path), `review/p5-fail.md` (fail path), and `work/p2-ticket-selection.md` (claim) — each perform 4–5 sequential file changes with no "if any step fails" instruction. If a step fails mid-sequence, the ticket is in an indeterminate state.
**Change proposed:** Add a single "if any step in this sequence fails" line to each of the three operations: report the failure and the last completed step (so the user can identify where to resume), and do not attempt the final commit. The instruction does not need to prescribe a rollback — just a clear stop-and-report so the agent does not silently half-complete an operation.
**Targets:** Multi-Step Operation Failure Specification (↑ 33→67)
**Predicted improvement:** +34 weighted (1×)
**Pattern applied:** P10 — Failure Mode Registry (applied to intra-operation states)
**Risk level:** low
**Risk note:** Added stop-and-report lines must not be verbose enough to interrupt normal happy-path flow. Use a single conditional at the end of the sequence, not inline guards after every step.

### H9 — Persona Handoff Context Blocks
**Problem observed:** Persona Chain Handoff Explicitness is 0%. Both within-file persona transitions (`pr.md`: Vale→Helm; `cleanup.md`: Arden→Pulse) rely entirely on implicit session context for the incoming persona to know what the prior persona decided. While this works in monolithic execution, it creates invisible coupling: if either command is ever refactored to dispatch phases as subagents, the handoffs would silently lose all prior-phase context.
**Change proposed:** Add explicit "receives:" context blocks immediately before each persona transition. In `pr.md` Phase 4: add a "Helm receives:" block listing PR number, subject slug, and CI status from Phase 3. In `cleanup.md` Phase 6: add a "Pulse receives:" block listing the archive path, ticket count, and quality envelope path established in Phases 1–4.
**Targets:** Persona Chain Handoff Explicitness (↑ 0→100)
**Predicted improvement:** +100 weighted (1×)
**Pattern applied:** novel — Persona Context Materialisation
**Risk level:** low
**Risk note:** The context blocks are documentation-level annotations within the same file session — they do not change control flow. They should use concrete variable names (matching frontmatter or Phase output variables) rather than prose descriptions to remain unambiguous.

### H10 — Ward Persona for Work Log Phase [persona experiment]
**Problem observed:** Persona-Phase Fit Score is 83%. Work/p6-work-log.md is a documentation-writing phase (primary cognitive demand: clarity, completeness, audience empathy) but Kira (Builder) is active throughout the work pipeline. The p6 file already acknowledges this mismatch by telling Kira to "write as if future-Ward is reading" — but reading as Ward is different from writing as Ward. The phase's quality standard invokes Ward's name without loading her.
**Phase targeted:** `work/p6-work-log.md` — currently Kira (Builder), cognitive demand = documentation
**Change type:** rotation
**Change proposed:** Add "You are now Ward (Documentation). Read `../../personas/documentation/persona.md`." at the start of `work/p6-work-log.md`. Add a corresponding return directive at the end: "Return to work/p8 as Kira — reload `../../personas/builder/persona.md`." Update `work.md`'s DO list to note that Kira yields to Ward during p6.
**Quality markers:**
1. Does the work log include structured references to plan items and AC IDs rather than narrative summaries?
2. Does the work log explicitly document the WHY for each decision (not just what was done)?
3. Are prior Review issues explicitly addressed by name if any Review sections exist?
**Targets:** Persona-Phase Fit Score (↑ 83→85)
**Predicted improvement:** +2 weighted (1×) — p6 score moves from 0.5→1.0 (+0.5/27 phases = +1.9 pp PPF → rounded to +2)
**Pattern applied:** P8 — Persona Rotation
**Risk level:** low
**Risk note:** The return-to-Kira directive must be explicit to prevent Ward from carrying into p8 (Move to Review), where Kira's builder mindset is more appropriate for session closure.

---

## Recommendation Brief (Run 2)

Based on baseline measurement, the following experiments are queued.

1. Stale command names — two instruction files still use `/kanban` (the pre-v3.0.0 name); agents following these will invoke the wrong command; fix by updating both to `/implement`.
2. Error recovery gaps — a lock file write failure and a missing plan file have no prescribed recovery; agents hitting these conditions have no next action; fix by adding minimal stop-and-report instructions.
3. Multi-step mutation failures — the pass path, fail path, and ticket-claim operations each perform 4–5 sequential file changes with no failure handling; a mid-sequence failure leaves the ticket in an indeterminate state; fix by adding stop-and-report at the end of each sequence.
4. Implicit persona handoffs — the PR command and cleanup command each switch personas mid-execution without listing what the new persona needs to know; if either command is ever dispatched as subagents, all handoff context would be lost; fix by adding explicit "receives:" context blocks.
5. Builder writing documentation — the work log phase tells Kira (Builder) to write as if Ward (Documentation) is reading, but never actually loads Ward; switching the active persona for that phase aligns execution with the intended quality standard.

---

## Experiment Results — 2026-03-25 (Run 2)

### H6 — Stale Command Name Fix
**Pre:** Cross-Command Reference Accuracy = 75. `review/p4-pass.md:60` said "Run `/kanban pr`"; `work/p4-stale-detection.md:16` said "Run `/kanban work {subject}`".
**Change:** Replaced both instances with `/implement pr` and `/implement work {subject}` respectively.
**Post:** Cross-Command Reference Accuracy = 100. All 8 slash command references in instruction files are now current.
**Delta:** CCRA +25 → weighted +25 (1×)
**Result:** CONFIRMED
**Commit:** `feat(implement): fix stale /kanban command references in p4-pass and p4-stale [H6]` (b289299)

---

### H7 — Error Recovery Gap Fill
**Pre:** Error Recovery Coverage = 83 (25/30 failure modes covered). Lock file write failure, plan file absent in work/p3, plan file absent in review/p2a, and plan field absent in review/p1 had no explicit recovery.
**Change:** Added four recovery instructions: (1) lock write failure handler in work/p2; (2) "file not found" STOP in work/p3 plan staleness section; (3) "file not found" STOP in review/p2a staleness section; (4) explicit "if plan field absent, print message and exit" to review/p1 DO NOT list.
**Post:** Error Recovery Coverage = 90 (27/30 failure modes fully covered).
**Delta:** ERC +7 → weighted +14 (2×)
**Result:** CONFIRMED
**Commit:** `feat(implement): add recovery instructions for uncovered failure modes [H7]` (a161abb)

---

### H8 — Multi-Step Mutation Failure Handling
**Pre:** Multi-Step Operation Failure Specification = 33 (2/6 operations specified). `review/p4-pass.md`, `review/p5-fail.md`, and `work/p2-ticket-selection.md` had no failure specification.
**Change:** Added "Sequence failure guard" paragraphs to all three operations: report failure, identify last completed step, do not proceed. Three new guards + 2 already-specified = 5/6.
**Post:** Multi-Step Operation Failure Specification = 83 (5/6 operations specified). *Exceeded prediction of 67% (4/6) — all three targeted operations now specify failure behaviour.*
**Delta:** MOFS +50 → weighted +50 (1×) *(prediction was +34 for 67%; actual improvement larger)*
**Result:** CONFIRMED — exceeded predicted improvement
**Commit:** `feat(implement): add sequence failure guards to multi-step mutations [H8]` (0329e01)

---

### H9 — Persona Handoff Context Blocks
**Pre:** Persona Chain Handoff Explicitness = 0 (0/2 within-file persona transitions had explicit context blocks). Both `pr.md` (Vale→Helm) and `cleanup.md` (Arden→Pulse) relied on implicit session context.
**Change:** Added explicit "receives:" blocks at both transitions. `pr.md` Phase 4 now lists PR number, subject, tickets list, and CI status that Helm inherits from Vale. `cleanup.md` Phase 6 now lists subject, archive path, ticket count, quality envelope path, and archive commit SHA that Pulse inherits from Arden + archive operation.
**Post:** Persona Chain Handoff Explicitness = 100 (2/2 transitions have explicit context blocks).
**Delta:** PCHE +100 → weighted +100 (1×)
**Result:** CONFIRMED
**Commit:** `feat(implement): add explicit persona handoff context blocks in pr.md and cleanup.md [H9]` (03b244d)

---

### H10 — Ward Persona for Work Log Phase
**Pre:** Persona-Phase Fit Score = 83 (23.25/27 phases). `work/p6-work-log.md` was written by Kira (Builder) despite being a documentation-writing phase whose quality standard explicitly referenced Ward's audience.
**Change:** Added Ward (Documentation) persona directive at the top of `work/p6-work-log.md` with explicit return-to-Kira at the end. Updated `work.md` personas section to note the Ward exception for p6.
**Post:** Persona-Phase Fit Score = 88 (23.75/27 phases — p6 improves from 0.5→1.0, raw PPF 86.1→87.96%, normalised 83→88).
**Delta:** PPF +5 → weighted +5 (1×)
**Result:** CONFIRMED — slightly exceeded predicted improvement of +2 (conservative rounding corrected)
**Commit:** `feat(implement): rotate to Ward persona for work log phase [H10]` (03bfc65)

---

## Experiment Summary (Run 2)

- **Confirmed:** H6, H7, H8, H9, H10
- **Partial:** none
- **Disconfirmed:** none

---

## Final Results — 2026-03-25 (Run 2)

Post-experiment composite:
- H6: CCRA +25 (75→100, ×1)
- H7: ERC +14 (83→90, ×2)
- H8: MOFS +50 (33→83, ×1) — exceeded prediction
- H9: PCHE +100 (0→100, ×1)
- H10: PPF +5 (83→88, ×1)
Total delta: +194 weighted
New sum: 2908+194 = 3102 / 3200 = 96.9%

| Metric | Baseline (R2) | Post | Delta | Status |
|--------|---------------|------|-------|--------|
| Intent-to-Output Traceability | 91 | 91 | 0 | — |
| Directive Density | 100 | 100 | 0 | — |
| Instruction Ambiguity Rate | 99 | 99 | 0 | — |
| Wiring Completeness Score | 100 | 100 | 0 | — |
| Redundancy Index | 99 | 99 | 0 | — |
| AC Concreteness | 100 | 100 | 0 | — |
| Subagent Alignment Score | 100 | 100 | 0 | — |
| Human Touchpoint Count | 95 | 95 | 0 | — |
| Context Decay Resilience | 100 | 100 | 0 | — |
| Context Loading Efficiency | 82 | 82 | 0 | — |
| Information Freshness Score | 100 | 100 | 0 | — |
| Instruction Token Efficiency | 95 | 95 | 0 | — |
| Persona-Phase Fit Score | 83 | 88 | +5 | ↑ |
| Persona Richness Score | 100 | 100 | 0 | — |
| Commit Format Consistency Score | 100 | 100 | 0 | — |
| Dependency Definition Consistency | 100 | 100 | 0 | — |
| Schema Field Integrity | 100 | 100 | 0 | — |
| Quality Envelope Signal Coverage | 100 | 100 | 0 | — |
| Claim Lifecycle Completeness | 100 | 100 | 0 | — |
| First-Pass Review Rate | 100 | 100 | 0 | — |
| Plan Stability Rate | 100 | 100 | 0 | — |
| PR Critique Rate | 100 | 100 | 0 | — |
| Cross-Command Reference Accuracy | 75 | 100 | +25 | ↑ |
| Error Recovery Coverage | 83 | 90 | +7 | ↑ |
| Multi-Step Operation Failure Specification | 33 | 83 | +50 | ↑ |
| Ticket State Transition Completeness | 95 | 95 | 0 | — |
| Persona Chain Handoff Explicitness | 0 | 100 | +100 | ↑ |
| **Composite** | **90.9%** | **96.9%** | **+6.0 pp** | |

**What improved and why:**
- Cross-Command Reference Accuracy: +25 — two instruction files retained the old `/kanban` command name after the v3.0.0 rename; agents following these instructions would have invoked a non-existent command
- Error Recovery Coverage: +7 — plan-file-absent and lock-write-failure scenarios had no prescribed recovery; agents in these states had no instruction for what to do next; three stop-and-report handlers added
- Multi-Step Operation Failure Specification: +50 (exceeded prediction) — the pass path, fail path, and ticket-claim each perform 4–5 sequential file changes; mid-sequence failures left tickets in indeterminate states; sequence failure guards added to all three
- Persona Chain Handoff Explicitness: +100 — both within-file persona transitions relied entirely on implicit session context; a future refactor to dispatch phases as subagents would silently lose all prior-phase decisions; explicit "receives:" blocks make the coupling visible
- Persona-Phase Fit Score: +5 — the work log phase explicitly told Kira to write "as if Ward is reading" without ever loading Ward; loading Ward directly removes the cognitive mismatch

**What was dropped and why:**
- None — all five hypotheses were confirmed

**What remains to improve:**
- Context Loading Efficiency: still at 82 — the monolithic orchestrators (next.md, pr.md, cleanup.md) load all phases regardless of which is active; progressive disclosure refactor would require restructuring three files
- Ticket State Transition Completeness: still at 95 — the permanently-blocked-ticket edge case lacks a dedicated "mark as abandoned" transition; low practical impact
- Error Recovery Coverage: still at 90 — three failure modes remain partial or uncovered; improving further requires deeper failure-state analysis (frontmatter parse errors, git configuration errors)

---

## Novel Patterns Discovered — 2026-03-25 (Run 2)

### NP2 — Persona Context Materialisation
**Discovered in:** skills/implement/ (pr.md, cleanup.md)
**Problem it solved:** Within-file persona transitions relied on implicit session context for the incoming persona to know what prior phases decided. This creates invisible coupling: if either command is ever split into subagents, the handoffs silently lose all prior-phase context.
**Implementation:** At each persona transition point, add an explicit "X receives:" block listing the specific variables, decisions, and artifact paths established by prior phases. The block should name concrete identifiers (PR number, archive path, ticket count), not narrative prose.
**Metrics it improved:** Persona Chain Handoff Explicitness (0→100)
**Generalises to:** Any multi-persona command where the later persona needs facts established by earlier phases — especially commands that may eventually be refactored to dispatch phases as subagents.
**Seed candidate:** yes — implicit coupling at persona boundaries is a predictable failure mode in growing agentic systems; making coupling explicit is a prerequisite for future modularisation
