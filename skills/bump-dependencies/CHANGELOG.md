# Changelog

---

## 4.23.0 — Step Numbering and Branch Lifecycle Fixes (2026-04-22)

Closes four gaps discovered in Run 030: Phase 8 Step B had a duplicate item number
"3." introduced by H114's absent-verdict check insertion without renumbering; Phase 0
Step H's existing-PR path deleted the remote BUMP_BRANCH but left a dangling local
branch; Phase 5's verdict block CI Status template had no guidance for surfacing the
data-source provenance note written by Phase 4 Step D.1; and Phase 5's "+2 CI pending"
note lacked a scope clause to prevent misapplication when Phase 4 was not triggered.

- **Phase 8 Step B — item renumbering:** items following the absent-verdict check
  renumbered from duplicate 3/4/5 to sequential 4/5/6 — eliminates ambiguity when
  agents parse the numbered list.
- **Phase 0 Step H — local branch cleanup:** `git branch -D <BUMP_BRANCH>` added
  after `git checkout <base-branch>` in the existing-PR path, completing the branch
  lifecycle (remote delete was already present).
- **Phase 5 Step C — CI data-source provenance:** `#### CI Status` template gains
  an instruction to append a provenance note when Phase 4 Step D.1 recorded that
  CI data came from the PR head branch rather than the isolated branch.
- **Phase 5 — "+2 CI pending" scope clause:** note now explicitly states it applies
  only when Phase 4 ran and Step D.1 was reached; directs agents to use the "+1
  precautionary" partially-pending row instead when Phase 4 was not triggered.

---

## 4.22.0 — Pending Signal Coverage and Span Clarity (2026-04-22)

Closes four gaps discovered in Run 029: Phase 4 Step D.1 now re-checks CI when Phase 1
recorded a partially-pending state (not only when failures were recorded), fulfilling an
orphaned re-check intent; Phase 5 gains two new scoring signals for the partially-pending
case (re-checked and not re-checked); Phase 8 Step E.1's exclusion table now surfaces
absent-verdict aliases alongside BLOCK and push-failed ones; and Phase 5's multi-version
span signal now applies when Phase 2 failed to enumerate intermediate versions.

- **Phase 4 Step D.1 — partially-pending re-check:** activation condition extended from
  "any CI failures" to also cover "partially pending (some passing, some pending, none
  failing)" — fulfils Phase 1 Step G's instruction to re-check before Phase 4.
- **Phase 5 scoring matrix — partially-pending signals:** two new rows handle the case
  where Phase 1 CI was partially pending; if Phase 4 re-checked, the updated result is
  used; if Phase 4 was not triggered, +1 precautionary signal applied.
- **Phase 8 Step E.1 — absent-verdict exclusion row:** PR body exclusion table template
  gains a third row for aliases skipped due to absent Phase 5 verdict (silent Wave 3
  agent failure), introduced by H114 but missing from the template.
- **Phase 5 — enumeration-failure span signal:** "Multi-version span" note extended to
  instruct agents to apply the +1 signal when Phase 2 recorded enumeration failure,
  closing the gap between Phase 2's Enumeration Warning and Phase 5's risk score.

---

## 4.21.0 — Pipeline Completeness and Fault Guards (2026-04-22)

Closes five gaps discovered in Run 028: Phase 3's routing now triggers Phase 4 when
CI failures require remediation even without source-code actionable usages; Phase 8's
consolidation step guards against merging aliases whose Wave 3 agent failed silently;
Phase 5 gains an explicit detection method for proactive PRs; Phase 0 discloses that
bump commits are orphaned when a user selects an existing PR; and Phase 3's impact
table surfaces unaddressed CI failures when Phase 4 is skipped, while Phase 4's
header is updated to reflect CI failures as a first-class activation trigger.

- **Phase 3 routing — CI-failure branch:** `→ Next` now routes to Phase 4 when Phase 1
  Step G recorded API break, Migration required, or Deprecation became removal failures,
  even with zero Phase 3 source-code actionable usages. Phase 4 Step A.1 is now
  reliably reachable for CI-failure-only scenarios.
- **Phase 8 Step B — absent-verdict guard:** third skip condition added for aliases
  where Phase 5 produced no verdict (silent Wave 3 agent failure), detected by querying
  PR comments. Prevents unreviewed aliases from being merged.
- **Phase 5 — proactive-PR detection method:** the 7-day supply-chain signal note now
  specifies exactly how a per-bump sub-agent determines whether Phase 0 created the
  PR (title prefix + branch prefix, both required).
- **Phase 0 Step H/I — orphaned-commit disclosure:** "Important:" note added to Step H
  and a ⚠️ banner added to Step I's output when the user chooses an existing PR,
  clarifying that BUMP_BRANCH commits were discarded.
