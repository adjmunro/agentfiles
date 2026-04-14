# propagate-renames

Development conventions for the `propagate-renames` prompt.

## Versioning

Bump `VERSION.md` and add a `CHANGELOG.md` entry for any change to `PROMPT.md` that
alters the workflow, search patterns, output format, or edge-case handling. Patch for
fixes, minor for new reference patterns or file type support, major for breaking
changes to the output format or fix strategy.

## Language

Follow the root `AGENTS.md` language rules: Oxford British English in prose, American
English in code and identifiers.

## Scope

This prompt intentionally targets only file/directory renames tracked by git. Code
identifier renames (method names, class names, variable names) and semantic renames
(concept renamed across many prose files) are out of scope — they require a different
strategy and are not handled here.
