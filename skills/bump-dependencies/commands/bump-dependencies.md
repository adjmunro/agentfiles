---
model: claude-sonnet-4-6
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch, WebSearch, Agent
argument-hint: "[PR-number]"
---

<!-- Phase dispatcher. Contains only boot logic and phase dispatch.
     All phase instructions live in phases/ subdirectory files.
     Read only the current phase file on entry — do not preload future phases. -->

# Bump Dependencies — Orchestrator

Primarily designed for Kotlin/Android projects using Gradle with a
`libs.versions.toml` version catalogue.

## Personas

Read each file before the phase in which it is active:

- `../../personas/examiner/persona.md` — **Echo (Examiner)** — active in Phase 2 (investigation) and Phase 3 (impact mapping)
- `../../personas/adversarial/persona.md` — **Rook (Adversary)** — active in Phase 2 security pass
- `../../personas/ink/persona.md` — **Ink (Commit Curator)** — active in Phase 0 (proactive bumps), Phase 1b (commit splitting), and Phase 4 (remediation commits)
- `../../personas/critic/persona.md` — **Arden (Critic)** — active in Phase 5 (verdict)

Identify by the active persona when communicating with the user. Switch personas at phase boundaries as declared.

## Mode Selection

**Check the argument before doing anything else.**

- **Argument provided** (e.g. `1509`, `#1509`, a full GitHub URL): this is **PR-review mode**.
  Strip any prefix, extract the bare PR number, and proceed directly to Phase 1 (see Execution below).

- **No argument**: this is **proactive mode**.
  Read `phases/p0-bump.md` and execute it completely. Phase 0 discovers outdated
  dependencies, bumps each one atomically, opens a PR, and outputs a PR number.
  After Phase 0 completes, use the PR number it produced and proceed to Phase 1.

## Input Normalisation (PR-review mode)

The argument is a bare PR number (e.g., `1509`). Hash-prefixed (`#1509`) and full
GitHub URLs are also accepted as fallbacks — strip the prefix and extract the number.

Always infer `owner/repo` from the current repository: `git remote get-url origin`.

## DO

- Complete each phase fully before reading the next phase file
- Make only necessary code changes; do not refactor surrounding code or expand scope
- Commit each bump or remediation fix atomically (one fix, one commit) before moving to the next
- Each bump commit gets exactly one PR comment — do not aggregate

## DO NOT

- Skip Phase 3 impact mapping even if Phase 2 reports no breaking changes — silent regressions often hide in minor version bumps
- Modify source code during Phase 2 or Phase 3 — Echo and Rook are read-only passes
- Abandon the pipeline on a single failing dependency — flag it and continue to the next
- Bump any dependency to a version published less than seven days ago — see Phase 0 for the supply-chain safety rule

---

```
[Phase 0: Discover & Bump] ← proactive mode only; produces a PR number
        │
        ▼ (PR number in scope — either from Phase 0 or from the argument)
[Phase 1: Parse & Fetch]
        │
        ├── Step G: Fetch CI check status
        │           ├── All pass → note in brief, continue
        │           └── Failures → triage, classify, append to brief
        ▼
[Phase 1b: Split Commits?] ← Ink — skip if already atomic; produces manifest
        │   Step I: create one isolated branch per alias from base branch
        │           dep-review/<PR-number>/<alias> ← cherry-pick alias commit
        ▼
[Wave 1: Parallel Investigation] ─── agent-1: bump-A ──► [Phase 2 → 3] on isolated branch  ─┐
                                 ├── agent-2: bump-B ──► [Phase 2 → 3] on isolated branch  ─┤
                                 └── agent-N: bump-N ──► [Phase 2 → 3] on isolated branch  ─┘
                                                                                               │ (all P2-3 done)
                                                                                               ▼
                                              [Wave 2: Sequential Remediation]
                                              Each agent works on its own isolated branch:
                                              Step A.1: merge CI failures into must-fix list
                                              bump-A → bump-B → bump-N (one at a time)
                                              Step D.1: re-check CI after commits
                                              Step F: force-push isolated branch
                                                              │
                                                              ▼
                                              [Wave 3: Parallel Verdict and Comment] ─── agent-1 ──► [Phase 5 → 6] on isolated branch
                                                              ├── agent-2 ──► [Phase 5 → 6] on isolated branch
                                                              └── agent-N ──► [Phase 5 → 6] on isolated branch
                                              (Phase 5: CI hard block if failures unresolved)
                                                              │ (all P5-6 done)
                                                              ▼
                                              [Wave 4: Consolidation — Orchestrator]
                                              Phase 8: reset PR head branch to base
                                              Merge verified isolated branches → PR head branch
                                              Full integration test suite on PR head branch
                                              Bisect on failure to identify regression introducer
                                              Force-push PR head branch
                                              Delete all isolated branches (remote + local)
                                                              │
                                                              ▼
                                              [Wave 5: Summary — Orchestrator]
                                              Phase 7: single consolidated PR comment
```