- **Phase 3 impact table + Phase 4 header — CI-failure completeness:** Phase 3's impact
  table template gains a "CI Failures Not Addressed" section (conditional on Phase 4
  not being triggered); Phase 4's header activation comment now lists CI failures as
  an explicit trigger alongside Phase 3 actionable usages.

## 4.20.0 — Gate Propagation and Guard Parity (2026-04-22)

Closes five instruction gaps discovered in Run 027: Phase 7 preamble now handles the
zero-aliases case (all blocked) without posting a redundant summary comment to an
already-closed PR; IS_PROACTIVE detection in Phase 7 and Phase 8 now requires both
title and branch name, preventing Phase 8 from closing a human-authored PR; Phase 8
Step E gains a `git branch --show-current` check before force-pushing, guarding against
detached HEAD after bisect; Wave 2 now explicitly collects remediation commit hashes per
alias for Wave 3 dispatch; and Phase 1b Step G persists cross-bump compatibility check
results to the manifest and session brief, with a new Phase 5 scoring signal (+3) for
detected violations.

- **Phase 7 preamble — zero-alias guard:** explicit case added for "zero aliases reviewed
  (all blocked or push-failed)" that skips Steps B and C entirely, eliminating the
  redundant summary comment posted to a proactive PR Phase 8 already closed.
- **IS_PROACTIVE secondary confirmation:** all three detection sites (Phase 7 Step A,
  Phase 8 Steps B and E.1) now check both title and `headRefName` — IS_PROACTIVE=true
  only if the title starts with `chore(deps): bump outdated dependencies` AND the head
  branch starts with `deps/auto-bump-`.
- **Phase 8 Step E branch verification:** `git branch --show-current` check added before
  the force-push with an explicit stop-and-report if the current branch is not `<head-branch>`,
  mirroring the Step A guard pattern.
- **Wave 2 remediation hash accumulator:** after each Phase 4 run, explicit instruction
  to collect commit hashes into a named accumulator keyed by alias, used in Wave 3
  agent dispatch.
- **Phase 1b cross-bump check result persistence:** Step G now writes `cross_bump_check_result`
  and `violated_constraints` to each alias's manifest entry and appends a summary to the
  session brief; Step H manifest schema extended with the two fields; Phase 5 scoring
  matrix gains a +3 signal for `violation_detected`.

---

## 4.19.0 — Safety Parity and Resilience (2026-04-22)

Closes five instruction gaps discovered in Run 026: Phase 1 Step G now handles the
"some passing, some pending, none failing" CI state with a correct output template
instead of misfiring "CI is FAILING"; Phase 8 Step E.1 surfaces push_failed entries
in the excluded section of the updated PR description; Phase 1b Step H persists the
atomic commit manifest to a temp file for orchestrator session recovery; Phase 2 Pass C's
data boundary note now explicitly names commit messages alongside package diff and
changelog entries; and Phase 2 Pass A records the new version's publication date so
Phase 5 can apply the 7-day supply-chain safety signal in PR-review mode.

- **Phase 1 Step G — partial-pending CI state:** a fourth case added between all-pending
  and failing; the third category heading narrowed from "failing or pending" to "failing"
  — agents now output "CI status: partially pending — M passing, N pending" instead of
  "CI is FAILING. 0 check(s) failed." when no checks have actually failed.
- **Phase 8 Step E.1 — push_failed visibility:** the PR description update trigger
  extended to include `push_failed: true` entries alongside Phase 5 BLOCK verdicts; the
  "Excluded" table now has a distinct row type for push-failed aliases, making every
  manifest entry visible in the updated PR description.
- **Phase 1b Step H — manifest persistence:** a temp file write (`/tmp/dep-review-<PR>-
  manifest.json`) added after the manifest JSON, with a write-failure fallback; the
  orchestrator dispatch note updated to read the manifest from the file if context was lost.
- **Phase 2 Pass C — commit message data boundary:** the "Data boundary (reinforced)"
  note now names three source categories: package diff, changelog entries, and commit
  messages; free-form commit text from potentially adversarial maintainers is now an
  explicitly bounded source.
- **Phase 2 Pass A + Phase 5 — 7-day safety signal:** Pass A now records the new
  version's publication date from the same API response used for version enumeration;
  Phase 5 adds `| New version published < 7 days before PR creation date | +1 |` to the
  scoring matrix with a note distinguishing PR-review mode from Phase 0 proactive mode.

---

## 4.18.0 — Impact Clarity and Comment Integrity (2026-04-22)

