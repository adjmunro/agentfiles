---
allowed-tools: Read, Glob, Grep, Bash
argument-hint: "[pr | trunk | <git-ref>]"
---

<!-- ORCHESTRATOR: This is a read-only command. It reads git history and file contents only.
     Never write, edit, or stage files in the target repository unless the user
     explicitly requests a saved output file. -->

## Personas

Personas are loaded progressively at each phase boundary — do not read all files upfront. Identify by the active persona at each phase boundary when communicating with the user.

| Persona | File | Active phases |
|---------|------|---------------|
| Arc (Sequencer) | `../../personas/temporal/persona.md` | Phase 1 |
| Loom (Synthesist) | `../../personas/synthesis/persona.md` | Phase 2, Phase 3 |
| Ward (Documentation) | `../../personas/documentation/persona.md` | Phase 2 Step 5, Phase 4, Phase 5 |

---

## Entry Point

Parse `$ARGUMENTS` to determine the scope and framing mode:

| Argument | Scope | Framing |
|----------|-------|---------|
| _(empty)_ | Since branch parent commit | Session resume |
| `pr` | Since branch parent commit | PR review |
| `trunk` | Since divergence from `main` or `master` | Session resume |
| Any other token | Since that git ref or commit SHA | Session resume |

Store the resolved values as:
- `SCOPE_REF` — the git ref boundary (e.g. `main`, `HEAD~3`, a commit SHA)
- `MODE` — either `pr` or `default`

If `$ARGUMENTS` is a ref-like token that cannot be resolved (git returns an error), stop and report the error explicitly. Do not proceed with an unresolvable ref.

---

## Phase 1 — Ref Resolution (Arc)

*Load `../../personas/temporal/persona.md` — Arc (Sequencer) is active. Establish the temporal boundary before reading any files.*

**Step 1 — Resolve SCOPE_REF:**

- If mode is `pr` or arguments are empty: run `git merge-base HEAD $(git rev-parse --abbrev-ref HEAD@{upstream} 2>/dev/null || git log --oneline | tail -1 | awk '{print $1}')` to find the branch parent. If upstream tracking is available use it; otherwise fall back to the first commit on the current branch. Store the resulting SHA as `SCOPE_REF`.
- If mode is `trunk`: run `git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null` to find the divergence point. Store as `SCOPE_REF`.
- If `$ARGUMENTS` is any other token: validate it with `git rev-parse --verify <token>`. Store as `SCOPE_REF` if valid; abort with a clear error if not.

**Step 2 — Collect commit list:**

Run: `git log --oneline --no-merges <SCOPE_REF>..HEAD`

Record:
- Number of commits
- First commit date (oldest in range): `git log --format="%ad" --date=short <SCOPE_REF>..HEAD | tail -1`
- Last commit date (most recent): `git log --format="%ad" --date=short -1`
- Current branch name: `git rev-parse --abbrev-ref HEAD`

If the commit list is empty, report: "No commits found between `<SCOPE_REF>` and `HEAD`. Nothing to summarise." Stop.

**Step 3 — Collect changed files:**

Run: `git diff --name-only <SCOPE_REF>..HEAD`

Store the full list. Note any paths matching these patterns for targeted reading in Phase 2:
- `skills/*/CHANGELOG.md`
- `skills/*/SKILL.md`
- `skills/*/commands/*.md`
- `skills/personas/*/persona.md`
- `skills/personas/*/CHANGELOG.md`
- `.kanban/**/*.md`

---

## Phase 2 — Source Reading (Loom)

*Load `../../personas/synthesis/persona.md` — Loom (Synthesist) is active. Gather all source material before synthesising.*

*Intent Anchor: `SCOPE_REF` and `MODE` must be resolved from Phase 1 before reading any files. If either is undefined, return to Phase 1.*

Identify the distinct source domains present in this change set. At minimum, distinguish between: git commit messages (intent layer), CHANGELOG entries (structured description layer), and changed instruction files (implementation layer). Read across all three before drawing any conclusions.

