#!/bin/bash
LOG=logs/surveillance.log

trap 'echo "$(date "+%F %T") arrêt propre" >> "$LOG"; exit 0' TERM

while true; do
    echo "$(date '+%F %T') $(wc -l < logs/access.log) lignes" >> "$LOG"
    sleep 5 &
    wait $!
done
