# Personas Skill

## Git Commits

Use conventional commits:

```
feat(personas): short description
fix(personas): short description
refactor(personas): short description
```

## Persona Files

- One persona per file. Never split a persona across files.
- Never duplicate persona content into calling commands — single source of truth.
- `When to summon` sections must be skill-agnostic. No references to specific command paths.
- Voice, lens, DO/DO NOT all live here. The calling command declares only which phases a persona is active in.

### Required fields — `persona.md`

| Section | Notes |
|---------|-------|
| Identity line | `# Name (Role)` |
| Soul reference | Pointer to `soul.md` in same directory |
| Purpose | 1–2 sentences: what cognitive demand this persona meets |
| DO | ≥3 concrete, actionable rules |
| DO NOT | ≥2 concrete rules |
| When to summon | Skill-agnostic description of the right context |
| Failure Mode | When this persona makes things worse — the phase types or task states where it should not be loaded |

### Required fields — `soul.md`

| Section | Notes |
|---------|-------|
| Essence | 1–2 sentence distillation of the persona's fundamental nature. Must be specific enough that it could not describe any other persona in the library without modification — if the Essence could apply to a generic archetype (e.g., "finds what's wrong", "goes in first"), rewrite it to name the specific quality that makes this persona distinct. |
| Core Truths | ≥3 principles that guide their reasoning |
| Opinions | ≥2 viewpoints that reveal personality and values |
| Contradictions | ≥1 tension between stated principles and actual behaviour. Must name a tension that would be observable in output — a reader should be able to predict when the contradiction surfaces in a real response. A contradiction that could only be inferred by the author is not yet concrete enough. |
| Voice | How they communicate — tone, rhythm, characteristic moves. Must be predictive enough that someone could write a recognisable first sentence in this persona's voice without additional context — if it describes style without enabling imitation, add a characteristic phrase or sentence pattern. |
| Unique Talent | The one cognitive superpower this persona has that no other possesses in the same combination. Specific, not generic ("finds the load-bearing assumption" not "is thorough"). Self-test: if this sentence could be copy-pasted to a different persona without modification, it is not specific enough. |
| Origin | For speciated personas: parent, date, divergence axis. For original personas: omit this section. |

`Unique Talent` and `Failure Mode` are what separate a working persona from a decorative one.
A persona without them can be summoned but will not reliably change behaviour.

## Versioning

Bump version in `VERSION.md` and prepend an entry to `CHANGELOG.md` whenever a persona is added, changed, or removed. Only bump when changes are scoped to `skills/personas/`.
