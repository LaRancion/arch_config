#!/usr/bin/env bash

# Waybar multi-VPN detector
# Detects:
# - Tailscale
# - WireGuard
# - OpenVPN
# - NetworkManager VPNs
# - ProtonVPN interfaces

VPNs=()

add_vpn() {
    local vpn="$1"

    for existing in "${VPNs[@]}"; do
        [[ "$existing" == "$vpn" ]] && return
    done

    VPNs+=("$vpn")
}


# ============================================================
# TAILSCALE
# ============================================================

if command -v tailscale >/dev/null 2>&1; then
    if tailscale status --peers=false 2>/dev/null |
        grep -qE '^100\.|^fd[0-9a-f:]+ '; then
        add_vpn "Tailscale"
    fi
fi

# Interface fallback
if ip link show tailscale0 >/dev/null 2>&1; then
    add_vpn "Tailscale"
fi


# ============================================================
# WIREGUARD
# ============================================================

if command -v wg >/dev/null 2>&1; then
    WG_INTERFACES=$(wg show interfaces 2>/dev/null)

    if [[ -n "$WG_INTERFACES" ]]; then
        for iface in $WG_INTERFACES; do
            add_vpn "WireGuard ($iface)"
        done
    fi
fi


# ============================================================
# NETWORKMANAGER VPNs
# ============================================================

if command -v nmcli >/dev/null 2>&1; then
    while IFS=: read -r name type; do
        if [[ "$type" == "vpn" && -n "$name" ]]; then
            add_vpn "VPN: $name"
        fi
    done < <(
        nmcli -t -f NAME,TYPE connection show --active 2>/dev/null
    )
fi


# ============================================================
# OPENVPN / TUN INTERFACES
# ============================================================

while read -r iface; do
    [[ -z "$iface" ]] && continue
    add_vpn "OpenVPN ($iface)"
done < <(
    ip -o link show 2>/dev/null |
        awk -F': ' '$2 ~ /^tun[0-9]+$/ {print $2}'
)


# ============================================================
# PROTONVPN INTERFACES
# ============================================================

while read -r iface; do
    [[ -z "$iface" ]] && continue
    add_vpn "ProtonVPN ($iface)"
done < <(
    ip -o link show 2>/dev/null |
        awk -F': ' '$2 ~ /^proton/ {print $2}'
)


# ============================================================
# WAYBAR OUTPUT
# ============================================================

COUNT=${#VPNs[@]}

if (( COUNT == 0 )); then
    printf '%s\n' \
        '{"text":"󰖂 VPN","class":"disconnected","tooltip":"No VPN connections"}'
    exit 0
fi


# ============================================================
# BUILD DISPLAY TEXT
# ============================================================

if (( COUNT == 1 )); then
    TEXT="󰖂 ${VPNs[0]}"
else
    TEXT="󰖂 $COUNT VPNs"
fi


# ============================================================
# BUILD TOOLTIP
# ============================================================

TOOLTIP="VPN connections:"

for vpn in "${VPNs[@]}"; do
    TOOLTIP+=$'\n'"• $vpn"
done


# ============================================================
# JSON OUTPUT
# ============================================================

if command -v jq >/dev/null 2>&1; then
    jq -cn \
        --arg text "$TEXT" \
        --arg tooltip "$TOOLTIP" \
        '{
            text: $text,
            class: "connected",
            tooltip: $tooltip
        }'
else
    # Fallback if jq is not installed.
    # Bash printf %q is NOT suitable for JSON, so keep
    # this fallback deliberately simple.
    JSON_TOOLTIP=${TOOLTIP//$'\n'/\\n}
    JSON_TEXT=${TEXT//\\/\\\\}
    JSON_TEXT=${JSON_TEXT//\"/\\\"}
    JSON_TOOLTIP=${JSON_TOOLTIP//\\/\\\\}
    JSON_TOOLTIP=${JSON_TOOLTIP//\"/\\\"}

    printf '{"text":"%s","class":"connected","tooltip":"%s"}\n' \
        "$JSON_TEXT" "$JSON_TOOLTIP"
fi
