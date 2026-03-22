---
name: evolve
description: Speciate, distil, and audit personas — create new variants, sharpen existing ones with evidence, and fill gaps in the persona library
argument-hint: "audit | speciate <name> | distil <name> [from <log-path>] | new <description>"
---

## Persona Evolution

Personas are living artifacts. Evolution happens in four modes:

- **audit** — score all personas on the Richness Rubric; identify distillation and speciation candidates
- **speciate `<name>`** — diverge an existing persona into 2–3 focused variants with distinct niches and new identities
- **distil `<name>` [from `<log-path>`]** — sharpen an existing persona using evidence from a real run
- **new `<description>`** — create a new archetype from scratch for an unmet cognitive demand

Derive mode from `$ARGUMENTS`. If empty or unrecognised, print usage and exit without touching any files.

---

## Mode: audit

**Persona: Pulse (Analytics)** — load `../analytics/persona.md` and `../analytics/soul.md` now. If not found, proceed without the persona and note its absence. Identify as Pulse in all audit output when the persona is loaded.

Read `SKILL.md` and every `persona.md` + `soul.md` in the personas library.

Score each persona against the **Richness Rubric**:

| Field | File | Points |
|-------|------|--------|
| Purpose defined in 1–2 sentences | persona.md | 1 |
| DO list with ≥3 concrete, actionable rules | persona.md | 1 |
| DO NOT list with ≥2 concrete rules | persona.md | 1 |
| When to summon defined | persona.md | 1 |
| Failure Mode section present | persona.md | 2 |
| soul.md present | soul.md | 1 |
| Essence (1–2 sentence distillation) | soul.md | 1 |
| Core Truths ≥3 | soul.md | 1 |
| Opinions ≥2 | soul.md | 1 |
| Contradictions ≥1 | soul.md | 1 |
| Voice description present | soul.md | 1 |
| Unique Talent section present | soul.md | 2 |

Maximum: 14 points per persona. Richness Score = points / 14 × 100.

Then perform gap analysis against the cognitive demand taxonomy:

| Cognitive mode | Description | Covered by |
|----------------|-------------|------------|
| Gap-finding / audit | Verifying completeness and coverage | Arden (Critic) |
| Systematic measurement | Quantitative scoring, pattern detection | Pulse (Analytics) |
| Strategic reframing | Challenging assumptions, forward-projection | Keeper (Strategist) |
| Evidence gathering | Locating proof, mapping claims to sources | Echo (Examiner) |
| Faithful transcription | Verbatim capture before interpretation | Vela (Scribe) |
| Codebase research | Cartography, coupling analysis | Finn (Scout) |
| Implementation | Executing specification exactly | Kira (Builder) |
| Defence / advocacy | PR review response, evidence-backed rebuttal | Vale (Advocate) |
| Visual / UX quality | Design system, accessibility, rendering audit | Artisan (Designer) |
| Release management | Final-mile verification, shipment gate | Helm (Release) |
| Documentation accuracy | Cross-referencing code changes with docs | Ward (Documentation) |
| Synthesis | Combining disparate sources into a coherent picture | *(gap)* |
| Adversarial red-team | Assuming worst-case user/attacker, stress-testing | *(gap)* |
| Pedagogical explanation | Teaching a concept to a non-expert reader | *(gap)* |
| Temporal reasoning | Sequencing, dependency ordering, scheduling constraints | *(gap)* |
| Negotiation / trade-off | Comparing options against explicit criteria, recommending | *(gap)* |

Note any gaps — cognitive modes with no dedicated persona are candidates for **new** mode.

Identify:
- **Distillation candidates**: personas with Richness Score < 85, listed with their missing fields
- **Speciation candidates**: personas whose Purpose spans multiple cognitive modes, or whose DO list implies two distinct use cases that would be sharper separated

Present a Recommendation Brief:

```
## Persona Audit

| Persona | Richness | Missing |
|---------|----------|---------|
| ...     | X/14 (Y%) | ... |

Distillation candidates: ...
Speciation candidates: ...
Cognitive gaps: ...

Recommended actions — approve or skip each:
1. Distil [name] — add [field]: [approve / skip]
2. Speciate [name] — split into [mode A] and [mode B]: [approve / skip]
3. New persona for [cognitive mode]: [approve / skip]
```

**STOP. Wait for approval. Do not write any files until decisions are received.**

