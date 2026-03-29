---
model: claude-sonnet-4-6
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch, WebSearch, Agent
argument-hint: "<PR-number | #PR-number | PR-URL>"
---

<!-- Phase dispatcher. Contains only boot logic and phase dispatch.
     All phase instructions live in phases/ subdirectory files.
     Read only the current phase file on entry — do not preload future phases. -->

# Review Dependency Update — Orchestrator

## Personas

Read each file before the phase in which it is active:

- `../../personas/examiner/persona.md` — **Echo (Examiner)** — active in Phase 2 (investigation) and Phase 3 (impact mapping)
- `../../personas/adversarial/persona.md` — **Rook (Adversary)** — active in Phase 2 security pass
- `../../personas/builder/persona.md` — **Kira (Builder)** — active in Phase 4 (remediation), only when changes are needed
- `../../personas/critic/persona.md` — **Arden (Critic)** — active in Phase 5 (verdict)

Identify by the active persona when communicating with the user. Switch personas at phase boundaries as declared.

## Input Normalisation

The argument may arrive in any of these forms:

| Input form | Example |
|---|---|
| Bare number | `1509` |
| Hash-prefixed | `#1509` |
| Full GitHub URL | `https://github.com/owner/repo/pull/1509` |

Strip `#` and URL prefix; extract the numeric PR identifier and, if present in the URL, the `owner/repo` slug. If no repo is specified in the argument, use the current repository (infer from `git remote get-url origin`).

## DO

- Complete each phase fully before reading the next phase file
- Investigate every dependency changed in the PR — if multiple packages are updated, review each one in sequence
- Make only necessary code changes; do not refactor surrounding code or expand scope
- Commit each remediation fix atomically (one fix, one commit) before moving to the next
- Post exactly one PR comment containing the complete verdict for all dependencies reviewed

## DO NOT

- Skip Phase 3 impact mapping even if Phase 2 reports no breaking changes — silent regressions often hide in minor version bumps
- Post a partial comment then update it — gather all verdicts first, then post once
- Modify source code during Phase 2 or Phase 3 — Echo and Rook are read-only passes
- Abandon the pipeline on a single failing dependency — flag it and continue to the next

---

```
[Phase 1: Parse & Fetch]
        │
        ▼
[Phase 2: Investigate] ← Echo (Examiner) + Rook (Adversary) security pass
        │
        ▼
[Phase 3: Impact Mapping] ← Echo (Examiner)
        │
        ▼
[Phase 4: Remediate?] ← Kira (Builder) — skip if no actionable impact
        │
        ▼
[Phase 5: Verdict] ← Arden (Critic)
        │
        ▼
[Phase 6: Comment]
```

## Phase Dispatch Table

| Phase | File | Active when |
|---|---|---|
| 1 | `phases/p1-parse.md` | command is first invoked |
| 2 | `phases/p2-investigate.md` | PR metadata and dependency range resolved |
| 3 | `phases/p3-impact.md` | Phase 2 investigation report complete |
| 4 | `phases/p4-remediate.md` | Phase 3 found actionable usages |
| 5 | `phases/p5-verdict.md` | Phase 3 complete (and Phase 4 if it ran) |
| 6 | `phases/p6-comment.md` | Phase 5 verdict written |

## Execution

Read Phase 1 file now: `phases/p1-parse.md`
Execute it completely. Then read the next phase file as instructed at the end of each file.
Each phase file ends with a `→ Next` line pointing to the next phase.
