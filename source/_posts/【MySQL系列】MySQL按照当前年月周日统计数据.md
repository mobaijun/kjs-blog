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

* 查询当天数据

~~~sql
SELECT * FROM 表名 WHERE TO_DAYS(表中时间字段) = TO_DAYS(NOW());
~~~

* 查询本周数据

~~~sql
SELECT * FROM 表名 WHERE YEARWEEK(DATE_FORMAT(表中时间字段，'%Y-%m-%d')) = YEARWEEK(NOW());
~~~

* 查询当月数据

~~~sql
SELECT * FROM 表名 WHERE YEARWEEK(DATE_FORMAT(表中时间字段，'%Y-%m')) = DATE_FORMAT(CURDATE(),'%Y-%m');
~~~

* 查询最近一周数据

~~~sql
SELECT * FROM 表名 WHERE DATE_SUB(CURDATE(),INTERVAL 1 WEEK) <= DATE(表中时间字段);
~~~

> 中间的 1 是一周的意思，2 周就填写 2

* 查询最近一月内数据

~~~sql
SELECT * FROM 表名 WHERE DATE_SUB(CURDATE(),INTERVAL 1 MONTH) <= DATE(表中时间字段);
~~~

* 查询当年每月的统计数据

~~~sql
SELECT MONTH('表中日期字段'), COUNT(*) FROM '表名' WHERE YEAR(CURDATE()) GROUP BY MONTH('表中日期字段');
~~~

> PS：在复制 SQL 的时候需要注意，Mybatis 无法解析 <= | >= 这样的符号，需要使用 `<![CDATA[ <= ]]>` 包裹。
>
> 不然会报：org.xml.sax.SAXParseException: 元素内容必须由格式正确的字符数据或标记组成（具体可以看下这篇文章：[传送门](https://blog.csdn.net/Hello_World_QWP/article/details/86513179)）

* 统计某年每个月的数据量

~~~sql
SELECT MONTH( 日期字段 ),COUNT( 1 ) FROM 表名 WHERE YEAR ( 日期字段 ) = 查询年份  GROUP BY MONTH ( 日期字段 );
~~~

## 其他统计 SQL

* 查询本年度数据

~~~sql
SELECT *  FROM 表名  WHERE YEAR ( FROM_UNIXTIME( 日期字段 ) ) = YEAR (curdate( ));
~~~

* 查询数据附带季度数

~~~sql
SELECT *, QUARTER ( FROM_UNIXTIME( `日期字段` ) )  FROM 表名;
~~~

* 查询本季度的数据

~~~sql
SELECT * FROM 表名 WHERE quarter( FROM_UNIXTIME( 日期字段 ) ) = quarter(curdate( ));
~~~

* 查询7天的数据

~~~sql
SELECT * FROM 表名 WHERE DATE_SUB( CURDATE(), INTERVAL 7 DAY ) <= date( 日期字段 );
~~~

* 查询本周统计

~~~sql
SELECT *  FROM 表名  WHERE MONTH ( 日期字段 ) = MONTH (curdate()) AND WEEK ( 日期字段 ) = WEEK (curdate());
~~~

* 统计每天数据总量

~~~sql
SELECT count(*) FROM 表名  GROUP BY date(日期字段);
~~~

> 下面的内容不重要，没地方写了所以就记录在这里吧！

![](https://dl4.weshineapp.com/gif/20211223/5cb2f1736615a4ea835513b5192b5c33.gif?f=micro_)

## 非日期统计查询

* 查询表的数据量大小

~~~sql
SELECT TABLE_NAME,( data_length + index_length )/ 1024 / 1024 AS TABLE_MB,
TABLE_ROWS 
FROM
	information_schema.`TABLES` 
WHERE
	TABLE_SCHEMA = 'database_name';
~~~

* 查询阻塞语句

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

* 统计数据库访问量前 10 的 IP 地址

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

![](https://dl4.weshineapp.com/gif/20210926/f802b54fcddc8ab2b46013f58d3b83f8.gif?f=micro_)