Closes five instruction gaps discovered in Run 025: Phase 3 Step A now has explicit
actionable/advisory classification rules for all four symbol categories, Phase 5 scoring
matrix covers the all-pending Phase 1 CI state, Phase 3 Step D propagates the Phase 2
enumeration failure warning into the published impact table, Phase 6 Step B sanitises
aliases containing slashes before constructing the temp file path, and Phase 6 Step A
defines the correct source for the commit short-hash used in PR comment headers.

- **Phase 3 Step A — actionable/advisory classification:** a classification paragraph
  after the four-category list now explicitly labels each category — removed APIs and
  CVE patterns in active use are always actionable; deprecated APIs are advisory;
  changed-signature usages are actionable only if a code change is required, advisory
  otherwise; agents now have a consistent basis for the must-fix count that drives Phase 4
  and Phase 5.
- **Phase 5 scoring matrix — all-pending Phase 1 CI row:** `| CI was all-pending at
  Phase 1 (no checks had completed when Phase 1 ran) | 0 |` added immediately after the
  "CI was passing" row, with a clarifying note distinguishing it from the Phase 4
  re-check pending signal (+2); agents no longer improvise or misapply the re-check row.
- **Phase 3 Step D — enumeration failure warning in impact table:** a conditional
  `### Enumeration Warning` section added to the impact table template; when Phase 2
  recorded the enumeration fallback, the warning now propagates to the published PR
  comment via the Phase 6 impact table.
- **Phase 6 Step B — alias filename sanitisation:** a `tr '/' '-'` instruction and
  `ALIAS_SAFE` variable added before the heredoc; GitHub Actions aliases (`owner/action`)
  no longer produce an invalid temp file path that would fail every GitHub Actions bump.
- **Phase 6 Step A — commit short-hash source defined:** a blockquote before the comment
  template now specifies that `<short-hash>` is the original cherry-picked bump commit
  from Phase 1b Step I, not the current isolated branch HEAD (which may be a Phase 4
  remediation commit).

---

## 4.17.0 — Routing Rules and Resilience Paths (2026-04-21)

Closes five instruction gaps discovered in Run 024: Phase 0 Step D now has an explicit ecosystem-to-function routing rule for the batch lookup script, Phase 0 Step H handles non-interactive contexts when an existing proactive PR is detected, Phase 5 scores version downgrades explicitly, Phase 8 Step A stops and reports rather than silently proceeding after a failed reset, and Phase 2 Pass A has a terminal fallback for the case where version enumeration fails across all strategies.

- **Phase 0 Step D — ecosystem routing rule:** two sentences before the batch script example now map `ecosystem = gradle-plugin` to `fetch_plugin` and `ecosystem = maven` to `fetch_maven`; agents no longer need to infer the mapping from the example alone, preventing incorrect registry queries for plugins published to both Maven Central and the Gradle Plugin Portal.
- **Phase 0 Step H — non-interactive default:** a third conditional branch covers the case where no interactive channel is available (sub-agent, CI context); agents now proceed with creating a new PR rather than stalling indefinitely, mirroring the equivalent clause in Phase 1b Step D.
- **Phase 5 scoring matrix — version downgrade row:** `| Version downgrade | +2 |` added after the patch bump row, with a clarifying note explaining when to apply the signal; agents previously had no prescribed score for a `change_type = downgrade` input from Phase 1.
- **Phase 8 Step A — reset failure handling:** an explicit stop-and-report clause fires if `git reset --hard` exits non-zero or the subsequent log check shows the tip does not match the base; prevents a corrupted tree from propagating through the merge loop and force-push.
- **Phase 2 Pass A — enumeration terminal fallback:** step 5 added to the version enumeration list covers the case where all five strategies (npm, Maven, PyPI, Cargo, GitHub Releases) fail to return a version list; agents now assume single-version span, record a warning, and proceed rather than halting or silently skipping aggregation.

---

## 4.16.0 — Edge-State Completeness and Step Clarity (2026-04-20)

Closes five instruction gaps discovered in Run 023: Phase 7's integration-test line now covers bisection-inconclusive outcomes, Phase 1 Step G handles a purely-pending CI state without misreporting it as failing, Phase 7 Step D skips redundant output for proactive all-blocked runs, Phase 4 Step F has an ordering note explaining why it precedes Step E, and Phase 3 Step C checks additional licence file paths.

