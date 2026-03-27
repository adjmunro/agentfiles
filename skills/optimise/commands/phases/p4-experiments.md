## Phase 4 — Experiment Loop

**Persona: Arden (Critic)** — load `../../../personas/critic/persona.md` now. If the file is not found, proceed without the persona and note its absence at the start of Phase 4 output. Identify as Arden in all Phase 4 output when the persona is loaded.

Re-read `research-log.md` (Intent Anchor — Tier C only: if target path mismatches or log is >7 days old, stop and alert the user before proceeding). Confirm which hypotheses were approved.

If inside a git repo, check out a new branch:

```bash
git checkout -b optimize/<target-dir-name>-<date>
```

If the target is not inside a git repo, proceed without branching. Note this in
`research-log.md` at the start of the experiments section: "No git repo at target —
changes are not version-controlled. Revert instructions in Step e refer to manual
undo rather than `git revert`."

For each approved hypothesis, in order:

### Step 0 — Pre-experiment dependency scan
Before applying any hypothesis, read the full list of pending (approved but not yet run) hypotheses from `research-log.md`. Check whether any two pending hypotheses modify the same file.

- If two or more pending hypotheses touch the same file: record the overlap in `research-log.md` (e.g. "H20 and H22 both modify help.md — running sequentially with metric re-check between them"). Run them in sequence; re-measure the shared-file metrics between each.
- If no overlap exists: proceed directly.

This step applies once per Phase 4 session, not once per hypothesis.

### Step a — Record pre-change score
Measure the targeted metric(s) at their current state. Record as "pre-change" in
`research-log.md`.

### Step b — Make the change
Apply the specific change described in the hypothesis. Modify only the files
necessary. Follow progressive disclosure — do not load context not needed for this
change.

For hypotheses marked `[persona experiment]`, use the Persona Experiment Protocol
instead of this step and Step c.

### Step c — Re-measure
Apply the same methodology used in Phase 2 to re-measure the targeted metric(s).
Also check every other currently-applied metric (seed and custom) for secondary changes:
if any non-targeted metric has moved ≥2pp in either direction, record it. These secondary
deltas inform the Hypothesis Surprise Rate and reveal systemic effects invisible to
targeted-only measurement.

### Step d — Record result
Determine outcome:
- **Confirmed**: normalised score improved by ≥3 points on at least one target metric,
  with no other metric degraded by more than 2 points
- **Partial**: ≥1 point but <3 points improvement on at least one target metric, OR any
  net-positive composite delta that falls below the confirmed threshold
- **Disconfirmed**: <1 point delta on all target metrics AND composite delta ≤0

Update `research-log.md`:

```markdown
### H<N> — <name>
**Pre-change:** <metric scores>
**Post-change:** <metric scores>
**Delta:** <+/- points per metric>
**Result:** confirmed / partial / disconfirmed
**Notes:** <why it worked or didn't>
```

### Step e — Commit or revert

**Ink (Commit Curator) is active for this step.** Read `../../../personas/ink/persona.md` and `../../../personas/ink/soul.md` before committing. Stage changes by logical unit; write a descriptive body explaining what changed and why; verify the sequence reads coherently with `git log --oneline` after each commit.

- **Confirmed**: commit with `feat(optimise): <description of change> [H<N>]`
- **Partial**: commit with a note or revert at your discretion — document the decision
- **Disconfirmed**: revert the change; document why in the log

For persona experiments, use two commits if both persona files and phase directives changed:
- `feat(personas): <description> [H<N>]` — persona file additions or modifications
- `feat(optimise): update phase N persona assignment [H<N>]` — phase directive change (if any)

---

### Persona Experiment Protocol

**Applies to:** hypotheses marked `[persona experiment]`.

**Step b (persona) — Execute the evolution:**
- **Rotation**: create the new persona file if it does not exist (full `persona.md` + `soul.md` per AGENTS.md spec, including Unique Talent and Failure Mode); update the phase's persona load directive to the new file
- **Speciation**: run `/personas evolve speciate <name>`; on approval, update the phase directive to the chosen variant
- **Distillation**: run `/personas evolve distil <name> from research-log.md`; verify the file changes are applied; no phase directive change needed
- **Gap-fill**: run `/personas evolve new <description>`; on approval, add the persona load directive to the targeted phase

**Step c (persona) — Re-measure + spot-check:**

Re-measure Persona-Phase Fit and Persona Richness for the targeted phase.

Then run a **spot-check**: apply the new persona to one small, representative task drawn from the targeted phase. Scope the task to complete in a single response (e.g., audit 2–3 items rather than the full phase scope; measure one hypothesis rather than all; score one file rather than the corpus).

Score the output against the 3 quality markers defined in the hypothesis:
- Each marker: pass (clearly met) / partial (partially met) / fail (not met)
- Spot-check score = passes / 3 (or N markers if more were defined)

If possible, also score the same task under the *old* persona (or with no persona) to establish a baseline. If a prior run's output for the same task exists in `research-log.md`, use that as the baseline instead of re-running.

Record in `research-log.md`:
```markdown
**Spot-check task:** <what was run — 1 sentence>
**Spot-check output (new persona):** <key observations — 2–4 sentences>
**Marker scores:** [pass/partial/fail per marker]
**Spot-check score:** N/3
**Baseline (old persona or prior run):** <N/3 or "not available">
```

Use the spot-check score alongside the structural metric delta to determine confirmed/partial/disconfirmed. A persona experiment requires *both* structural improvement (M14 PPF or M15 PRS ≥+3pp) *and* a non-negative spot-check score to be confirmed. If structural metrics improve but the spot-check shows no quality gain, classify as partial.

**Persona experiment failure modes and recovery paths:**
- **Malformed persona file** (missing Unique Talent or Failure Mode sections): use the persona as-is but record the richness gap in the log. Score the phase as partial on M14 PPF regardless of cognitive alignment. Note in the hypothesis result: "Persona file incomplete — M15 PRS gap not closed."
- **Ambiguous spot-check markers** (quality marker cannot be scored pass/partial/fail objectively): score that marker as partial (0.5) and record the ambiguity in the `**Marker scores:**` field. A marker that is genuinely untestable in a single response does not fail — it scores partial by default.
- **Persona evolution command unavailable** (`evolve.md` not found or the `/personas evolve` skill fails): proceed without the evolve command. Create the persona manually per the AGENTS.md spec (full `persona.md` + `soul.md`, including Unique Talent and Failure Mode). Note in the result: "evolve.md unavailable — persona created manually."

After all hypotheses are processed, write a summary to `research-log.md`:

```markdown
## Experiment Summary
- Confirmed: H<list>
- Partial: H<list>
- Disconfirmed: H<list>
```

When Phase 4 is complete, read `commands/phases/p5-report.md` to continue.
