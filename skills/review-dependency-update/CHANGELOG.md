# Changelog

---

## 3.6.0 — Branch Cleanup (2026-04-10)

Phase 8 Step F now deletes all `dep-review/<PR-number>/*` working branches on
both the remote and locally, and returns to the base branch — previously only
remote isolated branches were deleted, leaving local isolated branches, the
consolidated branch, and the checked-out PR head branch behind as stale state.

- **Step F (remote isolated branches):** unchanged — `git push origin --delete` per alias
- **Step F (local isolated branches):** added `git branch -D` per alias — were never cleaned up
- **Step F (consolidated branch):** added remote + local deletion after base checkout — was
  explicitly excluded from cleanup with incorrect reasoning ("it now backs the PR head")
- **Step F (local PR head branch):** added `git branch -D <head-branch>` — was checked out
  in Phase 1b Step A and left behind pointing to the pre-consolidation tip

---

## 3.5.0 — The Precise Searcher (2026-04-01)

Closes two first-time-agent gaps identified in the eighth optimisation pass:
missing ecosystem-specific file extension guidance in Phase 3, and temp file
naming collisions between concurrent skill runs in Phase 6 and Phase 7.

- **Phase 3 Step B (ecosystem search extensions table):** adds a 10-ecosystem
  lookup table mapping each supported ecosystem to its relevant source and
  config file extensions; covers Kotlin/Android (`.kt`, `.kts`, `.java`,
  `*.gradle`, `*.gradle.kts`, `*.toml`, `*.xml`), Java, npm/Yarn, Python,
  Ruby, Go, Rust, Swift, PHP, and .NET; includes an explicit callout that
  Kotlin/Android searches must include `.kts` or they will miss the majority
  of a Kotlin-first codebase; previously, Phase 3 instructed agents to use
  "appropriate extensions for this ecosystem" with no definition of what those
  are — a first-time agent on an unfamiliar project could search the wrong
  file types and miss real usages
- **Phase 6 Step B (temp file path):** renames `/tmp/dep-review-<alias>.md`
  to `/tmp/dep-review-<PR-number>-<alias>.md`; two concurrent skill runs for
  different PRs bumping the same alias would previously write to the same path
  and clobber each other's per-bump comment; now consistent with the PR-numbered
  pattern already established in Phase 1 and Phase 8
- **Phase 7 Step C (temp file path):** renames `/tmp/dep-review-summary.md`
  to `/tmp/dep-review-<PR-number>-summary.md`; any two concurrent skill runs
  previously shared this path, meaning the last run to reach Phase 7 would
  silently post a summary for the wrong PR; now disambiguated by PR number

---

## 3.4.0 — The Prepared Agent (2026-04-01)

Closes two first-time-agent gaps identified in the seventh optimisation pass:
a missing pre-flight check that caused the skill to fail silently on non-GitHub
repositories and unauthenticated sessions, and a return-contract gap that caused
Wave 3 sub-agents to never surface their Phase 5 verdict blocks to the orchestrator.

- **Phase 1 Step A (prerequisite gate):** adds a two-part pre-flight check before
  the first `gh` call — (1) verifies the `git remote get-url origin` URL is
  `github.com`-hosted and stops with a plain-language advisory if not, naming the
  detected host and directing the user to a GitHub repository; (2) runs
  `gh auth status` and stops with the authentication instruction if `gh` is not
  logged in; previously, a non-GitHub remote or unauthenticated session would fail
  silently at the first `gh pr view` call with no prescribed diagnostic
- **Orchestrator Wave 3 dispatch prompt (return contract):** adds an explicit
  instruction for each Wave 3 sub-agent to return its Phase 5 verdict block as the
  final line of its output message; previously, the orchestrator's Wave 5 preamble
  required this return but the sub-agents never received the instruction — every
  parallel run silently fell through to the `gh pr view --json comments` fallback

---

## 3.3.0 — The Consistent Executor (2026-04-01)

Closes three instruction-level correctness gaps found in the sixth optimisation
pass: a manifest schema contradiction introduced in v3.2.0, an unhandled push-failure
path in Phase 1b, and a missing CI data source in Phase 5 for the Phase 4 skip path.

