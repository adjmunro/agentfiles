## Archive: runs prior to 2026-04-01 (Runs 3 and 4)

This file contains the complete research log for optimise runs 3 and 4 on
`skills/review-dependency-update/`. Archived from `research-log.md` at the
end of Run 5 per the 15,000-token archival policy. For runs 1 and 2, see
`research-log-archive-2026-04-01.md`.

---

## Audit — 2026-04-01 (Run 3)

**Target:** skills/review-dependency-update/
**Files:** 12 total (8 command, 4 support)
**Token estimate:** ~9,200 tokens (slightly grown from additions in Run 2)

### Feature Inventory
- Multi-phase pipeline: yes
- Persona system: yes
- Subagent invocations: yes
- Multi-session orchestration: no
- Parallel execution: yes
- Cached artifacts: yes

### Files
**Command files (8):** review-dependency-update.md, p1-parse.md, p1b-split-commits.md, p2-investigate.md, p3-impact.md, p4-remediate.md, p5-verdict.md, p6-comment.md
**Support files (4):** SKILL.md, AGENTS.md, VERSION.md, CHANGELOG.md

### TTL Check
Prior log date 2026-04-01, today 2026-04-01 (same day, Run 3) → Tier C — used as-is.

### Notes
All 4 persona files verified to exist. No broken references. No speciation warnings.
Four directed hypotheses supplied by user for this run: source commit inspection, deep lockfile diffing, signed git tag verification, registry signing and artifact integrity.

---

## Custom Metrics — 2026-04-01 (Run 3)

### MX11 — Source Commit Inspection Coverage (SCIC) [custom]
**Measures:** Whether Phase 2 instructs the agent to inspect actual git commits between the old and new tag for anomalous patterns (newly added network calls, eval/exec, obfuscation, unexpected binary files) and check tag-to-tarball integrity
**Why seeds miss it:** No seed metric measures supply-chain hygiene at the source-commit level. Pass C (Rook) checks the published diff and changelog but not the underlying VCS commit history. An attacker who controls the tag or publishes without a matching tag commit would not be caught.
**Methodology:** Check Phase 2 Pass C for: (a) instruction to list commits between old and new tag using the VCS API; (b) patterns to flag (network calls, eval/exec, binary files, obfuscation); (c) tag-to-tarball integrity check (does the published artifact match the tagged source?). SCIC = checks present / 3.
**Direction:** ↑ higher is better
**Weight:** 2× (critical supply-chain signal)
**Normalisation:** rate × 100

### MX12 — Deep Lockfile Diffing Coverage (DLDC) [custom]
**Measures:** Whether Phase 1 or Phase 2 instructs the agent to compare old vs new lockfile to surface every transitive version bump, flag transitive packages with major version jumps, and flag newly-introduced transitive packages
**Why seeds miss it:** M1 (IOT) checks whether phases consume prior artifacts, not whether the artifact scope is complete. An agent that only reviews direct dependency manifest changes misses transitive supply-chain risk.
**Methodology:** Check Phase 1 Step D and Phase 2 for: (a) explicit instruction to diff the lockfile (not just the manifest); (b) rule to flag transitive packages with a major version bump; (c) rule to flag newly-introduced transitive packages. DLDC = checks present / 3.
**Direction:** ↑ higher is better
**Weight:** 1×
**Normalisation:** rate × 100

### MX13 — Git Tag Signing Verification (GTSV) [custom]
**Measures:** Whether Phase 2 Pass C instructs the agent to check whether the new version's git tag is GPG/SSH signed, and to flag unsigned tags on packages that previously used signing
**Why seeds miss it:** Rook's existing checks focus on content anomalies and maintainer history. Tag signing is a distinct authenticity signal — a valid-looking release could be unsigned even if the code appears clean. Seeds have no mechanism for this.
**Methodology:** Check Phase 2 Pass C for: (a) instruction to verify tag signature; (b) instruction to check whether prior tags were signed (signing regression); (c) instruction to flag unsigned tags. GTSV = checks present / 3.
**Direction:** ↑ higher is better
**Weight:** 2× (authentication gap — unsigned tags on security-sensitive packages are a direct risk)
**Normalisation:** rate × 100

