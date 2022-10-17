#!/usr/bin/env bash
#makoctl reload
killall --quiet i3bar && i3bar --bar_id=bar-0
gsettings set org.gnome.desktop.interface gtk-theme ""
sleep 0.2
gsettings set org.gnome.desktop.interface gtk-theme FlatColor
