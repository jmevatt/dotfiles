#!/usr/bin/env bash
# install-fedora.sh — dotfiles deps for a fresh Fedora install
# Usage: bash install-fedora.sh [--skip-themes] [--skip-wayland-wm]
set -euo pipefail

SKIP_THEMES=false
SKIP_WAYLAND_WM=false
for arg in "$@"; do
  case "$arg" in
    --skip-themes) SKIP_THEMES=true ;;
    --skip-wayland-wm) SKIP_WAYLAND_WM=true ;;
  esac
done

# ─── helpers ───────────────────────────────────────────────────────────────────
need_sudo() { [[ $EUID -ne 0 ]]; }
info()  { echo -e "\033[1;36m==> $*\033[0m"; }
warn()  { echo -e "\033[1;33m[!] $*\033[0m"; }
ok()    { echo -e "\033[1;32m[✓] $*\033[0m"; }
skip()  { echo -e "\033[0;90m[-] skipping: $*\033[0m"; }

if need_sudo; then
  SUDO=sudo
else
  SUDO=
fi

# ─── repos ─────────────────────────────────────────────────────────────────────
info "Enabling RPM Fusion (free + nonfree)"
$SUDO dnf install -yq \
  "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
  "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

info "Enabling COPR repos (wezterm, cliphist)"
$SUDO dnf copr enable -y wezfurlong/wezterm-nightly
$SUDO dnf copr enable -y atim/starship

# ─── core shell ────────────────────────────────────────────────────────────────
info "Core shell environment"
$SUDO dnf install -yq \
  zsh \
  stow \
  git \
  neovim \
  tmux \
  starship \
  atuin \
  zoxide \
  fzf \
  fd-find \
  bat \
  eza \
  jq \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  curl \
  wget

# ─── terminal emulators ─────────────────────────────────────────────────────────
info "Terminal emulators"
$SUDO dnf install -yq kitty wezterm

# ─── gnome (primary DE) ────────────────────────────────────────────────────────
info "GNOME + GDM"
$SUDO dnf install -yq \
  gnome-shell \
  gdm \
  dconf \
  gnome-extensions-app \
  pipx \
  gnome-tweaks \
  nautilus

info "Installing gnome-extensions-cli (gext) via pipx"
pipx install gnome-extensions-cli --include-deps

# ─── wayland stack (active for GNOME; also used by sway/labwc) ─────────────────
info "Wayland core stack"
$SUDO dnf install -yq \
  wl-clipboard \
  xdg-desktop-portal \
  xdg-desktop-portal-gnome \
  xdg-desktop-portal-wlr \
  polkit-gnome \
  grim \
  slurp \
  libnotify

# ─── optional wayland WMs (sway + labwc packages in-repo, inactive on GNOME) ────
if [[ "$SKIP_WAYLAND_WM" == "false" ]]; then
  info "Wayland WMs: sway, labwc, waybar, supporting stack"
  $SUDO dnf install -yq \
    sway \
    labwc \
    waybar \
    swaylock \
    swayidle \
    swaybg \
    mako \
    swaynotificationcenter \
    wofi \
    kanshi \
    wlr-randr \
    wob \
    xclip
else
  skip "Wayland WMs (--skip-wayland-wm)"
fi

# ─── audio ──────────────────────────────────────────────────────────────────────
info "Audio stack"
$SUDO dnf install -yq \
  pipewire \
  wireplumber \
  pipewire-pulseaudio \
  playerctl \
  pavucontrol

# ─── network / bluetooth ────────────────────────────────────────────────────────
info "Network + Bluetooth"
$SUDO dnf install -yq \
  NetworkManager-tui \
  network-manager-applet \
  blueman

# ─── file manager + nnn ecosystem ───────────────────────────────────────────────
info "File managers + nnn ecosystem"
$SUDO dnf install -yq \
  nnn \
  thunar \
  mediainfo \
  mpv \
  ffmpegthumbnailer \
  poppler-utils \
  ImageMagick \
  atool \
  moreutils \
  renameutils \
  w3m \
  xdg-utils

# glow (markdown preview for nnn) — try dnf, fall back to note
if $SUDO dnf install -yq glow 2>/dev/null; then
  ok "glow installed"
else
  warn "glow not found in repos — install manually: https://github.com/charmbracelet/glow"
fi

# ffmpeg (RPM Fusion nonfree)
info "ffmpeg (RPM Fusion)"
$SUDO dnf install -yq ffmpeg

# ─── iphone support ─────────────────────────────────────────────────────────────
info "iPhone / iOS support"
$SUDO dnf install -yq \
  libimobiledevice \
  gvfs-afc

# ─── browser ────────────────────────────────────────────────────────────────────
info "Firefox"
$SUDO dnf install -yq firefox

