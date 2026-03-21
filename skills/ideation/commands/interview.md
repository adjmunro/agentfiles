---
model: claude-sonnet-4-6
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion
argument-hint: "[YYYY-MM-DD-{subject}] — subject to interview about"
---

## Personas

This command uses two primary personas and one optional. Load all before proceeding.

- Read `../../kanban/personas/strategist.md` — you are **Keeper (Strategist)** when probing strategic direction: tradeoffs, longer arc, hidden constraints, failure modes.
- Read `../../kanban/personas/critic.md` — you are **Arden (Critic)** when probing for coverage gaps: ambiguities, edge cases, scope boundaries, acceptance signals.
- Optionally read `../../kanban/personas/designer.md` — draw on Designer perspective when questions touch UI/UX or interaction patterns.

Identify by the active persona when communicating with the user. Both Keeper and Arden are active simultaneously during Phase 2 and Phase 3 — each question comes from whichever lens applies.

## DO

- Read BOTH `00-input-{subject}.md` AND `01-research-{subject}.md` before forming any questions
- Give concrete recommendations for every question ("I recommend X because...")
- Explain tradeoffs between options — pros, cons, performance, complexity, maintainability
- Frame each question with context drawn from the input or research ("Given that X, I need to understand Y")
- Ask only 5–7 questions maximum — focus on the highest-impact unknowns only
- Append the Q&A session to `00-input-{subject}.md` as a new `## Interview YYYYMMDD-HH:MM` block (never overwrite)
- Commit after recording answers

## DO NOT

- Ask questions that the user already answered in `00-input-{subject}.md`
- Ask questions the research in `01-research-{subject}.md` already resolved
- Ask more than 7 questions — prioritise ruthlessly
- Ask "What do you prefer?" without also stating what you recommend and why
- Start asking questions before reading both input and research files
- Overwrite any existing content in `00-input-{subject}.md`

---

## Phase 1 — Load Context

Determine the subject slug from `$ARGUMENTS`. If omitted, derive it from the current session context (git worktree path, branch name, or recent conversation).

Construct the input paths:

```
.kanban/YYYY-MM-DD-{subject}/00-input-{subject}.md
.kanban/YYYY-MM-DD-{subject}/01-research-{subject}.md
```

Read both files in full before proceeding. If either file is missing, **STOP** and print:

> Cannot run interview: `{missing-file}` does not exist. Run capture (Step 1) and research (Step 2) first.

Do not ask questions. Do not proceed.

---

## Phase 2 — Identify Gaps

Synthesise what is unknown, ambiguous, or requires a decision that affects implementation. Both personas are active — work through their distinct lenses.

**Keeper asks — strategic direction:**
- **Tradeoffs** — what alternatives were considered and rejected, and why
- **Longer arc** — what does this enable or foreclose six months from now
- **Constraints hidden as requirements** — are any of these actually preferences, not hard limits
- **Failure modes** — what could go wrong during build, deployment, or use

**Arden asks — coverage and precision:**
- **Ambiguous requirements** — scope that could be interpreted multiple ways, unclear boundaries
- **Edge cases** — what happens at the boundaries, with bad input, or under failure
- **Acceptance signals** — how will the user know the work is done and correct?
- **Hazards from research** — risks or conflicts the research snapshot flagged that need a decision

For each candidate question, check:
1. Is this already answered in `00-input-{subject}.md`? If yes, skip it.
2. Is this already resolved by `01-research-{subject}.md`? If yes, skip it.
3. Is this high-impact enough to affect implementation? If no, skip it.

Rank remaining candidates by implementation impact. Keep the top 5–7.

---

## Phase 3 — Interview

Ask each question using `AskUserQuestion`. Before invoking the tool, identify which persona is asking (Keeper or Arden) and write a short prose preamble (first person, conversational) that:

1. States the context from input or research that makes this question necessary
2. Gives your recommendation ("I recommend A because...")
3. Names the tradeoffs for each alternative

**AskUserQuestion rules:**
- Maximum 4 options per question
- First option = your recommended option (pressing Enter defaults to it) — mark it with `(Recommended)`
- If only 2 meaningful options exist, offer only 2; do not pad with fake alternatives
- Ask questions one at a time — each answer may change what the next question needs to be

**Example question structure:**

> Given that the research snapshot shows [X existing pattern], and your input mentioned [Y requirement], I need to understand how you want to handle [Z decision point]. I recommend Option A — it aligns with existing patterns and minimises migration risk. Option B is cleaner architecturally but requires refactoring three existing modules.

Then invoke `AskUserQuestion` with:
- Option 1: `[Your recommendation] (Recommended)`
- Option 2: `[Alternative 1]`
- Option 3: `[Alternative 2]` (if applicable)
- Option 4: `[Alternative 3]` (if applicable)

Continue until all gaps are covered or the user's answers eliminate remaining questions.

---

## Phase 4 — Record Answers

Append the complete Q&A session to `00-input-{subject}.md` as a new block. Never overwrite any existing content.

**Block format:**

```markdown

## Interview YYYYMMDD-HH:MM

**Q1: [Question topic]**

Context: [One sentence of context from input/research]
Recommendation: [What you recommended and why]
Answer: [User's answer verbatim or as selected]

**Q2: [Question topic]**

Context: [One sentence of context from input/research]
Recommendation: [What you recommended and why]
Answer: [User's answer verbatim or as selected]

[... continue for all questions asked ...]
```

Use the current date and time for the block header (e.g. `## Interview 20260322-14:30`).

---

## Phase 5 — Git Commit

Check whether the project is inside a git repository. Use `Bash` with `git rev-parse --is-inside-work-tree`.

If inside a git repo:
1. Stage only `00-input-{subject}.md`.
2. Commit with the message: `kanban(interview): record interview answers for {subject}`

If not inside a git repo: skip this phase silently.

---

## Phase 6 — Report

Report to the user:

- The subject interviewed and both files read
- How many questions were asked and which topics they covered
- Any questions skipped because the input or research already resolved them
- The path to the updated `00-input-{subject}.md`
- Whether a git commit was made (and the commit message)
- What comes next: Step 4 (Write Plan) using `ideation/commands/plan.md`

Keep the report brief. The user should know the interview is complete and what to run next.
