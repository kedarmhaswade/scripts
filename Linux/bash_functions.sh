#!/bin/bash

# ONLY USE IN REAL SCRIPTS
# These are some everyday utilities that bash scripts may need

# Note: MY_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) --> gives your script's directory

# bails if the given folder does not exist
bailNoFolder() {
  if [ ! -d $1 ]
  then
    echo "Folder $1 does not exist, exiting ..."
    exit 2;    
  fi
}

# bails if the given file does not exist
bailNoFile() {
  if [ ! -f $1 ]
  then
    echo "File $1 does not exist, exiting ..."
    exit 2;    
  fi
}

bailNoFolderOrFile() {
  if [ ! -d $1 -a ! -f $1 ]
  then
    echo "Neither the folder nor the file $1 exists, exiting ..."
    exit 2;    
  fi
}
#relink [existing_file_or_folder] [link_name] (note: link_name will be recreated)
#return 1 on success and 0 on failure (how un-C-like)
relink() {
    if [ ! -d $1 -a ! -f $1 ]
    then
        echo "a dangling symlink will be created"
    fi
    if [ -L $2 ]
    then
      rm $2
      echo "removing the link before relinking: $2"
    fi
    ln -s $1 $2
}
random() {
  RANDOM=$$$(date +%s)
  if [ "$1x" = "x" ]
  then
    base=100
  else
    base=$1
  fi
  d=$(($(($RANDOM % $base))+1))
  echo $d
}
backupFile() {
  if [ -f $1 ]
  then
    to=$1.bak.`random`
    cp $1 $to
    echo "copied $1 to $to"
  fi
}
# convert the given argument from hex to decimal
hex2dec() {
    upper=$(echo "$@" | tr "[:lower:]" "[:upper:]")
    echo "ibase=16;$upper" | bc
}
# convert the given argument from decimal to hex
dec2hex() {
    echo "obase=16; $@" | bc
}
bin2dec() {
    echo "ibase=2;$@" | bc
}
dec2bin() {
    echo "obase=2;$@" | bc
}
hex2bin() {
    upper=$(echo "$@" | tr "[:lower:]" "[:upper:]")
    echo "obase=2; ibase=16;$upper" | bc
}
bin2hex() {
    echo "ibase=2; obase=16;$@" | bc
}
random_string() {
    cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1
}
