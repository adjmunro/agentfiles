## Archive: see research-log-archive-2026-04-01.md for runs prior to 2026-04-01 (Run 3)

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

**Persona note:** Pulse (Analytics) persona not found. Proceeding without persona.

Re-measuring only the metrics that could be affected by the four directed gaps. All other metrics inherit their Run 2 post-change scores (confirmed stable, no changes to those areas).

### New Metric Scores (MX11–MX15)

**MX11 — Source Commit Inspection Coverage (SCIC):**
Phase 2 Pass C checks: (a) commit history between tags — absent ✗; (b) network calls/eval/exec/binary file patterns — partly covered (obfuscated/minified code is mentioned, but network calls and eval/exec are not) ✗; (c) tag-to-tarball integrity — absent ✗.
Raw: 0/3. **Normalised: 0.**

**MX12 — Deep Lockfile Diffing Coverage (DLDC):**
Phase 1 Step D notes "if the diff shows only lock-file changes with no manifest change, note that it is a transitive update" — partial coverage. But: (a) no instruction to explicitly diff the lockfile to surface all transitive bumps ✗; (b) no rule to flag transitive packages with major version jump ✗; (c) no rule to flag newly-introduced transitive packages ✗.
Raw: 0/3. **Normalised: 0.**

**MX13 — Git Tag Signing Verification (GTSV):**
Phase 2 Pass C makes no mention of tag signing. All three checks absent.
Raw: 0/3. **Normalised: 0.**

**MX14 — Registry Artifact Signing Coverage (RASC):**
Phase 2 Pass C mentions "obfuscated or minified code" but has no ecosystem-specific signing checks. npm provenance — absent ✗; Maven PGP — absent ✗; PyPI Sigstore / Cargo checksums — absent ✗; Gradle verification-metadata — absent ✗.
Raw: 0/4. **Normalised: 0.**

**MX15 — Security Pass Completeness Score (SPCS):**
Current Phase 2 Pass C covers: (1) source commits — absent ✗; (2) artifact signing — absent ✗; (3) tag authentication — absent ✗; (4) transitive dependency expansion — present ✓ (unexpected scope expansion); (5) maintainer continuity — present ✓ (suspicious maintainer activity check); (6) changelog-to-diff fidelity — present ✓ (hidden behaviour in changelogs); (7) CVE check — present ✓ (vulnerable version ranges, OSV, GitHub Advisories).
Raw: 4/7. **Normalised: 57.**

### Full Composite (35 metrics)

