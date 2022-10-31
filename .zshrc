#!/usr/bin/env zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ANTIGEN_LOG=$HOME/.antigen/antigen.log
############ To install (optional) ############
# fzf:      pacman -S fzf       ## https://github.com/junegunn/fzf#installation
# thefuck:  pacman -S thefuck   ## https://github.com/nvbn/thefuck
# wpgtk:    yay -S wpgtk-git    ## https://github.com/deviantfero/wpgtk

############ Important Functions ############
fails=()
getFails()   {  for fail in $fails; do echo $fail; done; }
printFails() {
  local choicefile="$HOME/.cache/printNoFails";
  if ! [[ -f "$choicefile" ]] && [[ "${#fails[@]}" != 0 ]]; then
    getFails;
    local compcontext='y:yes:(yes)';
    vared -cp 'Hide fails (yes)? ' ans;
    [[ "$ans" = "yes" ]] && touch "$choicefile";
  fi
}
include ()   {
  for arg in "$@"; do
    [[ -z $l ]] && local list="$arg" || list+=", $arg"
    if [[ -f "$arg" ]]; then
      source "$arg";
      local SUCCESS=true;
      break;
    fi
  done
  if [[ -z $SUCCESS ]]; then
    if [[ "${#[@]}" > 1 ]]; then
      fails+=("One of these: $list")
    else
      fails+=("$1");
    fi
    return 1;
  fi
}
exportzsh () { [[ -d "$1" ]] && export ZSH="$1" }

# get emacs tramp working with zsh
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ '


############ Includes ############
# FZF
# => see under FZF

# Import colorscheme from wpgtk
[[ -f "$HOME/.config/wpg/sequences" ]] && (cat $HOME/.config/wpg/sequences &)


############ Set shell options ############

# display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# command execution timestamp shown in the history command output.
HIST_STAMPS="yyyy-mm-dd"

# The list (hash) of commands will be updated for each search by issuing the rehash command.
# Disable if file access is slow
zstyle ":completion:*:commands" rehash 1

### setopts
# GLOBDOTS lets files beginning with a . be matched without explicitly specifying the dot.
# setopt globdots
# http://zsh.sourceforge.net/Intro/intro_2.html#SEC2
setopt extendedglob


############ Plugins ############
# find antigen or install antigen
function () {
  local a1="/usr/share/zsh/share/antigen.zsh"
  local a2="/usr/share/zsh-antigen/antigen.zsh"
  local a3="$HOME/.antigen/antigen.zsh"
  if [[ -f $a1 ]]; then
    ANTIGEN="$a1";
    elif [[ -f $a2 ]]; then
    ANTIGEN="$a2";
    elif [[ -f $a3 ]]; then
    ANTIGEN="$a3";
  else
    echo "Downloading Antigen to $a3"
    mkdir -p ${a3:h}
    curl -L git.io/antigen > $a3 \
    && ANTIGEN=$a3
  fi
}
source $ANTIGEN

# Load the oh-my-zsh's library
antigen use oh-my-zsh

antigen bundle adb
antigen bundle code
antigen bundle colorize
antigen bundle command-not-found
antigen bundle cp
antigen bundle docker-compose
antigen bundle git
antigen bundle gradle
antigen bundle npm
antigen bundle pip
if (( $+commands[thefuck] )); then
  antigen bundle thefuck
fi;
# nice directory listing, ls replacement
antigen bundle supercrabtree/k

# jump around
antigen bundle changyuheng/fz
antigen bundle rupa/z

# fzf completion everywhere
antigen bundle Aloxaf/fzf-tab

# Fish-like auto suggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=1'
antigen bundle zsh-users/zsh-autosuggestions

# Extra zsh completions
antigen bundle zsh-users/zsh-completions
antigen bundle spwhitt/nix-zsh-completions

# Auto-close and delete matching delimiters
antigen bundle hlissner/zsh-autopair

# Syntax highlighting
antigen bundle z-shell/F-Sy-H --branch=main

# Load the theme
antigen theme romkatv/powerlevel10k
# Load theme settings. To customize, run `p10k configure` or edit ~/.p10k.zsh.
include ~/.p10k.zsh

# Tell antigen that you're done
antigen apply

# After oh-my-zsh
HISTSIZE=1000000000
SAVEHIST=1000000000

# Some nice functions
include "$HOME/.zshfunc.zsh"


############ FZF ############
export FZF_DEFAULT_COMMAND='fd --type f --follow'
# CTRL-T - Paste the selected files and directories onto the command-line
export FZF_CTRL_T_OPTS="--height 80% --preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200' --bind 'shift-left:preview-page-up,shift-right:preview-page-down,?:toggle-preview,alt-w:toggle-preview-wrap,alt-e:execute($EDITOR {})'"
# CTRL-R - Paste the selected command from history onto the command-line
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
# ALT-C - cd into the selected directory
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# install fzf if not already installed
if ! (( $+commands[fzf] )); then
  export PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
  if [[ ! -d "$HOME/.fzf/bin" ]]; then
    echo "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
    && $HOME/.fzf/install --bin
  fi
fi
# fzf keybindings for Arch + Ubuntu + others
include /usr/share/fzf/key-bindings.zsh /usr/share/doc/fzf/examples/key-bindings.zsh $HOME/.fzf/shell/completion.zsh
include /usr/share/fzf/completion.zsh /usr/share/zsh/vendor-completions/_fzf $HOME/.fzf/shell/key-bindings.zsh

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

