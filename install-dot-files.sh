#!/bin/bash
# filename: install-dot-files.sh
# author: lukas42singer (at) gmail <dot> com
# description: generates symbolic links to the dotfiles in this folder
#              i need this folder for my 'my-dot-files' git repository.
#
# this file is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#

dir=~/my-dot-files              # my-dot-files directory
old=~/.my-dot-files_OLD         # backup directory
# list of files/folders to link in the home dir
files="vimrc muttrc vimcheatsheet bashrc"

echo "creating backup directory ($old) ..."
mkdir -p $old
echo "... done"

echo "change into 'my-dot-files' directory ..."
cd $dir
echo "... done"

for file in $files; do
  echo "move ~/.$file to $old ..."
  mv ~/.$file  $old/
  echo "... done"
  echo "create symlink to $file in home directory"
  ln -s $dir/$file  ~/.$file
done


