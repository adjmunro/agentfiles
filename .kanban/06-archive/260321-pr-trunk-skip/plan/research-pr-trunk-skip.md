## Research: 260321-pr-trunk-skip
**Date**: 2026-03-21T00:00:00Z
**Status**: Snapshot — may go stale. Verify before acting.

## Project Structure

- `skills/kanban/commands/pr.md` — 4 phases + precondition block; target for trunk-skip logic
- `skills/kanban/commands/cleanup.md` — archive gate; handles both GitHub and non-GitHub paths already
- `skills/kanban/SKILL.md` — state machine docs; line ~30 has the existing non-GitHub skip note
- `skills/kanban/commands/next.md` — orchestrator; does not interact with PR flow; no changes needed
- `skills/kanban/personas/advocate.md` — Vale, Phases 1–3 of pr.md
- `skills/kanban/personas/release.md` — Helm, Phase 4 of pr.md

## Relevant Patterns

**Existing non-GitHub skip in pr.md (Precondition Check 1):**
- Detects GitHub via `git remote -v` for `github.com` URL
- If no GitHub: "skip it entirely — all tickets in `05-pull-request/` is sufficient to proceed to `kanban-cleanup`"
- cleanup.md independently handles both paths via its own precondition flowchart

**Precondition block structure in pr.md:**
- Check 1: GitHub remote present?
- Check 2: All subject tickets in `05-pull-request/`?
- New Check 3 will insert here: trunk branch? → protection check

**Commit convention when skipping:**
- pr.md currently creates: `kanban(pr): open draft PR for YYMMDD-<subject>`
- On trunk skip, still commit to maintain audit trail: `kanban(pr): skip draft PR for YYMMDD-<subject> — trunk branch unprotected`

## Dependencies

- pr.md → cleanup.md: one-way. Skipping pr.md hands off to cleanup, which already handles non-PR paths.
- cleanup.md does NOT need changes — it already accepts "all tickets in 05-pull-request/" as a valid precondition regardless of how they got there.
- next.md: no coupling to PR flow. No changes needed.
- SKILL.md: documents the bypass conditions; needs a second entry alongside the non-GitHub note.

## Hazards

- **Insertion order**: Trunk check must run after both existing precondition checks (GitHub confirmed, tickets in pipeline). Don't insert before Check 2 or the error path is wrong.
- **API failure handling**: `gh api repos/{owner}/{repo}/branches/{branch}/protection` can fail silently on non-GitHub remotes, no auth, or network errors. Plan §2.4 says stop and ask — must be explicit in the command text.
- **Audit trail gap**: If the skip path makes no commit, there's no record that pr.md ran. Emit an empty commit with a skip message.
- **Race condition (acceptable)**: Protection status could change between check and cleanup. This is best-effort — document it.

## Recommended Ticket Sequence

1. **TASK-001** — TDD Red Phase: enumerate all new behaviours as falsifiable criteria before touching pr.md or SKILL.md
2. **TASK-002** — Add Precondition Check 3 to pr.md: trunk detection + gh protection check + three-way branch (protected / unprotected / failed)
3. **TASK-003** — Update SKILL.md: expand non-GitHub skip note to document both bypass conditions
4. **TASK-004** — Version bump & changelog: 1.1.0 → 1.2.0 (or combine with capture-flow bump if both land together)
