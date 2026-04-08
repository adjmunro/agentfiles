#!/usr/bin/env zsh
# agentfiles — component manager for agentfiles repositories
# Installs and updates components from a remote (or local) agentfiles repository.
#
# Usage:
#   agentfiles available [type]        List installable components from the source
#   agentfiles install <type>/<name>   Install a component
#   agentfiles update [<type>/<name>]  Update installed components (default: all)
#   agentfiles list                    List installed components and their versions
#   agentfiles status                  Check for available updates
#   agentfiles remove <type>/<name>    Remove an installed component
#   agentfiles force-update            Clear CLI cache and re-download
#
# Types (all directory-based, all carry VERSION.md):
#   skill/<name>    skills/<name>/     →  <skills_dir>/<name>/
#   hook/<name>     hooks/<name>/      →  .claude/hooks/<name>/
#   prompt/<name>   prompts/<name>/    →  .claude/prompts/<name>/
#   command/<name>  commands/<name>/   →  .claude/commands/<name>/   [deprecated]
#
# Prompts are one-shot agent instructions (environment-aware, run once).
# They install to .claude/prompts/ rather than .claude/commands/.
#
# Configuration (environment variables):
#   AGENTFILES_REPO    GitHub repo slug  (default: adjmunro/agentfiles)
#   AGENTFILES_BRANCH  Branch to use     (default: main)
#   AGENTFILES_PATH    Path to a local clone — skips GitHub entirely (for testing)

set -euo pipefail

# ── Configuration ─────────────────────────────────────────────────────────────

AGENTFILES_REPO="${AGENTFILES_REPO:-adjmunro/agentfiles}"
AGENTFILES_BRANCH="${AGENTFILES_BRANCH:-main}"
AGENTFILES_REMOTE="https://github.com/${AGENTFILES_REPO}.git"
AGENTFILES_RAW="https://raw.githubusercontent.com/${AGENTFILES_REPO}/${AGENTFILES_BRANCH}"

CACHE_FILE="${XDG_CACHE_HOME:-${HOME}/.cache}/agentfiles/agentfiles.sh"

# ── Type maps ─────────────────────────────────────────────────────────────────

# Map an install type to its subdirectory in the agentfiles repo.
type_repo_dir() {
  case "$1" in
    skill)   print "skills"   ;;
    hook)    print "hooks"    ;;
    prompt)  print "prompts"  ;;
    command) print "commands" ;;
    *) die "unknown type '${1}' — supported: skill, hook, prompt  (command is deprecated)" ;;
  esac
}

# Map an install type to its local destination base directory.
type_local_base() {
  case "$1" in
    skill)   skills_dir ;;
    hook)    print ".claude/hooks" ;;
    prompt)  print ".claude/prompts" ;;
    command) print ".claude/commands" ;;
  esac
}

# ── Helpers ───────────────────────────────────────────────────────────────────

die()  { print -u2 "agentfiles: error: $*"; exit 1 }
step() { print "  $*" }
ok()   { print "✓ $*" }

