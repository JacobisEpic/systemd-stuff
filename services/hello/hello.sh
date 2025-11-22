#!/usr/bin/env bash
set -euo pipefail

LOG=/tmp/systemd-hello.log

echo "$(date) - Hello from systemd service! This is a user service that's self-contained" >> $LOG

while true; do
    echo "$(date) - Still running..." >> $LOG
    sleep 10
done
EOF