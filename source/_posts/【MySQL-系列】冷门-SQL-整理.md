---
title: 【MySQL 系列】冷门 SQL 整理
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 970409657
tags:
  - MySQL
categories:
  - 数据库
date: 2022-07-28 10:42:57
img:
coverImg:
password:
summary:
---

## 查看当前链接所有业务数据库

~~~sql
SELECT
	schema_name AS db_name 
FROM
	information_schema.schemata 
WHERE
	schema_name NOT IN ( 'information_schema', 'sys', 'mysql', 'performance_schema' );
~~~

> PS: information_schema 中的数据默认不是实时的数据，如果需要实时的数据，需要执行下面命令：

~~~sql
SET GLOBAL information_schema_stats_expiry = 0;
~~~

效果如下：

~~~bash
+-----------------+
| db_name         |
+-----------------+
| seata           |
| test            |
+-----------------+
~~~

## 批量操作某个前缀的表

~~~SQL
SELECT
	concat( 'select count(*) from DB_NAME.', table_name, ';' ) 
FROM
	information_schema.TABLES 
WHERE
	table_schema = 'DB_NAME' 
	AND table_name LIKE 'a_%';
~~~

效果如下：

~~~bash
+------------------------------------------------------+
| concat('select count(*) from test.',table_name,';')  |
+------------------------------------------------------+
| select count(*) from test.test_tables1;              |
| select count(*) from test.test_tables2;         	   |
+------------------------------------------------------+
~~~

## 查找业务库中的非 InnoDB 的表

~~~sql
SELECT
	table_schema,
	table_name,
ENGINE 
FROM
	information_schema.TABLES 
WHERE
	table_schema NOT IN ( 'information_schema', 'sys', 'mysql', 'performance_schema' ) 
	AND ENGINE <> 'InnoDB';
~~~

效果如下：

~~~bash
+--------------+--------------------------------------------+--------+
| table_schema | table_name                                 | ENGINE |
+--------------+--------------------------------------------+--------+
| test         | test_table                                 | MyISAM |
+--------------+--------------------------------------------+--------+
~~~

## 批量构造修改存储引擎的语句

~~~sql
SELECT DISTINCT
	concat( 'alter table ', table_schema, '.', table_name, ' engine=innodb', ';' ) 
FROM
	information_schema.TABLES 
WHERE
	(
	ENGINE <> 'innodb' 
	AND table_schema NOT IN ( 'information_schema', 'sys', 'mysql', 'performance_schema' ));
~~~

效果如下：

~~~bash
+--------------------------------------------------------------------------------+
| concat( 'alter table ', table_schema, '.', table_name, ' engine=innodb', ';' ) |
+--------------------------------------------------------------------------------+
| alter table test.tables engine=innodb;            			     |
+--------------------------------------------------------------------------------+
~~~

## 查看每张表数据量，并按数据量排序

~~~sql
SELECT
	table_schema,
	table_name,
	table_rows 
FROM
	information_schema.TABLES 
WHERE
	table_schema NOT IN ( 'information_schema', 'sys', 'mysql', 'performance_schema' ) 
ORDER BY
	table_rows DESC;
~~~

效果如下：

~~~bash
+-----------------+--------------------------------------------+------------+
| table_schema    | table_name                                 | table_rows |
+-----------------+--------------------------------------------+------------+
| test            | test.tables1                  			   |    2484153 |
| test            | test.tables2				               |    2228574 |
+-----------------+--------------------------------------------+------------+
~~~

## 某个库所有表的字段详情

~~~sql
SELECT
	table_schema,
	table_name,
	column_name,
	column_type,
	collation_name 
FROM
	information_schema.COLUMNS 
WHERE
	table_schema = 'DB_NAME';
~~~

效果如下：

~~~bash
+--------------+--------------------+---------------------+--------------+----------------+
| table_schema | table_name         | column_name         | column_type  | collation_name |
+--------------+--------------------+---------------------+--------------+----------------+
| test         | april_project_list | id                  | bigint(11)   | NULL           |
| test         | april_project_list | project_name        | varchar(50)  | utf8_bin       |
| test         | april_project_list | description         | varchar(255) | utf8_bin       |
| test         | april_project_list | project_description | varchar(255) | utf8_bin       |
| test         | april_project_list | project_start_time  | datetime     | NULL           |
| test         | april_project_list | project_end_time    | datetime     | NULL           |
| test         | april_project_list | company             | varchar(50)  | utf8_bin       |
| test         | april_project_list | technology          | varchar(255) | utf8_bin       |
| test         | april_project_list | post                | char(1)      | utf8_bin       |
+--------------+--------------------+---------------------+--------------+----------------+
~~~

## 查看某张表的具体信息

~~~sql
SELECT
	* 
FROM
	information_schema.TABLES 
