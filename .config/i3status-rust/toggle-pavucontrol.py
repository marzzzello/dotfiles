#!/usr/bin/env python

import i3ipc
import re

conn = i3ipc.Connection()
ps = conn.get_tree().find_classed("Pavucontrol")

killed = False
for p in ps:
    if re.findall("on", p.floating):
        p.command('kill')
        killed = True

if not killed:
    conn.command('exec pavucontrol')
