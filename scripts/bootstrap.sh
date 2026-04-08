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
#
# Env vars:
#   AGENTFILES_PATH   path to a local agentfiles checkout (skips GitHub fetch)
#   AGENTFILES_ALIAS  name for the shell function  (default: agentfiles)

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

# ── Write shell function ──────────────────────────────────────────────────────
#
# Asks where to write the shell function, then appends it to that file.
# The function caches skill.sh locally and re-fetches only when stale (1 hour).
#
# Use AGENTFILES_ALIAS to change the function name (default: agentfiles).

fn_name="${AGENTFILES_ALIAS:-agentfiles}"
cli_url="${AGENTFILES_RAW}/scripts/agentfiles.sh"

fn_body="${fn_name}() {
  local _cache=\"\${XDG_CACHE_HOME:-\$HOME/.cache}/agentfiles/agentfiles.sh\"
  local _ttl=3600
  if [[ ! -f \"\$_cache\" ]] || (( \$(date +%s) - \$(date -r \"\$_cache\" +%s 2>/dev/null || echo 0) > _ttl )); then
    mkdir -p \"\${_cache:h}\"
    if ! curl -fsSL '${cli_url}' -o \"\$_cache\" 2>/dev/null; then
      echo \"agentfiles: failed to fetch CLI — the URL may have moved.\" >&2
      echo \"  Re-run bootstrap to get the updated function:\" >&2
      echo \"    zsh <(curl -sSL https://raw.githubusercontent.com/${AGENTFILES_REPO}/main/scripts/bootstrap.sh)\" >&2
      return 1
    fi
  fi
  zsh \"\$_cache\" \"\$@\"
}"

# Sentinel file written on successful setup — unambiguous detection that works
# regardless of where the function was placed or what it was named.
sentinel="${HOME}/.config/agentfiles/installed"

echo ""

if [[ -f "$sentinel" ]]; then
  echo "✓ agentfiles already set up (see ${sentinel}) — skipping shell function."
else
  if [[ -t 0 ]]; then
    # Interactive terminal: prompt for the rc file path.
    printf "Where should the '${fn_name}' shell function be written?\n"
    printf "File will be created if it does not exist. Leave blank to skip.\n"
    printf "Path [~/.zshrc]: "
    read rc_path
  else
    # Non-interactive (e.g. Claude, CI): use AGENTFILES_RC env var or skip.
    rc_path="${AGENTFILES_RC:-}"
    if [[ -n "$rc_path" ]]; then
      echo "Non-interactive: writing '${fn_name}' function to AGENTFILES_RC=${rc_path}"
    else
      echo "Non-interactive: skipping shell function setup."
      echo "  Re-run interactively or set AGENTFILES_RC=<path> to write automatically."
    fi
  fi

  if [[ -z "$rc_path" ]]; then
    echo "Skipped shell function setup."
  else
    # Expand leading ~ to $HOME
    rc_path="${rc_path/#~/${HOME}}"

    mkdir -p "$(dirname "$rc_path")"
    printf "\n%s\n" "$fn_body" >> "$rc_path"

    # Write sentinel so future bootstrap runs skip this step.
    mkdir -p "$(dirname "$sentinel")"
    printf "%s\n%s\n" "$rc_path" "$cli_url" > "$sentinel"

    echo "✓ '${fn_name}' function written to ${rc_path}"
    echo "  Reload with: source ${rc_path}"
  fi
fi

echo ""
echo "  ${fn_name} install skill/<name>    — install a skill"
echo "  ${fn_name} install hook/<name>     — install a hook"
echo "  ${fn_name} install command/<name>  — install a command"
echo "  ${fn_name} update                  — update all installed skills"
echo "  ${fn_name} status                  — check for updates"
echo "  ${fn_name} force-update            — clear cache and re-download CLI"
echo ""
echo "  Caches agentfiles.sh for 1 hour; re-fetches automatically when stale."