# Parse <type>/<name> into _type and _name.
parse_ref() {
  local ref="$1"
  [[ "$ref" == */* ]] || die "expected <type>/<name>, got '${ref}' — e.g. skill/implement"
  _type="${ref%%/*}"
  _name="${ref#*/}"
}

# Detect the skills directory for the current project (no side effects).
skills_dir() {
  if   [[ -d ".agents/skills" ]]; then print ".agents/skills"
  elif [[ -d ".claude/skills" ]]; then print ".claude/skills"
  elif [[ -d ".agents"        ]]; then print ".agents/skills"
  else                                  print ".claude/skills"
  fi
}

# Extract the first semver string from content.
parse_version() {
  grep -oE '[0-9]+\.[0-9]+\.[0-9]+' <<< "$1" | head -1
}

# Fetch the version from a component's remote VERSION.md.
# Arg: repo-relative path to the component directory (e.g. "skills/implement")
remote_version() {
  local repo_path="$1"
  local content
  if [[ -n "${AGENTFILES_PATH:-}" ]]; then
    local vfile="${AGENTFILES_PATH}/${repo_path}/VERSION.md"
    [[ -f "$vfile" ]] || { print ""; return 0; }
    content="$(< "$vfile")"
  else
    content=$(curl -fsSL "${AGENTFILES_RAW}/${repo_path}/VERSION.md" 2>/dev/null) \
      || { print ""; return 0; }
  fi
  parse_version "$content"
}

# Read the version from an installed component's local VERSION.md.
# Arg: absolute or relative path to the installed component directory.
local_version() {
  local local_dest="$1"
  local vfile="${local_dest}/VERSION.md"
  [[ -f "$vfile" ]] || { print ""; return 0; }
  parse_version "$(< "$vfile")"
}

# Fetch a component directory from the source into a local destination.
# Uses AGENTFILES_PATH if set, otherwise sparse-clones from GitHub.
fetch_component() {
  local repo_path="$1"
  local local_dest="$2"

  if [[ -n "${AGENTFILES_PATH:-}" ]]; then
    local src="${AGENTFILES_PATH}/${repo_path}"
    [[ -d "$src" ]] || die "not found in local clone: ${src}"
    mkdir -p "$local_dest"
    cp -r "${src}/." "$local_dest/"
  else
    local tmp; tmp=$(mktemp -d)
    trap "rm -rf '${tmp}'" EXIT INT TERM

    (
      git clone --quiet --filter=blob:none --sparse --depth=1 \
        "$AGENTFILES_REMOTE" "$tmp" 2>/dev/null
      git -C "$tmp" sparse-checkout set "$repo_path" >/dev/null 2>&1
    ) || die "failed to fetch '${repo_path}' from ${AGENTFILES_REPO}"

    local src="${tmp}/${repo_path}"
    [[ -d "$src" ]] || die "'${repo_path}' not found in repository"
    mkdir -p "$local_dest"
    cp -r "${src}/." "$local_dest/"

    rm -rf "$tmp"
    trap - EXIT INT TERM
  fi
}

# List component names available under a repo directory.
# Uses AGENTFILES_PATH if set, otherwise a no-checkout git clone + ls-tree.
list_remote_components() {
  local repo_dir="$1"   # e.g. "skills", "hooks"

  if [[ -n "${AGENTFILES_PATH:-}" ]]; then
    local base="${AGENTFILES_PATH}/${repo_dir}"
    [[ -d "$base" ]] || return 0
    for d in "${base}"/*/; do
      [[ -d "$d" ]] && print "${d%/}" | sed "s|.*/||"
    done
    return
  fi

  local tmp; tmp=$(mktemp -d)
  trap "rm -rf '${tmp}'" EXIT INT TERM

  git clone --quiet --filter=blob:none --sparse --no-checkout --depth=1 \
    "$AGENTFILES_REMOTE" "$tmp" 2>/dev/null \
    || { print -u2 "agentfiles: warning: could not reach ${AGENTFILES_REPO}"; return 1; }

  git -C "$tmp" ls-tree HEAD "${repo_dir}/" 2>/dev/null \
    | awk '$2 == "tree" { sub(/.*\//, "", $4); print $4 }'

  rm -rf "$tmp"
  trap - EXIT INT TERM
}

# ── Commands ──────────────────────────────────────────────────────────────────

cmd_available() {
  local filter_type="${1:-}"
  local -a types

  if [[ -n "$filter_type" ]]; then
    type_repo_dir "$filter_type" >/dev/null  # validates the type
    types=("$filter_type")
  else
    types=(skill hook prompt)
  fi

  local source_label
  [[ -n "${AGENTFILES_PATH:-}" ]] \
    && source_label="local: ${AGENTFILES_PATH}" \
    || source_label="${AGENTFILES_REPO} (${AGENTFILES_BRANCH})"
  print "Available components from ${source_label}:"
  print ""

  for type in "${types[@]}"; do
    local repo_dir; repo_dir=$(type_repo_dir "$type")
    local local_base; local_base=$(type_local_base "$type")
    print "  ${repo_dir}:"
    local found=false
    while IFS= read -r name; do
      [[ -z "$name" ]] && continue
      found=true
      local local_dest="${local_base}/${name}"
      local installed=""
      local version; version=$(local_version "$local_dest")
      [[ -n "$version" ]] && installed=" (installed v${version})"
      printf "    %s/%s%s\n" "$type" "$name" "$installed"
    done < <(list_remote_components "$repo_dir")
    $found || print "    (none)"
  done
}

cmd_install() {
  local ref="${1:?usage: agentfiles install <type>/<name>}"
  local _type _name; parse_ref "$ref"
  local repo_dir; repo_dir=$(type_repo_dir "$_type")
  local local_base; local_base=$(type_local_base "$_type")
  local repo_path="${repo_dir}/${_name}"
  local local_dest="${local_base}/${_name}"

  local version; version=$(remote_version "$repo_path")
  [[ -z "$version" ]] && die "${ref} not found in ${AGENTFILES_PATH:-${AGENTFILES_REPO}}"

  local current; current=$(local_version "$local_dest")

  # When using a local path, always install (version may not be bumped yet).
  if [[ -z "${AGENTFILES_PATH:-}" && "$current" == "$version" ]]; then
    print "${ref} is already at v${version}."
    return
  fi

  if [[ -n "${AGENTFILES_PATH:-}" ]]; then
    print "Installing ${ref} v${version} from local..."
  elif [[ -n "$current" ]]; then
    print "Updating ${ref} v${current} → v${version}..."
  else
    print "Installing ${ref} v${version}..."
  fi

  fetch_component "$repo_path" "$local_dest"
  step "→ ${local_dest}/"
  ok "${ref} v${version} installed"
}

cmd_update() {
  local ref="${1:-}"

  if [[ -z "$ref" ]]; then
    # Update all installed versioned components.
    local found=false
    for type in skill hook prompt; do
      local local_base; local_base=$(type_local_base "$type")
      [[ -d "$local_base" ]] || continue
      for component_dir in "${local_base}"/*/; do
        [[ -d "$component_dir" ]] || continue
        [[ -f "${component_dir}VERSION.md" ]] || continue
        found=true
        local name="${component_dir%/}"; name="${name##*/}"
        cmd_update "${type}/${name}"
      done
    done
    $found || print "No versioned components installed."
    return
  fi

  local _type _name; parse_ref "$ref"
  local repo_dir; repo_dir=$(type_repo_dir "$_type")
  local local_base; local_base=$(type_local_base "$_type")
  local repo_path="${repo_dir}/${_name}"
  local local_dest="${local_base}/${_name}"

  local current; current=$(local_version "$local_dest")
  [[ -z "$current" ]] && die "${ref} is not installed (run: agentfiles install ${ref})"

  local latest; latest=$(remote_version "$repo_path")
  [[ -z "$latest" ]] && die "could not reach source for '${ref}'"

  if [[ -z "${AGENTFILES_PATH:-}" && "$current" == "$latest" ]]; then
    print "${ref}: already up to date (v${current})"
    return
  fi

  cmd_install "$ref"
}

