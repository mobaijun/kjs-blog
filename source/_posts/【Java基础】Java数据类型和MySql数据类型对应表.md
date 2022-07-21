---
title: 【Java基础】Java数据类型和MySql数据类型对应表
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 961492254
tags:
  - 小知识
categories:
  - 后端
date: 2021-08-19 11:27:50
img:
coverImg:
password:
summary:
---

* MySQL数据类型对应Java数据类型

| **类型名称**  | **显示长度** | **数据库类型**            | **JAVA类型**             | **JDBC类型索引(int)** | **描述** |
| ------------- | ------------ | ------------------------- | ------------------------ | --------------------- | -------- |
|               |              |                           |                          |                       |          |
|               |              |                           |                          |                       |          |
| **VARCHAR**   | **L+N**      | **VARCHAR**               | **java.lang.String**     | **12**                |          |
| **CHAR**      | **N**        | **CHAR**                  | **java.lang.String**     | **1**                 |          |
| **BLOB**      | **L+N**      | **BLOB**                  | **java.lang.byte[]**     | **-4**                |          |
| **TEXT**      | **65535**    | **VARCHAR**               | **java.lang.String**     | **-1**                |          |
|               |              |                           |                          |                       |          |
|               |              |                           |                          |                       |          |
| **INTEGER**   | **4**        | **INTEGER UNSIGNED**      | **java.lang.Long**       | **4**                 |          |
| **TINYINT**   | **3**        | **TINYINT UNSIGNED**      | **java.lang.Integer**    | **-6**                |          |
| **SMALLINT**  | **5**        | **SMALLINT UNSIGNED**     | **java.lang.Integer**    | **5**                 |          |
| **MEDIUMINT** | **8**        | **MEDIUMINT UNSIGNED**    | **java.lang.Integer**    | **4**                 |          |
| **BIT**       | **1**        | **BIT**                   | **java.lang.Boolean**    | **-7**                |          |
| **BIGINT**    | **20**       | **BIGINT UNSIGNED**       | **java.math.BigInteger** | **-5**                |          |
| **FLOAT**     | **4+8**      | **FLOAT**                 | **java.lang.Float**      | **7**                 |          |
| **DOUBLE**    | **22**       | **DOUBLE**                | **java.lang.Double**     | **8**                 |          |
| **DECIMAL**   | **11**       | **DECIMAL**               | **java.math.BigDecimal** | **3**                 |          |
| **BOOLEAN**   | **1**        | **同TINYINT**             |                          |                       |          |
|               |              |                           |                          |                       |          |
|               |              |                           |                          |                       |          |
| **ID**        | **11**       | **PK (INTEGER UNSIGNED)** | **java.lang.Long**       | **4**                 |          |
|               |              |                           |                          |                       |          |
|               |              |                           |                          |                       |          |
| **DATE**      | **10**       | **DATE**                  | **java.sql.Date**        | **91**                |          |
| **TIME**      | **8**        | **TIME**                  | **java.sql.Time**        | **92**                |          |
| **DATETIME**  | **19**       | **DATETIME**              | **java.sql.Timestamp**   | **93**                |          |
| **TIMESTAMP** | **19**       | **TIMESTAMP**             | **java.sql.Timestamp**   | **93**                |          |
| **YEAR**      | **4**        | **YEAR**                  | **java.sql.Date**        | **91**                |          |

