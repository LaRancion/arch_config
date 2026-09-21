#!/usr/bin/env bash

SERVICE="net.hadess.PowerProfiles"
OBJECT="/net/hadess/PowerProfiles"
INTERFACE="net.hadess.PowerProfiles"

get_profile() {
    busctl get-property \
        "$SERVICE" \
        "$OBJECT" \
        "$INTERFACE" \
        ActiveProfile 2>/dev/null |
        awk -F'"' '{print $2}'
}

set_profile() {
    busctl call \
        "$SERVICE" \
        "$OBJECT" \
        org.freedesktop.DBus.Properties \
        Set \
        ssv \
        "$INTERFACE" \
        ActiveProfile \
        s \
        "$1" >/dev/null
}

if [ "$1" = "toggle" ]; then
    CURRENT=$(get_profile)

    case "$CURRENT" in
        power-saver)
            set_profile balanced
            ;;
        balanced)
            set_profile performance
            ;;
        performance)
            set_profile power-saver
            ;;
    esac

    exit 0
fi

PROFILE=$(get_profile)

case "$PROFILE" in
    performance)
        printf '{"text":"󰓅 Performance","class":"performance","tooltip":"Power profile: Performance\\nClick to switch"}\n'
        ;;

    balanced)
        printf '{"text":"󰾅 Balanced","class":"balanced","tooltip":"Power profile: Balanced\\nClick to switch"}\n'
        ;;

    power-saver)
        printf '{"text":"󰾆 Saver","class":"power-saver","tooltip":"Power profile: Power Saver\\nClick to switch"}\n'
        ;;

    *)
        printf '{"text":"󰚥 Power","class":"unknown","tooltip":"Power profile unavailable"}\n'
        ;;
esac

