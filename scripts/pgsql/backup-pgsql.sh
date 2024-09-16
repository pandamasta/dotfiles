#!/bin/bash
# Author: Aurelien Martin - 2024-09-26

#!/bin/bash

# Define the path to the credentials file
CRED_FILE="$HOME/.backup_creds"
GZIP_FLAG=0
ENCRYPT_FLAG=0
FTP_FLAG=0

# Helper function to display usage instructions
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Backup PostgreSQL database with optional compression, encryption, and FTP upload."
    echo ""
    echo "Options:"
    echo "  --gzip           Compress the backup using gzip."
    echo "  --encrypt        Encrypt the backup using the password in the credentials file."
    echo "  --ftp            Upload the backup to the FTP server using credentials in the config."
    echo "  --help           Display this help message."
    echo ""
    echo "Decryption Instructions:"
    echo "To decrypt an encrypted backup file, use the following command:"
    echo ""
    echo "  openssl enc -aes-256-cbc -d -in <encrypted_file> -out <output_file> -k <your_password>"
    echo ""
    echo "If the file was compressed, you will need to decompress it after decryption:"
    echo "  gunzip <output_file>.gz"
}

# Parse arguments
for arg in "$@"; do
    case $arg in
        --gzip)
            GZIP_FLAG=1
            shift
            ;;
        --encrypt)
            ENCRYPT_FLAG=1
            shift
            ;;
        --ftp)
            FTP_FLAG=1
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option $arg"
            show_help
            exit 1
            ;;
    esac
done

# Check if the credentials file exists
if [ ! -f "$CRED_FILE" ]; then
    # If it doesn't exist, create it with placeholders
    echo "Creating credentials file at $CRED_FILE..."
    cat <<EOL > "$CRED_FILE"
# Backup Credentials
FTP_USER=your_login
FTP_PASS=your_password
FTP_URL=ftp://your_ftp_server
BACKUP_PASS=your_encryption_password
EOL
    # Set the file permissions to make it readable only by the user
    chmod 600 "$CRED_FILE"
    
    # Inform the user to edit the credentials
    echo "Please edit the credentials in $CRED_FILE and rerun the script."
    exit 1
fi

# Load credentials from the file
. "$CRED_FILE"

# Get the current date, hour, minute, and second
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

# Define the backup file name using the timestamp
BACKUP_FILE="/backup/pgdump_all_backup_${TIMESTAMP}.sql"
GZIPPED_FILE="/backup/pgdump_all_backup_${TIMESTAMP}.sql.gz"
ENCRYPTED_FILE="/backup/pgdump_all_backup_${TIMESTAMP}.sql.enc"

# Generate the plain SQL dump
pg_dumpall > "$BACKUP_FILE"

# Optionally gzip the file
if [ "$GZIP_FLAG" -eq 1 ]; then
    echo "Compressing the backup with gzip..."
    gzip "$BACKUP_FILE"
    BACKUP_FILE="$GZIPPED_FILE"
fi

# Optionally encrypt the file
if [ "$ENCRYPT_FLAG" -eq 1 ]; then
    echo "Encrypting the backup..."
    openssl enc -aes-256-cbc -salt -in "$BACKUP_FILE" -out "${BACKUP_FILE}.enc" -k "$BACKUP_PASS"
    BACKUP_FILE="${BACKUP_FILE}.enc"
fi

# Delete backups older than 7 days (applies to both compressed and uncompressed files)
find /backup/ -type f -name '*.sql.gz' -o -name '*.sql.enc' -mtime +7 -delete

# Optionally upload the backup via FTP
if [ "$FTP_FLAG" -eq 1 ]; then
    echo "Uploading backup to FTP..."
    curl -T "$BACKUP_FILE" --user "$FTP_USER:$FTP_PASS" "$FTP_URL/$(basename "$BACKUP_FILE")"
    echo "Backup uploaded to FTP: $(basename "$BACKUP_FILE")"
else
    echo "Backup created locally: $(basename "$BACKUP_FILE")"
fi

