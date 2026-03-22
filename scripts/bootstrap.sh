#!/usr/bin/env zsh
# bootstrap.sh — installs the /install skill into the current repository.
#
# Usage (from any git repo):
#   zsh <(curl -sSL https://raw.githubusercontent.com/adjmunro/agentfiles/main/scripts/bootstrap.sh)
#
# Or if you have a local agentfiles checkout:
#   AGENTFILES_PATH=~/path/to/agentfiles zsh bootstrap.sh
#
# After running, use /install all (or /install <component>) in this repo.

set -e

AGENTFILES_URL="https://raw.githubusercontent.com/adjmunro/agentfiles/main"

# ── Resolve source ────────────────────────────────────────────────────────────

if [[ -n "$AGENTFILES_PATH" && -d "$AGENTFILES_PATH/skills/install" ]]; then
  echo "Using local agentfiles: $AGENTFILES_PATH"
  use_local=true
else
  echo "Fetching install skill from GitHub..."
  use_local=false
fi

# ── Detect target dirs ────────────────────────────────────────────────────────

if [[ ! -d ".git" ]]; then
  echo "Error: not a git repository. Run from your project root after git init."
  exit 1
fi

# Prefer .claude/commands/, fall back to .agents/commands/
if [[ -d ".claude" ]]; then
  target_dir=".claude/commands/install"
elif [[ -d ".agents" ]]; then
  target_dir=".agents/commands/install"
else
  # Create .claude/ as default
  mkdir -p .claude
  target_dir=".claude/commands/install"
fi

mkdir -p "$target_dir/components"

# ── Install files ─────────────────────────────────────────────────────────────

install_file() {
  local rel_path="$1"          # path within skills/install/commands/
  local dest="$2"              # destination path

  if $use_local; then
    cp "$AGENTFILES_PATH/skills/install/commands/$rel_path" "$dest"
  else
    curl -sSL "$AGENTFILES_URL/skills/install/commands/$rel_path" -o "$dest"
  fi
}

echo "Installing to $target_dir/ ..."

install_file "install.md"                              "$target_dir/install.md"
install_file "components/kanban.md"                    "$target_dir/components/kanban.md"
install_file "components/sign-hook.md"                 "$target_dir/components/sign-hook.md"
install_file "components/british-english-hook.md"      "$target_dir/components/british-english-hook.md"
install_file "components/symlinks.md"                  "$target_dir/components/symlinks.md"
install_file "components/gradle-idea.md"               "$target_dir/components/gradle-idea.md"
install_file "components/bash-guard.md"                "$target_dir/components/bash-guard.md"
install_file "components/readme-hook.md"               "$target_dir/components/readme-hook.md"
install_file "components/title-hook.md"                "$target_dir/components/title-hook.md"

echo ""
echo "✓ /install skill installed to $target_dir/"
echo ""
echo "  Run /install all         — set up standard components"
echo "  Run /install <component> — install a specific component"
echo ""
echo "  Components: kanban  symlinks  sign-hook  british-english-hook"
echo "              bash-guard  readme-hook  title-hook  gradle-idea"
