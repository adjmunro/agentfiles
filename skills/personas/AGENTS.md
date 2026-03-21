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

## Versioning

Bump version in `VERSION.md` and prepend an entry to `CHANGELOG.md` whenever a persona is added, changed, or removed. Only bump when changes are scoped to `skills/personas/`.