- **Phase 7 full template — bisection inconclusive variant:** the integration tests line now has two conditional forms — "Regression introduced by `<alias>`" when Phase 8 bisection identified a single introducer, and "Regression source inconclusive — multiple aliases may interact" when Phase 8 reported no single introducer; previously agents had no template for the inconclusive state.
- **Phase 1 Step G — pending-only CI handling:** a new case between "all pass" and "one or more failing or pending" handles the state where every check is still in progress; agents now record "CI status: pending — no results yet" rather than incorrectly writing "CI is FAILING."
- **Phase 7 Step D — proactive all-blocked skip:** an explicit callout at the top of Step D instructs agents to skip the user report when all aliases were blocked and Phase 8 already closed the PR and reported the outcome; prevents redundant output after the all-skipped early exit.
- **Phase 4 Step F — step ordering note:** a note explains that Step F (Force-Push) intentionally precedes Step E (Remediation Summary) in the file so the summary can reference the final pushed state; clarifies the non-sequential F→E lettering.
- **Phase 3 Step C — licence file paths:** expanded the project-licence lookup list from three paths (`LICENSE`, `LICENSE.md`, `package.json`) to six, adding `LICENSE.txt`, `COPYING`, and `LICENCE`; covers GPL projects and British-spelling conventions.

---

## 4.15.0 — Consolidation Hardening and CI Scope Clarity (2026-04-20)

Closes five instruction gaps discovered in Run 022: Phase 8 now explicitly skips `push_failed: true` manifest entries before attempting a merge, Phase 5 covers the CI "pending" state in its scoring matrix, Phase 4's CI re-check step clarifies that `gh pr checks` targets the PR head branch (not the isolated branch), Phase 7 has explicit instructions for populating `push_failed` rows in the alias table, and the Phase 8 Step G admonition now lists only valid skip reasons.

- **Phase 8 Step B — push_failed guard:** a new first check skips any manifest entry with `push_failed: true` before attempting `git merge`; previously an agent would try to merge a non-existent isolated branch and error out.
- **Phase 5 scoring matrix — CI pending row:** new row "+2 re-check result pending or unavailable" covers the case where Phase 4 Step D.1 returns "pending"; agents previously had no prescribed score for this state and improvised.
- **Phase 4 Step D.1 — CI re-check scope note:** added a callout explaining that `gh pr checks` targets the PR head branch commit (pre-remediation) not the isolated branch; agents must record the data source in the Remediation Summary so Phase 5 knows the scope.
- **Phase 7 Step B — push_failed row instruction:** explicit prose added before the alias table template; agents now have a stated rule for when to include `push_failed: true` rows rather than inferring from the template alone.
- **Phase 8 Step G admonition — accurate skip reasons:** removed "merge conflict" (conflicts are resolved in Step B.4, not skipped); updated reason column to `push_failed: true / Phase 5 BLOCK / unverified` and updated next-steps to match.

---

## 4.14.0 — Verified Annotations and Resilient Scoring (2026-04-17)

Closes five instruction gaps discovered in Run 021: Phase 0 now verifies changelog URLs before committing annotations, Phase 5 covers all Rook output states and has explicit missing-data fallbacks for all upstream inputs, the Phase 1b manifest schema documents the `push_failed` field, and Phase 8 surfaces skipped aliases to users with prescribed next steps.

- **Phase 0 Step E — changelog URL verification:** before annotating each version entry, the agent attempts to fetch the URL; dead or unavailable URLs are flagged with `# unverified` and recorded in the session brief rather than committed silently.
- **Phase 5 scoring matrix — Rook inconclusive and skipped states:** two new rows cover "Rook: inconclusive findings (+1)" and "Rook pass skipped or unavailable (+0)"; previously agents improvised when Rook produced no definitive output.
- **Phase 5 — missing-data handling section:** explicit defaults for all four upstream inputs (investigation report, Rook report, impact table, remediation summary); Phase 5 no longer stalls on missing upstream data — it applies 0-contribution defaults, adds notes to the verdict block, and proceeds.
- **Phase 1b Step H — push_failed field in manifest schema:** `"push_failed": false` is now a documented optional field in the canonical manifest schema, consistent with Step I's dynamic amendment on push failure.
- **Phase 8 Step G — skipped-alias user notification:** the consolidation summary now includes a conditional `> [!WARNING]` admonition listing each skipped alias, the reason it was skipped, and a specific next-step instruction for each failure mode (merge conflict, BLOCK verdict, push failure).

---

## 4.13.0 — Attribution Clarity and Verification Depth (2026-04-17)

Closes four instruction gaps discovered in Run 020: Phase 6 comments now attribute reviews to the current `/bump-dependencies` skill name rather than the legacy pre-rename identifier, Phase 7's conditional banner guidance is separated from the template body, Phase 0's Plugin Portal version fallback selects the correct "next oldest" release by sorting before choosing, and Phase 1b's isolated branch verification now confirms the cherry-picked commit matches the expected alias.

