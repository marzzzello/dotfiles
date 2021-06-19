if ! pgrep -u "$USER" ssh-agent >/dev/null; then
    ssh-agent >~/.ssh-agent-thing
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
    eval "$(<~/.ssh-agent-thing)"
fi

export GOPATH="$HOME/go"
export npm_config_prefix="$HOME/.local"

# uncomment to disable bluetooth at startup:
#rfkill block bluetooth
