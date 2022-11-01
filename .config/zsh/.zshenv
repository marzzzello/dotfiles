# Set ZDOTDIR via systemd user environment variable (1) or call this file from ~/.zshenv (2)
# 1: echo 'ZDOTDIR=${ZDOTDIR:-~/.config/zsh}' >> ~/.config/environment.d/env.conf
# 2: echo ". ~/.config/zsh/.zshenv" > ~/.zshenv

export ZDOTDIR=${ZDOTDIR:-~/.config/zsh}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-~/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-~/.local/share}
# export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-~/.xdg}

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ("$SHLVL" -eq 1 && ! -o LOGIN) && -s ${ZDOTDIR:-~}/.zprofile ]]; then
    source ${ZDOTDIR:-~}/.zprofile
fi

# Preferred editor for local & root & remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim' # ssh
    [[ -f /etc/profile.d/telegram_sshalert.sh ]] && /etc/profile.d/telegram_sshalert.sh
elif [[ $USER = "root" ]]; then
    export EDITOR='vim' # non ssh but root
else
    export EDITOR='code --wait' # non ssh and non root
fi
