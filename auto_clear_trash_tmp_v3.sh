#!/bin/bash

# Check Crontab!

CRON_DIR=`echo /etc/crontab`
SHELL_NAME=`echo $0 | awk -F/ '{print $2}'`
cat $CRON_DIR | grep "$CURRENT_DIR/$SHELL_NAME" &> /dev/null
if [ $? -ne 0 ]
   then
        CURRENT_DIR=`pwd`
        chmod +x $SHELL_NAME
        echo "0 0 * * 1 root $CURRENT_DIR/$SHELL_NAME" >> $CRON_DIR
        if [ $? -ne 0 ]
           then
                echo "Crontab created error , please create to /etc/crontab manually!"
        fi
fi

# Regular Trash TMP clean up !

TRASH_DIR="/root/trash_tmp"
if [ ! -d $TRASH_DIR ]
    then
        mkdir -p $TRASH_DIR
fi

DIRSIZE=`du -s $TRASH_DIR  | awk  '{print $1}'`
MAXSIZE=$((1024*500))
LOG_FILE="/root/trash_tmp/00_trash_delete.log"
if [ ! -f $LOG_FILE ]
        then
                touch $LOG_FILE
fi

lsattr -a $LOG_FILE | grep "^\-.*a\-.*\s" &> /dev/null
if [ $? -ne 0 ]
        then
                chattr +a $LOG_FILE
fi

echo "------------------------`date`--------------------" &>> $LOG_FILE
while [ $DIRSIZE -ge $MAXSIZE ]
do
   THE_EARLIEST_FILE=`ls $TRASH_DIR -ltr | head -2 | tail -1 | awk '{print $9}' `
   \rm -rf $TRASH_DIR/$THE_EARLIEST_FILE
   if [ $? -eq 0  ]
     then
        echo -e " [^∇^*] \t Remove $THE_EARLIEST_FILE \t success!" &>> $LOG_FILE
     else
        echo -e " [X﹏X] \t Remove $THE_EARLIEST_FILE \t error!!!" &>> $LOG_FILE
   fi
   DIRSIZE=`du -s $TRASH_DIR  | awk  '{print $1}'`
done
echo "------------------------------------------------------------------------" &>> $LOG_FILE

