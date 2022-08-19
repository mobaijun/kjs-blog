---
title: 【DB系列】InfluxDB
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - InfluxDB
categories:
  - 数据库
abbrlink: 2901774056
date: 2020-12-04 10:25:12
img:
coverImg:
password:
summary:
---

### 什么是时序数据库?

#### 时序数据库简介排行

![主要内容](https://tencent.cos.mobaijun.com/article_with_pictures/20200820154355.png)

[时间序列数据库 Time Series Database (TSDB)](https://baike.baidu.com/item/%E6%97%B6%E5%BA%8F%E6%95%B0%E6%8D%AE%E5%BA%93/922671)

> 时序数据库全称为时间序列数据库。时间序列数据库主要用于指处理带时间标签（按照时间的顺序变化，即时间序列化）的数据，带时间标签的数据也称为时间序列数据。
>
> 时间序列数据主要由电力行业、化工行业等各类型实时监测、检查与分析设备所采集、产生的数据，这些工业数据的典型特点是：产生频率快（每一个监测点一秒钟内可产生多条数据）、严重依赖于采集时间（每一条数据均要求对应唯一的时间）、测点多信息量大（常规的实时监测系统均有成千上万的监测点，监测点每秒钟都产生数据，每天产生几十GB的数据量）。

#### 特点

> 基于时间序列数据的特点，关系型数据库无法满足对时间序列数据的有效存储与处理，因此迫切需要一种专门针对时间序列数据来做优化的数据库系统，即时间序列数据库。
> 对于时序大数据的存储和处理往往采用关系型数据库的方式进行处理，但由于关系型数据库天生的劣势导致其无法进行高效的存储和数据的查询。时序大数据解决方案通过使用特殊的存储方式，使得时序大数据可以高效存储和快速处理海量时序大数据，是解决海量数据处理的一项重要技术。该技术采用特殊数据存储方式，极大提高了时间相关数据的处理能力，相对于关系型数据库它的存储空间减半，查询速度极大的提高。时间序列函数优越的查询性能远超过关系型数据库，Informix TimeSeries非常适合在物联网分析应用。

* <font color="red">有效处理庞大数据</font>
* 对重复的部分，Informix TimeSeries只保持一份数据
* <font color="red">节省空间50%，有效降低I/O</font>
* 主键索引更有效
* 时间序列表头分离的特性不浪费空间;

### InfluxDB简介

> InfluxDB是一个由InfluxData开发的开源时序型数据库。它由Go写成，着力于高性能地查询与存储时序型数据。InfluxDB被广泛应用于存储系统的监控数据，IoT行业的实时数据等场景。
>
> InfluxDB是一个用于存储和分析时间序列数据的开源数据库。InfluxDB（时序数据库），常用的一种使用场景：监控数据统计。每毫秒记录一下电脑内存的使用情况，然后就可以根据统计的数据，利用图形化界面（InfluxDB V1一般配合Grafana）制作内存使用情况的折线图；
>
> 可以理解为按时间记录一些数据（常用的监控数据、埋点统计数据等），然后制作图表做统计；
>
> [官网地址](https://docs.influxdata.com/influxdb/v1.8/introduction/install/)

* 主要特性
  * 内置HTTP接口，使用方便
  * 数据可以打标记，这样查询可以很灵活
  * 类SQL的查询语句
  * 安装管理很简单，并且读写数据很高效
  * 能够实时查询，数据在写入时被索引后就能够被立即查出

> 在最新的[DB-ENGINES](https://db-engines.com/en/ranking/time+series+dbms)给出的时间序列数据库的排名中，InfluxDB高居第一位，可以预见，InfluxDB会越来越得到广泛的使用。

### 安装InfluxDB

|     概念     |  MySQL   |                          InfluxDB                           |
| :----------: | :------: | :---------------------------------------------------------: |
| 数据库（同） | database |                          database                           |
|  表（不同）  |  table   |                         measurement                         |
|  列（不同）  |  column  | tag(带索引的，非必须)、field(不带索引)、timestemp(唯一主键) |

> 安装InfluxDB包需要`root`或是有管理员权限才可以。另进入官网influxDB需要链接外部网络
>
> [下载地址](https://portal.influxdata.com/downloads/)

![选择时序数据库](https://tencent.cos.mobaijun.com/article_with_pictures/20200820164830.png)

* 选择下载的系统版本,我这里下载的是Windows系统版本

![选择版本](https://tencent.cos.mobaijun.com/article_with_pictures/20200820164934.png)

* 下载完成以后解压压缩包,文件如下

![文件内容](https://tencent.cos.mobaijun.com/article_with_pictures/20200820165121.png)

> influxd.exe   启动程序
>
> influx.exe <font color="red">influxDB数据库命令行界面</font>
>
> influxdb.conf   配置文件

### 启动及常用命令

> 点击地址栏输入cmd,如下命令启动数据库

~~~bash
# 启动influxdb数据库
$ start influxd.exe
# 查看配置
$ influxd config
# 查看帮助
$ influx --help
# 退出
$ exit
~~~

### 网络

> InfluxDB默认使用下面的网络端口：
>
> * TCP端口`8086`用作InfluxDB的客户端和服务端的http api通信
> * TCP端口`8088`给备份和恢复数据的RPC服务使用

另外，InfluxDB也提供了多个可能需要自定义端口的插件，所以的端口映射都可以通过配置文件修改，对于默认安装的InfluxDB，这个配置文件位于`/influxdb/influxdb.conf`。

### 配置

> 安装好之后，每个配置文件都有了默认的配置，你可以通过命令`influxd config`来查看这些默认配置。

在配置文件`/influxdb/influxdb.conf`之中的大部分配置都被注释掉了，所有这些被注释掉的配置都是由内部默认值决定的。配置文件里任意没有注释的配置都可以用来覆盖内部默认值，需要注意的是，本地配置文件不需要包括每一项配置。

* Windows环境下需要配置默认文件夹路径

![修改默认配置](https://tencent.cos.mobaijun.com/article_with_pictures/20200820170839.png)

### 权限

> Linux下如果InfluxDB没有使用标准的数据和配置文件的文件夹的话，你需要确定文件系统的权限是正确的：

```bash
=================以下两条命令未验证=======================
$ chown influxdb:influxdb /mnt/influx
$ chown influxdb:influxdb /mnt/db
```

### 可视化程序[*InfluxDBStudio*]

#### 安装InfluxDBStudio

> [下载地址](https://github.com/CymaticLabs/InfluxDBStudio/releases/tag/v0.2.0-beta.1)

![启动程序](https://tencent.cos.mobaijun.com/article_with_pictures/20200820171348.png)

#### 链接时序数据库

![创建链接对象](https://tencent.cos.mobaijun.com/article_with_pictures/20200820171957.png)

![默认值](https://tencent.cos.mobaijun.com/article_with_pictures/20200820172213.png)

* influxDB数据库初始无账号密码，随意填写即可

> 需要注意的是,链接时序数据库时不能关闭influxd.exe程序

![启动程序](https://tencent.cos.mobaijun.com/article_with_pictures/20200820172319.png)

### InfluxQL

> 第一次安装好InfluxDB之后是没有数据库的(除了系统自带的`_internal`)，因此创建一个数据库是我们首先要做的事，通过`CREATE DATABASE <db-name>`这样的InfluxQL语句来创建，其中`<db-name>`就是数据库的名字。数据库的名字可以是被双引号引起来的任意Unicode字符。 如果名称只包含ASCII字母，数字或下划线，并且不以数字开头，那么也可以不用引起来。

* 测试sql

~~~sql
-- 创建数据库
CREATE DATABASE mobai;
-- 查看所有数据库
SHOW DATABASES;
-- 指定使用的数据库
USE mobai;
-- 删除数据库
DROP DATABASE mobai;
-- 查看保留策略
SHOW retention policies ON mobai;
-- 创建保留策略rp-one-year
CREATE retention policy "rp-one-year" ON "mobai" duration 365d replication 1
-- 更改保留策略rp-one-year为mobai的默认策略
ALTER retention policy "rp-one-year" ON "mobai" duration 365d replication 1 DEFAULT
-- 删除保留策略
DROP retention policy "rp-one-year" ON "mobai";
~~~

> 说明：在输入上面的语句之后，并没有看到任何信息，这在CLI里，表示语句被执行并且没有错误，如果有错误信息展示，那一定是哪里出问题了，这就是所谓的*没有消息就是好消息*。

### InfluxDB表

> ​    与MySQL等关系型数据不同，在InfluxDB中，无需显式创建表，在写入时序数据时，InfluxDB服务器会根据行协议，按需自动创建对应的表。

* 创建表

~~~sql
-- 在数据库mobai中，插入数据时，自动创建了表devops-idc-sz。
use mobai;
=====================================================
> use mobai;
Using database mobai
> show measurements;
> insert devops,host=server1 cpu=23.1,mem=0.63
> show measurements;
name: measurements
name
----
devops
>
~~~

* 查看表

> ​    通过SHOW语句，，查看数据库mobai中的所有的表。

~~~sql
=====================================================
> show measurements;
name: measurements
name
----
devops
>
~~~

* 删除表

> ​    通过DROP语句，删除表devops-idc-sz和对应的所有数据。

~~~sql
DROP measurement devops
~~~

* 数据写入

> ​    通过INSERT语句和行协议，向表devops中插入3条DevOps环境的时序数据记录，时序数据对应的时间为2019/8/30 17:44:53。

~~~sql
> insert devops,host=server01 cpu=16.1,mem=0.43 1567158293000000000
> insert devops,host=server02 cpu=23.8,mem=0.63 1567158293000000000
> insert devops,host=server03 cpu=56.3,mem=0.78 1567158293000000000
~~~

* 数据查询

> ​    通过SELECT语句，查询表devops中的所有数据。

~~~sql
> select * from devops;
name: devops
time                cpu  host     mem
----                ---  ----     ---
1567158293000000000 16.1 server01 0.43
1567158293000000000 56.3 server03 0.78
1567158293000000000 23.8 server02 0.63
1597975570681506000 23.1 server1  0.63
>
~~~

* 数据更新

> 因为时序数据多写少读无更新的特点，InfluxDB，不支持数据更新操作，亦不建议对时序数据记录执行更新操作。如果在某些特殊场景下，必须对时序数据记录的指标值进行更新，可以利用“时间戳（Timestamp）和时间序列线（Series）完全相同的时序数据记录，是同一条时序数据记录，新插入的时序数据，会覆盖原有的时序数据记录”的特性，更新时序数据记录的的指标值。

~~~sql
> insert devops,host=server01 cpu=76.1,mem=0.83 1567158293000000000
> select * from devops;
name: devops
time                cpu  host     mem
----                ---  ----     ---
1567158293000000000 76.1 server01 0.83
1567158293000000000 56.3 server03 0.78
1567158293000000000 23.8 server02 0.63
1597975570681506000 23.1 server1  0.63
>
~~~

* 数据删除

> 同样，因为时序数据多写少读无更新和批量删除时序数据记录的特点，InfluxDB不支持删除单条时序数据记录。除了通过保留策略周期性的定时删除时序数据记录，InfluxDB还还还支持通过WHERE条件语句、删除时间序列线、删除表、删除数据库、删除分片（Shard）等方式直接批量删除指定的时序数据记录。

~~~sql
-- 通过WHERE条件语句从指定表中删除时序数据记录，从表devops中，删除标签名为host，标签值为server01、在2019/8/30 17:44:53时间点的时序数据记录。
===================================================================
DELETE FROM devops WHERE "host" = 'server01' AND time = 1567158293s
===================================================================
-- 需要注意:（WHERE条件语句，不支持指标（Field），只支持标签和时间戳。）
~~~

> 通过删除时间序列线删除时序数据记录，删除标签对"host"='server01'对应的时间序列线的所有时序数据记录。

~~~sql
DROP series FROM devops WHERE "host" = 'server01'
~~~

> 通过删除指定表删除时序数据记录，删除表devops对应的所有时序数据记录。

~~~sql
DROP measurement  devops
~~~

> 通过删除指定数据库删除时序数据记录，删除数据库mobai对应的所有时序数据记录。

~~~sql
DROP database mobai
~~~

> 通过删除指定分片删除时序数据记录，删除分片 6对应的所有时序数据记录。

~~~sql
===========================插入数据==================================
> insert devops,host=server01 cpu=16.1,mem=0.43 1567158293000000000
> insert devops,host=server02 cpu=16.1,mem=0.43 1567158293000000000
> insert devops,host=server03 cpu=16.1,mem=0.43 1567158293000000000
> insert devops,host=server04 cpu=16.1,mem=0.43 1567158293000000000
> insert devops,host=server05 cpu=16.1,mem=0.43 1567158293000000000
> insert devops,host=server06 cpu=16.1,mem=0.43 1567158293000000000
> insert devops,host=server07 cpu=16.1,mem=0.43 1567158293000000000
> insert devops,host=server08 cpu=16.1,mem=0.43 1567158293000000000
===========================查看数据==================================
> SELECT * FROM devops
name: devops
time                cpu  host     mem
----                ---  ----     ---
1567158293000000000 16.1 server01 0.43
1567158293000000000 16.1 server08 0.43
1567158293000000000 16.1 server07 0.43
1567158293000000000 16.1 server06 0.43
1567158293000000000 16.1 server05 0.43
1567158293000000000 16.1 server04 0.43
1567158293000000000 16.1 server03 0.43
1567158293000000000 16.1 server02 0.43
===========================查看分片数据============================
> show shards
name: _internal
id database  retention_policy shard_group start_time           end_time             expiry_time          owners
-- --------  ---------------- ----------- ----------           --------             -----------          ------
1  _internal monitor          1           2020-08-20T00:00:00Z 2020-08-21T00:00:00Z 2020-08-28T00:00:00Z
2  _internal monitor          2           2020-08-21T00:00:00Z 2020-08-22T00:00:00Z 2020-08-29T00:00:00Z

name: mobai
id database retention_policy shard_group start_time           end_time             expiry_time          owners
-- -------- ---------------- ----------- ----------           --------             -----------          ------
4  mobai    autogen          4           2019-08-26T00:00:00Z 2019-09-02T00:00:00Z 2019-09-02T00:00:00Z
3  mobai    autogen          3           2020-08-17T00:00:00Z 2020-08-24T00:00:00Z 2020-08-24T00:00:00Z
===========================删除全部数据============
> drop shard 4
> select *  from  devops
~~~

> * 参考文章
>   * [InfluxDB从原理到实战 - InfluxDB常用的基础操作](https://cloud.tencent.com/developer/article/1496378)
>   * [InfluxDB中文文档](https://jasper-zhang1.gitbooks.io/influxdb/content/)
>   * [influxdb常用操作](https://www.dazhuanlan.com/2019/10/01/5d92b438480eb/)
>   * [InfluxDB简明手册](https://www.lanqiao.cn/library/influxdb-handbook/shu_ju_ku_yu_biao_de_cao_zuo)