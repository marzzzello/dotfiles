#!/usr/bin/env python

from i3ipc import Connection
import re

conn = Connection()
htops = conn.get_tree().find_titled("htop-floating")

killed = False
for e in htops:
    print(e.window_title, e.floating)

    if re.findall("on", e.floating) and re.findall("htop-floating", e.window_title):
        e.command('kill')
        killed = True

if not killed:
    conn.command('exec "gnome-terminal --window --title htop-floating -- htop"')
