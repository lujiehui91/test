#!/bin/bash
#
# /etc/init.d/Spark
#
# Startup script for Spark
#
# chkconfig: 2345 20 80
# description: Starts and stops spark

prog="Spark"
mesosps="/home/mesos/spark-2.0.1-bin-hadoop2.7/jars"
mesosBin="/home/mesos/spark-2.0.1-bin-hadoop2.7/bin/spark-shell"
desc="Spark daemon"
outFile="/home/mesos/spark-2.0.1-bin-hadoop2.7/logs/$prog.out"

start() {
  echo "Starting $desc ($prog): "
  su $mesosUser -c "nohup $mesosBin --master mesos://zk://192.168.1.140:2181,192.168.1.141:2181,192.168.1.142:2181/mesos >>$outFile 2>&1 &"

  RETVAL=$?
  return $RETVAL
}

stop() {
  echo "Shutting down $desc ($prog): "
  pkill -f $mesosps
}

restart() {
    stop
    start
}

status() {

  if [ -z $pid ]; then
     pid=$(pgrep -f $mesosps)

  fi


  if [ -z $pid ]; then
    echo "$prog is NOT running."
    return 1
  else
    echo "$prog is running (pid is $pid)."
  fi

}

case "$1" in
  start)   start;;
  stop)    stop;;
  restart) restart;;
  status)  status;;
  *)       echo "Usage: $0 {start|stop|restart|status}"
           RETVAL=2;;
esac
exit $RETVAL