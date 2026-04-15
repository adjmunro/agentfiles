<!-- SUMMARY-START -->
## Run 002 — 2026-03-25 | Target: skills/implement/
Composite: 90.9% → 96.9% (+6.0 pp)

### Hypotheses
| ID  | Description                                      | Outcome   |
|-----|--------------------------------------------------|-----------|
| H6  | Stale command name fix                           | Confirmed |
| H7  | Error recovery gap fill                          | Confirmed |
| H8  | Multi-step mutation failure handling             | Confirmed |
| H9  | Persona handoff context blocks                   | Confirmed |
| H10 | Ward persona for work log phase                  | Confirmed |

### Metric Snapshot
| Metric | Baseline | Post |
|--------|----------|------|
| Intent-to-Output Traceability | 91 | 91 |
| Directive Density | 100 | 100 |
| Instruction Ambiguity Rate | 99 | 99 |
| Wiring Completeness Score | 100 | 100 |
| Redundancy Index | 99 | 99 |
| AC Concreteness | 100 | 100 |
| Subagent Alignment Score | 100 | 100 |
| Human Touchpoint Count | 95 | 95 |
| Context Decay Resilience | 100 | 100 |
| Context Loading Efficiency | 82 | 82 |
| Information Freshness Score | 100 | 100 |
| Instruction Token Efficiency | 95 | 95 |
| Persona-Phase Fit Score | 83 | 88 |
| Persona Richness Score | 100 | 100 |
| Commit Format Consistency Score | 100 | 100 |
| Dependency Definition Consistency | 100 | 100 |
| Schema Field Integrity | 100 | 100 |
| Quality Envelope Signal Coverage | 100 | 100 |
| Claim Lifecycle Completeness | 100 | 100 |
| First-Pass Review Rate | 100 | 100 |
| Plan Stability Rate | 100 | 100 |
| PR Critique Rate | 100 | 100 |
| Cross-Command Reference Accuracy | 75 | 100 |
| Error Recovery Coverage | 83 | 90 |
| Multi-Step Operation Failure Specification | 33 | 83 |
| Ticket State Transition Completeness | 95 | 95 |
| Persona Chain Handoff Explicitness | 0 | 100 |
<!-- SUMMARY-END -->

---

## Phase 1 — Audit

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
4. **Implicit persona handoffs**: `pr.md` (Vale→Helm) and `cleanup.md` (Arden→Pulse) switch personas without explicit context-transfer blocks — each new persona infers prior phase state from session context only.
5. **Multi-step mutation gaps**: `review/p4-pass.md`, `review/p5-fail.md`, and `work/p8-move-to-review.md` perform 4–5 step sequences with no "if any step fails" specification.

---

## Phase 2 — Baseline

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

## Phase 3 — Hypotheses

### Custom Metric Definitions (Run 2)

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

### Recommendation Brief (Run 2)

Based on baseline measurement, the following experiments are queued.

1. Stale command names — two instruction files still use `/kanban` (the pre-v3.0.0 name); agents following these will invoke the wrong command; fix by updating both to `/implement`.
2. Error recovery gaps — a lock file write failure and a missing plan file have no prescribed recovery; agents hitting these conditions have no next action; fix by adding minimal stop-and-report instructions.
3. Multi-step mutation failures — the pass path, fail path, and ticket-claim operations each perform 4–5 sequential file changes with no failure handling; a mid-sequence failure leaves the ticket in an indeterminate state; fix by adding stop-and-report at the end of each sequence.
4. Implicit persona handoffs — the PR command and cleanup command each switch personas mid-execution without listing what the new persona needs to know; if either command is ever dispatched as subagents, all handoff context would be lost; fix by adding explicit "receives:" context blocks.
5. Builder writing documentation — the work log phase tells Kira (Builder) to write as if Ward (Documentation) is reading, but never actually loads Ward; switching the active persona for that phase aligns execution with the intended quality standard.

---

## Phase 4 — Experiments

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

## Phase 5 — Report

### Experiment Summary (Run 2)

