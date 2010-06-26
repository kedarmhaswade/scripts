#!/bin/sh

bailNoFolder() {
  if [ ! -d $1 ]
  then
    echo "Folder $1 does not exist, exiting ..."
    exit 2;    
  fi
}

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
      ln -s $1 $2
    fi
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
