#! /bin/bash
# Description: 替换rm命令，不是删除文件，而是移动文件到/root/trash_tmp/

TRASH_DIR="/root/trash_tmp"

for i in $*; do
    STAMP=`date +%F-%T`
    FileName=`basename $i`
    mv $i $TRASH_DIR/$FileName"_"$STAMP
done
