#!/usr/bin/env zsh

renew() {
    current=$(wpg -c)
    case $current in
    goes16-*.png)
        echo goes
        goes
        ;;
    lakeside_[01][0-9].png)
        echo lakeside
        lakeside
        ;;
    himawari-*.png)
        echo himawari
        himawari
        ;;
    *) echo "no scripted theme set" ;;
    esac
}

renew_cached() {
    current=$(wpg -c)
    case ${current} in
    goes16-*.png)
        echo goes
        feh --bg-max ~/.cache/goes16background/goes16-*.png
        wpg -n -s ~/.cache/goes16background/goes16-*.png
        ;;
    lakeside_[01][0-9].png)
        echo lakeside
        wpg -s $(printf "$HOME/.config/wpg/scripted_themes/lakeside_imgs/lakeside_%02d.png" "$(($(date +%-H) / 2))")
        ;;
    himawari-*.png)
        echo himawari
        feh --bg-max ~/.cache/himawaripy/himawari-*.png
        wpg -n -s ~/.cache/himawaripy/himawari-*.png
        ;;
    *)
        echo "resetting non scripted theme"
        wpg -s ${current}
        ;;
    esac
}

goes() {
    rm -f ~/.cache/goes16background/goes16-*.png &>/dev/null

    # Download and set backround
    goes16-background --save-battery --deadline 1

    # Delete old, cached theme
    rm -f ~/.config/wpg/schemes/_home_*__cache_goes16background_goes16-*_png_* &>/dev/null

    # Generate and set new theme
    wpg -n -s ~/.cache/goes16background/goes16-*.png
}

himawari() {
    setopt extendedglob

    # Download and set backround
    himawaripy --auto-offset --save-battery --deadline 1

    # Delete old, cached themes
    rm -f ~/.config/wpg/schemes/_home_*__cache_himawaripy_himawari-*_png_* &>/dev/null

    # Generate and set new theme
    wpg -n -s ~/.cache/himawaripy/himawari-*.png

    unsetopt extendedglob
}

lakeside() {
    # filenum    time
    # 00 00:00 - 01:59
    # 01 02:00 - 03:59
    # 02 04:00 - 05:59
    # 03 06:00 - 07:59
    # 04 08:00 - 09:59
    # 05 10:00 - 11:59
    # 06 12:00 - 13:59
    # 07 14:00 - 15:59
    # 08 16:00 - 17:59
    # 09 18:00 - 19:59
    # 19 20:00 - 21:59
    # 11 22:00 - 23:59

    # divide hours by 2, add padding with zero, set image & theme
    wpg -s $(printf "$HOME/.config/wpg/scripted_themes/lakeside_imgs/lakeside_%02d.png" "$(($(date +%-H) / 2))")
}
