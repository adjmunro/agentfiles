# Changelog

---

## v1.1.0 - 2026-03-27 - Optimise Pass: Robustness and Output Fidelity

### Added
- Progressive persona loading: each persona (Arc, Loom, Ward) is now loaded at the phase boundary where it activates, with `soul.md` included alongside `persona.md`
- Intent Anchor blocks at Phase 2, Phase 3, Phase 4, and Phase 5 entries to prevent phase execution without required prior state
- Phase 2 Step 6: source domain coverage tally (always rendered as `X/3 — [list]`) to surface missing domains before synthesis
- Phase 3 Step 2: 4-component area entry completeness check (area name, commit subjects, synthesis sentence, doc note if applicable)
- Phase 5 completion gate: all 5 sections must be present before finalising output; explicit fallback text required if a section has no content
- Detached HEAD detection in Phase 1 Step 1 with a `git merge-base HEAD main` fallback and a clear abort message
- Why-section quality gate: if no commit bodies or changelog entries exist, lists missing commits by SHA; if < 3 sentences of rationale, appends a depth indicator
- Ward "living status document" framing in Phase 4 activation directive
- Phase 5 "write for the next person" directive for Ward, with "assume no prior context" framing
- Loom Phase 2 activation now includes "note emergent connections between source domains" to prime cross-domain synthesis
- "No files changed" error path now outputs all 5 sections with per-section fallback text rather than a single generic message
- Loom Phase 3 preamble: "Identify the emergent property of this change set" instruction for naming the synthesis thread in the Changes by area introduction

### Changed
- Phase 2 intent anchor compressed to single line; specifics moved to Phase 3 anchor where they are load-bearing for M1 traceability
- Directive language hardened throughout: "aim for" → "write", "should be" → "must be", vague thresholds → concrete criteria
- SKILL.md updated to correctly reflect Ward's phase coverage (Phase 2 Step 5, Phase 4, Phase 5)
- Ward Phase 2 Step 5 doc-drift check now explicitly signals Loom's resumption after Ward's step completes

## v1.0.0 - 2026-03-22 - Initial Release

### Added
- Initial release of the `/summary` skill
- Four invocation modes: default (branch parent), `pr` (PR review framing), `trunk` (divergence from main), and `<ref>` (arbitrary git ref)
- Structured output sections: Context, Changes by area, New & changed features, Why, and Open work
- Persona assignments: Arc (Sequencer) for temporal reasoning, Loom (Synthesist) for cross-source synthesis, Ward (Documentation) for doc accuracy
- CHANGELOG scanning: reads changed `CHANGELOG.md` files in `skills/` and `personas/` directories
- Open work detection: scans `.kanban/` for in-progress tickets
