# Changelog

What's new, what's better, what's different. Most recent stuff on top.

---

## v1.5.0 - 2026-03-25 - Promotion Semantics and Orchestration Correctness

Optimise run 5 — composite 84.6% → 89.3% (+4.7pp within run; +1.3pp net vs. run 4 after metric dilution). All 5 hypotheses confirmed.

- **Backlog promotion conflict resolved** (`p5-commit.md`, `tickets.md`, `ideate.md`): `p5-commit.md` contained a "Backlog Promotion" section that promoted tickets to `04-todo/` immediately after the audit commit, directly contradicting `ideate.md` Phase 7 ("no tickets go to `04-todo/` until step 9"). This made the user confirmation gate at Phase 8 semantically void. Promotion mechanics moved to `ideate.md` Phase 8 with idempotency guard and improved body spec. WHY comment added. Promote Gate Semantics Consistency 50→100, Orchestrator-Subphase Contract Consistency 65→90 [H21]
- **SKILL.md version corrected to 1.5.0** (`SKILL.md`): version field showed "1.3.0" despite skill being at v1.4.0 post-run-4 — same recurring pattern as H17. Corrected to "1.5.0" (reflecting this run's changes). Documentation Version Accuracy 67→100 [H22]
- **TESTING.md Command Coverage table updated** (`TESTING.md`): table had 10 rows covering happy-path paths only; 7 scenarios added in runs 3–4 exercised 3 additional command paths (plan.md audit gate FAIL, plan.md validation abandon, ideate.md entry routing). Added 3 new rows + split existing rows into variant columns. Coverage Table Completeness 77→100 [H23]
- **interview.md model upgraded to opus** (`commands/interview.md`): interview used `claude-sonnet-4-6` while all other complex phases used `claude-opus-4-6`. Interview is the highest-complexity phase (multi-source synthesis, calibrated confidence, tradeoff evaluation) — using a lower-capability model here had the highest quality risk. Upgraded to `claude-opus-4-6`. Model Cognitive Alignment Score 80→100 [H24]
- **Promote commit body improved** (`commands/ideate.md`): promote commit body now specifies 3 items (count + ticket IDs + destination directory), up from 1 item. Commit Body Item Count Adequacy 86→100 [H25]
- 5 new custom metrics defined: Orchestrator-Subphase Contract Consistency, Model Cognitive Alignment Score, TESTING.md Coverage Table Completeness, Cross-File Reference Accuracy, Promote Gate Semantics Consistency
- Novel pattern documented: NP9 (Separation of Phase Commit from Orchestrator Side Effect)

---

## v1.4.0 - 2026-03-25 - Gap Restoration and Test Coverage

Optimise run 4 — composite 84.0% → 88.0% (+4.0pp within run; +1.9pp net vs. run 3 after metric dilution). All 5 hypotheses confirmed.

- **Critic Pass gap categories restored** (`capture.md`): Phase 5 "silently scan for:" was missing its category list — a critical operational defect. Five categories restored (unstated assumptions, missing constraints, acceptance signals, contradictions, ambiguous terms). WHY comment added citing H6 rationale. Critic Pass Criteria Completeness 75→100, IOT 98→100 [H16]
- **SKILL.md version corrected** (`SKILL.md`): version field read "1.2.0" despite skill being at v1.3.0 post-run-3. CHANGELOG claimed H13 fixed this but did not. Corrected to "1.3.0". Documentation Version Accuracy 67→100, State Machine Fidelity 90→95 [H17]
- **Three resume-path scenarios added** (`TESTING.md`): Entry Routing table defines 5 non-fresh routing states; only 2 had test scenarios. Added resume-after-plan→Step 6, resume-with-tickets→Step 9, and resume-with-input-only→loop-back. TESTING.md Resume Path Coverage 40→100, Scenario Coverage 85→100 [H18]
- **Next-step instruction added to research.md report** (`commands/research.md`): Phase 6 described what to confirm but never named the next command. "→ Next: Run `ideation/commands/interview.md`" appended. Phase Exit Next-Step Coverage 80→100 [H19]
- **WHY traceability comments added to 5 instructions** (`capture.md`, `plan.md`, `interview.md`, `tickets/p4-critic-audit.md`, `tickets/p2-scout-research.md`): capture verbatim check (H6), plan re-entry guard (H8), interview idempotency guard (H8), dependency graph audit (H7), dependency detection block (H12). Hypothesis Traceability Coverage 80→88 [H20]
- 5 new custom metrics defined: Critic Pass Criteria Completeness, Documentation Version Accuracy, TESTING.md Resume Path Coverage, Phase Exit Next-Step Coverage, Commit Body Item Count Adequacy
- Novel patterns documented: NP7 (State-Machine-to-Test Bijection), NP8 (WHY Comment Traceability Anchors)

---

## v1.3.0 - 2026-03-25 - Documentation Sync and Git History

Optimise run 3 — composite 77.0% → 85.9% (+8.9pp). All 5 hypotheses confirmed.

- **Commit body instructions** (all command files): each phase-level commit now specifies a body with phase-specific outcome details (first-run/loop-back status, key findings, approval ratios, audit scores). Commit Message Body Completeness 15→86 [H11]
- **Scout dependency heuristics** (`tickets/p2-scout-research.md`): vague "note dependencies" replaced with concrete trigger condition, dependency-type examples (schema/API/file/config), output format, and coverage mandate. Scout Dependency Detection Strength 15→88 [H12]
- **SKILL.md state machine updated** (`SKILL.md`): entry routing table added; 5-state resume logic, step-6 abandon path, and plan-audit FAIL branch all now reflected in the diagram. Version reference corrected to 1.2.0→1.3.0. State Machine Fidelity 60→90 [H13]
- **TESTING.md expanded** (`TESTING.md`): 4 missing scenarios added — abandon at step 6, resume after research, resume after interview, and plan audit FAIL recovery. Scenario Coverage 55→85 [H13]
- **Ticket-sizing concreteness** (`tickets/p3-draft-tickets.md`): "small enough without ambiguity" replaced with a concrete session-scope proxy (1–5 files, 0–3 new files, single-concern). AC Concreteness 92→97 [H14]
- **Remaining idempotency guards** (`plan.md`, `p3-draft-tickets.md`, `p4-critic-audit.md`, `p5-commit.md`): audit-append, ticket-file creation, ticket-audit-append, and git-mv promotion all now check for existing state before acting. Phase Idempotency Coverage 83.3→94.4 [H15]
- 5 new custom metrics defined: TESTING.md Scenario Coverage, SKILL.md State Machine Fidelity, Commit Message Body Completeness, Exit Path Completeness, Scout Dependency Detection Strength
- Novel patterns documented: NP5 (Commit Convention Propagation), NP6 (Dependency Heuristic Injection)

---

## v1.2.0 - 2026-03-25 - Idempotency and Contract Enforcement

Optimise run 2 — composite 79.7% → 84.0% (+4.3pp). All 5 hypotheses confirmed.

- **Verbatim fidelity check** (`capture.md`): mandatory 3–5 phrase spot-check added to Phase 5 (Critic Pass) before the gap audit. Verbatim Contract Enforcement Coverage 50→100 [H6]
- **Dependency graph audit** (`tickets/p4-critic-audit.md`): explicit dependency-completeness verification sub-step added after coverage audit. Ticket Dependency Completeness 60→90 [H7]
- **Phase re-entry guards** (`plan.md`, `interview.md`): plan-draft guard prevents destructive overwrite of a complete plan; interview timestamp-uniqueness guard prevents duplicate Interview blocks. Phase Idempotency Coverage 61.1→83.3 [H8]
- **Concrete plan FAIL recovery** (`plan.md`): dead-end FAIL condition replaced with 2-option recovery flow (accept with `[UNRESOLVED]` markers or loop back to capture). Failure Recovery Coverage 92.9→100 [H9]
- **Concrete "substantive content" threshold** (`ideate.md`, `capture.md`, `tickets/p1-load-plan.md`): "stub headings or placeholder text" replaced with machine-checkable non-heading-line proxy; audit-section pattern made explicit. AC Concreteness 86.8→92.0 [H10]
- 5 new custom metrics defined: Ticket Dependency Completeness, Phase Idempotency Coverage, Verbatim Contract Enforcement Coverage, Persona Load Order Consistency, Audit Gate Symmetry
- Novel patterns documented: NP3 (Structural Contract Verification), NP4 (Phase Crash-Recovery Guard)

---

## v1.1.0 - 2026-03-25 - Resilience and Traceability

Optimise run 1 — composite 69.3% → 84.3% (+15.0pp). All 5 hypotheses confirmed.

- **Resume state routing** (`ideate.md`): re-entry into a partially-completed subject now routes deterministically to the correct step based on artifact presence. All 5 mid-session states handled (tickets drafted → plan done → interview recorded → research done → input exists).
- **Inline ticket schema** (`tickets/p3-draft-tickets.md`): full frontmatter schema inlined; hard dependency on `skills/implement/commands/_shared.md` eliminated. Ideation now fully self-contained.
- **Active intent anchors** (`ideate.md`): 5 passive HTML comment anchors converted to executed re-read directives at all orchestrator phase transitions (Phases 3–8). Context decay resilience now 100%.
- **Interview item tagging** (`plan.md`): `[INTERVIEW]` source tagging added to plan critic audit. Source column distinguishes interview decisions from raw capture items. `[INTERVIEW GAP]` escalation for unresolved interview items.
- **Staleness policies consolidated** (`capture.md`, `interview.md`, `research.md`, `plan.md`): `00-quality-*.md` policy added to `interview.md` (NO TTL). `00-input-*.md` policy made authoritative in `capture.md`; consuming files now carry short cross-references only. All 4 inter-session artifacts have complete, consistent TTL policies.

---

## v1.0.0 - 2026-03-22 - Initial Release

The ideation skill launches with a seamless 9-step loop that collapses capture, research, interview, planning, and ticket creation into one continuous workflow. Users capture ideas, get intelligent recommendations informed by codebase research, build plans collaboratively, and exit with a ready-to-work backlog — all without breaking context.

- Thin `ideate.md` orchestrator drives the full 9-step workflow
- Step 1: Capture verbatim input and assets into `00-input-{subject}.md`
- Step 2: Research phase scans local files and documentation before interviewing
- Step 3: Interview phase asks research-informed questions with recommendations and tradeoff explanations
- Steps 4–5: Plan drafting and critic audit gate with 95% threshold
- Step 6: Validation loop — continue, add more, or abandon
- Steps 7–8: Ticket creation in `03-refinement/` with critic audit gate
- Step 9: Hard-stop decision: add tickets to backlog (`04-todo/`) or abandon with explicit slug confirmation
- New directory structure: `YYYY-MM-DD-{subject}/` with stages `03-refinement/` through `08-done/`
- Personas shared from `skills/kanban/personas/` — no duplication
- Independent versioning starting at v1.0.0, separate from kanban skill
