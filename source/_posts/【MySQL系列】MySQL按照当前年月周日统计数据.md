---
title: 【MySQL系列】MySQL按照当前年月周日统计数据
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 4014467466
date: 2022-07-27 14:37:02
img:
coverImg:
password:
summary:
tags:
- 统计
categories:
- 数据库
---

## 前言：

> 接了一个小需求，获取用电统计的数据，要求获取最近月，周，天统计数据，MySQL 本来就包含处理这种需求的函数，这里记录下。

## 查询当天数据

~~~sql
SELECT * FROM 表名 WHERE TO_DAYS(表中时间字段) = TO_DAYS(NOW());
~~~

### 查询昨天数据

~~~sql
SELECT * FROM 表名 WHERE TO_DAYS(NOW()) - TO_DAYS(FROM_UNIXTIME(表中时间字段)) = 1;
~~~

* 方式2

~~~sql
SELECT * FROM 表名 WHERE TO_DAYS(NOW()) - TO_DAYS(表中日期字段) = 1;
~~~

## 查询本周数据

~~~sql
SELECT * FROM 表名 WHERE YEARWEEK(DATE_FORMAT(表中时间字段,'%Y-%m-%d')) = YEARWEEK(NOW());
~~~

### 查询上周数据

~~~sql
SELECT * FROM 表名 WHERE YEARWEEK(FROM_UNIXTIME(表中时间字段,'%Y-%m-%d')) = YEARWEEK(NOW())-1;
~~~

### 查询近30天数据（包含当天）

~~~sql
SELECT * FROM 表名 where DATE_SUB(CURDATE(), INTERVAL 30 DAY) <= FROM_UNIXTIME(表中时间字段)
~~~

## 查询当月数据

~~~sql
SELECT * FROM 表名 WHERE YEARWEEK(DATE_FORMAT(表中时间字段,'%Y-%m')) = DATE_FORMAT(CURDATE(),'%Y-%m');
~~~

* 方式2

~~~sql
SELECT
	* 
FROM
	表名 
WHERE
	date_format( 表中时间字段, '%Y -%m' )= date_format(NOW(), '%Y -%m' ) 
GROUP BY
	create_time DESC;
~~~

* 方式3

~~~sql
SELECT * FROM 表名 WHERE FROM_UNIXTIME(表中时间字段, '%Y%m') = DATE_FORMAT(CURDATE(), '%Y%m');
~~~

### 查询上月数据

~~~sql
SELECT * FROM 表名 WHERE PERIOD_DIFF(DATE_FORMAT(NOW(),'%Y%m'), FROM_UNIXTIME(表中时间字段,'%Y%m')) = 1;
~~~

## 查询最近一周数据

~~~sql
SELECT * FROM 表名 WHERE DATE_SUB(CURDATE(),INTERVAL 1 WEEK) <= DATE(表中时间字段);
~~~

> 中间的 1 是一周的意思，2 周就填写 2

## 查询最近一月内数据

~~~sql
SELECT * FROM 表名 WHERE DATE_SUB(CURDATE(),INTERVAL 1 MONTH) <= DATE(表中时间字段);
~~~

## 查询当年每月的统计数据

~~~sql
SELECT MONTH('表中日期字段'), COUNT(*) FROM '表名' WHERE YEAR(CURDATE()) GROUP BY MONTH('表中日期字段');
~~~

