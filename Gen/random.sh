#!/bin/sh
#attribution: http://linuxgazette.net/issue55/tag/4.html
RANDOM=$$$(date +%s)
if [ "$1x" == "x" ];
then
  base=100
else
  base=$1
fi
d=$[ ( $RANDOM % $base  ) + 1 ]
echo $d
