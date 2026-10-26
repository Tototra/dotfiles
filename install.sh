#!/usr/bin/env bash
# Installe les dotfiles : liens symboliques (l'existant est sauvegardé) + plugins zsh
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
ZPLUG="${XDG_DATA_HOME:-$HOME/.local/share}/zsh-plugins"

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

echo "→ Outils (Homebrew)"
if command -v brew >/dev/null; then
  brew install fzf zoxide eza bat fd || echo "  (certains outils n'ont pas pu s'installer, ce n'est pas bloquant)"
else
  echo "  Homebrew absent : installe fzf, zoxide, eza, bat et fd à la main pour profiter de tout."
fi

echo "→ Plugins zsh"
mkdir -p "$ZPLUG"
for repo in zsh-users/zsh-autosuggestions zsh-users/zsh-syntax-highlighting \
            zsh-users/zsh-completions Aloxaf/fzf-tab; do
  name="${repo#*/}"
  if [ -d "$ZPLUG/$name/.git" ]; then
    git -C "$ZPLUG/$name" pull -q --ff-only && echo "  à jour : $name"
  else
    git clone -q --depth 1 "https://github.com/$repo.git" "$ZPLUG/$name" && echo "  installé : $name"
  fi
done

echo "→ ~/.zshrc"
touch "$HOME/.zshrc"
OLD='source ~/.config/kitty/zsh-select.zsh'
NEW="source $DIR/zsh/init.zsh"
if grep -qxF "$OLD" "$HOME/.zshrc"; then
  cp "$HOME/.zshrc" "$HOME/.zshrc.bak-$STAMP"
  grep -vxF "$OLD" "$HOME/.zshrc.bak-$STAMP" > "$HOME/.zshrc"
fi
grep -qxF "$NEW" "$HOME/.zshrc" || echo "$NEW" >> "$HOME/.zshrc"
echo "  ok"

echo "✓ Terminé. Ouvre un nouvel onglet (cmd+t) pour tout activer."
