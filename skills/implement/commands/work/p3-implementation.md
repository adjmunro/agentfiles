# Phase 3 — Implementation
<!-- Part of: work.md orchestrator -->
<!-- Active when: ticket has been selected and claimed (moved to 05-in-progress/) -->

<!-- INTENT ANCHOR — re-read original intent before writing any code -->
<!-- 1. Read the ticket's `plan` frontmatter field to get the plan file path. -->
<!-- 2. Read the `## Intent` section from that plan file. -->
<!-- 3. State the intent in exactly 1 sentence before writing any code. Do not proceed until this sentence is written. -->

Before writing a single line of code, read the full ticket file from top to bottom.

**Required reading:**

- All existing `## Review` sections — understand exactly what failed in prior attempts and why
- The `## Context` section — understand why this ticket exists
- The `## Acceptance Criteria` section — understand the verifiable completion conditions

**Staleness policies for artifacts read in this phase:**
- Ticket file (`05-in-progress/TASK-NNN-*.md`): NO TTL — frontmatter is updated in-place and always reflects current state. Load without age check.
- Plan file (path from ticket's `plan` frontmatter field): LOAD WITH CAVEAT (TTL: 7 days). Check its `created_at` frontmatter field (or file mtime as fallback).
  - If the file does not exist at the stated path: STOP. Print "Plan file not found: {path}. Verify the ticket's `plan` frontmatter field is correct, or re-run `/implement init` to regenerate it." Do not proceed.
  - If age ≤ 7 days: load normally.
  - If age > 7 days: load, but prepend this warning to any extracted content:
    ⚠ STALE (written {N} days ago): treat as reference only. Plan will not reflect current codebase state — verify requirements against existing code before implementing.

**If prior Review sections exist:** Treat every identified issue as a constraint on your implementation. Do not repeat the same mistakes. Note which plan items each prior failure touched.

**Model tier override:** Read the ticket's `effort` field and select the appropriate model:
- `low` → fast/cheap model (e.g. haiku)
- `medium` → standard model (e.g. sonnet)
- `high` → most capable model (e.g. opus)

If your environment supports spawning subagents, select the appropriate tier here.

## Consecutive Failure Escalation

If the ticket's `consecutive_failures` field is ≥ 2, escalate before starting implementation:

> Warning: This ticket has failed review `{consecutive_failures}` consecutive time(s). The same gap is recurring. Review prior `## Review` sections carefully before proceeding.

If `consecutive_failures` is ≥ 3, send a desktop notification (if your environment supports it) and append an escalation block:

```markdown
## Escalation — YYYY-MM-DDTHH:MMZ

Ticket has reached {N} consecutive failures. Identical gap is recurring. Prior review sections reviewed: [yes/no]. Approach taken to break the pattern: [description].
```

## WHY-Comments — Non-Negotiable

**Quill (Intent Annotator) governs this section.** Every code change must include inline comments explaining:

- **WHY this code exists** — what requirement or constraint drives it
- **WHY this approach was chosen** — what alternatives were considered and rejected
- **What breaks if you remove it** — the consequence of deletion or change
- **Which plan item or ticket AC it satisfies** — reference by ID where applicable

Comments that only describe *what* the code does are non-compliant. "Sort the list" is not a WHY-comment. "Sort before binary search — O(log n) lookup in Phase 3 requires sorted input; unsorted input silently returns wrong results" is.

## Doc Comments — Public API Surface

**Folio (API Documenter) governs this section.** Read `../../personas/folio/persona.md` before writing or modifying any public function or class.

For every new or modified public function, method, or class:

- Write or update the doc comment (`///`, JSDoc, docstring, KDoc, XML doc) to reflect the current signature, return type, and behaviour — from the caller's perspective only
- Document every exception that can be thrown — no exceptions are too unlikely to document
- Do not describe implementation details the caller has no need to know
- Do not state the obvious — if the function name and signature already say everything, no doc comment is needed

If a function's signature did not change and its observable behaviour did not change, its doc comment does not need updating.

## Scope Enforcement

Work only within the scope defined by this ticket's acceptance criteria. If implementation reveals additional work outside this ticket's stated ACs, do NOT do that work here. See `work/p5-scope-enforcement.md`.

## Plan-Layer Isolation

The following paths are **read-only** from implement. Never write, move, rename, or delete:
- `00-input-*` files
- `01-research-*` files
- `02-plan-*` files
- `00-assets/` directory and its contents
- `03-refinement/` directory and its contents

Kanban2 picks up work only after tickets are promoted to `04-todo/`.

## Commit Discipline (applies throughout this phase)

Commit after every meaningful, self-contained unit of work. A meaningful unit is one of:

- A model or type definition
- A function or method (with its tests if co-located)
- A test suite for an existing function
- A protocol, interface, or schema
- A configuration change that is complete in itself

**Never batch unrelated changes into a single commit.**

Commit message format:

```
feat({NNN}): [what and why in one line]
```

Replace `{NNN}` with the ticket number. The message body must describe what changed and why it matters — not a laundry list of files touched.

Examples:
- `feat(011): add work.md command — implements ticket claim and implementation flow`
- `feat(011): add stale detection — prevents resuming abandoned sessions without user confirmation`

## Ticket Reference

> See `_shared.md § Ticket Frontmatter Schema` when you need field definitions.
> See `_shared.md § Ticket Body Structure` when you need the body template.
> See `_shared.md § Directory Structure` when you need path references.

→ Next: When all acceptance criteria in the ticket have been addressed — each item has a corresponding code change or verified implementation — read `work/p6-work-log.md` and execute it.
   If implementation reveals work outside the ticket's stated acceptance criteria, read `work/p5-scope-enforcement.md` first, then return here.