Phases 2–3 (read-only investigation) run in parallel, each on its own isolated branch.
**Phase 4 (remediation commits) runs sequentially** — git operations are not concurrency-safe — but each agent operates only on its own isolated branch, eliminating cross-contamination.
Phases 5–6 (verdict and comment) resume in parallel after all Phase 4 work is done.
**Phase 8 (consolidation) runs once, orchestrator-only**, merging all verified isolated branches and replacing the PR head branch.

## Phase Dispatch Table

| Phase | File | Concurrency | Active when |
|---|---|---|---|
| 0 | `phases/p0-bump.md` | Sequential | proactive mode only (no argument) |
| 1 | `phases/p1-parse.md` | Sequential | command is first invoked (or after Phase 0) |
| 1b | `phases/p1b-split-commits.md` | Sequential | Phase 1 complete; always runs as a check; creates isolated branches |
| — | **Wave 1: Parallel Investigation** | — | Phase 1b isolated branches created |
| 2 | `phases/p2-investigate.md` | **Parallel** | per-agent: investigate this bump on isolated branch |
| 3 | `phases/p3-impact.md` | **Parallel** | per-agent: Phase 2 complete |
| — | **Wave 2: Sequential Remediation** | — | All Wave 1 agents complete |
| 4 | `phases/p4-remediate.md` | **Sequential** | Phase 3 found actionable usages; one bump at a time on isolated branch |
| — | **Wave 3: Parallel Verdict and Comment** | — | All Phase 4 work committed |
| 5 | `phases/p5-verdict.md` | **Parallel** | per-agent: Phase 4 complete (or skipped) |
| 6 | `phases/p6-comment.md` | **Parallel** | per-agent: Phase 5 verdict written |
| — | **Wave 4: Consolidation** | — | All Wave 3 agents complete |
| 8 | `phases/p8-consolidate.md` | **Sequential (orchestrator)** | all Phase 6 comments posted; merges isolated branches, replaces PR head |
| — | **Wave 5: Summary** | — | Phase 8 consolidation complete |
| 7 | `phases/p7-summary.md` | **Sequential (orchestrator)** | Phase 8 complete; posts final PR comment |

## Parallel Dispatch

After Phase 1b produces the atomic commit manifest, follow the two-wave protocol.
If the manifest is not in context (e.g., session resumed after interruption), read it
from `/tmp/dep-review-<PR-number>-manifest.json` before dispatching.


### Wave 1 — Parallel Investigation (Phases 2–3)

**Before dispatching**, exclude any manifest entries where `push_failed: true` — these
aliases have no isolated branch and cannot be investigated. Dispatch only entries without
this flag.

**If the Agent tool is available** — launch all agents concurrently in a single
message. Each agent receives this prompt:

> Re-read `/tmp/dep-review-<PR-number>-session-brief.md` now to re-anchor to the
> original PR context before beginning. If the file is not found (session resumed after
> restart), use the PR context below as your intent anchor.
>
> You are reviewing a single dependency bump as part of PR <number> (<PR URL>) in
> <owner/repo>. Base branch: `<base-branch>`. Head commit for this bump: `<hash>`.
> PR title: `<title>`. Ecosystem: `<ecosystem>`.
> Your bump: alias `<alias>`, packages `<packages>`, plugins `<plugins>`,
> version `<old>` → `<new>`.
> Cross-bump constraints for this alias: `<cross_bump_constraints, or "none">`.
> Your isolated branch: `dep-review/<PR-number>/<alias>` — all investigation and
> testing for this bump operates on this branch. Do not check out or modify any
> other branch.
> Phase files are in `skills/bump-dependencies/commands/phases/` from repo root.
> **Execute Phases 2 and 3 only.** Do NOT run Phase 4, 5, or 6 yet.
> Return your Phase 3 impact table (actionable usages count, advisory count, files affected).

**If the Agent tool is not available** — run Phases 2–3 sequentially for each
entry in the manifest, collecting impact tables before proceeding to Wave 2.

After all agents complete (or sequential runs finish): verify that a Phase 3 impact
table was received for every dispatched alias. If any agent did not return one (silent
failure or crash), treat that alias as having unknown must-fix status — flag it
explicitly in the manifest and run Phase 4 manually for it before proceeding to Wave 3.

### Wave 2 — Sequential Remediation (Phase 4)

**Phase 4 must run sequentially across bumps — never concurrently.**