- **Phase 6 Step A — correct skill attribution:** comment template updated from `/review-dependency-update` (the legacy name) to `/bump-dependencies`; every PR comment generated since v4.0.0 carried a stale reference to a non-existent slash command.
- **Phase 7 Step B — template-guidance separation:** conditional inclusion logic for the exclusion banner moved outside the fenced template block as explicit prose; HTML comment delimiters that conflated agent directives with literal PR comment content have been removed from inside the template.
- **Phase 0 Step D — Plugin Portal fallback sort instruction:** the `maven-metadata.xml` version list is now explicitly sorted in descending semantic version order before pre-release exclusion and the 7-day safety check are applied; previously the selection was order-dependent on the XML source.
- **Phase 1b Step I — alias content verification:** post-creation check now verifies that the extra commit on each isolated branch references the expected alias in its message; a cherry-pick error previously produced a structurally valid branch with wrong content that passed the existing structural check.

---

## 4.12.0 — API Pagination and Branch Hygiene (2026-04-15)

Closes five instruction gaps discovered in Run 17: Phase 2 now paginates its GitHub Releases API calls for complete intermediate-version enumeration, the Phase 5 data-source note uses the exact Phase 2 record format, orphaned branches are cleaned up when a prior proactive PR is reused, merged C.4 entries are annotated in the PR body, and the C.5 deduplication step handles version-drift between TOML and build script.

- **Phase 2 Pass A — paginated GitHub Releases calls:** `--paginate` added to both the Multi-Version Span Detection call and the changelog fallback call; packages with more than 50–100 releases previously had intermediate versions silently truncated.
- **Phase 5 Step C — exact Phase 2 record anchor:** data-source note updated from the vague "multi-version span section" to the exact `Multi-version span detected:` record format, making the cross-reference deterministic for sub-agents.
- **Phase 0 Step H — orphaned branch cleanup on PR resume:** when the user elects to resume an existing proactive PR, the newly-pushed BUMP_BRANCH is now explicitly deleted from the remote before proceeding to Step I.
- **Phase 0 Step H — merged C.4 annotation in PR body:** PR body bump table note updated to annotate the TOML alias row with a parenthetical when a C.4 build script variable was merged into it via Step C.5 (e.g. `kotlin (also updates \`kotlinVersion\` in \`build.gradle.kts\`)`).
- **Phase 0 Step C.5 — version drift handling:** explicit tiebreak added for when the C.4 variable and C.1 alias resolve to the same coordinates but list different current versions; TOML is authoritative and the discrepancy is surfaced in the Step I summary.

---

## 4.11.0 — Pagination, Deduplication, and Comment Scope Clarity (2026-04-15)

Closes five instruction gaps discovered in Run 16: bare-SHA fallback now paginates the tag list API, cross-source TOML/build-script deduplication prevents double-bumping identical coordinates, the Phase 5 verdict block has an explicit data source for the intermediate version list, single-alias Phase 7 comments are scoped down when only integration test results need surfacing, and a title-based check prevents duplicate proactive bump PRs across runs.

- **Phase 0 Step D — paginated bare-SHA fallback:** `--paginate` added to the GitHub API call that searches for a tag matching a bare SHA; repos with many tags silently missed without it.
- **Phase 0 Step C.5 — cross-source deduplication:** new step between C.4 and D compares Step C.4 variables against Step C.1 aliases by resolved Maven coordinates; duplicates are folded into the alias entry's edit scope and removed from the standalone C.4 list, preventing double lookup, bump, and commit sequences for the same `group:artifact`.
- **Phase 5 Step C — intermediate version list data source:** explicit note added before the verdict block template stating that `<v1>, <v2>, ...` values come from Phase 2 Pass A (Multi-Version Span Detection), with a fallback path to the session brief file.
- **Phase 7 Step B — single-alias integration test failure scope:** scope-narrowing note added so that when Steps B–C run solely because Phase 8 integration tests failed on a single-alias PR, the posted comment is reduced to integration result + bisect finding only, avoiding duplication of the Phase 6 per-bump detail.
- **Phase 0 Step H — cross-run proactive PR deduplication:** title-based open-PR check added before the branch-specific check; if a previous proactive bump PR is open under a different branch name, the user is prompted to choose between resuming it or creating a new one.

---

## 4.10.0 — Edge Case Completeness (2026-04-15)

Closes five instruction gaps discovered in Run 15: single-alias PR integration results now reach the PR, the multi-version span threshold is consistent across all three locations that define it, bare-SHA fallback resolves the unhandled non-match case, proactive all-blocked PRs clean up their remote branch, and the Step H PR body gains the C.4 variable format note.

