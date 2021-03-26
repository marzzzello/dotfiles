#!/usr/bin/env zsh

DBUS="qdbus"
ICON="battery-low"
INTERVAL=60
REPEAT_WARNING=false
WARNING_PERCENTAGE=15
WARNING_TEXT='Battery low $p%'
CRITICAL_PERCENTAGE='WARNING_PERCENTAGE / 2'
CRITICAL_TEXT='Battery really low $p%'
VERBOSE=false
STATUS="OK"
#SOUND_FILE
VOLUME=100

colors() {
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    cyan=$(tput setaf 6)
    reset=$(tput sgr0)
}

# Only use colors on stdout
if [ -t 1 ]; then
    colors
fi

print_help() {
    echo -e "${green}Options:${reset}
 -p     battery level percentage which is considered as warning
            ${cyan}Default: ${red}$WARNING_PERCENTAGE${reset}
 -k     battery level percentage which is considered as critical
            ${cyan}Default: ${red}$CRITICAL_PERCENTAGE${reset}
 -w     text to display for warnings
            ${cyan}Default: ${red}$WARNING_TEXT${reset}
 -c     text to display for critical warnings
            ${cyan}Default: ${red}$CRITICAL_TEXT${reset}
 -d     choose dbus command. There are currently qdbus and gdbus
            ${cyan}Default: ${red}$DBUS${reset}
 -i     name or path for the notification icon
            ${cyan}Default: ${red}$ICON${reset}
 -t     check the battery level in this interval (seconds)
            ${cyan}Default: ${red}$INTERVAL${reset}
 -r     repeat notifications every interval
            ${cyan}Default: ${red}$REPEAT_WARNING${reset}
 -s     path to sound file (uses paplay)
            ${cyan}Default: ${red}$SOUND_FILE${reset}
 -V     sound volume (0-100)
            ${cyan}Default: ${red}$VOLUME${reset}
 -h     show this help message and exit
 -v     turn on verbosity
            ${cyan}Default: ${red}$VERBOSE${reset}"
}

while getopts 'p:k:w:c:d:i:t:rp:w:s:V:hv' opt; do
    case "$opt" in
    p) WARNING_PERCENTAGE=$OPTARG ;;
    k) CRITICAL_PERCENTAGE=$OPTARG ;;
    w) WARNING_TEXT=$OPTARG ;;
    c) CRITICAL_TEXT=$OPTARG ;;
    d) DBUS=$OPTARG ;;
    i) ICON=$OPTARG ;;
    t) INTERVAL=$OPTARG ;;
    r) REPEAT_WARNING=true ;;
    s) SOUND_FILE=$OPTARG ;;
    V) VOLUME=$OPTARG ;;
    h) print_help && exit 1 ;;
    v) VERBOSE=true ;;
    *)
        echo "Unknown option $OPTARG"
        echo "Use -h to see usage"
        ;;
    esac
done

CRITICAL_PERCENTAGE_NE="$CRITICAL_PERCENTAGE"
CRITICAL_PERCENTAGE="$(eval echo "$(($CRITICAL_PERCENTAGE))")"

if [[ $VERBOSE = true ]]; then
    echo -e "WARNING_PERCENTAGE:${red}\t$WARNING_PERCENTAGE${reset}"
    echo -e "CRITICAL_PERCENTAGE_NE:${red}\t$CRITICAL_PERCENTAGE_NE${reset}"
    echo -e "CRITICAL_PERCENTAGE:${red}\t$CRITICAL_PERCENTAGE${reset}"
    echo -e "WARNING_TEXT:${red}\t\t$WARNING_TEXT${reset}"
    echo -e "CRITICAL_TEXT:${red}\t\t$CRITICAL_TEXT${reset}"
    echo -e "DBUS:${red}\t\t\t$DBUS${reset}"
    echo -e "ICON:${red}\t\t\t$ICON${reset}"
    echo -e "INTERVAL:${red}\t\t$INTERVAL${reset}"
    echo -e "REPEAT_WARNING:${red}\t\t$REPEAT_WARNING${reset}"
    echo -e "SOUND_FILE:${red}\t\t$SOUND_FILE${reset}"
    echo -e "VOLUME:${red}\t\t\t$VOLUME${reset}"
    echo -e "VERBOSE:${red}\t\t$VERBOSE${reset}"
    echo
fi

get_percent() {
    if [[ $DBUS = "qdbus" ]]; then
        percent=$(qdbus --system org.freedesktop.UPower \
            /org/freedesktop/UPower/devices/DisplayDevice \
            org.freedesktop.DBus.Properties.Get \
            org.freedesktop.UPower.Device Percentage)
    elif [[ $DBUS = "gdbus" ]]; then
        percent=$(gdbus call --system --dest org.freedesktop.UPower \
            --object-path /org/freedesktop/UPower/devices/DisplayDevice \
            --method org.freedesktop.DBus.Properties.Get \
            org.freedesktop.UPower.Device Percentage |
            grep -Eo '[0-9\.]*')
    else
        echo "only qdbus and gdbus are supported"
        exit 1
    fi
}

get_status() {
    get_percent

    if ((percent < CRITICAL_PERCENTAGE)); then
        STATUS="CRITICAL"
    elif ((percent < WARNING_PERCENTAGE)); then
        STATUS="WARNING"
    else
        STATUS="OK"
    fi
}

loop() {
    OLDSTATUS=$STATUS
    get_status
    [[ $VERBOSE = true ]] && printf "Battery level:${red}\t\t%.2f%%\n${reset}" "$percent"
    [[ $VERBOSE = true ]] && echo -e "OLDSTATUS:${red}\t\t$OLDSTATUS${reset}\nSTATUS:${red}\t\t\t$STATUS${reset}"
    notify
    sleep "$INTERVAL"
}

warning() {
    notify-send -i "$ICON" "$(eval echo "$WARNING_TEXT")"
    sound
}

critical() {
    notify-send -i "$ICON" "$(eval echo "$CRITICAL_TEXT")"
    sound
}

sound() {
    if [[ -n $SOUND_FILE ]]; then
        VOLUME=$((VOLUME * 65536 / 100))
        paplay "$SOUND_FILE" --volume $VOLUME &
    fi
}

notify() {
    p=$(printf "%.0f" "$percent")

    [[ $REPEAT_WARNING = true ]] && OLDSTATUS="OK"

    if [[ $OLDSTATUS = "$STATUS" ]]; then
        :
    elif [[ $OLDSTATUS = "OK" && $STATUS = "WARNING" ]]; then
        # send warning notification
        warning
    elif [[ $OLDSTATUS != "CRITICAL" && $STATUS = "CRITICAL" ]]; then
        # send critical notification
        critical
    else
        # battery got charged
        :
    fi
}

while true; do
    loop
done

######## logic ########
# OK -> OK        # never
# OK -> WARNING   # warning
# OK -> CRITICAL  # critictal

# WARNING -> OK       # no
# WARNING -> WARNING  # repeat -> warning
# WARNING -> CRITICAL # critical

# CRITICAL -> OK       # no
# CRITICAL -> WARNING  # no
# CRITICAL -> CRITICAL # repeat -> critical
