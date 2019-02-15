#!/bin/sh
### BEGIN INIT INFO
# Provides:          opencast matterhorn
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: lecture recording and management system
### END INIT INFO
# /etc/init.d/matterhorn
#

set -e

##
# These variables are set in the configuration scripts.
##
#eg:  /usr/local/matterhorn
MATTERHORN=${MATTERHORN_HOME:-/usr/share/matterhorn}
#eg:  /usr/local/matterhorn/felix, or $MATTERHORN
FELIX_HOME=${FELIX_HOME:-$MATTERHORN}
#eg:  /usr/local/matterhorn/capture-agent, or $MATTERHORN/capture-agent
CA=${CA_DIR:-$MATTERHORN/capture-agent}
#eg:  Commonly opencast or matterhorn.  Can also be your normal user if you are testing.
MATTERHORN_USER=matterhorn
M2_REPOSITORY=${M2_REPO:-${MATTERHORN}/mvn2}
#Enable this if this machine is a CA.  This will enable capture device autoconfiguration.
IS_CA=false

LOGDIR="$FELIX_HOME/logs"

PATH=$PATH:$FELIX

##
# To enable the debugger on the vm, enable all of the following options
##

DEBUG_PORT="8000"
DEBUG_SUSPEND="n"
#DEBUG_OPTS="-Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,address=$DEBUG_PORT,server=y,suspend=$DEBUG_SUSPEND"

##
# Only change the line below if you want to customize the server
##

MAVEN_ARG="-DM2_REPO=$M2_REPOSITORY"

FELIX_CONFIG_DIR="$FELIX_HOME/etc"
FELIX_WORK_DIR="$FELIX_HOME/work"

FELIX="-Dfelix.home=$FELIX_HOME"
FELIX_WORK="-Dfelix.work=$FELIX_WORK_DIR"
FELIX_CONFIG_OPTS="-Dfelix.config.properties=file:${FELIX_CONFIG_DIR}/config.properties -Dfelix.system.properties=file:${FELIX_CONFIG_DIR}/system.properties"
FELIX_FILEINSTALL_OPTS="-Dfelix.fileinstall.dir=$FELIX_CONFIG_DIR/load"
JMX_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=1099 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"
FELIX_OPTS="$FELIX $FELIX_WORK $FELIX_CONFIG_OPTS $FELIX_FILEINSTALL_OPTS"

PAX_CONFMAN_OPTS="-Dbundles.configuration.location=$FELIX_CONFIG_DIR"

PAX_LOGGING_OPTS="-Dorg.ops4j.pax.logging.DefaultServiceLog.level=WARN"
MATTERHORN_LOGGING_OPTS="-Dopencast.logdir=$LOGDIR"
ECLIPSELINK_LOGGING_OPTS="-Declipselink.logging.level=SEVERE"
UTIL_LOGGING_OPTS="-Djava.util.logging.config.file=$FELIX_CONFIG_DIR/services/java.util.logging.properties"

LOG_OPTS="$PAX_LOGGING_OPTS $MATTERHORN_LOGGING_OPTS $ECLIPSELINK_LOGGING_OPTS $UTIL_LOGGING_OPTS"

GRAPHICS_OPTS="-Djava.awt.headless=true -Dawt.toolkit=sun.awt.HeadlessToolkit"
JAVA_OPTS="-Xms256m -Xmx1024m -XX:MaxPermSize=256m"

# The following lines are required to run Matterhorn as a service in Redhat.
# These lines should remain commented out.
# It is necessary to run "chkconfig matterhorn on" to enable matterhorn service management with Redhat.

#chkconfig: 2345 99 01
#description: lecture recording and management system

FELIX_CACHE="$FELIX_WORK_DIR/felix-cache"


###############################
### NO CHANGES NEEDED BELOW ###
###############################

case "$1" in
  start)
    echo -n "Starting Matterhorn as user $MATTERHORN_USER: "
    if $IS_CA ; then
        $CA/device_config.sh
    fi

# check if felix is already running
    MATTERHORN_PID=`ps aux | awk '/felix.jar/ && !/awk/ {print $2}'`
    if [ ! -z "$MATTERHORN_PID" ]; then
      echo "matterhorn is already running"
      exit 1
    fi


# Make sure matterhorn bundles are reloaded
    if [ -d "$FELIX_CACHE" ]; then
      echo "Removing cached matterhorn bundles from $FELIX_CACHE"
      for bundle in `find "$FELIX_CACHE" -type f -name bundle.location | xargs grep --files-with-match -e "file:" | sed -e s/bundle.location// `; do
        rm -r $bundle
      done
    fi

    cd $FELIX_HOME

# starting felix

    runuser $MATTERHORN_USER -c "java -Dgosh.args='--noshutdown -c noop=true' $DEBUG_OPTS $FELIX_OPTS $GRAPHICS_OPTS $TEMP_OPTS $MAVEN_ARG $JAVA_OPTS $PAX_CONFMAN_OPTS $LOG_OPTS $JMX_OPTS -jar $FELIX_HOME/bin/felix.jar $FELIX_CACHE 2>&1 > /dev/null &"
    echo "done."
    ;;
  stop)
    echo -n "Stopping Matterhorn: "
    MATTERHORN_PID=`ps aux | awk '/felix.jar/ && !/awk/ {print $2}'`
    if [ ! -z $MATTERHORN_PID ]; then
      kill $MATTERHORN_PID

      sleep 7

      MATTERHORN_PID=`ps aux | awk '/felix.jar/ && !/awk/ {print $2}'`
      if [ ! -z $MATTERHORN_PID ]; then
        echo "Hard killing since felix ($MATTERHORN_PID) seems unresponsive to regular kill"

        kill -9 $MATTERHORN_PID
      fi
    fi
    echo "done."
    ;;
  restart)
    $0 stop
    $0 start
    ;;
  status)
    MATTERHORN_PID=`ps aux | awk '/felix.jar/ && !/awk/ {print $2}'`
    if [ -z "$MATTERHORN_PID" ]; then
      echo "matterhorn is not running"
      exit 0
    else
      echo "matterhorn is running with PID $MATTERHORN_PID"
      exit 0
    fi
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
    ;;
esac

exit 0
