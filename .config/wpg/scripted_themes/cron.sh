#!/usr/bin/env zsh

# Useful for logs
date +%FT%T%:z

export I3SOCK=$(ls /run/user/*/*-ipc.*.sock)
echo I3SOCK: $I3SOCK
RESPONSE="$(i3-msg nop)"
# echo "Response: $RESPONSE"

if [[ "$RESPONSE" =~ '[ ?{"success":true} ?]' ]]; then
  source $HOME/.config/wpg/scripted_themes/theme_func.sh
  renew
else
  echo "Desktop not supported"
fi
