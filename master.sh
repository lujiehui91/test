#!/bin/bash
#
# /etc/init.d/mesos-master
#
# Startup script for mesos-master
#
# chkconfig: 2345 20 80
# description: Starts and stops mesos-master

prog="mesos-master"
#mesosBin="/usr/sbin/$prog"
mesosps="/home/mesos/mesos-1.0.1/build/src/.libs/lt-mesos-master"
mesosBin="/home/mesos/mesos-1.0.1/build/bin/mesos-master.sh"
desc="Mesos Master daemon"
outFile="/home/mesos/log/$prog.out"

start() {
  echo "Starting $desc ($prog): "
#  su $mesosUser -c "nohup $mesosBin --quiet --conf=/etc/mesos/conf/ >>$outFile 2>&1 &"
  su $mesosUser -c "nohup $mesosBin --quiet  --ip=192.168.1.142  --work_dir=/var/lib/mesos >>$outFile 2>&1 &"

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