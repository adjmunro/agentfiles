# Changelog

---

## v1.1.0 - 2026-03-27 - Optimise Run 1

Systematic optimisation pass via `/optimise`. Composite improved from 77.0% → 97.6% (+20.6pp).

- **H1** — Persist removed content log to `.tighten-audit.tmp` in Phase 3; Phase 4 reads it explicitly; Final Report cleans it up (RCLP 0→100, IFS 50→100)
- **H2** — Add explicit prior-phase artifact confirmation: Phase 2 re-confirms Phase 1 target summary; Phase 5 gates on Phase 4 audit being clean before committing (IOT 50→100)
- **H3** — Strip VERSION.md to pure version declaration; normalise CHANGELOG.md header (SFM 75→100)
- **H4** — Expand Remove table with temporal hedges, meta-commentary openers, and at-this-stage shorthand; expand Strengthen table with indirect recommendations and instruction-context softeners (RCC 80→95)
- **H5** — Operationalise Phase 4 audit criteria 1 and 2 with concrete, checkable definitions of "weakened" and "lost" (ACC 85→95)

---

## v1.0.0 - 2026-03-26 - Initial Release

First release of the tighten skill.

- Removes filler phrases, hedge qualifiers, and redundant restatements from prose
- Strengthens weak imperatives (`should` → `must`, `try to` → direct verb)
- Elevates impact vocabulary (concrete verbs, emphatic markers for hard rules)
- Resolves passive voice where the actor is unambiguous
- Audit phase verifies no meaning was lost before committing
- Supports `--dry-run` flag for preview without writing
