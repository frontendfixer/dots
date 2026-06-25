#!/bin/bash
set -euo pipefail

wifi_enabled="unknown"
if command -v nmcli >/dev/null 2>&1; then
    wifi_enabled=$(nmcli radio wifi)
fi

bluetooth_enabled="unknown"
if command -v bluetoothctl >/dev/null 2>&1; then
    if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
        bluetooth_enabled="enabled"
    else
        bluetooth_enabled="disabled"
    fi
fi

if [ "$wifi_enabled" = "enabled" ] || [ "$bluetooth_enabled" = "enabled" ]; then
    command -v nmcli >/dev/null 2>&1 && nmcli radio wifi off
    command -v bluetoothctl >/dev/null 2>&1 && bluetoothctl power off >/dev/null
    notify-send "Airplane mode" "Wireless radios disabled" 2>/dev/null || true
else
    command -v nmcli >/dev/null 2>&1 && nmcli radio wifi on
    command -v bluetoothctl >/dev/null 2>&1 && bluetoothctl power on >/dev/null
    notify-send "Airplane mode" "Wireless radios enabled" 2>/dev/null || true
fi