- **Phase 1b Step I (push-failed alias retention):** retains push-failed aliases in
  the manifest with `push_failed: true` rather than removing them; Phase 7's check
  for excluded aliases now has data to find; the v3.2.0 instruction ("Remove
  push-failed aliases from the manifest") contradicted Phase 7 Step A's instruction
  ("check the manifest for entries with `push_failed: true`") and made the Run 5
  reporting fix unreachable at runtime
- **Orchestrator Wave 1 dispatch:** adds an explicit pre-dispatch guard to skip
  manifest entries where `push_failed: true`; clarifies that excluded aliases have
  no isolated branch and cannot be investigated; makes the exclusion logic explicit
  rather than implicit
- **Phase 1b Step F (force-push failure recovery):** adds a 5-step push-failure
  decision tree matching the existing pattern in Phase 4 Step F and Phase 8 Step E;
  previously the step only noted `--force-with-lease` with no prescribed next action
  on rejection; closes the last unhandled conditional branch in the pipeline
- **Phase 5 Step A (CI data source note):** when Phase 4 is skipped (no actionable
  usages), Phase 5 now has an explicit instruction to read the CI Status section
  from the session brief; previously, CI data only entered Phase 5 scope via Phase 4's
  Remediation Summary — a clean bump with CI failures and no codebase usages to
  remediate had no prescribed CI data retrieval path

---

## 3.2.0 — The Complete Pipeline (2026-04-01)

Closes five edge-case gaps discovered in the fifth optimisation pass: the
already-atomic PR path, bisect recovery, consolidation summary durability,
push-failed alias visibility, and supply-chain verdict enforcement.

- **Phase 1b Step C (already-atomic path):** when all commits are already atomic
  and no splitting is required, the skip path now continues to Steps G, H, and I
  (cross-bump check, manifest production, and isolated branch creation) rather
  than jumping straight to `→ Next`; the orchestrator's Wave 1 dispatch requires
  a populated manifest regardless of whether splitting occurred
- **Phase 8 Step D (bisect combinatorial failure):** the combinatorial-failure path
  ("record that finding explicitly") now includes an explicit `git checkout
  dep-review/<PR-number>/consolidated` instruction, returning the orchestrator to
  the consolidated branch HEAD before the force-push step
- **Phase 8 Step G (consolidation summary persistence):** writes the consolidation
  summary to `/tmp/dep-review-<PR-number>-consolidation-summary.md` in addition to
  in-context output; failure-tolerant (if `/tmp` is unwritable, notes this and
  proceeds — consistent with Phase 1 Step E)
- **Phase 7 Step A (push-failed alias visibility):** instructs the orchestrator to
  scan the manifest for `push_failed: true` entries and surface them as "Not
  reviewed — isolated branch push failed in Phase 1b" rows in the Bumps Reviewed
  table; Phase 7 Step B template updated with the corresponding row type
- **Phase 7 Step A item 7 (consolidation summary read):** reads from the Phase 8
  temp file as the primary source for the consolidation outcome, with in-context
  data as fallback
- **Phase 5 Step B (supply-chain integrity hard block):** adds a hard block
  mirroring the existing CI hard block — if Rook reports a Confirmed tag-signing
  regression or tag-to-tarball mismatch, the verdict floor is REQUEST CHANGES
  regardless of tier; the existing Rook +5 scoring signal is unchanged

---

## 3.1.0 — The Resilient Consolidator (2026-04-01)

Hardens the isolated-branch architecture introduced in v3.0.0 against six
failure modes that were previously unhandled. Re-runability after an aborted
session, Phase 8 edge cases, Phase 7 data availability across closed sub-agents,
and Phase 1b intent-anchoring gaps are all addressed.

- **Phase 1b (start):** re-reads `/tmp/dep-review-<PR-number>-session-brief.md`
  at startup before Step A — the only phase in the pipeline that previously
  skipped this re-anchor; closes the Intent-to-Output Traceability gap
- **Phase 1b Step I:** adds delete-if-exists guards (`git push origin --delete`
  and `git branch -D` with `2>/dev/null || true`) before each `git checkout -b`
  to make isolated-branch creation idempotent on re-runs; adds a push-failure
  handler that records `push_failed` on the manifest entry, continues to the
  next alias, reports all failures after the loop, and excludes failed aliases
  from the manifest
- **Phase 4 Step F:** adds a four-step retry decision tree for `--force-with-lease`
  rejections: fetch remote state, inspect commits, retry once if the rejection is
  a stale-lease artefact from Phase 1b's original push, and stop with an explicit
  message if unexpected remote commits are found
- **Phase 8 Step A:** adds delete-if-exists guard before consolidated branch
  creation (same idempotency fix as Phase 1b)
- **Phase 8 Step B (all-skipped exit):** if every alias is skipped (all Phase 5
  verdicts are BLOCK or unverified), skip the integration test suite and the
  force-push step; proceed directly to cleanup and document that the PR head
  branch was not modified
- **Phase 8 Step E (push-rejection decision tree):** four-step handler: fetch
  remote, inspect commits, retry once if the rejection is a stale-lease artefact,
  stop with an explicit message if a human has pushed new commits to the head
  branch since Phase 1b
- **Phase 7 Step A:** adds an explicit data-source block at the top with a
  three-tier data collection strategy (parallel agent return values, sequential
  in-context data, fallback PR-comment retrieval via gh CLI); adds item 7
  (consolidation outcome) to the data-gather list, referencing the Phase 8
  consolidation summary
- **Orchestrator Wave 5:** documents the three-tier Phase 5 data collection
  strategy — require Wave 3 agents to return verdict blocks as final output;
  sequential data is already in context; fallback: `gh pr view --json comments`
- **Phase 2 changelog table:** adds Koin, Arrow, SqlDelight, Detekt, and Gradle
  (build tool) to the Kotlin/Android primary sources table

---

## 3.0.0 — The Isolated Investigator (2026-04-01)

**Breaking architectural change.** Replaces the shared PR head branch execution
model with per-alias isolated branches. Previously, all per-bump agents operated
on the same PR head branch, meaning bump-B's investigation and tests were
contaminated by bump-A's unresolved state. This release eliminates cross-
contamination entirely: each alias group lives on its own isolated branch from
the moment Phase 1b completes until Phase 8 merges it into the consolidated branch.

- **Phase 1b Step I (new):** after producing the atomic commit manifest, creates
  one isolated branch per alias group forked from the **base branch** (not the PR
  head); cherry-picks the alias group's commit onto the branch; pushes it to the
  remote; manifest schema extended with an `isolated_branch` field
  (`dep-review/<PR-number>/<alias>`) so all downstream phases can locate the branch
  without inferring it
- **Phase 4 Step A (rewritten):** now checks out the **isolated branch** for the
  current alias (`dep-review/<PR-number>/<alias>`) rather than the PR head branch;
  includes fetch-before-checkout fallback; adds a branch-name confirmation guard
  (`git branch --show-current`) before any changes are made
- **Phase 4 Step F (new):** force-pushes the isolated branch after all commits and
  tests pass; uses `--force-with-lease`; includes an explicit note that Phase 4 must
  never write to the PR head branch directly — that is Phase 8's responsibility
- **New `phases/p8-consolidate.md` — Phase 8: Consolidation (orchestrator-only):**
  - Step A: creates a fresh `dep-review/<PR-number>/consolidated` branch from base
  - Step B: merges each verified isolated branch in manifest order using
    `git merge --no-ff`; skips aliases flagged as unverified or BLOCK by Phase 5;
    records merge outcome (clean / conflict resolved / skipped) per alias
  - Step C: runs the full integration test suite on the consolidated branch; records
    pass/fail and test counts
  - Step D: on integration test failure, bisects by checking out each alias merge
    point in order and re-running the suite; identifies the regression introducer;
    does not automatically skip the offending alias — flags it for human decision
  - Step E: force-pushes the consolidation branch to replace the PR head branch
    (`git push --force-with-lease origin dep-review/<PR-number>/consolidated:<head-branch>`)
  - Step F: deletes all remote isolated branches (including skipped ones)
  - Step G: writes a structured consolidation summary (merge results table,
    integration test result, bisect findings, skipped aliases) for Phase 7
- **Orchestrator pipeline diagram:** updated to show isolated branches in Wave 1
  and Wave 2; Phase 8 consolidation as Wave 4; Phase 7 summary as Wave 5
- **Orchestrator Phase Dispatch Table:** Phase 8 row added (Sequential /
  orchestrator, active after all Wave 3 agents complete); Phase 7 moved to Wave 5;
  column descriptions updated to reference isolated branches
- **Wave 1 agent prompt:** adds `isolated_branch` field so each agent knows which
  branch to operate on; includes instruction not to check out or modify any other branch
- **Wave 3 agent prompt:** adds `isolated_branch` field consistent with Wave 1;
  verdict work is based on the isolated branch state
- **Wave 4 section (new):** describes the sequential, orchestrator-only dispatch of
  Phase 8; covers consolidation, integration test, bisect, force-push, and cleanup;
  fallback for non-parallel execution
- **Wave 5 section (renamed from Wave 4):** Phase 7 now runs after Phase 8, receiving
  both the per-bump Phase 5 verdict data and the Phase 8 consolidation summary

---

## 2.5.0 — The Consolidated Close (2026-04-01)

Adds a final consolidated verdict comment as the last action of every skill run.
Previously, the skill posted one per-bump comment per dependency reviewed, leaving
reviewers with no single place to see the full picture — they had to scroll through
all individual comments to understand the overall recommendation. This release closes
that gap with Phase 7, a new orchestrator-only step that posts one summary comment
after all per-bump Phase 6 comments have been posted.

- New `phases/p7-summary.md`: orchestrator-only phase that collects verdict data from
  all bumps and posts a single consolidated PR comment; covers all required dimensions:
  bumps reviewed (alias, versions, span, tier, score, verdict), CI status before and
  after remediation with unresolved-failure call-outs, supply chain signals (tag
  signing, registry integrity, source commit anomalies, maintainer changes), breaking
  changes and deprecations with remediation status, remediations made (commit hashes
  and descriptions), final verdicts table with overall recommendation, and a
  plain-English paragraph written for non-technical reviewers
- Phase 6 (`p6-comment.md`): adds orchestrator note at the end — per-bump agents do
  not run Phase 7; it is dispatched by the orchestrator after all agents complete
- Orchestrator pipeline diagram: updated to show Wave 4 and the Phase 7 summary step
  after all Phase 5–6 parallel work is done
- Orchestrator Phase Dispatch Table: Phase 7 row added as Sequential (orchestrator),
  active when all Phase 6 comments are posted; Wave 4 separator row added
- Orchestrator Wave 4 section: new section describing the sequential, orchestrator-only
  dispatch of Phase 7, with a fallback for non-parallel execution

---

## 2.4.0 — The CI Gatekeeper (2026-04-01)

Adds CI status checking and failure triage to the pipeline. Previously, the skill
reviewed changelog, API changes, and codebase impact but had no visibility into
whether the dependency update's own CI was passing. A PR could receive an APPROVE
verdict while build or test failures caused by the version bump were silently ignored.
This release closes that gap by fetching CI status in Phase 1, triaging failures by
category, feeding actionable failures into Phase 4 remediation, and enforcing a hard
block in Phase 5 for unresolved non-environment failures.

- Phase 1 Step G: new step — fetches CI/check status via `gh pr checks` after writing
  the session brief; if all checks pass, notes it in the brief and continues; if any
  checks are failing or pending, fetches logs for each failing job (`gh run view
  --log-failed`) and classifies each failure into one of five categories: API break,
  Migration required, Test environment issue, Deprecation became removal, or Other;
  appends a structured CI Status section to the session brief with a triage table and
  routing notes; data-boundary guard applied to CI log content
- Phase 4 Step A.1: new step — reads CI triage from the session brief before working
  through the Phase 3 impact table; API break, Deprecation became removal, and
  Migration required failures are added to the must-fix list; Test environment issue
  failures are recorded as advisory; Other failures are flagged for manual attention
- Phase 4 Step D.1: new step — after all commits, re-fetches `gh pr checks` to
  determine whether previously failing jobs now pass; records each job as resolved or
  unresolved; unresolved non-environment failures propagate to Phase 5 as blocking
- Phase 4 Step E (Remediation Summary): extended with a CI Status After Remediation
  table showing before/after state for each previously failing job
- Phase 5 Step A scoring matrix: four new CI signals — all failures resolved (0 extra
  penalty), unresolved non-environment failures (+4), unresolved environment-only
  failures (+1), CI passing or not configured (0)
- Phase 5 CI hard block: new override rule — regardless of tier, any unresolved
  non-environment CI failure forces the verdict to REQUEST CHANGES at minimum; APPROVE
  and APPROVE WITH CONDITIONS are blocked
- Phase 5 Step C verdict block: new CI Status field added between Security and
  Warnings / Follow-up Required
- Orchestrator pipeline diagram: updated to show Step G branch, Step A.1 merge, Step
  D.1 re-check, and Phase 5 CI hard block annotation

---

## 2.3.0 — The Full Span (2026-04-01)

Adds multi-version span awareness across Phases 1, 2, and 5. Previously, when a
dependency jumped multiple releases (e.g. `1.0.0 → 1.3.0`), the skill would only
inspect the changelog and signals for the final version being moved to. Intermediate
releases — and any breaking changes, deprecations, CVEs, or security signals they
introduced — were silently skipped. This release closes that gap.

- Phase 1 Step E: session brief now includes a `Version Span` column; multi-version
  spans list all intermediate versions inline (e.g. `multi (3 versions: 1.1.0, 1.2.0,
  1.3.0)`) to signal Phase 2 that changelog aggregation is required
- Phase 2 Pass A: new "Multi-Version Span Detection" block — enumerates all released
  versions in the range (old, new] using the appropriate registry API per ecosystem;
  records the intermediate version list; distinguishes single-version and multi-version
  spans before any changelog fetch begins
- Phase 2 Pass B: explicit instruction to aggregate change entries across every
  intermediate version; intermediate CVEs that were later patched must still be
  reported, with both the introduction version and the fix version noted
- Phase 2 Pass C.1: clarifying note that the `old-tag...new-tag` commit comparison
  already covers all intermediates; no additional per-version comparison needed
- Phase 2 Pass D report template: version span line added to the investigation report
  header; Security Advisories table extended with an "Introduced in span" column and
  an explanatory note on intermediate CVE reporting
- Phase 5 Step A scoring matrix: new signal "Multi-version span (≥3 intermediate
  versions skipped)" (+1) with a clarifying note on when to apply it