**Step 1 — Read full commit log with bodies:**

Run: `git log --format="commit %H%nauthor: %an%ndate: %ad%n%nsubject: %s%n%nbody:%n%b%n---" --date=short <SCOPE_REF>..HEAD`

Extract from each commit:
- Subject line (the "what")
- Body (the "why" — may be absent; mark as `[no body]` if missing)
- Conventional commit scope, if present (e.g. `feat(personas)` → scope is `personas`)

Group commits by scope. If no scopes are present, group by inferred area (based on changed file paths).

**Step 2 — Read changed CHANGELOG files:**

For each `CHANGELOG.md` in the changed-files list, read the most recent entry (the top entry). Extract:
- Version and date
- Section headings (Added / Changed / Fixed) and their bullet points

These entries are the structured description of intent and are authoritative for the "Why" section.

**Step 3 — Read changed SKILL.md and command files:**

For each changed `SKILL.md` or `commands/*.md` file in the list, read the full file. Note:
- What the skill or command does (from the Overview or Purpose section)
- Any invocation syntax or argument hints
- Any changed phases or steps (compare subject lines that mention the file to what the file now says)

**Step 4 — Read changed persona files:**

For each changed `persona.md` in the list, read the Purpose and DO sections. Note what the persona is for and what changed.

**Step 5 — Check for documentation drift (Ward):**

*Load `../../personas/documentation/persona.md` — Ward (Documentation) is active for this step.*

For each changed SKILL.md, AGENTS.md, or README file, cross-reference against the commit subjects that touched it. If a commit claims to add a feature but the documentation does not reflect it, flag it as drift. If a commit body references a file path that does not exist in the changed-files list, flag it as a potential stale reference.

Record any drift findings — they will appear in the output under a "Documentation notes" sub-section inside the relevant area block.

*Loom (Synthesist) resumes after Step 5. Ward's documentation-drift check is complete.*

**Step 6 — Source domain coverage tally:**

Count how many of the three domains yielded data: (a) commit message bodies, (b) CHANGELOG entries, (c) changed instruction/skill/persona files. If only one domain contributed data, record a coverage note for the Context block: "Source coverage: [domain name] only — no [other domains] changed in this range." This note appears in the Context block at Phase 3 Step 1.

---

## Phase 3 — Synthesis (Loom)

*Loom (Synthesist) is active. Synthesise across all three source domains into a unified picture.*

*Intent Anchor: Confirm `SCOPE_REF` and `MODE` are still in scope from Phase 1. Confirm Phase 2 source material (commit log, CHANGELOG entries, instruction files) has been gathered before beginning synthesis.*

Before writing output, identify the emergent property of this change set: what quality or capability exists now that did not exist before, that could not have been derived from any single commit message or changelog entry alone? Name it explicitly in the "Changes by area" introduction.

**Step 1 — Build the Context block:**

```
Branch:    <branch-name>
Commits:   <N> commit(s)
Date range: <first-date> → <last-date>
Scope:     Since <SCOPE_REF description>
```

**Step 2 — Build the Changes by area block:**

Group all commits by scope/area. For each group:

1. Name the area (e.g. `personas`, `summary`, `commands/optimise`)
2. List the commits in that group (subject lines only)
3. Write a 1–2 sentence synthesis of the group's intent — drawn from commit bodies and changelog entries, not just subject lines
4. If Ward flagged documentation drift for this area, include a `> Doc note:` block beneath the synthesis

Aim for one paragraph per area. Do not list every commit bullet-for-bullet — synthesise.

**Step 3 — Build the New & changed features block:**

For each changed skill, command, or persona (identified in Phase 2):

Write a brief entry with two parts:
- **What it does now**: one sentence describing the current capability
- **How to use it**: the invocation syntax or trigger condition, taken directly from the file

