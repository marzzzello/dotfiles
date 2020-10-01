# Dotfiles

![](https://forthebadge.com/images/badges/built-with-love.svg)
![](https://forthebadge.com/images/badges/fuck-it-ship-it.svg)
![](https://forthebadge.com/images/badges/contains-Cat-GIFs.svg)

[![Repo on GitLab](https://img.shields.io/badge/repo-GitLab-fc6d26.svg?style=for-the-badge&logo=gitlab)](https://gitlab.com/marzzzello/dotfiles)
[![Repo on GitHub](https://img.shields.io/badge/repo-GitHub-4078c0.svg?style=for-the-badge&logo=github)](https://github.com/marzzzello/dotfiles)
[![license](https://img.shields.io/github/license/marzzzello/dotfiles.svg?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjxwYXRoIHN0eWxlPSJmaWxsOiNkZGRkZGQiIGQ9Ik03IDRjLS44MyAwLTEuNS0uNjctMS41LTEuNVM2LjE3IDEgNyAxczEuNS42NyAxLjUgMS41UzcuODMgNCA3IDR6bTcgNmMwIDEuMTEtLjg5IDItMiAyaC0xYy0xLjExIDAtMi0uODktMi0ybDItNGgtMWMtLjU1IDAtMS0uNDUtMS0xSDh2OGMuNDIgMCAxIC40NSAxIDFoMWMuNDIgMCAxIC40NSAxIDFIM2MwLS41NS41OC0xIDEtMWgxYzAtLjU1LjU4LTEgMS0xaC4wM0w2IDVINWMwIC41NS0uNDUgMS0xIDFIM2wyIDRjMCAxLjExLS44OSAyLTIgMkgyYy0xLjExIDAtMi0uODktMi0ybDItNEgxVjVoM2MwLS41NS40NS0xIDEtMWg0Yy41NSAwIDEgLjQ1IDEgMWgzdjFoLTFsMiA0ek0yLjUgN0wxIDEwaDNMMi41IDd6TTEzIDEwbC0xLjUtMy0xLjUgM2gzeiIvPjwvc3ZnPgo=)](LICENSE.md)
[![commit-activity](https://img.shields.io/github/commit-activity/m/marzzzello/dotfiles.svg?style=for-the-badge)](https://img.shields.io/github/commit-activity/m/marzzzello/dotfiles.svg?style=for-the-badge)
[![Mastodon Follow](https://img.shields.io/mastodon/follow/103207?domain=https%3A%2F%2Fsocial.tchncs.de&logo=mastodon&style=for-the-badge)](https://social.tchncs.de/@marzzzello)

## To install

<details>
  <summary><b>Package list with details</b></summary>

| Package name                | Repo | Needed for                                                            | Package description                                                                                            |
| --------------------------- | ---- | --------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| arandr                      | main | to set monitor layout with GUI                                        | Provide a simple visual front end for XRandR 1.2.                                                              |
| autorandr                   | main | to set monitor layout automatically e.g. after reboot                 | Auto-detect connected display hardware and load appropiate X11 setup using xrandr                              |
| awesome-terminal-fonts      | main | powerline font for i3status-rust                                      | fonts/icons for powerlines                                                                                     |
| dunst                       | main | notifications                                                         | Customizable and lightweight notification-daemon                                                               |
| evolution                   | main | autostart                                                             | Manage your email, contacts and schedule                                                                       |
| feh                         | main | to set wallpaper                                                      | Fast and light imlib2-based image viewer                                                                       |
| firefox                     | main | autostart                                                             | Standalone web browser from mozilla.org                                                                        |
| gammastep                   | main | night mode                                                            | Adjust the color temperature of your screen according to your surroundings.                                    |
| guake                       | main | autostart                                                             | Drop-down terminal for GNOME                                                                                   |
| i3-gaps                     | main | my window manager                                                     | A fork of i3wm tiling window manager with more features, including gaps                                        |
| kdeconnect                  | main | autostart                                                             | Adds communication between KDE and your smartphone                                                             |
| keepassxc                   | main | password manager, ssh-agent (automatic unlock with pam script)        | Cross-platform community-driven port of Keepass password manager                                               |
| light-locker                | main | screen locker                                                         | A simple session locker for LightDM                                                                            |
| lxappearance                | main | to set GTK theme and icon-set                                         | Feature-rich GTK+ theme switcher of the LXDE Desktop                                                           |
| lxsession-gtk3              | main | needed for programms like e.g. gparted                                | Lightweight X11 session manager (GTK+ 3 version)                                                               |
| neofetch                    | main | show system information                                               | A CLI system information tool written in BASH that supports displaying images.                                 |
| network-manager-applet      | main | to choose network connection                                          | Applet for managing network connections                                                                        |
| noto-fonts-emoji            | main | emojis 😍😜🧑‍💻                                                      | Google Noto emoji fonts                                                                                        |
| pamixer                     | main | make sound control keys working                                       | Pulseaudio command-line mixer like amixer                                                                      |
| pavucontrol                 | main | Sound settings and mixer                                              | PulseAudio Volume Contro                                                                                       |
| picom                       | main | transparency and smooth transitions                                   | X compositor that may fix tearing issues                                                                       |
| playerctl                   | main | make music control keys working                                       | mpris media player controller and lib for spotify, vlc, audacious, bmp, xmms2, and others.                     |
| powerline-fonts             | main | more powerline fonts                                                  | patched fonts for powerline                                                                                    |
| python-i3-py                | main | for scripts                                                           | tools for i3 users and developers                                                                              |
| qt5-tools                   | main | qdbus for w8unlock.zsh script                                         | A cross-platform application and UI framework (Development Tools, QtHelp)                                      |
| rofi                        | main | launcher, to set theme, to exit i3, for searching the web, ...        | A window switcher, application launcher and dmenu replacement                                                  |
| terminus-font               | main | another font                                                          | Monospace bitmap font (for X11 and console)                                                                    |
| ttf-dejavu                  | main | main font                                                             | Font family based on the Bitstream Vera Fonts with a wider range of characters                                 |
| xsettingsd                  | main | for wpgtk to live reload GTK+ theme                                   | Provides settings to X11 applications via the XSETTINGS specification                                          |
| dino                        | AUR  | autostart                                                             | Modern XMPP (Jabber) chat client written in GTK+/Vala                                                          |
| gnome-terminal-transparency | AUR  | terminal emulator                                                     | The GNOME Terminal Emulator, with background transparency                                                      |
| goes16-background-git       | AUR  | live earth wallpaper                                                  | Put near-realtime picture of Earth as your desktop background.                                                 |
| himawaripy-git              | AUR  | live earth wallpaper (different satellite)                            | Put near-realtime picture of Earth as your desktop background.                                                 |
| i3status-rust-git           | AUR  | status bar                                                            | Very resourcefriendly and feature-rich replacement for i3status to use with bar programs, written in pure Rust |
| nerd-fonts-complete         | AUR  | more fonts                                                            | Iconic font aggregator, collection, and patcher. 40+ patched fonts, over 3,600 glyph/icons                     |
| rofi-surfraw-git            | AUR  | web search with rofi                                                  | Universal tool to search the internet                                                                          |
| rofimoji-git                | AUR  | emoji picker                                                          | A simple emoji picker for rofi                                                                                 |
| shadowfox-updater           | AUR  | dark firefox theme                                                    | An auto-updater for ShadowFox                                                                                  |
| spotify                     | AUR  | autostart                                                             | A proprietary music streaming service                                                                          |
| wpgtk-git                   | AUR  | generate and set themes and configs based on wallpapers and templates | A gui wallpaper chooser that changes your Openbox theme, GTK theme and Tint2 theme                             |
| xuserrun-dbus-git           | AUR  | run cronjob command as X11 user                                       | Run commands as the currently-active X11 user while also using his dbus-session                                |
| yay                         | AUR  | AUR helper                                                            | Yet another yogurt. Pacman wrapper and AUR helper written in go.                                               |

</details>

1. Install all: `$aurhelper arandr autorandr awesome-terminal-fonts dunst evolution feh firefox gammastep guake i3-gaps kdeconnect light-locker lxappearance lxsession-gtk3 neofetch network-manager-applet noto-fonts-emoji pamixer pavucontrol picom playerctl powerline-fonts python-i3-py rofi rxvt-unicode seahorse terminus-font ttf-dejavu xsettingsd dino gnome-terminal-transparency goes16-background-git himawaripy-git i3status-rust-git nerd-fonts-complete rofi-surfraw-git rofimoji-git shadowfox-updater spotify wpgtk-git xuserrun-dbus-git yay `
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

```sh
cd "${HOME}" || exit
git clone --recursive --jobs 8 --bare https://gitlab.com/marzzzello/dotfiles.git "${HOME}/.git"
alias dotfiles="git --work-tree=${HOME}"

# backup
mkdir -p .dotfiles-backup
if dotfiles checkout; then
  echo "Checked out dotfiles."
else
  echo "Backing up pre-existing dot files."
  dotfiles checkout 2>&1 | awk -F '\t' '/\t/ {print $2}' | xargs -I{} dirname .dotfiles-backup/{} | xargs -I{} mkdir -p {}
  dotfiles checkout 2>&1 | awk -F '\t' '/\t/ {print $2}' | xargs -I{} mv {} .dotfiles-backup/{}
fi

dotfiles config core.bare false
git checkout
git submodule update --init --recursive --jobs 8

rm "${HOME}/.git/config"
git config include.path ../.gitconfig.local

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

## License

This project is licensed under the [MIT License](LICENSE.md) except for the mpv scripts [[1]](.config/mpv/scripts/mpv_thumbnail_script_client_osc.lua)[[2]](.config/mpv/scripts/mpv_thumbnail_script_server.lua).
