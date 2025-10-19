#!/usr/bin/env bash
# Simple SSH brute-force summary with enhanced username detection
# Usage: ./ssh-bruteforce-summary.sh ["24 hours ago"]

set -euo pipefail

SINCE="${1:-24 hours ago}"

# Detect SSH unit
if systemctl status ssh >/dev/null 2>&1; then
  UNIT="ssh"
elif systemctl status sshd >/dev/null 2>&1; then
  UNIT="sshd"
else
  echo "Could not find ssh or sshd systemd service." >&2
  exit 1
fi

PAT='Failed password|Invalid user|Failed publickey|authentication failure'

# Capture matching lines
MATCHES=$(sudo journalctl -u "$UNIT" --since "$SINCE" -o cat 2>/dev/null | grep -E "$PAT" || true)

if [ -z "$MATCHES" ]; then
  echo "No matching logs found since: $SINCE (unit: $UNIT)"
  exit 0
fi

# Total count
TOTAL=$(echo "$MATCHES" | wc -l)

echo "Analyzing since: $SINCE (unit: $UNIT)"
echo "Total suspicious auth failure lines: $TOTAL"
echo

echo "Top offending IPs:"
echo "$MATCHES" \
  | sed -n 's/.*\(from \|rhost=\)\([^ ]*\).*/\2/p' \
  | grep -v '^$' \
  | sort | uniq -c | sort -nr | head -n 15

echo
echo "Top attempted usernames (if present in logs):"
echo "$MATCHES" \
  | sed -n -E 's/.*(Invalid user|Failed password for) ([^ ]*) .*/\2/p' \
  | grep -v '^$' \
  | sort | uniq -c | sort -nr | head -n 10

echo
echo "Done."
