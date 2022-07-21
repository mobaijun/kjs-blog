---
title: 【MySQL系列】MySQL复习笔记(2)-约束
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - 基础复习
categories:
  - 数据库
abbrlink: 1359261681
date: 2020-05-21 17:03:51
img:
coverImg:
password:
summary:
---

### DQL查询语句

* 查询满足条件的数据

~~~sql
SELECT 字段 FROM 表名 WHERE 条件;
~~~

* MySQL运算符

|  >   |   大于   |
| :--: | :------: |
|  <   |   小于   |
|  <=  | 小于等于 |
|  >=  | 大于等于 |
|  =   |   等于   |
|  <>  |  不等于  |
|  !=  |  不等于  |

* test

~~~sql
SELECT * FROM "表名" WHERE '字段'='值';
~~~

#### 逻辑运算符

|   and   |     多个条件同时满足     |
| :-----: | :----------------------: |
| **or**  | **多个条件其中一个满足** |
| **not** |       **都不满足**       |

* test

~~~sql
SELECT * FROM "表名" WHERE '字段'>'值' AND '字段'='值';
~~~

* in**关键字**

> `in`里面的每个数据都会作为一次条件，只要满足条件的就会显示

* test

~~~sql
SELECT * FROM '表名' WHERE 字段名 IN (值1, 值2, 值3);
~~~

* **BETWEEN**关键字

~~~sql
BETWEEN 值1 AND 值2;
~~~

> 比如：`age BETWEEN 80 AND 100`
>
> 相当于： `age>=80 && age<=100` 

### **模糊查询**

**关键字(like)**表示模糊查询

~~~sql
SELECT 字段 FROM 表名 WHERE 字段名 LIKE '规则';
~~~

满足`通配符字符串`规则的数据就会显示出来

>  所谓的`通配符字符串`就是`含有通配符的字符串`

MySQL通配符有两个：

* %`: 表示任意多个字符
  `

* `_`: 表示一个字符

* test

~~~sql
SELECT * FROM '表名' WHERE NAME LIKE '值%';
SELECT * FROM '表名' WHERE NAME LIKE '值__';
~~~

### DQL-排序

**ORDER BY**关键字可以将查询出的结果进行排序

~~~sql
SELECT 字段 FROM 表名 WHERE 条件 ORDER BY 字段 [ASC|DESC];
[]:表示可有可无
|:或者多个中选择一个
~~~

* **ASC:升序(默认)**
* **DESC:降序**

#### 单列排序

> 单列排序就是使用一个字段排序

~~~sql
select * FROM '表名' order by '字段' DESC;
~~~

#### 组合排序

> 组合排序就是先按第一个字段进行排序，如果第一个字段相同，才按第二个字段进行排序，依次类推。

~~~sql
SELECT * FROM '表名' WHERE '条件' ORDER BY '字段名' [ASC|DESC], '字段名' [ASC|DESC];
~~~

### 聚合函数

之前的查询都是横向查询，它们都是根据条件一行一行的进行判断，而使用聚合函数查询是纵向查询，它是对一列的值进行计算，然后返回一个结果值。另外聚合函数会忽略空值NULL。

| count(字段) |         统计指定列记录数，记录为NULL的不统计          |
| :---------: | :---------------------------------------------------: |
|  sum(字段)  | 计算指定列的数值和，如果不是数值类型，那么计算结果为0 |
|  max(字段)  |                  计算指定列的最大值                   |
|  min(字段)  |                  计算指定列的最小值                   |
|  avg(字段)  |                  计算指定列的平均值                   |

* **COUNT(*):表示表中所有字段**

~~~sql
SELECT COUNT(*) FROM '表名';
~~~

* **SUM(math):表示分数求和**

~~~sql
SELECT SUM(math) FROM '表名';
~~~

* **MAX(math)表示查询math最高分**

~~~sql
SELECT MAX(math) FROM '表名';
~~~

* **MIN(math):查询数学成绩最低分**

