# Dotfiles

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
git clone --bare git@gitlab.com:marzzzello/dotfiles.git $HOME/.dotfiles


git clone --separate-git-dir=$HOME/.dotfiles git@gitlab.com:marzzzello/dotfiles.git $HOME/dotfiles-tmp
cp ~/dotfiles-tmp/.gitmodules ~  # If you use Git submodules
rm -r ~/dotfiles-tmp/
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

### setup script
```
git clone --bare git@gitlab.com:marzzzello/dotfiles.git $HOME/.dotfiles
function dotfiles {
   git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
mkdir -p .dotfiles-backup
dotfiles checkout
if [ $? = 0 ]; then
  echo "Checked out dotfiles.";
  else
    echo "Backing up pre-existing dot files.";
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
fi;
dotfiles checkout
dotfiles config status.showUntrackedFiles no
```