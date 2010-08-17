#!/bin/sh
if [ "$1x" = "x" ] 
then
  echo "Type at the keyboard and then do a ^D to put it in clipboard"
  xclip -selection clipboard
else
  SRC=$1
  if [ ! -f "$SRC" ] 
  then
    echo "$SRC is not a file, trying it as a command"
    $SRC | xclip -selection clipboard
  else
    cat $SRC | xclip   -selection clipboard
  fi
    echo "Contents of $SRC are now in clipboard"
fi