- **Phase 7 — single-alias Phase 8 surfacing:** the skip condition for single-alias PRs now checks whether Phase 8 integration tests passed; if tests failed, Steps B–C are executed to post the bisect finding as a PR comment rather than silently dropping it.
- **Phase 5 — multi-version span threshold:** scoring matrix row updated from ≥3 to ≥2 intermediate versions, aligning with Phase 2's definition and Phase 5's own explanatory note. Explanatory note cross-references Phase 2 explicitly.
- **Phase 0 Step D — bare-SHA fallback:** GitHub Actions with bare-SHA pins that do not match any tagCommit.oid in the GraphQL response now have an explicit API fallback path, with a dereference step for annotated tags and a conservative "treat as upgradeable" path if still unresolved.
- **Phase 8 Step F — proactive all-blocked cleanup:** the all-skipped early exit path now explicitly deletes the remote PR head branch after closing the proactive PR, preventing dangling `deps/auto-bump-<date>` branches on the remote.
- **Phase 0 Step H — PR body C.4 format:** PR body bump table template now includes the `<varName> (<script-file>)` format note for root build script variable entries, matching the Step I format added in v4.8.0.

---

## 4.9.0 — Orchestration Robustness (2026-04-15)

Closes four instruction gaps in the parallel wave orchestration: proactive-mode detection now uses an unambiguous operator, the non-agent fallback no longer re-runs completed phases, Wave 1 agent failures have an explicit recovery path, and standalone root build script bumps have a defined commit position.

- **Phase 7 & Phase 8 — proactive-mode detection:** "matches" replaced with "starts with" in all three proactive-PR detection conditions; eliminates the risk that agents interpreting exact equality fail to detect date-suffixed PR titles.
- **Orchestrator Wave 3 non-agent fallback:** guard added to start from Phase 4 when Wave 1 already ran Phases 2–3 sequentially, preventing double-execution of investigation phases.
- **Orchestrator Wave 1 agent dispatch:** explicit recovery instruction added for silent agent failure — aliases that do not return a Phase 3 impact table are flagged and queued for manual Phase 4 rather than silently dropped.
- **Phase 0 Step G — commit ordering:** standalone root build script variable bumps (Step C.4 entries with no TOML alias counterpart) added as item 2 in the ordering list, closing the gap left when Step F gained C.4 editing rules in v4.7.0.

---

## 4.8.0 — Step Zero Completeness (2026-04-15)

Closes two representation gaps in Phase 0 left open after the H45–H49 root build script additions: the Step I summary table now names the identifier format for variable-name entries, and Step D now states the 7-day safety threshold as explicit arithmetic.

- **Step I — root build script identifier format:** placeholder updated to `<alias/action/var>`; note added specifying `<varName> (<script-file>)` format (e.g., `kotlinVersion (build.gradle.kts)`) with reference to Step F.
- **Step D — safety window formula:** qualitative "older than seven days" anchor replaced with `release_date ≤ (BUMP_DATE − 7 days)`; explicit note that the anchor is BUMP_DATE, not script execution time.

---

## 4.7.0 — Orchestration Clarity and Workflow Completeness (2026-04-14)

Closes three instruction gaps that could cause agents to stall or behave ambiguously,
and completes the Step F editing coverage opened by the H45 root build script discovery.

- **Step F — root build script editing rules:** Kotlin DSL and Groovy DSL in-place variable update patterns; no trailing comments to avoid `buildSrc` parsing issues; changelog URL carried via Step I summary and PR body.
- **Phase 8 Step D — integration failure push rationale:** explicit continuation note confirming Phase 8 proceeds to force-push after bisect regardless of test result; Phase 7 surfaces the finding for human decision.
- **Phase 1b Step D — automated mode detection:** "fully automated mode with no user present" replaced with runtime-observable context properties (subagent dispatch, non-interactive CI context).
- **optimise pattern library — P18 promoted:** Cross-File Structural Anchor added to `p3-hypothesize.md` after three consecutive run cycles as a logged seed candidate.

---

## 4.6.0 — Phase 0 Completeness and Resilience (2026-04-14)

Completes Phase 0's source coverage, surfaces silent failures, and adds
ecosystem-specific guidance throughout Step D and Step G.

- **Step C.4 — root build script extraction:** Kotlin DSL and Groovy version
  variable declarations are now parsed and recorded; projects with legacy
  root-level version declarations are no longer silently excluded
- **Step D — batch lookup failure recovery:** dependencies missing from batch
  output (network error, API timeout) are now recorded as Skipped (lookup failed)
  in the Step I summary and PR body rather than silently treated as up-to-date
- **Step C.1 — BOM alias guidance:** BOM/indirect aliases now include a PR body
  note recommending manual transitive-dependency review
- **Step G — ecosystem commit body note:** explicit guidance on which ecosystems
  (GitHub Actions) provide API release descriptions vs. which do not (Maven, Gradle
  Portal, Gradle wrapper)

---

## 4.5.0 — Discovery Coverage and PR Transparency (2026-04-14)

Expands Phase 0 coverage to Gradle composite builds, improves PR body transparency,
completes commit message format parity, and fixes stale orchestrator references.

