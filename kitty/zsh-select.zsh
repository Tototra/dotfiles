# ── Sélection au clavier façon éditeur de texte pour zsh ──
# shift+flèches / cmd+shift+flèches / ⌥+shift+flèches / cmd+a : sélectionne (surligné)
# ⌫ ou Suppr : efface la sélection · flèche sans shift : désélectionne

# Couleur du surlignage (assortie au thème Nocturne)
zle_highlight=(region:bg=#a6b4ff,fg=#12131c paste:none)

_zs_select()   { (( REGION_ACTIVE )) || zle set-mark-command; zle $1 }
_zs_deselect() { REGION_ACTIVE=0; zle $1 }
_zs_delete()   { if (( REGION_ACTIVE )); then zle kill-region; else zle $1; fi }

# _zs_bind <type> <séquence> <widget par défaut>
# Réutilise le widget déjà lié à la touche (respecte tes plugins éventuels)
_zs_n=0
_zs_bind() {
  local type=$1 seq=$2 base=$3 cur
  if [[ $type != select ]]; then
    cur=${${(z)"$(bindkey -M emacs -- "$seq")"}[2]}
    [[ -n $cur && $cur != undefined-key && $cur != _zs_* ]] && base=$cur
  fi
  (( _zs_n++ ))
  local w="_zs_w$_zs_n"
  eval "$w() { _zs_$type $base }"
  zle -N $w
  bindkey -M emacs -- "$seq" $w
}

# Sélection
_zs_bind select '\e[1;2D' backward-char        # shift+←
_zs_bind select '\e[1;2C' forward-char         # shift+→
_zs_bind select '\e[1;2H' beginning-of-line    # shift+début  (cmd+shift+←)
_zs_bind select '\e[1;2F' end-of-line          # shift+fin    (cmd+shift+→)
_zs_bind select '\e[1;4D' backward-word        # ⌥+shift+←
_zs_bind select '\e[1;4C' forward-word         # ⌥+shift+→

# Déplacements qui annulent la sélection
_zs_bind deselect '\e[D'    backward-char
_zs_bind deselect '\eOD'    backward-char
_zs_bind deselect '\e[C'    forward-char
_zs_bind deselect '\eOC'    forward-char
_zs_bind deselect '\e[A'    up-line-or-history
_zs_bind deselect '\eOA'    up-line-or-history
_zs_bind deselect '\e[B'    down-line-or-history
_zs_bind deselect '\eOB'    down-line-or-history
_zs_bind deselect '\e[H'    beginning-of-line
_zs_bind deselect '\eOH'    beginning-of-line
_zs_bind deselect '\e[F'    end-of-line
_zs_bind deselect '\eOF'    end-of-line
_zs_bind deselect '^A'      beginning-of-line
_zs_bind deselect '^E'      end-of-line
_zs_bind deselect '\e[1;3D' backward-word      # ⌥+←
_zs_bind deselect '\e[1;3C' forward-word       # ⌥+→

# Effacement : supprime la sélection si elle existe
_zs_bind delete '^?'     backward-delete-char  # ⌫
_zs_bind delete '^H'     backward-delete-char
_zs_bind delete '\e[3~'  delete-char           # Suppr (fn+⌫)


# Annuler / rétablir (cmd+z / cmd+shift+z dans Kitty)
bindkey -M emacs '^_'   undo
bindkey -M emacs '^X^Y' redo

# cd sans taper cd : `Documents/`, `..`, `~/Developer` suffisent
# cdpath : les dossiers de ton home marchent depuis n'importe où (le dossier courant reste prioritaire)
setopt auto_cd
cdpath=(. $HOME)

# Commande `code` (VS Code) : ajoute son dossier au PATH s'il existe
for _vsc in "/Applications/Visual Studio Code.app" "$HOME/Applications/Visual Studio Code.app" \
            "/Applications/Visual Studio Code - Insiders.app" "$HOME/Applications/Visual Studio Code - Insiders.app"; do
  [[ -d "$_vsc/Contents/Resources/app/bin" ]] && path+=("$_vsc/Contents/Resources/app/bin")
done
(( $+commands[code] )) || (( ! $+commands[code-insiders] )) || alias code=code-insiders
unset _vsc

unset _zs_n
