#!/bin/bash
cd ~/rtorrent_build/rtorrent
make clean
export CFLAGS="-g -I$HOME/rtorrent_build/libtorrent_install/include"
export LDFLAGS="-L$HOME/rtorrent_build/libtorrent_install/lib"
export PKG_CONFIG_PATH=$HOME/rtorrent_build/libtorrent_install/lib/pkgconfig:$PKG_CONFIG_PATH
./configure --prefix=$HOME/rtorrent_build/rtorrent_install --with-xmlrpc-c
make
make install
