# Dotfiles

## To install
- dunst
- i3-gaps
- i3status-rust
- rofi
- wpgtk

Optional:
- goes16-background
- himawaripy

<details>
  <summary>Package list with details</summary>

Package name            | Repo | Package description                                                                           | Needed for
------------------------|------|-----------------------------------------------------------------------------------------------|-----------------------------------------------------------------------
arandr                  | main | Provide a simple visual front end for XRandR 1.2.                                             | to set monitor layout with GUI
autorandr               | main | Auto-detect connected display hardware and load appropiate X11 setup using xrandr             | to set monitor layout automatically e.g. after reboot
awesome-terminal-fonts  | main | fonts/icons for powerlines                                                                    | powerline font for i3status-rust
compton                 | main | X compositor that may fix tearing issues                                                      | transparency and smooth transitions
dunst                   | main | Customizable and lightweight notification-daemon                                              | notifications
evolution               | main | Manage your email, contacts and schedule                                                      | autostart
feh                     | main | Fast and light imlib2-based image viewer                                                      | to set wallpaper
firefox                 | main | Standalone web browser from mozilla.org                                                       | autostart
gajim                   | main | Full featured and easy to use XMPP (Jabber) client                                            | autostart
guake                   | main | Drop-down terminal for GNOME                                                                  | autostart
i3-gaps                 | main | A fork of i3wm tiling window manager with more features, including gaps                       | my window manager
kdeconnect              | main | Adds communication between KDE and your smartphone                                            | autostart
light-locker            | main | A simple session locker for LightDM                                                           | screen locker
lxappearance            | main | Feature-rich GTK+ theme switcher of the LXDE Desktop                                          | to set GTK theme  and icon-set
lxsession               | main | Lightweight X11 session manager                                                               | needed for programms like e.g. gparted
network-manager-applet  | main | Applet for managing network connections                                                       | to choose network connection
noto-fonts-emoji        | main | Google Noto emoji fonts                                                                       | emojis :P
pamixer                 | main | Pulseaudio command-line mixer like amixer                                                     | make sound control keys working
playerctl               | main | mpris media player controller and lib for spotify, vlc, audacious, bmp, xmms2, and others.    | make music control keys working
powerline-fonts         | main | patched fonts for powerline                                                                   | more powerline fonts
python-i3-py            | main | tools for i3 users and developers                                                             | for scripts
redshift                | main | Adjusts the color temperature of your screen according to your surroundings.                  | night mode
rofi                    | main | A window switcher, application launcher and dmenu replacement                                 | launcher, to set theme, to exit i3, for searching the web, ...
rxvt-unicode            | main | Unicode enabled rxvt-clone terminal emulator (urxvt)                                          | very customizable terminal emulator
seahorse                | main | GNOME application for managing PGP keys.                                                      | store WiFi and other passwords, includes gnome-keyring as dependency
terminus-font           | main | Monospace bitmap font (for X11 and console)                                                   | another font
ttf-dejavu              | main | Font family based on the Bitstream Vera Fonts with a wider range of characters                | main font
xsettingsd              | main | Provides settings to X11 applications via the XSETTINGS specification                         | for wpgtk to live reload GTK+ theme
dino                         | AUR | Modern XMPP (Jabber) chat client written in GTK+/Vala                                                                                                                | autostart
gnome-terminal-transparency  | AUR | The GNOME Terminal Emulator, with background transparency                                                                                                            | terminal emulator
i3status-rust-git            | AUR | Very resourcefriendly and feature-rich replacement for i3status to use with bar programs (like i3bar and swaybar), written in pure Rust                              | status bar
nerd-fonts-complete          | AUR | Iconic font aggregator, collection, and patcher. 40+ patched fonts, over 3,600 glyph/icons, includes popular collections such as Font Awesome & fonts such as Hack   | more fonts
rofi-surfraw-git             | AUR | Universal tool to search the internet                                                                                                                                | web search with rofi
rofimoji-git                 | AUR | A simple emoji picker for rofi                                                                                                                                       | emoji picker
spotify                      | AUR | A proprietary music streaming service                                                                                                                                | autostart
wpgtk-git                    | AUR | A gui wallpaper chooser that changes your Openbox theme, GTK theme and Tint2 theme                                                                                   | to generate and set themes based on wallpapers and to generate the configs from the templates
xuserrun-dbus-git            | AUR | Run commands as the currently-active X11 user while also using his dbus-session                                                                                      | run cronjob command as X11 user

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
i3status-rust-git            
nerd-fonts-complete          
rofi-surfraw-git             
rofimoji-git                 
spotify                      
wpgtk-git                    
xuserrun-dbus-git            
`  
2. If you want some fancy wallpaper images from the earth in almost realtime then also install `goes16-background-git` and `himawaripy-git`
3. Install dotfiles like descriped further down.
4. Set monitor layout with arandr. If you you want to save multiple different monitor setups have a look at autorandr. With `$mod+m` there is a script to set some basic layouts.
5. Run `wpg-install.sh -ig` and then go to your wallpaper folder and generate colorscheme with `wpg -a *` or alternatively do it over the gui with `wpg`.
6. Set GTK theme to `FlatColor` and icon theme to `FlattrColor`. E.g using `lxappearance`.
7. Set colorscheme with `wpg -s [TAB]`. This also generates all the config files from the templates in `.config/wpg/templates`. So make sure no error message appears and the config files get generated.
8. Run `systemctl --user enable --now dunst.service` to enable notifications.
9. Add the following line to cron with `EDITOR=vim crontab -e` and make sure cron service is running: `sudo systemctl enable --now cronie.service`.
```
00  *   *   *   *  xuserrun $HOME/.config/wpg/scripted_themes/cron.sh >> $HOME/.config/wpg/scripted_themes/cron.log 2>&1
```

## Starting from scratch 
```
git init --bare $HOME/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles config --local status.showUntrackedFiles no
echo "alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.zshrc
```

### Add files
```
dotfiles status
dotfiles add .vimrc
dotfiles commit -m "Add vimrc"
dotfiles add .bashrc
dotfiles commit -m "Add bashrc"
```

### Add remote repo
```
dotfiles remote add gitlab git@gitlab.com:marzzzello/dotfiles.git 
dotfiles remote add github git@github.com:marzzzello/dotfiles.git
dotfiles push -u origin master
```

## Install dotfiles onto a new system
```
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
git clone --recursive --bare git@gitlab.com:marzzzello/dotfiles.git $HOME/.dotfiles


git clone --recursive --separate-git-dir=$HOME/.dotfiles git@gitlab.com:marzzzello/dotfiles.git $HOME/dotfiles-tmp
cp ~/dotfiles-tmp/.gitmodules ~  # If you use Git submodules
rm -r ~/dotfiles-tmp/
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

### setup script
```
git clone --recursive  --bare git@gitlab.com:marzzzello/dotfiles.git $HOME/.dotfiles
function dotfiles {
   git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
mkdir -p .dotfiles-backup
dotfiles checkout
if [ $? = 0 ]; then
  echo "Checked out dotfiles.";
  else
    echo "Backing up pre-existing dot files.";
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} dirname .dotfiles-backup/{} | xargs -I{} mkdir -p {}
	dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
fi;
dotfiles checkout
dotfiles config status.showUntrackedFiles no
```
