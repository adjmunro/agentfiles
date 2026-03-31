---
model: claude-sonnet-4-6
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch, WebSearch, Agent
argument-hint: "<PR-number>"
---

<!-- Phase dispatcher. Contains only boot logic and phase dispatch.
     All phase instructions live in phases/ subdirectory files.
     Read only the current phase file on entry — do not preload future phases. -->

# Review Dependency Update — Orchestrator

Primarily designed for Kotlin/Android projects using Gradle with a
`libs.versions.toml` version catalog.

## Personas

Read each file before the phase in which it is active:

- `../../personas/examiner/persona.md` — **Echo (Examiner)** — active in Phase 2 (investigation) and Phase 3 (impact mapping)
- `../../personas/adversarial/persona.md` — **Rook (Adversary)** — active in Phase 2 security pass
- `../../personas/ink/persona.md` — **Ink (Commit Curator)** — active in Phase 1b (commit splitting) and Phase 4 (remediation commits)
- `../../personas/critic/persona.md` — **Arden (Critic)** — active in Phase 5 (verdict)

Identify by the active persona when communicating with the user. Switch personas at phase boundaries as declared.

## Input Normalisation

The argument is a bare PR number (e.g., `1509`). Hash-prefixed (`#1509`) and full
GitHub URLs are also accepted as fallbacks — strip the prefix and extract the number.

Always infer `owner/repo` from the current repository: `git remote get-url origin`.

## DO

- Complete each phase fully before reading the next phase file
- Make only necessary code changes; do not refactor surrounding code or expand scope
- Commit each remediation fix atomically (one fix, one commit) before moving to the next
- Each bump commit gets exactly one PR comment — do not aggregate

## DO NOT

- Skip Phase 3 impact mapping even if Phase 2 reports no breaking changes — silent regressions often hide in minor version bumps
- Modify source code during Phase 2 or Phase 3 — Echo and Rook are read-only passes
- Abandon the pipeline on a single failing dependency — flag it and continue to the next

---

```
[Phase 1: Parse & Fetch]
        │
        ▼
[Phase 1b: Split Commits?] ← Ink — skip if already atomic; produces manifest
        │
        ▼
[Parallel Dispatch] ─── agent-1: bump-A ──► [Phase 2 → 3]  ─┐
                    ├── agent-2: bump-B ──► [Phase 2 → 3]  ─┤
                    └── agent-N: bump-N ──► [Phase 2 → 3]  ─┘
                                                              │ (all P2-3 done)
                                                              ▼
                                              [Phase 4: Sequential Remediation]
                                              bump-A → bump-B → bump-N (one at a time)
                                                              │
                                                              ▼
                                              [Parallel Resume] ─── agent-1 ──► [Phase 5 → 6]
                                                              ├── agent-2 ──► [Phase 5 → 6]
                                                              └── agent-N ──► [Phase 5 → 6]
```

Phases 2–3 (read-only investigation) run in parallel across all bumps.
**Phase 4 (remediation commits) runs sequentially** — git operations are not concurrency-safe.
Phases 5–6 (verdict and comment) resume in parallel after all Phase 4 work is done.

## Phase Dispatch Table

| Phase | File | Concurrency | Active when |
|---|---|---|---|
| 1 | `phases/p1-parse.md` | Sequential | command is first invoked |
| 1b | `phases/p1b-split-commits.md` | Sequential | Phase 1 complete; always runs as a check |
| — | **Wave 1 Dispatch** | — | Phase 1b manifest produced |
| 2 | `phases/p2-investigate.md` | **Parallel** | per-agent: investigate this bump |
| 3 | `phases/p3-impact.md` | **Parallel** | per-agent: Phase 2 complete |
| — | **Wave 2: Remediation** | — | All Wave 1 agents complete |
| 4 | `phases/p4-remediate.md` | **Sequential** | Phase 3 found actionable usages; one bump at a time |
| — | **Wave 3 Dispatch** | — | All Phase 4 work committed |
| 5 | `phases/p5-verdict.md` | **Parallel** | per-agent: Phase 4 complete (or skipped) |
| 6 | `phases/p6-comment.md` | **Parallel** | per-agent: Phase 5 verdict written |

## Parallel Dispatch

After Phase 1b produces the atomic commit manifest, follow the two-wave protocol:

### Wave 1 — Parallel Investigation (Phases 2–3)

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
> Phase files are in `skills/review-dependency-update/commands/phases/` from repo root.
> **Execute Phases 2 and 3 only.** Do NOT run Phase 4, 5, or 6 yet.
> Return your Phase 3 impact table (actionable usages count, advisory count, files affected).

**If the Agent tool is not available** — run Phases 2–3 sequentially for each
entry in the manifest, collecting impact tables before proceeding to Wave 2.

### Wave 2 — Sequential Remediation (Phase 4)

**Phase 4 must run sequentially across bumps — never concurrently.**

For each bump that has actionable usages (must-fix items), run Phase 4 in manifest
order. Only start the next bump's Phase 4 after the previous one's commits are pushed.

Reason: concurrent `git commit` and `git push` operations on the same branch produce
race conditions — commits can be lost or the push rejected.

### Wave 3 — Parallel Verdict and Comment (Phases 5–6)

After all Phase 4 work is complete, re-launch agents (or resume sequentially) to
run Phases 5–6 for each bump. Each agent receives the same prompt as Wave 1 plus:

> Re-read `/tmp/dep-review-<PR-number>-session-brief.md` now to re-anchor to the
> original PR context before beginning. If the file is not found, use the PR context
> in this prompt as your intent anchor.
>
> Phase 4 remediation commits for your bump: <comma-separated hashes, or "none">.
> Execute Phases 5 and 6 only. Post your own PR comment at the end.

**If the Agent tool is not available** — run Phases 2–6 fully sequentially for each
entry in the manifest, in order. The serialisation requirement is automatically satisfied.

## Execution

Read Phase 1 file now: `phases/p1-parse.md`
Execute it completely. Then read the next phase file as instructed at the end of each file.
Each phase file ends with a `→ Next` line pointing to the next phase.
