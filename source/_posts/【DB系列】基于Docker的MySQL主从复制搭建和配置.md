---
title: 【DB系列】基于Docker的MySQL主从复制搭建和配置
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 572796845
tags:
  - MySQL主从搭建
categories:
  - 数据库
date: 2022-08-18 09:21:43
img:
coverImg:
password:
summary:
---

## 前言

> 为什么基于 Docker 搭建 MySQL ？
>
> * 在 Linux 服务器中以系统安装 MySQL 比较繁琐
> * 一台服务器可以独立运行多个 Docker 容器
> * Docker 容器之间相互独立，有独立 ip，互不冲突
> * Docker 使用步骤简便，启动容器在秒级别

## 环境准备：

### 主库

* 运行主库

~~~bash
$ docker run --restart=always -d --name=mysql --privileged=true -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root -v /usr/local/mysql/my.cnf:/etc/mysql/my.cnf -v /usr/local/mysql/logs:/var/log/mysql -v /usr/local/mysql/data:/var/lib/mysql -v /etc/localtime:/etc/localtime mysql
~~~

* 配置主库

> 修改挂载的配置文件

~~~properties
[root@mobai data]# cat /usr/local/mysql-master/my.cnf 
[mysqld]  
# 设置server_id,注意要唯一
server-id=2022
# 开启二进制日志功能 
log-bin=mysql-master
# relay_log配置中继日志
relay_log=edu-mysql-relay-bin
~~~

### 从库

* 运行从库

~~~bash
$ docker run --restart=always -d --name=mysql --privileged=true -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root -v /usr/local/mysql/my.cnf:/etc/mysql/my.cnf -v /usr/local/mysql/logs:/var/log/mysql -v /usr/local/mysql/data:/var/lib/mysql -v /etc/localtime:/etc/localtime mysql
~~~

* 配置从库

~~~properties
[root@mobaijun mysql]# cat /usr/local/mysql/my.cnf 
[mysqld]
server-id=100  
# 开启二进制日志功能
log-bin=mysql-bin
~~~

## 重启主从库

~~~bash
$ docker restart 容器id
~~~

## 注意事项：

> 首先在主从没有生效的时候，要保持两台服务器数据库、表相同，数据相同

## 主从库用户权限分配

> <font color="#dc143c">分别在两台服务器 MySQL 8 中创建用户，授予权限。</font>

* 查询所有用户

~~~sql
SELECT `user`
	,
`HOST` 
FROM
	mysql.`user`;
~~~

* 在主从库分别重复一下步骤

~~~sql
# 创建同步用户
CREATE USER 'april-synchronize' @'%' IDENTIFIED BY 'april-synchronize123!@';
# 分配用户权限（全部权限）
GRANT ALL PRIVILEGES ON *.* TO 'april-synchronize' @'%';
# 也可也分配增删改查权限和 slave 权限
GRANT SELECT, DELETE,UPDATE,INSERT,REPLICATION SLAVE, REPLICATION CLIENT,REPLICATION_SLAVE_ADMIN ON *.* TO 'april-synchronize' @'%';
# 授予复制账号 REPLICATION CLIENT 权限，复制用户可以使用 SHOW MASTER STATUS, SHOW SLAVE STATUS 和 SHOW BINARY LOGS 来确定复制状态。
# 授予复制账号 REPLICATION SLAVE 权限，复制才能真正地工作。
-------------------------------------------------------------------------------------------------------------
# 刷新权限
FLUSH PRIVILEGES;
# 查询用户权限
SHOW GRANTS FOR 'april-synchronize' @'%';
-------------------------------------------------------------------------------------------------------------
# 删除用户
DROP USER 'april-synchronize' @'%';
~~~

## 主从链接

* 在主库命令行进入MySQL

~~~bash
$ show master status;
~~~

~~~bash
+---------------------+----------+--------------+------------------+-------------------+
| File                | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+---------------------+----------+--------------+------------------+-------------------+
| mysql-master.000003 |   312957 |              |                  |                   |
+---------------------+----------+--------------+------------------+-------------------+
~~~

> File 和 Position 字段的值后面将会用到，在后面的操作完成之前，需要保证主库不能做任何操作，否则将会引起状态变化，File 和 Position 字段的值变化。
>

* 从库

进入命令行，执行以下内容

~~~bash
CHANGE MASTER TO master_host = '172.17.0.3',
master_user = 'april-synchronize',
master_password = 'april-synchronize123!@',
master_port = 3306,
master_log_file = 'mysql-master.000003',
master_log_pos = 312957,
master_connect_retry = 30;
~~~

> 参数说明：
> master_host ：主库的IP地址
>
> master_port：主库的端口号，指的是容器的端口号
> master_user：用于数据同步的用户
> master_password：用于同步的用户的密码
> master_log_file：指定从库从哪个日志文件开始复制数据，即上文中提到的 File 字段的值
> master_log_pos：从哪个 Position 开始读，即上文中提到的 Position 字段的值
> master_connect_retry：如果连接失败，重试的时间间隔，单位是秒，默认是 60 秒

* 在从库中的 mysql 终端执行 show slave status \G; 用于查看主从同步状态。

