#!/bin/sh

pkg_global='i3 tmux rxvt-unicode terminator mc ranger aspell-fr aspell-en sshfs qpdfview unrar ccze rsync unison unison-gtk apcalc arandr encfs taskwarrior rxvt-unicode roxterm terminator fdupes manpages-fr manpages-fr-dev manpages-fr-extra'
pkg_system='aptitude iftop alien rkhunter htop lshw bash-completion pv powerstat wicd-curses ftp apt-file lsscsi iotop'
pkg_devel='vim git tig gdb ddd pylint python-pip exuberant-ctags gcc g++ build-essential autoconf automake autotools-dev fakeroot libncurses5-dev ncurses-base pgadmin3 virtualenv cmake puppet-lint python-pylint-django'
pkg_debian='apt-listbugs apt-listchanges debhelper dh-make debmake devscripts lintian quilt checkinstall pbuilder'
pkg_elec='arduino oregano gspiceui'
pkg_internet='tor hexchat irssi w3m nmap chromium icedove ncftp'
pkg_sound='alsa-base alsa-utils alsa-oss alsamixergui libasound2 libasound2-doc pulseaudio pavucontrol'
pkg_desktop='xinit iceweasel pcmanfm gpicview systemd-gui libimage-exiftool-perl gxkb'
pkg_multimedia='vlc cdparanoia ripperx flac libdvdread4 darktable mesa-utils mencoder fswebcam imagemagick'
pkg_recording='jackd qjackctl multimedia-firewire ardour calf-plugins hydrogen hydrogen-drumkits hydrogen-drumkits-effects zynaddsubfx x42-plugins qsynth zam-plugins vlc-plugin-jack jack-keyboard'
pkg_nonfree='flashplugin-nonfree'
pkg_office='krb5-config krb5-doc krb5-user aspell-fr aspell-en hunspell-en-us hunspell-fr cups cups-client qrencode'
pkg_security='keepassx pass kpcli crunch wireshark tcpdump pwgen'
pkg_goodies='fonts-inconsolata'
pkg_network='whois dnsutils snmp snmp-mibs-downloader'

apt-get install $pkg_global $pkg_system $pkg_devel $pkg_debian $pkg_elec $pkg_internet $pkg_multimedia $pkg_nonfree $pkg_security $pkg_goodies $pkg_network
