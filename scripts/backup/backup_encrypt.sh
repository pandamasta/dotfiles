#!/bin/sh
# Simple sh script to backup my home and encrypt
# Tested on Ubuntu 24.04
# List archive: openssl enc -d -aes-256-cbc -in /var/backups/backup_20250124_103009.tar.gz.enc -pass file:/root/backup.key | tar -tzf -
# Decompress archive: openssl enc -d -aes-256-cbc -in /var/backups/backup_YYYYMMDD_HHMMSS.tar.gz.enc -pass file:/root/backup.key | tar -xzf -

# Variables
BACKUP_DIRS="/home"  # Directories to back up
EXCLUDE_PATTERN="--exclude=*.tmp --exclude=*.log --exclude=.vscode --exclude=.cache --exclude=__pycache__"  # Patterns to exclude
BACKUP_DEST="/var/backups"  # Destination directory for backups
BACKUP_KEY="/root/backup.key"  # Encryption key file

# Ensure backup directory exists
mkdir -p "$BACKUP_DEST"

# Generate encryption key if not exists
[ -f "$BACKUP_KEY" ] || head -c 32 /dev/urandom > "$BACKUP_KEY" && chmod 600 "$BACKUP_KEY"

# Create backup
ARCHIVE_NAME="backup_$(date +%Y%m%d_%H%M%S).tar.gz"
ARCHIVE_PATH="$BACKUP_DEST/$ARCHIVE_NAME"
tar czf "$ARCHIVE_PATH" $EXCLUDE_PATTERN $BACKUP_DIRS

# Encrypt backup
openssl enc -aes-256-cbc -salt -in "$ARCHIVE_PATH" -out "$ARCHIVE_PATH.enc" -pass file:"$BACKUP_KEY"
rm -f "$ARCHIVE_PATH"

echo "Backup created: $ARCHIVE_PATH.enc"
