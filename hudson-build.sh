#!/bin/sh
java -version
mvn -v
svn co https://svn.dev.java.net/svn/hudson/trunk/hudson
svn co https://svn.dev.java.net/svn/hudson/trunk/www
cd hudson/main
#use maven2 for build
mvn install -Dmaven.test.skip=true
