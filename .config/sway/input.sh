#!/usr/bin/env sh
sleep 4
swaymsg input type:keyboard xkb_layout de
sleep 2
swaymsg input type:touchpad dwt enabled
swaymsg input type:touchpad tap enabled
swaymsg input type:touchpad natural_scroll enabled
swaymsg input type:touchpad middle_emulation enabled
