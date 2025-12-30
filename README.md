# dotfiles
This repo contains dotfiles and a small bootstrap script to set up a macOS development environment quickly.

## Quick start
1. Inspect the `Brewfile` and `install.sh` and change anything you want before running.
2. Dry run (recommended):
   - DRY_RUN=1 ./install.sh
   - This prints actions without changing your system.
3. Run the installer:
   - ./install.sh

## What the installer does
- Installs or updates Homebrew (if needed) and runs `brew bundle` from the `Brewfile`.
- Installs Oh My Zsh (if not present) and symlinks your dotfiles (`.zshrc`, `.gitconfig`).
- Adds `colima` and the Docker CLI to the Brewfile (use `colima start` when you need it).
- Is idempotent — safe to run multiple times.

## What to edit before running
- `Brewfile` — remove/add packages you want. If you don't want Colima/Docker, remove those lines.
- `install.sh` — set `DOTFILES` or tweak behavior if you'd like different defaults.
- `~/.zshrc` — review the AWS helpers and other custom functions and adjust to taste.

## AWS SSO
- This repo provides a small `aws_login` helper that now delegates to `dotfiles/bin/aws-sso` (a tiny script).
- Use `dotfiles/bin/aws-sso suggest` (default) to print recommended `aws sso login` commands, or `dotfiles/bin/aws-sso login <profile>` to perform login and persist the active profile.
- To configure SSO profiles: run `aws configure sso` (requires AWS CLI v2). Profiles are stored in `~/.aws/config` (modern format uses `sso_session`).
- After SSO login, validate with: `aws sts get-caller-identity --profile <profile>`.