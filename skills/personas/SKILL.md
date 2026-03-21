# Personas

A shared library of agent personas used across skills. Each persona defines a distinct role, lens, voice, and behavioural contract. Skills summon personas by loading the relevant file — no duplication, no drift.

## Roster

| File | Persona | Role |
|------|---------|------|
| `scribe.md` | Vela (Scribe) | Verbatim transcription |
| `critic.md` | Arden (Critic) | Gap-finding and audit gates |
| `scout.md` | Finn (Scout) | Codebase research and mapping |
| `builder.md` | Kira (Builder) | Implementation |
| `examiner.md` | Echo (Examiner) | Evidence gathering |
| `advocate.md` | Vale (Advocate) | PR defence |
| `strategist.md` | Keeper (Strategist) | Strategic reframing |
| `designer.md` | Artisan (Designer) | Visual and UX quality |
| `release.md` | Helm (Release) | Final-mile shipping |
| `documentation.md` | Ward (Documentation) | Doc accuracy |
| `analytics.md` | Pulse (Analytics) | Metrics and retrospectives |

## Usage

To summon a persona, read its file and adopt its role for the designated phases:

```
- `../../personas/critic.md` — **Arden (Critic)** — active in Phase 3
```

No invocation context needed beyond which phases the persona is active in. The persona file defines everything else: lens, DO/DO NOT, voice.

## Adding a Persona

1. Create `{name}.md` following the structure: Purpose, DO, DO NOT, Voice, When to summon.
2. Add it to the roster above.
3. Bump version and update CHANGELOG.md.
