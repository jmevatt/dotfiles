# xfce — XFCE4 settings snapshot + apply scripts

Captures Jordan's live XFCE4 / xfwm4 state on Helicon (X11) into the dotfiles
repo. Mirrors the `gnome/` package pattern — because XFCE's `xfconfd` atomically
replaces its XML files on every change, direct stow symlinks break, so we use a
**dump/apply** workflow instead.

## Layout

```
xfce/
├── .local/bin/                # STOWED → ~/.local/bin/
│   ├── xfce-settings-dump     # snapshot live state → repo
│   └── xfce-settings-apply    # restore repo state → live
├── xfconf/                    # NOT stowed — dumped XML per channel
├── panel/                     # NOT stowed — panel launcher layout
├── thunar/                    # NOT stowed — accels.scm + uca.xml
├── .stow-local-ignore         # excludes xfconf/, panel/, thunar/, README.md
└── README.md
```

## Scripts

| Script                 | What it does                                                           |
|------------------------|------------------------------------------------------------------------|
| `xfce-settings-dump`   | Copies `~/.config/xfce4/xfconf/xfce-perchannel-xml/*.xml` (curated channels) + `~/.config/xfce4/panel/` + `~/.config/Thunar/{accels.scm,uca.xml}` into the repo. |
| `xfce-settings-apply`  | Stops xfconfd, copies repo snapshots into the live config paths, restarts xfconfd + panel + xfwm4 + xfsettingsd. Supports `--dry-run`. |

Both respect `DOTFILES_REPO` (default: `~/code/dotfiles`).

## Curated xfconf channels

```
displays                    # xrandr layout
keyboards                   # layout + repeat rate
pointers                    # mouse/touchpad
thunar                      # file manager prefs
xfce4-desktop               # wallpaper, icons, right-click menu
xfce4-keyboard-shortcuts    # global hotkeys
xfce4-notifyd               # notification daemon
xfce4-panel                 # panel + plugin config
xfce4-power-manager         # power + blank-screen
xfce4-screensaver           # lock screen
xfce4-session               # session behavior, logout
xfwm4                       # window manager (focus, tiling, compositor)
xsettings                   # GTK theme / icons / fonts / cursor
```

Channels without an XML file on disk are skipped — they're on defaults and
xfconfd hasn't flushed anything yet.

## Usage

```bash
# after making changes in GUI:
xfce-settings-dump
cd ~/code/dotfiles && git diff xfce/

# on a fresh machine (after stow):
xfce-settings-apply            # stop xfconfd, restore XML, restart components
xfce-settings-apply --dry-run  # preview what would happen
```

A logout/login after `xfce-settings-apply` is the most reliable way to fully
pick up every setting.

## Why no direct stow of `xfconf/` XML

`xfconfd` writes each channel via `g_file_set_contents_full` → temp-file +
atomic rename. That replaces stow symlinks with regular files on first change,
breaking the link silently. Dump/apply avoids the footgun at the cost of
running `xfce-settings-dump` after GUI tweaks you want to keep (same tax as
`gnome-settings-dump`).

## Hot-control cheatsheet (non-repo, for day-to-day tweaking)

```bash
xfconf-query -c <channel> -l                    # list props
xfconf-query -c <channel> -p <prop> -s <value>  # set prop
xfconf-query -c <channel> -p <prop> -r          # reset to default
xfce4-panel -r                                  # restart panel
xfdesktop --reload                              # reload desktop/wallpaper
xfwm4 --replace                                 # restart window manager
xfsettingsd --replace                           # reload xsettings daemon
```
