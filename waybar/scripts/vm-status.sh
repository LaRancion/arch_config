#!/usr/bin/env bash

if ! command -v virsh >/dev/null 2>&1; then
    printf '{"text":"󰐻 VM","class":"disconnected","tooltip":"libvirt/virsh not installed"}\n'
    exit 0
fi

VMS=$(virsh -c qemu:///system list --state-running --name 2>/dev/null | sed '/^$/d')
COUNT=$(printf '%s\n' "$VMS" | sed '/^$/d' | wc -l)

if [ "$COUNT" -gt 0 ]; then
    NAMES=$(printf '%s\n' "$VMS" | paste -sd ', ' -)

    printf '{"text":"󰐻 %s VM","class":"running","tooltip":"Running VMs:\\n%s"}\n' \
        "$COUNT" "$NAMES"
else
    printf '{"text":"󰐻 0 VM","class":"disconnected","tooltip":"No virtual machines running"}\n'
fi
