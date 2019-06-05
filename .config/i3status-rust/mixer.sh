#!/usr/bin/env zsh

toggle(){
  xdotool search Pavucontrol && i3-msg '[class="Pavucontrol"] kill' || i3-msg exec pavucontrol

  # laggy when closing?!:
  # killall pavucontrol || i3-msg exec pavucontrol
}

toggle > /dev/null 2>&1
