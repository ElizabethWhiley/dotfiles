#!/usr/bin/env bash
# Idempotent macOS bootstrap script

set -euo pipefail
IFS=$'\n\t'

DOTFILES="${HOME}/dotfiles"
BREWFILE="${DOTFILES}/Brewfile"

# Use DRY_RUN=1 to preview actions without changing the system, e.g.:
#   DRY_RUN=1 ./install.sh

log() { printf '=> %s\n' "$*"; }
warn() { printf 'WARN: %s\n' "$*" >&2; }
error() { printf 'ERROR: %s\n' "$*" >&2; }
die() { error "$*"; exit 1; }

have() { command -v "$1" >/dev/null 2>&1; }

run_cmd() {
  log "+ $*"
  if [ "${DRY_RUN:-0}" = "1" ]; then
    log "(dry-run) skipping: $*"
    return 0
  fi
  eval "$*"
}

safe_symlink() {
  src="$1"
  dest="$2"

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    log "Symlink $dest already points to $src"
    return 0
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    backup="${dest}.backup.$(date -u +%Y%m%dT%H%M%SZ)"
    run_cmd "mv -- \"$dest\" \"$backup\""
    log "Backed up \"$dest\" to \"$backup\""
  fi

  run_cmd "ln -s \"$src\" \"$dest\""
  log "Symlinked \"$dest\" -> \"$src\""
}

# Ensure DOTFILES exists
if [ ! -d "$DOTFILES" ]; then
  die "DOTFILES directory not found at $DOTFILES"
fi

# Homebrew: install or update (idempotent)
install_homebrew() {
  if have brew; then
    log "Homebrew found — updating..."
    run_cmd "brew update"
  else
    log "Homebrew not found — installing..."
    run_cmd "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""

    # Initialize brew env for current shell (idempotent)
    if [ -f "/opt/homebrew/bin/brew" ]; then
      run_cmd "echo 'eval \"$(/opt/homebrew/bin/brew shellenv)\"' >> \"$HOME/.zprofile\""
      run_cmd "eval \"$(/opt/homebrew/bin/brew shellenv)\""
    fi
  fi
}

install_oh_my_zsh() {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    log "Oh My Zsh already installed"
    return 0
  fi
  log "Installing Oh My Zsh..."
  run_cmd "/bin/sh -c \"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)\""
}

# Run brew bundle (if available)
run_brew_bundle() {
  if ! have brew; then
    warn "brew not found; skipping bundle"
    return 0
  fi
  if brew bundle --help >/dev/null 2>&1; then
    if [ ! -f "$BREWFILE" ]; then
      warn "Brewfile not found at $BREWFILE; skipping"
      return 0
    fi

    log "Checking Brewfile for pending changes..."
    # `brew bundle check` exits 0 when everything is satisfied, non-zero otherwise
    if brew bundle check --file "$BREWFILE" >/dev/null 2>&1; then
      log "All Brewfile dependencies are already satisfied; skipping 'brew bundle'"
      return 0
    fi

    log "Running brew bundle with $BREWFILE"
    run_cmd "brew bundle --file \"$BREWFILE\""
  else
    warn "'brew bundle' command not available; make sure Homebrew is up-to-date"
  fi
}

main() {
  log "Starting bootstrap"

  install_homebrew
  install_oh_my_zsh

  # Safe symlinks for config files
  safe_symlink "$DOTFILES/.zshrc" "$HOME/.zshrc"
  safe_symlink "$DOTFILES/.gitconfig" "$HOME/.gitconfig"

  run_brew_bundle

  log "Bootstrap complete"
}

main "$@"

