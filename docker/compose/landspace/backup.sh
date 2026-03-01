#!/bin/bash
BACKUP_DIR="./backups"
mkdir -p $BACKUP_DIR

DATE=$(date +%Y-%m-%d_%Hh%M)

tar -czf $BACKUP_DIR/landing_backup_$DATE.tar.gz /path/to/backup

find $BACKUP_DIR -type f -mtime +30 -delete

echo "Backup terminé le $DATE"
