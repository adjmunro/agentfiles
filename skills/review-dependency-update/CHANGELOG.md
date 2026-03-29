# Changelog

---

## 1.0.0 — The First Pass (2026-03-30)

Initial release of the dependency-update review skill. Six-phase pipeline covering
PR parsing, changelog investigation, code-impact mapping, remediation, risk verdict,
and PR comment posting. Integrates Echo, Rook, Kira, and Arden personas.

- Phase 1: normalise PR reference (number, hash, or URL) and extract dependency metadata
- Phase 2: changelog and API-change investigation with Echo; security red-team with Rook
- Phase 3: codebase impact mapping — usages of changed or deprecated APIs
- Phase 4: conditional remediation with Kira — atomic commits per fix
- Phase 5: risk verdict with Arden — Low / Medium / High / Critical classification
- Phase 6: post structured verdict as a GitHub PR comment

---
