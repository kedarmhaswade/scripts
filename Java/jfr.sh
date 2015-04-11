#!/bin/bash
set -o nounset
set -o errexit
# run the given class with JFR enabled JVM

if [[ $# -lt 1 ]];
then
  echo "$0 <optional classpath followed by main class, e.g. -cp foo.jar Foo>"
  exit 1
fi
echo "running ... java -XX:+UnlockCommercialFeatures -XX:+FlightRecorder $*"
echo "Now connect using the command jmc ..."
java -XX:+UnlockCommercialFeatures -XX:+FlightRecorder $*