### MX14 — Registry Artifact Signing Coverage (RASC) [custom]
**Measures:** Whether Phase 2 Pass C includes ecosystem-specific artifact signing checks: npm provenance/OIDC, Maven PGP signatures, PyPI Sigstore, Cargo crate checksums, Gradle verification-metadata
**Why seeds miss it:** No existing metric measures whether the workflow applies the correct signing check for each ecosystem. A generic "check for obfuscation" instruction is insufficient — each ecosystem has a distinct signing mechanism and a distinct failure mode.
**Methodology:** For the four ecosystems most commonly encountered (npm, Maven/Gradle, PyPI/Cargo): check whether Phase 2 Pass C includes an ecosystem-specific signing check. RASC = ecosystems with explicit check / 4.
**Direction:** ↑ higher is better
**Weight:** 2× (artifact integrity is critical — a tampered package with a valid-looking changelog would bypass all other checks)
**Normalisation:** rate × 100

### MX15 — Security Pass Completeness Score (SPCS) [custom, moonshot]
**Measures:** The aggregate depth of the security review pass (Rook / Pass C) across seven distinct security dimensions: supply-chain source integrity, artifact signing, tag authenticity, transitive risk, maintainer continuity, changelog-to-diff fidelity, and known CVE coverage. Treats the security pass as a checklist and measures how many dimensions are explicitly covered.
**Why seeds miss it:** No metric models the security review as a multi-dimensional checklist. Seeds measure instruction clarity and structure — not whether the review is substantively complete against an expert security-review rubric. This borrows from security audit methodology (ISO 27001, SLSA levels) applied to dependency review instructions.
**Methodology:** Enumerate 7 security dimensions in Phase 2 Pass C: (1) source commits/VCS history between tags, (2) artifact/registry signing, (3) git tag authentication, (4) transitive dependency expansion, (5) maintainer continuity (ownership change, new publisher account), (6) changelog-to-diff fidelity (undocumented changes), (7) known CVE check (OSV, GitHub Advisories). SPCS = dimensions present / 7.
**Direction:** ↑ higher is better
**Weight:** 2× (aggregate security coverage; directly measures the security review's completeness as a professional reviewer would evaluate it)
**Normalisation:** rate × 100

---

## Baseline — 2026-04-01 (Run 3)

**Composite (35 metrics, including 5 new): 77.7%** (3,262 / 4,200)

New metric scores: SCIC = 0, DLDC = 0, GTSV = 0, RASC = 0, SPCS = 57.

---

## Experiment Results — 2026-04-01 (Run 3)

### H12 — Source Commit Inspection
**Pre-change:** SCIC = 0, SPCS = 57
**Post-change:** SCIC = 100, SPCS = 100
**Delta:** SCIC +100pp (2×), SPCS +43pp (2×)
**Result:** confirmed

### H13 — Deep Lockfile Diffing
**Pre-change:** DLDC = 0
**Post-change:** DLDC = 100
**Delta:** DLDC +100pp (1×)
**Result:** confirmed

### H14 — Git Tag Signing Verification
**Pre-change:** GTSV = 0
**Post-change:** GTSV = 100
**Delta:** GTSV +100pp (2×)
**Result:** confirmed

### H15 — Registry Artifact Signing and Integrity
**Pre-change:** RASC = 0
**Post-change:** RASC = 100
**Delta:** RASC +100pp (2×)
**Result:** confirmed (implemented as part of H12)

## Experiment Summary (Run 3)
- Confirmed: H12, H13, H14, H15

## Final Results — 2026-04-01 (Run 3)

| Metric | Baseline (Run 3) | Post | Delta | Status |
|---|---|---|---|---|
| Source Commit Inspection Coverage | 0 | 100 | +100 | ↑ |
| Deep Lockfile Diffing Coverage | 0 | 100 | +100 | ↑ |
| Git Tag Signing Verification | 0 | 100 | +100 | ↑ |
| Registry Artifact Signing Coverage | 0 | 100 | +100 | ↑ |
| Security Pass Completeness Score | 57 | 100 | +43 | ↑ |
| Instruction Token Efficiency | 98 | 97 | −1 | ↓ (within tolerance) |
| **Composite** | **77.7%** | **96.4%** | **+18.7 pp** | |

### Novel Pattern Candidates

### NP4 — Supply-Chain Source Audit
**Seed candidate:** yes — proposed as P18 — Supply-Chain Source Audit.

### NP5 — Transitive Dependency Surface
**Seed candidate:** yes — proposed as P19 — Transitive Dependency Surface.

### NP6 — Authentication Regression Detection
**Seed candidate:** yes — proposed as P20 — Security Regression Check.

---

## Audit — 2026-04-01 (Run 4)

**Target:** skills/review-dependency-update/
**Files:** 14 total (10 command, 4 support)
**Token estimate:** ~11,600 tokens (grown from p7-summary.md, p8-consolidate.md additions in v3.0.0)

### Feature Inventory
- Multi-phase pipeline: yes
- Persona system: yes
- Subagent invocations: yes
- Multi-session orchestration: no
- Parallel execution: yes
- Cached artifacts: yes

### Files
**Command files (10):** review-dependency-update.md, p1-parse.md, p1b-split-commits.md, p2-investigate.md, p3-impact.md, p4-remediate.md, p5-verdict.md, p6-comment.md, p7-summary.md (orchestrator-only), p8-consolidate.md (orchestrator-only, new in v3.0.0)
**Support files (4):** SKILL.md, AGENTS.md, VERSION.md, CHANGELOG.md

### TTL Check
Prior log date 2026-04-01, today 2026-04-01 (same day, Run 4) → Tier C — used as-is.

### Notes
Four new command files (p7, p8) added in v3.0.0. Focus: Phase 8 failure modes, isolated_branch threading, edge cases in consolidation.

---

## Custom Metrics — 2026-04-01 (Run 4)

### MX16 — Isolated Branch Lifecycle Completeness (IBLC) [custom]
**Measures:** Whether every distinct state in an isolated branch's lifecycle has an explicit handler with a prescribed next action.
**Weight:** 2×

### MX17 — Branch Naming Collision Guard (BNCG) [custom]
**Measures:** Whether Phase 1b Step I and Phase 8 Step A have delete-if-exists guards before `git checkout -b`.
**Weight:** 1×

### MX18 — Consolidation Partial-Failure Recovery (CPFR) [custom]
**Measures:** Whether Phase 8 has defined behaviour for each major failure mode: individual alias skip, all-skipped early exit, push rejection.
**Weight:** 2×

### MX19 — Sub-Agent Branch Context Fidelity (SBCF) [custom]
**Measures:** Whether Wave 1 and Wave 3 prompts include the `isolated_branch` field, and whether Phase 4 validates the branch before git writes.
**Weight:** 1×

### MX20 — Consolidation-to-Summary Data Handoff (CSDH) [custom, moonshot]
**Measures:** Whether Phase 8's consolidation summary schema contains sufficient data for Phase 7 to compose its full PR comment without re-reading closed sub-agent contexts.
**Weight:** 2×

---

## Baseline — 2026-04-01 (Run 4)

**Composite (35 metrics including 5 new): 78.4%** (4,075 / 5,200)

Re-measured M1 IOT at 89 (p1b lacked explicit session-brief re-read).

New metric scores: IBLC = 75, BNCG = 0, CPFR = 33, SBCF = 100, CSDH = 17.

---

## Experiment Results — 2026-04-01 (Run 4)

### H16 — Idempotent Branch Creation: confirmed (+100pp BNCG, 1×)
### H17 — Consolidation Edge-Case Handlers: confirmed (+67pp CPFR, 2×)
### H18 — Phase 7 Data Sourcing Instructions: confirmed (+83pp CSDH, 2×)
### H19 — Phase 1b Session-Brief Re-anchor: confirmed (+11pp M1 IOT, 2×)
### H20 — Isolated Branch Push-Failure Handlers: confirmed (+25pp IBLC, 2×)
### H21 — Changelog Coverage Additions: confirmed (+14pp MX1, 1×)

## Experiment Summary (Run 4)
- Confirmed: H16, H17, H18, H19, H20, H21

## Final Results — 2026-04-01 (Run 4)

| Metric | Baseline (Run 4) | Post | Delta | Status |
|---|---|---|---|---|
| Intent-to-Output Traceability | 89 | 100 | +11 | ↑ |
| Changelog Source Coverage | 86 | 100 | +14 | ↑ |
| Isolated Branch Lifecycle Completeness | 75 | 100 | +25 | ↑ |
| Consolidation Partial-Failure Recovery | 33 | 100 | +67 | ↑ |
| Consolidation-to-Summary Data Handoff | 17 | 100 | +83 | ↑ |
| Branch Naming Collision Guard | 0 | 100 | +100 | ↑ |
| **Composite** | **78.4%** | **87.7%** | **+9.3 pp** | |

### Novel Pattern Candidates

### NP7 — Idempotent Branch Creation
**Seed candidate:** yes — proposed as P21 — Idempotent Branch Creation.

### NP8 — Cross-Agent Data Contract
**Seed candidate:** yes — proposed as P22 — Cross-Agent Data Contract.

---

Log within size threshold (estimated ~13,000 tokens — approaching limit). Consider archiving before Run 5.
