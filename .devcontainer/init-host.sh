#!/bin/bash
#
# .devcontainer/init-host.sh
# --------------------------
# Run by devcontainer.json `initializeCommand`, which executes on the HOST
# machine *before* the container is created. This is the correct place to make
# sure every host-side bind-mount source exists, because bind mounts are
# resolved by the container engine at create time:
#
#   - if a source path is missing, container creation can fail outright, and
#   - for *file* mounts (e.g. ~/.gitconfig) the engine may silently create an
#     empty *directory* in its place, which then breaks the tool inside.
#
# Rather than duplicating the mount list here, we parse the `mounts` array
# straight out of devcontainer.json so the two can never drift apart.
#
# This runs on the host, so we avoid hard dependencies (no jq/python required)
# and use a small, dependency-free parser.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEVCONTAINER_JSON="$SCRIPT_DIR/devcontainer.json"

if [ "${CODESPACES:-}" = "true" ]; then
  echo "init-host: running in Codespaces; skipping host-side mount setup"
  exit 0
fi

if [[ ! -f "$DEVCONTAINER_JSON" ]]; then
  echo "init-host: error: cannot find devcontainer.json at $DEVCONTAINER_JSON" >&2
  exit 1
fi

# Resolve devcontainer ${localEnv:VAR} placeholders against the host environment.
# Unset variables resolve to an empty string, matching devcontainer behaviour
# (e.g. ${localEnv:USERPROFILE} is empty on macOS/Linux).
resolve_localenv() {
  local value="$1"
  while [[ "$value" =~ \$\{localEnv:([A-Za-z_][A-Za-z0-9_]*)\} ]]; do
    local var="${BASH_REMATCH[1]}"
    local replacement="${!var:-}"
    value="${value//\$\{localEnv:$var\}/$replacement}"
  done
  printf '%s' "$value"
}

# Extract the value of a key=value pair from a comma-separated mount string.
mount_field() {
  local spec="$1" key="$2"
  local part
  IFS=',' read -ra parts <<<"$spec"
  for part in "${parts[@]}"; do
    if [[ "$part" == "$key="* ]]; then
      printf '%s' "${part#"$key"=}"
      return 0
    fi
  done
  return 1
}

# Pull each mount string out of devcontainer.json. Mount entries are JSON
# strings containing "source=" and "target=" fields; we strip JSONC line
# comments, quotes, and trailing commas. This intentionally ignores object-form
# mounts, which this repo does not use.
#
# We use a while/read loop (not `mapfile`) so this works on the bash 3.2 that
# ships by default on macOS as well as the bash 5.x on Debian. `sed -E`/`grep -E`
# are common to both GNU and BSD userlands.
MOUNT_SPECS=()
while IFS= read -r line; do
  [[ -n "$line" ]] && MOUNT_SPECS+=("$line")
done < <(
  sed -E 's#//.*$##' "$DEVCONTAINER_JSON" \
    | grep -E '"[^"]*source=[^"]*target=[^"]*"' \
    | sed -E 's#^[[:space:]]*"##; s#",?[[:space:]]*$##'
)

if [[ ${#MOUNT_SPECS[@]} -eq 0 ]]; then
  echo "init-host: no string bind mounts found in devcontainer.json; nothing to do"
  exit 0
fi

for spec in "${MOUNT_SPECS[@]}"; do
  type="$(mount_field "$spec" type || true)"
  if [[ -n "$type" && "$type" != "bind" ]]; then
    # Only bind mounts have a host-side source path we need to materialise.
    continue
  fi

  raw_source="$(mount_field "$spec" source || true)"
  if [[ -z "$raw_source" ]]; then
    echo "init-host: warning: could not parse source from mount: $spec" >&2
    continue
  fi

  path="$(resolve_localenv "$raw_source")"

  if [[ -e "$path" ]]; then
    # Source already exists; leave it untouched whether it's a file or dir.
    continue
  fi

  # The source is missing and devcontainer bind mounts don't record whether the
  # source should be a file or a directory, so we infer it. This only applies to
  # *newly created* sources; anything that already exists is respected above.
  #
  #   1. A basename with a real extension (a dot that isn't the leading dotfile
  #      dot), e.g. config.toml, is treated as a file.
  #   2. An extensionless dotfile is genuinely ambiguous (.ssh is a directory but
  #      .gitconfig is a file), so we consult a small disambiguation set of
  #      well-known dotfiles that are regular files.
  #   3. Everything else defaults to a directory.
  base="$(basename "$path")"
  KNOWN_FILE_BASENAMES=(
    .gitconfig .bashrc .bash_profile .zshrc .profile .npmrc .netrc .gitignore
  )
  is_file=0
  if [[ "${base#.}" == *.* ]]; then
    is_file=1
  else
    for known in "${KNOWN_FILE_BASENAMES[@]}"; do
      if [[ "$base" == "$known" ]]; then
        is_file=1
        break
      fi
    done
  fi

  if [[ "$is_file" -eq 1 ]]; then
    echo "init-host: creating missing mount file: $path"
    mkdir -p "$(dirname "$path")"
    touch "$path"
  else
    echo "init-host: creating missing mount directory: $path"
    mkdir -p "$path"
  fi
done
