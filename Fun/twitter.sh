#!/bin/sh
function usage() {
  echo "$1 [p tweet]"
}
if [ $# -eq 0 ] ; 
then
  curl -s http://twitter.com/bloggerkedar | grep '<span class="entry-content">' | cut  -d'@' -f2 | cut -d'>' -f2 | cut -d'<' -f1
  exit 0
fi
if [ "$1" == "p" ] ;
then
  if [ "$2x" == "x" ] ;
  then
    usage $0
    exit 1
  else
    tweet=$2
    user=bloggerkedar
    echo "twitter password for $user: "
    oldmodes=`stty -g`
    stty -echo
    read password
    stty $oldmodes
    curl -u $user:$password -d status="$tweet" https://twitter.com/statuses/update.xml
  fi
fi

