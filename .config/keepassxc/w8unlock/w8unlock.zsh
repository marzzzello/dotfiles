#!/usr/bin/env zsh

# This script waits until i3 is ready, then it opens KeeKassXC and unlocks the database with the password given via stdin
# w8unlock = wait i3 ready, open keepassxc, unlock

# uncomment and insert your username and path:
# KEEPASSXC_USER="YOUR_USERNAME"
# DB_PATH="/home/$KEEPASSXC_USER/path/to/your/database.kdbx"

LOGFILE="${0:a:h}/log" # same directory as script
LOGIN_PW="$(timeout --foreground 1 tr '\0' '\n')"

adddate() {
    while IFS= read -r line; do
        printf '%s %s\n' "$(date --iso-8601=seconds)" "$line";
    done
}

debug(){
  echo "Starting..." | adddate
  env | adddate
  # echo "PW: $LOGIN_PW" | adddate
}

# sometimes state does not show
desktop_is_active(){
  for sessionid in $(loginctl list-sessions --no-legend | awk '{ print $1 }'); do
    CONDITIONS=$(loginctl show-session -p Name -p State -p Type -p Remote $sessionid \
    | grep -e Name=$KEEPASSXC_USER -e Remote=no -e State=active | wc -l)

    loginctl show-session -p State $sessionid
    # echo "COND=$CONDITIONS"
    if (( CONDITIONS == 3 )); then
      return
    fi

    return 1;
  done
}

i3_is_active(){
  I3SOCK="/run/user/1000/i3/$(ls /run/user/1000/i3 2>/dev/null | grep ipc-socket)" && \
  SUCCESS="$(i3-msg -s "$I3SOCK" nop | jq '.[0].success')" || return 1

  if [[ "$SUCCESS" == "true" ]]; then
    return
  else
    return 2
  fi
}

# max 15 seconds
wait_for_desktop(){
  for i in {1..15}; do
    i3_is_active
    case $? in
      0) echo "Ready"             | adddate; return;;
      1) echo "Far from ready"    | adddate;;
      2) echo "Not ready"         | adddate;;
      *) echo "non existing case" | adddate;;
    esac

    sleep 1;
  done;

  return 1;
}

openkeepassxc(){
  echo "Exec KeePassXC..." | adddate
  i3-msg -s "$I3SOCK" exec "echo "$LOGIN_PW" | keepassxc --pw-stdin $DB_PATH" | adddate
  echo Done | adddate;

}

main() {
  echo
  # debug

  if [[ "$PAM_USER" == "$KEEPASSXC_USER" ]]; then
    wait_for_desktop && openkeepassxc
  else
    echo "Wrong user" | adddate
  fi

}

main 2>&1 | tee -a "$LOGFILE"