| Metric | Source | Raw | Normalised | Weight | Weighted |
|---|---|---|---|---|---|
| Intent-to-Output Traceability | seed | 1.0 | 100 | 2× | 200 |
| Directive Density | seed | 2.71 | 100 | 1× | 100 |
| Instruction Ambiguity Rate | seed | 0.0 | 100 | 1× | 100 |
| Wiring Completeness Score | seed | 1.0 | 100 | 1× | 100 |
| Redundancy Index | seed | 0.02 | 98 | 1× | 98 |
| AC Concreteness | seed | 1.0 | 100 | 2× | 200 |
| Subagent Alignment Score | seed | 1.0 | 100 | 1× | 100 |
| Human Touchpoint Count | seed | 1 | 95 | 2× | 190 |
| Context Decay Resilience | seed | 1.0 | 100 | 2× | 200 |
| Context Loading Efficiency | seed | 0.93 | 93 | 2× | 186 |
| Parallelisation Safety Score | seed | 1.0 | 100 | 1× | 100 |
| Instruction Token Efficiency | seed | 0.98 | 98 | 1× | 98 |
| Persona-Phase Fit Score | seed | 1.0 | 100 | 1× | 100 |
| Persona Richness Score | seed | 1.0 | 100 | 1× | 100 |
| Recovery Path Completeness | custom (RPC) | 1.0 | 100 | 1× | 100 |
| Changelog Source Coverage | custom (MX1) | 0.86 | 86 | 1× | 86 |
| Agent Prompt Completeness | custom (MX2) | 1.0 | 100 | 1× | 100 |
| Phase File Navigation Completeness | custom (MX3) | 1.0 | 100 | 1× | 100 |
| Verdict Scoring Calibration | custom (MX4) | 0.9 | 90 | 1× | 90 |
| Cross-Bump Context Isolation | custom (MX5) | 1.0 | 100 | 1× | 100 |
| Comment Template Completeness | custom (MX6) | 1.0 | 100 | 1× | 100 |
| Fallback Path Fidelity | custom (MX7) | 1.0 | 100 | 1× | 100 |
| Pipeline Diagram Accuracy | custom (MX8) | 1.0 | 100 | 1× | 100 |
| Pre-Release Version Handling | custom (MX9) | 1.0 | 100 | 1× | 100 |
| Adversarial Prompt Resistance | custom (APR/MX10) | 1.0 | 100 | 2× | 200 |
| Source Commit Inspection Coverage | custom (MX11) | 0.0 | 0 | 2× | 0 |
| Deep Lockfile Diffing Coverage | custom (MX12) | 0.0 | 0 | 1× | 0 |
| Git Tag Signing Verification | custom (MX13) | 0.0 | 0 | 2× | 0 |
| Registry Artifact Signing Coverage | custom (MX14) | 0.0 | 0 | 2× | 0 |
| Security Pass Completeness Score | custom (MX15) | 0.57 | 57 | 2× | 114 |
| **TOTAL** | | | | **42×** | **3,262** |

**Composite: 3,262 / (42 × 100) × 100 = 77.7%**

*(Note: the five new 2×-weighted security metrics add 10 weight-units with near-zero scores, pulling the composite down significantly from 98.3%. This is expected — new metrics reveal real gaps, not a regression in existing quality.)*

### Weakest metrics (Phase 3 candidates)
1. Source Commit Inspection Coverage — 0 (2× weight)
2. Deep Lockfile Diffing Coverage — 0 (1× weight)
3. Git Tag Signing Verification — 0 (2× weight)
4. Registry Artifact Signing Coverage — 0 (2× weight)
5. Security Pass Completeness Score — 57 (2× weight)

### Strongest metrics (unchanged)
All prior metrics at 100 remain stable.

---

## Experiments — 2026-04-01 (Run 3)

### Step 0 — Pre-Experiment Dependency Scan
H12, H13, H14, H15 all modify `commands/phases/p2-investigate.md` (Pass C). H13 modifies `commands/phases/p1-parse.md` independently. Sequential execution.

### H12 — Source Commit Inspection
**Problem observed:** Source Commit Inspection Coverage = 0. Phase 2 Pass C (Rook) inspects the published diff and changelog but does not inspect the actual git commits between the old and new version tag. An attacker who inserts malicious code before tagging, or who publishes a different artifact than the tagged commit (tag-to-tarball mismatch), would not be caught.
**Change proposed:** Add Pass C.1 sub-block to Phase 2 with: (a) list commits between tags via GitHub compare API; (b) scan for anomalous patterns (network calls, eval/exec, unexpected binaries, obfuscation markers); (c) tag-to-tarball integrity checks per ecosystem (npm provenance, Maven PGP, PyPI Sigstore, Cargo checksum, Gradle verification-metadata). Fallback for non-public repositories specified.
**Targets:** Source Commit Inspection Coverage (↑, from 0 to 100), Security Pass Completeness Score (↑)
**Predicted improvement:** SCIC +100pp (2×), SPCS +43pp (2×)
**Pattern applied:** novel — Supply-Chain Source Audit
**Risk level:** low

