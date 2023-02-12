#!/usr/bin/env zsh
basename="$HOME/Pictures/Screenshots-PC/Screenshot_$(date '+%Y%m%d-%H%M%S')_"

screenshot() {
    case "$1" in
    all)
        regions="all"
        ;;
    output)
        regions=$(swaymsg -t get_outputs |
            jq -r '.. | select(.name?) | {"name": .name, "rect": .rect} | "\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height) \(.name)"')
        ;;
    window)
        regions=$(swaymsg -t get_tree |
            jq -r '.. | select(.pid? and .visible?) | {"name": .name, "rect": .rect} | "\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height) \(.name)"')
        ;;
    *)
        regions=""
        ;;
    esac

    echo region: $regions >/dev/stderr

    if [[ $regions == "all" ]]; then
        grim - | swappy -o "${basename}all.png" -f -
        return
    elif [[ $regions != "" ]]; then
        echo $regions | slurp -d -f "%x,%y %wx%h %l" | read -r pos size title
        grim -g "$pos $size" - | swappy -o "${basename}${title:-selection}.png" -f -
    else
        slurp -d -f "%x,%y %wx%h" | read -r pos size
        grim -g "$pos $size" - | swappy -o "${basename}${title:-selection}.png" -f -
    fi
}

screenshot $@