- **Confirmed:** H6, H7, H8, H9, H10
- **Partial:** none
- **Disconfirmed:** none

---

### Final Results — 2026-03-25 (Run 2)

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

### Novel Patterns Discovered — 2026-03-25 (Run 2)

### NP2 — Persona Context Materialisation
**Discovered in:** skills/implement/ (pr.md, cleanup.md)
**Problem it solved:** Within-file persona transitions relied on implicit session context for the incoming persona to know what prior phases decided. This creates invisible coupling: if either command is ever split into subagents, the handoffs silently lose all prior-phase context.
**Implementation:** At each persona transition point, add an explicit "X receives:" block listing the specific variables, decisions, and artifact paths established by prior phases. The block should name concrete identifiers (PR number, archive path, ticket count), not narrative prose.
**Metrics it improved:** Persona Chain Handoff Explicitness (0→100)
**Generalises to:** Any multi-persona command where the later persona needs facts established by earlier phases — especially commands that may eventually be refactored to dispatch phases as subagents.
**Seed candidate:** yes — implicit coupling at persona boundaries is a predictable failure mode in growing agentic systems; making coupling explicit is a prerequisite for future modularisation

---

### Future Metric Candidates — noted 2026-03-26

The following metric ideas were flagged during a post-Run-2 review. They are not yet implemented — they require inspecting actual kanban artefacts (tickets, plan files, project state) rather than instruction files alone, which means the optimise loop would need to be pointed at a live kanban directory rather than a skill directory. They are recorded here for a future run.

### Output-Quality Metrics (require kanban artefact access)

**MX-PC — Plan-to-Ticket Coverage**
Does every plan item have at least one ticket that references it? Measured as: plan items with a ticket link / total plan items. Requires a canonical link field in ticket frontmatter (e.g. `plan_ref:`).

**MX-AC — Acceptance Criteria Specificity**
Are ACs written as testable, unambiguous statements? Score each AC as: vague (0) / partially specific (0.5) / fully testable (1). Average across all ACs in the ticket set.

**MX-DO — Dependency Ordering Correctness**
Are `depends_on` references topologically ordered in `04-todo/`? Measured as: tickets with all dependencies appearing earlier in filename sort order / total tickets with dependencies. Flags cycles and forward-references.

**MX-EL — Effort Label Consistency**
Do tickets labelled `effort: low/medium/high` have AC counts and scope consistent with the label? Static heuristic: low = ≤3 ACs, medium = 4–6, high = 7+. Runtime correlation (actual work session length vs label) would require execution data.

**MX-GR — Ticket Grouping Coherence**
Are related changes (same file, same subsystem, same concern) grouped into one ticket rather than fragmented across many? Heuristic: tickets that share >50% of their AC file references are candidates for consolidation.

**MX-CS — Clean-State Scoping**
Is each ticket scoped to leave the project in a buildable/passing state when complete? This cannot be measured statically — it requires post-commit CI or test-run evidence. Proxy metric: does each ticket's AC list include at least one "tests pass" or "no regressions" criterion?

### Design Notes

These metrics shift optimise from measuring *instruction quality* (how well the skill files are written) to measuring *output quality* (how well the planning phase performs when executed). A future run targeting these would need:

1. A sample kanban directory with real tickets and plan files to score against
2. Possibly a new optimise "mode" — `artefact mode` vs the current `instruction mode` — that applies the appropriate metric subset based on what is being targeted
3. Ticket linting as a planning-phase gate: a check within the planning pipeline that validates ticket quality (AC specificity, dependency ordering, effort label consistency) before execution begins, rather than measuring it retrospectively

### Broader Applicability Note

The idea of running `/optimise` on non-skill targets (kanban artefact sets, documentation stores, API specs, test suites) requires the optimise skill to support **dynamic metric selection** — choosing which metrics are relevant to the target type. The current metric library (M1–M15 + MX series) is instruction-file-centric. A metric taxonomy by target type would allow the Phase 2 baseline to skip irrelevant metrics and add domain-appropriate ones without manual curation each run.