~~~sql
SELECT MIN(math) FROM '表名';
~~~

* **AVG(math):查询数学成绩平均分**

~~~sql
SELECT AVG(math) FROM '表名';
~~~

### 分组查询

> 分组查询是指使用 `GROUP BY`语句对查询信息进行分组

~~~sql
SELECT 字段名 FROM 表名 WHERE 条件 GROUP BY 字段;
~~~

* GROUP BY怎么分组的？
  **将分组字段结果中相同内容作为一组**

~~~sql
SELECT * FROM '表名' GROUP BY sex;
~~~

> `GROUP BY`将分组字段的相同值作为一组，并且返回每组的第一条数据，所以单独分组没什么用处。分组的目的就是为了统计，一般分组会跟聚合函数一起使用。

分组后聚合函数的作用？不是操作所有数据，而是<font color="red">分别操作每组数据</font>。

~~~sql
SELECT SUM(math), sex FROM '表名' GROUP BY sex;
~~~

### limit语句

> `LIMIT`是`限制`的意思，所以`LIMIT`的作用就是限制查询记录的条数。

~~~sql
SELECT 字段 FROM 表名 WHERE 条件 LIMIT offset, length;
~~~

> `offset`是指偏移量，可以认为是跳过的记录数量，不写则默认为0。
> `length`是指需要显示的总记录数

* test

~~~sql
SELECT * FROM '表名' LIMIT 2,6;
~~~

**LIMIT的使用场景**：`分页`

比如我们登录京东，淘宝，返回的商品信息可能有几万条，不是一次全部显示出来。是一页显示固定的条数。假设我们一每页显示5条记录的方式来分页。

~~~sql
-- 每页显示5条
-- 第一页： LIMIT 0,5;	跳过0条，显示5条
-- 第二页： LIMIT 5,5;  跳过5条，显示5条
-- 第三页： LIMIT 10,5; 跳过10条，显示5条
SELECT * FROM student3 LIMIT 0,5;
SELECT * FROM student3 LIMIT 5,5;
SELECT * FROM student3 LIMIT 10,5;
~~~

> **注意**：
>
> * 如果第一个参数是0可以简写：
>   `SELECT * FROM 表名 LIMIT 0,5;`
>    `SELECT * FROM 表名 LIMIT 5;`
> * LIMIT 10，5; -- 不够5条，有多少显示多少

### 备份

* 备份的应用场景

> 在服务器进行数据传输、数据存储和数据交换，就有可能产生数据故障。比如发生意外停机或存储介质损坏。这时，如果没有采取数据备份和数据恢复手段与措施，就会导致数据的丢失，造成的损失是无法弥补与估量的。

#### 命令行备份

* 命令行

~~~bash
$ mysqldump -u用户名 -p密码 数据库 > 文件的路径
~~~

* 还原(还原的时候需要先登录MySQL,并选中对应的数据库)

~~~bash
SOURCE 导入文件的路径
~~~

#### MySQL图形化界面工具备份