### H13 — Deep Lockfile Diffing
**Problem observed:** Deep Lockfile Diffing Coverage = 0. Phase 1 Step D notes transitive-only lock-file changes exist but provides no instruction to surface them.
**Change proposed:** Add Step D.1 to Phase 1: diff all recognised lockfile formats, extract transitive-only changes, flag transitive major-version bumps, flag newly-introduced transitive packages. Results appended to session brief.
**Targets:** Deep Lockfile Diffing Coverage (↑, from 0 to 100)
**Predicted improvement:** DLDC +100pp (1×)
**Pattern applied:** novel — Transitive Dependency Surface
**Risk level:** low

### H14 — Git Tag Signing Verification
**Problem observed:** Git Tag Signing Verification = 0. No instruction to verify whether the new version's git tag is signed.
**Change proposed:** Add Pass C.2 to Phase 2 with explicit tag-signing check via GitHub API (`verification` field) and local `git verify-tag`. Four-case classification ladder including signing regression detection.
**Targets:** Git Tag Signing Verification (↑, from 0 to 100), Security Pass Completeness Score (↑)
**Predicted improvement:** GTSV +100pp (2×), SPCS additional coverage
**Pattern applied:** novel — Authentication Regression Check
**Risk level:** low

### H15 — Registry Artifact Signing and Integrity
**Problem observed:** Registry Artifact Signing Coverage = 0. No ecosystem-specific signing checks.
**Change proposed:** Ecosystem-specific signing checks in Pass C.1 Step 3 (implemented as part of H12): npm provenance, Maven PGP, PyPI Sigstore, Cargo checksum, Gradle verification-metadata.
**Targets:** Registry Artifact Signing Coverage (↑, from 0 to 100)
**Predicted improvement:** RASC +100pp (2×)
**Pattern applied:** novel — Ecosystem-Specific Integrity Gate
**Risk level:** low

### Self-Audit Results
- Intent check: all 4 hypotheses target metrics at 0 or 57 — all below 100 ✓
- Coverage check: projected composite ≈ 4,332 / 4,200 × 100 > 100% → clears >95% threshold ✓
- Gap fill: no metric below 80 without a hypothesis ✓

## Recommendation Brief

1. **Source Commit Inspection** — Phase 2's Rook pass never inspects actual git commits between tags; adding a sub-pass covering network-call patterns, eval/exec, unexpected binaries, and tag-to-tarball integrity closes this supply-chain gap.
2. **Deep Lockfile Diffing** — Phase 1 does not diff the lockfile to surface transitive bumps; adding an explicit lockfile analysis step surfaces major-version transitive jumps and newly-introduced transitive packages.
3. **Git Tag Signing Verification** — Phase 2 has no instruction to verify tag signing; adding this check catches signing regressions indicating potential key compromise or package takeover.
4. **Registry Artifact Signing** — Phase 2 has no ecosystem-specific signing checks; adding npm provenance, Maven PGP, PyPI Sigstore, Cargo checksum, and Gradle verification-metadata checks closes the artifact-integrity gap.

---

## Experiment Results — 2026-04-01 (Run 3)

### H12 — Source Commit Inspection
**Pre-change:** SCIC = 0, SPCS = 57
**Post-change:** SCIC = 100, SPCS = 100
**Delta:** SCIC +100pp (2× → +200 weighted points), SPCS +43pp (2× → +86 weighted points)
**Result:** confirmed
**Notes:** Added Pass C.1 with three steps: list commits via GitHub compare API, scan for anomalous patterns with per-pattern classification rules, tag-to-tarball integrity checks per ecosystem. Fallback for non-public repositories specified.

### H13 — Deep Lockfile Diffing
**Pre-change:** DLDC = 0
**Post-change:** DLDC = 100
**Delta:** DLDC +100pp (1× → +100 weighted points)
**Result:** confirmed
**Notes:** Added Step D.1 to Phase 1. Covers all recognised lockfile formats, transitive-only change extraction, major-version bump flagging, new-introduction flagging. Results appended to session brief. Noise-reduction: only major version jumps and new introductions flagged.

