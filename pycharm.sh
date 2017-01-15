#!/bin/sh
 
# from https://gist.github.com/suya55/dbbca5078401861b22b0
# check for where the latest version of IDEA is installed
IDEA=`ls -1d /Applications/PyCharm\ * | tail -n1`
wd=`pwd`
# Setup your working directory. Edit 'work' to your working directory.
#working_dir=`ls -1d ~/work/$1 | head -n1`
working_dir=.

# were we given a directory?
if [ -d "$1" ]; then
#  echo "checking for things in the working dir given"
  wd=`ls -1d "$1" | head -n1`
fi

# were we given a file?
if [ -f "$1" ]; then
#  echo "opening '$1'"
  open -a "$IDEA" "$1"
else
    # let's check for stuff in our working directory.
    pushd $wd > /dev/null

    # does our working dir have an .idea directory?
    if [ -d ".idea" ]; then
#      echo "opening via the .idea dir"
      open -a "$IDEA" .

    # is there an IDEA project file?
    elif [ -f *.ipr ]; then
#      echo "opening via the project file"
      open -a "$IDEA" `ls -1d *.ipr | head -n1`

    # Is there a pom.xml?
    elif [ -f pom.xml ]; then
#      echo "importing from pom"
      open -a "$IDEA" "pom.xml"
# find argument in woring directory
    elif [ -d $working_dir ]; then
      open -a "$IDEA" $working_dir
    # can't do anything smart; just open IDEA
    else
#      echo 'cbf'
      open "$IDEA"
    fi

    popd > /dev/null
fi
