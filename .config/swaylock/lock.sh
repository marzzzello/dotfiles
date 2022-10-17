#!/usr/bin/env sh

LOCKARGS=""

work() {
    grim -o $1 $2
    #convert $IMAGE -blur $BLURTYPE -font Liberation-Sans -pointsize 26 -fill white -gravity center -comment 'Type password to unlock' - | composite -gravity center $LOCK - ${IMAGE}
    $HOME/.config/swaylock/pixelate.py $2
}

for OUTPUT in $(swaymsg -t get_outputs | jq -r '.[] | select(.active == true) | .name'); do
    IMAGE=/tmp/$OUTPUT-lock.png
    IMAGES="${IMAGES} ${IMAGE}"
    LOCKARGS="${LOCKARGS} --image ${OUTPUT}:${IMAGE}"
    work $OUTPUT $IMAGE &
done

wait
date -Is
killall evolution -s STOP
qdbus org.keepassxc.KeePassXC.MainWindow /keepassxc org.keepassxc.KeePassXC.MainWindow.lockAllDatabases && echo locked KeepassXC DBs
swaylock ${LOCKARGS}
date -Is
rm $IMAGES
