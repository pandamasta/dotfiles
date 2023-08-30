#!/bin/sh

IP=$(curl -s ifconfig.me)

echo "network.local_address.set = $IP" >> ~/.rtorrent.rc
