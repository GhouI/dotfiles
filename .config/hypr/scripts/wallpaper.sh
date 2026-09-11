#!/usr/bin/env bash
# Set a wallpaper: `wallpaper.sh <file>`, or a random one from ~/Pictures/wallpapers with no argument.
# hyprpaper reads ~/.cache/current-wallpaper, so we repoint that link and restart it.
set -euo pipefail

DIR="$HOME/Pictures/wallpapers"
LINK="$HOME/.cache/current-wallpaper"

if [ $# -gt 0 ]; then
  pick="$(realpath "$1")"
else
  current="$(readlink "$LINK" 2>/dev/null || true)"
  mapfile -t all < <(find "$DIR" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \))
  [ ${#all[@]} -eq 0 ] && { notify-send "Wallpaper" "No images in $DIR"; exit 1; }
  others=()
  for f in "${all[@]}"; do [ "$f" != "$current" ] && others+=("$f"); done
  [ ${#others[@]} -eq 0 ] && others=("${all[@]}")
  pick="${others[RANDOM % ${#others[@]}]}"
fi

ln -sfn "$pick" "$LINK"
pkill -x hyprpaper || true
while pgrep -x hyprpaper >/dev/null; do sleep 0.05; done
setsid -f hyprpaper >/dev/null 2>&1
