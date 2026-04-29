# dotfiles — AI assistant instructions

Jordan's Linux workstation dotfiles, managed with GNU Stow. Primary target host is Helicon.

## Model

Each top-level directory is a stow package. The package interior mirrors `$HOME`; `stow <pkg>` creates symlinks into `/home/jmevatt`.

`.stowrc` pins the target to `/home/jmevatt`, so stow commands work from repo root.

## Common Commands

```bash
stow gnome zsh tmux kitty
stow -D gnome
stow -R gnome
```

## Hard Rules

- Never commit secrets.
- Never read, print, edit, search, or summarize `~/.env`, `.env`, `.env.*`, keys, tokens, or credential files.
- Do not weaken `.gitignore` secret protections.
- Do not stow `.env` or secret material even if locally ignored.
- Keep one package per app so `stow` and `stow -D` stay surgical.
- Remember stowed files are symlinks: editing the repo path or `$HOME` path changes the same content.

## Active Desktop Context

- Current primary target: Helicon.
- GNOME on Wayland with GDM is the active desktop path.
- wlroots/XFCE packages are maintained but inactive unless Jordan says otherwise.

## GNOME Workflow

- `gnome-settings-dump`: export curated dconf branches to `gnome/dconf/*.ini`.
- `gnome-settings-apply`: restore settings.
- `gnome-extensions-install`: install/enable curated extensions.
- Read `gnome/README.md` before deep GNOME changes.

## Adding A Package

1. Create `newpkg/` with interior mirroring `$HOME`.
2. Add `newpkg/.stow-local-ignore` for tracked files that should not be symlinked.
3. Run `stow newpkg` to install.
4. Update this repo's package docs.
