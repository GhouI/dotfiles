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
  .config/btop
  .config/cava
  .config/wlogout
  .config/gtk-4.0
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
if command -v oh-my-posh >/dev/null && ! fc-list | grep "JetBrainsMono Nerd Font" >/dev/null; then
  oh-my-posh font install JetBrainsMono
fi

# Catppuccin Mocha GTK theme + cursors
GTK_THEME=catppuccin-mocha-red-standard+default
CURSORS=catppuccin-mocha-red-cursors
tmp="$(mktemp -d)"
if [ ! -d "$HOME/.local/share/themes/$GTK_THEME" ]; then
  curl -fsSL -o "$tmp/gtk.zip" "https://github.com/catppuccin/gtk/releases/download/v1.0.3/$GTK_THEME.zip"
  mkdir -p "$HOME/.local/share/themes" && unzip -oq "$tmp/gtk.zip" -d "$HOME/.local/share/themes"
fi
if [ ! -d "$HOME/.local/share/icons/$CURSORS" ]; then
  curl -fsSL -o "$tmp/cursors.zip" "https://github.com/catppuccin/cursors/releases/download/v2.0.0/$CURSORS.zip"
  mkdir -p "$HOME/.local/share/icons" && unzip -oq "$tmp/cursors.zip" -d "$HOME/.local/share/icons"
fi
rm -rf "$tmp"

gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark
gsettings set org.gnome.desktop.interface cursor-theme "$CURSORS"
gsettings set org.gnome.desktop.interface cursor-size 24
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface accent-color red
echo "themed   GTK, icons, cursors"
