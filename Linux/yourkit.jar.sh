#!/bin/bash

# runs the given jar with yourkit profiler
AGENT_PATH=/usr/share/yjp-9.0.8/bin/linux-x86-64/libyjpagent.so
java -agentpath:$AGENT_PATH -Xmx2g -jar $1
