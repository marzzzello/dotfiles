#!/usr/bin/env python

# This script starts a terminal and, mobes it to the top of the workspace with a width of 90%
# and remembers the height as percentage
# Works with multiple outputs with different resolution or scaling

from i3ipc import Connection

title = 'terminal-dropdown'
conn = Connection()

# check if dropdown terminal exists and toggle scratchpad, set height and width
terms = conn.get_tree().find_named(title)
for term in terms:
    if term.parent.name != '__i3_scratch':
        height_ppt = round(term.rect.height / term.parent.rect.height * 100)
        term.command(f'mark --replace "{height_ppt}"')
        print('set height_ppt to', height_ppt)
    else:
        try:
            height_ppt = term.marks[0]
        except IndexError:
            height_ppt = 30

        print('hidden, height_ppt:', height_ppt)
    cmd = '''
scratchpad show
[title = "{title}"] resize set width 100ppt height {height_ppt}ppt
[title = "{title}"] move position 0 0
[title = "{title}"] resize set width 90ppt height {height_ppt}ppt
'''.format(
        height_ppt=height_ppt, title=title
    )
    print(cmd)
    term.command(cmd)
    exit(0)

# open dropdown terminal, positioning etc is done in sway config
conn.command(f'exec --no-startup-id "kitty --title {title}"')
