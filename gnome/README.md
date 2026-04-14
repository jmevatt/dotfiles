# gnome

GNOME dotfiles for Helicon (and any future GNOME-on-Wayland install).

## What's stowed

- `.local/bin/gnome-settings-{dump,apply}` — round-trip dconf settings to/from this repo.

## What's NOT stowed

- `dconf/` — plaintext exports of curated dconf branches. Tracked in git but excluded from `stow` (see `.stow-local-ignore`).
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
gnome-settings-apply --dry-run    # preview
gnome-settings-apply              # commit
```

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
