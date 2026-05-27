#!/usr/bin/env bash

CONF_DIR="/etc/wireguard"

mapfile -t servers < <(find "$CONF_DIR" -maxdepth 1 -name 'proton-*.conf' -printf '%f\n' 2>/dev/null \
  | sed 's/\.conf$//' | sort)

active=$(ip -o link show 2>/dev/null | grep -oE 'proton-[a-zA-Z0-9-]+' | head -n1)

menu=""
for s in "${servers[@]}"; do
  if [[ "$s" == "$active" ]]; then
    menu+="● ${s#proton-}\n"
  else
    menu+="○ ${s#proton-}\n"
  fi
done
[[ -n "$active" ]] && menu+="✕ Disconnect\n"

choice=$(echo -e "$menu" | walker --dmenu -p "Proton VPN")
[[ -z "$choice" ]] && exit 0

label=$(echo "$choice" | sed 's/^[●○✕] *//')

[[ -n "$active" ]] && sudo wg-quick down "$active"

if [[ "$choice" != *Disconnect* ]]; then
  sudo wg-quick up "proton-${label}"
fi

pkill -RTMIN+8 waybar
