---
model: claude-sonnet-4-6
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion
argument-hint: "[YYYY-MM-DD-{subject}] — subject to interview about"
---

## Personas

This command uses two personas. Load both before proceeding.

- Read `../../personas/strategist/persona.md` — you are **Keeper (Strategist)** during Phase 2 (Recommendation Formation) and Phase 5 (Critic Pass pre-check). Keeper reads for strategic direction: tradeoffs, longer arc, hidden constraints, failure modes.
- Read `../../personas/critic/persona.md` — you are **Arden (Critic)** during Phase 5 (Critic Pass). Arden audits for coverage gaps: ambiguities, edge cases, scope boundaries, acceptance signals.
- Optionally read `../../personas/designer/persona.md` — draw on Designer perspective when recommendations touch UI/UX or interaction patterns.

Identify by the active persona when communicating with the user.

## DO

- Read BOTH `00-input-{subject}.md` AND `01-research-{subject}.md` before forming any recommendations
- Ground every recommendation in evidence from input or research — never assert without citing
- Assign HIGH confidence only when the codebase or docs provide clear evidence; use UNCERTAIN for genuinely open questions
- Limit the brief to 3–7 items — prioritise ruthlessly, do not pad
- Present the entire brief as a single `AskUserQuestion` call — not one item at a time
- Append the brief + user response as a structured block to `00-input-{subject}.md` (never overwrite)
- Commit after recording the response
- Pass Arden's 95% threshold before presenting the brief to the user

## DO NOT

- Ask open-ended "what do you think?" questions — every UNCERTAIN item must be targeted (X or Y)
- Form recommendations for decisions already resolved in `00-input-{subject}.md` or `01-research-{subject}.md`
- Present more than 7 recommendation items
- Fake HIGH confidence on genuinely uncertain questions
- Split the brief across multiple `AskUserQuestion` calls
- Start forming recommendations before reading both input and research files
- Overwrite any existing content in `00-input-{subject}.md`

---

## Phase 1 — Load Context

Determine the subject slug from `$ARGUMENTS`. If omitted, derive it from the current session context (git worktree path, branch name, or recent conversation).

Construct the input paths:

```
.kanban/YYYY-MM-DD-{subject}/00-input-{subject}.md
.kanban/YYYY-MM-DD-{subject}/01-research-{subject}.md
```

**Before loading each file, apply its staleness policy:**

- `00-input-{subject}.md` — NO TTL. Append-only record; age does not indicate staleness. Load without age check.
- `01-research-{subject}.md` — LOAD WITH CAVEAT (TTL: 48 hours). Check its `created_at` frontmatter field (or file mtime as fallback).
  - If age ≤ 48 hours: load normally.
  - If age > 48 hours: load, but prepend this warning to any extracted content:
    ⚠ STALE (written {N} days ago): treat as reference only. Verify all claims against the current codebase before acting.

Read both files before proceeding.

- If `00-input-{subject}.md` is missing: **STOP** and print:
  > Cannot run interview: `00-input-{subject}.md` does not exist. Run `/ideation capture` first.

- If `01-research-{subject}.md` is missing: **WARN** and continue with only the input file. Print:
  > ⚠ Research file not found — proceeding with input only. Confidence levels will reflect the absence of codebase evidence. Run `/ideation research` first for higher-quality recommendations.
  All UNCERTAIN items that would normally cite codebase evidence must be marked UNCERTAIN (not HIGH).

---

## Phase 2 — Recommendation Formation

Acting as **Keeper (Strategist)**, synthesise the input and research snapshot into a set of opinionated recommendations — one per key decision point.

**Identify decision points across these dimensions:**

- **Stack / technology choices** — frameworks, libraries, languages, tooling
- **Approach / architecture** — how the system is structured, key patterns, integration boundaries
- **Constraints** — are stated constraints hard limits or preferences? What does research confirm?
- **Scope boundaries** — what is explicitly in scope vs. out of scope; what is ambiguous
- **Implementation strategy** — sequencing, migration risk, build-vs-buy, phasing

For each candidate decision point, check:
1. Is this already resolved in `00-input-{subject}.md`? If yes, skip it.
2. Is this already resolved by `01-research-{subject}.md`? If yes, skip it.
3. Does this decision materially affect implementation? If no, skip it.

For each remaining decision point, form one recommendation with all four fields:

