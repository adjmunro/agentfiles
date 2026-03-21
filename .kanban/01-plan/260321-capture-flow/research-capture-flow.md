## Research: 260321-capture-flow
**Date**: 2026-03-21T00:00:00Z
**Status**: Snapshot — may go stale. Verify before acting.

## Project Structure

Relevant files for this change:

- `skills/kanban/commands/capture.md` — 9 phases; Phase 4 is the sole target
- `skills/kanban/commands/plan.md` — Phase 3 interview (distinct; must not be touched)
- `skills/kanban/commands/interview.md` — referenced model: reads file first, then asks pointed questions
- `skills/kanban/personas/scribe.md` — Vela, primary in capture Phases 4–8
- `skills/kanban/personas/critic.md` — Arden, challenger in capture Phase 6
- `skills/kanban/VERSION.md` — current: 1.1.0
- `skills/kanban/CHANGELOG.md` — newest-first format

## Relevant Patterns

- **Command structure**: YAML frontmatter → Personas → DO/DO NOT → numbered phases with hard STOP conditions
- **Interview pattern** (plan Phase 3, interview.md): read input first, derive questions from gaps, ask one at a time sequentially
- **Scribe rules**: ask one question at a time; transcribe verbatim; never batch questions
- **Preamble**: no precedent in existing commands — this is a new pattern; must be natural prose in agent's own voice, not labeled sections
- **Phase 4 currently**: opens with `AskUserQuestion` multi-choice before user writes anything; question categories (impl choices, tradeoffs, edge cases, constraints, acceptance signals) remain unchanged

## Dependencies

- `plan.md` Phase 2 reads the output of capture (`input-*.md`). Transcription format (Phase 5) must not change.
- `scribe.md` and `critic.md` reference `capture.md` phases — no edits needed to persona files.
- No other command depends on Phase 4's interview behaviour. All downstream commands consume the output file only.
- Phase 6 (Critic gap-scan) follows Phase 4 and must not re-ask what Phase 4 already covered — both gates serve different purposes.

## Hazards

- **Accidental format change**: Phase 4 asks questions; Phase 5 transcribes answers verbatim. Rework must touch only timing and framing of questions — transcription format is load-bearing downstream.
- **Scope creep**: plan.md Phase 3 is a separate interview gate. Requirement 4.2 is explicit: do not touch it.
- **Preamble ≠ Vela**: The preamble is agent analysis; the question is Vela speaking. Voice must stay consistent — preamble flows into question, but they are distinct.
- **Phase 6 duplication**: Critic in Phase 6 gap-hunts after all Phase 4 questions are done. The rework must not accidentally make Phase 6 redundant or re-ask covered ground.

## Recommended Ticket Sequence

1. **TASK-001 — TDD Red Phase**: Write failing test stubs for all new Phase 4 behaviour (free-write prompt, read-then-ask flow, preamble per question). No implementation yet.
2. **TASK-002 — Free-write opening**: Remove multi-choice question; add single framing line + free-form input collection.
3. **TASK-003 — Read-then-ask flow**: After free-write, derive questions from gaps in user input (not fixed template); ask sequentially.
4. **TASK-004 — Question preamble**: Before each question, output natural-prose preamble (interpretation, recommendation, reasoning); agent may research at discretion.
5. **TASK-005 — Regression check**: Confirm Phases 5–9 are unaffected; verify Phase 4 → Phase 5 handoff is clean.
6. **TASK-006 — Version bump & changelog**: 1.1.0 → 1.2.0 (minor feature); add changelog entry.
