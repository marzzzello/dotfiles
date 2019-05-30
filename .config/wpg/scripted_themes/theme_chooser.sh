#!/usr/bin/env zsh

# without scripted_themes:
# wpg -s `wpg -l | rofi -dmenu -i -p "theme"`

themes=$(wpg -l)
scripted_themes="goes
himawari
lakeside"

source $HOME/.config/wpg/scripted_themes/theme_func.sh

choice=$(echo "random\nreset\n$themes\n$scripted_themes" | rofi -dmenu -i -p "theme")

if [ $? -eq 0 ]; then
  case $choice in
    goes)     goes;;
    lakeside) lakeside;;
    himawari) himawari;;
    random)   wpg -m;;
    reset)    wpg -s `wpg -c`;; #$HOME/.config/wpg/wp_init.sh;;
    *)        wpg -s "$choice";;
  esac
else
  echo "no choice"
  return 1
fi

