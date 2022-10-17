# Preferred editor for local & root & remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim' # ssh
    /etc/profile.d/telegram_sshalert.sh
elif [[ $USER = "root" ]]; then
    export EDITOR='vim' # non ssh but root
else
    export EDITOR='code --wait' # non ssh and non root
fi
