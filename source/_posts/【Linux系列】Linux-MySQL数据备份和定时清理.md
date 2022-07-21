---
title: 【Linux系列】Linux-MySQL数据备份和定时清理
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 619134598
tags:
  - MySQL数据备份
categories:
  - Linux
date: 2021-06-29 10:17:58
img:
coverImg:
password:
summary:
---

最近接了个新需求，需要将我们经常使用的几个数据库，*MySQL、influxdb*在Linux系统上实现定时自动备份，比如每天备份一次，*间隔31天*清理31天之前备份的数据，研究了一下，准备先从*MySQL*实现。

*MySQL*自己已经提供了命令行导出数据库数据以及文件的一种工具*mysqldump*，其实可以通过命令行直接导出数据库数据实现备份。

~~~bash
# mysqldump用法
mysqldump -uuser -hlocalhost -ppassword database_name > test.sql
# 如果MySQL属于单机版本安装，可能会找不到mysqldump，可以将需要的命令添加软链接，可以使用通配符
sudo ln -s /server/mysql/mysql-5.7.31-linux-glibc2.12-x86_64/bin/mysqldump /usr/bin
~~~

---

## mysqldump常用操作示例

1. 备份全部数据库的数据和结构

```sql
mysqldump -uuser -hlocalhost -ppassword -A > test.sql
```

2. 备份全部数据库的结构（加 -d 参数）

```
mysqldump -uuser -hlocalhost -ppassword -A -d > test.sql
```

3. 备份全部数据库的数据(加 -t 参数)

```
mysqldump -uuser -hlocalhost -ppassword -A -t > test.sql
```

4. 备份单个数据库的数据和结构(,数据库名mydb)

```
mysqldump -uuser -hlocalhost -ppassword database_name > test.sql
```

5. 备份单个数据库的结构

```
mysqldump -uroot -p123456 database_name -d > test.sql
```

6. 备份单个数据库的数据

```
mysqldump -uuser -hlocalhost -ppassword database_name -t > test.sql
```

7. 备份多个表的数据和结构（数据，结构的单独备份方法与上同）

```
mysqldump -uuser -hlocalhost -ppassword database_name t1 t2 > test.sql
```

8. 一次备份多个数据库

```
mysqldump -uuser -hlocalhost -ppassword --databases db1 db2 > test.sql
```

---

## 还原MySQL备份数据

有两种方式还原，第一种是在*MySQL*命令行中，第二种是使用*shell*完成还原

1. 在系统命令行中，输入如下实现还原：

```sql
mysql -uuser -hlocalhost -ppassword databases_name < /test.sql
```

2. 在登录进入*mysql*命令行中,通过*source*指令找到对应系统中的文件进行还原：

```sql
mysql> source /test.sql
```

## 编写shell脚本维护备份的MySQL数据库文件

在linux中，通常使用**BASH**脚本对需要执行的内容进行编写，加上定时执行命令**crontab**实现日志自动化生成。

以下代码功能就是针对*mysql*进行备份，配合*crontab*定时任务，实现备份的内容为近10天内的每天的mysql数据库记录。

在Linux中，使用vi或者vim编写脚本内容并命名为：*mysql-dump.sh*

~~~shell
#!/bin/bash

function f_check_is_root() {
  if [ "$EUID" -ne 0 ]; then
    echo "请用root运行或使用sudo"
    exit
  fi
}

f_check_is_root
echo "=======================正在执行MySQL数据备份========================="
echo "================    __  ___      _____ ____    __ ================"
echo "================   /  |/  /_  __/ ___// __ \  / / ================"
echo "================  / /|_/ / / / /\__ \/ / / / / /  ================"
echo "================ / /  / / /_/ /___/ / /_/ / / /___================"
echo "================/_/  /_/\__, //____/\___\_\/_____/================"
echo "================       /____/                     ================"
echo "=================================================================="
# 常用变量
PACKAGE_HOME=$(pwd)
user=$(whoami)
# 保存备份个数，备份31天数据
number=31
# 备份保存路径
backup_dir=/server/data/mysql-backups
# 日期
# shellcheck disable=SC2006
date=$(date +%Y-%m-%d-%H-%M-%S)
# 备份工具
tool=mysqldump
# 用户名
username=test
# 密码
password=test
# IP地址
ip=localhost
#将要备份的数据库
database_name=test

#如果文件夹不存在则创建
if [ ! -d $backup_dir ]; then
  mkdir -p $backup_dir
fi

# 简单写法  mysqldump -uuser -ppassword zijing_monitor > /server/data/zijing_monitor-$date.sql
$tool -u $username -h$ip -p$password $database_name >$backup_dir/$database_name-$date.sql

# 写创建备份日志
echo "create $backup_dir/$database_name-$date.dupm" >>$backup_dir/log.txt

# 找出需要删除的备份
# shellcheck disable=SC2006
# shellcheck disable=SC2012
delfile=$(ls -l -crt $backup_dir/*.sql | awk '{print $9 }' | head -1)

# shellcheck disable=SC2006
# shellcheck disable=SC2012
# 判断现在的备份数量是否大于$number
count=$(ls -l -crt $backup_dir/*.sql | awk '{print $9 }' | wc -l)

if [ $count -gt $number ]; then
  # 删除最早生成的备份，只保留number数量的备份
  rm $delfile
  # 写删除文件日志
  echo "delete $delfile" >>$backup_dir/log.txt
fi
~~~

如上代码主要含义如下：

1. 首先设置各项参数，例如number最多需要备份的数目，备份路径，用户名，密码等。

2. 执行mysqldump命令保存备份文件，并将操作打印至同目录下的log.txt中标记操作日志。

3. 定义需要删除的文件：通过ls命令获取第九列，即文件名列，再通过

```bash
head -1
```

实现定义操作时间最晚的那个需要删除的文件。

4.定义备份数量：通过ls命令加上

```bash
wc -l
```

统计以sql结尾的文件的行数。

5.如果文件超出限制大小，就删除最早创建的sql文件

## 使用crontab定期执行备份脚本

在LINUX中，周期执行的任务一般由cron这个守护进程来处理[ps -ef|grep cron]。cron读取一个或多个配置文件，这些配置文件中包含了命令行及其调用时间。cron的配置文件称为“crontab”，是“cron table”的简写。

**一、cron服务**
　　cron是一个linux下 的定时执行工具，可以在无需人工干预的情况下运行作业。

~~~bash
# 启动服务
$ service crond start
# 关闭服务
$ service crond stop
# 重启服务
$ service crond restart
# 重新载入配置
$ service crond reload
# 查看服务状态 
$ service crond status
~~~

**二、创建cron脚本**

1. 写cron脚本文件,命名为*backups.cron*。
2. 添加定时任务。执行命令 “crontab crontest.cron”。搞定 
3. "crontab -l" 查看定时任务是否成功或者检测*/server/backups/backups.cron*下是否生成对应cron脚本

注意：这操作是直接替换该用户下的crontab，而不是新增

* 定期执行编写的定时任务脚本（记得先给shell脚本执行权限）

```shell
0 0 1 * * ? /server/backups/mysql-dump.sh
```

* 随后使用crontab命令定期指令编写的定时脚本

```bash
$ crontab backups.cron
```

* 再通过命令检查定时任务是否已创建：

```bash
$ crontab -l
```

## 本文参考：

1. MySQLdump常用命令：https://www.cnblogs.com/letcafe/p/mysqlautodump.html（博客园）