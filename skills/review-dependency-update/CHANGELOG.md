# Changelog

---

## 1.5.0 — The Full Library (2026-03-31)

Expands the Kotlin/Android changelog source table in Phase 2 from 14 to 31 entries,
adding the most frequently-encountered library families that were previously missing.
Agents investigating these libraries will now find a direct canonical URL rather than
falling through to the generic GitHub Releases / Maven Central lookup chain.

- Added: Lifecycle, WorkManager, Paging, DataStore, Navigation, Compose UI/Foundation/Material, Kotlin Immutable Collections
- Added: Dagger (non-Hilt), Moshi, Glide, Accompanist, Timber, LeakCanary, MockK, Turbine
- Added: Firebase Android SDK, Google Play Services / Play Core

---

## 1.4.0 — The Anchored Agent (2026-03-31)

Addresses context decay in parallel dispatch: sub-agents now re-anchor to the
original PR intent before beginning their phases, and receive a richer context
packet including ecosystem, PR title, and cross-bump constraints.

- Phase 1 Step E: writes session brief to `/tmp/dep-review-<PR-number>-session-brief.md` for sub-agent re-anchoring; failure is non-fatal
- Wave 1 and Wave 3 dispatch prompts: prepend re-read instruction for the session brief file
- Wave 1 prompt: adds `PR title`, `Ecosystem`, and `Cross-bump constraints` fields to per-bump agent context
- Wave 3 prompt: adds re-anchor instruction (consistent with Wave 1)

---

## 1.3.0 — The Safe Paralleliser (2026-03-31)

Fixes a concurrency bug in the parallel dispatch architecture where multiple agents
could run Phase 4 (remediation commits) simultaneously on the same branch, causing
git race conditions. Introduces a three-wave execution model, enriches the per-bump
agent prompt, adds cross-bump compatibility checking, and replaces qualitative
verdict tiers with a scored calibration matrix.

- Orchestrator: three-wave model — Phases 2–3 in parallel, Phase 4 sequential,
  Phases 5–6 parallel; Phase Dispatch Table updated with concurrency column
- Orchestrator: per-bump agent prompt enriched with PR URL, base branch, and
  phase-file base path; Wave 3 prompt carries remediation commit hashes
- Phase 1b: Step D gate now explicit (60-second timeout or auto-proceed in automated
  mode) instead of "reasonable pause"
- Phase 1b: new Step G — cross-bump compatibility check for known Kotlin/Android
  alias constraints (Kotlin↔KSP, AGP↔Kotlin, Compose Compiler↔Kotlin, Hilt↔KSP)
- Phase 1b: Step H manifest enriched with PR-level context (pr_url, base_branch,
  head_branch, cross_bump_constraints)
- Phase 4: concurrency guard comment — Phase 4 must not run in parallel across bumps
- Phase 5: qualitative tier table replaced with a 19-signal scoring matrix; tier
  thresholds and tier-to-verdict mapping added; scores override ambiguous multi-criteria situations

---

## 1.2.0 — The Parallel Inspector (2026-03-31)

Kotlin/Android focus, parallel agent dispatch per bump, and per-bump PR comments.
Phase 1b rewritten around `libs.versions.toml` version-catalog aliases as the
primary grouping signal; plugins and dependencies sharing an alias always co-commit.

- Phase 1b: full rewrite — catalog alias is the authoritative group; plugin↔dependency
  equivalence table covers AGP, Kotlin, KSP, Hilt, Navigation Safe Args, Wire
- Orchestrator: parallel dispatch section — one agent per atomic commit runs Phases
  2–6 concurrently; falls back to sequential when Agent tool unavailable
- Phase 2: Kotlin/Android changelog source table (AndroidX, Jetpack, AGP, Kotlin,
  Compose, KSP, Hilt, Ktor, Coil, Room, OkHttp, Retrofit, Coroutines, Serialization)
- Phase 5: loop-back removed — each agent owns exactly one bump
- Phase 6: rewritten for per-bump comments; no aggregation; temp-file posting to
  avoid shell-escaping issues

---

## 1.1.0 — The Atomic Splitter (2026-03-31)

Adds Phase 1b: automatic commit splitting for PRs that bundle multiple unrelated
dependency bumps into a single commit. Runs before investigation so the review
proceeds against a clean, bisectable history.

- New `p1b-split-commits.md` phase — Ink (Commit Curator) inspects PR commits,
  identifies bundles, plans the split, soft-resets and re-commits by logical group,
  then force-pushes with `--force-with-lease`
- Grouping heuristics: same npm scope / Maven groupId / PyPI namespace, coordinated
  releases (react + react-dom, boto3 + botocore), and shared BOM entries stay together
- Skips automatically if all bump commits are already atomic
- Orchestrator flow and dispatch table updated; Ink persona now declared for both
  Phase 1b and Phase 4

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
