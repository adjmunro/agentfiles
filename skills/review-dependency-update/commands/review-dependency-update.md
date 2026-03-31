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
[Parallel Dispatch] ─── agent-1: bump-A ──► [Phase 2 → 3 → 4? → 5 → 6]
                    ├── agent-2: bump-B ──► [Phase 2 → 3 → 4? → 5 → 6]
                    └── agent-N: bump-N ──► [Phase 2 → 3 → 4? → 5 → 6]
```

Each agent runs Phases 2–6 independently for one version-catalog alias (or groupId).
Each agent posts its own PR comment. There is no final aggregation step.

## Phase Dispatch Table

| Phase | File | Active when |
|---|---|---|
| 1 | `phases/p1-parse.md` | command is first invoked |
| 1b | `phases/p1b-split-commits.md` | Phase 1 complete; always runs as a check |
| — | **Parallel Dispatch** | Phase 1b manifest produced |
| 2 | `phases/p2-investigate.md` | per-agent: investigate this bump |
| 3 | `phases/p3-impact.md` | per-agent: Phase 2 complete |
| 4 | `phases/p4-remediate.md` | per-agent: Phase 3 found actionable usages |
| 5 | `phases/p5-verdict.md` | per-agent: Phase 3 complete (and Phase 4 if it ran) |
| 6 | `phases/p6-comment.md` | per-agent: Phase 5 verdict written |

## Parallel Dispatch

After Phase 1b produces the atomic commit manifest, dispatch one agent per entry.

**If the Agent tool is available** — launch all agents concurrently in a single
message. Each agent receives this prompt:

> You are reviewing a single dependency bump on PR <number> in <owner/repo>.
> Your bump: alias `<alias>`, packages `<packages>`, plugins `<plugins>`,
> version `<old>` → `<new>`, commit `<hash>`.
> Read `phases/p2-investigate.md` and execute Phases 2–6 in sequence for this bump.
> Post your own PR comment at the end (Phase 6).

**If the Agent tool is not available** — run Phases 2–6 sequentially for each
entry in the manifest, in order.

## Execution

Read Phase 1 file now: `phases/p1-parse.md`
Execute it completely. Then read the next phase file as instructed at the end of each file.
Each phase file ends with a `→ Next` line pointing to the next phase.
