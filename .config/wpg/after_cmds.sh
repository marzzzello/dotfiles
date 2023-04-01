#!/usr/bin/env bash
#makoctl reload
killall --quiet i3bar && i3bar --bar_id=bar-0
THEME=$(gsettings get org.gnome.desktop.interface gtk-theme)
gsettings set org.gnome.desktop.interface gtk-theme ""
sleep 0.2
gsettings set org.gnome.desktop.interface gtk-theme "${THEME}"
