#!/bin/bash
# freeze-diagnosis.sh
# Collect system memory, swap, top memory users, and journal logs

OUTFILE="${1:-freeze-diagnosis-$(date +%F-%H%M%S).log}"

echo "=== Freeze Diagnosis Dump ==="
echo "Output file: $OUTFILE"
echo

{
echo "=== Date ==="
date
echo

echo "=== Memory and Swap Info ==="
free -h
echo
swapon --show
echo

echo "=== ZRAM Info ==="
if [ -e /sys/class/zram-control/hot_add ]; then
    for z in /dev/zram*; do
        echo "Device: $z"
        cat /sys/block/$(basename $z)/mm_stat 2>/dev/null || echo "No mm_stat available"
        echo
    done
else
    echo "No ZRAM devices detected"
fi

echo "=== Top 10 Memory Users (All processes) ==="
ps -eo pid,ppid,cmd,%mem,rss --sort=-rss | head -n 11
echo

echo "=== Top 10 Systemd Services by RSS ==="
systemctl list-units --type=service --state=running --no-legend | awk '{print $1}' | while read svc; do
    pid=$(systemctl show -p MainPID $svc | cut -d'=' -f2)
    if [ "$pid" -ne 0 ]; then
        rss=$(grep VmRSS /proc/$pid/status 2>/dev/null | awk '{print $2}')
        echo -e "$rss\t$svc"
    fi
done | sort -nr | head -10 | awk '{printf "%-10s KB\t%s\n", $1, $2}'
echo

echo "=== Journal Logs: Memory Watchdog + ZRAM + Errors ==="
journalctl -b -1 -u memory-watchdog.service -u zram-swap.service -p err..alert --no-pager
echo

} > "$OUTFILE"

echo "=== Done ==="
echo "All output saved to $OUTFILE"