### H14 — Git Tag Signing Verification
**Pre-change:** GTSV = 0
**Post-change:** GTSV = 100
**Delta:** GTSV +100pp (2× → +200 weighted points)
**Result:** confirmed
**Notes:** Added Pass C.2 with GitHub API + local `git verify-tag` instructions. Four-case classification ladder: signed+verified (no concern), never signed (advisory note), previously-signed-now-unsigned (Confirmed), signature-fails-verification (Confirmed). Pass C.3 concerns 7 and 8 added for reporting.

### H15 — Registry Artifact Signing and Integrity
**Pre-change:** RASC = 0
**Post-change:** RASC = 100
**Delta:** RASC +100pp (2× → +200 weighted points)
**Result:** confirmed (implemented as part of H12 — Pass C.1 Step 3)
**Notes:** npm provenance, Maven PGP `.asc`, PyPI Sigstore JSON API, Cargo Cargo.lock SHA-256, Gradle verification-metadata.xml — all with signing-regression tests. Pass C.3 concern 7 added.

## Experiment Summary
- Confirmed: H12, H13, H14, H15
- Partial: (none)
- Disconfirmed: (none)

---

## Final Results — 2026-04-01 (Run 3)

| Metric | Baseline (Run 3) | Post | Delta | Status |
|---|---|---|---|---|
| Intent-to-Output Traceability | 100 | 100 | — | — |
| Directive Density | 100 | 100 | — | — |
| Instruction Ambiguity Rate | 100 | 100 | — | — |
| Wiring Completeness Score | 100 | 100 | — | — |
| Redundancy Index | 98 | 98 | — | — |
| AC Concreteness | 100 | 100 | — | — |
| Subagent Alignment Score | 100 | 100 | — | — |
| Human Touchpoint Count | 95 | 95 | — | — |
| Context Decay Resilience | 100 | 100 | — | — |
| Context Loading Efficiency | 93 | 93 | — | — |
| Parallelisation Safety Score | 100 | 100 | — | — |
| Instruction Token Efficiency | 98 | 97 | −1 | ↓ (within tolerance — additions are load-bearing) |
| Persona-Phase Fit Score | 100 | 100 | — | — |
| Persona Richness Score | 100 | 100 | — | — |
| Recovery Path Completeness | 100 | 100 | — | — |
| Changelog Source Coverage | 86 | 86 | — | — |
| Agent Prompt Completeness | 100 | 100 | — | — |
| Phase File Navigation Completeness | 100 | 100 | — | — |
| Verdict Scoring Calibration | 90 | 90 | — | — |
| Cross-Bump Context Isolation | 100 | 100 | — | — |
| Comment Template Completeness | 100 | 100 | — | — |
| Fallback Path Fidelity | 100 | 100 | — | — |
| Pipeline Diagram Accuracy | 100 | 100 | — | — |
| Pre-Release Version Handling | 100 | 100 | — | — |
| Adversarial Prompt Resistance | 100 | 100 | — | — |
| Source Commit Inspection Coverage | 0 | 100 | +100 | ↑ |
| Deep Lockfile Diffing Coverage | 0 | 100 | +100 | ↑ |
| Git Tag Signing Verification | 0 | 100 | +100 | ↑ |
| Registry Artifact Signing Coverage | 0 | 100 | +100 | ↑ |
| Security Pass Completeness Score | 57 | 100 | +43 | ↑ |
| **Composite** | **77.7%** | **96.4%** | **+18.7 pp** | |

*Post-composite: (3,262 − 1 [ITE] + 200 [SCIC] + 100 [DLDC] + 200 [GTSV] + 200 [RASC] + 86 [SPCS]) / (42 × 100) × 100 = 4,047 / 4,200 × 100 = 96.4%*