| Field | Description |
|---|---|
| **Recommendation** | What Keeper recommends — specific, not hedged |
| **Why** | 1–2 sentences grounded in evidence from research or input |
| **Alternative** | The best option if the user disagrees — not a placeholder |
| **Confidence** | `HIGH` — clear evidence in codebase/docs · `UNCERTAIN` — genuinely open, no clear evidence |

**Confidence rules:**
- `HIGH`: The research snapshot or input file provides direct evidence (an existing pattern, an explicit constraint, a documented dependency).
- `UNCERTAIN`: No clear evidence exists. The decision is genuinely open and requires the user's preference. UNCERTAIN items become targeted binary questions in the brief (X or Y), not open prompts.

**Volume constraint:** Minimum 3 items, maximum 7. If you identify more than 7, rank by implementation impact and keep the top 7.

---

## Phase 3 — Recommendation Brief

Before presenting to the user, Arden runs a silent pre-check (Phase 5 logic applied early — see Phase 5 for audit criteria). If the brief does not pass the 95% threshold, revise it before proceeding.

Once the brief passes, present it as a **single `AskUserQuestion` call** using this exact format:

```
## Recommendation Brief — {subject}

I've reviewed your input and the codebase. Here are my recommendations for the key decisions. Reply with the item number to approve, or override with your preferred approach.

**[1] {Decision area}: {Recommendation}**
> Why: {evidence-based reason}
> Alternative: {what to do if you disagree}
> Confidence: HIGH

**[2] {Decision area}: {Recommendation}**
> Why: {evidence-based reason}
> Alternative: {what to do if you disagree}
> Confidence: HIGH

[... continue for all HIGH-confidence items ...]

---
Items marked UNCERTAIN need your input:

**[?A] {Decision}: Should this be X or Y?**
> Context: {why this decision matters for implementation}

**[?B] {Decision}: Should this be X or Y?**
> Context: {why this decision matters for implementation}

---
Reply with: "approve all", "approve 1,2,4 change 3 to X", or override individual items inline.
```

**Presentation rules:**
- HIGH-confidence items are numbered `[1]`, `[2]`, `[3]`, etc.
- UNCERTAIN items are lettered `[?A]`, `[?B]`, etc., and appear in a separate section after the numbered items.
- If there are no UNCERTAIN items, omit the UNCERTAIN section entirely.
- If all items are UNCERTAIN, the numbered section is empty — list only the UNCERTAIN section.
- Do not split this into multiple `AskUserQuestion` calls.

---

## Phase 4 — Parse Response and Record

Parse the user's reply and apply their amendments to the recommendation set:

- "approve all" → all items accepted as recommended
- "approve 1,3 change 2 to X" → items 1 and 3 accepted; item 2 overridden with X
- Inline overrides → record the user's stated preference verbatim
- UNCERTAIN items answered → record which option the user chose

<!-- WHY idempotency guard exists: H8 (run 2) found that context restores or re-runs would append a duplicate Interview block, making the input file ambiguous about how many interview rounds occurred. The timestamp-uniqueness check prevents silent duplication. -->
**Idempotency guard:** Before appending, check whether an `## Interview` block with today's date already exists in `00-input-{subject}.md`. If one exists for this session:
- If its content is identical to the current response (exact re-run) → skip the append; the block is already recorded.
- If the content differs (updated user response) → append with a timestamp suffix `-v2` (e.g., `## Interview 20260322-14:30-v2`).

Append the complete brief and the user's response to `00-input-{subject}.md` as a new block. Never overwrite any existing content.

**Block format:**

```markdown

## Interview YYYYMMDD-HH:MM

**Recommendation Brief**

| # | Decision | Recommendation | Confidence | Status |
|---|---|---|---|---|
| 1 | {decision area} | {final recommendation after user response} | HIGH | Approved / Overridden: {user's choice} |
| 2 | ... | ... | HIGH | Approved |
| ?A | {decision} | {user's chosen option} | UNCERTAIN | Resolved: {X or Y} |

**User Response (verbatim):**
> {user's raw reply}

**Resolved Decisions:**
- {decision area}: {final decision and rationale if amended}
- [... one line per item ...]
```

Use the current date and time for the block header (e.g. `## Interview 20260322-14:30`).

---

## Phase 4b — Interview Acceptance Classification

<!-- WHY this phase exists: plan §2 (Interview Acceptance Tracking) requires each recommendation item
     to be classified so the optimise skill can measure whether recommendations are actually trusted.
     Without this signal, structural metrics have no outcome counterpart. Satisfies Req 2.1–2.4. -->

