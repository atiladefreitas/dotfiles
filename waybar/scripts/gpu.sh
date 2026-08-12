#!/usr/bin/env bash
# Outputs JSON for waybar's custom/gpu module.
#
# This is a hybrid-graphics laptop (Intel iGPU + NVIDIA dGPU).  The dGPU is
# left under PCI runtime power management, so most of the time it is parked in
# D3cold drawing nothing.  Querying nvidia-smi WAKES IT — polling it blindly
# every few seconds would keep the card alive permanently and cost several
# watts of battery.  So the PCI runtime_status is read first (a cheap sysfs
# read that does not resume the device) and nvidia-smi runs only when the GPU
# is already awake.
#
# Class mirrors the top-process module so the bar can highlight heavy load:
#   >= 80% → "critical"
#   >= 40% → "high"
#   suspended/absent → "idle"
#   else   → "normal"

emit() {
    # $1=text  $2=tooltip  $3=class
    local text=${1//\"/\\\"}
    local tooltip=${2//\"/\\\"}
    printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$text" "$tooltip" "$3"
    exit 0
}

# Locate the dGPU by asking the nvidia driver what it has bound, rather than
# hardcoding a bus address that could shift.
dev=""
for d in /sys/bus/pci/drivers/nvidia/0000:*; do
    if [ -r "$d/power/runtime_status" ]; then
        dev=$d
        break
    fi
done

# Driver not loaded / no dGPU: nothing to report.
if [ -z "$dev" ]; then
    emit "—" "No NVIDIA GPU bound" "idle"
fi

# Asleep — report it without resuming the card.
status=$(cat "$dev/power/runtime_status" 2>/dev/null)
if [ "$status" != "active" ]; then
    emit "off" "dGPU suspended (${status:-unknown}) — running on Intel iGPU" "idle"
fi

read -r util temp mem_used mem_total power name < <(
    nvidia-smi \
        --query-gpu=utilization.gpu,temperature.gpu,memory.used,memory.total,power.draw,name \
        --format=csv,noheader,nounits 2>/dev/null \
    | head -n1 \
    | awk -F', *' '{print $1, $2, $3, $4, $5, $6}'
)

# nvidia-smi failed or returned nothing usable.
if [ -z "$util" ]; then
    emit "n/a" "nvidia-smi query failed" "idle"
fi

# Some fields read "[N/A]" on mobile parts depending on the driver.
case $util in ''|*[!0-9]*) util=0 ;; esac

if [ "$util" -ge 80 ]; then
    class="critical"
elif [ "$util" -ge 40 ]; then
    class="high"
else
    class="normal"
fi

text="${util}%"

tooltip="<b>${name:-GPU}</b>"
tooltip+="\\n  Usage    ${util}%"
[ -n "$temp" ] && tooltip+="\\n  Temp     ${temp}°C"
if [ -n "$mem_used" ] && [ -n "$mem_total" ]; then
    tooltip+=$(awk -v u="$mem_used" -v t="$mem_total" \
        'BEGIN { printf "\\n  VRAM     %.1fG / %.1fG", u/1024, t/1024 }')
fi
[ -n "$power" ] && tooltip+="\\n  Power    ${power}W"

emit "$text" "$tooltip" "$class"
