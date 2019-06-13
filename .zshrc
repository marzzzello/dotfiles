ANTIGEN_LOG=$HOME/antigen.log
############ To install ############
# antigen:              trizen -S antigen-git            ## https://github.com/zsh-users/antigen
# purepower:                                             ## https://github.com/romkatv/dotfiles-public/blob/master/.purepower
# fzf:                  pacman -S fzf                    ## https://github.com/junegunn/fzf#installation
# .zshfunc.zsh
# thefuck:              pacman -S thefuck                ## https://github.com/nvbn/thefuck
# wpgtk:                trizen -S wpgtk-git              ## https://github.com/deviantfero/wpgtk

############ Important Functions ############
fails=()
getFails()   {  for fail in $fails; do echo $fail; done; }
printFails() {  
	local choicefile="$HOME/.cache/printNoFails"; 
    if ! [ -f "$choicefile" ] && [ "${#fails[@]}" != 0 ]; then
    getFails;
    local compcontext='y:yes:(yes)';
    vared -cp 'Hide fails (yes)? ' ans; 
    [[ "$ans" = "yes" ]] && touch "$choicefile";
    fi
}
include ()   { 
    if [[ -f "$1" ]]; then
        source "$1";
    elif [[ -f "$2" ]]; then
        source "$2";
    else
        fails+=("One of these: $1 || $2");
        return 1;
    fi
}
exportzsh () { [[ -d "$1" ]] && export ZSH="$1" }

#get emacs tramp working with zsh
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ '


############ Includes ############

# FZF
# => see under FZF

# thefuck
eval $(thefuck --alias)

# Import colorscheme from wpgtk
[[ -f "$HOME/.config/wpg/sequences" ]] && (cat $HOME/.config/wpg/sequences &)


############ Set shell options ############

# display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# command execution timestamp shown in the history command output.
HIST_STAMPS="yyyy-mm-dd"

HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$HOME/.zsh_history"

# The list (hash) of commands will be updated for each search by issuing the rehash command. 
# Disable if file access is slow 
zstyle ":completion:*:commands" rehash 1

### setopts
# GLOBDOTS lets files beginning with a . be matched without explicitly specifying the dot. 
# setopt globdots
# http://zsh.sourceforge.net/Intro/intro_2.html#SEC2
setopt extendedglob


############ Env variables ############
# make go binaries accessible
export PATH=$HOME/go/bin:$PATH

export TERM="xterm-256color"

export BROWSER="firefox" 
export XIVIEWER="shotwell"

# Preferred editor for local & root & remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'   # ssh
elif [[ $USER = "root" ]]; then
  export EDITOR='vim'   # non ssh but root
else
  export EDITOR='subl'  # non ssh and non root
fi

# Display context under sudo -i
[[ $USER != root ]] && DEFAULT_USER=$USER


############ Plugins ############
local a1="/usr/share/zsh/share/antigen.zsh"
local a2="/usr/share/zsh-antigen/antigen.zsh"
local a3="$HOME/.antigen.zsh"
if [[ -f $a1 ]]; then
    ANTIGEN=$a1;
elif [[ -f $a2 ]]; then
    ANTIGEN=$a2;
elif [[ -f $a3 ]]; then
    ANTIGEN=$a3;
else
    echo "Downloading Antigen to $a3"
    curl -L git.io/antigen > $a3 \
    && ANTIGEN=$a3
fi

source $ANTIGEN

# Load the oh-my-zsh's library
antigen use oh-my-zsh

antigen bundle adb
antigen bundle colorize
antigen bundle command-not-found
antigen bundle common-aliases
antigen bundle git
antigen bundle gradle
antigen bundle npm
antigen bundle pip

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Fish-like auto suggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=1'
antigen bundle zsh-users/zsh-autosuggestions

# Extra zsh completions
antigen bundle zsh-users/zsh-completions

# Auto-close and delete matching delimiters
antigen bundle hlissner/zsh-autopair

# Load the theme
antigen theme romkatv/powerlevel10k
# Load theme settings
include ~/.purepower

# Tell antigen that you're done
antigen apply

# Some nice functions 
include "$HOME/.zshfunc.zsh"


############ FZF ############
# CTRL-T - Paste the selected files and directories onto the command-line 
export FZF_CTRL_T_OPTS="--height 80% --preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200' --bind 'shift-left:preview-page-up,shift-right:preview-page-down,?:toggle-preview,alt-w:toggle-preview-wrap,alt-e:execute($EDITOR {})'"
# CTRL-R - Paste the selected command from history onto the command-line 
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
# ALT-C - cd into the selected directory 
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# Directly executing the command (CTRL-X CTRL-R)
fzf-history-widget-accept() {
  fzf-history-widget
  zle accept-line
}
zle     -N     fzf-history-widget-accept
bindkey '^X^R' fzf-history-widget-accept

