#!/usr/bin/env python

import i3ipc
import re

i3 = i3ipc.Connection()
tree = i3.get_tree()

es = i3.get_tree().find_classed("Evolution")

killed = False
for e in es:
	if( re.findall("on", e.floating) and re.findall("(K|C)alend(e|a)r – Evolution", e.window_title) ):
		e.command('kill')
		killed = True

if(killed==False):
	i3.command('exec "evolution -c calendar"')
