# ╔══════════════════════════════════════════════════════════════╗
# ║   zsh · autocomplétion intelligente (chargé depuis ~/.zshrc)   ║
# ╚══════════════════════════════════════════════════════════════╝
ZPLUG="${XDG_DATA_HOME:-$HOME/.local/share}/zsh-plugins"
DOTFILES="${${(%):-%x}:A:h:h}"
[[ -n $HOMEBREW_PREFIX ]] || for p in /opt/homebrew /usr/local "$HOME/.homebrew"; do
  [[ -x $p/bin/brew ]] && { eval "$($p/bin/brew shellenv)"; break; }
done

# ─── Historique : gros, partagé entre terminaux, sans doublons ──────
HISTFILE=${HISTFILE:-$HOME/.zsh_history}
HISTSIZE=100000
SAVEHIST=100000
setopt share_history inc_append_history extended_history
setopt hist_ignore_all_dups hist_ignore_space hist_reduce_blanks hist_verify
setopt auto_cd auto_pushd pushd_ignore_dups interactive_comments
setopt complete_in_word always_to_end no_beep

# ─── Moteur de complétion ───────────────────────────────────────────
[[ -d $ZPLUG/zsh-completions/src ]] && fpath=("$ZPLUG/zsh-completions/src" $fpath)
[[ -n $HOMEBREW_PREFIX ]] && fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump-$ZSH_VERSION"

# Insensible à la casse + correspondance floue (doc → Documents, g-c → git-commit)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zcompcache"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*' menu no

# ─── fzf-tab : Tab ouvre un menu fuzzy avec aperçu ──────────────────
if [[ -r $ZPLUG/fzf-tab/fzf-tab.plugin.zsh ]] && (( $+commands[fzf] )); then
  source "$ZPLUG/fzf-tab/fzf-tab.plugin.zsh"
  if (( $+commands[eza] )); then
    _zs_ls='eza -1 --color=always --icons $realpath'
  else
    _zs_ls='ls -1G $realpath'
  fi
  zstyle ':fzf-tab:complete:(cd|z|zi|pushd|ls|eza):*' fzf-preview "$_zs_ls"
  zstyle ':fzf-tab:complete:(cat|bat|less|nvim|vim|code):*' fzf-preview \
    '(( $+commands[bat] )) && bat --color=always --style=numbers --line-range=:200 $realpath 2>/dev/null || head -200 $realpath 2>/dev/null || eval $_zs_ls'
  zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff --color=always -- $word | head -200'
  zstyle ':fzf-tab:complete:git-(checkout|switch|log):*' fzf-preview 'git log --oneline --graph --color=always -20 $word'
  zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps -o pid,pcpu,pmem,command -p $word'
  zstyle ':fzf-tab:*' switch-group '<' '>'
  zstyle ':fzf-tab:*' fzf-flags --height=50% --border=rounded
  zstyle ':fzf-tab:*' use-fzf-default-opts yes
fi

# ─── fzf : ctrl+r historique fuzzy · ctrl+t fichiers · ⌥c dossiers ──
if (( $+commands[fzf] )); then
  export FZF_DEFAULT_OPTS="--layout=reverse --info=inline --cycle \
    --color=bg+:#1b1d2b,fg:#d8dcf0,fg+:#eef0fb,hl:#82aaff,hl+:#a6c4ff \
    --color=border:#2a2d40,prompt:#c9a0ff,pointer:#ffcc77,marker:#9ee58f,info:#7f86a8,spinner:#7dcfff,header:#7dcfff"
  (( $+commands[fd] )) && {
    export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
    export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
    export FZF_ALT_C_COMMAND='fd --type d --hidden --strip-cwd-prefix --exclude .git'
  }
  source <(fzf --zsh 2>/dev/null)
fi

# ─── zoxide : cd apprend tes dossiers (cd proj → ~/Developer/projet) ──
(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd cd)"

# ─── ↑ / ↓ : remonte l'historique en filtrant sur ce qui est déjà tapé ──
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
for k in '\e[A' '\eOA'; do bindkey -M emacs "$k" up-line-or-beginning-search; done
for k in '\e[B' '\eOB'; do bindkey -M emacs "$k" down-line-or-beginning-search; done

# ─── Sélection au clavier (shift+flèches, cmd+a…) ───────────────────
[[ -r $HOME/.config/kitty/zsh-select.zsh ]] && source "$HOME/.config/kitty/zsh-select.zsh"

# ─── Suggestions grises à la fish (→ pour accepter) ─────────────────
if [[ -r $ZPLUG/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#5c6388'
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40
  source "$ZPLUG/zsh-autosuggestions/zsh-autosuggestions.zsh"
  bindkey -M emacs '^ ' autosuggest-accept          # ctrl+espace : accepter
fi

# ─── Coloration syntaxique (toujours en dernier) ────────────────────
if [[ -r $ZPLUG/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  typeset -gA ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[command]='fg=#9ee58f'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#9ee58f'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#9ee58f'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#9ee58f'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff7a93'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#7dcfff,underline'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#ffcc77'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#ffcc77'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#4a5072'
  source "$ZPLUG/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ─── Alias kitty ────────────────────────────────────────────────────
alias icat='kitten icat' d='kitten diff' s='kitten ssh'
(( $+commands[eza] )) && alias ls='eza --icons --group-directories-first' ll='eza -la --icons --git --group-directories-first' lt='eza --tree --level=2 --icons'
(( $+commands[bat] )) && alias cat='bat --paging=never --style=plain'
unset _zs_ls p k
