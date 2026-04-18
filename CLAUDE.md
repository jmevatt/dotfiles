# CLAUDE.md — dotfiles

Solo repo of Jordan's Linux workstation dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).
Primary target host: **Helicon** (Arch, **XFCE4 + xfwm4 on X11**). The `labwc/`, `sway/`, `waybar/`, `mako/`, `swaync/`, `swaylock/`, `wofi/`, and `kanshi/` packages are maintained but inactive on the current session.

## Model

Each top-level directory is a **stow package**. Its interior mirrors `$HOME`.
`stow <pkg>` creates symlinks from `$HOME` into this repo — `stow -D <pkg>` removes them.

`.stowrc` pins the target to `/home/jmevatt`, so `stow` commands work from anywhere in the repo.

**Editing gotcha:** after `stow`, files live as symlinks. Editing either the repo path _or_ `$HOME`
path modifies the same file — they're the same inode.

## Packages

| Package     | Contents                                                                      |
| ----------- | ----------------------------------------------------------------------------- |
| `autostart` | `.config/autostart/*.desktop` — deskflow, discord, kitty, signal              |
| `git`       | `.gitconfig` (user/email + global excludesfile)                               |
| `gnome`     | dconf branch exports + gnome-*-install/dump/apply scripts                     |
| `gtk`       | `.config/gtk-{3,4}.0/bookmarks` — lowercase file-picker sidebar entries       |
| `iphone`    | `iPhone.desktop` + `afc-open` / `iphone-open` helpers for iOS device mounting |
| `kanshi`    | `.config/kanshi/config` — declarative wlroots output profiles                  |
| `kitty`     | `.config/kitty/` terminal config                                              |
| `labwc`     | `.config/labwc/{rc.xml,autostart,environment,menu.xml}` — full-floating wlroots compositor |
| `mako`      | `.config/mako/config` — wayland notification daemon (Catppuccin Mocha)        |
| `nnn`       | `.config/nnn/` — `quitcd.zsh` + `plugins/` (runtime dirs not tracked)         |
| `starship`  | `.config/starship.toml` prompt                                                |
| `sway`      | `.config/sway/{config,conf.d/*.conf}` — modular sway config (Helicon)         |
| `swaylock`  | `.config/swaylock/config` — screen lock theming (Catppuccin Mocha)            |
| `swaync`    | `.config/swaync/{config.json,style.css}` — notification center (Catppuccin Mocha) |
| `tmux`      | `.tmux.conf`                                                                  |
| `waybar`    | `.config/waybar/{config.jsonc,style.css}` — status bar (Catppuccin Mocha)     |
| `wofi`      | `.config/wofi/{config,style.css}` — app launcher (Catppuccin Mocha)           |
| `wezterm`   | `.config/wezterm/wezterm.lua` terminal config                                 |
| `xfce`      | xfconf/panel/Thunar dump + apply scripts (xfce-settings-{dump,apply}) — **active DE** |
| `zsh`       | `.zshrc`                                                                      |

## GNOME workflow

The `gnome/` package is the only non-trivial one. It round-trips dconf settings to this repo:

- `gnome-settings-dump` — export curated dconf branches to `gnome/dconf/*.ini`
- `gnome-settings-apply` — restore them on a fresh machine
- `gnome-extensions-install` — install + enable curated extensions from `gnome/extensions.txt` (requires `gext`)

`gnome/dconf/`, `gnome/extensions.txt`, and `gnome/README.md` are **excluded from stow**
via `gnome/.stow-local-ignore` — they're tracked in git but never symlinked into `$HOME`.

**For deep GNOME details, read `gnome/README.md`** — it's current and authoritative.

## Hard rules

- **Never commit secrets.** Secrets live in `~/.env` (out of repo). `.gitignore` blocks
  `.env`, `.env.*`, `*.key`, `*.pem`, `*_rsa`, `*_ed25519`, `*_ecdsa`, `id_*`. Don't weaken these.
- **One package per app.** Keeps `stow` / `stow -D` surgical — don't merge unrelated configs.
- **Don't stow `.env` or secret material** even if gitignored locally. If a config file
  references a token, split it: check in the template, keep the filled version outside the repo.
- **`.config/autostart/` entries** must use absolute paths or `$PATH`-resolvable commands —
  GNOME's autostart does not source shell rc files.

## Common commands

```bash
stow gnome zsh tmux kitty   # stow multiple
stow -D gnome               # uninstall (delete symlinks, keep repo)
stow -R gnome               # restow (useful after adding/removing files in a package)
```

## When adding a new package

1. Create `newpkg/` with interior mirroring `$HOME` (e.g. `newpkg/.config/newapp/config.toml`).
2. If some files should be tracked but _not_ symlinked, add them to `newpkg/.stow-local-ignore`
   (one regex per line, anchored with `^/`).
3. `stow newpkg` to install.
4. Update the package table in this file and `README.md`.
