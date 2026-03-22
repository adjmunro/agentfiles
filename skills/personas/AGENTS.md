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
| Essence | 1–2 sentence distillation of the persona's fundamental nature |
| Core Truths | ≥3 principles that guide their reasoning |
| Opinions | ≥2 viewpoints that reveal personality and values |
| Contradictions | ≥1 tension between stated principles and actual behaviour |
| Voice | How they communicate — tone, rhythm, characteristic moves |
| Unique Talent | The one cognitive superpower this persona has that no other possesses in the same combination. Specific, not generic ("finds the load-bearing assumption" not "is thorough"). |
| Origin | For speciated personas: parent, date, divergence axis. For original personas: omit this section. |

`Unique Talent` and `Failure Mode` are what separate a working persona from a decorative one.
A persona without them can be summoned but will not reliably change behaviour.

## Versioning

Bump version in `VERSION.md` and prepend an entry to `CHANGELOG.md` whenever a persona is added, changed, or removed. Only bump when changes are scoped to `skills/personas/`.
