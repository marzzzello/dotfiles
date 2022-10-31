#!/bin/bash

APP_REF="org.keepassxc.KeePassXC/x86_64/master"

for inst in "$HOME/.local/share/flatpak" "/var/lib/flatpak"; do
    if [ -d "$inst/app/$APP_REF" ]; then
        FLATPAK_INST="$inst"
        break
    fi
done
[ -z "$FLATPAK_INST" ] && exit 1

APP_PATH="$FLATPAK_INST/app/$APP_REF/active"

RUNTIME_REF=$(awk -F'=' '$1=="runtime" { print $2 }' <"$APP_PATH/metadata")
RUNTIME_PATH="$FLATPAK_INST/runtime/$RUNTIME_REF/active"

exec flatpak-spawn \
    --app-path="$APP_PATH/files" \
    --usr-path="$RUNTIME_PATH/files" \
    -- keepassxc-proxy "$@"
