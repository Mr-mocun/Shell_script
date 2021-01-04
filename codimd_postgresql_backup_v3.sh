#!/bin/bash
# Restore database : `cat your_dump.sql | docker exec -i your-db-container psql -U postgres`

# Check Crontab!

CRON_DIR=`echo /etc/crontab`
SHELL_NAME=`echo $0 | awk -F/ '{print $2}'`
cat $CRON_DIR | grep "$CURRENT_DIR/$SHELL_NAME" &> /dev/null
if [ $? -ne 0 ]
   then
        CURRENT_DIR=`pwd`
        chmod +x $SHELL_NAME
        echo "0 0 */1 * * root $CURRENT_DIR/$SHELL_NAME" >> $CRON_DIR
        if [ $? -ne 0 ]
           then
                echo "Crontab created error , please create to /etc/crontab manually!"
        fi
fi

# Backup codimarkdown databse Daily!

BACKUP_DIR=`echo /root/Backup/sql_backup/codimd_sql_backup`
CONTAINER_ID=`docker ps -q --filter ancestor=postgres:11.6-alpine`

if [ ! -d $BACKUP_DIR ]
    then
        mkdir -p $BACKUP_DIR
fi

docker exec -t $CONTAINER_ID pg_dumpall -c -U codimd > $BACKUP_DIR/codimd_pgdump_`date +%Y-%m-%d"_"%H_%M_%S`.sql

if [ $? -eq 0  ]
    then
        echo -e " [^∇^*] \t `date +%Y-%m-%d"_"%H_%M_%S` \t success!" &>> $BACKUP_DIR/00_codimd_pgdump.log
        echo "-----------------------------------------------------" &>> $BACKUP_DIR/00_codimd_pgdump.log
    else
        echo -e " [X﹏X] \t `date +%Y-%m-%d"_"%H_%M_%S` \t error!!!" &>> $BACKUP_DIR/00_codimd_pgdump.log
        echo "-----------------------------------------------------" &>> $BACKUP_DIR/00_codimd_pgdump.log
fi

# Regular codimarkdown database clean up !

DIRSIZE=`du -s $BACKUP_DIR  | awk  '{print $1}'`
MAXSIZE=$((1024*200))
while [ $DIRSIZE -ge $MAXSIZE ]
do
   THE_EARLIEST_SQL=`ls $BACKUP_DIR -l | head -3 | tail -1 | awk '{print $9}'`
   \rm -rf $BACKUP_DIR/$THE_EARLIEST_SQL

   if [ $? -eq 0  ]
     then
        echo -e " [^∇^*] \t Remove $THE_EARLIEST_SQL \t success!" &>> $BACKUP_DIR/00_codimd_pgdump.log
     else
        echo -e " [X﹏X] \t Remove $THE_EARLIEST_SQL \t error!!!" &>> $BACKUP_DIR/00_codimd_pgdump.log
   fi
   DIRSIZE=`du -s $BACKUP_DIR  | awk  '{print $1}'`
done
echo "-----------------------------------------------------" &>> $BACKUP_DIR/00_codimd_pgdump.log
