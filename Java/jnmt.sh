#!/bin/bash
set -o nounset
set -o errexit
# run the given class with Java 8 native memory tracing enabled

if [[ $# -lt 1 ]];
then
  echo "$0 <optional classpath followed by main class, e.g. -cp foo.jar Foo>"
  exit 1
fi
echo "running ... java -XX:NativeMemoryTracking *"
echo "Now do jcmd <pidof java> VM.native_memory summary and observe Java Heap numbers" 
# -XX:NativeMemoryTracking=summary|detail|off
java -XX:+UnlockDiagnosticVMOptions -XX:NativeMemoryTracking=detail -XX:+PrintNMTStatistics $*
