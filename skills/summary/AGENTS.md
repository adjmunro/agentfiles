# Summary Skill

## Git Commits

Use **conventional commits** for all changes:

```
feat(scope): short description
fix(scope): short description
refactor(scope): short description
docs(scope): short description
chore(scope): short description
```

The commit body should be generated — describe what changed, why, and any non-obvious side effects. Keep the subject line under 72 characters.

Common scopes: `summary`, `commands`, `skills`

Examples:
- `feat(summary): add trunk mode for divergence-from-main scope`
- `fix(summary): correct ref resolution for detached HEAD state`
- `refactor(summary): split open-work scan into its own phase`

**Never force push.** This is a hard rule with no exceptions.

---

## Scope

This skill is read-only with respect to the repository it operates on. It reads git history and file contents; it never writes or modifies anything in the target repository.

The only files it may write are its own output artefacts — and only when the user explicitly requests a saved summary (e.g. a markdown file). By default, output goes to the terminal only.

---

## DO

- Derive the git ref boundary from `$ARGUMENTS` before reading any changed files
- Read changed `CHANGELOG.md` files to extract structured descriptions of intent
- Read changed `SKILL.md`, `commands/*.md`, and `persona.md` files to understand what was touched
- Group changes by area (skill, persona, commands) rather than by commit order
- Extract "why" from commit message bodies, not just subjects
- Scan `.kanban/` for any tickets in `04-todo/`, `05-in-progress/`, or `06-in-review/` and surface them in the Open work section
- When the mode is `pr`, frame the output for a reviewer who is evaluating whether to approve the branch
- Identify any changed documentation and flag if it appears to have drifted from the code changes

## DO NOT

- Modify any files in the repository being summarised
- Invent features or changes that are not evidenced in the git log or changed files
- Summarise commits without reading their bodies — the body is where the "why" lives
- Conflate multiple areas into a single "Changes by area" entry — keep groupings distinct
- Omit the Open work section even if it is empty — an explicit "no open tickets found" is more useful than silence
- Treat a CHANGELOG entry as authoritative if the changed files contradict it — flag the discrepancy

---

## Versioning

**Only bump the version when changes are scoped to `skills/summary/`.** If a commit touches other parts of the repo but not this skill, do not bump the summary version.

Before committing any summary changes, bump the version in `VERSION.md`. Use semver:
- Patch (1.0.0 → 1.0.1): Bug fixes, typos, minor corrections
- Minor (1.0.0 → 1.1.0): New features, new modes, behaviour changes
- Major (1.0.0 → 2.0.0): Breaking changes to the output structure or mode set

**Immediately after bumping the version, update `CHANGELOG.md`.**

---

## Changelog

Add a new entry at the top of the file (below the header):

```markdown
## X.Y.Z - YYYY-MM-DD - Short Title

### Added / Changed / Fixed
- bullet points
```

Rules:
- **Newest on top.** File reads newest-to-oldest.
- **Date every entry.** Format: `YYYY-MM-DD`.
- **Every version gets an entry.** No skipping.
