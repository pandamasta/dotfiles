#!/bin/bash
# Author: Aurelien Martin - 2024-12-21

##############################################################################
# Step #0: Load config value
##############################################################################

# Configuration file path
CONFIG_FILE="./backup.conf"

# Check if the config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Configuration file $CONFIG_FILE not found."
    echo "Creating $CONFIG_FILE with default settings..."
    
    # Write default configuration to backup.conf
    cat <<EOL > "$CONFIG_FILE"
# Backup configuration
REMOTE_USER="backup"                  # Remote username
REMOTE_HOST="remote.server.com"       # Remote server address
REMOTE_PORT="22"                      # SSH port (default is 22)
REMOTE_DIR="/path/to/backup"          # Remote backup directory
SSH_KEY="\$HOME/.ssh/backup_rsa"      # SSH key path
INCLUDE_FILE="./include.txt"          # File containing paths to include
EXCLUDE_FILE="./exclude.txt"          # File containing paths to exclude
EOL

    echo "Default configuration created in $CONFIG_FILE."
    echo "Please edit this file with your details and rerun the script."
    exit 0
fi

# Source the configuration file
source "$CONFIG_FILE"

##############################################################################
# Step #2: Pre-flight
##############################################################################

# Generate SSH key if it doesn't exist
if [[ ! -f "$SSH_KEY" ]]; then
    echo "Generating SSH key..."
    ssh-keygen -t rsa -b 4096 -N "" -f "$SSH_KEY"
    echo "Copying SSH key to the remote server..."
    ssh-copy-id -i "$SSH_KEY" -p "$REMOTE_PORT" "$REMOTE_USER@$REMOTE_HOST"
else
    echo "SSH key already exists."
fi

# Check for inclusion and exclusion files
if [[ ! -f "$INCLUDE_FILE" ]]; then
    echo "Error: Include file $INCLUDE_FILE not found. Please create it."
    exit 1
fi

if [[ ! -f "$EXCLUDE_FILE" ]]; then
    echo "Error: Exclude file $EXCLUDE_FILE not found. Please create it."
    exit 1
fi

##############################################################################
# Step #3: Synchronize data
##############################################################################

# Perform rsync
echo "Starting rsync backup..."
rsync -avzh --progress \
    --files-from="$INCLUDE_FILE" \
    --exclude-from="$EXCLUDE_FILE" \
    -e "ssh -i $SSH_KEY -p $REMOTE_PORT" \
    / \
    "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"

if [[ $? -eq 0 ]]; then
    echo "Backup completed successfully."
else
    echo "Error during rsync backup."
    exit 1
fi
