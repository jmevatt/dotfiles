# Credits

**vex-shell** is a renamed fork of [caelestia-dots/shell](https://github.com/caelestia-dots/shell).

- **Upstream commit:** `0e07176`
- **Fork date:** 2026-04-12
- **Upstream license:** GPLv3

## Rename scope (shallow)

User-facing identity renamed `caelestia` → `vex`:
- Directory + entry point (`qs -c vex-shell`)
- `WlrLayershell.namespace` prefixes
- Window `appid`
- Hyprland keybind name (`vex:refreshDevices`)
- Internal IPC names, QML ids, notify-send app name for our shell

Intentionally **NOT** renamed (dependencies, not identity):
- `import Caelestia` — the C++ QML plugin from `caelestia-shell-git` AUR
- `["caelestia", …]` — invocations of `caelestia-cli`
- XDG paths (`~/.config/caelestia`, `~/.cache/caelestia`, `~/.local/state/caelestia`) — shared state with `caelestia-cli`
- `/usr/lib/caelestia` libdir default
- `"caelestia-cli"` as notify-send `--app-name` (external tool)

## Pulling upstream updates

```bash
cd ~/code/hyprland/caelestia-shell
git fetch origin && git log HEAD..origin/main --oneline
# diff specific files against the fork to cherry-pick individual changes
```

## License

This fork inherits [GPLv3](LICENSE) from upstream.
