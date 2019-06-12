#!/usr/bin/env bash

toggle(){
  xdotool search "$1" && i3-msg '[instance='"$1"'] kill' || i3-msg exec "$1"

  # laggy when closing?!:
  # killall "$1" || i3-msg exec "$1"
}

toggle pavucontrol > /dev/null 2>&1