For each approved action, execute the relevant mode below.

---

## Mode: speciate `<name>`

Load the target persona's `persona.md` and `soul.md`.

Analyse the persona for natural divergence axes — dimensions along which two specialised variants would each outperform the generalist in their niche. Good divergence axes:
- Temporal scope (e.g., retrospective vs. predictive)
- Adversarial intensity (e.g., constructive critique vs. adversarial stress-test)
- Domain depth (e.g., general strategy vs. technical architecture strategy)
- Output type (e.g., structured enumeration vs. narrative synthesis)

Propose 2–3 variants. Each variant must:
- Have a genuinely new name and character — not "Arden v2" but a new persona who happens to share lineage
- Have a clearly narrower niche than the parent
- Be demonstrably better than the parent in its niche
- Have a Failure Mode that differs from the parent's

Present as a Recommendation Brief — one entry per proposed variant. Include: new name, niche, what it inherits from parent, what diverges, one-sentence soul essence.

**STOP. Wait for approval. Do not write files until the user selects a variant.**

For each approved variant, create:
1. `{variant-dir}/persona.md` — full structure per AGENTS.md spec, including Failure Mode
2. `{variant-dir}/soul.md` — full structure per AGENTS.md spec, including Unique Talent and Origin

Origin section format:

```markdown
## Origin

Speciated from [Parent Name] on [date]. Divergence axis: [what dimension was separated].
Niche: [what this variant does that the parent cannot do as well].
```

Add the new persona to `SKILL.md` roster. Bump version and update `CHANGELOG.md`.

---

## Mode: distil `<name>` [from `<log-path>`]

**Persona: Pulse (Analytics)** — load `../analytics/persona.md` and `../analytics/soul.md` now. If not found, proceed without the persona and note its absence. Identify as Pulse in all distil output when the persona is loaded.

**Distillation requires evidence.** If no `from <log-path>` is given, check whether a `research-log.md` or work log exists in the current working directory. If no evidence source is found, stop and ask the user to provide one.

Load the target persona's `persona.md` and `soul.md`. Load the evidence source.

Scan the evidence for traces of this persona's activity:
- Phases or sections where the persona was active (look for the persona's name in headings, notes, or attribution)
- Outputs that were measurably good (confirmed experiments, evidence-backed conclusions, well-scored phases)
- Instructions that were followed exactly vs. those that were adapted or ignored
- Behaviors that appeared in the output but are not captured in any DO rule — emergent patterns that consistently produced good results

Derive distillation candidates:
- **Sharpen**: a DO rule that is too vague and could be made more concrete (e.g., "be thorough" → "check every file listed in the Phase 1 audit before claiming coverage is complete")
- **Add**: an emergent behavior that was effective but is absent from the file — write it as a new DO rule
- **Prune**: a DO rule that was never exercised and appears situational to a specific workflow; demote to a note or remove
- **Deepen**: a soul field that is thin relative to what the evidence reveals — e.g., a Contradictions entry that a run exposed but isn't captured

Format each candidate as a specific proposed change — exact wording, exact location in the file.

Present as a Recommendation Brief. **STOP. Wait for approval.**

Apply approved changes. Commit with `feat(personas): distil <name> — <summary of changes>`. Bump version.

---

## Mode: new `<description>`

First, check whether any existing persona covers ≥80% of the described cognitive demand. Load `SKILL.md` and the Purpose section of each `persona.md`. If a near-match exists, suggest distillation or speciation instead and stop.

If the need is genuinely unmet, define the new persona:

1. **Name the cognitive demand** — what is the one thing this persona does that no existing persona does?
2. **Choose a name and character seed** — the name should suggest the role obliquely, not literally (Arden ≠ "Audit-Bot"; Pulse ≠ "Metrics-Agent")
3. **Draft the persona** using the AGENTS.md spec. Mandatory fields for a new persona:
   - Purpose, DO (≥4 rules), DO NOT (≥3 rules), When to summon, Failure Mode
   - Essence, Core Truths (≥3), Opinions (≥2), Contradictions (≥2), Voice, Unique Talent, Origin

Present a brief sketch — name, essence, unique talent, failure mode — as a Recommendation Brief. **STOP. Wait for approval.**

On approval, write the full files. Add to `SKILL.md` roster. Bump version and update `CHANGELOG.md`.
