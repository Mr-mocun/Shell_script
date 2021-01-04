# Shell_script
更新一些日常使用的脚本

## codimd_postgresql_backup_v3.sh
主要实现如下几点功能：
1. 创建该脚本的计划任务，每天执行一次；
2. 日常备份 Codimd 的备份数据库；
3. 检测备份文件夹得大小，超过阈值时，从最早的数据库备份文件开始删除；
4. 同时在备份文件夹下生成日志。

### 使用说明
```bash
root@icloud: ~/shell_script# chmod +x codimd_postgresql_backup_v3.sh
root@icloud: ~/shell_script# ./codimd_postgresql_backup_v3.sh
```
## delete.sh 和 auto_clear_trash_tmp_v3.sh
主要实现如下功能：
1. 手工替换 rm 命令，将 rm 命令替换为 mv 命令；
2. 创建回收站目录；
3. 创建该脚本的计划任务，每周一执行一次；
4. 日常清理回收站，超过阈值时，从最早的删除文件开始删除；
5. 同时在回收站文件夹下生成日志，并对日志文件追加锁。

### 使用说明
```bash
root@icloud: ~/shell_script# vim /root/.bashrc
# 添加最后一行 alias rm='sh  /root/shell_script/delete.sh'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias rm='sh  /root/shell_script/delete.sh'
root@icloud: ~/shell_script# source /root/.bashrc
```
后续如果需要删除文件，仅需 `rm 文件名` 即可，如果需要强制使用 `rm` 命令，可以使用 `\` 转义，即 `\rm -rf 文件名`

## 持续更新中……
