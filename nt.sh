#!/bin/bash

# Prints some thread statistics

set -o nounset
set -o errexit
# analyze a single dump
analyze_dump() {
  #tbd
  echo "wip"
}
if [[ $# -eq 0 ]]; then
  echo "Usage: $0 thread-dump-file+"
  exit 1
fi
for dump in $@;
do
  echo -e "Thread Dump File \t\t: Number of Threads"
  nt='grep "^.*\[.*\]$" $dump | wc -l'
  echo $dump:$(eval $nt) 
  grep java.lang.Thread.State: $dump | sort | uniq -c | sort
  # analyze_dump $dump
done
