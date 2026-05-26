#!/usr/bin/env bash
# Usage: set-wallpaper.sh <image-filename>
# Looks for the image in ~/dotfiles/wallpapers/

set -euo pipefail

WALLPAPER_DIR="$HOME/dotfiles/wallpapers"
IMG="$WALLPAPER_DIR/$1"

if [[ ! -f "$IMG" ]]; then
  echo "Error: $IMG not found"
  exit 1
fi

ln -sf "$IMG" "$WALLPAPER_DIR/current"
pkill swaybg || true
swaybg -i "$WALLPAPER_DIR/current" -m fill &
echo "Wallpaper set to $1"
