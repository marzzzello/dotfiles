#!/usr/bin/env python

from i3ipc import Connection
import re

conn = Connection()
ps = conn.get_tree().find_classed("Blueberry.py")

killed = False
for p in ps:
    if re.findall("on", p.floating):
        p.command('kill')
        killed = True

if not killed:
    conn.command('exec blueberry')
