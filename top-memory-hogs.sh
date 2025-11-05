#!/bin/bash

TOP_N=${1:-10}             # Number of top entries to show
TYPE_FILTER=${2:-u}         # s=services, u=user processes, c=combined

echo "=== Memory Usage Overview ==="
echo

echo "Top $TOP_N entries (RSS in MB) - Filter: $TYPE_FILTER"
printf "%-8s %-6s %-6s %-s\n" "RSS(MB)" "PID" "TYPE" "NAME"
echo "---------------------------------------------------"

# Temporary file to collect all entries
TMP_FILE=$(mktemp)

# --- Systemd services ---
if [[ "$TYPE_FILTER" == "s" || "$TYPE_FILTER" == "c" ]]; then
    systemctl list-units --type=service --state=running --no-legend | awk '{print $1}' | while read svc; do
        pid=$(systemctl show -p MainPID $svc | cut -d'=' -f2)
        if [ "$pid" -ne 0 ]; then
            rss_kb=$(grep VmRSS /proc/$pid/status 2>/dev/null | awk '{print $2}')
            rss_mb=$(( (rss_kb + 512) / 1024 ))
            printf "%-8s %-6s %-6s %-s\n" "$rss_mb" "$pid" "SERVICE" "$svc"
        fi
    done >> "$TMP_FILE"
fi

# --- User processes ---
if [[ "$TYPE_FILTER" == "u" || "$TYPE_FILTER" == "c" ]]; then
    ps -u $USER -o pid,rss,comm --no-headers | while read pid rss comm; do
        rss_mb=$(( (rss + 512)/1024 ))
        printf "%-8s %-6s %-6s %-s\n" "$rss_mb" "$pid" "USER" "$comm"
    done >> "$TMP_FILE"
fi

# Sort by RSS descending and pick top N
sort -nr "$TMP_FILE" | head -"$TOP_N"

# Clean up
rm "$TMP_FILE"

