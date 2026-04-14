# dotfiles

Jordan's Linux workstation dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).
Primary host: **Helicon** (Arch Linux, GNOME on Wayland).

## Layout

Each top-level directory is a **stow package** — its contents mirror `$HOME`.

```
dotfiles/
├── autostart/   → ~/.config/autostart/
├── git/         → ~/.gitconfig
├── gnome/       → ~/.config/gtk-{3,4}.0/, ~/.local/bin/gnome-*   (see gnome/README.md)
├── iphone/      → ~/.local/bin/{afc,iphone}-open + iPhone.desktop
├── kitty/       → ~/.config/kitty/
├── starship/    → ~/.config/starship.toml
├── tmux/        → ~/.tmux.conf
├── vex-shell/   → ~/.config/quickshell/
└── zsh/         → ~/.zshrc
```

`.stowrc` pins the target to `/home/jmevatt`, so `stow` works from anywhere in the repo.

## Usage

```bash
# First-time clone on a new machine
git clone git@git.evattlabs.com:jordan/dotfiles ~/code/dotfiles
cd ~/code/dotfiles

# Install everything
stow autostart git gnome iphone kitty starship tmux vex-shell zsh

# Install one
stow kitty

# Uninstall (deletes symlinks, keeps repo)
stow -D kitty

# Re-stow after adding files to a package
stow -R kitty
```

## GNOME

The `gnome/` package round-trips dconf settings and manages the curated extension set.
See **[`gnome/README.md`](gnome/README.md)** for the full workflow
(`gnome-settings-dump`, `gnome-settings-apply`, `gnome-extensions-install`).

## Rules

- **Never commit secrets.** Tokens/keys live in `~/.env` — not in this repo. `.gitignore`
  blocks `.env`, `.env.*`, `*.key`, `*.pem`, `*_rsa`, `*_ed25519`, `*_ecdsa`, `id_*`.
- **Edit either side.** Files in this repo are symlinked into `$HOME`; editing either
  location modifies the same file.
- **One package per app.** Keeps `stow` / `stow -D` surgical.
