#!/bin/sh 

# Written by Kedar Mhaswade (kedar.mhaswade@gmail.com).
# Artistic License - you are free to use this script at your own risk.

. `dirname $0`/functions.sh
SKEL=`dirname $0`/jetty-skeleton

usage() {
    echo "$0 web-app_war_or_folder service_name user_name host_ip (note: may require sudo password)"
    echo "deploys the given webapp *at the root context* in jetty installed at /home/user_name/jetty"
}
checkArgs() {
    if [ $# -ne 4 ] 
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
    HOST=$4
    HTTP_PORT=80
    HTTPS_PORT=443
    JETTY_XML=${JETTY_HOME}/etc/jetty.xml
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
  sed -e 's|XXXNameXXX|'"${SERVICE_NAME}"'|g' \
      -e 's|XXXUserNameXXX|'"${USER_NAME}"'|g' \
      -e 's|XXXUserHomeXXX|'"${USER_HOME}"'|g' \
      -e 's|XXXDaemonArgsXXX|'"${DAEMON_ARGS}"'|g' <$SKEL >$SCRIPT_NAME
  chmod +x $SCRIPT_NAME
}
editJettyXml() {
  #backupFile $JETTY_XML
  sed -e 's|\(^.*<Set name="host">\)\(.*\)\(</Set>.*\)|\1'"${HOST}"'\3|g' \
      -e 's|\(^.*<Set name="port">\)\(.*\)\(</Set>.*\)|\1'"${HTTP_PORT}"'\3|g' \
      -e 's|\(^.*<Set name="confidentialPort">\)\(.*\)\(</Set>.*\)|\1'"${HTTPS_PORT}"'\3|g' \
      -i.bak ${JETTY_XML}
}
checkArgs "$@"
install
doService
editJettyXml
