## Global aliases

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

## Suffix aliases

alias -s {asc,cpp,cxx,cc,c,hh,h,inl,txt,tex}='$EDITOR'
[[ -n "$BROWSER" ]] && alias -s {htm,html,de,org,net,com,at,cx,nl,se,dk}='$BROWSER'
[[ -n "$XIVIEWER" ]] && alias -s {jpg,jpeg,png,gif,mng,tiff,tif,xpm}='$XIVIEWER'
(( $+commands[texstudio] )) && alias -s tex='texstudio'
(( $+commands[mpv] )) && alias -s {ape,avi,flv,m4a,mkv,mov,mp3,mp4,mpeg,mpg,ogg,ogm,rm,wav,webm}='background mpv'

# read documents
alias -s pdf='background qpfdview'
alias -s ps=gv
alias -s dvi=xdvi
alias -s chm=xchm
alias -s djvu=djview

# list whats inside packed file
alias -s zip="unzip -l"
alias -s rar='unrar l'
alias -s tar='tar tf'
alias -s tar.gz='echo '

# use suffix aliases also for uppercase suffixes
for ext in ${(k)saliases}; alias -s $ext:u=$saliases[$ext]

## Normal aliases

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

alias zshrc='${=EDITOR} ${ZDOTDIR:-~}/.zshrc' # Quick access to the .zshrc file

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

# old command but new docker-compose v2 because zsh completion for docker command is outdated
[ -f /usr/libexec/docker/cli-plugins/docker-compose ] && alias docker-compose='/usr/libexec/docker/cli-plugins/docker-compose'

# docker-compose alias with all files
[ -d /opt/stacks ] && alias dc="cd /opt/stacks && docker-compose $(for f in /opt/stacks/*-dc.yml; do echo -n -f ${f##*/}\ ; done)"

  # fix ssh with kitty terminal
[[ "$TERM" == "xterm-kitty" && "$SSH_CONNECTION" == "" ]] &&  alias ssh="kitty +kitten ssh"

if [[ -n "$KITTY_WINDOW_ID" ]]; then
  alias kk="kitty +kitten"
  alias ki="kitty +kitten icat"
  alias kd="kitty +kitten diff"
  alias kc="kitty +kitten clipboard"
  alias ki="kitty +kitten icat"
fi

# fix emulator
alias emulator='/opt/android-sdk/tools/emulator'

# flatpak
alias code='flatpak run --command=code-oss --file-forwarding com.visualstudio.code-oss --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto --unity-launch'
alias codew='flatpak run --command=code-oss --file-forwarding com.visualstudio.code-oss --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto --unity-launch --wait'
alias dino='gtk-launch im.dino.Dino'
alias firefox='gtk-launch org.mozilla.firefox'
alias gimp='gtk-launch org.gimp.GIMP'
alias signal='gtk-launch org.signal.Signal'
alias spotify='gtk-launch com.spotify.Client'
alias telegram='gtk-launch org.telegram.desktop'


## Projects/Helpers

# ddnet time
alias ddtime='~/projects/ddtime/ddtime.sh'

# PDF,JPG,PNG to ODT or ODS
alias pdf2odt='~/projects/pdf2odt/pdf2odt'

# echo360 helpers
alias echo360='~/projects/echo360/run.sh'
alias echo360Helper='~/projects/echo360/echoDlHelper.sh'

# automerge folders
alias automerge='~/projects/Dubly/src/automerge.py'
alias duply='~/projects/Dubly/src/dubly.py'
