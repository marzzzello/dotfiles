#!/usr/bin/env zsh

# This script waits until KeePassXC is ready (e.g. autostart KeePassXC via i3 config), then it  unlocks the database with the password given via stdin
# w8unlock = wait until keepassxc is ready, unlock database via dbus

USER_ID=$DotSecrets: user_id$
KEEPASSXC_USER="$DotSecrets: keepassxc_user$"
DB_PATH="$DotSecrets: db_path$"

LOGFILE="${0:a:h}/log" # same directory as script
LOGIN_PW="$(timeout --foreground 1 tr '\0' '\n')"

adddate() {
  while IFS= read -r line; do
    printf '%s %s\n' "$(date --iso-8601=seconds)" "$line"
  done
}

debug() {
  echo "Starting..." | adddate
  env | adddate
  # echo "PW: $LOGIN_PW" | adddate
}

# max 20 seconds
wait_for_keepassxc() {
  for i in {1..20}; do
    # set DBUS address
    pidof swayidle && _DBUS_ENV=$(cat /proc/$(pidof swayidle)/environ | grep -Po --text 'DBUS_SESSION_BUS_ADDRESS=[^\x00]*')
    if [[ $_DBUS_ENV =~ unix ]]; then
      export $_DBUS_ENV
      echo "DBUS_SESSION_BUS_ADDRESS set to ${DBUS_SESSION_BUS_ADDRESS}"
    else
      export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus" # for x11
      echo "DBUS_SESSION_BUS_ADDRESS set to ${DBUS_SESSION_BUS_ADDRESS}"
    fi
    qdbus org.keepassxc.KeePassXC.MainWindow / org.freedesktop.DBus.Peer.Ping &>/dev/null
    case $? in
    0)
      echo "Ready" | adddate
      return
      ;;
    2) echo "Not ready" | adddate ;;
    *) echo "Something went wrong" | adddate ;;
    esac

    sleep 1
  done

  return 1
}

openkeepassxc() {
  echo "Exec KeePassXC..." | adddate
  qdbus org.keepassxc.KeePassXC.MainWindow /keepassxc org.keepassxc.KeePassXC.MainWindow.openDatabase "$DB_PATH" "$LOGIN_PW"
  echo "Done; Returned ${pipestatus[1]}" | adddate
}

main() {
  echo
  # debug

  if [[ "$PAM_USER" == "$KEEPASSXC_USER" ]]; then
    wait_for_keepassxc && sleep 3 && openkeepassxc
  else
    echo "Wrong user: $PAM_USER" | adddate
  fi

}

main 2>&1 | tee -a "$LOGFILE"
