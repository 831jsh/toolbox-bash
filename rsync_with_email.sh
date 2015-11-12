#!/bin/bash
# Script sync 2 locations with writing full log and sends report by email.

###########################
###      Variables      ###
###########################

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
    echo "Usage: rsync_with_email.sh '/source/' '/destination/' 'log_name' 'email1@example.com,email2@example.com'"
    exit 1
fi

SOURCE=$1
DESTINATION=$2
LOG_NAME=$3
EMAIL=$4

FULL_LOG="/var/log/rsync_${LOG_NAME}_full.log"
STATUS_LOG="/var/log/rsync_${LOG_NAME}_status.log"
SCRIPT_NAME=`basename $0`

###########################
###  Create status log  ###
###########################

echo "Start time:  `date '+%Y-%m-%d %H:%M:%S'`" > $STATUS_LOG
echo "" >> $STATUS_LOG
echo "Hostname:    `hostname`" >> $STATUS_LOG
echo "Source:      $SOURCE" >> $STATUS_LOG
echo "Destination: $DESTINATION" >> $STATUS_LOG
echo "" >> $STATUS_LOG
echo "Time output: " >> $STATUS_LOG

###########################
###        Rsync       ####
###########################

( time /usr/bin/rsync -rav --delete-after $SOURCE $DESTINATION 2>&1 > $FULL_LOG ) >> $STATUS_LOG 2>&1
exit_code=$?

###########################
### Finalise status log ###
###########################

echo "" >> $STATUS_LOG
echo "Finish time: `date '+%Y-%m-%d %H:%M:%S'`" >> $STATUS_LOG
echo "" >> $STATUS_LOG
echo -n "Status: " >> $STATUS_LOG
if [ $exit_code -eq 0 ]; then
    echo "OK successful, exit code = $exit_code" >> $STATUS_LOG
elif [ $exit_code -eq 24 ]; then
    echo "WARNING source changed, exit code = $exit_code >> $STATUS_LOG
else
    echo "CRITICAL failed, exit code = $exit_code >> $STATUS_LOG
fi
echo "" >> $STATUS_LOG
echo "Full log: " `hostname` " " $FULL_LOG >> $STATUS_LOG

###########################
###  Send status email  ###
###########################

tail -n 30 $STATUS_LOG | mail -s "${SCRIPT_NAME} ${LOG_NAME}" $EMAIL
