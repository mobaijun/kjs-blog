---
title: 【MySQL系列】MySQL数据库备份与恢复-使用MySQLDump记录
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 2902111757
tags:
  - MySQL数据备份
categories:
  - 数据库
date: 2021-09-26 15:55:35
img:
coverImg:
password:
summary:
---

## 简介

最近接了一个新需求，需要把 `MySQL` 备份做成可视化界面进行操作，使用代码去调用 `MySQLdump` 程序进程备份，使用 `MySQL` 程序进程恢复。

因为用到了很多指令，所以参考网上找到的资料，特此记录下

后面时间多的话就把 `MySQL `可视化备份解决思路和代码贴出来，后面再说吧

> `mysqldump` 客户端可用来转储数据库或搜集数据库进行备份或将数据转移到另一个 `sql` 服务器(不一定是一个 `mysql` 服务器)。转储包含创建表和/或装载表的sql语句。

* 如果在服务器上进行备份，并且表均为 `myisam` 表，应考虑使用 `mysqlhotcopy` ，因为可以更快地进行备份和恢复。

## 前言

本文从三部分介绍 `mysql ` 数据备份与恢复：

* 第一，`mysql` 基本常识；
* 第二，数据备份与恢复示例；
* 第三，`mysqldump` 具体参数说明。

## 一、MySql 基本常识

### 1、连接`mysql`

~~~bash
$ 格式： mysql -h主机地址 -u用户名 －p用户密码
~~~

1. 连接到本机上的`MYSQL`

~~~bash
# 回车后提示你输密码，如果刚安装好MYSQL，超级用户root是没有密码的，故回车即可进入到MYSQL中了，MYSQL的提示符是：mysql>
$ mysql -uroot -p
~~~

2. 连接到远程主机上的`MYSQL`

```bash
# 假设远程主机的IP为：127.0.0.1，用户名为root,密码为12356。则键入以下命令：
$  mysql -h127.0.0.1 -uroot -p12356
# （注：u与root可以不用加空格，其它也一样）
```

3. 退出`MYSQL`命令

```bash
# 退出命令
$ exit && \q
```

### 2、常见命令：

~~~bash
1、显示数据库列表：
$ show databases;
# 刚开始时才两个数据库：mysql和test。mysql库很重要它里面有MYSQL的系统信息，我们改密码和新增用户，实际上就是用这个库进行操作。

2、显示库中的数据表：
$ use mysql; // 打开库
# 显示所有表
$ show tables;

3、显示数据表的结构：
$ describe 表名;
# 简写：desc 表名

4、建库：
$ create database 库名;

5、建表：
use 库名;
$ create table 表名 (字段设定列表);

6、删库和删表:
$ drop database 库名;

$ drop table 表名;
7、将表中记录清空：
$ delete from 表名;

8、显示表中的记录：
$ select * from 表名;

9、mysqldump 程序帮助命令
$ mysqldump --help
~~~

## 二、数据备份与恢复

### 1、备份：从数据库导出数据：

  ~~~bash
  $ mysqldump -h链接ip -P(大写)端口 -u用户名 -p密码数据库名 > xxxx.sql(路径)
  ~~~

> 示例：`mysqldump -h127.0.0.1 -P3307 -uroot -p8888 test > test.sql;`

### 2、备份导出示例：

1、导出数据和表结构——将特定数据库特定表中的数据和表格结构和数据全部返回

~~~bash
$ mysqldump -uroot -h127.0.0.1 -padmin -P3306 test up_subjects > test.sql
~~~

2、导出表结构却不导出表数据——只返回特定数据库特定表格的表格结构，不返回数据,添加“-d”命令参数

~~~bash
$ mysqldump -uroot -h127.0.0.1 -padmin -P3306 -d test up_subjects > test.sql
~~~

3、导出表结构和满足挑顶条件的表数据——只返回特定数据库中特定表的表格结构和满足特定条件的数据

~~~bash
$ mysqldump -uroot -h127.0.0.1 -padmin -P3306 test up_subjects --where="ctime>'2017-01-01' and ctime<'2017-06-30'" >test.sql
~~~

