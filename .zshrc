############ To install ############
# oh-my-zsh:            trizen -S oh-my-zsh-git          ## https://github.com/robbyrussell/oh-my-zsh
# zsh-autosuggestions:  pacman -S zsh-autosuggestions    ## https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
# powerlevel9k:         pacman -S zsh-theme-powerlevel9k ## https://github.com/bhilburn/powerlevel9k/wiki/Install-Instructions
# fzf:                  pacman -S fzf                    ## https://github.com/junegunn/fzf#installation
# .zshfunc.zsh
# thefuck:              pacman -S thefuck                ## https://github.com/nvbn/thefuck
# wpgtk:                trizen -S wpgtk-git              ## https://github.com/deviantfero/wpgtk

############ Important Functions ############
fails=()
getFails()   { for fail in $fails; do echo $fail; done;}
printFails() { local choicefile="$HOME/.cache/printNoFails"; 
               if ! [ -f "$choicefile" ] && [ "${#fails[@]}" != 0 ]; then
               getFails;
               local compcontext='y:yes:(yes)';
               vared -cp 'Hide fails (yes)? ' ans; 
               if [ "$ans" = "yes" ]; then touch "$choicefile"; fi
               fi
             }
include ()   { [[ -f "$1" ]] && source "$1" || fails+=("$1") return 1}
exportzsh () { [[ -d "$1" ]] && export ZSH="$1" }

#get emacs tramp working with zsh
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ '
export TERM="xterm-256color" # Before sourcing oh-my-zsh


############ Includes ############

# oh-my-zsh
# => see under Oh-my-zsh

include '/usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme' || include '/usr/share/powerlevel9k/powerlevel9k.zsh-theme' || export ZSH_THEME=agnoster 

# FZF
# => see under FZF

# thefuck
eval $(thefuck --alias)

# Import colorscheme from wpgtk
(cat $HOME/.config/wpg/sequences &)


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

############ Plugins ############
source /usr/share/zsh/share/antigen.zsh

# Some nice functions 
include $HOME/.zshfunc.zsh

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
antigen bundle zsh-users/zsh-autosuggestions

# Extra zsh completions
antigen bundle zsh-users/zsh-completions

# Load the theme
#antigen theme robbyrussell

# Tell antigen that you're done
antigen apply


############ FZF ############
export FZF_CTRL_T_OPTS="--height 80% --preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200' --bind 'shift-left:preview-page-up,shift-right:preview-page-down,?:toggle-preview,alt-w:toggle-preview-wrap,alt-e:execute($EDITOR {})'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# Directly executing the command (CTRL-X CTRL-R)
fzf-history-widget-accept() {
  fzf-history-widget
  zle accept-line
}
zle     -N     fzf-history-widget-accept
bindkey '^X^R' fzf-history-widget-accept

# fzf keybindings
include /usr/share/fzf/key-bindings.zsh
include /usr/share/fzf/completion.zsh


############ Aliases (more special ones first) ############

# fix emulator
alias emulator='/opt/android-sdk/tools/emulator'

# start & unlock KeepassXC/Hibiscus with secret-tool
alias kxc="(secret-tool lookup keepassDB pws | keepassxc --pw-stdin ~/1+3/documents/pws.kdbx &)"


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

unalias fd # use real fd ;)
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