- **Step C composite-build glob:** catch-all `**/libs.versions.toml` scan added after
  the two hardcoded paths — projects with version catalogues under `build-logic/` or
  `buildSrc/` are now included in the proactive bump scope
- **Step H PR body skip summary:** "Dependency scan summary" table added to the PR body
  template — reviewers can now see all five skip categories alongside bumped dependencies
- **Step G wrapper example:** Gradle wrapper commit message example added for format
  parity with `libs.versions.toml` and GitHub Actions examples
- **Phase comment headers:** seven phase files (p1–p6) updated from the pre-v4.0.0
  `review-dependency-update.md` reference to `bump-dependencies.md`

---

## 4.4.0 — Safe Discovery Hardening (2026-04-14)

Hardens Phase 0's version discovery against pre-release versions, incorrect direction
bumps, duplicate PR creation, and ambiguous cross-file references.

- **Step D pre-release exclusion:** Maven batch and Gradle Plugin Portal fallback now
  explicitly discard versions with `-alpha`, `-beta`, `-rc`, `-SNAPSHOT`, `-M[0-9]`,
  or `-milestone` suffixes; GitHub Actions GraphQL requests the `isPrerelease` field
  and skips pre-release releases during parse
- **Step F monotonicity guard:** explicit `safe_latest > current_version` comparison
  added before any file edit; dependencies already ahead of the safe latest are skipped
  and reported as "Skipped (already at safe latest)" in the Step I summary
- **Step H PR deduplication:** `gh pr list --head <BUMP_BRANCH>` check added before
  `gh pr create`; if an open PR already exists it is reused, preventing duplicate PRs
  on back-to-back runs
- **Step E structural anchor:** cross-file reference to Phase 2's changelog source table
  now names the exact section heading (`### Kotlin/Android primary sources`) rather than
  "the table section", making the reference stable to future refactoring

---

## 4.3.0 — Blocked Dep Handling (2026-04-13)

Adds prominent blocked-dep messaging and proactive PR lifecycle management for
the case where the review pipeline returns BLOCK verdicts.

- **Phase 8 all-skipped exit:** now branches on mode — proactive PRs are closed
  via `gh pr close` with a comment listing each blocked alias and its reason;
  dependabot/external PRs are left open unchanged (Phase 7 posts the summary)
- **Phase 8 Step E.1 (new):** after a successful force-push on a proactive PR with
  mixed pass/BLOCK results, rewrites the PR description to show only the deps that
  landed, with a prominent `⚠️ Excluded — blocked by review` table listing removed
  deps and a retry instruction
- **Phase 7 Step A:** determines `IS_PROACTIVE` from the PR title before composing
  the comment
- **Phase 7 Step B:** adds an exclusion banner (GitHub `[!WARNING]` callout) at the
  top of the summary comment whenever any alias is BLOCK; wording differs by mode —
  proactive explains the dep was already removed, dependabot/external calls for action
- **Phase 7 Step D:** user-facing output now shows "Merged into PR" vs "Blocked"
  counts and appends a mode-specific follow-up note when any deps were blocked
- Header comments in p7 and p8 updated from `review-dependency-update.md` to
  `bump-dependencies.md`

---

## 4.2.0 — Batch Lookup (2026-04-13)

Replaces serial per-dependency API calls with batched lookups, and removes the
major-version-restriction logic so actions always bump to the global latest safe release.

- **Step C.2:** removed "bump within major only" row — all tag-pinned actions (any
  form) bump to the globally latest safe release and are SHA-pinned
- **Step D (Maven/Gradle Plugin Portal):** serial WebFetch calls replaced with a
  generated parallel shell script (one `curl &` per dependency, single `wait`); emits
  a tab-separated table parsed in one pass; `rows=5` gives fallback versions for the
  7-day check without extra calls; Gradle Plugin Portal version-only API covered with
  `maven-metadata.xml` fallback when the latest is too recent
- **Step D (GitHub Actions):** serial REST calls replaced with a single GraphQL query
  covering all distinct action repos; `tagCommit.oid` resolves SHA inline — no second
  round-trip; bare-SHA version identification uses already-fetched GraphQL data; single
  per-action fallback only when `tagCommit` is null (annotated tag edge case)
- **Step D (Gradle Wrapper):** unchanged — already a single call

---

## 4.1.0 — SHA Everything (2026-04-13)

Expands Phase 0 action scanning to include local composite actions, and replaces the
SHA-skip rule with SHA-pin-and-bump: every GitHub Action is now updated to the latest
safe release and written in `owner/action@<sha> # <tag>  <changelog_url>` format.

- **Step C:** added `.github/actions/**/action.yml` / `action.yaml` to the scan list —
  local composite action files may reference external actions and were previously missed
