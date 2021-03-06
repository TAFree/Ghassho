#!/usr/bin/env bash


# File	      : judger.sh
# Description : A daemon plays the role of TAFree judge client.
# Creator     : Yu Tzu Wu <abby8050@gmail.com>
# License     : MIT


# Constant
PID_JUDGER_FILE=judger.pid
PID_MONITOR_FILE=monitor.pid
LOG_JUDGER_FILE=judger.log
LOG_MONITOR_FILE=monitor.log
TMP_JUDGER_DIR=.script


## For research study
TMP_RECORD_DIR=.process
##


# Variable
ACTION=$1
PID_JUDGER=""
INTERVAL=1
COMMAND="php JudgeAdapter.php"


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

start_judger() {

	## For research study 
	if [ ! -d $TMP_RECORD_DIR ]; then
		mkdir $TMP_RECORD_DIR
		chmod 777 $TMP_RECORD_DIR
	fi
	##

	if [ ! -d $TMP_JUDGER_DIR ]; then
		mkdir $TMP_JUDGER_DIR
		chmod 777 $TMP_JUDGER_DIR
	elif [ -n "$(ls -a ${TMP_JUDGER_DIR})" ]; then
		rm -rf $TMP_JUDGER_DIR/*
	fi
	$COMMAND &> $LOG_JUDGER_FILE &
	PID_JUDGER=$!
	echo $PID_JUDGER > $PID_JUDGER_FILE
}

start_monitor() {
	monitor &> $LOG_MONITOR_FILE &
	echo $! > $PID_MONITOR_FILE
}

stop() {
	if [ -e $PID_MONITOR_FILE ]; then
		kill $(cat $PID_MONITOR_FILE) 
		rm $PID_MONITOR_FILE
		echo "Monitor has stoped"		
	fi
	if [ -e $PID_JUDGER_FILE ]; then
		kill $(cat $PID_JUDGER_FILE) 
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