# fzf keybindings for Arch + Ubuntu
include /usr/share/fzf/key-bindings.zsh /usr/share/doc/fzf/examples/key-bindings.zsh
include /usr/share/fzf/completion.zsh   /usr/share/zsh/vendor-completions/_fzf
# export FZF_DEFAULT_OPTS='--bind tab:down --cycle'
# export FZF_COMPLETION_TRIGGER=''

# Defaults:
# bindkey '^T' fzf-file-widget
# bindkey '\ec' fzf-cd-widget
# bindkey '^R' fzf-history-widget

#bindkey '^F' fzf-file-widget
#bindkey '^X' fzf-cd-widget
#bindkey '^Y' fzf-completion
#bindkey '^I' $fzf_default_completion

############ Aliases (more special ones first) ############

# fix emulator
alias emulator='/opt/android-sdk/tools/emulator'

# start & unlock KeepassXC/Hibiscus with secret-tool
alias kxc="(secret-tool lookup keepassDB pws | keepassxc --pw-stdin ~/1+3/pws.kdbx &)"


## Projects/Helpers

# ddnet time
alias ddtime='~/projects/ddtime/ddtime.sh'

# PDF,JPG,PNG to ODT or ODS
alias pdf2odt="~/projects/pdf2odt/pdf2odt"

# echo360 helpers
alias echo360="~/projects/echo360/run.sh"
alias echo360Helper="~/projects/echo360/echoDlHelper.sh"

# moodle crawler
alias moodle="python2 ~/Moodle-Crawler/src/moodleCrawler.py"
alias extlogrm="find . -name 'external-links.log' -execdir bash -c 'old="$1"; new="../$(basename -- "$PWD").${old##*.}"; mv "$old" "$new"; rmdir "$PWD"' - {} \;"

# automerge folders
alias automerge=~/projects/Dubly/src/automerge.py
alias duply=~/projects/Dubly/src/dubly.py

##


# pm -> trizen if it is installed, if not pm -> pacman
type trizen >/dev/null 2>&1 && alias pm="trizen" || alias pm="pacman"

# Clipboard
alias xclip="xclip -selection c"
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

# more colors
alias ccat='colorize_via_pygmentize'
alias cnf-lookup='cnf-lookup --colors'
alias pacman='pacman --color=auto'  # use more colors

# suffix aliases
alias -s html='background firefox'
alias -s {pdf,PDF}='background qpfdview'
alias -s {ape,avi,flv,m4a,mkv,mov,mp3,mp4,mpeg,mpg,ogg,ogm,rm,wav,webm}='background vlc'
alias -s {asc,base,c,cc,cpp,cxx,h,hh,inl,tex,txt,TXT}="$EDITOR"
alias -s tex='texstudio'
alias -s {zip,ZIP}="unzip -l"
alias -s {rar,RAR}='unrar l'
alias -s tar.gz='echo '
alias -s tar='tar tf'

# global alias
alias -g ES="2>&1"

# use real fd ;)
[[ $(which fd) == *aliased* ]] && unalias fd

alias fh="fd -HI" # fd with hidden and ignored files
# if lsd is installed use it, if not use ls
which lsd > /dev/null && alias l="lsd -la" || alias l='ls -lAFh'

alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias firefox="env GTK_THEME=Adwaita:light firefox"
alias diff='diff --color=auto'

alias week='date +%V' #week number

alias dd="dd status=progress"

alias rmlh=" tail -3 ~/.zsh_history ; head -n -1 ~/.zsh_history > ~/.zsh_history.tmp ; mv ~/.zsh_history.tmp .zsh_history ; echo "last:" ;tail -1 ~/.zsh_history"
alias searchsploit='/usr/share/exploit-db/searchsploit'
alias msfconsole="msfconsole --quiet -x \"db_connect ${USER}@msf\""


alias teamV="sudo systemctl start teamviewerd.service && teamviewer"


# mass renaming files 
autoload zmv
alias mmv='noglob zmv -W'

alias proxy='sudo iptables -t nat -A OUTPUT -p tcp --dport  80 -m owner ! --uid-owner 1001 -j DNAT --to-destination 127.0.0.1:8080; \
             sudo iptables -t nat -A OUTPUT -p tcp --dport 443 -m owner ! --uid-owner 1001 -j DNAT --to-destination 127.0.0.1:8443'
alias proxystop='sudo iptables -t nat -F'

###

printFails

