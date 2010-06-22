# This is the init script for starting up the 
#		Tomcat server
#
# chkconfig: 345 91 10 
# description: Starts and stops the Tomcat Server daemon.
#

if [ -f "/etc/rc.d/init.d/functions" ]; then
   . /etc/rc.d/init.d/functions
fi

# Get config.
if [ -f "/etc/sysconfig/network" ]; then
   . /etc/sysconfig/network
fi


# Check that networking is up.
[ "${NETWORKING}" = "no" ] && exit 0

INSTANCE_NAME=`basename $0`
CATALINA_HOME="/opt/tomcat"
NODE_DIRECTORY=$CATALINA_HOME/../nodes
CATALINA_BASE="$NODE_DIRECTORY/$INSTANCE_NAME"
cd $CATALINA_BASE
TOMCAT_USER="tomcat"

startupscript="$CATALINA_BASE/$INSTANCE_NAME start"
stopscript="$CATALINA_BASE/$INSTANCE_NAME stop"

start(){
	echo -n $"Starting Tomcat Server service: "
	#daemon -c 
	if [[ "$USER" == "$TOMCAT_USER" ]]
	then
	    $startupscript
	else
	    su $TOMCAT_USER -c "$startupscript"
	fi
	RETVAL=$?
	echo
}

stop(){
	echo -n $"Stopping Tomcat Server service: " 
	$shutdownscript	
	RETVAL=$?
	echo
}

restart(){
    stop
    start
}


# See how we were called.
case "$1" in
  start)
	start
	;;
  stop)
	stop
	;;
  status)
 	status $INSTANCE_NAME
	;;
  restart)
	restart
	;;
  *)
	echo $"Usage: $0 {start|stop|status|restart}"
	exit 1
esac

exit 0