For each bump that has actionable usages (must-fix items), run Phase 4 in manifest
order. Only start the next bump's Phase 4 after the previous one's commits are pushed.

Reason: concurrent `git commit` and `git push` operations on the same branch produce
race conditions — commits can be lost or the push rejected.

**After each Phase 4 run completes**, extract the remediation commit hashes from its
Remediation Summary (Step E — the commit hash column). Record them in an accumulator
keyed by alias:

```
remediation_hashes = {
  "<alias>": ["<short-hash-1>", "<short-hash-2>"],   # commits from Phase 4
  "<alias-no-fix>": [],                               # Phase 4 skipped or no commits
}
```

Use this accumulator when building the Wave 3 agent prompts — it supplies the
`Phase 4 remediation commits for your bump` field. If Phase 4 was skipped for an alias
(no actionable usages), record an empty list and pass `none` in the Wave 3 prompt.

### Wave 3 — Parallel Verdict and Comment (Phases 5–6)

After all Phase 4 work is complete, re-launch agents (or resume sequentially) to
run Phases 5–6 for each bump. Each agent receives the same prompt as Wave 1 plus:

> Re-read `/tmp/dep-review-<PR-number>-session-brief.md` now to re-anchor to the
> original PR context before beginning. If the file is not found, use the PR context
> in this prompt as your intent anchor.
>
> Your isolated branch: `dep-review/<PR-number>/<alias>` — all verdict work for
> this bump is based on the state of this branch. Do not check out or modify any
> other branch.
> Phase 4 remediation commits for your bump: <comma-separated hashes, or "none">.
> Execute Phases 5 and 6 only. Post your own PR comment at the end.
> **Return your Phase 5 verdict block as the final line of your output message.**

**If the Agent tool is not available** — run Phases 4–6 sequentially for each entry
in the manifest, in order. If Wave 1 was also non-agent (Phases 2–3 not yet run),
start from Phase 2 instead — but do not re-run Phases 2–3 if Wave 1 already ran them.
(Phase 4's one-bump-at-a-time sequencing requirement is automatically satisfied by
this serialisation — no additional sequencing step is needed.)

### Wave 4 — Consolidation (Phase 8)

After all Wave 3 agents have completed and all per-bump Phase 6 comments are posted,
the **orchestrator** (not a sub-agent) executes Phase 8. This is a sequential,
orchestrator-only step — there is exactly one Phase 8 execution per skill run.

Read `phases/p8-consolidate.md` and execute it. Phase 8:
1. Resets the PR head branch to base (discarding the original dependabot commits locally)
2. Merges each verified isolated branch into the PR head branch in manifest order
3. Runs the full integration test suite
4. Bisects on failure to identify the regression introducer
5. Force-pushes the PR head branch (required — history was rewritten in step 1)
6. Deletes all isolated branches (remote and local) and the local PR head checkout

The consolidation summary produced by Phase 8 is passed to Phase 7.

**If the Agent tool is not available** — Phase 8 runs immediately after the last
bump's Phase 6 comment is posted, using the data already in scope.

### Wave 5 — Consolidated Summary Comment (Phase 7)

After Phase 8 consolidation is complete, the **orchestrator** executes Phase 7.
This is a sequential, orchestrator-only step — there is exactly one Phase 7
execution per skill run.

**Before reading Phase 7**, ensure Phase 5 verdict data for all bumps is available
in the orchestrator's context:

- **If running with the Agent tool (parallel waves):** require each Wave 3 agent
  to return its Phase 5 verdict block as the final line of its output message.
  The orchestrator accumulates these as agents complete.
- **If running sequentially:** Phase 5 verdict blocks are already in context from
  each bump's sequential execution — no additional step needed.
- **Fallback (parallel, data not in context):** retrieve verdict data from the PR
  comments already posted by Phase 6. Run:
  ```
  gh pr view <PR-number> --repo <owner/repo> --json comments \
    --jq '.comments[] | select(.body | startswith("## Dependency Review:")) | .body'
  ```
  Use this output as the Phase 5 verdict data source.

Read `phases/p7-summary.md` and execute it, using the collected Phase 5 verdict
data and the Phase 8 consolidation summary. The result is a single PR comment that
consolidates all findings, CI outcomes, supply chain signals, remediations,
consolidation results, and verdicts into one place.

**If the Agent tool is not available** — Phase 7 runs immediately after Phase 8
completes, using the data already in scope.

## Execution

**Proactive mode (no argument):** read `phases/p0-bump.md` now and execute it.
After Phase 0 completes, use the PR number it outputs and proceed to Phase 1.

**PR-review mode (argument provided):** read `phases/p1-parse.md` now and execute it.

Then read the next phase file as instructed at the end of each file.
Each phase file ends with a `→ Next` line pointing to the next phase.