- **Step C.2:** removed the "skip SHA-pinned refs" rule; SHA-pinned actions are now
  bumped like any other entry; bare-SHA entries without a tag comment have their current
  version identified via the API before bumping
- **Step D (GitHub Actions):** SHA resolution step added — after identifying the safe
  target tag, resolves it to a commit SHA via the git refs API (handles both lightweight
  and annotated tags); bare-SHA entries without a tag comment are also resolved back to
  a human-readable tag for the summary table
- **Step F (GitHub Actions editing rules):** target format is now
  `owner/action@<sha> # <tag>  <changelog_url>` — single rewrite converts both
  tag-pinned and SHA-pinned entries into the canonical form
- **Step I summary:** removed "Skipped (SHA pin)" row — no longer applicable
- **Orchestrator DO NOT:** tightened wording — no mention of SHA-pin skipping

---

## 4.0.0 — Proactive Bumper (2026-04-13)

Breaking rename: skill renamed from `review-dependency-update` to `bump-dependencies`.
Adds a no-argument proactive mode (Phase 0) that discovers outdated dependencies,
annotates version definitions with changelog hyperlinks, bumps each to the latest safe
release, and opens a PR before handing off to the existing review pipeline.

- **Rename:** directory, SKILL.md, AGENTS.md, orchestrator file, and all internal paths
  updated from `review-dependency-update` to `bump-dependencies`
- **Phase 0 (`p0-bump.md`):** scans `libs.versions.toml`, `.github/workflows/*.yml`,
  and `gradle/wrapper/gradle-wrapper.properties` for outdated dependencies; resolves
  each alias to Maven / Gradle Plugin Portal / GitHub Releases coordinates; checks
  publication date and skips versions newer than seven days (supply-chain safety); adds
  or updates an inline `# <changelog-url>` comment on each version line; commits each
  bump atomically; pushes a `deps/auto-bump-YYYY-MM-DD` branch and opens a PR
- **Orchestrator:** mode-selection section added — no argument → Phase 0 then Phase 1;
  argument provided → Phase 1 directly; `argument-hint` updated to `[PR-number]`
- **Ink persona** added to Phase 0 active-phases list
- **AGENTS.md:** scope updated to `bump-deps`; bump commit pattern documented

---

## 3.9.0 — Summary as Entry Point (2026-04-13)

Phase 7 summary now serves as a navigation guide: tells the reviewer which
per-bump comments are worth opening and why, rather than just restating verdicts.

- **Remediations applied section:** lists every commit where code was written on
  the reviewer's behalf (hash + one-line description) so they know what to
  scrutinise; `_None required._` when Phase 4 made no commits
- **Worth a closer look section:** flags non-blocking items that warrant attention
  — auto-migrated breaking changes (verify correctness), supply-chain concerns,
  APPROVE WITH CONDITIONS rationale, partial remediations, unresolved deprecations;
  `_Nothing flagged._` when clean
- **Needs human action:** unchanged — explicit decisions or manual work required
  before merge
- Step A updated to collect remediations and notable findings alongside verdicts

---

## 3.8.0 — Concise Run Summary (2026-04-13)

Phase 7 summary comment radically simplified. The old template restated all
per-bump detail already present in the Phase 6 comments; the new one is a
navigator only.

- **Skip when N=1:** if only one alias was reviewed, Phase 7 is not posted —
  the Phase 6 comment is already complete
- **Removed:** CI status table, supply-chain table, breaking-changes table,
  remediation table, and plain-English paragraph — all duplicated per-bump data
- **Kept:** verdict-per-alias table (single-glance overview), integration test
  result (new info not in per-bump comments), "needs human action" bullet list
  (distilled actionable items), overall recommendation
- **Step A** simplified to collect only what the new template needs

---

## 3.7.0 — Direct Head Branch Consolidation (2026-04-10)

Phase 8 no longer creates a separate `dep-review/<PR-number>/consolidated` working
branch. Instead it resets the PR head branch to base and merges the isolated
branches directly onto it — eliminating the extra branch, simplifying cleanup,
and keeping local/remote names in sync throughout.

- **Step A:** replaced "create dep-review/.../consolidated from base" with
  "fetch + checkout head-branch, reset --hard to origin/<base-branch>"
- **Step E:** push is now `git push --force-with-lease origin <head-branch>`
  directly (was a cross-ref push from consolidated → head-branch); force-push
  is still required because Step A rewrites history past the original dependabot
  commits
- **Step F:** simplified — only isolated branches need deleting (remote + local);
  no consolidated branch to clean up; checkout base then delete local head-branch
- **Orchestrator:** updated pipeline diagram and Phase 8 description to match

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
