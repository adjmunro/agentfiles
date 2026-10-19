# Shared

Material reused by more than one skill in this plugin.

Link to it from a skill's `SKILL.md` with a relative Markdown link, e.g.
`[conventions](../../shared/conventions.md)`. Claude resolves the path
from the skill's own directory.

Only this plugin's directory is copied when the plugin is installed, so
anything a skill links to must live inside `plugins/software-factory/`.
Material shared across plugins has to be duplicated into each one.