If the file was not changed enough to alter usage (e.g. only a doc fix), note "Usage unchanged — documentation updated."

**Step 4 — Build the Why block:**

Pull rationale from:
1. Commit message bodies (the primary source)
2. CHANGELOG entry introductory sentences (secondary source)

Write this as prose, not a list. One paragraph per logical motivation thread. If multiple commits share the same rationale, consolidate.

If no commit bodies exist and no changelog entries provide rationale, write: "No rationale recorded in commit messages or changelogs." Then append a diagnostic note listing the commits that are missing bodies by SHA and subject, and recommend the author enrich those commits before re-running `/summary`.

---

## Phase 4 — Open Work

*Ward (Documentation) is active.*

Scan for in-progress and queued tickets in `.kanban/`. Check for any items in these directories:

- `.kanban/*/04-todo/` — queued, not started
- `.kanban/*/05-in-progress/` — active work
- `.kanban/*/06-in-review/` — in review

For each ticket file found, read its filename only (do not read the full file). Extract:
- Subject (from the parent directory name, e.g. `2026-03-21-my-feature`)
- Stage (todo / in-progress / in-review)
- Ticket ID and name (from the filename, e.g. `TASK-003-my-feature.md`)

If no tickets are found in any of those directories, write: "No open tickets found in `.kanban/`."

If tickets are found, present them as a table:

| Subject | Stage | Ticket |
|---------|-------|--------|
| `<subject>` | in-progress | `TASK-003-my-feature` |

---

## Phase 5 — Output

*Ward (Documentation) is active. Assemble sections in the defined order. Write for the next person reading this — assume no prior context about this branch or session.*

Before finalising output, verify completion: all 5 sections must be present (Context, Changes by area, New & changed features, Why, Open work), each containing either substantive content or explicit fallback text. Verify section order matches the list above.

Assemble the final report using the sections below, in this order. Use markdown headings. Do not add commentary outside the defined sections.

---

### Framing

**If `MODE` is `pr`**: open with:

> **PR Review Summary** — `<branch-name>` → `<base-branch>`
>
> This summary is framed for a reviewer. It covers what changed, why, and what to look for when approving.

**If `MODE` is `default`**: open with:

> **Session Summary** — `<branch-name>`
>
> Changes since `<SCOPE_REF description>`.

---

### Section order

```
## Context
<Context block from Phase 3 Step 1>

## Changes by area
<Area groups from Phase 3 Step 2>

## New & changed features
<Feature entries from Phase 3 Step 3>

## Why
<Rationale prose from Phase 3 Step 4>

## Open work
<Ticket table or empty notice from Phase 4>
```

---

### PR mode additions

When `MODE` is `pr`, append a final section after Open work:

```
## Review checklist
```

Populate it with 3–5 targeted items derived from the actual changes — not a generic checklist. Each item should be a specific thing a reviewer should verify, based on what was changed. Examples:

- "Check that the new `trunk` mode resolves the correct merge-base when upstream is not configured"
- "Verify CHANGELOG entry matches the implementation in `commands/summary.md`"

Do not include generic items such as "check for typos" or "verify tests pass" unless the changes specifically introduce a risk in that area.

---

## Error handling

| Condition | Behaviour |
|-----------|-----------|
| `$ARGUMENTS` ref cannot be resolved | Abort with: "Cannot resolve ref `<token>`. Check the ref exists and is reachable from HEAD." |
| Git is not available or not a repo | Abort with: "Not inside a git repository. `/summary` requires git." |
| No commits in range | Report: "No commits between `<SCOPE_REF>` and HEAD. Nothing to summarise." |
| No files changed in range | Output all 5 sections. Context block as normal. Changes by area: "No file changes detected in this range." New & changed features: "No skill, command, or persona files changed in this range." Why: "No commit bodies or changelog entries — no rationale to record." Open work: scan `.kanban/` as normal. |
| `.kanban/` does not exist | In the Open work section, write: "No `.kanban/` directory found." |
