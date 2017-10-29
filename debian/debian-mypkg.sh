#!/bin/bash

if [ `id -u` != "0" ]; then echo "Please run as root" ; exit 1; fi

pkgini_path='pkg-debian.db'

#If no file as input select pkgini_path

function usage()
{
cat << EOF
usage: $0 

EOF
}


showMenu(){
cat << EOF
**** Install Debian's packages based on profile ****

Select profile you want to install

EOF
getFlavour
}

getFlavour() {
    awk '/\[/ {count++ ; print count $0}' < $1
}

listToArgs(){

    choice="$2"
    pkglist=$(awk -v var=$choice '{if(NR == var+1 ) { print $0 }} '  RS= < $1 | tail +2 | xargs ) 
 
}

installPackages(){
	echo -e "This will install the following package"
	echo $pkglist
	echo -e "Are you sure you want to install them ? [y|n]"
	read choice
	echo "Press only Enter for dryrun"

	if [[ $choice == "y" ]]; then
		echo "Run apt ..."
    	apt-get install $pkglist
	else
		echo "Run apt in dry mode"
		apt-get install --dry-run $pkglist
	fi
}

showMenu
getFlavour $pkgini_path
read -p "->" choice
listToArgs $pkgini_path $choice
installPackages $pkglist
	