- Phase 5 Step C verdict block: version span line added; Summary field guidance
  updated to require explicit mention of traversed versions and whether any signals
  originated from intermediate releases

---

## 2.2.0 — The Lockfile Lens (2026-04-01)

Adds explicit transitive dependency analysis to Phase 1. The agent now diffs the
lockfile (all recognised formats) to surface transitive major-version bumps and
newly-introduced transitive packages before investigation begins. Results are
appended to the session brief for downstream Phase 2 agents. Patch-only transitive
bumps are intentionally excluded to avoid noise.

- Phase 1 Step D.1: diffs lockfile between base and head branch; flags transitive
  major-version bumps and newly-introduced transitive packages; appends findings
  to session brief; graceful fallback when no lockfile is present in the PR

---

## 2.1.0 — The Supply-Chain Auditor (2026-04-01)

Substantially expands Phase 2's security red-team pass (Rook) to cover three new
supply-chain dimensions that were previously absent: source commit inspection,
git tag signing verification, and ecosystem-specific artifact signing. Together
these additions close the gap between a changelog-and-diff review and a
professional SLSA-aligned dependency security audit.

- Phase 2 Pass C.1 — Source Commit Inspection: lists commits between old and new
  tag via the GitHub compare API; scans for anomalous patterns (newly added network
  calls, eval/exec, unexpected binary files, obfuscation markers); checks
  tag-to-tarball integrity per ecosystem (npm provenance, Maven PGP `.asc`,
  PyPI Sigstore attestations, Cargo `Cargo.lock` SHA-256, Gradle
  `verification-metadata.xml`); explicit fallback for non-public packages
