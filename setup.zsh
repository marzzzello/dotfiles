#!/usr/bin/env zsh
cd "$HOME" || exit
git clone --recursive --jobs 8 --bare https://gitlab.com/marzzzello/dotfiles.git "$HOME/.git"

# backup
BACKUP_DIR=".dotfiles-backup"
mkdir -p "$BACKUP_DIR"
mv .antigen "$BACKUP_DIR" &>/dev/null
if git --work-tree="$HOME" checkout &>/dev/null; then
  echo "Checked out dotfiles."
else
  git --work-tree="$HOME" checkout 2>&1 | awk -F '\t' '/\t/ {print $2}' >"$BACKUP_DIR/BACKUP_FILE_LIST"
  echo "Backing up $(wc -l <$BACKUP_DIR/BACKUP_FILE_LIST) pre-existing dot files."
  xargs -I{} dirname $BACKUP_DIR/{} <"$BACKUP_DIR/BACKUP_FILE_LIST" | xargs -I{} mkdir -p {}
  xargs -I{} mv {} $BACKUP_DIR/{} <"$BACKUP_DIR/BACKUP_FILE_LIST"
fi

git --work-tree="$HOME" config core.bare false
git checkout
git submodule update --init --recursive --jobs 8

rm "$HOME/.git/config"
git config include.path ../.gitconfig.local

if command -v wpg-install.sh >/dev/null; then
  echo "Installing wpgtk themes and icons"
  wpg-install.sh -gi
else
  echo "ERROR: command wpg-install.sh not found"
  echo "Please install wpgtk and run the command wpg-install -gi"
fi

wallpaper="wallpaper-forest-4k.jpg"
echo "Downloading wallpaper to $wallpaper"
curl -L https://upload.wikimedia.org/wikipedia/commons/6/69/7-78049_small-memory-8k-wallpaper-forest-minimalist-wallpaper-4k.jpg --output "$HOME/$wallpaper"
if command -v wpg >/dev/null; then
  echo "Add and set colorscheme"
  wpg -a $wallpaper
  wpg -A $wallpaper
  wpg -s $wallpaper
else
  echo "Run wpg to generate the config from the template files"
fi

echo "Run lxappearance to set the GTK and icon theme"
