#!/bin/bash
# Example script to manipulate dates
# It expects lines like: Nov 12 15:17:01 test-srv *
# Usage: # ./date_manipulation.sh /var/log/syslog

echo "### Start ###"

# Get date from log file
date_time_from_log=`tail -n 1 ${1} | awk '{ print $1, $2, $3 }'`
echo "String from log file:     $date_time_from_log"

# Convert Human date to EPOCH time in seconds
date_string_to_seconds=`date -d "$date_time_from_log" +%s`
echo "Date from log in seconds: $date_string_to_seconds"

# Date now in EPOCH
date_time_now_in_seconds=`date +%s`
echo "Date_time now in seconds: $date_time_now_in_seconds"

# Result
let result=$date_time_now_in_seconds-$date_string_to_seconds
echo "It happend:               $result seconds ago"
let result_2=result/60
echo "It happend:               $result_2 minutes ago"

echo "### End ###"
