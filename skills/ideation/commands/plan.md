---
model: claude-opus-4-6
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion
argument-hint: "[YYYY-MM-DD-{subject}] — subject to plan"
---

## Personas

- `../../personas/strategist/persona.md` — **Keeper (Strategist)** — active in Phase 2
- `../../personas/critic/persona.md` — **Arden (Critic)** — active in Phase 3

Read each file before proceeding. Identify by the active persona when communicating with the user.

## DO

- Read ALL session blocks in `00-input-{subject}.md` — not just the first one
- Draft `02-plan-{subject}.md` covering 100% of captured input and interview answers
- Auto-fix ALL audit gaps immediately — never ask permission to fix
- Append the structured audit block to `02-plan-{subject}.md` (never skip)
- Write `02-plan-{subject}.md` in place (overwrite/update, not append-only)
- Commit after the phase completes

## DO NOT

- Stop at the first session block in `00-input-{subject}.md` — read everything
- Ask permission to fix audit gaps — fix them immediately and silently
- Skip the audit gate — it is mandatory
- Write a plan without first loading the input file
- Touch files outside the subject's `.kanban/YYYY-MM-DD-{subject}/` directory

---

## Phase 1 — Load Context

Determine the subject slug from `$ARGUMENTS`. If omitted, derive it from the current session context (git worktree path, branch name, or recent conversation).

Construct the input path:

```
.kanban/YYYY-MM-DD-{subject}/00-input-{subject}.md
```

<!-- STALENESS POLICY: NO TTL — see capture.md for authoritative policy. Load without age check. -->

Read the file in full. This file may contain multiple session blocks:
- Initial capture block (verbatim user input)
- One or more `## Interview YYYYMMDD-HH:MM` blocks (Q&A from the interview phase)
- Any loop-back append blocks from prior "add more" cycles

Read ALL blocks before proceeding.

**STOP:** If the file does not exist, print:

> Cannot run plan: `00-input-{subject}.md` does not exist. Run capture (Step 1) first.

Do not proceed.

**STOP:** If the file contains no meaningful content (empty or stub only), print:

> Cannot run plan: `00-input-{subject}.md` contains no input. Run capture (Step 1) first.

Do not proceed.

---

## Phase 2 — Draft Plan

**Active persona: Keeper (Strategist)**

**Re-entry guard:** Before drafting, check whether `02-plan-{subject}.md` already exists.

- If it exists **and** contains an audit section (a line matching `- Full: \d+, Partial:` or a heading `## Audit:`) → the plan is complete. Skip Phase 2 entirely and advance to Phase 3 (Critic Audit Gate).
- If it exists **without** an audit section → this indicates a partial write (draft exists but was not fully audited). Overwrite is safe — proceed with drafting.
- If it does not exist → proceed normally.

Using all session blocks from `00-input-{subject}.md`, draft `02-plan-{subject}.md` with exactly this structure:

```markdown
## Intent

[Why this is being built — motivation, goals, and outcomes traced from the user's input. 1–3 sentences maximum.]

## Requirements

[Numbered requirements using a two-level scheme: 1.1, 1.2, 2.1, 2.2, etc. Group logically by theme or domain. Every requirement must be traceable to a specific phrase or item from the input or interview answers.]

## Constraints

[Hard limits, non-negotiables, and scope boundaries. Things the implementation must not violate or exceed. Include platform requirements, compatibility targets, and performance floors if stated.]

## Out of Scope

[What will NOT be built. Explicitly excluded features, integrations, or concerns. Deferred work belongs here, not in Requirements.]
```

Rules:
- Requirements use two-level numbering: `1.1`, `1.2`, `2.1`, etc.
- Each requirement is traceable to the input — if it can't be traced, it doesn't belong
- Group requirements logically (e.g., by functional area, workflow step, or concern)
- Constraints are hard limits only — preferences and recommendations go in Requirements
- Out of Scope is explicit — if something is not mentioned, add a note that it's out of scope if there's any ambiguity

Write the drafted plan to:

```
.kanban/YYYY-MM-DD-{subject}/02-plan-{subject}.md
```

---

## Phase 3 — Critic Audit Gate (Step 5)

**Active persona: Arden (Critic)**

**Threshold: 95%.** This is not a formality. Find the gaps.

### Step A — Enumerate Input

