#!/usr/bin/env zsh

OPTIONS="\
Lock
Logout
Reboot
Power off
Suspend
Hibernate"

selection=`echo -e $OPTIONS | rofi -dmenu -i -p "power-menu"`
lock=(light-locker-command -l)

case "$selection" in
    Lock)         $lock;;
    Logout)       i3-msg exit;;
    Reboot)       reboot;;
    "Power off")  poweroff;;
    Suspend)      $lock; systemctl suspend;;
    Hibernate)    $lock; systemctl hibernate;;
    *)            echo "what is that?";;
esac
exit 0