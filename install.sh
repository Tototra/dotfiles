#!/usr/bin/env bash
# Installe les dotfiles par liens symboliques (sauvegarde ce qui existe déjà)
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.bak-$STAMP"
    echo "  sauvegardé : $dst -> $dst.bak-$STAMP"
  fi
  ln -sfn "$src" "$dst"
  echo "  lié : $dst -> $src"
}

echo "→ Kitty"
link "$DIR/kitty" "$HOME/.config/kitty"

echo "→ zsh (sélection au clavier)"
LINE='source ~/.config/kitty/zsh-select.zsh'
touch "$HOME/.zshrc"
grep -qxF "$LINE" "$HOME/.zshrc" || echo "$LINE" >> "$HOME/.zshrc"

echo "✓ Terminé. Recharge Kitty (cmd+shift+F5) et ouvre un nouveau shell."