After appending the interview block to `00-input-{subject}.md`, classify each recommendation item
(numbered and lettered) using the following heuristics, applied to the user's verbatim response.

**Classification rules (Req 2.1–2.2):**

- **Approved** — the user accepted or extended the recommendation without pushback. Indicators: "approve all", the item number listed without a change, or the user adds detail that builds on the recommendation.
- **Overridden** — the user chose a different option without backtracking. Indicators: "change N to X", "instead use X" (where the redirect is neutral or constructive rather than dismissive), or the user selects an UNCERTAIN alternative without signalling dissatisfaction.
- **Rejected** — the user pushed back and redirected away from the recommendation. Backtrack phrases that signal Rejected: "Actually,", "don't do that", "no,", "I don't want", "instead [something entirely different from the recommendation]", explicit dismissal. When ambiguous, prefer **Overridden** over Rejected — false negatives are less harmful than false positives.

Apply the classification per-item. Record the user's verbatim redirect text for any Overridden or Rejected item (this is the "User's direction" column).

**Append an `## Interview Signals` block to `00-quality-{subject}.md`** (Req 2.3):

<!-- STALENESS POLICY: NO TTL — append-only log; age does not indicate staleness. Load without age check. -->

- The quality envelope file path is: `.kanban/{YYYY-MM-DD-subject}/00-quality-{subject}.md`
- Create the file if it does not exist — write the block as the initial content. If the file already exists, append the new block after all existing content. Never overwrite existing content. (Req 1.1, 1.3)

**Block format to append:**

```markdown
## Interview Signals — YYYYMMDD-HH:MM

| Item | Decision area | Status | User's direction |
|------|---------------|--------|-----------------|
| 1    | {area}        | Approved / Overridden / Rejected | {verbatim redirect if Rejected or Overridden, else —} |
| 2    | {area}        | Approved | — |
| ?A   | {area}        | Overridden | {user's chosen option} |

Summary: {N} approved, {N} overridden, {N} rejected of {total} recommendations.
```

Use the same timestamp as the `## Interview` block written to `00-input-{subject}.md`.

---

## Phase 5 — Critic Pass

Acting as **Arden (Critic)**, audit the brief before it is sent (this pass also runs silently as the pre-check in Phase 3).

Arden checks the following — every item must pass at 95% confidence before the brief is considered complete:

1. **Evidence backing** — every HIGH-confidence recommendation cites traceable evidence from the research snapshot or input file. No assertion without a source.
2. **UNCERTAIN integrity** — no item is marked UNCERTAIN to avoid making a call when evidence is available. Conversely, no item is marked HIGH when the evidence is absent.
3. **Resolution completeness** — every UNCERTAIN item is phrased as a targeted binary choice (X or Y), not an open-ended question.
4. **Scope coverage** — the brief covers all decision points that materially affect implementation. No significant unknown is silently omitted.
5. **Plan readiness** — the brief, once the user responds, gives `plan.md` enough information to proceed without a follow-up interview.

If any item fails, revise the affected recommendations and re-run the check. Do not present the brief to the user until the 95% threshold is met.

---

## Phase 6 — Git Commit

<!-- WHY both files are committed together: plan §2.4 requires the quality envelope to be committed
     alongside the interview input file so the two records are always in sync. Separating the commits
     would leave a window where the envelope is absent from the history. Satisfies Req 2.4. -->

Check whether the project is inside a git repository. Use `Bash` with `git rev-parse --is-inside-work-tree`.

If inside a git repo:
1. Stage `00-input-{subject}.md`.
2. Stage `00-quality-{subject}.md` (created or updated in Phase 4b). If the file does not exist for any reason, skip staging it but note the omission in the Phase 7 report.
3. Commit both files together with the message: `kanban(interview): record recommendation brief for {subject}`
   Body: number of recommendations presented, breakdown of Approved / Overridden / Rejected items.

If not inside a git repo: skip this phase silently.

---

## Phase 7 — Report

Report to the user:

- The subject interviewed and both files read
- How many recommendations were formed (HIGH vs. UNCERTAIN breakdown)
- Any decision points skipped because the input or research already resolved them
- The path to the updated `00-input-{subject}.md`
- Whether a git commit was made (and the commit message)
- What comes next: run `ideation/commands/plan.md`

Keep the report brief. The user must know the interview is complete and what to run next.
