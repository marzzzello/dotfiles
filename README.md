# Dotfiles

![](https://forthebadge.com/images/badges/built-with-love.svg)
![](https://forthebadge.com/images/badges/Built-By-hipsters.svg)
![](https://forthebadge.com/images/badges/contains-Cat-GIFs.svg)
![](https://forthebadge.com/images/badges/fuck-it-ship-it.svg)

[![Repo on GitLab](https://img.shields.io/badge/repo-GitLab-fc6d26.svg?style=for-the-badge&logo=gitlab)](https://gitlab.com/marzzzello/dotfiles)
[![Repo on GitHub](https://img.shields.io/badge/repo-GitHub-4078c0.svg?style=for-the-badge&logo=github)](https://github.com/marzzzello/dotfiles)
[![GitHub](https://img.shields.io/github/license/marzzzello/dotfiles.svg?style=for-the-badge)]( 	LICENSE.md)
[![GitHub](https://img.shields.io/github/commit-activity/w/marzzzello/dotfiles.svg?style=for-the-badge)]()

## To install

<details>
  <summary><b>Package list with details</b></summary>

Package name            | Repo | Needed for                                                              | Package description
------------------------|------|-------------------------------------------------------------------------|-----------------------------------------------------------------------
arandr                  | main | to set monitor layout with GUI                                          | Provide a simple visual front end for XRandR 1.2.
autorandr               | main | to set monitor layout automatically e.g. after reboot                   | Auto-detect connected display hardware and load appropiate X11 setup using xrandr
awesome-terminal-fonts  | main | powerline font for i3status-rust                                        | fonts/icons for powerlines
compton                 | main | transparency and smooth transitions                                     | X compositor that may fix tearing issues
dunst                   | main | notifications                                                           | Customizable and lightweight notification-daemon
evolution               | main | autostart                                                               | Manage your email, contacts and schedule
feh                     | main | to set wallpaper                                                        | Fast and light imlib2-based image viewer
firefox                 | main | autostart                                                               | Standalone web browser from mozilla.org
gajim                   | main | autostart                                                               | Full featured and easy to use XMPP (Jabber) client
guake                   | main | autostart                                                               | Drop-down terminal for GNOME
i3-gaps                 | main | my window manager                                                       | A fork of i3wm tiling window manager with more features, including gaps
kdeconnect              | main | autostart                                                               | Adds communication between KDE and your smartphone
light-locker            | main | screen locker                                                           | A simple session locker for LightDM
lxappearance            | main | to set GTK theme  and icon-set                                          | Feature-rich GTK+ theme switcher of the LXDE Desktop
lxsession               | main | needed for programms like e.g. gparted                                  | Lightweight X11 session manager
network-manager-applet  | main | to choose network connection                                            | Applet for managing network connections
noto-fonts-emoji        | main | emojis :P                                                               | Google Noto emoji fonts
pamixer                 | main | make sound control keys working                                         | Pulseaudio command-line mixer like amixer
pavucontrol             | main | Sound settings and mixer                                                | PulseAudio Volume Control
playerctl               | main | make music control keys working                                         | mpris media player controller and lib for spotify, vlc, audacious, bmp, xmms2, and others.
powerline-fonts         | main | more powerline fonts                                                    | patched fonts for powerline
python-i3-py            | main | for scripts                                                             | tools for i3 users and developers
redshift                | main | night mode                                                              | Adjusts the color temperature of your screen according to your surroundings.
rofi                    | main | launcher, to set theme, to exit i3, for searching the web, ...          | A window switcher, application launcher and dmenu replacement
rxvt-unicode            | main | very customizable terminal emulator                                     | Unicode enabled rxvt-clone terminal emulator (urxvt)
seahorse                | main | store WiFi and other passwords, includes gnome-keyring as dependency    | GNOME application for managing PGP keys.
terminus-font           | main | another font                                                            | Monospace bitmap font (for X11 and console)
ttf-dejavu              | main | main font                                                               | Font family based on the Bitstream Vera Fonts with a wider range of characters
xsettingsd              | main | for wpgtk to live reload GTK+ theme                                     | Provides settings to X11 applications via the XSETTINGS specification
dino                         | AUR | autostart                                                           | Modern XMPP (Jabber) chat client written in GTK+/Vala
gnome-terminal-transparency  | AUR | terminal emulator                                                   | The GNOME Terminal Emulator, with background transparency
goes16-background-git        | AUR | live earth wallpaper                                                | Put near-realtime picture of Earth as your desktop background.
himawaripy-git               | AUR | live earth wallpaper (different satellite)                          | Put near-realtime picture of Earth as your desktop background.
i3status-rust-git            | AUR | status bar                                                          | Very resourcefriendly and feature-rich replacement for i3status to use with bar programs, written in pure Rust
nerd-fonts-complete          | AUR | more fonts                                                          | Iconic font aggregator, collection, and patcher. 40+ patched fonts, over 3,600 glyph/icons
rofi-surfraw-git             | AUR | web search with rofi                                                | Universal tool to search the internet
rofimoji-git                 | AUR | emoji picker                                                        | A simple emoji picker for rofi
shadowfox-updater            | AUR | dark firefox theme                                                  | An auto-updater for ShadowFox
spotify                      | AUR | autostart                                                           | A proprietary music streaming service
wpgtk-git                    | AUR | generate and set themes based on wallpapers and to generate the configs from the templates | A gui wallpaper chooser that changes your Openbox theme, GTK theme and Tint2 theme
xuserrun-dbus-git            | AUR | run cronjob command as X11 user                                     | Run commands as the currently-active X11 user while also using his dbus-session

</details>

1. Install all: `$aurhelper
arandr
autorandr
awesome-terminal-fonts
compton
dunst
evolution
feh
firefox
gajim
guake
i3-gaps
kdeconnect
light-locker
lxappearance
lxsession
network-manager-applet
noto-fonts-emoji
pamixer
pavucontrol
playerctl
powerline-fonts
python-i3-py
redshift
rofi
rxvt-unicode
seahorse
terminus-font
ttf-dejavu
xsettingsd
dino
gnome-terminal-transparency
goes16-background-git
himawaripy-git
i3status-rust-git
nerd-fonts-complete
rofi-surfraw-git
rofimoji-git
shadowfox-updater
spotify
wpgtk-git
xuserrun-dbus-git
`
2. If you want some fancy wallpaper images from the earth in almost realtime then also install `goes16-background-git` and `himawaripy-git`
3. Install dotfiles like descriped further down.
4. Set monitor layout with arandr. If you you want to save multiple different monitor setups have a look at autorandr. With `$mod+m` there is a script to set some basic layouts.
5. Run `wpg-install.sh -ig` and then go to your wallpaper folder and generate colorscheme with `wpg -a *` or alternatively do it over the gui with `wpg`.
6. Set GTK theme to `FlatColor` and icon theme to `FlattrColor`. E.g using `lxappearance`.
7. Set colorscheme with `wpg -s [TAB]`. This also generates all the config files from the templates in `.config/wpg/templates`. So make sure that no error messages appear and that the config files are generated.
8. Run `systemctl --user enable --now dunst.service` to enable notifications.
9. Add the following line to cron with `EDITOR=vim crontab -e` and make sure cron service is running: `sudo systemctl enable --now cronie.service`.
```
00  *   *   *   *  xuserrun $HOME/.config/wpg/scripted_themes/cron.sh >> $HOME/.config/wpg/scripted_themes/cron.log 2>&1
```
10. Run the Firefox profile manager `firefox -ProfileManager -no-remote` and add a profile with the name `user.js` and set the path to `~/.mozilla/firefox/user.js`. Install your addons and then run ShadowFox (also themes some addons) with this command:  
`shadowfox-updater -generate-uuids -profile-name user.js -set-dark-theme`


## Install dotfiles onto a new system
```bash
git clone --recursive --bare https://gitlab.com/marzzzello/dotfiles.git $HOME/.dotfiles
function dotfiles {
   git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
mkdir -p .dotfiles-backup
dotfiles checkout
if [ $? = 0 ]; then
  echo "Checked out dotfiles.";
else
  echo "Backing up pre-existing dot files.";
  dotfiles checkout 2>&1 | awk -F '\t' '/\t/ {print $2}' | xargs -I{} dirname .dotfiles-backup/{} | xargs -I{} mkdir -p {}
  dotfiles checkout 2>&1 | awk -F '\t' '/\t/ {print $2}' | xargs -I{} mv {} .dotfiles-backup/{}
fi;
dotfiles checkout
dotfiles submodule update --init
dotfiles config status.showUntrackedFiles no
dotfiles config filter.head.clean 'head -n 2'
```

As single command: 
```
curl 'https://gitlab.com/marzzzello/dotfiles/raw/master/setup.zsh' | zsh 
```

or even shorter
```
curl -L 'https://git.io/marzzzello' | zsh
```

## Starting from scratch
I started with [this tutorial](https://de.atlassian.com/git/tutorials/dotfiles) on how to store your dotfiles