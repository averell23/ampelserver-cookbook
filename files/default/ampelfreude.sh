#!/bin/sh

### BEGIN INIT INFO
# Provides:        ampelfreude
# Required-Start:  $network $remote_fs $syslog
# Required-Stop:   $network $remote_fs $syslog
# Default-Start:   2 3 4 5
# Default-Stop:    0 1 6
# Short-Description: Start NTP daemon
### END INIT INFO

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin
HOME=/var/apps/ampelfreude/current

. /lib/lsb/init-functions


case $1 in
  start)
    log_daemon_msg "Starting Ampel Runner server" "ampelfreude"
    cd $HOME
    bundle exec ruby ampel_control.rb start
    status=$?
    log_end_msg $status
      ;;
  stop)
    log_daemon_msg "Stopping NTP server" "ampelfreude"
    cd $HOME
    bundle exec ruby ampel_control.rb stop
    status=$?
    log_end_msg $status
      ;;
  restart|force-reload)
    $0 stop && sleep 2 && $0 start
      ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 2
    ;;
esac