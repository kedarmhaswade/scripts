#!/bin/sh 

# Written by Kedar Mhaswade (kedar.mhaswade@gmail.com).
# Artistic License - you are free to use this script at your own risk.

. `dirname $0`/functions.sh
SKEL=`dirname $0`/jetty-skeleton

usage() {
    echo "$0 web-app_war_or_folder service_name user_name host_ip_service_needs http_port (note: may require sudo password)"
    echo "deploys the given webapp *at the root context* in jetty installed at /home/user_name/jetty"
}
checkArgs() {
    if [ $# -ne 5 ] 
    then
        echo "not enough arguments: $# : we need 5"
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
    HTTP_PORT=$5
    HTTPS_PORT=8443
    JETTY_XML=$JETTY_HOME/etc/jetty.xml
}
createRootContext() {
  echo "<?xml version=\"1.0\"  encoding=\"ISO-8859-1\"?>" > $1
  echo "<!DOCTYPE Configure PUBLIC \"-//Jetty//Configure//EN\" \"http://www.eclipse.org/jetty/configure.dtd\">" >> $1
  echo "<Configure class=\"org.eclipse.jetty.webapp.WebAppContext\">" >> $1
  echo "  <Set name=\"contextPath\">/</Set>" >> $1
  echo "  <Set name=\"war\"><SystemProperty name=\"jetty.home\" default=\".\"/>$2</Set>" >> $1
  echo "</Configure>" >> $1
}
install() {
  bailNoFolder $USER_HOME
  bailNoFolder $JETTY_HOME
  bailNoFile $JETTY_HOME/start.jar
  bailNoFolderOrFile $WEB_APP
  if [ -d $WEB_APP ]
  then
    relink $WEB_APP $JETTY_HOME/webapps/root
    chown $USER_NAME $JETTY_HOME/webapps/root
  fi
  if [ -f $WEB_APP ]
  then
      cp $WEB_APP $JETTY_HOME/webapps/root.war
      chown $USER_NAME $JETTY_HOME/webapps/root.war
  fi
  if [ ! -d $JETTY_HOME/contexts.org ] 
  then
    mv $JETTY_HOME/contexts $JETTY_HOME/contexts.org
    chown -R $USER_NAME $JETTY_HOME/contexts.org 
    mkdir $JETTY_HOME/contexts
  fi
  createRootContext $JETTY_HOME/contexts/$SERVICE_NAME.xml /webapps/root.war
  chown -R $USER_NAME $JETTY_HOME/contexts 
}
doService() {
  bailNoFile $SKEL
  backupFile $SCRIPT_NAME
  sed -e 's|XXXNameXXX|'"${SERVICE_NAME}"'|g' \
      -e 's|XXXUserNameXXX|'"${USER_NAME}"'|g' \
      -e 's|XXXJettyHomeXXX|'"${JETTY_HOME}"'|g' \
      -e 's|XXXUserHomeXXX|'"${USER_HOME}"'|g' <$SKEL >$SCRIPT_NAME 
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
