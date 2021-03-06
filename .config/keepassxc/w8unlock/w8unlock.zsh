#!/usr/bin/env zsh

# This script waits until KeePassXC is ready (e.g. autostart KeePassXC via i3 config), then it  unlocks the database with the password given via stdin
# w8unlock = wait until keepassxc is ready, unlock database via dbus

# uncomment and insert your username and path:
# KEEPASSXC_USER="YOUR_USERNAME"
# DB_PATH="/home/$KEEPASSXC_USER/path/to/your/database.kdbx"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

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

# max 15 seconds
wait_for_keepassxc() {
  for i in {1..20}; do
    qdbus org.keepassxc.KeePassXC.MainWindow / org.freedesktop.DBus.Peer.Ping &>/dev/null
    case $? in
    0)
      echo "Ready" | adddate
      return
      ;;
    2) echo "Not ready" | adddate ;;
    *) echo "non existing case" | adddate ;;
    esac

    sleep 1
  done

  return 1
}

openkeepassxc() {
  echo "Exec KeePassXC..." | adddate
  qdbus org.keepassxc.KeePassXC.MainWindow /keepassxc org.keepassxc.MainWindow.openDatabase "$DB_PATH" "$LOGIN_PW"
  echo "Done; Returned ${pipestatus[1]}" | adddate

}

main() {
  echo
  # debug

  if [[ "$PAM_USER" == "$KEEPASSXC_USER" ]]; then
    wait_for_keepassxc && openkeepassxc
  else
    echo "Wrong user: $PAM_USER" | adddate
  fi

}

main 2>&1 | tee -a "$LOGFILE"
