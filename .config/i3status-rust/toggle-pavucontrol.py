#!/usr/bin/env python

import i3ipc
import re

i3 = i3ipc.Connection()
tree = i3.get_tree()

ps = i3.get_tree().find_classed("Pavucontrol")

killed = False
for p in ps:
	if( re.findall("on", p.floating) ):
		p.command('kill')
		killed = True

if(killed==False):
	i3.command('exec pavucontrol')
