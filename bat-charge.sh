#!/bin/bash
BAT=BAT1
echo "------"
ls /sys/class/power_supply/
echo "------"
echo "using battery name: $BAT; adjust from above ls accordingly ..."

echo "% charge: `cat /sys/class/power_supply/$BAT/charge_now | xargs -I {} echo "scale=2; 100 * {} / $(cat /sys/class/power_supply/$BAT/charge_full)" | bc`"

