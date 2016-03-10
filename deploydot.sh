#!/bin/sh
#author: Aurelien Martin 
#description: Deploy the dotfiles to the home directory of the current user depending of the operating system
#Tested on Linux
#TODO: All tests are missing!. Test on other OS flavour
#      Fix if a config file in a repo contain a .

OS=`uname`
ROOT_OF_REPO=$PWD

info(){
    echo "OS: $OS"
    echo "User: $USER"
    echo "Home: $HOME"
    echo "Repository Path $ROOT_OF_REPO" 
}

getDotFilesNamePerOSInRepo(){
    find ./dotfiles/common -maxdepth 2  -type f | cut -sd / -f 3-
    find ./dotfiles/$1 -maxdepth 2 -type f | cut -sd / -f 3-
}

DotFilesPerOSInRepo=$(getDotFilesNamePerOSInRepo $OS)

for i in $DotFilesPerOSInRepo; do
  #Get the basename of the file
  filename=`echo $i | cut -sd / -f 2-`
   #If the config file exist, backup and create a symblink to the repo
   if [ -f ~/\.$filename ] ; then
      #If the config file is a symblink do nothing (for the moment)
      if [ -L ~/\.$filename ] ; then
         echo "$filename is symblink do nothing"
      else
         echo ".$filename is a regular file in $HOME"
	 echo "Move ~/.$filename to ~/.$filename.orig"
         mv ~/.$filename ~/.$filename.orig
         echo "Symblink $ROOT_OF_REPO/dotfiles/$i to ~/.$filename"
         ln -s $ROOT_OF_REPO/dotfiles/$i ~/.$filename
      fi
   else
      echo ".$filename doesn't exist in $HOME. Symblink $ROOT_OF_REPO/dotfiles/$i to ~/.$filename"
      ln -s $ROOT_OF_REPO/dotfiles/$i ~/.$filename
   fi
done