- Phase 2 Pass C.2 — Git Tag Signing: checks whether the new version's git tag is
  GPG/SSH-signed via GitHub API (`verification` field) and local `git verify-tag`;
  four-case classification ladder including signing-regression detection (previously
  signed → now unsigned = Confirmed concern); advisory note for packages that have
  never signed
- Phase 2 Pass C.3 — Named Concerns: renumbers and extends the existing concern list
  to eight items, adding concerns 7 (registry signing regression) and 8 (tag signing
  regression) to surface Pass C.1/C.2 findings in the final report table
- Phase 2 Pass D — Investigation Report template: extended Security Red-Team section
  with structured tables for Pass C.1 (source commit + integrity) and Pass C.2 (tag
  signing) findings alongside the existing Pass C.3 named-concern table

---

## 1.9.2 — The Final Gate (2026-04-01)

Replaces the last subjective acceptance criterion in Phase 4 with a concrete binary
test. The previous condition ("does not alter the observable behaviour of the
surrounding code") required interpretive judgment. The new condition is objectively
checkable without tooling.

- Phase 4 Step C: replaces "does not alter observable behaviour" with a two-part
  binary test — pure rename/equivalent-replacement (same input/output types), OR
  the changelog explicitly states "no behaviour change" for this symbol

---

## 1.9.1 — The Explicit Fallback (2026-04-01)

Clarifies the Wave 3 non-parallel fallback instruction to explicitly note that Phase
4's one-bump-at-a-time sequencing constraint is automatically satisfied by sequential
execution. Previously this invariant was implicit, which could cause confusion for
agents trying to determine whether additional ordering logic was needed.

- Orchestrator Wave 3 fallback: adds parenthetical clarifying Phase 4 sequencing
  is automatically satisfied by serialisation

---

## 1.9.0 — The Guarded Reader (2026-04-01)

Adds explicit data-boundary instructions to the phases that read untrusted external
content — Phase 1 (PR body/title) and Phase 2 (changelogs). Without these guards,
a crafted changelog entry or PR description could embed text that redirects the
agent's behaviour (prompt injection). Rook's Pass C in Phase 2 already had partial
protection; this formalises and reinforces it across all three external-read points.

- Phase 1 Step B: adds data-boundary note before fetching PR metadata
- Phase 2 Pass A: adds data-boundary note before changelog fetch
- Phase 2 Pass C: reinforces boundary — Rook is suspicious of content, not directed by it

---

## 1.8.1 — The Accurate Map (2026-04-01)

Corrects the SKILL.md pipeline diagram to reflect the actual pipeline structure,
including Phase 1b and parallelisation annotations that were previously absent.

- SKILL.md: adds Phase 1b to pipeline diagram; annotates Phases 2–3 and 5–6 as
  parallel-per-bump and Phase 4 as sequential
- SKILL.md: corrects the "Multiple dependencies" note to accurately describe
  the parallel/sequential split rather than implying pure sequential execution
- SKILL.md: renames "6-Phase Pipeline" heading to "Pipeline"

---

## 1.8.0 — The Version Realist (2026-04-01)

Adds explicit handling for version range edge cases that were previously unaddressed
in Phase 2: pre-release version string ordering, multi-hop major version upgrades,
and BOM pin / version-only alias resolution.

- Phase 2 Pass A: adds "Version Range Edge Cases" block covering pre-release suffixes
  (alpha/beta/rc/SNAPSHOT ordering), multi-hop major ranges (fetch all intermediate
  changelogs), and version-only BOM aliases (resolve via BOM mapping URL)

---

## 1.7.0 — The Concrete Gate (2026-03-31)

Replaces two subjective acceptance criteria with concrete, binary-testable conditions.
Agents executing Phase 4 and Phase 2 no longer need to exercise judgment on whether
a migration is "low-risk" or a bug fix is "relevant".

- Phase 4 Step C: replaces "low-risk and well-documented" with three concrete binary conditions — documented replacement with code example/guide, ≤3 call sites or all structurally identical, no observable behaviour change
- Phase 2 Pass B: replaces "relevant to our usage" for bug fixes with a concrete codebase-presence check — record if the affected API or type is imported or called in this codebase (Phase 3 confirms)

---

## 1.6.0 — The Calibrated Scorer (2026-03-31)

Improves the Phase 5 risk scoring matrix by adding a differentiated signal for
major bumps with no changelog, and a risk-reduction signal for fully-remediated PRs.
Closes the one-directional asymmetry in the matrix.

- New signal: "Major version bump with no changelog found" (+3) — differentiated from plain major bump (+2); mutually exclusive (note added to prevent double-counting)
- New signal: "All actionable usages fully remediated (zero skipped must-fix items)" (−1, floor 0) — provides credit for clean Phase 4 outcomes
- Clarifying note: the two major-bump signals are mutually exclusive; use the no-changelog variant only when Phase 2 found nothing

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
