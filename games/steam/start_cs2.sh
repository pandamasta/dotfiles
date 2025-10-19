#!/bin/bash
ENV_FILE="/srv/steamcmd/scripts/env/cs2/cs2.env"
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
else
    echo "Error: Environment file $ENV_FILE not found" >&2
    exit 1
fi

if [ ! -x "/srv/steamcmd/servers/cs2_server/game/bin/linuxsteamrt64/cs2" ]; then
    echo "Error: CS2 binary not found or not executable" >&2
    exit 1
fi

# Set LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/srv/steamcmd/servers/cs2_server/game/bin/linuxsteamrt64:/srv/steamcmd/servers/cs2_server/game/bin/linuxsteamrt64

# Run the CS2 server
exec /srv/steamcmd/servers/cs2_server/game/bin/linuxsteamrt64/cs2 \
    -dedicated \
    -ip 0.0.0.0 \
    -port 27015 \
    -maxplayers 16 \
    -serverlogging \
    +sv_setsteamaccount "${STEAM_TOKEN}" \
    +hostname "${SERVER_HOSTNAME}" \
    +rcon_password "${RCON_PASS}" \
    +game_mode 0 \
    +game_type 1 \
    +map de_dust2
