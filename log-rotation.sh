#!/bin/bash
# Author: Travis Tran
# Email: contact@travistran.me
# Page: https://docs.pitagon.vn/display/TECH/2019/05/04/Log+Rotation
 
# Path for message log
ACTION_LOG=/home/admin/action.log
# Path to log directory (must have / trail)
LOG_DIR=/home/admin/log_kpi/
# Number of daily log you want to keep from now
OFFSET=7
# Prefix of log file name
LOG_NAME_PREFIX=kpifull_
# Date pattern of log file name
LOG_NAME_DATE_PATTERN=%Y-%m-%d
# Suffix of log file name
LOG_NAME_SUFFIX=.log
 
 
# START
echo $(date +"%Y-%m-%d %H:%M:%S") "----------------------------" >> $ACTION_LOG
echo $(date +"%Y-%m-%d %H:%M:%S") "Start LogRotation..." >> $ACTION_LOG
for file in $(find $LOG_DIR -maxdepth 1 -name "$LOG_NAME_PREFIX*"); do
    echo $(date +"%Y-%m-%d %H:%M:%S") "Checking file: $file" >> $ACTION_LOG
    valid=0
    for ((i = 0; i <= $OFFSET; i++)); do
        dateStr=$(date --date="$i days ago" +"$LOG_NAME_DATE_PATTERN")
        logByDate="$LOG_DIR$LOG_NAME_PREFIX$dateStr$LOG_NAME_SUFFIX"
        if [ "$file" = "$logByDate" ]; then
            if [ $i = 0 ]; then
                valid=-1
                echo $(date +"%Y-%m-%d %H:%M:%S") "This file is current log." >> $ACTION_LOG
            else
                valid=1
            fi
            break
        elif [ "$file" = "$logByDate.zip" ]; then
            valid=2
            echo $(date +"%Y-%m-%d %H:%M:%S") "This file ALREADY be zipped." >> $ACTION_LOG
            break
        fi
    done
    if [ $valid = -1 ]; then
        continue
    elif [ $valid = 2 ]; then
        continue
    elif [ $valid = 0 ]; then
        echo $(date +"%Y-%m-%d %H:%M:%S") "This file is NOT in rotation range." >> $ACTION_LOG
        rm -f "$file";
        echo $(date +"%Y-%m-%d %H:%M:%S") "Deleted." >> $ACTION_LOG
    else
        echo $(date +"%Y-%m-%d %H:%M:%S") "This file is IN rotation range." >> $ACTION_LOG
        zip -q "$file.zip" "$file"
        echo $(date +"%Y-%m-%d %H:%M:%S") "Zipped." >> $ACTION_LOG
        rm -f "$file";
        echo $(date +"%Y-%m-%d %H:%M:%S") "Original log file removed." >> $ACTION_LOG
    fi
done
echo $(date +"%Y-%m-%d %H:%M:%S") "End LogRotation!!!" >> $ACTION_LOG
