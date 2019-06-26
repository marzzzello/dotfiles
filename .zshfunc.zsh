#!/usr/bin/env zsh

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

# if in home directory and interactive shell, than manage dotfiles with extra parameters 
git=$(command -v git)
git(){
    if [ $PWD = "$HOME" ] && [ -t 1 ]; then
		#echo home
		$git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "$@"
	else
		#echo nonhome
		$git "$@"
	fi
	
}


ssh-update-key(){
  ssh "$@" "cat ~/.ssh/authorized_keys" > /tmp/authorized_keys_before
  ssh-copy-id -i $HOME/.ssh/main.pub "$@"
  ssh-remove-old-keys "$@"
  ssh "$@" "cat ~/.ssh/authorized_keys" > /tmp/authorized_keys_after
  echo diff:
  diff /tmp/authorized_keys_{before,after} -u
  rm /tmp/authorized_keys_{before,after}
}

ssh-remove-old-keys(){
  sed="sed -i '"
  for file in $HOME/.ssh/old/*.pub; do 
    #echo "file: $file"
    fingerprint=`sed -e 's/\(ssh[a-z0-9-]*\)\W\+\(AAAA[0-9A-Za-z+/]\+[=]\{0,3\}\)\W\+\(.*\)/\2/' $file`
    sed+="\~$fingerprint~d; " # use tilde (~) as delemiter
  done
  sed+="'"
  
  ssh "$@" "$sed ~/.ssh/authorized_keys"
}

autoload -Uz compinit
compinit
compdef ssh-update-key=ssh
compdef ssh-remove-old-keys=ssh


### execute in backround
background() {
  for ((i=2;i<=$#;i++)); do
    ${@[1]} ${@[$i]} &> /dev/null &
  done
}

function notify {
  while read input; do 
    notify-send "message" "$input"; 
  done; 
}

### pdf fuzzy searcher ## go get github.com/bellecp/fast-p
pdf () {
    open=xdg-open   # this will open pdf file withthe default PDF viewer on KDE, xfce, LXDE and perhaps on other desktops.

    fd ".pdf$" \
    | fast-p \
    | fzf --read0 --reverse -e -d $'\t'  \
        --preview-window down:80% --preview '
            v=$(echo {q} | tr " " "|"); 
            echo -e {1}"\n"{2} | grep -E "^|$v" -i --color=always;
        ' \
    | cut -z -f 1 -d $'\t' | tr -d '\n' | xargs -r --null $open > /dev/null 2> /dev/null
}


### cleanups
cupm(){
  if pacman -Qdtq; then
    sudo pacman -Runcs `pacman -Qdtq` --noconfirm
  fi
  echo "j\nj" | sudo pacman -Scc
}

cutrash(){
  rm -rf $HOME/.local/share/Trash/
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

function cu() {
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
  local user=$(secret-tool lookup loginID user)
  local password=$(secret-tool lookup loginID pw)
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
if command -v pacman > /dev/null; then
  function paclist() {
    # Source: https://bbs.archlinux.org/viewtopic.php?id=93683
    LC_ALL=C pacman -Qei $(pacman -Qu | cut -d " " -f 1) | \
      awk 'BEGIN {FS=":"} /^Name/{printf("\033[1;36m%s\033[1;37m", $2)} /^Description/{print $2}'
  }

  function pacdisowned() {
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

  function pacmanallkeys() {
    emulate -L zsh
    curl -s https://www.archlinux.org/people/{developers,trustedusers}/ | \
      awk -F\" '(/pgp.mit.edu/) { sub(/.*search=0x/,""); print $1}' | \
      xargs sudo pacman-key --recv-keys
  }

  function pacmansignkeys() {
    emulate -L zsh
    for key in $*; do
      sudo pacman-key --recv-keys $key
      sudo pacman-key --lsign-key $key
      printf 'trust\n3\n' | sudo gpg --homedir /etc/pacman.d/gnupg \
        --no-permission-warning --command-fd 0 --edit-key $key
    done
  }

  if (( $+commands[xdg-open] )); then
    function pacweb() {
      pkg="$1"
      infos="$(pacman -Si "$pkg")"
      if [[ -z "$infos" ]]; then
        return
      fi
      repo="$(grep '^Repo' <<< "$infos" | grep -oP '[^ ]+$')"
      arch="$(grep '^Arch' <<< "$infos" | grep -oP '[^ ]+$')"
      xdg-open "https://www.archlinux.org/packages/$repo/$arch/$pkg/" &>/dev/null
    }
  fi
  
  # list explicit installed package with extra info, sorted by install date
  # -c enables colors
  function mypaclist() {
    OLDIFS=$IFS
    c="$1"
    comm -23 <(pacman -Qetq) <(pacman -Qgq base base-devel gnome texlive-most xorg | sort) | while read -r pkg version ; do 
      sed -n -e "/ installed $pkg/{s/].*/]/p;q}" /var/log/pacman.log | tr "\n" ";";
      echo -n "$pkg;"
      LANG=en_US.UTF-8 pacman -Qi $pkg | awk -F ': ' '/Description/ {print $2}' 
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
