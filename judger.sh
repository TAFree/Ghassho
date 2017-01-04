#!/usr/bin/env bash


# File	      : judger.sh
# Description : A daemon plays the role of a TAFree judge client.
# Creator     : Yu Tzu Wu (abby8050@gmail.com)


# Constant
PID_JUDGER_FILE=judger.pid
PID_MONITOR_FILE=monitor.pid
LOG_JUDGER_FILE=judger.log
LOG_MONITOR_FILE=monitor.log


# Variables
ACTION=$1
PID_JUDGER=""
INTERVAL=1


# Function
monitor() {
	while true; do
		PSLINE=$(ps $PID_JUDGER | wc -l)
		if [ $PSLINE -eq 1 ]; then
			start_judger
			echo "$(date) Restart judger"
		fi	
		sleep $INTERVAL
	done
}

judger() {
	# Connect to MySQL
}

start_judger() {
	judger &> $LOG_JUDGER_FILE &
	PID_JUDGER=$!
	echo $PID_JUDGER > $PID_JUDGER_FILE
}

start_monitor() {
	monitor &> $LOG_MONITOR_FILE &
	echo $! > $PID_MONITOR_FILE
}

stop() {
	if [ -e $PID_MONITOR_FILE ]; then
		kill -9 $(cat $PID_MONITOR_FILE) 
		rm $PID_MONITOR_FILE
		echo "Monitor has stoped"		
	fi
	if [ -e $PID_JUDGER_FILE ]; then
		kill -9 $(cat $PID_JUDGER_FILE) 
		rm $PID_JUDGER_FILE
		echo "Judger has stoped"		
	fi
}


# Main
case $ACTION in
	start)
		start_judger
		start_monitor
		echo "Write log in judger.log"
		;;
	stop)
		stop
		;;
	*)
		echo "Usage: $0 {start|stop}" >&2
		exit 1
		;;
esac

exit 0;



