# dotfiles

Jordan's Linux workstation dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

Each top-level directory is a **stow package** — its contents mirror `$HOME`.

```
dotfiles/
├── hypr/        → ~/.config/hypr/
├── kitty/       → ~/.config/kitty/
├── starship/    → ~/.config/starship.toml
├── zsh/         → ~/.zshrc
├── git/         → ~/.gitconfig
├── tmux/        → ~/.tmux.conf
├── i3/          → ~/.config/i3/
├── polybar/     → ~/.config/polybar/
├── i3status/    → ~/.config/i3status/
└── vex-shell/   → ~/.config/quickshell/caelestia/   (Quickshell fork, see CREDITS.md)
```

## Usage

```bash
# First-time clone on a new machine
git clone git@git.evattlabs.com:jordan/dotfiles ~/code/dotfiles
cd ~/code/dotfiles

# Install all packages
stow hypr kitty starship zsh git

# Install one
stow hypr

# Uninstall (deletes symlinks, keeps repo)
stow -D hypr

# Re-stow after adding files
stow -R hypr
```

## Rules

- **Never commit secrets.** Exports with tokens/keys live in `~/.env` — not in this repo.
- **Edit either side.** Files in this repo are symlinked into `$HOME`; editing either location modifies the same file.
- **One package per app.** Keeps install/uninstall surgical.
