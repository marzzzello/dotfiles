#!/usr/bin/env zsh
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
