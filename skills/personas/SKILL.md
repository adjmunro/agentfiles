# Personas

A shared library of agent personas used across skills. Each persona lives in its own subdirectory with two files: `persona.md` (role, lens, DO/DO NOT) and `soul.md` (essence, values, opinions, contradictions, voice). Skills summon personas by loading the relevant files — no duplication, no drift.

## Roster

| Directory | Persona | Role |
|-----------|---------|------|
| `scribe/` | Vela (Scribe) | Verbatim transcription |
| `critic/` | Arden (Critic) | Gap-finding and audit gates |
| `scout/` | Finn (Scout) | Codebase research and mapping |
| `builder/` | Kira (Builder) | Implementation |
| `examiner/` | Echo (Examiner) | Evidence gathering |
| `advocate/` | Vale (Advocate) | PR defence |
| `strategist/` | Keeper (Strategist) | Strategic reframing |
| `designer/` | Artisan (Designer) | Visual and UX quality |
| `release/` | Helm (Release) | Final-mile shipping |
| `documentation/` | Ward (Documentation) | Doc accuracy |
| `analytics/` | Pulse (Analytics) | Metrics and retrospectives |

## Usage

To summon a persona in a skill command, load both files and adopt the role for the designated phases:

```
- `../../personas/critic/persona.md` — **Arden (Critic)** — active in Phase 3
```

The `persona.md` defines what they do; `soul.md` defines who they are. Commands that need only the role can load just `persona.md`. Commands that need character depth (e.g. summon) load both.

No invocation context needed beyond which phases the persona is active in. The persona file defines the lens; the soul file defines the voice and values.

## Commands

- `commands/summon.md` — summon one or more personas for freeform conversation
- `commands/evolve.md` — speciate, distil, and audit personas; create new variants with evidence-based sharpening

## Adding a Persona

1. Create `{name}/` directory with `persona.md` and `soul.md`.
2. `persona.md` structure: identity line, soul.md reference note, Purpose, DO (≥3 rules), DO NOT (≥2 rules), When to summon, **Failure Mode**.
3. `soul.md` structure: Essence, Core Truths (≥3), Opinions (≥2), Contradictions (≥1), Voice, **Unique Talent**, Origin (speciated personas only).
4. Add to the roster above.
5. Bump version and update CHANGELOG.md.

See `AGENTS.md` for full field definitions. **Unique Talent** and **Failure Mode** are mandatory — they are what distinguish a persona that changes behaviour from one that is merely decorative.
