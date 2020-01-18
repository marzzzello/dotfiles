#!/usr/bin/env zsh

# Useful for logs

DESKTOP=$(loginctl show-session 2 -p Desktop | awk -F= '{print $2}')

date +%FT%T%:z

source $HOME/.config/wpg/scripted_themes/theme_func.sh

case $choice in
  i3|sway) renew;;
  *)       echo "Desktop not supported";;
esac

