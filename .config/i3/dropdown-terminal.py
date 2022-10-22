#!/usr/bin/env python
from i3ipc import Connection

conn = Connection()
terms = conn.get_tree().find_instanced('kitty')
for term in terms:
    if term.parent.scratchpad_state != 'none':
        conn.command('scratchpad show')
        exit(0)

conn.command('exec --no-startup-id "kitty --title terminal-dropdown"')
