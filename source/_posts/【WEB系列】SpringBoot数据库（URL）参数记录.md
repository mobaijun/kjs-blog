---
title: 【WEB系列】SpringBoot数据库（URL）参数记录
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 2403615121
tags:
  - 配置文件
categories:
  - SpringBoot
date: 2021-07-19 11:18:38
img:
coverImg:
password:
summary:
---

1. 数据库连接字符串示例：

~~~yaml
jdbc:mysql://localhost:3306/mydb?autoReconnect=true&useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Hongkong
~~~



2. 语句分解分析：

~~~yaml
jdbc:mysql://localhost:3306/mydb
~~~

* 连接本地*mysql*数据库mydb
* *localhost*是本机的IP地址也就是*127.0.0.1*
* *3306*是对应本地的端口号，一般是*mysql*数据库的连接端口
* *mydb*就是对应要连接的数据库库名

~~~yaml
autoReconnect=true
~~~

* 当数据库连接异常中断时，是否自动重新连接

~~~yaml
useUnicode=true&characterEncoding=utf8
~~~

* 是否使用*Unicode*字符集，如果参数*characterEncoding*设置为*gb2312*或*gbk*，本参数值必须设置为*true*,当*useUnicode*设置为*true*时，指定字符编码。比如可设置为*gb2312*或*gbk*
* 解决乱码问题
* 系统编码类型为*UTF-8*，当数据库编码格式为*GBA*，也不会出现乱码

~~~yaml
useSSL=false
~~~

* 这个参数可以使*JDBC*兼容更高版本的数据库

~~~yaml
serverTimezone=Hongkong
~~~

- 数据库时区设置，*UTC*为世界时间
- 世界时间比北京时间早8个钟
- 时区设置为东八区时会出现各种陷阱，可直接修改*mysql*的配置文件
  或者设置*serverTimezone=Asia/Shanghai*

~~~yaml
autoReconnectForPools=true
~~~

* 是否使用针对数据库连接池的重连策略

~~~yaml
failOverReadOnly=true
~~~

* 自动重连成功后，连接是否设置为只读？

~~~yaml
maxReconnectsautoReconnect=true
~~~

* 设置为true时，重试连接的次数

~~~yaml
initialTimeoutautoReconnect=true
~~~

* 设置为true时，两次重连之间的时间间隔，单位：秒

~~~yaml
connectTimeout=100
~~~

* 和数据库服务器建立socket连接时的超时，单位：毫秒。 0表示永不超时，适用于JDK 1.4及更高版本

~~~yaml
socketTimeoutsocket=1000
~~~

* 操作（读写）超时，单位：毫秒。 0表示永不超时



3. 其他

在使用数据库连接池的情况下，最好设置如下两个参数：

~~~yaml
autoReconnect=true&failOverReadOnly=false
~~~

需要注意的是，在xml配置文件中，url中的&符号需要转义成&。比如在tomcat的server.xml中配置数据库连接池时，mysql jdbc url样例如下：

~~~yaml
jdbc:mysql://localhost:3306/test?user=root&amp;password=&amp;useUnicode=true&amp;characterEncoding=gbk
&amp;autoReconnect=true&amp;failOverReadOnly=false
~~~

—

参考：

https://www.cnblogs.com/yokoboy/archive/2013/03/01/2939315.html

MySQL官网文档： http://dev.mysql.com/doc/refman/5.1/en/connector-j-reference-configuration-properties.html

https://www.huaweicloud.com/articles/e70b4852d363bdad2cce3be977590d38.html