---
title: 【MySQL系列】'MySQL远程连接失败(错误码:2003)'
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 3639136044
tags:
  - 异常
categories:
  - 数据库
date: 2021-05-24 15:10:40
img:
coverImg:
password:
summary:
---

### 1. 环境信息

* 服务器系统：Centos 7.6
* 服务器MySQL版本：8.0.25
* 本地系统：Windows10
* 本地客户端：navicat 15

### 2. 本地客户端连接远程服务器MySQL报错

![](https://tencent.cos.mobaijun.com/article_with_pictures/TFgMNBsY16SbQ4v.png)

### 3. 错误描述

> "error 2003: can't connect to mysql server on '***' (10061)"    
>
> Google翻译：错误2003：无法连接到“**”上的mysql服务器（10061）

### 4. 解决过程

1. Xshell远程登陆服务器，用“ps aux|grep mysql”命令查看，MySQL服务已启动:

2. 用"vim my.cnf"命令查看my.cnf文件(在MySQL安装目录下，我的位置是/etc/my.cnf),修改其对应的值并重启MySQL。对应内容如下：

~~~bash
[mysqld]
bind-address=0.0.0.0	# 表示允许任何主机登陆MySQL
port=3306               # 表示MySQL运行端口为3306
~~~

3. 用“mysql -uroot -p”命令，回车后输入密码“***”能正常登陆服务器MySQL

~~~bash
mysql> show global variables like 'port';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| port          | 3306  |
+---------------+-------+
1 row in set (0.00 sec)
~~~

4. 查看MySQL权限配置

~~~bash
mysql> use mysql;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select host,user from user;
+-----------+------------------+
| host      | user             |
+-----------+------------------+
| %         | root             |
| %         | zijing           |
| localhost | mysql.infoschema |
| localhost | mysql.session    |
| localhost | mysql.sys        |
+-----------+------------------+
5 rows in set (0.00 sec)
~~~

> 1. 如果上述查询结果，root用户对应的host不为%，则修改用户权限、
> 2. 此处需注意的是，修改权限时要带上密码(IDENTIFIED BY 'password')。

4. 修改完以上操作，我尝试链接MySQL，但还是无法成功

![](https://tencent.cos.mobaijun.com/article_with_pictures/tCHq6BVLN94p5jD.png)

我以为可能是防火墙原因，但之前已经将3306端口暴露出来了

![](https://tencent.cos.mobaijun.com/article_with_pictures/iRszEgOxUnpTZ43.png)

* 已经开放了远程端口

![](https://tencent.cos.mobaijun.com/article_with_pictures/5rKx3RvhokBdyUL.png)

5. 目前所有可以尝试的办法都已经尝试过了，突然灵光一闪，我想起来之前ecs服务器是需要开放防火墙端口的，可能需要我去控制台开启3306的访问端口，于是我百度了轻量型应用服务器如何开启安全组

![](https://tencent.cos.mobaijun.com/article_with_pictures/WEaPblqUvcZxYK7.png)

> 官网地址：[传送门](https://www.vpstip.com/simple-application-stop-firewall.html)

6. 当我开启了控制台的防火墙端口，感觉世界真的很美好了

![](https://tencent.cos.mobaijun.com/article_with_pictures/MnDT1PwfZaYjkQ8.png)

7. 使用navicat链接MySQL

![](https://tencent.cos.mobaijun.com/article_with_pictures/A6pHIa85TibROgE.png)

> 成功了，想起来前辈说的那句话，每次遇到一些莫名其妙的错误，怎么都排查不出来的时候，那个错误一定是个非常无脑的问题。