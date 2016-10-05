#!/bin/sh
#author: Aurelien Martin 
#description: Deploy the dotfiles to the home directory of the current user depending of the operating system
#Tested on Linux
#TODO: All tests are missing!. Test on other OS flavour
#      Fix if a config file in a repo contain a .

OS=`uname`
ROOT_OF_REPO=$PWD

globalvar(){
    echo "OS: $OS"
    echo "User: $USER"
    echo "Home: $HOME"
    echo "Repository Path $ROOT_OF_REPO" 
}

getFileToLink(){
    find ./dotfiles/common -maxdepth 1  -type f | cut -sd / -f 3-
    find ./dotfiles/$1 -maxdepth 1 -type f | cut -sd / -f 3-
}

getDirectoryToLink(){
    find ./dotfiles/common/ -mindepth 1 -maxdepth 1  -type d | cut -sd / -f 3-
    find ./dotfiles/$1 -mindepth 1 -maxdepth 1  -type d | cut -sd / -f 3-
}

CreateLink(){

  for file in $@; do
      #Get the basename of the file
      filename=`echo $file | cut -sd / -f 2-`
      #If the config file exist, backup and create a symblink to the repo
      if [ -f ~/$filename ] || [ -d ~/$filename ]; then
          #If the config file is a symblink do nothing (for the moment)
          if [ -L ~/$filename ] ; then
          target=`readlink -f $filename` 
          echo "$filename is a symblink -> $target"
      else
         #Backup the existing file and create the symb link
         echo "$filename is a regular file in $HOME"
	 echo "Move ~/$filename to ~/$filename.orig"
         mv ~/$filename ~/$filename.orig
         echo "Symblink $ROOT_OF_REPO/dotfiles/$filename to ~/$filename"
         ln -s $ROOT_OF_REPO/dotfiles/$filename ~/$filename
      fi
  else
      echo "$filename doesn't exist in $HOME. Symblink $ROOT_OF_REPO/dotfiles/$file to ~/$filename"
      ln -s $ROOT_OF_REPO/dotfiles/$file ~/$filename
   fi
done

}

FileToLink=$(getFileToLink $OS)
DirectoryToLink=$(getDirectoryToLink $OS)

CreateLink $DirectoryToLink $FileToLink
