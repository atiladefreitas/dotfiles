#!/usr/bin/env bash

active=$(ip -o link show 2>/dev/null | grep -oE 'proton-[a-zA-Z0-9-]+' | head -n1)

if [[ -n "$active" ]]; then
  label="${active#proton-}"
  printf '{"text":"%s","tooltip":"Proton VPN: connected (%s)","class":"connected"}\n' "${label^^}" "$active"
else
  printf '{"text":"off","tooltip":"Proton VPN: disconnected","class":"disconnected"}\n'
fi