# ─── fonts ──────────────────────────────────────────────────────────────────────
info "Fonts (system packages)"
$SUDO dnf install -yq \
  google-noto-emoji-color-fonts \
  google-noto-sans-cjk-fonts \
  google-noto-sans-fonts \
  hack-fonts \
  adwaita-icon-theme

if [[ "$SKIP_THEMES" == "false" ]]; then
  info "JetBrainsMono Nerd Font (manual download)"
  FONT_DIR="$HOME/.local/share/fonts/JetBrainsMonoNerd"
  if [[ -d "$FONT_DIR" ]]; then
    skip "JetBrainsMono Nerd Font already present at $FONT_DIR"
  else
    mkdir -p "$FONT_DIR"
    TMP=$(mktemp -d)
    curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" -o "$TMP/jbmono.tar.xz"
    tar -xf "$TMP/jbmono.tar.xz" -C "$FONT_DIR"
    fc-cache -fv "$FONT_DIR"
    rm -rf "$TMP"
    ok "JetBrainsMono Nerd Font installed to $FONT_DIR"
  fi
fi

# ─── devops / cloud tools ────────────────────────────────────────────────────────
info "Devops tools"
$SUDO dnf install -yq \
  golang \
  python3 \
  python3-pip \
  nodejs \
  npm \
  rust \
  cargo \
  kubernetes-client \
  awscli2

# terraform (HashiCorp repo)
if ! command -v terraform &>/dev/null; then
  info "Adding HashiCorp repo for terraform"
  $SUDO dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
  $SUDO dnf install -yq terraform
else
  ok "terraform already installed"
fi

# ─── bun ─────────────────────────────────────────────────────────────────────────
if ! command -v bun &>/dev/null; then
  info "Installing bun"
  curl -fsSL https://bun.sh/install | bash
else
  ok "bun already installed"
fi

# ─── cliphist (not in Fedora repos) ─────────────────────────────────────────────
if ! command -v cliphist &>/dev/null; then
  info "Installing cliphist"
  CLIPHIST_VER=$(curl -fsSL "https://api.github.com/repos/sentriz/cliphist/releases/latest" | jq -r '.tag_name')
  curl -fsSL "https://github.com/sentriz/cliphist/releases/download/${CLIPHIST_VER}/v${CLIPHIST_VER#v}-linux-amd64" -o /tmp/cliphist
  $SUDO install -m755 /tmp/cliphist /usr/local/bin/cliphist
  ok "cliphist ${CLIPHIST_VER} installed"
else
  ok "cliphist already installed"
fi

# ─── zsh plugins (cloned to ~/.zsh/) ────────────────────────────────────────────
info "Cloning zsh plugins to ~/.zsh/"
mkdir -p "$HOME/.zsh"

if [[ ! -d "$HOME/.zsh/zsh-autosuggestions" ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
else
  skip "~/.zsh/zsh-autosuggestions already exists"
fi

if [[ ! -d "$HOME/.zsh/zsh-syntax-highlighting" ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.zsh/zsh-syntax-highlighting"
else
  skip "~/.zsh/zsh-syntax-highlighting already exists"
fi

# ─── set default shell to zsh ────────────────────────────────────────────────────
if [[ "$SHELL" != "$(command -v zsh)" ]]; then
  info "Setting zsh as default shell"
  chsh -s "$(command -v zsh)"
else
  ok "zsh already default shell"
fi

# ─── manual / not automatable ────────────────────────────────────────────────────
echo ""
warn "Manual steps still required:"
cat <<'EOF'
  [ ] WhiteSur GTK theme:    https://github.com/vinceliuice/WhiteSur-gtk-theme
  [ ] WhiteSur icon theme:   https://github.com/vinceliuice/WhiteSur-icon-theme
  [ ] WhiteSur cursor theme: https://github.com/vinceliuice/WhiteSur-cursors
  [ ] deskflow (KVM):        https://github.com/deskflow/deskflow
  [ ] ollama:                https://ollama.com/download/linux
  [ ] signal-desktop:        flatpak install signal-desktop OR Signal .repo
  [ ] discord:               flatpak install discord OR RPM Fusion discord
  [ ] dragon (nnn dnd):      https://github.com/mwh/dragon
  [ ] Google Cloud SDK:      https://cloud.google.com/sdk/docs/install (drop in ~/Downloads/)
  [ ] stripe CLI:            https://stripe.com/docs/stripe-cli
  [ ] codex CLI:             npm install -g @openai/codex
  [ ] atuin sync login:      atuin login
  [ ] GNOME extensions:      run gnome-extensions-install (after stow gnome)
  [ ] stow packages:         cd ~/code/dotfiles && stow gnome zsh tmux kitty wezterm starship nnn git autostart gtk
EOF

echo ""
ok "Done! Reboot or re-login for font cache + GNOME session changes."
