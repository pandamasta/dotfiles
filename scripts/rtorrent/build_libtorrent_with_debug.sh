# Rebuild libtorrent with debug symbols
cd ~/rtorrent_build/libtorrent
make clean
export CFLAGS="-g -I$HOME/rtorrent_build/libtorrent_install/include"
export CXXFLAGS="-g"
./configure --prefix=$HOME/rtorrent_build/libtorrent_install
make
make install
