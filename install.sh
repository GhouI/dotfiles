#!/usr/bin/env bash
# Symlink dotfiles into $HOME. Existing files are backed up to <name>.bak.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

LINKS=(
  .bashrc
  .profile
  .gitconfig
  .config/ghostty
  .config/oh-my-posh
  .config/hypr
  .config/waybar
  .config/rofi
  .config/mako
  .config/fastfetch
  .claude/settings.json
)

for path in "${LINKS[@]}"; do
  src="$DOTFILES/$path"
  dest="$HOME/$path"
  mkdir -p "$(dirname "$dest")"

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "ok       $path"
    continue
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mv "$dest" "$dest.bak"
    echo "backup   $path -> $path.bak"
  fi
  ln -s "$src" "$dest"
  echo "linked   $path"
done

# Oh My Posh needs a Nerd Font for its icons
if command -v oh-my-posh >/dev/null && ! fc-list | grep "MesloLGM Nerd Font" >/dev/null; then
  oh-my-posh font install meslo
fi
