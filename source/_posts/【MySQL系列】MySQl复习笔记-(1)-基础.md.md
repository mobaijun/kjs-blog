---
title: 【MySQL系列】MySQl复习笔记-(1)-基础.md
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - 基础复习
categories:
  - 数据库
abbrlink: 1108852137
date: 2020-05-20 14:06:18
img:
coverImg:
password:
summary:
---

### 启动/关闭

* **启动(以管理员模式运行命令行)**

~~~bash
net start mysql
~~~

* **关闭(以管理员模式运行命令行)**

~~~bash
net stop mysql
~~~

### 登录/退出

* 登录

~~~bash
mysql -u"用户名" -p"密码"
~~~

* **登录格式二**

~~~bash
mysql -h"ip地址" -u"用户名" -p"密码"
~~~

* **退出**

~~~bash
exit
~~~

### 图形化界面

* [Navicat](https://www.navicat.com.cn/products)
* [SQLyog](https://sqlyog.softonic.cn/)
* 当然,我个人是不建议使用`SQLyog`的,推荐使用`Navicat`,因为`Navicat`真的很强大

### SQL语句分类

* **什么是SQL语句**

  * 结构化查询语言(**S**tructured **Q**uery **L**anguage)简称SQL。
  * SQL语句就是对数据库进行操作的一种语言。

* **SQL的作用**

  * 通过SQL语句我们可以**方便**的操作数据库、表、数据。
  * SQL是数据库管理系统都需要遵循的规范。不同的数据库生产厂商都支持SQL语句，但都有特有内容。

* **SQL语句分类**

  * <font color="red">**DDL**</font>(Data Definition Language)数据定义语言
    用来定义数据库对象：数据库，表，列等。关键字：create, drop,alter等

  * <font color="red">**DML**</font>(Data Manipulation Language)数据操作语言
    用来对数据库中表的数据进行增删改。关键字：insert, delete, update等

  * <font color="red">**DQL**</font>(Data Query Language) 数据查询语言
    对数据库进行数据查询，关键字select。

  * <font color="red">**DCL**</font>(Data Control Language)数据控制语言(了解)

    是用来设置或更改数据库用户或角色权限的语句，这个比较少用到。

* **SQL通用语法**

  * SQL语句可以单行或多行书写,分号结尾
  * 可以使用空格和缩进增强语句的可读性
  * MySQL数据库的SQL语句不区分大小写,关键字建议大写
  * **三种注释**
    * 单行注释(-- 注释内容)
    * 多行注释(/* 注释内容 */)
    * 注释内容(# 注释内容/MySQL特有)

~~~sql
-- 查询mobai表
SELECT 
	* 
	FROM
		mobai;
~~~

### DDL操作数据库

* **创建数据库**

~~~sql
CREATE DATABASE IF NOT EXISTS '数据库名';
~~~

* **判断是否存在相同数据库并创建**

~~~sql
CREATE DATABASE '数据库名' DEFAULT CHARACTER SET '字符集';
~~~

* **创建数据库并指定编码**

~~~sql
CREATE DATABASE '数据库名' DEFAULT CHARACTER SET '字符集';
~~~

* **查看数据库**

~~~sql
SHOW DATABASES;
~~~

* **查看当前数据库详细信息**

~~~sql
SHOW CREATE DATABASE '数据库';
~~~

* **修改数据库编码**

~~~sql
ALTER DATABASE '数据库名' DEFAULT CHARACTER SET '新字符集';
~~~

* **删除数据库**

~~~sql
DROP DATABASE '数据名';
~~~

* **查看当前使用数据库**

~~~sql
SELECT DATABASE();
~~~

* **切换数据库**

~~~sql
USE '数据库';
~~~

* **DDL小结**

| DDL语句操作数据库 | 关键字                                                    |
| :---------------: | :-------------------------------------------------------- |
|       创建        | **CREATE** DATABASE 数据库名;                             |
|       修改        | **ALTER** DATABASE 数据库名 DEFAULT CHARACTER SET 字符集; |
|       查看        | **SHOW** CREATE DATABASE 数据库名;                        |
|       删除        | **DROP** DATABASE 数据库名;                               |

* **创建表**

~~~sql
CREATE TABLE '表名' ('字段名 字段类型, 字段名 字段类型');
~~~

* **MySQL(常用)数据类型**

|  类型   |    描述    |
| :-----: | :--------: |
|   int   |    整型    |
| double  |  浮点类型  |
| varchar | 字符串类型 |
|  date   |  日期类型  |

* **查看数据库中所有表**

~~~sql
SHOW TABLES;
~~~

* **查看表结构**

~~~sql
DESC '表名';
~~~

* **查看创建表的SQL语句**

~~~sql
SHOW CREATE TABLE '表名';
~~~

* **快速创建一个表结构相同的表**

~~~sql
CREATE TABLE '新表名' LIKE '旧表名';
~~~

* **删除表**

~~~sql
DROP TABLE '表名';
~~~

* **判断是否存在并删除表**

~~~sql
DROP TABLE IF EXISTS '表名';
~~~

#### DDL修改表结构

* **给表添加一列**

~~~sql
ALTER TABLE '表名' ADD '字段名' '字段类型';
~~~

* **修改列类型**

~~~sql
ALTER TABLE '表名' MODIFY '字段名' '新的类型';
~~~

* **修改列名字**

~~~sql
ATLER TABLE '表名' CHANGE '老字段名' '新字段名' '字段类型';
~~~

* **删除列**

~~~sql
ALTER TABLE '表名' DROP '字段名';
~~~

* **修改表名**

~~~sql
RENAME TABLE '旧表名' TO '新表名';
~~~

* **修改表的字符集**

~~~sql
ALTER TABLE '表名' DEFAULT CHARACTER SET '新字符集';
~~~

### DML插入记录

> DML是对表中的数据进行增删改

* **插入全部字段**

~~~sql
INSERT INTO '表名' ('字段名1, 字段名2, 字段名3') VALUES ('值1, 值2, 值3');
~~~

* **简化写法**

~~~sql
INSERT INTO '表名' VALUES ('值1, 值2, 值3');
~~~

* **解决MySQL/DOS窗口中文乱码问题**

> 错误原因:因为MySQL的客户端设置编码是utf8,而系统的DOS命令行编码是gbk，编码不一致导致的乱码

~~~sql
set names gbk; -- 告诉mysql传输数据的时候,使用gbk
~~~

### DML更新表记录

* **不带条件修改数据**

~~~sql
UPDATE '表名' SET '字段名'='新的值';
~~~

* **待条件修改数据新的值**

~~~sql
UPDATE '表名' SET '字段名=新的值' WHERE '条件';
~~~

**关键字说明**

* `UPDATE`: -- 表示修改
* `SET`: -- 修改的字段
* `WHERE`: -- 指定条件

### DML删除表记录

* **带条件删除数据**

~~~sql
DELETE FROM '表名' WHERE '条件';
~~~

* **不带条件删除数据**

~~~sql
DELETE FROM '表名';
~~~

* **注意**

  >- 值与字段必须对应，个数相同，类型相同
  >- 值的数据大小必须在字段的长度范围内
  >- 除了数值类型外，其它的字段类型的值必须使用引号引起。（建议单引号）
  >- 如果要插入空值，可以不写字段，或者插入null

### DQL没有条件的简单查询

> 注意：查询不会对数据库中的数据进行修改，只是一种显示数据的方式。

* **写出查询每列的名称**

~~~sql
SELECT '字段名1', '字段名2' FROM '表名';
~~~

* **使用*表示所有列**

~~~sql
SELECT * FROM '表名';
~~~

* **查询表中指定列数据**
  * 查询指定列的数据,多个列之间以逗号分隔

~~~sql
SELECT '字段名1', '字段名2' FROM '表名';
~~~

* **别名查询**
  * 查询时给列、表指定别名需要使用AS关键字
  * 使用别名的好处是方便观看和处理查询到的数据

~~~sql
SELECT 字段名1 AS 别名, 字段名2 AS 别名... FROM 表名;
SELECT 字段名1 AS 别名, 字段名2 AS 别名... FROM 表名 AS 表别名;
~~~

* **清除重复值**

~~~sql
SELECT DISTINCT '字段名' FROM '表名';
~~~

* **某列数据和固定值运算**

~~~sql
SELECT 字段名 + 数值 FROM 表名;
~~~

* 某列数据和其他列数据参与运算

~~~sql
SELECT 字段1 + 字段2 FROM 表名;
~~~

> 注意: 参与运算的必须是数值类型

### 蠕虫复制

> 什么是蠕虫复制：在已有的数据基础之上，将原来的数据进行复制，插入到对应的表中

~~~sql
INSERT INTO 表名1 SELECT 字段名 FROM 表名2;
~~~