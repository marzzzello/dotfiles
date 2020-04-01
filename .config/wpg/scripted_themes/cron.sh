#!/usr/bin/env zsh

# Useful for logs
date +%FT%T%:z

RESPONSE="$(i3-msg nop)"
# echo "Response: $RESPONSE"

if [[ "$RESPONSE" == '[{"success":true}]' ]]; then
  source $HOME/.config/wpg/scripted_themes/theme_func.sh
  renew
else
  echo "Desktop not supported"
fi