cmd_list() {
  local found=false
  for type in skill hook prompt; do
    local local_base; local_base=$(type_local_base "$type")
    [[ -d "$local_base" ]] || continue
    for component_dir in "${local_base}"/*/; do
      [[ -d "$component_dir" ]] || continue
      [[ -f "${component_dir}VERSION.md" ]] || continue
      found=true
      local name="${component_dir%/}"; name="${name##*/}"
      local version; version=$(local_version "$component_dir")
      printf "  %-8s %-22s v%s\n" "${type}" "$name" "$version"
    done
  done
  $found || print "No versioned components installed."
}

cmd_status() {
  print "Checking for updates..."
  local found=false
  for type in skill hook prompt; do
    local local_base; local_base=$(type_local_base "$type")
    local repo_dir; repo_dir=$(type_repo_dir "$type")
    [[ -d "$local_base" ]] || continue
    for component_dir in "${local_base}"/*/; do
      [[ -d "$component_dir" ]] || continue
      [[ -f "${component_dir}VERSION.md" ]] || continue
      found=true
      local name="${component_dir%/}"; name="${name##*/}"
      local current; current=$(local_version "$component_dir")
      local latest;  latest=$(remote_version "${repo_dir}/${name}" 2>/dev/null) || latest=""

      if [[ -z "$latest" ]]; then
        printf "  %-8s %-22s v%s  (remote unavailable)\n" "$type" "$name" "$current"
      elif [[ "$current" == "$latest" ]]; then
        printf "  %-8s %-22s v%s  up to date\n" "$type" "$name" "$current"
      else
        printf "  %-8s %-22s v%s → v%s  UPDATE AVAILABLE\n" "$type" "$name" "$current" "$latest"
      fi
    done
  done
  $found || print "  No versioned components installed."
}

cmd_remove() {
  local ref="${1:?usage: agentfiles remove <type>/<name>}"
  local _type _name; parse_ref "$ref"
  local local_base; local_base=$(type_local_base "$_type")
  local local_dest="${local_base}/${_name}"

  [[ -e "$local_dest" ]] || die "${ref} is not installed"
  rm -rf "$local_dest"
  ok "${ref} removed"
}

cmd_force_update() {
  print "Refreshing agentfiles CLI cache..."
  mkdir -p "${CACHE_FILE:h}"
  curl -fsSL "${AGENTFILES_RAW}/scripts/agentfiles.sh" -o "$CACHE_FILE" \
    || die "failed to download agentfiles.sh from ${AGENTFILES_RAW}"
  ok "CLI cached at ${CACHE_FILE}"
}

# ── Dispatch ──────────────────────────────────────────────────────────────────

case "${1:-}" in
  available)    shift; cmd_available   "${1:-}" ;;
  install)      shift; cmd_install     "$@" ;;
  update)       shift; cmd_update      "${1:-}" ;;
  list)         cmd_list ;;
  status)       cmd_status ;;
  remove)       shift; cmd_remove      "$@" ;;
  force-update) cmd_force_update ;;
  *)
    print "Usage: agentfiles <command> [args]"
    print ""
    print "Commands:"
    print "  available [type]         List installable components from the source"
    print "  install <type>/<name>    Install a component"
    print "  update [<type>/<name>]   Update installed components (default: all)"
    print "  list                     List installed components and their versions"
    print "  status                   Check for available updates"
    print "  remove <type>/<name>     Remove an installed component"
    print "  force-update             Clear CLI cache and re-download"
    print ""
    print "Types (all directory-based, all carry VERSION.md):"
    print "  skill/<name>    skills/<name>/    →  <skills_dir>/<name>/"
    print "  hook/<name>     hooks/<name>/     →  .claude/hooks/<name>/"
    print "  prompt/<name>   prompts/<name>/   →  .claude/prompts/<name>/"
    print ""
    print "Environment:"
    print "  AGENTFILES_REPO    Source repo       (default: adjmunro/agentfiles)"
    print "  AGENTFILES_BRANCH  Branch            (default: main)"
    print "  AGENTFILES_PATH    Local clone path  (skips GitHub, for testing)"
    ;;
esac