############ Aliases (more general ones first) ############


# make alias work with sudo https://wiki.archlinux.org/title/sudo#Passing_aliases
alias sudo='sudo '

# prompt before removing/overwrite
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ls short cmds
alias l='ls -lFh'     #size,show type,human readable
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias ll='ls -l'      #long list
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'
alias lsr='ls -lARFh' #Recursive list of files and directories
alias lsn='ls -1'     #A column contains name of files and directories

alias zshrc='${=EDITOR} ${ZDOTDIR:-$HOME}/.zshrc' # Quick access to the .zshrc file

alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

alias t='tail -f'




alias h='history'
alias hgrep="fc -El 0 | grep"
alias help='man'
alias p='ps -f'
alias sortnr='sort -n -r'
alias unexport='unset'



# Clipboard
alias xclip="xclip -selection c"
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

# more colors
alias diff='diff --color=auto'
alias grep='grep --color'
alias ip="ip -color"


## Modern Unix tools

# cat => bat
(( $+commands[bat] )) && alias cat="bat"
(( $+commands[batcat] )) && alias cat="batcat"

# ls => lsd
(( $+commands[lsd] )) && alias l="lsd -la" || alias l='ls -lAFh'

# fdfind => fd (ubuntu): if fdfind exists and fd is not used then alias fd
{ (( $+commands[fdfind] )) && ! (( $+commands[fd] )) } && alias fd="fdfind"
alias fh="fd -HI" # fd with hidden and ignored files

# df => duf
(( $+commands[duf] )) && alias df="duf"

# du => dust
(( $+commands[dust] )) && alias du="dust" && alias dud="dunst -d 1" || alias du='du -h' && alias dud='du -d 1' && alias duf='du -s *'

##

alias dd="dd status=progress"
alias week='date +%V' #week number
alias rmlh=" tail -3 ~/.zsh_history ; head -n -1 ~/.zsh_history > ~/.zsh_history.tmp ; mv ~/.zsh_history.tmp .zsh_history ; echo "last:" ;tail -1 ~/.zsh_history"
alias searchsploit='/usr/share/exploit-db/searchsploit'
alias msfconsole="msfconsole --quiet -x \"db_connect ${USER}@msf\""
alias ap="ansible-playbook"
alias k="k -h"
alias teamV="sudo systemctl start teamviewerd.service && teamviewer"

# mass renaming files
autoload zmv
alias mmv='noglob zmv -W'

alias proxy='sudo iptables -t nat -A OUTPUT -p tcp --dport  80 -m owner ! --uid-owner 1001 -j DNAT --to-destination 127.0.0.1:8080; \
sudo iptables -t nat -A OUTPUT -p tcp --dport 443 -m owner ! --uid-owner 1001 -j DNAT --to-destination 127.0.0.1:8443'
alias proxystop='sudo iptables -t nat -F'

# docker-compose alias with all files
[ -d /opt/stacks ] && alias dc="cd /opt/stacks && docker-compose $(for f in /opt/stacks/*-dc.yml; do echo -n -f ${f##*/}\ ; done)"
if [[ "$TERM" == "xterm-kitty" && "$SSH_CONNECTION" == "" ]]; then
  # fix ssh with kitty terminal
  alias ssh="kitty +kitten ssh"
  alias kk="kitty +kitten"
  alias ki="kitty +kitten icat"
  alias kd="kitty +kitten diff"
  alias kc="kitty +kitten clipboard"
  alias ki="kitty +kitten icat"
fi

# fix emulator
alias emulator='/opt/android-sdk/tools/emulator'

## Projects/Helpers

# ddnet time
alias ddtime='~/projects/ddtime/ddtime.sh'

# PDF,JPG,PNG to ODT or ODS
alias pdf2odt="~/projects/pdf2odt/pdf2odt"

# echo360 helpers
alias echo360="~/projects/echo360/run.sh"
alias echo360Helper="~/projects/echo360/echoDlHelper.sh"

# automerge folders
alias automerge=~/projects/Dubly/src/automerge.py
alias duply=~/projects/Dubly/src/dubly.py



# global alias
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g M="| most"
alias -g ES="2>&1"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g P="2>&1  | pygmentize -l pytb"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"

# suffix aliases
alias -s {asc,cpp,cxx,cc,c,hh,h,inl,txt,tex}='$EDITOR'
[[ -n "$BROWSER" ]] && alias -s {htm,html,de,org,net,com,at,cx,nl,se,dk}='$BROWSER'
[[ -n "$XIVIEWER" ]] && alias -s {jpg,jpeg,png,gif,mng,tiff,tif,xpm}='$XIVIEWER'
(( $+commands[texstudio] )) && alias -s tex='texstudio'
(( $+commands[mpv] )) && alias -s {ape,avi,flv,m4a,mkv,mov,mp3,mp4,mpeg,mpg,ogg,ogm,rm,wav,webm}='background mpv'

#read documents
alias -s pdf='background qpfdview'
alias -s ps=gv
alias -s dvi=xdvi
alias -s chm=xchm
alias -s djvu=djview

#list whats inside packed file
alias -s zip="unzip -l"
alias -s rar='unrar l'
alias -s tar='tar tf'
alias -s tar.gz='echo '

# use suffix aliases also for uppercase suffixes
for ext in ${(k)saliases}; alias -s $ext:u=$saliases[$ext]

###

printFails
