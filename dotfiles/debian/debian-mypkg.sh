#!/bin/bash

#if [ `id -u` != "0" ]; then echo "Please run as root" ; exit 1; fi

pkgini_path='pkg-debian.db'

function usage
{
cat << EOF
usage: $0 

Install Debian's packages

EOF
}

getFlavour() {
    awk '/\[/ {count++ ; print count $0}' < $1
}

getPackagesList(){

    choice="$2"
    pkglist=$(awk -v var=$choice '{if(NR == var+1 ) { print $0 }} '  RS= < $1 | tail +2 | xargs ) 
 
}

installPackages(){
    apt-get install --dry-run $pkglist
}


getFlavour $pkgini_path
read -p "->" choice
getPackagesList $pkgini_path $choice
installPackages