* [SQLyog](https://www.webyog.com/product/sqlyog)
* [Navicat](https://www.navicat.com.cn/manual/online_manual/cn/navicat/win_manual/#/backup_restore_0)

> 超简单,导出上SQL文件即可,不熟悉也可参阅官方文档

### 数据库约束

> ​	对表中的数据进行进一步的限制，保证数据的**正确性**、**有效性**和**完整性**。

#### 约束种类

|   PRIMARY KEY   |    主键约束    |
| :-------------: | :------------: |
|   **UNIQUE**    |  **唯一约束**  |
|  **NOT NULL**   |  **非空约束**  |
|   **DEFAULT**   | **默认值约束** |
| **FOREIGN KEY** |  **外键约束**  |

#### 创建主键约束

> 每张表都应该有一个主键，并且每张表只能有一个主键。
>
> 哪个字段作为表的主键?
>
> * 通常不用业务字段作为主键，单独给每张表设计一个id的字段，把id作为主键。主键是给数据库和程序使用的，不是给最终的客户使用的。所以主键有没有含义没有关系，只要不重复，非空就行。

* 建表时添加约束

~~~sql
CREATE TABLE 表名 (
	字段名 字段类型 PRIMARY KEY,
	字段名 字段类型
);
~~~

* 在已有表中添加约束

~~~sql
ALTER TABLE 表名 ADD PRIMARY KEY(字段);
~~~

* 删除主键

~~~sql
ALTER TABLE 表名 DROP PRIMARY KEY;
~~~

### 主键自增

> 需求:主键如果让我们自己添加很有可能重复,我们通常希望在每次插入新记录时,数据库自动生成主键字段的值

~~~sql
字段名 字段类型 PRIMARY KEY AUTO_INCREMENT
~~~

* 默认地AUTO_INCREMENT 的开始值是1，如果希望修改起始值,请使用下列SQL语法

~~~sql
ALTER TABLE 表名 AUTO_INCREMENT=起始值;
~~~

### 唯一约束

> 表中字段的值不能重复

~~~sql
字段名 字段类型 UNIQUE
~~~

### 非空约束

> 表中字段的值不能为NULL

~~~sql
字段名 字段类型 NOT NULL
~~~

### 默认值约束

> 不指定这个字段的数据,就使用默认值

~~~sql
字段名 字段类型 default 值
~~~

### 外键约束

> 一个表中的字段引用另一个表的主键
>
> * 主表： 主键所在的表,约束别人的表,将数据给别人用
> * 副表/从表： 外键所在的表,被约束的表,使用别人的数据

* 创建外键

~~~sql
CREATE TABLE 表名 (
	字段名 字段类型,
    字段名 字段类型,
    CONSTRAINT 外键约束名 FOREIGN KEY(外键字段名) REFERENCES 主表(主键)
);
-- 外键约束名: fk开头, fk结尾
~~~

* 关键字释义
  * CONSTRAINT:  表示建立外键约束
  * FOREIGN KEY(外键字段名): 让哪个字段作为外键
  * REFERENCES 主表名(主键字段名) : 参照哪个表的哪个字段

* 已有表增加外键

~~~sql
ALTER TABLE 表名 ADD CONSTRAINT 外键约束名 FOREIGN KEY(外键字段名) REFERENCES 主表(主键);
~~~

* 删除外键约束

~~~sql
ALTER TABLE 表名 DROP FOREIGN KEY(外键约束名);
~~~

### 外键的级联

> 在修改和删除主表的主键时，同时更新或删除副表的外键值，称为级联操作

* `ON UPDATE CASCADE` -- 级联更新,主表更新时,从表跟着更新
* `ON DELETE CASCADE` -- 级联删除,主表删除时,从表跟着删除

**测试**

~~~sql
CREATE TABLE employee (
	id INT PRIMARY KEY AUTO_INCREMENT,
	NAME VARCHAR(30),
	age INT,
	dep_id INT,
	-- 添加外键约束,并且添加级联更新和级联删除
	CONSTRAINT employee_dep_fk FOREIGN KEY (dep_id) REFERENCES department(id) ON UPDATE CASCADE ON DELETE CASCADE
);
~~~

### 表关系概念

#### 一对一

> 在实际的开发中应用不多.因为一对一可以创建成一张表。
>
> 两种建表原则：
>
> * 外键唯一：主表的主键和从表的外键（唯一），形成主外键关系，外键唯一`UNIQUE`
>
> * 外键是主键：主表的主键和从表的主键，形成主外键关系

#### 一对多

> * 例如：班级和学生，部门和员工，客户和订单，分类和商品
>
>   一对多建表原则: 在从表(多方)创建一个字段,字段作为外键指向主表(一方)的主键

#### 多对多

>* 例如：老师和学生，学生和课程
>  多对多关系建表原则: 需要创建第三张表，中间表中至少两个字段，这两个字段分别作为外键指向各自一方的主键。