> PS：在复制 SQL 的时候需要注意，Mybatis 无法解析 <= | >= 这样的符号，需要使用 `<![CDATA[ <= ]]>` 包裹。
>
> 不然会报：org.xml.sax.SAXParseException: 元素内容必须由格式正确的字符数据或标记组成（具体可以看下这篇文章：[传送门](https://blog.csdn.net/Hello_World_QWP/article/details/86513179)）

### 查询本季度的数据

~~~sql
SELECT * FROM 表名 WHERE QUARTER(FROM_UNIXTIME(表中时间字段))=QUARTER(NOW()) AND YEAR(FROM_UNIXTIME(表中时间字段))=YEAR(NOW());
~~~

### 查询上季度的数据

~~~sql
SELECT * FROM 表名 WHERE QUARTER(FROM_UNIXTIME(表中时间字段)) = QUARTER(DATE_SUB(NOW(),INTERVAL 1 QUARTER)) AND YEAR(FROM_UNIXTIME(表中时间字段))=YEAR(NOW());
~~~

### 查询今年的数据

~~~sql
SELECT * FROM 表名 WHERE YEAR(FROM_UNIXTIME(表中时间字段))=YEAR(NOW());
~~~

### 查询去年的数据

~~~sql
SELECT * FROM 表名 WHERE YEAR(FROM_UNIXTIME(表中时间字段)) = YEAR(DATE_SUB(NOW(),INTERVAL 1 YEAR));
~~~

## 统计某年每个月的数据量

~~~sql
SELECT MONTH( 日期字段 ),COUNT( 1 ) FROM 表名 WHERE YEAR ( 表中时间字段 ) = 查询年份  GROUP BY MONTH ( 表中时间字段 );
~~~

## 其他统计 SQL

### 查询本年度数据

~~~sql
SELECT *  FROM 表名  WHERE YEAR ( FROM_UNIXTIME( 日期字段 ) ) = YEAR (curdate( ));
~~~

### 查询数据附带季度数

~~~sql
SELECT *, QUARTER ( FROM_UNIXTIME( `日期字段` ) )  FROM 表名;
~~~

### 查询本季度的数据

~~~sql
SELECT * FROM 表名 WHERE quarter( FROM_UNIXTIME( 日期字段 ) ) = quarter(curdate( ));
~~~

### 查询7天的数据

~~~sql
SELECT * FROM 表名 WHERE DATE_SUB( CURDATE(), INTERVAL 7 DAY ) <= date( 日期字段 );
~~~

### 查询本周统计

~~~sql
SELECT *  FROM 表名  WHERE MONTH ( 日期字段 ) = MONTH (curdate()) AND WEEK ( 日期字段 ) = WEEK (curdate());
~~~

### 统计每天数据总量

~~~sql
SELECT count(*) FROM 表名  GROUP BY date(日期字段);
~~~

> 下面的内容不重要，没地方写了所以就记录在这里吧！

![](https://dl4.weshineapp.com/gif/20211223/5cb2f1736615a4ea835513b5192b5c33.gif?f=micro_)

### MySQL获取全部每天最后一条记录

* #### 如果时间列（create_time）是 [datetime](https://so.csdn.net/so/search?q=datetime&spm=1001.2101.3001.7020) 格式（2020-08-24 15:57:57）

~~~sql
SELECT
	a.id,
	a.data,
	a.create_time,
	b.date 
FROM
	test_table a
	JOIN ( SELECT DATE_FORMAT( create_time, '%Y-%m-%d' ) date, 
          MAX( create_time ) max_time FROM test_table GROUP BY date ) b ON b.max_time = a.create_time 
ORDER BY
	b.date DESC
~~~

* 查询结果

~~~bash
+------+----------------------+---------------------+------------+
| id   | data                 | create_time         | date       |
+------+----------------------+---------------------+------------+
| 1184 |   0.3599999999999852 | 2022-07-18 23:59:00 | 2022-07-18 |
| 1160 |   0.3599999999999852 | 2022-07-17 23:59:00 | 2022-07-17 |
| 1136 |   0.3499999999999943 | 2022-07-16 23:59:00 | 2022-07-16 |
| 1112 |  0.35999999999999943 | 2022-07-15 23:59:00 | 2022-07-15 |
| 1098 |                    0 | 2022-07-14 13:59:00 | 2022-07-14 |
| 1085 |                    0 | 2022-07-13 23:59:00 | 2022-07-13 |
| 1062 |  0.35999999999999943 | 2022-07-12 23:59:00 | 2022-07-12 |
| 1038 |  0.35999999999999943 | 2022-07-11 23:59:00 | 2022-07-11 |
| 1014 |  0.35999999999999943 | 2022-07-10 23:59:00 | 2022-07-10 |
+------+----------------------+---------------------+------------+
~~~

* #### 如果时间列（create_time）是时间戳格式（1598255877）

~~~sql
SELECT
	a.id,
	a.create_time,
	a.test_value,
	a.create_date,
	b.date 
FROM
	test_table a
	JOIN ( SELECT FROM_UNIXTIME( create_time, '%Y-%m-%d' ) date, MAX( create_time ) max_time FROM test_table GROUP BY date ) b ON b.max_time = a.create_time 
ORDER BY
	b.date DESC
~~~

### MySQL获取本月每天最后一条记录

~~~sql
SELECT
	a.id,
	a.data,
	a.create_time,
	b.date 
FROM
	table_name a
	JOIN ( SELECT DATE_FORMAT( create_time, '%Y-%m-%d' ) date, MAX( create_time ) max_time FROM table_name GROUP BY date ) b ON b.max_time = a.create_time 
WHERE
	DATE_FORMAT( create_time, '%Y -%m' )= DATE_FORMAT( NOW(), '%Y -%m' ) 
ORDER BY
	b.date DESC
~~~

* 结果

~~~bash
+---------------------+---------------------+---------------------+------------+
|      id          |       data          |      create_time    | date       |
+---------------------+---------------------+---------------------+------------+
|                1 |                   0 | 2022-07-22 10:59:00 | 2022-07-22 |
|                2 |                   0 | 2022-07-21 23:59:00 | 2022-07-21 |
|                3 |                   0 | 2022-07-20 23:59:00 | 2022-07-20 |
|                4 |                   0 | 2022-07-19 13:59:01 | 2022-07-19 |
|                5 |  0.3599999999999852 | 2022-07-18 23:59:00 | 2022-07-18 |
|                6 |  0.3599999999999852 | 2022-07-17 23:59:00 | 2022-07-17 |
|                7 |  0.3499999999999943 | 2022-07-16 23:59:00 | 2022-07-16 |
|                8 | 0.35999999999999943 | 2022-07-15 23:59:00 | 2022-07-15 |
|                9 |                   0 | 2022-07-14 13:59:00 | 2022-07-14 |
|               10 |                   0 | 2022-07-13 23:59:00 | 2022-07-13 |
|               11 | 0.35999999999999943 | 2022-07-12 23:59:00 | 2022-07-12 |
|               12 | 0.35999999999999943 | 2022-07-11 23:59:00 | 2022-07-11 |
|               13 | 0.35999999999999943 | 2022-07-10 23:59:00 | 2022-07-10 |
|               14 | 0.35999999999999943 | 2022-07-09 23:59:00 | 2022-07-09 |
|               15 |  0.3499999999999943 | 2022-07-08 23:59:00 | 2022-07-08 |
|               16 |  0.3499999999999943 | 2022-07-07 23:59:00 | 2022-07-07 |
|               17 | 0.35999999999999943 | 2022-07-06 23:59:00 | 2022-07-06 |
|               18 |  0.3500000000000014 | 2022-07-05 23:59:00 | 2022-07-05 |
|               19 | 0.35999999999999943 | 2022-07-04 23:59:00 | 2022-07-04 |
|               20 |  0.3500000000000014 | 2022-07-03 23:59:00 | 2022-07-03 |
|               21 | 0.35999999999999943 | 2022-07-02 23:59:00 | 2022-07-02 |
|               22 | 0.35999999999999943 | 2022-07-01 23:59:00 | 2022-07-01 |
+---------------------+---------------------+---------------------+------------+
~~~

## 获取上月每天最后一条数据

~~~sql
SELECT
	a.id,
	a.data,
	a.create_time,
	b.date 
FROM
	table_name a
	JOIN ( SELECT DATE_FORMAT( create_time, '%Y-%m-%d' ) date, MAX( create_time ) max_time FROM table_name GROUP BY date ) b ON b.max_time = a.create_time 
WHERE
DATE_FORMAT( create_time, '%Y %m' ) = DATE_FORMAT(DATE_SUB( curdate(), INTERVAL 1 MONTH ),'%Y %m')
ORDER BY b.date DESC;
~~~

* 结果

~~~bash
+------------+---------------------+-------------+
| project_id |         data	       | create_time |
+------------+---------------------+-------------+
|         28 |                   0 | 2022-07-14  |
|         28 |                   0 | 2022-07-13  |
|         28 |                   0 | 2022-07-12  |
|         28 | 0.35999999999999943 | 2022-07-11  |
|         28 | 0.35999999999999943 | 2022-07-10  |
|         28 | 0.35999999999999943 | 2022-07-09  |
|         28 |  0.3499999999999943 | 2022-07-08  |
|         28 |  0.3499999999999943 | 2022-07-07  |
|         28 | 0.35999999999999943 | 2022-07-06  |
|         28 |  0.3500000000000014 | 2022-07-05  |
|         28 | 0.35999999999999943 | 2022-07-04  |
|         28 |  0.3500000000000014 | 2022-07-03  |
|         28 | 0.35999999999999943 | 2022-07-02  |
|         28 | 0.35999999999999943 | 2022-07-01  |
+------------+---------------------+-------------+
~~~

## 获取本周每天最后一条数据

~~~sql
SELECT
	a.id,
	a.data,
	a.create_time,
	b.date 
FROM
	table_name a
	JOIN ( SELECT DATE_FORMAT( create_time, '%Y-%m-%d' ) date, MAX( create_time ) max_time FROM table_name GROUP BY date ) b ON b.max_time = a.create_time 
WHERE
	YEARWEEK(DATE_FORMAT(create_time,'%Y-%m-%d')) = YEARWEEK(NOW());
ORDER BY
	b.date DESC
~~~

* 结果

~~~bash
+---------------------+---------------------+---------------------+------------+
|      id          |       data          |      create_time    | date       |
+---------------------+---------------------+---------------------+------------+
|               13 | 0.35999999999999943 | 2022-07-10 23:59:00 | 2022-07-10 |
|               14 | 0.35999999999999943 | 2022-07-09 23:59:00 | 2022-07-09 |
|               15 |  0.3499999999999943 | 2022-07-08 23:59:00 | 2022-07-08 |
|               16 |  0.3499999999999943 | 2022-07-07 23:59:00 | 2022-07-07 |
|               17 | 0.35999999999999943 | 2022-07-06 23:59:00 | 2022-07-06 |
|               18 |  0.3500000000000014 | 2022-07-05 23:59:00 | 2022-07-05 |
|               19 | 0.35999999999999943 | 2022-07-04 23:59:00 | 2022-07-04 |
+---------------------+---------------------+---------------------+------------+
~~~

## 非日期统计查询

### 查询表的数据量大小

~~~sql
SELECT TABLE_NAME,( data_length + index_length )/ 1024 / 1024 AS TABLE_MB,
TABLE_ROWS 
FROM
	information_schema.`TABLES` 
WHERE
	TABLE_SCHEMA = 'database_name';
~~~

* 结果

~~~bash
+--------------------------------------------+--------------+------------+
| TABLE_NAME                                 | TABLE_MB     | TABLE_ROWS |
+--------------------------------------------+--------------+------------+
| sys_role_menu                              | 0.04687500   |        465 |
| sys_user                                   | 0.01562500   |          4 |
| sys_user_post                              | 0.01562500   |         13 |
| sys_user_role                              | 0.01562500   |         26 |
+--------------------------------------------+--------------+------------+
~~~

### 查询阻塞语句

~~~sql
SELECT
	r.trx_id waiting_trx_id,
	r.trx_mysql_thread_Id waiting_thread,
	r.trx_query waiting_query,
	b.trx_id blocking_trx_id,
	b.trx_mysql_thread_id blocking_thread,
	b.trx_query blocking_query 
FROM
	information_schema.innodb_lock_waits w
	INNER JOIN information_schema.innodb_trx b ON b.trx_id = w.blocking_trx_id
	INNER JOIN information_schema.innodb_trx r ON r.trx_id = w.requesting_trx_id;
~~~

### 统计数据库访问量前 10 的 IP 地址

~~~sql
SELECT
	SUBSTRING_INDEX( HOST, ':', 1 ) AS ip,
	COUNT(*) 
FROM
	information_schema.PROCESSLIST 
GROUP BY
	ip 
ORDER BY
	COUNT(*) DESC 
	LIMIT 10;
~~~

* 结果

~~~bash
+---------------+----------+
| ip            | COUNT(*) |
+---------------+----------+
| 1.74.3.122    |       33 |
| 113.51.32.63  |        9 |
| 8.132.10.2    |        2 |
+---------------+----------+
~~~



![](https://dl4.weshineapp.com/gif/20210926/f802b54fcddc8ab2b46013f58d3b83f8.gif?f=micro_)
