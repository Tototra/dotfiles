# dotfiles

Mes fichiers de config.

| Dossier | Contenu |
|---|---|
| `kitty/` | Config Kitty : thème Nocturne, splits, onglets powerline, curseur animé, raccourcis macOS + sélection au clavier pour zsh |

## Installation

```sh
git clone https://github.com/Tototra/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

Le script crée des liens symboliques vers ce dépôt (l'existant est sauvegardé en `.bak-<date>`),
donc toute modif de config se fait directement dans `~/dotfiles` et se versionne avec git.

Détails et raccourcis : [kitty/README.md](kitty/README.md)
