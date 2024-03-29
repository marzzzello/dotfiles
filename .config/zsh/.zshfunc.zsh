#!/usr/bin/env zsh

# re-checkout everything, rerun gitattribute filters
reattr(){
  git stash
  rm .git/index
  git checkout HEAD -- "$(git rev-parse --show-toplevel)"
  git stash pop
}

# copy/paste for x11/wayland. Copy if something is piped into this function otherwise paste
clip(){
  if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
    [[ -t 0 ]] && wl-paste -n || wl-copy
  else
    [[ -t 0 ]] && xclip -o || xclip
  fi
}

mkcd(){
    mkdir "$@" && cd "$@";
}

dkim(){
  s="$1"
  [[ $2 ]] && n="$2" || n=85
  echo "len: $n" > /dev/stderr

  # inster space after ';'
  s=$(echo -n "$s" | sed 's/;/; /g')
  echo -e "dkim._domainkey\t\tTXT ("
  while [ ${#s} -gt $n ]; do
    echo "\"${s:0:$n}\"" # print first n characters
    s="${s:$n}" # save remaining characters
  done
  echo "\"${s:0:$n}\" )"
}

### Freeze and unfreeze processes (for example: stop firefox)
stop(){
  if [ $# -ne 1 ]; then
          echo 1>&2 Usage: stop process
  else
    PROCESS=$1
    echo "Stopping processes with the word ${tGreen}$1${tReset}"
    ps axw | grep -i $1 | awk -v PROC="$1" '{print $1}' | xargs kill -STOP
  fi
}

cont(){
  if [ $# -ne 1 ]; then
          echo 1>&2 Usage: cont process
  else
    PROCESS=$1
    echo "Continuing processes with the word ${tGreen}$1${tReset}"
    ps axw | grep -i $1 | awk -v PROC="$1" '{print $1}' | xargs kill -CONT
  fi
}

###

# copys the main identidy to server (~/.ssh/main.pub) and removes old ssh keys from server (see next function)
ssh-update-key(){
  if grep 'SSH2 PUBLIC KEY' -q ~/.ssh/main.pub; then
      echo "Please use OpenSSH format"
      return 1;
  fi
  ssh "$@" "cat ~/.ssh/authorized_keys" > /tmp/authorized_keys_before
  ssh-copy-id -i ~/.ssh/main.pub "$@"
  ssh-remove-old-keys "$@"
  ssh "$@" "cat ~/.ssh/authorized_keys" > /tmp/authorized_keys_after
  echo diff:
  diff /tmp/authorized_keys_{before,after} -u
  rm /tmp/authorized_keys_{before,after}
}

# removes all public keys from servers which are under ~/.ssh/old/*.pub
ssh-remove-old-keys(){
  sed="sed -i '"
  for file in ~/.ssh/old/*.pub; do
     if grep 'SSH2 PUBLIC KEY' -q $file; then
         echo "Please use OpenSSH format for $file"
         return 1;
     fi
    #echo "file: $file"
    fingerprint=`sed -e 's/\(ssh[a-z0-9-]*\)\W\+\(AAAA[0-9A-Za-z+/]\+[=]\{0,3\}\)\W\+\(.*\)/\2/' $file`
    sed+="\~$fingerprint~d; " # use tilde (~) as delemiter
  done
  sed+="'"

  ssh "$@" "$sed ~/.ssh/authorized_keys"
}

autoload -Uz compinit
compinit -u
compdef ssh-update-key=ssh
compdef ssh-remove-old-keys=ssh


### execute in backround
background() {
  for ((i=2;i<=$#;i++)); do
    ${@[1]} ${@[$i]} &> /dev/null &
  done
}

# use pipe to notify
notify(){
  while read input; do
    notify-send "message" "$input";
  done;
}

rf() {
	RG_PREFIX="rga --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 20 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="80%:down"
	)" &&
	echo "opening $file" &&
	xdg-open "$file"
}

rpdf() {
	RG_PREFIX="rga --files-with-matches -t pdf"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 20 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="80%:down"
	)" &&
	echo "opening $file" &&
	xdg-open "$file"
}

### pdf fuzzy searcher ## go get github.com/bellecp/fast-p
pdf() {
    open=xdg-open   # this will open pdf file withthe default PDF viewer on KDE, xfce, LXDE and perhaps on other desktops.

    # find . -type f -iname '*.pdf' \
    /usr/bin/fd ".pdf$" \
    | fast-p \
    | fzf --read0 --reverse -e -d $'\t'  \
        --preview-window down:80% --preview '
            v=$(echo {q} | tr " " "|");
            echo -e {1}"\n"{2} | grep -E "^|$v" -i --color=always;
        ' \
    | cut -z -f 1 -d $'\t' | tr -d '\n' | xargs -r --null $open > /dev/null 2> /dev/null
}

### cleanups

cutrash(){
  rm -rf ~/.local/share/Trash/
}
cudockerprune(){
  docker system prune -a -f
}
cudockervol(){
  docker volume rm $(docker volume ls -qf dangling=true)
}
cudocker(){
  if systemctl status docker.service | grep " Active: " | grep " active"; then
    :
  else
    case "$1" in
      -[fF]|-force) DockerStop=true;;
      *) echo "Docker not running. Use -f to temporarily start it."; return 1;;
    esac
      if DockerStop==false; then
        echo "starting Docker..."
        sudo systemctl start docker.service;
      fi

      cudockerprune;
      cudockervol;
      sudo du -hs  /var/lib/docker/;

      if DockerStop==false; then
        echo "stopping Docker..."
        sudo systemctl stop docker.service;
      fi
  fi
}

cu() {
  case "$1" in
     -[tT]|-trash)  cutrash;;
     -[pP]|-pm)     cupm;;
     -[dD]|-docker) cudocker $2 ;;
     -[aA]|-all)    cutrash; cupm; cudocker;;
     *|-[hH]|-help)
echo "Usage:
 -t  --trash
 -p  --pm
 -d  --docker
 -a  --all" ;;
  esac
}

# broot: a better tree
br() {
    local cmd cmd_file code
    cmd_file=$(mktemp)
    if broot --outcmd "$cmd_file" "$@"; then
        cmd=$(<"$cmd_file")
        rm -f "$cmd_file"
        eval "$cmd"
    else
        code=$?
        rm -f "$cmd_file"
        return "$code"
    fi
}


# mount fs stud
fsstud(){
  if sudo modprobe cifs; then
    local user=$(secret-tool lookup loginID user)
    local password=$(secret-tool lookup loginID pw)

    sudo mount -t cifs -o ,vers=3.0,username=$user,password=$password,\
    domain=ruhr-uni-bochum,uid=1000,gid=999 //fsstud.ruhr-uni-bochum.de/home/$user ~/fsstud
  else
    echo "Can not load cifs kernel module..."
    echo "Maybe you have updated your kernel but not loaded yet. Then reboot"
  fi
}


### login to login.rub.de even when DNS is not (yet) working
hirn(){
  local ip=$(curl -s --resolve login.rub.de:443:134.147.64.8 https://login.rub.de/cgi-bin/start \
      | sed -n 's/.*ipaddr\" value=\"\([0-9\.]*\).*/\1/p');
  local user=$(cat ~/.hirn.user)
  local password=$(cat ~/.hirn.pw)
  #echo "ip=$ip, user=$user, password=$password"

  curl -s --resolve login.rub.de:443:134.147.64.8 "https://login.rub.de/cgi-bin/laklogin" \
  --data "code=1&loginid=$user&password=$password&ipaddr=$ip&action=Login" \
  | grep -e small -e big | sed "s/<[^>]\+>//g"
}
# ... logout
hirnlogout(){
  curl -s --resolve login.rub.de:443:134.147.64.8 'https://login.rub.de/cgi-bin/laklogin' \
  --data 'code=1&loginid=&password=&ipaddr=&action=Logout' \
  | grep -e small -e big \
  | sed 's/<[^>]\+>//g'
}

### IP addresses
ips(){
  echo 'Internal IPs:'
  ipi
  echo -e '\nPublic IP:'
  ipp
}
# Public IPs
ipp(){
  dig +short +tcp myip.opendns.com @resolver1.opendns.com -4;
  dig +short +tcp myip.opendns.com @resolver1.opendns.com -6 AAAA
}
# Internal IPs
ipi(){
  ip a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)'\
       | awk '{ sub(/inet6? (addr:)? ?/, ""); print }'
}


### restart dnscrypt-proxy
reDNS(){
  sudo systemctl stop dnscrypt-proxy.service
  sudo systemctl restart dnscrypt-proxy.socket
  ping -c1 google.de
}


### keylogger
keystart() {
  for dev in /sys/class/input/event*; do
    event=`basename $dev`;
    grep -q '1[02]001[3Ff]' /sys/class/input/$event/device/capabilities/ev \
    && echo -n "$event: " \
    && cat /sys/class/input/$event/device/name \
    && sudo systemctl start logkeys@$event;
  done
}
keylog() {
  sudo tail -f /var/log/logkeys/*
}
keystop() {
  sudo systemctl stop "logkeys@*"
}



### Repo updater
gitud(){
  for i in */.git; do
    ( echo $i; cd $i/..; git pull; );
  done
}

gituam(){
  find . -name .git -type d \
 | xargs -n1 -P4 -I% git --git-dir=% --work-tree=%/.. remote update -p
}

gitua(){
  # store the current dir
  CUR_DIR=$(pwd)

  # Let the person running the script know what's going on.
  echo "Pulling in latest changes for all repositories..."

  # Find all git repositories and update it to the master latest revision
  for i in $(find . -name ".git" | cut -c 3-); do
      echo "";
      echo "$i";

      # We have to go to the .git parent directory to call the pull command
      cd "$i";
      cd ..;

      # finally pull
      git pull origin master;

      # lets get back to the CUR_DIR
      cd $CUR_DIR
  done
  echo "Complete!"
}


### pacman specific stuff
  # check if pacman is installed
if command -vp pacman > /dev/null; then

  alias pacman='pacman --color=auto'  # use more colors

  # pm -> yay if it is installed, if not pm -> pacman
  command -v yay &>/dev/null && alias pm="yay" || alias pm="pacman"

  # remove packages installed as dependency but not needed anymore
  alias cupm='pm -Qtdq && pm -Rucns --noconfirm $(pm -Qtdq); sudo paccache -r -k 0; pm -Scc --noconfirm'

  # update mirrorlist
  alias upmirror="sudo reflector --completion-percent 80 --country France --country Germany --age 6 --protocol https --sort rate --verbose --save /etc/pacman.d/mirrorlist"

  # update all packages
  alias uppm="pm -Syu --devel --timeupdate --noconfirm --noremovemake --noredownload  --norebuild --useask --sudoloop"

  # update keyring
  alias upkeys="pm -Sy --noconfirm archlinux-keyring; sudo pacman-key --populate archlinux"

  # full update
  alias upfull="upmirror && upkeys && uppm && cupm"


  paclist() {
    # Source: https://bbs.archlinux.org/viewtopic.php?id=93683
    LC_ALL=C pacman -Qei $1 | awk 'BEGIN {FS=":"} /^Name/{printf("\033[1;36m%s\033[1;37m", $2)} /^Description/{printf $2} /^Groups/{if ($2!=" None") printf("\033[1;31m%s\033[1;37m", $2)}/^Validated/{printf "\n"}'
  }

  pacdisowned() {
    emulate -L zsh

    tmp=${TMPDIR-/tmp}/pacman-disowned-$UID-$$
    db=$tmp/db
    fs=$tmp/fs

    mkdir "$tmp"
    trap  'rm -rf "$tmp"' EXIT

    pacman -Qlq | sort -u > "$db"

    find /bin /etc /lib /sbin /usr ! -name lost+found \
      \( -type d -printf '%p/\n' -o -print \) | sort > "$fs"

    comm -23 "$fs" "$db"
  }

  pacmanallkeys() {
    emulate -L zsh
    curl -s https://archlinux.org/people/{developers,trustedusers}/ | \
      awk -F\" '(/keyserver.ubuntu.com/) { sub(/.*search=0x/,""); print $1}' | \
      xargs sudo pacman-key --recv-keys
  }

  pacmansignkeys() {
    emulate -L zsh
    for key in $*; do
      sudo pacman-key --recv-keys $key
      sudo pacman-key --lsign-key $key
      printf 'trust\n3\n' | sudo gpg --homedir /etc/pacman.d/gnupg \
        --no-permission-warning --command-fd 0 --edit-key $key
    done
  }

  if (( $+commands[xdg-open] )); then
    pacweb() {
      pkg="$1"
      infos="$(pacman -Si "$pkg")"
      if [[ -z "$infos" ]]; then
        return
      fi
      repo="$(grep '^Repo' <<< "$infos" | grep -oP '[^ ]+$')"
      arch="$(grep '^Arch' <<< "$infos" | grep -oP '[^ ]+$')"
      xdg-open "https://archlinux.org/packages/$repo/$arch/$pkg/" &>/dev/null
    }
  fi

  # list explicit installed package with extra info, sorted by install date
  # -c enables colors
  mypaclist() {
    OLDIFS=$IFS
    c="$1"
    comm -23 <(pacman -Qetq) <(pacman -Qgq base-devel gnome texlive-most xorg | sort) | while read -r pkg version ; do
      sed -n -e "/ installed $pkg/{s/].*/]/p;q}" /var/log/pacman.log | tr "\n" ";";
      echo -n "$pkg;"
      LANG=C pacman -Qi $pkg | awk -F ': ' '/Description/ {print $2}'
      #sed -n "/%DESC%/{n;p}" "/var/lib/pacman/local/$pkg-$version/desc"
    done | sort > /tmp/tmpout

    IFS=';'

    while read -r date pkg desc; do
      if [ "$c" = "-c" ]; then
        tput setaf 6; tput bold
      fi
      echo "$pkg";
      if [ "$c" = "-c" ]; then
        tput setaf 7; #tput sgr0; tput bold
      fi
      echo "\t$desc"
      if [ "$c" = "-c" ]; then
        tput sgr0
      fi
      echo "\t$date"
    done < /tmp/tmpout
    yes|rm /tmp/tmpout
    IFS=$OLDIFS
  }

fi