4、导出数据却不导出表结构——只返回特定数据库中特定表格的数据，不返回表格结构，添加“-t”命令参数

~~~bash
$ mysqldump -uroot -h127.0.0.1 -padmin -t -P3306 test up_subjects >test.sql
~~~

5、导出特定数据库的所有表格的表结构及其数据，添加“--databases ”命令参数

~~~bash
$ mysqldump -uroot -h127.0.0.1 -padmin -P3306 --databases test > test.sql
~~~

### 3、恢复导入数据库数据：

> 将导出的本地文件导入到指定数据库

1、系统命令行

~~~bash
# 格式：mysql -h链接ip -P(大写)端口 -u用户名 -p密码 数据库名 < d:XX.sql(路劲) 
$ mysql -uusername -ppassword test < test.sql
~~~

2、或`mysql`命令行

~~~bash
mysql>
# 选择数据库
user test;
# 导入sql
source test.sql;
~~~

3、恢复整个数据库的方法：

~~~bash
$ mysql -uroot -h127.0.0.1 -padmin -P3306 < test.sql
~~~

### 4、具体恢复示例：

  1、先登录该`MySQL`服务器，切换要导入数据的数据、具体命令如下：

~~~bash
mysql> use test;

mysql> source /home/test/test.sql

Query OK, 0 rows affected (0.01 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 9 rows affected (0.00 sec)

Records: 9 Duplicates: 0  Warnings: 0
~~~

> 注释：表示影响的记录为9行，重复的记录有0行，警告的记录有0个

2、直接使用系统命令行

~~~bash
$ mysql -uroot -h127.0.0.1 -padmin -P3306 test < /home/test/test.sql
~~~

## 三、mysqldump参数说明

1. `mysqldump`字符集设置

~~~bash
$ mysqldump -uusername -ppassword --default-character-set=gb2312 db1 table1 > tb1.sql
~~~

>   `mysqldump`客户端可用来转储数据库或搜集数据库进行备份或将数据转移到另一个`sql`服务器(不一定是一个`mysql`服务器)。转储包含创建表和/或装载表的`sql`语句。

如果在服务器上进行备份，并且表均为`myisam`表，应考虑使用[mysqlhotcopy](https://dev.mysql.com/doc/refman/5.6/en/mysqlhotcopy.html)，因为可以更快地进行备份和恢复。

* 可以使用 mysqldump –help查看所有参数

~~~bash
$ mysqldump --help
~~~

1、--all-databases  , -A

> 导出全部数据库。

~~~bash
$ mysqldump -uroot -p --all-databases
~~~

2、--all-tablespaces  , -Y

> 导出全部表空间。

~~~bash
$ mysqldump -uroot -p --all-databases --all-tablespaces
~~~

3、--no-tablespaces  , -y

> 不导出任何表空间信息。

~~~bash
$ mysqldump -uroot -p --all-databases --no-tablespaces
~~~

4、--add-drop-database

> 每个数据库创建之前添加`drop`数据库语句。

~~~bash
$ mysqldump -uroot -p --all-databases --add-drop-database
~~~

5、--add-drop-table

> 每个数据表创建之前添加`drop`数据表语句。(默认为打开状态，使用`--skip-add-drop-table`取消选项)

~~~bash
# (默认添加drop语句)
$ mysqldump -uroot -p --all-databases
# (取消drop语句)
$ mysqldump -uroot -p --all-databases –skip-add-drop-table
~~~

6、--add-locks

> 在每个表导出之前增加`LOCK TABLES`并且之后`UNLOCK  TABLE`。(默认为打开状态，使用`--skip-add-locks`取消选项)

~~~bash
# (默认添加LOCK语句)
$ mysqldump -uroot -p --all-databases
# (取消LOCK语句)
$ mysqldump -uroot -p --all-databases –skip-add-locks
~~~

7、--allow-keywords

> 允许创建是关键词的列名字。这由表名前缀于每个列名做到。

~~~bash
$ mysqldump -uroot -p --all-databases --allow-keywords
~~~

8、--apply-slave-statements

> 在`'CHANGE MASTER'`前添加`'STOP SLAVE'`，并且在导出的最后添加`'START SLAVE'`。

~~~bash
$ mysqldump -uroot -p --all-databases --apply-slave-statements
~~~

9、-character-sets-dir

> 字符集文件的目录

~~~bash
$ mysqldump -uroot -p --all-databases --character-sets-dir=/usr/local/mysql/share/mysql/charsets
~~~

10、--comments

> 附加注释信息。默认为打开，可以用`--skip-comments`取消

~~~bash
#  (默认记录注释)
$ mysqldump -uroot -p --all-databases
# (取消注释)
$ mysqldump -uroot -p --all-databases --skip-comments   
~~~

11、--compatible

> 导出的数据将和其它数据库或旧版本的`MySQL`相兼容。值可以为`ansi、mysql323、mysql40、postgresql、oracle、mssql、db2、maxdb、no_key_options、no_tables_options、no_field_options`等，要使用几个值，用逗号将它们隔开。它并不保证能完全兼容，而是尽量兼容。

~~~bash
$ mysqldump -uroot -p --all-databases --compatible=ansi
~~~

12、--compact

> 导出更少的输出信息(用于调试)。去掉注释和头尾等结构。可以使用选项：`--skip-add-drop-table --skip-add-locks --skip-comments --skip-disable-keys`

~~~bash
$ mysqldump -uroot -p --all-databases --compact
~~~

13、--complete-insert,  -c

> 使用完整的insert语句(包含列名称)。这么做能提高插入效率，但是可能会受到`max_allowed_packet`参数的影响而导致插入失败。

~~~bash
$ mysqldump -uroot -p --all-databases --complete-insert
~~~

14、--compress, -C

> 在客户端和服务器之间启用压缩传递所有信息

~~~bash
$ mysqldump -uroot -p --all-databases --compress
~~~

15、--create-options,  -a

> 在`CREATE TABLE`语句中包括所有`MySQL`特性选项。(默认为打开状态)

~~~bash
$ mysqldump -uroot -p --all-databases
~~~

16、--databases,  -B

> 导出几个数据库。参数后面所有名字参量都被看作数据库名。

~~~bash
$ mysqldump -uroot -p --databases test mysql
~~~

17、--debug

> 输出`debug`信息，用于调试。默认值为：`d:t,/tmp/mysqldump.trace`

~~~bash
$ mysqldump -uroot -p --all-databases --debug
# 默认值
$ mysqldump -uroot -p --all-databases --debug=” d:t,/tmp/debug.trace”
~~~

18、`--debug-check`

> 检查内存和打开文件使用说明并退出。

~~~bash
$ mysqldump -uroot -p --all-databases --debug-check
~~~

19、`--debug-info`

> 输出调试信息并退出

~~~bash
$ mysqldump -uroot -p --all-databases --debug-info
~~~

20、`--default-character-set`

> 设置默认字符集，默认值为`utf8`

~~~bash
$ mysqldump -uroot -p --all-databases --default-character-set=utf8
~~~

21、--delayed-insert

> 采用延时插入方式（`INSERT DELAYED`）导出数据

~~~bash
$ mysqldump -uroot -p --all-databases --delayed-insert
~~~

22、--delete-master-logs

> `master`备份后删除日志. 这个参数将自动激活`--master-data`。

~~~bash
$ mysqldump -uroot -p --all-databases --delete-master-logs
~~~

23、--disable-keys

> 对于每个表，用/*!40000 ALTER TABLE tbl_name DISABLE KEYS */;和/*!40000ALTER TABLE tbl_name ENABLE KEYS */;语句引用`INSERT`语句。这样可以更快地导入`dump`出来的文件，因为它是在插入所有行后创建索引的。该选项只适合`MyISAM`表，默认为打开状态。

~~~bash
$ mysqldump -uroot -p --all-databases
~~~

24、--dump-slave

> 该选项将主的`binlog`位置和文件名追加到导出数据的文件中(`show slave status`)。设置为`1`时，将会以`CHANGE MASTER`命令输出到数据文件；设置为`2`时，会在`change`前加上注释。该选项将会打开`--lock-all-tables`，除非`--single-transaction`被指定。该选项会自动关闭`--lock-tables`选项。默认值为0。

~~~bash
$ mysqldump -uroot -p --all-databases --dump-slave=1

$ mysqldump -uroot -p --all-databases --dump-slave=2
~~~

25、--master-data

> 该选项将当前服务器的`binlog`的位置和文件名追加到输出文件中(`show master status`)。如果为`1`，将会输出`CHANGE MASTER` 命令；如果为`2`，输出的`CHANGE  MASTER`命令前添加注释信息。该选项将打开`--lock-all-tables` 选项，除非`--single-transaction`也被指定（在这种情况下，全局读锁在开始导出时获得很短的时间；其他内容参考下面的`--single-transaction`选项）。该选项自动关闭`--lock-tables`选项。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --master-data=1;

$ mysqldump -uroot -p --host=localhost --all-databases --master-data=2;
~~~

26、--events, -E

> 导出事件。

~~~bash
$ mysqldump -uroot -p --all-databases --events
~~~

27、--extended-insert,  -e

> 使用具有多个`VALUES`列的`INSERT`语法。这样使导出文件更小，并加速导入时的速度。默认为打开状态，使用`--skip-extended-insert`取消选项。

~~~bash
$ mysqldump -uroot -p --all-databases
# (取消选项)
$ mysqldump -uroot -p --all-databases--skip-extended-insert   
~~~

28、--fields-terminated-by

> 导出文件中忽略给定字段。与`--tab`选项一起使用，不能用于`--databases`和`--all-databases`选项

~~~bash
$ mysqldump -uroot -p test test --tab=”/home/mysql” --fields-terminated-by=”#”
~~~

29、--fields-enclosed-by

> 输出文件中的各个字段用给定字符包裹。与`--tab`选项一起使用，不能用于`--databases`和`--all-databases`选项

~~~bash
$ mysqldump -uroot -p test test --tab=”/home/mysql” --fields-enclosed-by=”#”
~~~

30、--fields-optionally-enclosed-by

> 输出文件中的各个字段用给定字符选择性包裹。与`--tab`选项一起使用，不能用于`--databases`和`--all-databases`选项

~~~bash
$ mysqldump -uroot -p test test --tab=”/home/mysql” --fields-enclosed-by=”#” --fields-optionally-enclosed-by  =”#”
~~~

31、--fields-escaped-by

> 输出文件中的各个字段忽略给定字符。与`--tab`选项一起使用，不能用于`--databases`和`--all-databases`选项

~~~bash
$ mysqldump -uroot -p mysql user --tab=”/home/mysql” --fields-escaped-by=”#”
~~~

32、--flush-logs

> 开始导出之前刷新日志。
>
> 请注意：假如一次导出多个数据库(使用选项`--databases`或者`--all-databases`)，将会逐个数据库刷新日志。除使用`--lock-all-tables`或者`--master-data`外。在这种情况下，日志将会被刷新一次，相应的所以表同时被锁定。因此，如果打算同时导出和刷新日志应该使用`--lock-all-tables`或者`--master-data`和`--flush-logs`。

~~~bash
$ mysqldump -uroot -p --all-databases --flush-logs
~~~

33、--flush-privileges

> 在导出`mysql`数据库之后，发出一条`FLUSH  PRIVILEGES`语句。为了正确恢复，该选项应该用于导出`mysql`数据库和依赖`mysql`数据库数据的任何时候。

~~~bash
$ mysqldump -uroot -p --all-databases --flush-privileges
~~~

34、--force

> 在导出过程中忽略出现的`SQL`错误。

~~~bash
$ mysqldump -uroot -p --all-databases --force
~~~

36、--help

显示帮助信息并退出。

~~~bash
$ mysqldump --help
~~~

37、--hex-blob

> 使用十六进制格式导出二进制字符串字段。如果有二进制数据就必须使用该选项。影响到的字段类型有`BINARY、VARBINARY、BLOB`。

~~~bash
$ mysqldump -uroot -p --all-databases --hex-blob
~~~

38、--host, -h

> 需要导出的主机信息

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases
~~~

39、--ignore-table

> 不导出指定表。指定忽略多个表时，需要重复多次，每次一个表。每个表必须同时指定数据库和表名。例如：`--ignore-table=database.table1 --ignore-table=database.table2 ……`

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --ignore-table=mysql.user
~~~

40、--include-master-host-port

> 在`--dump-slave`产生的'`CHANGE  MASTER TO..`'语句中增加`'MASTER_HOST=<host>，MASTER_PORT=<port>`' 

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --include-master-host-port
~~~

41、--insert-ignore

> 在插入行时使用`INSERT IGNORE`语句.

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --insert-ignore
~~~

42、--lines-terminated-by

> 输出文件的每行用给定字符串划分。与`--tab`选项一起使用，不能用于`--databases`和`--all-databases`选项。

~~~bash
$ mysqldump -uroot -p --host=localhost test test --tab=”/tmp/mysql”  --lines-terminated-by=”##”
~~~

43、--lock-all-tables,  -x

> 提交请求锁定所有数据库中的所有表，以保证数据的一致性。这是一个全局读锁，并且自动关闭`--single-transaction`和`--lock-tables`选项。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --lock-all-tables
~~~

44、--lock-tables,  -l

> 开始导出前，锁定所有表。用`READ  LOCAL`锁定表以允许`MyISAM`表并行插入。对于支持事务的表例如`InnoDB`和`BDB`，`--single-transaction`是一个更好的选择，因为它根本不需要锁定表。
>
> 请注意当导出多个数据库时，`--lock-tables`分别为每个数据库锁定表。因此，该选项不能保证导出文件中的表在数据库之间的逻辑一致性。不同数据库表的导出状态可以完全不同。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --lock-tables
~~~

45、--log-error

> 附加警告和错误信息到给定文件

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases  --log-error=/tmp/mysqldump_error_log.err
~~~

46、--max_allowed_packet

> 服务器发送和接受的最大包长度。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --max_allowed_packet=10240
~~~

47、--net_buffer_length

> `TCP/IP`和`socket`连接的缓存大小。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --net_buffer_length=1024
~~~

48、--no-autocommit

> 使用`autocommit/commit`语句包裹表。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --no-autocommit
~~~

49、--no-create-db,  -n

> 只导出数据，而不添加`CREATE DATABASE`语句。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --no-create-db
~~~

50、--no-create-info,  -t

> 只导出数据，而不添加`CREATE TABLE`语句。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --no-create-info
~~~

51、--no-data, -d

> 不导出任何数据，只导出数据库表结构。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --no-data
~~~

52、--no-set-names,  -N

> 等同于`--skip-set-charset`

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --no-set-names
~~~

53、--opt

> 等同于`--add-drop-table, --add-locks, --create-options, --quick, --extended-insert,--lock-tables,  --set-charset,--disable-keys` 该选项默认开启,  可以用`--skip-opt`禁用.

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --opt
~~~

54、--order-by-primary

> 如果存在主键，或者第一个唯一键，对每个表的记录进行排序。在导出`MyISAM`表到`InnoDB`表时有效，但会使得导出工作花费很长时间。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --order-by-primary
~~~

55、--password, -p

> 连接数据库密码

56、--pipe(windows系统可用)

> 使用命名管道连接`mysql`

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --pipe
~~~

57、--port, -P

> 连接数据库端口号

~~~bash
# 注意是大写P
$ mysqldump -uroot  -Plocalhost -ppassword
~~~

58、--protocol

> 使用的连接协议，包括：`tcp, socket, pipe, memory.`

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --protocol=tcp
~~~

59、--quick, -q

> 不缓冲查询，直接导出到标准输出。默认为打开状态，使用`--skip-quick`取消该选项。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases

$ mysqldump -uroot -p --host=localhost --all-databases --skip-quick
~~~

60、--quote-names,-Q

> 使用（`）引起表和列名。默认为打开状态，使用`--skip-quote-names`取消该选项。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases

$ mysqldump -uroot -p --host=localhost --all-databases --skip-quote-names
~~~

61、--replace

> 使用`REPLACE INTO` 取代`INSERT INTO`.

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --replace
~~~

62、--result-file,  -r

> 直接输出到指定文件中。该选项应该用在使用回车换行对`（\\r\\n）`换行的系统上（例如：`DOS，Windows`）。该选项确保只有一行被使用。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases--result-file=/tmp/mysqldump_result_file.txt
~~~

63、--routines, -R

> 导出存储过程以及自定义函数。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --routines
~~~

64、--set-charset

> 添加`'SET NAMES default_character_set'`到输出文件。默认为打开状态，使用`--skip-set-charset`关闭选项。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases

$ mysqldump -uroot -p --host=localhost --all-databases --skip-set-charset
~~~

65、--single-transaction

> 该选项在导出数据之前提交一个`BEGIN SQL`语句，`BEGIN`不会阻塞任何应用程序且能保证导出时数据库的一致性状态。它只适用于多版本存储引擎，仅`InnoDB`。本选项和`--lock-tables`选项是互斥的，因为`LOCK  TABLES`会使任何挂起的事务隐含提交。要想导出大表的话，应结合使用`--quick`选项。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --single-transaction
~~~

66、--dump-date

> 将导出时间添加到输出文件中。默认为打开状态，使用`--skip-dump-date`关闭选项。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases

$ mysqldump -uroot -p --host=localhost --all-databases --skip-dump-date
~~~

67、--skip-opt

> 禁用`–opt`选项.

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --skip-opt
~~~

68、--socket,-S

> 指定连接`mysql`的`socket`文件位置，默认路径`/tmp/mysql.sock`

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --socket=/tmp/mysqld.sock
~~~

69、--tab,-T

> 为每个表在给定路径创建`tab`分割的文本文件。注意：仅仅用于`mysqldump`和`mysqld`服务器运行在相同机器上。注意使用`--tab`不能指定`--databases`参数

~~~bash
$ mysqldump -uroot -p --host=localhost test test --tab="/home/mysql"
~~~

70、--tables

> 覆盖`--databases (-B)`参数，指定需要导出的表名，在后面的版本会使用`table`取代`tables`。

~~~bash
$ mysqldump -uroot -p --host=localhost --databases test --tables test
~~~

71、--triggers

> 导出触发器。该选项默认启用，用`--skip-triggers`禁用它。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --triggers
~~~

72、--tz-utc

> 在导出顶部设置时区`TIME_ZONE='+00:00' `，以保证在不同时区导出的`TIMESTAMP`数据或者数据被移动其他时区时的正确性。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --tz-utc
~~~

73、--user, -u

> 指定连接的用户名。

74、--verbose, --v

> 输出多种平台信息。

75、--version, -V

> 输出`mysqldump`版本信息并退出

76、--where, -w

> 只转储给定的`WHERE`条件选择的记录。请注意如果条件包含命令解释符专用空格或字符，一定要将条件引用起来。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --where=” user=’root’”
~~~

77、--xml, -X

> 导出XML格式.

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases --xml
~~~

78、--plugin_dir

> 客户端插件的目录，用于兼容不同的插件版本。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases--plugin_dir=”/usr/local/lib/plugin”
~~~

79、--default_auth

> 客户端插件默认使用权限。

~~~bash
$ mysqldump -uroot -p --host=localhost --all-databases--default-auth=”/usr/local/lib/plugin/<PLUGIN>”
~~~

---

参考文章链接：

> [MySql数据库备份与恢复——使用mysqldump 导入与导出方法总结_helloxiaozhe的博客-CSDN博客_mysqldump导出数据库](https://blog.csdn.net/helloxiaozhe/article/details/77680255)
>
> [MySQL :: MySQL Backup and Recovery :: 1.4.1 Dumping Data in SQL Format with mysqldump](https://dev.mysql.com/doc/mysql-backup-excerpt/5.6/en/mysqldump-sql-format.html)

