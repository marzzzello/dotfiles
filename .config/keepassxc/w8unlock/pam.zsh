#!/usr/bin/env zsh

# pam.zsh
#
# This script should be started by pam_exec
# To achieve that, add the following line to /etc/pam.d/system-login
# auth       optional   pam_exec.so expose_authtok /home/YOUR_USERNAME/.config/keepassxc/w8unlock/pam.zsh
# Make sure that the path links to this script
# Add the line also to /etc/pam.d/swaylock to make it work with swaylock

LOGIN_PW="$(timeout --foreground 1 tr '\0' '\n')"
w8unlock="${0:a:h}/w8unlock.zsh"

# start w8unlock as backround process
echo "$LOGIN_PW" | sudo --preserve-env=PAM_USER -u "$PAM_USER" "$w8unlock" &!
