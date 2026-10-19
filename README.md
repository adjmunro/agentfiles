# agentfiles

A private Claude Code plugin marketplace.

```
/plugin marketplace add adjmunro/agentfiles
/plugin install <plugin>@adjmunro
```

## Plugins

| Plugin | Path |
|---|---|
| `general` | [plugins/general](plugins/general) |
| `software-factory` | [plugins/software-factory](plugins/software-factory) |
| `git` | [plugins/git](plugins/git) |

## Adding a plugin

1. Create `plugins/<name>/.claude-plugin/plugin.json`.
2. Put skills in `plugins/<name>/skills/<skill>/SKILL.md`.
3. Add an entry to `.claude-plugin/marketplace.json` with
   `"source": "./plugins/<name>"`.

Each plugin is installed on its own, so a plugin can only reference files
inside its own directory.
