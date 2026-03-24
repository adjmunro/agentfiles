# Changelog

What's new, what's better, what's different. Most recent stuff on top.

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
