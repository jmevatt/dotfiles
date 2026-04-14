# ── History ──────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=50000
setopt HIST_IGNORE_ALL_DUPS  # no duplicate entries
SAVEHIST=50000
setopt HIST_REDUCE_BLANKS    # trim whitespace
setopt SHARE_HISTORY         # share across sessions
setopt APPEND_HISTORY        # don't overwrite

# ── Directory navigation ────────────────────────────────────────────────────
setopt AUTO_CD               # type dir name to cd
setopt AUTO_PUSHD            # cd pushes to stack
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# ── Globbing ─────────────────────────────────────────────────────────────────
setopt NO_NOMATCH            # bash-style: unmatched globs pass through literally
setopt EXTENDED_GLOB         # ^, ~, #, <-> qualifiers in patterns

# ── Completion ───────────────────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'         # case-insensitive
zstyle ':completion:*' menu select                           # arrow-key menu
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}       # colorized
zstyle ':completion:*' group-name ''                         # group by type
zstyle ':completion:*:descriptions' format '%F{yellow}── %d ──%f'
zstyle ':completion:*' completer _complete _approximate      # fuzzy fallback

# ── Prompt ───────────────────────────────────────────────────────────────────
# Starship handles prompt (git, async, cross-shell). Config: ~/.config/starship.toml
eval "$(starship init zsh)"

# ── Key bindings ─────────────────────────────────────────────────────────────
bindkey -e                              # emacs mode
bindkey '^[[A' history-search-backward  # up arrow searches history
bindkey '^[[B' history-search-forward   # down arrow too
bindkey '^[[3~' delete-char             # delete key works
bindkey '^[[1;5C' forward-word          # Ctrl+Right
bindkey '^[[1;5D' backward-word         # Ctrl+Left

# ── Aliases ──────────────────────────────────────────────────────────────────
# ls → eza (icons, git status, dir-first sort)
alias ls='eza --icons=auto --group-directories-first'
alias ll='eza -lah --git --icons=auto --group-directories-first'
alias lt='eza -lah --git --sort=modified --icons=auto'    # time-sorted
alias tree='eza --tree --icons=auto --git-ignore'

# cat → bat (syntax highlighting; no pager for short output)
alias cat='bat --paging=never --style=plain'
alias less='bat'                                          # real paging with highlights

alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias claude="claude --dangerously-skip-permissions"

# ── Environment ──────────────────────────────────────────────────────────────
export EDITOR=vim
export CMAKE_BUILD_PARALLEL_LEVEL=$(nproc)
export LANG=en_US.UTF-8

export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

alias codex="codex --dangerously-bypass-approvals-and-sandbox"
alias qwen-local='env $(cat "$HOME/.qwen/.env" | xargs) qwen'
alias gs="git status"
alias gpm="git checkout main && git pull origin main"
alias gd="git diff"
alias vim="nvim"
alias pgrep="pgrep -a"

export TERM=xterm-256color
export COLORTERM=truecolor

# Treat `/` as a word boundary so alt+backspace (and ^W, alt+b/f) stop at path separators
WORDCHARS=${WORDCHARS//\//}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/jmevatt/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/home/jmevatt/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/jmevatt/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/jmevatt/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="$HOME/.npm-global/bin:$PATH"

alias tf=terraform

# ── Power-user: global + suffix aliases ──────────────────────────────────────
# Global aliases expand anywhere on the line (zsh-only)
alias -g G='| grep'
alias -g L='| less'
alias -g J='| jq'
alias -g H='| head'
alias -g T='| tail'
alias -g NUL='>/dev/null 2>&1'
alias -g C='| wc -l'

# Suffix aliases — type `./foo.yaml` and it opens in nvim.
# Scoped to config/doc types only. Code extensions (sh/py/go/ts/tsx/js)
# are deliberately excluded: scripts need to execute via shebang, and
# source files are normally opened via editor keybind or $EDITOR, not
# by typing `./foo.ext` at the prompt. The alias would hijack that path.
alias -s {yaml,yml,toml,json,md,txt,conf}=nvim

# ── Helper functions ─────────────────────────────────────────────────────────
take() { mkdir -p "$@" && cd "${@:$#}"; }                # mkdir + cd in one
mkcd() { take "$@"; }                                     # alt name

fpath=(~/.stripe $fpath)
autoload -Uz compinit && compinit -i
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ── Tool inits (must come AFTER plugins + compinit) ──────────────────────────
# atuin — SQLite-backed history; Ctrl+R binding disabled (falls back to default zsh history search)
eval "$(atuin init zsh --disable-ctrl-r --disable-up-arrow)"

# zoxide — smarter cd (`z kraai` jumps to ~/code/kraai-backend, etc.)
eval "$(zoxide init zsh)"

# secrets
source ~/.env # NEVER READ THIS FILE

# ── nnn ───────────────────────────────────────────────────────────────────────
export NNN_OPENER=xdg-open
export NNN_FIFO=/tmp/nnn.fifo

# Auto-refresh XAUTHORITY for new shells — handles X11 session restarts gracefully
# (SDDM creates a new /tmp/xauth_* file per session; stale refs break xclip/flameshot)
if [[ -z "$XAUTHORITY" || ! -f "$XAUTHORITY" ]]; then
    export XAUTHORITY=$(ls -t /tmp/xauth_* 2>/dev/null | head -1)
    [[ -n "$TMUX" && -n "$XAUTHORITY" ]] && tmux set-environment XAUTHORITY "$XAUTHORITY"
fi

# Colors: 4 contexts — purple, blue, green, yellow (Catppuccin Mocha)
export NNN_COLORS='#cba6f7#89b4fa#a6e3a1#f9e2af'

# File type colors (order: dirs, symlinks, sockets, pipes, exec, block, char, orphan, missing, other, archive, audio, video, image)
export NNN_FCOLORS='c6f7e0a10d0503080b030d0b'

# Plugins: key=plugin mapping
#   p = preview-tui (kitty split preview)
#   f = fzopen     (fuzzy open)
#   d = fzcd       (fuzzy cd)
#   g = gitroot    (jump to git root)
#   i = diffs      (show git diff)
#   r = renamer    (bulk rename)
#   c = chksum     (checksum file)
export NNN_PLUG='p:preview-tui;f:fzopen;d:fzcd;g:gitroot;i:diffs;r:renamer;c:chksum'

# Bookmarks: key=path
export NNN_BMS="h:$HOME;c:$HOME/Code;d:$HOME/Documents;m:/mnt"

# cd on quit (type 'n' instead of 'nnn')
source "$HOME/.config/nnn/quitcd.zsh"


alias claude-mem='bun "/home/jmevatt/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs"'

# Added by codebase-memory-mcp install
export PATH="/home/jmevatt/.local/bin:$PATH"
