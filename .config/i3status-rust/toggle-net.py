#!/usr/bin/env python

from i3ipc import Connection
import re
import subprocess


def wifi_nm():
    """
    get wifi state from networkmanager
    """
    output = subprocess.check_output(['nmcli', 'radio', 'wifi'])
    state = output.decode('utf-8').strip()
    if state == "enabled":
        return True
    else:
        return False


def wifi_rfkill():
    """
    get wifi state from rfkill
    """
    output = subprocess.check_output(['rfkill', 'list', 'wifi'])
    r = re.findall("blocked: yes", output.decode('utf-8'))
    if len(r) == 0:
        # wifi not blocked
        return True
    else:
        return False


conn = Connection()
nets = conn.get_tree().find_instanced("gnome-control-center")

killed = False
for e in nets:
    if re.findall("on", e.floating):
        e.command('kill')
        killed = True
if not killed:
    if wifi_nm():
        # show wifi settings
        conn.command('exec "gnome-control-center wifi')
    else:
        # show network settings
        conn.command('exec "gnome-control-center network')
