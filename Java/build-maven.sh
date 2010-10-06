#!/bin/sh
export MAVEN_OPTS="-Xmx1g -Xms1g -XX:MaxPermSize=256m"
exec mvn "$@"
