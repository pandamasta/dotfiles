#!/bin/bash

# Check if script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root" >&2
    exit 1
fi

# Define sudoers file
SUDOERS_FILE="/etc/sudoers.d/steam-cs2"
SUDOERS_CONTENT="steam ALL=(ALL) NOPASSWD: /bin/systemctl start cs2-server, /bin/systemctl stop cs2-server"

# Create or overwrite sudoers file
echo "$SUDOERS_CONTENT" > "$SUDOERS_FILE"
if [ $? -ne 0 ]; then
    echo "Error: Failed to write to $SUDOERS_FILE" >&2
    exit 1
fi

# Set permissions (440, root:root)
chown root:root "$SUDOERS_FILE"
chmod 440 "$SUDOERS_FILE"
if [ $? -ne 0 ]; then
    echo "Error: Failed to set permissions on $SUDOERS_FILE" >&2
    exit 1
fi

# Verify sudoers file syntax
visudo -c -f "$SUDOERS_FILE"
if [ $? -ne 0 ]; then
    echo "Error: Invalid syntax in $SUDOERS_FILE" >&2
    exit 1
fi

# Test sudo configuration as steam user
echo "Testing sudo configuration for steam user..."
su - steam -c "sudo /bin/systemctl stop cs2-server && sudo /bin/systemctl start cs2-server" >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Success: sudo configuration for steam user is valid"
else
    echo "Error: sudo test failed for steam user" >&2
    exit 1
fi

echo "Bootstrap complete: $SUDOERS_FILE created and verified"
