#!/bin/bash
# Author: Aurelien Martin - 2024-12-21

# Silent mode flag
SILENT=false
if [[ "$1" == "--silent" ]]; then
    SILENT=true
    shift
fi

# Function to log messages
log_message() {
    local message=$1
    if [[ "$SILENT" == false ]]; then
        echo "$message" | tee -a "$LOG_FILE"
    else
        echo "$message" >> "$LOG_FILE"
    fi
}

##############################################################################
# Step #0: Load config value
##############################################################################

# Configuration file path
CONFIG_FILE="./backup.conf"
LOG_FILE="./backup.log"

# Check if the config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    log_message "Configuration file $CONFIG_FILE not found."
    log_message "Creating $CONFIG_FILE with default settings..."

    # Write default configuration to backup.conf
    cat <<EOL > "$CONFIG_FILE"
# Backup configuration
REMOTE_USER="rsyncuser"               # Remote username
REMOTE_HOST="remote.server.com"       # Remote server address
REMOTE_PORT="22"                      # SSH port
REMOTE_DIR="/home/rsyncuser/backups"  # Remote backup directory
SSH_KEY="\$HOME/.ssh/backup_rsa"      # SSH key path
INCLUDE_FILE="./rsync-include.txt"    # File containing paths to include
EXCLUDE_FILE="./rsync-exclude.txt"    # File containing paths to exclude
DELETE_MODE="false"                   # Set to "true" to enable rsync --delete
EOL

    log_message "Default configuration created in $CONFIG_FILE."
    log_message "Creating default rsync-include.txt and rsync-exclude.txt..."
    echo "# Add paths to include" > ./rsync-include.txt
    echo "/*" > ./rsync-exclude.txt
    log_message "Default files created. Please edit them as needed and rerun the script."
    exit 0
fi

# Source the configuration file
source "$CONFIG_FILE"

##############################################################################
# Step #1: Pre-flight
##############################################################################

# Add a timestamp to the log
current_date=$(date +"%Y-%m-%d %H:%M:%S")
log_message "##### Backup started at: $current_date"

# Generate SSH key if it doesn't exist
if [[ ! -f "$SSH_KEY" ]]; then
    log_message "Generating SSH key..."
    ssh-keygen -t rsa -b 4096 -N "" -f "$SSH_KEY"
    log_message "Copying SSH key to the remote server..."
    ssh-copy-id -i "$SSH_KEY" -p "$REMOTE_PORT" "$REMOTE_USER@$REMOTE_HOST"
else
    log_message "SSH key already exists."
fi

# Check for inclusion and exclusion files
if [[ ! -f "$INCLUDE_FILE" ]]; then
    log_message "Error: Include file $INCLUDE_FILE not found. Please create it."
    exit 1
fi

if [[ ! -f "$EXCLUDE_FILE" ]]; then
    log_message "Error: Exclude file $EXCLUDE_FILE not found. Please create it."
    exit 1
fi

##############################################################################
# Step #2: Synchronize data
##############################################################################

# Check for dry-run option
DRY_RUN=""
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN="--dry-run"
    log_message "[INFO] Performing a dry run. No data will be transferred."
fi

# Include the --delete option based on DELETE_MODE in the config file
DELETE_OPTION=""
if [[ "$DELETE_MODE" == "true" ]]; then
    DELETE_OPTION="--delete"
    log_message "[INFO] Rsync --delete mode enabled."
else
    log_message "[INFO] Rsync --delete mode disabled."
fi

# Perform rsync
log_message "Starting rsync backup..."
if [[ "$SILENT" == true ]]; then
    rsync -avzh $DRY_RUN $DELETE_OPTION \
        --include-from="$INCLUDE_FILE" \
        --exclude-from="$EXCLUDE_FILE" \
        -e "ssh -T -i $SSH_KEY -p $REMOTE_PORT" \
        / \
        "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR" >> "$LOG_FILE" 2>&1
else
    rsync -avzh --progress $DRY_RUN $DELETE_OPTION \
        --include-from="$INCLUDE_FILE" \
        --exclude-from="$EXCLUDE_FILE" \
        -e "ssh -T -i $SSH_KEY -p $REMOTE_PORT" \
        / \
        "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR" 2>&1 | tee -a "$LOG_FILE"
fi

if [[ $? -eq 0 ]]; then
    if [[ -n "$DRY_RUN" ]]; then
        log_message "Dry run completed successfully."
    else
        log_message "Backup completed successfully."
    fi
else
    log_message "Error during rsync backup."
    exit 1
fi

# Add a completion timestamp to the log
completion_date=$(date +"%Y-%m-%d %H:%M:%S")
log_message "##### Backup ended at: $completion_date"
