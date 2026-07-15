#!/usr/bin/env bash
# Outputs JSON for waybar's custom/top-process module.
# Shows the single process currently consuming the most CPU (the likely
# culprit behind rising CPU usage and temperature), with a tooltip listing
# the top offenders for both CPU and memory.
#
# Uses `top -bn2` and reads the SECOND sample so the figure is instantaneous
# (live) rather than a process-lifetime average — this makes the value move
# in response to what's actually happening right now.
#
# Class escalates with CPU load so the bar can highlight a runaway process:
#   >= 80% → "critical"
#   >= 40% → "high"
#   else   → "normal"

# top's %CPU is normalised to a single core, so a process using more than one
# core reads above 100.  Divide by the core count to express each process as a
# share of TOTAL system CPU (0-100).
ncores=$(nproc 2>/dev/null)
ncores=${ncores:-1}

# Two iterations with a short delay; the first is a since-boot baseline, the
# second is the live delta.  -o %CPU keeps it sorted so row 1 is the top hog.
# Extract only the second sample's process rows (fields: %CPU=9, COMMAND=12).
sample=$(top -bn2 -d 0.3 -w 512 -o %CPU 2>/dev/null | awk '
    /^ *PID/ { block++; next }
    block == 2 && NF >= 12 { print $9, $12 }
')

top_line=$(printf '%s\n' "$sample" | head -n1)
cpu=$(printf '%s' "$top_line" | awk '{print $1}')
name=$(printf '%s' "$top_line" | awk '{print $2}')

name=${name:-none}
cpu=${cpu:-0}

# Normalise the per-core value to a total-system share for display.
cpu_int=$(awk -v c="$cpu" -v n="$ncores" 'BEGIN { v = c / n; if (v > 100) v = 100; printf "%.0f", v }')

if [ "$cpu_int" -ge 80 ]; then
    class="critical"
elif [ "$cpu_int" -ge 40 ]; then
    class="high"
else
    class="normal"
fi

# Truncate long process names so the module stays compact.
short_name=$name
if [ ${#short_name} -gt 12 ]; then
    short_name="${short_name:0:11}…"
fi

text="${short_name} ${cpu_int}%"

# Build a tooltip: top 5 by CPU (from the live sample, normalised) and top 5
# by memory.
top_cpu=$(printf '%s\n' "$sample" \
    | awk -v n="$ncores" 'NR<=5 && NF { printf "  %5.1f%%  %s\\n", $1/n, $2 }')
top_mem=$(ps -eo %mem,comm --sort=-%mem --no-headers 2>/dev/null \
    | awk 'NR<=5 {m=$1; $1=""; sub(/^ +/, ""); printf "  %5.1f%%  %s\\n", m, $0}')

tooltip="<b>Top CPU (live)</b>\\n${top_cpu}\\n<b>Top Memory</b>\\n${top_mem}"

# Escape any characters that would break the JSON string.
text_esc=${text//\\/\\\\}
text_esc=${text_esc//\"/\\\"}
tooltip_esc=${tooltip//\"/\\\"}

printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' \
    "$text_esc" "$tooltip_esc" "$class"
