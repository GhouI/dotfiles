#!/usr/bin/env bash
# Select a region, copy it to the clipboard straight away, then open it in swappy to annotate.
# In swappy: Ctrl+C copies the annotated version, Ctrl+S saves to ~/Pictures/Screenshots.
set -euo pipefail

region=$(slurp) || exit 0   # Esc cancels
shot=$(mktemp --suffix=.png "${XDG_RUNTIME_DIR:-/tmp}/screenshot-XXXXXX")
trap 'rm -f "$shot"' EXIT

grim -g "$region" "$shot"
wl-copy --type image/png < "$shot"
swappy -f "$shot"