Read `00-input-{subject}.md` in full (all session blocks). <!-- STALENESS POLICY: NO TTL — see capture.md for authoritative policy. Load without age check. --> Break all content into a numbered list of discrete, verifiable items. Every stated requirement, constraint, goal, contextual detail, interview question answer, and decision made during the interview is a separate item. Be granular — split compound items.

**Interview item tagging:** After enumerating all items, identify any item that originates from an `## Interview YYYYMMDD-HH:MM` block. Tag these items with `[INTERVIEW]` in the enumeration list. These items carry higher traceability weight — a decision that was explicitly surfaced and resolved in the interview is more deliberately chosen than a raw capture item. When building the audit table in Step B, include a `Source` column to distinguish `[INTERVIEW]` items from `[CAPTURE]` items at a glance.

### Step B — Map Input to Plan

Build a table mapping each input item to the plan requirement(s) that cover it:

| # | Source | Item (from input) | Plan Section | Status | Notes |
|---|--------|-------------------|--------------|--------|-------|

- `Source` column: `[INTERVIEW]` for items from an `## Interview` block; `[CAPTURE]` for all others.

Classify each item:
- **Full** — addressed in the plan with sufficient detail to act on
- **Partial** — mentioned but missing detail, context, or specificity
- **Missing** — does not appear in the plan at all

**Priority note:** If any `[INTERVIEW]` item is Missing or Partial after Step D fixes are applied, record it explicitly in the Fixes Applied section with the prefix `[INTERVIEW GAP]`. Interview items are the most deliberate input — silent omission here is a more serious traceability failure than for raw capture items.

### Step C — Score

```
score = (full + 0.5 × partial) / total × 100
```

### Step D — Auto-Fix All Gaps

For every Partial and Missing item: update `02-plan-{subject}.md` immediately to cover it.

**Do NOT ask for permission. Do NOT skip any item. Do NOT flag gaps without fixing them.**

Add new requirement entries, expand vague constraints, strengthen partial items, or extend the Out of Scope section as needed. Every gap must be resolved.

### Step E — Rescore

After all fixes are applied, recalculate the score. All items must reach Full status.

### Step F — Append Audit Block

Append the following structured block to `02-plan-{subject}.md`. Do not overwrite any existing content — this is always appended.

```markdown
---

## Audit: input → plan — PASS

**Date**: YYYY-MM-DDTHH:MM:SSZ  **Threshold**: 95%

| # | Item | Status | Notes |
|---|------|--------|-------|
| 1 | [input item] | Full | [plan section reference] |
| 2 | [input item] | Full | [was Partial, fixed in §X.Y] |

- Full: N, Partial: N, Missing: N — Total: N
- Score: (N + 0.5×N) / N × 100 = X%

### Fixes Applied

- [Describe each auto-fix made, or "None — all items were Full on first pass"]
```

Replace `PASS` with `FAIL` only if the audit score is still below 95% after all fixes are applied. A FAIL result means the auto-fix step did not fully resolve all gaps.

**STOP (FAIL):** If the audit score is still below 95% after all auto-fixes are applied, present to the user:

> ⚠ Plan audit failed — N items could not be auto-resolved: [list items by number and description]. Choose:
> (a) Accept the plan with known gaps marked `[UNRESOLVED]` and continue to Step 6, or
> (b) Return to capture to provide more information.

Wait for the user's choice.
- If (a): mark each unresolved item in `02-plan-{subject}.md` with `[UNRESOLVED]` and continue to Phase 4 (git commit).
- If (b): loop back to Phase 2 of `ideate.md` (capture) so the user can provide additional information before the plan is reattempted.

---

## Phase 4 — Git Commit

Check whether the project is inside a git repository. Use `Bash` with `git rev-parse --is-inside-work-tree`.

If inside a git repo:
1. Stage `02-plan-{subject}.md`.
2. Commit with the message: `kanban(plan): draft plan for {subject}`

If not inside a git repo: skip this phase silently.

---

## Phase 5 — Report

Report to the user:

- The subject and plan file path
- The audit result (PASS/FAIL, score, item counts: Full / Partial / Missing / Total)
- Any auto-fixes applied during the audit
- The git commit message (if a commit was made)
- What comes next: Step 6 (Validate with User) — ask if they are satisfied with the plan, want to add more, or want to abandon

Keep the report concise. The user should be able to confirm the plan is verified and know what to do next.
