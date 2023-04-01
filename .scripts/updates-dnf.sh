#!/bin/sh

# You have to add the dnf command to the /etc/sudoers NOPASSWD of your user:
# user ALL=(ALL) NOPASSWD: /usr/bin/dnf updateinfo -q --list

updates=$(dnf updateinfo -q --list | wc -l)

if [ "$updates" -gt 0 ]; then
    echo "$updates"
else
    echo ""
fi
