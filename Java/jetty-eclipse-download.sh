#!/bin/sh

. `dirname $0/../Linux/functions.sh`

if [ "$1" = "" ]
then
    DIR=`pwd`
else
    DIR=$1
fi
bailNoFolder $DIR
cd $DIR
JETTY_VERSION=7.0.2.v20100331
wget http://download.eclipse.org/jetty/$JETTY_VERSION/dist/jetty-distribution-$JETTY_VERSION.tar.gz
tar xfz jetty-distribution-$JETTY_VERSION.tar.gz
relink jetty-distribution-$JETTY_VERSION jetty
