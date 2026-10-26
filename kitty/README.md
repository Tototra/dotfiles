# Config Kitty

## Installation
```sh
mv ~/.config/kitty ~/.config/kitty.bak 2>/dev/null   # sauvegarde l'ancienne
mkdir -p ~/.config/kitty && cp kitty.conf theme.conf macos.conf linux.conf ~/.config/kitty/
```
Puis `ctrl+shift+F5` (ou relance Kitty).

**Police** : JetBrains Mono Nerd Font
- macOS : `brew install --cask font-jetbrains-mono-nerd-font`
- Arch : `sudo pacman -S ttf-jetbrains-mono-nerd`
- Autres : https://www.nerdfonts.com/font-downloads

**Bonus conseillés** : `fzf` (recherche scrollback), `yazi` (fichiers), `btop` (moniteur).

## Aliases à ajouter dans ton .zshrc / .bashrc
```sh
alias icat="kitten icat"          # afficher des images dans le terminal
alias s="kitten ssh"              # ssh qui copie le terminfo + shell integration
alias d="kitten diff"             # diff côte à côte avec coloration
alias kt="kitten themes"          # changer de thème
```

## Terminal « Quake » (bonus)
`kitten quick-access-terminal` ouvre un terminal déroulant par-dessus tout.
Assigne-le à un raccourci global (ex. F12) dans les réglages clavier de ton OS.

## Raccourcis clés (ctrl+shift = ⌃⇧)
| Action | Touche |
|---|---|
| Split auto / vertical / horizontal | ⌃⇧Enter / ⌃⇧\ / ⌃⇧- |
| Naviguer entre panneaux | ⌃⇧ h j k l |
| Déplacer panneau | ⌃⌥ h j k l |
| Redimensionner | ⌃⌥⇧ flèches · ⌃⇧R (interactif) |
| Zoom panneau (plein écran) | ⌃⇧M |
| Choisir panneau à l'écran / échanger | ⌃⇧F / ⌃⇧X |
| Nouvel onglet (même dossier) | ⌃⇧T |
| Aller à l'onglet N | ⌃⇧1…9 |
| Prompt précédent / suivant | ⌃⇧↑ / ⌃⇧↓ |
| Sortie de la dernière commande | ⌃⇧G |
| Recherche fzf dans le scrollback | ⌃⇧/ |
| Ouvrir une URL au clavier | ⌃⇧E |
| Copier un chemin / hash / IP affiché | ⌃⇧P puis F / H / I |
| Opacité +/- | ⌃⇧A puis M / L |
| Sélecteur de thèmes | ⌃⇧F8 |
| Fichiers (yazi) / btop en overlay | ⌃⇧N / ⌃⇧B |
| Ouvrir un lien | Ctrl+clic |
