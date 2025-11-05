#!/bin/bash
# mem_watchdog.sh
# Monitors memory and swap, logs to rotating logs, triggers SysRq snapshots on high memory usage

# ----------------- CONFIG -----------------
LOGDIR="$HOME/mem_watchdog_logs"
LOGFILE="$LOGDIR/mem_watchdog.log"
MAX_LOG_FILES=10
MAX_LOG_SIZE=1048576       # 1 MB
MEM_THRESHOLD=90           # % of RAM usage
SWAP_THRESHOLD=50          # % of Swap usage
INTERVAL=10                # seconds between checks
# ----------------------------------------

mkdir -p "$LOGDIR"

timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

rotate_logs() {
    # Rotate logs if larger than MAX_LOG_SIZE
    if [ -f "$LOGFILE" ] && [ $(stat -c%s "$LOGFILE") -ge $MAX_LOG_SIZE ]; then
        for ((i=MAX_LOG_FILES-1; i>=1; i--)); do
            [ -f "$LOGDIR/mem_watchdog.log.$i" ] && mv "$LOGDIR/mem_watchdog.log.$i" "$LOGDIR/mem_watchdog.log.$((i+1))"
        done
        mv "$LOGFILE" "$LOGDIR/mem_watchdog.log.1"
        touch "$LOGFILE"
    fi
}

get_mem_usage() {
    free | awk '/Mem:/ {printf("%d", $3/$2 * 100)}'
}

get_swap_usage() {
    free | awk '/Swap:/ {printf("%d", $3/$2 * 100)}'
}

trigger_sysrq_snapshot() {
    if [ -w /proc/sysrq-trigger ]; then
        echo "$(timestamp) - Triggering SysRq memory snapshot..." | tee -a "$LOGFILE"
        for key in l m t; do
            echo "$key" > /proc/sysrq-trigger
        done
        echo "$(timestamp) - SysRq snapshot triggered." | tee -a "$LOGFILE"
    else
        echo "$(timestamp) - Cannot write to /proc/sysrq-trigger. Check kernel.sysrq=1" | tee -a "$LOGFILE"
    fi
}

# ----------------- MAIN LOOP -----------------
echo "$(timestamp) - Memory watchdog started." | tee -a "$LOGFILE"

while true; do
    rotate_logs

    MEM_USAGE=$(get_mem_usage)
    SWAP_USAGE=$(get_swap_usage)

    echo "$(timestamp) - Memory: $MEM_USAGE%, Swap: $SWAP_USAGE%" | tee -a "$LOGFILE"

    if [ "$MEM_USAGE" -ge "$MEM_THRESHOLD" ] || [ "$SWAP_USAGE" -ge "$SWAP_THRESHOLD" ]; then
        echo "$(timestamp) - WARNING: High memory/swap usage!" | tee -a "$LOGFILE"
        trigger_sysrq_snapshot
    fi

    sleep $INTERVAL
done

