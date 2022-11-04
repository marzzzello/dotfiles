# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-~/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-~/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ANTIGEN_LOG=${ZDOTDIR:-~}/.antigen/antigen.log
############ To install (optional) ############
# fzf:      pacman -S fzf       ## https://github.com/junegunn/fzf#installation
# thefuck:  pacman -S thefuck   ## https://github.com/nvbn/thefuck
# wpgtk:    yay -S wpgtk-git    ## https://github.com/deviantfero/wpgtk

############ Important Functions ############
fails=()
getFails()   {  for fail in $fails; do echo $fail; done; }
printFails() {
  local choicefile="~/.cache/printNoFails";
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

# Get emacs tramp working with zsh
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ '


############ Includes ############
# FZF
# => see under FZF

# Import colorscheme from wpgtk
[[ -f "~/.config/wpg/sequences" ]] && (cat ~/.config/wpg/sequences &)


############ Set shell options ############

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Command execution timestamp shown in the history command output.
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
# Find antigen or install antigen
function () {
  local a1="/usr/share/zsh/share/antigen.zsh"
  local a2="/usr/share/zsh-antigen/antigen.zsh"
  local a3="${ZDOTDIR:-~}/.antigen/antigen.zsh"
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
typeset -a ANTIGEN_CHECK_FILES=(${ZDOTDIR:-~}/.zshrc ${ZDOTDIR:-~}/.antigen/antigen.zsh)
ADOTDIR=${ZDOTDIR:-~}/.antigen
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
# Nice directory listing, ls replacement
antigen bundle supercrabtree/k

# Jump around
antigen bundle changyuheng/fz
antigen bundle rupa/z

# FZF completion everywhere
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
HISTFILE=${ZDOTDIR:-~}/.zsh_history

# Some nice functions
include "${ZDOTDIR:-~}/.zshfunc.zsh"


############ FZF ############
export FZF_DEFAULT_COMMAND='fd --type f --follow'
# CTRL-T - Paste the selected files and directories onto the command-line
export FZF_CTRL_T_OPTS="--height 80% --preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200' --bind 'shift-left:preview-page-up,shift-right:preview-page-down,?:toggle-preview,alt-w:toggle-preview-wrap,alt-e:execute($EDITOR {})'"
# CTRL-R - Paste the selected command from history onto the command-line
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
# ALT-C - cd into the selected directory
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"


FZF_DIR="${XDG_DATA_HOME:-~/.local/share}/fzf"
# Install fzf if not already installed
if ! (( $+commands[fzf] )); then

  export PATH="${PATH:+${PATH}:}${FZF_DIR}/bin"
  if [[ ! -d "${FZF_DIR}/bin" ]]; then
    echo "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "${FZF_DIR}" \
    && "${FZF_DIR}/install" --bin
  fi
fi
# FZF keybindings for Arch + Ubuntu + others
include /usr/share/fzf/key-bindings.zsh /usr/share/doc/fzf/examples/key-bindings.zsh "${FZF_DIR}/shell/completion.zsh"
include /usr/share/fzf/completion.zsh /usr/share/zsh/vendor-completions/_fzf "${FZF_DIR}/shell/key-bindings.zsh"


############ Aliases ############

source $ZDOTDIR/.zaliases

###

printFails
