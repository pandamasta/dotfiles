#!/bin/bash

# Define the path to the credentials file
CRED_FILE="$HOME/.backup_creds"

# Check if the credentials file exists
if [ ! -f "$CRED_FILE" ]; then
    # If it doesn't exist, create it with placeholders
    echo "Creating credentials file at $CRED_FILE..."
    cat <<EOL > "$CRED_FILE"
# Backup Credentials
FTP_USER=your_login
FTP_PASS=your_password
FTP_URL=ftp://your_ftp_server
EOL
    # Set the file permissions to make it readable only by the user
    chmod 600 "$CRED_FILE"
    
    # Inform the user to edit the credentials
    echo "Please edit the credentials in $CRED_FILE and rerun the script."
    exit 1
fi

# Load credentials from the file
. "$CRED_FILE"

# Get the current date, hour, and minute
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

# Define the backup file name using the timestamp
BACKUP_FILE="/backup/pgdump_all_backup_${TIMESTAMP}.sql.gz"

# Generate the backup file
pg_dumpall | gzip > "$BACKUP_FILE"

# Delete backups older than 7 days
find /backup/ -type f -name '*.gz' -mtime +7 -delete

# Upload the backup via FTP
curl -T "$BACKUP_FILE" --user "$FTP_USER:$FTP_PASS" "$FTP_URL/pgdump_all_backup_${TIMESTAMP}.sql.gz"

