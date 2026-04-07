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
AGENTFILES_RAW="$AGENTFILES_URL"

# ── Resolve source ────────────────────────────────────────────────────────────

if [[ -n "$AGENTFILES_PATH" && -d "$AGENTFILES_PATH/skills/install" ]]; then
  echo "Using local agentfiles: $AGENTFILES_PATH"
  use_local=true
else
  echo "Fetching install skill from GitHub..."
  use_local=false
fi

# ── Verify git repo ───────────────────────────────────────────────────────────

if [[ ! -d ".git" ]]; then
  echo "Error: not a git repository. Run from your project root after git init."
  exit 1
fi

# ── Detect target skills dir ──────────────────────────────────────────────────
#
# Prefer .agents/skills/ (agent-agnostic), fall back to .claude/skills/.
# Create the chosen dir if it does not exist.

if [[ -d ".agents" ]]; then
  skills_dir=".agents/skills"
elif [[ -d ".claude" ]]; then
  skills_dir=".claude/skills"
else
  mkdir -p .claude
  skills_dir=".claude/skills"
fi

target_dir="$skills_dir/install"

mkdir -p \
  "$target_dir/commands" \
  "$target_dir/commands/components"

# ── Install helper ────────────────────────────────────────────────────────────

install_file() {
  local rel_path="$1"   # path within the skills/install/ directory in agentfiles
  local dest="$2"

  if $use_local; then
    cp "$AGENTFILES_PATH/skills/install/$rel_path" "$dest"
  else
    curl -sSL "$AGENTFILES_RAW/skills/install/$rel_path" -o "$dest"
  fi
}

# ── Install skill package ─────────────────────────────────────────────────────

echo "Installing to $target_dir/ ..."

install_file "SKILL.md"                                        "$target_dir/SKILL.md"
install_file "commands/install.md"                             "$target_dir/commands/install.md"
install_file "commands/components/kanban.md"                   "$target_dir/commands/components/kanban.md"
install_file "commands/components/sign-hook.md"                "$target_dir/commands/components/sign-hook.md"
install_file "commands/components/british-english-hook.md"     "$target_dir/commands/components/british-english-hook.md"
install_file "commands/components/symlinks.md"                 "$target_dir/commands/components/symlinks.md"
install_file "commands/components/gradle-idea.md"              "$target_dir/commands/components/gradle-idea.md"
install_file "commands/components/bash-guard.md"               "$target_dir/commands/components/bash-guard.md"
install_file "commands/components/readme-hook.md"              "$target_dir/commands/components/readme-hook.md"
install_file "commands/components/title-hook.md"               "$target_dir/commands/components/title-hook.md"

echo ""
echo "✓ /install skill installed to $target_dir/"
echo ""
echo "  Run /install all         — set up standard components"
echo "  Run /install <component> — install a specific component"
echo ""
echo "  Components: kanban  symlinks  sign-hook  british-english-hook"
echo "              bash-guard  readme-hook  title-hook  gradle-idea"

# ── Register skill alias ──────────────────────────────────────────────────────
#
# Writes a shell alias that curls skill.sh fresh from GitHub on each
# invocation — no local copy to maintain or version.
#
# Customise via env vars before running bootstrap:
#   SKILL_ALIAS=myskill   change the alias name   (default: skill)
#   SKILL_ALIAS=          skip alias registration entirely

alias_name="${SKILL_ALIAS-skill}"   # default "skill"; empty string = skip

if [[ -n "$alias_name" ]]; then
  # Detect rc file from the current shell.
  case "${SHELL:-}" in
    */zsh)  rc_file="${HOME}/.zshrc" ;;
    */bash) rc_file="${HOME}/.bashrc" ;;
    *)      rc_file="${HOME}/.zshrc" ;;
  esac

  alias_line="alias ${alias_name}='zsh <(curl -fsSL ${AGENTFILES_RAW}/scripts/skill.sh)'"
  alias_marker="# agentfiles: ${alias_name}"

  # Avoid writing a duplicate if the alias is already present.
  if grep -qF "$alias_marker" "$rc_file" 2>/dev/null; then
    echo "✓ '${alias_name}' alias already present in ${rc_file}"
  else
    {
      echo ""
      echo "${alias_marker}"
      echo "${alias_line}"
    } >> "$rc_file"
    echo "✓ '${alias_name}' alias written to ${rc_file}"
    echo "  Reload your shell or run: source ${rc_file}"
  fi

  echo ""
  echo "  ${alias_name} install <name>  — install a skill into this project"
  echo "  ${alias_name} update          — update all installed skills"
  echo "  ${alias_name} list            — list installed skills"
  echo "  ${alias_name} status          — check for available updates"
  echo ""
  echo "  Always runs the latest version of skill.sh from GitHub."
fi
