#!/usr/bin/env zsh

renew(){
    current=$(wpg -c)
    case $current in
        goes16-latest.png)        echo goes; goes;;
         lakeside_[01][0-9].png)  echo lakeside; lakeside;;
         himawari-*.png)          echo himawari; himawari;;
         *) echo "no scripted theme set";;
    esac
}

goes(){
    # Download and set backround
    goes16-background --save-battery --deadline 1;

    # Delete old, cached theme
    rm ~/.config/wpg/schemes/_home_marcel__cache_goes16background_goes16-latest_png_*;

    # Generate and set new theme
    wpg -n -s ~/.cache/goes16background/goes16-latest.png;
}

himawari(){
    setopt extendedglob

    # Download and set backround
    himawaripy --auto-offset --save-battery --deadline 1;

    # Delete old, cached themes
    rm ~/.config/wpg/schemes/_home_marcel__cache_himawaripy_^`basename $(ls ~/.cache/himawaripy/himawari-*.png) .png`*

    # Generate and set new theme
    wpg -n -s ~/.cache/himawaripy/himawari-*.png

    unsetopt extendedglob
}

lakeside(){
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
    wpg -s $(printf "$HOME/.config/wpg/scripted_themes/lakeside_imgs/lakeside_%02d.png" "$(( `date +%-H` / 2 ))")
}
