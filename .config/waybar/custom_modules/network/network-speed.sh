#!/usr/bin/env bash

state_file="${XDG_RUNTIME_DIR:-/tmp}/waybar-network-speed"

get_iface() {
  ip route get 1.1.1.1 2>/dev/null | awk '{for (i = 1; i <= NF; i++) if ($i == "dev") { print $(i + 1); exit }}'
}

format_rate() {
  awk -v bytes="$1" 'BEGIN {
    if (bytes < 1024) printf "%.0fB", bytes
    else if (bytes < 1048576) printf "%.1fK", bytes / 1024
    else if (bytes < 1073741824) printf "%.1fM", bytes / 1048576
    else printf "%.1fG", bytes / 1073741824
  }'
}

emit() {
  jq -nc \
    --arg text "$1" \
    --arg tooltip "$2" \
    --arg class "$3" \
    '{text: $text, tooltip: $tooltip, class: $class}'
}

while true; do
  iface="$(get_iface)"

  if [[ -z "$iface" || ! -r "/sys/class/net/$iface/statistics/rx_bytes" ]]; then
    emit "󰖪 --" "No active network interface" "offline"
    sleep 1
    continue
  fi

  rx="$(<"/sys/class/net/$iface/statistics/rx_bytes")"
  tx="$(<"/sys/class/net/$iface/statistics/tx_bytes")"
  now="$(date +%s)"

  down="--"
  up="--"

  if [[ -f "$state_file" ]]; then
    read -r prev_rx prev_tx prev_time prev_iface <"$state_file"
    if [[ "$prev_iface" == "$iface" ]]; then
      dt=$((now - prev_time))
      if ((dt > 0)); then
        down="$(format_rate $(((rx - prev_rx) / dt)))"
        up="$(format_rate $(((tx - prev_tx) / dt)))"
      fi
    fi
  fi

  printf '%s %s %s %s\n' "$rx" "$tx" "$now" "$iface" >"$state_file"

  class="active"
  [[ "$down" == "--" ]] && class="idle"

  emit "󰁅 ${down} 󰁝 ${up}" "Interface: ${iface}
Download: ${down}/s
Upload: ${up}/s" "$class"

  sleep 1
done
