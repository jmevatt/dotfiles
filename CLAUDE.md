# CLAUDE.md — dotfiles

Solo repo of Jordan's Linux workstation dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).
Remote: `git@git.evattlabs.com:jordan/dotfiles`. Primary target host: **Helicon** (Arch, GNOME/Wayland).

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
| `gnome`     | GTK3/4 theming, dconf branch exports, dump/apply/extension-install scripts    |
| `iphone`    | `iPhone.desktop` + `afc-open` / `iphone-open` helpers for iOS device mounting |
| `kitty`     | `.config/kitty/` terminal config                                              |
| `starship`  | `.config/starship.toml` prompt                                                |
| `tmux`      | `.tmux.conf`                                                                  |
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
