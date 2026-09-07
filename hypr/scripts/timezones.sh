#!/usr/bin/env bash
# World clock: refreshes every second, q to quit

zones=(
  "Brazil|America/Sao_Paulo"
  "Germany|Europe/Berlin"
  "Spain|Europe/Madrid"
  "Dubai|Asia/Dubai"
  "Israel|Asia/Jerusalem"
)

tput civis
trap 'tput cnorm; exit 0' INT TERM EXIT

while true; do
  clear
  printf "\n  \033[1mWorld Clock\033[0m\n\n"
  for z in "${zones[@]}"; do
    name="${z%%|*}"
    tz="${z##*|}"
    printf "  \033[33m%-10s\033[0m %s\n" "$name" "$(TZ=$tz date '+%H:%M:%S  %a %d %b')"
  done
  printf "\n  press q to quit"
  read -rst 1 -n 1 key && [[ $key == q ]] && break
done
