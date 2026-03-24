---
id: "2026-03-25-outcome-quality-metrics/TASK-002"
subject: "2026-03-25-outcome-quality-metrics"
plan: "../02-plan-outcome-quality-metrics.md"
effort: medium
status: in_review
created_at: "2026-03-25T00:00:00Z"
claimed_at: "2026-03-24T11:43:20Z"
completed_at: "2026-03-24T11:43:20Z"
stale_after_hours: 4
depends_on:
  - "TASK-001"
spawned_tickets: []
plan_items:
  - "Req 1.1 — create 00-quality-{subject}.md file type"
  - "Req 1.2 — file schema with Interview Signals section"
  - "Req 1.3 — created on first write by interview.md"
  - "Req 2.1 — classify each recommendation as Approved / Overridden / Rejected"
  - "Req 2.2 — rejection heuristics via backtrack phrases in Phase 4"
  - "Req 2.3 — append Interview Signals block to quality envelope"
  - "Req 2.4 — commit quality envelope alongside interview files"
acceptance_criteria:
  - "Grep for 'Interview Signals' in skills/ideation/commands/interview.md returns at least one match"
  - "Grep for 'Approved' and 'Overridden' and 'Rejected' in skills/ideation/commands/interview.md each return at least one match"
  - "Grep for 'backtrack' or 'Actually' or 'don.*do that' in skills/ideation/commands/interview.md returns at least one match (rejection heuristic documented)"
  - "Grep for '00-quality' in skills/ideation/commands/interview.md returns at least one match"
  - "Grep for 'kanban(interview)' in skills/ideation/commands/interview.md returns at least one match (commit instruction references quality envelope)"
  - "Grep for 'Summary.*approved.*overridden.*rejected' in skills/ideation/commands/interview.md returns at least one match (summary line format present)"
  - "Grep for 'create.*if.*not exist\\|does not exist' in skills/ideation/commands/interview.md returns at least one match (create-on-first-write behaviour documented)"
consecutive_failures: 0
---

## Context

Modifies `skills/ideation/commands/interview.md` to add interview acceptance tracking (plan §2). After recording the user's response in Phase 4, the agent classifies each recommendation item as Approved, Overridden, or Rejected using backtrack-phrase heuristics, then appends an `## Interview Signals` block to a new `00-quality-{subject}.md` quality envelope file. The quality envelope is created on first write. Both files are staged and committed together under the existing `kanban(interview):` commit.

The `## Interview Signals` section is the first of five sections in the quality envelope schema (plan §1.2).

## Acceptance Criteria

- Grep for `Interview Signals` in `skills/ideation/commands/interview.md` returns at least one match
- Grep for `Approved` and `Overridden` and `Rejected` in `skills/ideation/commands/interview.md` each return at least one match
- Grep for `backtrack` or `Actually` or `don.*do that` in `skills/ideation/commands/interview.md` returns at least one match (rejection heuristic documented)
- Grep for `00-quality` in `skills/ideation/commands/interview.md` returns at least one match
- Grep for `kanban(interview)` in `skills/ideation/commands/interview.md` returns at least one match (commit instruction references quality envelope)
- Grep for `Summary.*approved.*overridden.*rejected` in `skills/ideation/commands/interview.md` returns at least one match (summary line format present)
- Grep for `create.*if.*not exist` or `does not exist` in `skills/ideation/commands/interview.md` returns at least one match (create-on-first-write behaviour documented)

<!-- Everything below this line is append-only and chronological -->

## Work Log — 2026-03-24T11:43:20Z

Added Phase 4b (Interview Acceptance Classification) to `skills/ideation/commands/interview.md`,
positioned immediately after Phase 4 records the user's response. This placement was chosen because
classification must happen after the response is recorded — it reads the same parsed response — and
before the git commit phase, so both artefacts (input block and signals block) can be committed
together. Splitting them would create a window where the quality envelope is absent from history.

**Decisions and WHY:**

- Phase 4b placed between Phase 4 and Phase 5 (not at the end) because the classification needs the
  parsed response data that Phase 4 produces. Placing it later would require re-parsing. (Req 2.1)

- Backtrack phrases listed verbatim from plan §2.2 ("Actually,", "don't do that", "no,",
  "I don't want") with the ambiguity tiebreak rule (prefer Overridden over Rejected) also from
  §2.2. Rationale: false negatives are less harmful than false positives — incorrectly marking a
  rejection as an override is recoverable; the reverse inflates the rejection signal. (Req 2.2)

- Quality envelope file path is `.kanban/{YYYY-MM-DD-subject}/00-quality-{subject}.md` — matches
  plan §1.1 location alongside the other `00-` files at the subject root. (Req 1.1)

- Create-if-not-exists behaviour explicitly stated in Phase 4b: "Create the file if it does not
  exist". Append-only constraint also stated. This satisfies AC for Req 1.3. (Req 1.3)

- Phase 6 updated to stage and commit `00-quality-{subject}.md` alongside `00-input-{subject}.md`
  under the existing `kanban(interview):` commit. WHY-comment in Phase 6 explains the sync
  requirement. (Req 2.4)

- Summary line format `{N} approved, {N} overridden, {N} rejected of {total}` matches plan §2.3
  exactly. (Req 2.3, AC: `Summary.*approved.*overridden.*rejected`)

**All ACs verified by grep:**

- `Interview Signals` — 2 matches ✓
- `Approved` — 5 matches ✓
- `Overridden` — 6 matches ✓
- `Rejected` — 3 matches ✓
- `backtrack` / `Actually` — 2 matches ✓
- `00-quality` — 3 matches ✓
- `kanban(interview)` — 1 match ✓
- `Summary.*approved.*overridden.*rejected` — 1 match ✓
- `does not exist` — 3 matches ✓
