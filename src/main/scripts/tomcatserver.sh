# This is the init script for starting up the 
#		Jakarta Tomcat server
#
# chkconfig: 345 91 10 
# description: Starts and stops the Tomcat daemon.
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

CATALINA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=12080 -Dcom.sun.management.jmxremote.ssl=false  -Dcom.sun.management.jmxremote.authenticate=false"

export CATALINA_OPTS


INSTANCE_NAME=`basename $0`
CATALINA_HOME=/opt/tomcat
NODE_DIRECTORY=$CATALINA_HOME/../nodes
CATALINA_BASE="$NODE_DIRECTORY/$INSTANCE_NAME"
TOMCAT_USER="tomcat"
JAVA_LOCATION="/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0"

## make a ln -s
if [ ! -n $JAVA_HOME ]; then
	if [ ! -d "/usr/lib/jvm/java-1.6.0" ]; then
		export JAVA_HOME=$JAVA_LOCATION
	fi
	if [ -d "/usr/lib/jvm/java-1.6.0" ]; then
		export JAVA_HOME="/usr/lib/jvm/java-1.6.0"
	fi
fi
export JRE_HOME=$JAVA_HOME/jre

if [ -f "$CATALINA_BASE/java.properties" ]; then
	export JAVA_OPTS=`cat $CATALINA_BASE/java.properties`
fi

if [ -d "$CATALINA_BASE/app_config" ]; then
    if [ ! -d "$CATALINA_BASE/bin" ]; then
    	mkdir $CATALINA_BASE/bin
    fi
    echo "#!/bin/sh" > $CATALINA_BASE/bin/setenv.sh
    echo "export CLASSPATH=$CATALINA_BASE/app_config" >> $CATALINA_BASE/bin/setenv.sh
    chmod +x $CATALINA_BASE/bin/setenv.sh
#	export CLASSPATH="$CATALINA_BASE/app_config"
fi

export CATALINA_BASE CATALINA_HOME

startup=$CATALINA_HOME/bin/startup.sh
shutdown=$CATALINA_HOME/bin/shutdown.sh

start(){
	echo -n $"Starting Tomcat service: "
	if [ ! -d "$CATALINA_BASE/logs" ]; then
		echo "Making log dir"
		mkdir -p "$CATALINA_BASE/logs"
	fi
	 
	#daemon -c 
	if [[ "$USER" == "$TOMCAT_USER" ]]
	then
	    $startup
	else
	    su $TOMCAT_USER -c "$startup"
	fi
	RETVAL=$?
	echo
}

stop(){
	echo -n $"Stopping Tomcat service: " 
	$shutdown	
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
 	status tomcat
	;;
  restart)
	restart
	;;
  *)
	echo $"Usage: $0 {start|stop|status|restart}"
	exit 1
esac

exit 0

