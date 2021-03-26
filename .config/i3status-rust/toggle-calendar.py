#!/usr/bin/env python

from i3ipc import Connection
import re

conn = Connection()
es = conn.get_tree().find_classed("Evolution")

killed = False
for e in es:
    if re.findall("on", e.floating) and re.findall("(K|C)alend(e|a)r – Evolution", e.window_title):
        e.command('kill')
        killed = True

if not killed:
    conn.command('exec "evolution -c calendar"')
