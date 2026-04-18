# dotfiles

Jordan's Linux workstation dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).
Primary host: **Helicon** (Arch Linux, labwc on Wayland — `gnome/` package retained as fallback session).

## Layout

Each top-level directory is a **stow package** — its contents mirror `$HOME`.

```
dotfiles/
├── autostart/   → ~/.config/autostart/
├── git/         → ~/.gitconfig
├── gnome/       → ~/.config/gtk-{3,4}.0/, ~/.local/bin/gnome-*   (see gnome/README.md)
├── iphone/      → ~/.local/bin/{afc,iphone}-open + iPhone.desktop
├── kanshi/      → ~/.config/kanshi/config (wlroots output profiles)
├── kitty/       → ~/.config/kitty/
├── labwc/       → ~/.config/labwc/ (rc.xml, autostart, environment, menu.xml)
├── mako/        → ~/.config/mako/config
├── nnn/         → ~/.config/nnn/ (quitcd.zsh + plugins/)
├── starship/    → ~/.config/starship.toml
├── sway/        → ~/.config/sway/{config,conf.d/}
├── swaylock/    → ~/.config/swaylock/config
├── swaync/      → ~/.config/swaync/ (config.json + style.css)
├── tmux/        → ~/.tmux.conf
├── waybar/      → ~/.config/waybar/ (config.jsonc + style.css)
├── wezterm/     → ~/.config/wezterm/
├── wofi/        → ~/.config/wofi/ (config + style.css)
└── zsh/         → ~/.zshrc
```

`.stowrc` pins the target to `/home/jmevatt`, so `stow` works from anywhere in the repo.

## Usage

```bash
# First-time clone on a new machine
git clone <repo-url> ~/code/dotfiles
cd ~/code/dotfiles

# Install everything
stow autostart git gnome iphone kanshi kitty labwc mako nnn starship sway swaylock swaync tmux waybar wezterm wofi zsh

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
