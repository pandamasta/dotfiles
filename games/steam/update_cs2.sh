#!/bin/bash

# Source the .env file
ENV_FILE="/srv/steamcmd/scripts/env/cs2/cs2.env"
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
else
    echo "Error: Environment file $ENV_FILE not found" >&2
    exit 1
fi

# Check if STEAM_LOGIN and STEAM_PASSWORD are set
if [ -z "$STEAM_LOGIN" ] || [ -z "$STEAM_PASSWORD" ]; then
    echo "Error: STEAM_LOGIN or STEAM_PASSWORD not set in $ENV_FILE" >&2
    exit 1
fi

# Stop the CS2 server, update, and restart
sudo systemctl stop cs2-server
/usr/games/steamcmd \
    +force_install_dir /srv/steamcmd/servers/cs2_server \
    +login "$STEAM_LOGIN" "$STEAM_PASSWORD" \
    +app_update 730 validate \
    +quit
if [ $? -ne 0 ]; then
    echo "Error: SteamCMD update failed" >&2
    # restart or handle rollback
    sudo systemctl start cs2-server
    exit 1
fi
sudo systemctl start cs2-server
