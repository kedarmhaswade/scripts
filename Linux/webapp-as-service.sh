#!/bin/sh 

# Written by Kedar Mhaswade (kedar.mhaswade@gmail.com).
# Artistic License - you are free to use this script at your own risk.

. `dirname $0`/functions.sh
SKEL=`dirname $0`/jetty-skeleton

usage() {
    echo "$0 web-app_war_or_folder service_name user_name (note: may prompt for sudo password)"
    echo "deploys the given webapp *at the root context* in jetty installed at /home/user_name/jetty"
}
checkArgs() {
    if [ $# -ne 3 ] 
    then
        echo "not enough arguments: $#"
        usage
        exit 1
    fi
    WEB_APP=$1
    SERVICE_NAME=$2
    USER_NAME=$3
    USER_HOME=/home/$USER_NAME
    JETTY_HOME=$USER_HOME/jetty
    SCRIPT_NAME=/etc/init.d/$SERVICE_NAME
    DAEMON_ARGS="-jar $JETTY_HOME/start.jar"
}
install() {
  bailNoFolder $USER_HOME
  bailNoFolder $JETTY_HOME
  bailNoFile $JETTY_HOME/start.jar
  bailNoFolderOrFile $WEB_APP
  if [ -d $WEB_APP ]
  then
    relink $WEB_APP $JETTY_HOME/webapps/root
  fi
  if [ -f $WEB_APP ]
  then
      cp $WEB_APP $JETTY_HOME/webapps/root.war
  fi
}
doService() {
  bailNoFile $SKEL
  backupFile $SCRIPT_NAME
  sed -e "s/NameXXX/$SERVICE_NAME/g" \
           -e "s/UserNameXXX/$USER_NAME/g" \
           -e "s/UserHomeXXX/$USER_HOME/g" \
           -e "s/DaemonArgsXXX/$DAEMON_ARGS/g" <$SKEL >$SCRIPT_NAME
  chmod +x $SCRIPT_NAME
}
checkArgs "$@"
install
doService
