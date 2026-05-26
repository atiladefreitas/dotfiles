#!/bin/bash
[[ -f ~/.config/user-dirs.dirs ]] && source ~/.config/user-dirs.dirs
OUTPUT_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
mkdir -p "$OUTPUT_DIR"

pkill slurp

TEMP_FILE="/tmp/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png"
hyprshot -m ${1:-region} --freeze --silent -o /tmp -f "$(basename "$TEMP_FILE")"

# Wait for hyprshot to finish writing the file
while [[ ! -f "$TEMP_FILE" ]] || [[ $(stat -c%s "$TEMP_FILE" 2>/dev/null || echo 0) -eq 0 ]]; do
  sleep 0.1
done
sleep 0.2

# Bail if user cancelled (no file)
[ -s "$TEMP_FILE" ] || exit 0

# Copy immediately so a plain screenshot works without editing
wl-copy < "$TEMP_FILE"

# Notify with a clickable Edit action; click opens satty
action="$(dunstify -h "string:image-path:$TEMP_FILE" -A "default,Edit" "Screenshot captured" "Click to edit in satty")"

if [ "$action" = "2" ]; then
  cat "$TEMP_FILE" | satty --filename - \
    --output-filename "$OUTPUT_DIR/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png" \
    --early-exit \
    --actions-on-enter save-to-clipboard \
    --save-after-copy \
    --copy-command 'wl-copy'
fi