WHERE
	table_schema = 'DB_NAME' 
	AND table_name = 'TABLE_NAME';
~~~

效果如下：

~~~bash
+---------------+--------------+--------------------+------------+--------+---------+------------+------------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+-----------------+----------+----------------+---------------+
| TABLE_CATALOG | TABLE_SCHEMA | TABLE_NAME         | TABLE_TYPE | ENGINE | VERSION | ROW_FORMAT | TABLE_ROWS | AVG_ROW_LENGTH | DATA_LENGTH | MAX_DATA_LENGTH | INDEX_LENGTH | DATA_FREE | AUTO_INCREMENT | CREATE_TIME         | UPDATE_TIME | CHECK_TIME | TABLE_COLLATION | CHECKSUM | CREATE_OPTIONS | TABLE_COMMENT |
+---------------+--------------+--------------------+------------+--------+---------+------------+------------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+-----------------+----------+----------------+---------------+
| def           | test         | april_project_list | BASE TABLE | InnoDB |      10 | Dynamic    |          0 |              0 |       16384 |               0 |            0 |         0 |              1 | 2022-07-26 04:01:39 | NULL        | NULL       | utf8_bin        | NULL     |                |               |
+---------------+--------------+--------------------+------------+--------+---------+------------+------------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+-----------------+----------+----------------+---------------+
~~~

## 查看 MySQL 所有用户

~~~sql
SELECT DISTINCT
	concat( "'", USER, '''@''', HOST, "';" ) AS USER 
FROM
	mysql.USER;
~~~

效果如下：

~~~bash
+------------------------------+
| USER                         |
+------------------------------+
| 'root'@'%';                  |
| 'root'@'localhost';          |
+------------------------------+
~~~

## 查看某个库所有表的碎片率

~~~sql
SELECT
	table_name,
	data_free / ( data_free + data_length + index_length ) AS value,
	data_free,
	data_length,
	index_length 
FROM
	information_schema.TABLES 
WHERE
	table_schema = 'DB_NAME' 
ORDER BY
	data_length DESC;
~~~

效果如下：

~~~bash
+--------------------+--------+-----------+-------------+--------------+
| table_name         | aaa    | data_free | data_length | index_length |
+--------------------+--------+-----------+-------------+--------------+
| april_project_list | 0.0000 |         0 |       16384 |            0 |
+--------------------+--------+-----------+-------------+--------------+
~~~

## 查询指定数据库所占空间大小

~~~sql
SELECT concat( round( sum( data_length )/( 1024 * 1024 ), 2 ) + round( sum( index_length )/( 1024 * 1024 ),
		2 
		),
	'MB' 
) AS 'DB Size' 
FROM
TABLES 
WHERE
	table_schema = 'DB_NAME';
~~~

效果如下：

~~~bash
+---------+
| DB Size |
+---------+
| 0.02MB  |
+---------+
~~~

## 查看索引所占的空间大小

~~~~sql
SELECT concat( round( sum( index_length )/( 1024 * 1024 ),
		2 
		),
	'MB' 
) AS 'DB Size' 
FROM
TABLES 
WHERE
	table_schema = 'test';
~~~~

效果如下：

~~~bash
+---------+
| DB Size |
+---------+
| 0.02MB  |
+---------+
~~~

## 查询数据库最大链接数

~~~sql
SHOW VARIABLES LIKE '%max_connections%';
~~~

效果如下：

~~~~bash
+-----------------+-------+
| Variable_name   | Value |
+-----------------+-------+
| max_connections | 151   |
+-----------------+-------+
~~~~

## 查看数据库当前连接数，并发数

~~~sql
SHOW STATUS LIKE 'Threads%';
~~~

效果如下：

~~~bash
+-------------------+-------+
| Variable_name     | Value |
+-------------------+-------+
| Threads_cached    | 5     |
| Threads_connected | 50    |
| Threads_created   | 164   |
| Threads_running   | 1     |
+-------------------+-------+
~~~

> Threads_cached: 代表当前此时此刻线程缓存中有多少空闲线程。
>
> Threads_connected: 代表当前已建立连接的数量，因为一个连接就需要一个线程，所以也可以看成当前被使用的线程数。
>
> Threads_created: 代表从最近一次服务启动，已创建线程的数量。
>
> Threads_running: 代表当前激活的（非睡眠状态）线程数。并不是代表正在使用的线程数，有时候连接已建立，但是连接处于 sleep 状态，这里相对应的线程也是 sleep 状态。

## 查看数据文件存放路径

~~~sql
SHOW VARIABLES LIKE '%datadir%';
~~~

效果如下：

~~~bash
+---------------+-----------------+
| Variable_name | Value           |
+---------------+-----------------+
| datadir       | /var/lib/mysql/ |
+---------------+-----------------+
~~~
