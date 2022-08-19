---
title: 【工具系列】IDEA链接MySQL数据库失败
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - 异常
categories:
  - 工具
abbrlink: 1191060190
date: 2020-03-24 15:39:13
img:
coverImg:
password:
summary:
---





> 异常信息:Server returns invalid timezone. Go to 'Advanced' tab and set 'serverTimezon(服务器返回无效时区。转到“高级”选项卡并设置“服务器时区”)

#### 解决方案

* 命令行登录MySQL数据库,win + R,登录数据库:

~~~bash
mysql -uroot  -p
~~~

* 点击回车输入密码

*  继续输入以下命令 （注意不要漏掉后面的分号），回车，如图： 

~~~bash
show variables like'%time_zone'; 
~~~

~~~bash
mysql> show variables like'%time_zone'; 
+------------------+--------+
| Variable_name    | Value  |
+------------------+--------+
| system_time_zone | CST    |
| time_zone        | SYSTEM |
+------------------+--------+
~~~

* 如果 显示 SYSTEM 就是我们没有设置时区, 时区错误，MySQL默认的时区是UTC时区，比北京时间晚`8`个小时 , 所以要修改mysql的时长区,输入一下命令,注意不要漏掉后面的分号），回车，如图： 

~~~bash
set global time_zone = '+8:00'; 
~~~

 这时你重新连接下数据库，基本上就没有问题了！