~~~bash
mysql> show slave status \G;
*************************** 1. row ***************************
               Slave_IO_State: Waiting for source to send event
                  Master_Host: 172.17.0.2
                  Master_User: april-master
                  Master_Port: 3309
                Connect_Retry: 30
              Master_Log_File: mysql-master.000003
          Read_Master_Log_Pos: 164307
               Relay_Log_File: d856863ac1d2-relay-bin.000002
                Relay_Log_Pos: 329
        Relay_Master_Log_File: mysql-master.000003
             Slave_IO_Running: NO
            Slave_SQL_Running: NO
              Replicate_Do_DB: 
          Replicate_Ignore_DB: 
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 164307
              Relay_Log_Space: 546
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Master_Server_Id: 2022
                  Master_UUID: a993626d-1e9a-11ed-a66e-0242ac110003
             Master_Info_File: mysql.slave_master_info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Replica has read all relay log; waiting for more updates
           Master_Retry_Count: 86400
                  Master_Bind: 
      Last_IO_Error_Timestamp: 
     Last_SQL_Error_Timestamp: 
               Master_SSL_Crl: 
           Master_SSL_Crlpath: 
           Retrieved_Gtid_Set: 
            Executed_Gtid_Set: 
                Auto_Position: 0
         Replicate_Rewrite_DB: 
                 Channel_Name: 
           Master_TLS_Version: 
       Master_public_key_path: 
        Get_master_public_key: 0
            Network_Namespace: 
~~~

> 正常情况下，Slave_IO_Running 和 Slave_SQL_Running 都是 No，因为我们还没有开启主从复制过程。

* 使用 `start slave` 开启主从复制过程，然后再次查询主从同步状态 `show slave status \G;`

如果在开启主从的过程中显示权限不足，按照上面步骤添加 `REPLICATION_SLAVE_ADMIN` 权限，然后刷新即可。报错信息如下：

~~~bash
Access denied; you need (at least one of) the SUPER or REPLICATION_SLAVE_ADMIN privilege(s) for this operation
~~~

* 修改权限，添加 `REPLICATION_SLAVE_ADMIN`

~~~sql
GRANT SELECT, DELETE,UPDATE,INSERT,REPLICATION SLAVE, REPLICATION CLIENT, REPLICATION_SLAVE_ADMIN ON *.* TO 'luban-synchronize' @'%';
~~~

* 查看主从状态

~~~bash
$ show slave status \G;
~~~

类似下图

![](https://tencent.cos.mobaijun.com/img/blog/【DB系列】基于Docker的MySQL主从复制搭建和配置/0.png)

> Slave_IO_Running 和 Slave_SQL_Running 都是 Yes，说明主从复制已经开启。此时可以测试数据同步是否成功。如果需要主从双向同步，在主库重复以上操作即可，一主多从，多主多从操做都是一样的，注意用户账号密码/及服务器 IP 端口正确。

* 双向同步最终效果

![](https://tencent.cos.mobaijun.com/img/blog/【DB系列】基于Docker的MySQL主从复制搭建和配置/1.png)

## 异常排查

如果出现异常，重点观察从库主从状态的异常日志，按照日志提示做出修改。

![](https://tencent.cos.mobaijun.com/img/blog/【DB系列】基于Docker的MySQL主从复制搭建和配置/2.png)

> 上图原因就是 IP 不通导致的，两台非局域网服务器，比如线上的服务器，以 Docker 启动后，拿外网 IP + 端口，非 Docker IP

其他可能出现的问题：

- 网络不通
  检查 ip, 端口
- 密码不对
  检查是否创建用于同步的用户和用户密码是否正确
- pos 不对
  检查主库的 Position

## 主从测试

> 非常简单，在主库创建一个数据库，然后检查从库是否存在此数据库。

## 完整的主备流程图

> 最后让我们来看一下，一个 update 语句在节点 A 执行，然后同步到节点 B 的完整流程图。

![](https://tencent.cos.mobaijun.com/img/blog/【DB系列】基于Docker的MySQL主从复制搭建和配置/3.png)

可以看到：主库接收到客户端的更新请求后，执行内部事务的更新逻辑，同时写入 binlog。
备库 B 跟主库 A 之间维持了一个长连接。主库 A 内部有一个线程，专门用于服务备库 B 的这个长连接。
一个事务日志同步的完整过程是这样的：

1、在备库 B 上通过 change master 命令，设置主库 A 的 IP、端口、用户名、密码、以及要从哪个位置开始请求 binlog，这个位置包含文件名和日志偏移量。
2、在备库 B 上执行 start slave 命令，这时侯备库会启动两个线程，io_thread 和 sql_thread。其中， io_thread 负责与主库建立连接。
3、主库 A 校验完用户名、密码后，开始按照备库 B 传过来的位置，从本地读取 binlog，发给 B。
4、备库 B 拿到 binlog 后，写到本地文件，称为中转日志（relay log）。
5、sql_thread 读取中转日志，解析日志里的命令，并执行。

## 参考文章

[基于 Docker 的 MySQL 主从复制搭建及原理（真正弄懂） | MySQL 技术论坛](https://learnku.com/articles/30439)