> 对于bolb，一般用于对图片的数据库存储，原理是把图片打成二进制，然后进行的一种存储方式，在java中对应byte［］数组。
>
> 对于boolen类型，在mysql数据库中，个人认为用int类型代替较好，对bit操作不是很方便，尤其是在具有web页面开发的项目中，表示0/1，对应java类型的Integer较好。[Java数据类型和MySql数据类型对应表 - 草原和大树 - 博客园](https://www.cnblogs.com/JemBai/archive/2009/08/20/1550683.html)

* Mybatis数据类型对应数据库和Java数据类型

| Mybatis  | JdbcType      | Oracle         | MySql              |
| -------- | ------------- | -------------- | ------------------ |
| JdbcType | ARRAY         |                |                    |
| JdbcType | BIGINT        |                | BIGINT             |
| JdbcType | BINARY        |                |                    |
| JdbcType | BIT           |                | BIT                |
| JdbcType | BLOB          | BLOB           | BLOB               |
| JdbcType | BOOLEAN       |                |                    |
| JdbcType | CHAR          | CHAR           | CHAR               |
| JdbcType | CLOB          | CLOB           | CLOB–>修改为TEXT   |
| JdbcType | CURSOR        |                |                    |
| JdbcType | DATE          | DATE           | DATE               |
| JdbcType | DECIMAL       | DECIMAL        | DECIMAL            |
| JdbcType | DOUBLE        | NUMBER         | DOUBLE             |
| JdbcType | FLOAT         | FLOAT          | FLOAT              |
| JdbcType | INTEGER       | INTEGER        | INTEGER            |
| JdbcType | LONGVARBINARY |                |                    |
| JdbcType | LONGVARCHAR   | LONG VARCHAR   |                    |
| JdbcType | NCHAR         | NCHAR          |                    |
| JdbcType | NCLOB         | NCLOB          |                    |
| JdbcType | NULL          |                |                    |
| JdbcType | NUMERIC       | NUMERIC/NUMBER | NUMERIC/           |
| JdbcType | NVARCHAR      |                |                    |
| JdbcType | OTHER         |                |                    |
| JdbcType | REAL          | REAL           | REAL               |
| JdbcType | SMALLINT      | SMALLINT       | SMALLINT           |
| JdbcType | STRUCT        |                |                    |
| JdbcType | TIME          |                | TIME               |
| JdbcType | TIMESTAMP     | TIMESTAMP      | TIMESTAMP/DATETIME |
| JdbcType | TINYINT       |                | TINYINT            |
| JdbcType | UNDEFINED     |                |                    |
| JdbcType | VARBINARY     |                |                    |
| JdbcType | VARCHAR       | VARCHAR        | VARCHAR            |

> 注意到, MyBatis的JdbcType中部分没有对应到Oracle和Mysql的数据类型中(或许由于自己遗漏)，不过不用担心，后续大家碰到再具体分析；同时上述对应关系不一定是一一对应，请大家了解。[MyBatis 常用类型](https://juejin.cn/post/6844903902446354439)

* Oracle数据类型对应Java数据类型

| SQL数据类型                      | JDBC类型代码                           | 标准的Java类型         | Oracle扩展的Java类型          |
| -------------------------------- | -------------------------------------- | ---------------------- | ----------------------------- |
|                                  | 1.0标准的JDBC类型:                     |                        |                               |
| `CHAR`                           | `java.sql.Types.CHAR`                  | `java.lang.String`     | `oracle.sql.CHAR`             |
| `VARCHAR2`                       | `java.sql.Types.VARCHAR`               | `java.lang.String`     | `oracle.sql.CHAR`             |
| `LONG`                           | `java.sql.Types.LONGVARCHAR`           | `java.lang.String`     | `oracle.sql.CHAR`             |
| `NUMBER`                         | `java.sql.Types.NUMERIC`               | `java.math.BigDecimal` | `oracle.sql.NUMBER`           |
| `NUMBER`                         | `java.sql.Types.DECIMAL`               | `java.math.BigDecimal` | `oracle.sql.NUMBER`           |
| `NUMBER`                         | `java.sql.Types.BIT`                   | `boolean`              | `oracle.sql.NUMBER`           |
| `NUMBER`                         | `java.sql.Types.TINYINT`               | `byte`                 | `oracle.sql.NUMBER`           |
| `NUMBER`                         | `java.sql.Types.SMALLINT`              | `short`                | `oracle.sql.NUMBER`           |
| `NUMBER`                         | `java.sql.Types.INTEGER`               | `int`                  | `oracle.sql.NUMBER`           |
| `NUMBER`                         | `java.sql.Types.BIGINT`                | `long`                 | `oracle.sql.NUMBER`           |
| `NUMBER`                         | `java.sql.Types.REAL`                  | `float`                | `oracle.sql.NUMBER`           |
| `NUMBER`                         | `java.sql.Types.FLOAT`                 | `double`               | `oracle.sql.NUMBER`           |
| `NUMBER`                         | `java.sql.Types.DOUBLE`                | `double`               | `oracle.sql.NUMBER`           |
| `RAW`                            | `java.sql.Types.BINARY`                | `byte[]`               | `oracle.sql.RAW`              |
| `RAW`                            | `java.sql.Types.VARBINARY`             | `byte[]`               | `oracle.sql.RAW`              |
| `LONGRAW`                        | `java.sql.Types.LONGVARBINARY`         | `byte[]`               | `oracle.sql.RAW`              |
| `DATE`                           | `java.sql.Types.DATE`                  | `java.sql.Date`        | `oracle.sql.DATE`             |
| `DATE`                           | `java.sql.Types.TIME`                  | `java.sql.Time`        | `oracle.sql.DATE`             |
| `TIMESTAMP`                      | `java.sql.Types.TIMESTAMP`             | `javal.sql.Timestamp`  | `oracle.sql.TIMESTAMP`        |
|                                  | 2.0标准的JDBC类型:                     |                        |                               |
| `BLOB`                           | `java.sql.Types.BLOB`                  | `java.sql.Blob`        | `oracle.sql.BLOB`             |
| `CLOB`                           | `java.sql.Types.CLOB`                  | `java.sql.Clob`        | `oracle.sql.CLOB`             |
| 用户定义的对象                   | `java.sql.Types.STRUCT`                | `java.sql.Struct`      | `oracle.sql.STRUCT`           |
| 用户定义的参考                   | `java.sql.Types.REF`                   | `java.sql.Ref`         | `oracle.sql.REF`              |
| 用户定义的集合                   | `java.sql.Types.ARRAY`                 | `java.sql.Array`       | `oracle.sql.ARRAY`            |
|                                  | Oracle扩展:                            |                        |                               |
| `BFILE`                          | `oracle.jdbc.OracleTypes.BFILE`        | N/A                    | `oracle.sql.BFILE`            |
| `ROWID`                          | `oracle.jdbc.OracleTypes.ROWID`        | N/A                    | `oracle.sql.ROWID`            |
| `REF CURSOR`                     | `oracle.jdbc.OracleTypes.CURSOR`       | `java.sql.ResultSet`   | `oracle.jdbc.OracleResultSet` |
| `TIMESTAMP`                      | `oracle.jdbc.OracleTypes.TIMESTAMP`    | `java.sql.Timestamp`   | `oracle.sql.TIMESTAMP`        |
| `TIMESTAMP WITH TIME ZONE`       | `oracle.jdbc.OracleTypes.TIMESTAMPTZ`  | `java.sql.Timestamp`   | `oracle.sql.TIMESTAMPTZ`      |
| `TIMESTAMP WITH LOCAL TIME ZONE` | `oracle.jdbc.OracleTypes.TIMESTAMPLTZ` | `java.sql.Timestamp`   | `oracle.sql.TIMESTAMPLTZ`     |

> [oracle中数据类型对应java类型 - 沧海一滴 - 博客园](https://www.cnblogs.com/softidea/p/7101091.html)

* SQL Server字段类型对应java数据类型

| SQL Server 类型        | JDBC 类型                             | Java数据类型                 |
| ---------------------- | ------------------------------------- | ---------------------------- |
| bigint                 | BIGINT                                | long                         |
| timestampbinary        | BINARY                                | byte[]                       |
| bit                    | BIT                                   | boolean                      |
| char                   | CHAR                                  | String                       |
| decimalmoneysmallmoney | DECIMAL                               | java.math.BigDecimal         |
| float                  | DOUBLE                                | double                       |
| int                    | INTEGER                               | int                          |
| imagevarbinary(max)    | LONGVARBINARY                         | byte[]                       |
| varchar(max)text       | LONGVARCHAR                           | String                       |
| nchar                  | CHARNCHAR (Java SE 6.0)               | String                       |
| nvarchar(max)ntext     | LONGVARCHARLONGNVARCHAR (Java SE 6.0) | String                       |
| numeric                | NUMERIC                               | java.math.BigDecimal         |
| real                   | REAL                                  | float                        |
| smallint               | SMALLINT                              | short                        |
| datetimesmalldatetime  | TIMESTAMP                             | java.sql.Timestamp           |
| varbinaryudt           | VARBINARY                             | byte[]                       |
| varchar                | VARCHAR                               | String                       |
| tinyint                | TINYINT                               | short                        |
| uniqueidentifier       | CHAR                                  | String                       |
| xml                    | LONGVARCHARSQLXML (Java SE 6.0)       | StringSQLXML                 |
| time                   | TIME (1)                              | java.sql.Time (1)            |
| date                   | DATE                                  | java.sql.Date                |
| datetime2              | TIMESTAMP                             | java.sql.Timestamp           |
| datetimeoffset (2)     | microsoft.sql.Types.DATETIMEOFFSET    | microsoft.sql.DateTimeOffset |

> [SQL Server字段类型对应java数据类型](https://www.cnblogs.com/coder-wzr/p/14217066.html)