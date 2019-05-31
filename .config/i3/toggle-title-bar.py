#!/usr/bin/env python
# This file will get overwritten by wpgtk because there is a template file under ~/.config/wpg/templates/

import i3

border = i3.filter(focused=True)[0]['border']

if border == "normal":
  i3.command("border pixel 5")
else:
  i3.command("border normal 5")
