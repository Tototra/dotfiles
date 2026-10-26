# dotfiles

Mes fichiers de config.

| Dossier | Contenu |
|---|---|
| `kitty/` | Config Kitty : thème Nocturne, splits, onglets powerline, curseur animé, raccourcis macOS + sélection au clavier pour zsh |
| `zsh/` | Autocomplétion intelligente : suggestions grises, menu fuzzy avec aperçu, historique fuzzy, cd qui apprend, coloration syntaxique |

## Installation

```sh
git clone https://github.com/Tototra/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

Le script crée des liens symboliques vers ce dépôt (l'existant est sauvegardé en `.bak-<date>`),
donc toute modif de config se fait directement dans `~/dotfiles` et se versionne avec git.

Détails et raccourcis : [kitty/README.md](kitty/README.md)

## Autocomplétion zsh

| Quoi | Comment |
|---|---|
| Suggestion grise tirée de l'historique | `→` ou `ctrl+espace` pour accepter, `⌥+→` mot par mot |
| Menu de complétion fuzzy avec aperçu | `Tab` (tape pour filtrer, `<` `>` pour changer de groupe) |
| Historique filtré sur le début tapé | `↑` / `↓` |
| Recherche fuzzy dans tout l'historique | `ctrl+r` |
| Insérer un fichier / aller dans un dossier | `ctrl+t` / `⌥+c` |
| `cd` qui apprend tes dossiers | `cd proj` → saute à ton dossier le plus utilisé contenant « proj », `cdi` pour choisir |
| Complétion insensible à la casse et floue | `cd doc<Tab>` → `Documents` |

Outils installés par `install.sh` via Homebrew : fzf, zoxide, eza, bat, fd.
Plugins : zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions, fzf-tab.
