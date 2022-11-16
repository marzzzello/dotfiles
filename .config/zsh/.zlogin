if ! pgrep -u "$USER" ssh-agent >/dev/null; then
    ssh-agent >~/.ssh-agent-thing
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
    eval "$(<~/.ssh-agent-thing)" >/dev/null
fi

# uncomment to disable bluetooth at startup:
#rfkill block bluetooth

############ Env variables ############
# PATH: add go binaries
[[ -d "$HOME/go/bin" ]] && export PATH=$HOME/go/bin:$PATH
# PATH: add perl tools
[[ -d "/usr/bin/core_perl" ]] && export PATH=/usr/bin/core_perl:$PATH
# PATH: add .local/bin
[[ -d "$HOME/.local/bin" ]] && export PATH=$HOME/.local/bin:$PATH
# PATH: latest android build tools
[[ -d "/opt/android-sdk" ]] && export PATH=/opt/android-sdk/build-tools/$(ls /opt/android-sdk/build-tools/ | tail -n1):$PATH &>/dev/null

export TERM="xterm-256color"

export GOPATH="$HOME/go"
export npm_config_prefix="$HOME/.local"

# colors for less and man pages
export LESS_TERMCAP_mb=$(
    tput bold
    tput setaf 2
) # green
export LESS_TERMCAP_md=$(
    tput bold
    tput setaf 6
) # cyan
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(
    tput bold
    tput setaf 3
    tput setab 4
) # yellow on blue
export LESS_TERMCAP_se=$(
    tput rmso
    tput sgr0
)
export LESS_TERMCAP_us=$(
    tput smul
    tput bold
    tput setaf 7
) # white
export LESS_TERMCAP_ue=$(
    tput rmul
    tput sgr0
)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)

# export QT_SCALE_FACTOR=0.7
# export QT_QPA_PLATFORMTHEME=qt5ct
#export QT_QPA_PLATFORMTHEME=gtk2
export QT_QPA_PLATFORMTHEME=qt5ct
#export QT_STYLE_OVERRIDE=kvantum
unset QT_STYLE_OVERRIDE
[[ $XDG_SESSION_TYPE == wayland ]] && export GDK_BACKEND=wayland

export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export QT_IM_MODULE=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus #kitty
# ibus-daemon -drx
