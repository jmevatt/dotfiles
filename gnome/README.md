# gnome

GNOME dotfiles for Helicon (and any future GNOME-on-Wayland install).

## What's stowed

- `.local/bin/gnome-settings-{dump,apply}` — round-trip dconf settings to/from this repo.
- `.local/bin/gnome-extensions-install` — install + enable the curated extension set from `extensions.txt`.

GTK themes are applied via dconf (captured in `dconf/org-gnome-desktop-interface.ini`).
Current: **WhiteSur-Dark** GTK + shell, WhiteSur-dark icons, WhiteSur cursors
(AUR: `whitesur-gtk-theme` + `whitesur-icon-theme` + `whitesur-cursor-theme-git`).

## What's NOT stowed

- `dconf/` — plaintext exports of curated dconf branches. Tracked in git but excluded from `stow` (see `.stow-local-ignore`).
- `extensions.txt` — curated UUID list read by `gnome-extensions-install`.
- `README.md` — this file.

## Workflow

**Capture current settings:**
```
gnome-settings-dump
cd ~/code/dotfiles && git diff gnome/dconf
git add gnome/dconf && git commit -m "gnome: <what changed>"
```

**Apply on a fresh machine (or restore after a reset):**
```
stow gnome
gnome-extensions-install          # install + enable curated extensions
# — log out and back in —
gnome-settings-apply --dry-run    # preview
gnome-settings-apply              # commit
```

## Extensions

Curated list lives in `extensions.txt` (one UUID per line, `#` comments ok).

**Install/sync:** `gnome-extensions-install` (idempotent — safe to re-run).
Requires `gext` — install via `yay -S gnome-extensions-cli` or `pipx install gnome-extensions-cli`.

**Current set** (see file for full list):
- Day-1: AppIndicator, Clipboard History, Caffeine, Astra Monitor, User Themes
- Aesthetic: Dash to Dock, Blur My Shell

Extensions require a GNOME Shell **restart** after install before their dconf
keys appear — on Wayland that means logout/login.

**Adding an extension:** append the UUID to `extensions.txt`, re-run
`gnome-extensions-install`, log out/in, tweak config in its settings pane,
run `gnome-settings-dump` to capture the config.

## Why per-branch files instead of one big dump?

A single `dconf dump /` pulls in ~2k keys including transient session state
(recently-opened files, window positions, evolution account state, wallpaper
paths, etc). The dump script whitelists portable user-preference branches
only — see the `BRANCHES` array in `gnome-settings-dump` to add/remove.

Each `.ini` file carries a `# dconf-branch:` header so the apply script knows
which path to load it into — handles dconf keys with underscores cleanly.

## Adding a new branch

1. Find the path: `dconf watch /` then change a setting in GNOME — the path scrolls by.
2. Append it to the `BRANCHES` array in `.local/bin/gnome-settings-dump`.
3. Re-run `gnome-settings-dump` and commit the new `.ini`.
