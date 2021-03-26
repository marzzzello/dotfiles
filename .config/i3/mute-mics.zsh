#!/usr/bin/env zsh

VERBOSE=false
SOURCE=""
DEFAULT_SOURCE=""
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
 -n     source name/index (if unset use default source)
            ${cyan}Default: ${red}$SOURCE${reset}
 -i     name or path for the notification icon
            ${cyan}Default: ${red}$ICON${reset}
 -h     show this help message and exit
 -v     turn on verbosity
            ${cyan}Default: ${red}$VERBOSE${reset}"
}

while getopts 'n:i:h:v' opt; do
    case "$opt" in
    n) SOURCE=$OPTARG ;;
    h) print_help && exit 1 ;;
    v) VERBOSE=true ;;
    *)
        echo "Unknown option $OPTARG"
        echo "Use -h to see usage"
        ;;
    esac
done

if [[ $VERBOSE = true ]]; then
    echo -e "SOURCE:${red}\t$SOURCE${reset}"
    echo -e "ICON:${red}\t\t\t$ICON${reset}"
    echo -e "VERBOSE:${red}\t\t$VERBOSE${reset}"
    echo
fi

get_default_source() {
    DEFAULT_SOURCE="$(pactl info | sed --silent 's/Default Source: //p')"
}

notify() {
    PA=$(pactl list sources | grep "Name: $SOURCE" -A10)
    MUTE=$(echo -n ${PA} | sed -n 's/\W*Mute: //p')
    VOLUME=$(echo -n ${PA} | sed -n 's/\W*Volume: //p' | head -n 1 | grep -Eo '[0-9]+%' | tr '\n' ' ')
    if [[ MUTE="yes" ]]; then
        ICON="audio-volume-muted"
    else
        ICON="audio-volume-high"
    fi

    ENCODED=$(echo -en "Source: ${SOURCE}\nMute: ${MUTE}\nVolume: ${VOLUME}")
    [[ $VERBOSE = true ]] && echo "${ENCODED}"
    notify-send -i "$ICON" "${ENCODED}"
}

main() {
    if [[ $SOURCE = "" ]]; then
        [[ $VERBOSE = true ]] && echo "Using default source"
        get_default_source
        SOURCE="${DEFAULT_SOURCE}"
    fi

    [[ $VERBOSE = true ]] && echo -e "SOURCE:${red}\t\t$SOURCE${reset}"

    pactl set-source-mute ${SOURCE} toggle
    notify
}

main
