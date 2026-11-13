#!/usr/bin/env bash
# No `set -e` here: each step runs in its own `set -e` subshell so one
# failing step doesn't stop the rest.
set -uo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

STEPS="submodules packages ohmyzsh syntax p10k link"
SKIPPED=2

# "package" or "package:command" when the binary name differs.
PACKAGES=(
  zsh
  jq
  yq
  vim
  tmux
  ripgrep:rg
  fzf
  neovim:nvim
  git-delta:delta
)

# "path" links $DOTFILES_DIR/path -> $HOME/path,
# "src:target" links $DOTFILES_DIR/src -> $HOME/target.
LINKS=(
  .gitconfig
  .zshrc
  .p10k.zsh
  .vimrc
  .tmux.conf
  .scripts
  .config/aerospace
  .config/ghostty
  .config/lazygit
  .config/nvim
  .config/zshrc.d
  .local/share/fonts
  AGENTS.md:.claude/CLAUDE.md
  AGENTS.md:.codex/AGENTS.md
)

DRY_RUN=0

usage() {
  cat <<EOF
Usage: bash init.sh [options] [step...]

Runs all steps unless steps are given.

Steps: $STEPS

Options:
  -n, --dry-run   print what would be done, change nothing
  --no-<step>     skip a step, e.g. --no-packages
  -h, --help      show this help
EOF
}

log()  { echo "    $*"; }
warn() { echo "    warning: $*" >&2; }

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "    [dry-run] $*"
  else
    "$@"
  fi
}

detect_pkg_manager() {
  if command -v brew &>/dev/null; then
    echo "brew"
  elif command -v dnf &>/dev/null; then
    echo "dnf"
  elif command -v apt-get &>/dev/null; then
    echo "apt"
  else
    echo "unsupported"
  fi
}

has_sudo() {
  [ "$DRY_RUN" -eq 1 ] && return 0
  command -v sudo &>/dev/null || return 1
  sudo -n true 2>/dev/null && return 0
  # Prompts for a password; fails if the user isn't in sudoers.
  [ -t 0 ] && sudo -v
}

step_submodules() {
  run git -C "$DOTFILES_DIR" submodule update --init --recursive
}

step_packages() {
  local entry pkg cmd pkg_mgr
  local missing=()

  for entry in "${PACKAGES[@]}"; do
    pkg="${entry%%:*}"
    cmd="${entry##*:}"
    command -v "$cmd" &>/dev/null || missing+=("$pkg")
  done

  if [ ${#missing[@]} -eq 0 ]; then
    log "All packages already installed"
    return 0
  fi
  log "Missing: ${missing[*]}"

  pkg_mgr=$(detect_pkg_manager)
  case "$pkg_mgr" in
    brew)
      run brew install "${missing[@]}"
      ;;
    dnf|apt)
      if ! has_sudo; then
        warn "No sudo rights, install manually: ${missing[*]}"
        return $SKIPPED
      fi
      if [ "$pkg_mgr" = dnf ]; then
        run sudo dnf install -y "${missing[@]}"
      else
        run sudo apt-get update -y
        run sudo apt-get install -y "${missing[@]}"
      fi
      ;;
    *)
      warn "No supported package manager found (brew, dnf, apt-get)"
      return 1
      ;;
  esac
}

step_ohmyzsh() {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    log "Already installed"
    return 0
  fi
  # RUNZSH=no keeps the installer from replacing this script with a zsh shell.
  run env RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
}

clone_once() {
  local url="$1" dir="$2"
  if [ -d "$dir" ]; then
    log "Already installed"
  else
    run git clone --depth=1 "$url" "$dir"
  fi
}

step_syntax() {
  clone_once https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
}

step_p10k() {
  clone_once https://github.com/romkatv/powerlevel10k.git \
    "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
}

step_link() {
  local entry src target current
  local skipped=0

  for entry in "${LINKS[@]}"; do
    src="$DOTFILES_DIR/${entry%%:*}"
    target="$HOME/${entry##*:}"

    if [ -L "$target" ]; then
      current="$(readlink "$target")"
      [ "$current" = "$src" ] && continue
      log "Relinking $target (was → $current)"
      run ln -sfn "$src" "$target"
    elif [ -e "$target" ]; then
      warn "$target exists and is not a symlink, skipping"
      skipped=1
    else
      log "Linking $target"
      run mkdir -p "$(dirname "$target")"
      run ln -s "$src" "$target"
    fi
  done

  run chmod +x "$DOTFILES_DIR/.scripts"/*

  [ "$skipped" -eq 0 ] || return $SKIPPED
}

selected=""
excluded=""

for arg in "$@"; do
  case "$arg" in
    -n|--dry-run) DRY_RUN=1 ;;
    -h|--help) usage; exit 0 ;;
    --no-*) excluded="$excluded ${arg#--no-}" ;;
    -*) echo "Unknown option: $arg" >&2; usage >&2; exit 1 ;;
    *) selected="$selected $arg" ;;
  esac
done

for step in $selected $excluded; do
  case " $STEPS " in
    *" $step "*) ;;
    *) echo "Unknown step: $step" >&2; usage >&2; exit 1 ;;
  esac
done

ok=""
skipped=""
failed=""

for step in $STEPS; do
  if [ -n "$selected" ]; then
    case " $selected " in *" $step "*) ;; *) continue ;; esac
  fi
  case " $excluded " in *" $step "*) continue ;; esac

  echo "==> $step"
  ( set -e; "step_$step" )
  case $? in
    0) ok="$ok $step" ;;
    "$SKIPPED") skipped="$skipped $step" ;;
    *) failed="$failed $step" ;;
  esac
done

report() {
  local label="$1"
  shift
  echo "$label ${*:--}"
}

echo
report "Done:  " $ok
report "Partly:" $skipped
report "Failed:" $failed

[ -z "$failed" ]