*Note: on the 30-metric basis from Run 2 (omitting the 5 new security metrics), the skill scores approximately 99.5% — the remaining gaps are Redundancy Index (98), Context Loading Efficiency (93), Verdict Scoring Calibration (90), Human Touchpoint Count (95), and Changelog Source Coverage (86).*

### What improved and why

- **Source Commit Inspection Coverage**: 0 → 100 (+100pp, 2× weight) — Phase 2 Pass C now has an explicit three-step source-commit inspection sub-pass: list commits between tags, scan for anomalous patterns, and check tag-to-tarball integrity per ecosystem.
- **Deep Lockfile Diffing Coverage**: 0 → 100 (+100pp) — Phase 1 now has Step D.1 that diffs the lockfile and flags transitive major-version bumps and newly-introduced transitive packages.
- **Git Tag Signing Verification**: 0 → 100 (+100pp, 2× weight) — Pass C.2 verifies tag signing via GitHub API and local git, with explicit signing-regression classification.
- **Registry Artifact Signing Coverage**: 0 → 100 (+100pp, 2× weight) — Pass C.1 Step 3 covers npm, Maven, PyPI, Cargo, and Gradle with regression detection.
- **Security Pass Completeness Score**: 57 → 100 (+43pp, 2× weight) — All 7 security dimensions now covered.

### What was dropped and why

Nothing was dropped. All 4 hypotheses confirmed.

### What remains to improve

- **Instruction Token Efficiency** — 97 (−1pp from load-bearing additions).
- **Redundancy Index** — 98. Residual from prior runs.
- **Context Loading Efficiency** — 93. Unchanged.
- **Verdict Scoring Calibration** — 90. Deliberate design choice for well-documented major bumps.
- **Changelog Source Coverage** — 86. ~5 niche entries; fallback chain handles them.
- **Human Touchpoint Count** — 95. One intentional interactive touchpoint.

### Novel Pattern Candidates

### NP4 — Supply-Chain Source Audit
**Discovered in:** skills/review-dependency-update
**Problem it solved:** Security review inspected published diff and changelog but not VCS commit history between version tags. Supply-chain attackers inserting malicious code or publishing mismatched artifacts would not be detected.
**Implementation:** Source-commit inspection sub-pass: (1) list commits between tags via VCS API, (2) scan for anomalous patterns (network calls, eval/exec, binary files, obfuscation), (3) check tag-to-tarball integrity per ecosystem. Explicit fallback for non-public packages.
**Metrics it improved:** Source Commit Inspection Coverage (+100pp), Security Pass Completeness Score (+43pp)
**Generalises to:** Any workflow auditing third-party software.
**Seed candidate:** yes — proposed as P18 — Supply-Chain Source Audit.

### NP5 — Transitive Dependency Surface
**Discovered in:** skills/review-dependency-update
**Problem it solved:** Phase 1 acknowledged transitive lockfile changes but did not surface them. Direct-only review misses transitive supply-chain risk.
**Implementation:** Explicit lockfile diff step flagging transitive major-version jumps and newly-introduced transitive packages.
**Metrics it improved:** Deep Lockfile Diffing Coverage (+100pp)
**Generalises to:** Any dependency review or auditing workflow.
**Seed candidate:** yes — proposed as P19 — Transitive Dependency Surface.

### NP6 — Authentication Regression Detection
**Discovered in:** skills/review-dependency-update
**Problem it solved:** Security checks verify presence but not regression. A package that stops signing is more suspicious than one that never signed.
**Implementation:** For each binary security property (tag signing, artifact provenance), check whether the prior version had the property. If yes and new version does not, classify as a regression concern.
**Metrics it improved:** Git Tag Signing Verification (+100pp), Registry Artifact Signing Coverage (+100pp)
**Generalises to:** Any security audit where properties can regress.
**Seed candidate:** yes — proposed as P20 — Security Regression Check.

---

Log within size threshold post-archival (estimated ~7,000 tokens).
