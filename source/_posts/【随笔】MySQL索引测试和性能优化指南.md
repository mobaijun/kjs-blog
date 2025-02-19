---
title: 【随笔】MySQL索引测试和性能优化指南
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 2529608396
date: 2025-02-19 13:40:09
img:
coverImg:
password:
summary:
tags:
- 索引
categories:
- 数据库
---

## 1.前言

在数据库查询优化的过程中，索引扮演着至关重要的角色。合理使用索引不仅能大幅提升查询效率，还能降低数据库的负载。然而，不同类型的索引在不同场景下的表现可能存在较大差异，因此深入理解各类索引的特性以及 `EXPLAIN` 关键字的查询分析能力尤为重要。

本篇文章将通过对比不同索引类型的性能、使用 `EXPLAIN` 分析 SQL 查询计划，并提供实际测试案例，帮助大家全面理解索引的应用和优化策略。

## 2.准备环境

|      名称      |                版本                 |
| :------------: | :---------------------------------: |
|     MySQL      |               8.0.41                |
|    Windows     | Windows 10 专业版，22H2，19045.5487 |
|      SSD       |                 1TB                 |
|     memory     |              64GB/3200              |
|      cpu       |              R7 4800H               |
| 测试单表数据量 |                100W                 |

1. 测试数据生成

~~~sql
-- 创建测试数据库
CREATE DATABASE test_db2;
USE test_db2;

-- 创建 users 表
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 生成 100 万条测试数据
-- 启用事务加速插入
START TRANSACTION;

DELIMITER ;;
CREATE PROCEDURE generate_test_data()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE batch_size INT DEFAULT 1000;
    
    WHILE i <= 1000000 DO
        INSERT INTO users (name, age, email)
        VALUES (
            CONCAT('User', i),
            FLOOR(20 + (RAND() * 30)),
            CONCAT('user', i, '@example.com')
        );
        
        -- 每1000条提交一次事务
        IF i % batch_size = 0 THEN
            COMMIT;
            START TRANSACTION;
        END IF;
        
        SET i = i + 1;
    END WHILE;
    
    COMMIT;
END;;
DELIMITER ;

-- 执行存储过程
CALL generate_test_data();
~~~

2. 结果

![image-20250219152545286](https://tencent.cos.mobaijun.com/xxbj_img/image-20250219152545286.png?imageSlim)

## 3. 索引的基本概念

### 3.1 什么是索引？

索引是一种特殊的数据结构（如 B-Tree 或 Hash），用于加速数据库查询。索引的本质是额外的存储结构，它维护着一张有序的键值映射表，使得查询可以高效地通过索引访问目标数据，而无需进行全表扫描。

### 3.2 索引的优点

- **加速查询**：索引能减少查询时扫描的数据量，大幅提高 SELECT 语句的执行速度。
- **提高排序效率**：当 ORDER BY 语句使用索引时，MySQL 可以利用索引中的顺序直接返回排序结果。
- **提升分组性能**：GROUP BY 语句在索引字段上执行时会更加高效。

### 3.3 索引的缺点

- **占用额外存储空间**：索引会占用额外的磁盘空间，尤其是复杂的索引结构。
- **影响写入性能**：INSERT、UPDATE 和 DELETE 语句在修改数据时需要同步更新索引，可能会降低写入速度。
- **索引维护成本**：维护过多的索引会影响数据库的整体性能，需要合理选择索引策略。

## 4. 常见索引类型的详细介绍

MySQL 提供了多种索引类型，以适应不同的查询需求。如下：

> 1. 普通索引
> 2. 唯一索引
> 3. 主键索引
> 4. 组合索引
> 5. 全文索引

### 4.1. 创建语句

~~~sql
CREATE TABLE table_name[col_name data type][unique|fulltext][index|key][index_name](col_name[length])[asc|desc]
~~~

1. `unique` 或 `fulltext`：分别表示唯一索引或全文索引。
2. `index` 和 `key`：这两个关键词作用相同，都用于指定创建索引。
3. `col_name`：指定要创建索引的列。
4. `index_name`：指定索引名称，默认为 `col_name`。
5. `length`：仅对字符串字段有效，表示索引长度。
6. `asc` 或 `desc`：指定索引的升序或降序排列。

### 4.2 普通索引

#### **特点**：
- 可以创建多个普通索引。
- 支持等值查询。
- 不唯一。

#### **缺点**：
- 普通索引不保证唯一性，可能会导致重复数据。
- 对于高频繁插入、更新或删除的表，普通索引会降低性能，因为每次数据变动都需要更新索引。

#### **创建示例**：

```sql
CREATE INDEX idx_users_name ON users(name);
```

### 4.3 唯一索引

#### **特点**：

- 用于确保数据的唯一性。
- 不允许重复值。
- 支持 `NULL` 值。

#### **缺点**：

- 如果数据表中存在重复数据，创建唯一索引时会失败。
- 在插入、更新数据时，系统需要额外的时间检查唯一性，可能导致性能下降。

#### **创建示例**：

```sql
CREATE UNIQUE INDEX idx_users_email ON users(email);
```

### 4.4 主键索引

#### **特点**：

- 每个表只能有一个主键索引。
- 主键索引的列不能有 `NULL` 值。
- 自动创建唯一索引。

#### **缺点**：

- 主键的创建要求数据列不为空且唯一，因此会影响表设计。
- 每次插入数据时，都需要确保主键的唯一性，这可能会降低写入性能。

#### **创建示例**：

```sql
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);
```

### 4.5 组合索引

#### **特点**：

- 多列组合索引。
- 用于多列同时参与查询的情况。
- 查询时最好遵循“最左前缀原则”。

#### **缺点**：

- 如果查询条件的字段顺序没有遵循“最左前缀原则”，组合索引可能不会被使用。
- 组合索引过长时，可能会影响索引的效率和占用存储空间。

#### **创建示例**：

```sql
CREATE INDEX idx_users_name_age ON users(name, age);
```

### 4.6 全文索引

#### **特点**：

- 适用于 MyISAM 和 InnoDB 存储引擎（MySQL 5.6+ 支持 InnoDB 的全文索引）。
- 支持文本数据的复杂查询。
- 使用 `MATCH() ... AGAINST()` 进行搜索。

#### **缺点**：

- 对于非文本字段，全文索引无法使用。
- 索引建立和更新时需要消耗更多的资源。
- 对于小数据量的表，全文索引可能带来不必要的性能开销。

#### **创建示例**：

```sql
CREATE FULLTEXT INDEX idx_users_description ON users(description);
```

## 5. 索引优化建议

### 5.1 优化索引设计

- **选择高选择性字段**：选择唯一性较高的字段来创建索引。
- **避免过多索引**：每个索引都会影响数据的写入性能，应避免过多不必要的索引。
- **考虑覆盖索引**：对于常用查询，可以创建覆盖索引，提高查询效率。

### 5.2 使用组合索引

在多个字段共同参与查询时，可以使用组合索引来提高性能，尤其是在 `WHERE` 子句中多个字段联合查询时。

#### **示例**：

```sql
CREATE INDEX idx_users_name_age ON users(name, age);
```

### 5.3 定期维护索引

数据库使用过程中，索引可能会发生碎片化，因此需要定期进行优化。

#### **优化表**：

```sql
OPTIMIZE TABLE users;
```

## 6. 什么情况下会走索引，什么情况下索引会失效

### 6.1 索引生效的情况

1. **等值查询**：索引对等值查询（`=`）有效。

~~~sql
SELECT * FROM users WHERE name = 'John';
~~~

2. **范围查询**：索引对范围查询（`>`, `<`, `BETWEEN`, `LIKE 'abc%'`）有效。

~~~sql
SELECT * FROM users WHERE age BETWEEN 20 AND 30;
~~~

3. **ORDER BY 和 GROUP BY**：索引可以加速排序和分组操作。

~~~sql
SELECT * FROM users ORDER BY name;
~~~

4. **联合查询（JOIN）**：在 `JOIN` 操作中，索引有助于加速连接操作。

~~~sql
SELECT * FROM users u JOIN orders o ON u.id = o.user_id;
~~~

5. **使用复合索引**：对于多个列的联合查询，复合索引可以显著提升查询效率，尤其是多个字段联合在 `WHERE` 子句中的情况。

~~~sql
SELECT * FROM users WHERE name = 'John' AND age > 20;
~~~

### 6.2 索引失效的情况

1. **`OR` 操作符**：当 `WHERE` 子句中包含 `OR` 时，索引可能失效，尤其是当 `OR` 左右两边的条件索引不同或包含非索引列时。

~~~sql
SELECT * FROM users WHERE age = 25 OR name = 'John';
~~~

2. **`LIKE` 使用通配符开头**：当 `LIKE` 查询使用通配符（如 `%abc`）开头时，索引失效。

~~~sql
SELECT * FROM users WHERE name LIKE '%John';
~~~

3. **`IS NULL` 和 `IS NOT NULL`**：如果查询中使用 `IS NULL` 或 `IS NOT NULL`，且列没有索引，索引会失效。

~~~sql
SELECT * FROM users WHERE name IS NULL;
~~~

4. **函数操作**：在 `WHERE` 子句中对列进行函数操作时，索引会失效。

```sql
SELECT * FROM users WHERE YEAR(birth_date) = 1990;
```

5. **数据类型不匹配**：当查询条件中的数据类型与列的数据类型不匹配时，索引会失效。

```sql
SELECT * FROM users WHERE age = '30';  -- 假设 age 是整数类型
```

## 7. 使用 EXPLAIN 分析索引

在 MySQL 中，`EXPLAIN` 是一个非常有用的关键字，用于分析 SQL 查询的执行计划。通过查看查询执行计划，开发人员可以了解 MySQL 如何执行某个 SQL 查询，进而帮助优化查询效率。无论是复杂的查询还是简单的 SELECT 语句，使用 `EXPLAIN` 都能帮助你分析执行情况并找出性能瓶颈。

### 7.1 什么是执行计划？

执行计划是数据库在执行 SQL 查询时，选择的最优路径。它包括了数据库访问的表、扫描的行数、使用的索引等信息。了解执行计划能帮助我们优化查询性能。

### 7.2 `EXPLAIN` 的基本使用

在 MySQL 中，`EXPLAIN` 用来查看某个 SELECT、DELETE、INSERT、UPDATE 或 REPLACE 语句的执行计划。最常见的使用方式是：

~~~sql
EXPLAIN SELECT * FROM users WHERE name = 'Sales';
~~~

这个语句将展示 MySQL 在执行 `SELECT` 查询时的执行计划，包括以下几个重要的信息。

### 7.3 `EXPLAIN` 输出的字段

执行 `EXPLAIN` 后，会返回一张包含若干字段的表。以下是常见的字段及其含义：

1. **id**：查询的标识符。对于联合查询中的每个子查询都会有不同的 id。越大的 id，表示该查询的优先级越高。

2. select_type

   ：查询类型。常见的值包括：

   - `SIMPLE`：简单的查询，不涉及 UNION 或子查询。
   - `PRIMARY`：最外层查询。
   - `UNION`：UNION 查询中的第二个或后续查询。
   - `SUBQUERY`：子查询。

3. **table**：显示该行记录对应的表名。

4. type

   ：连接类型，是查询效率的重要标志。常见的类型有：

   - `ALL`：全表扫描，效率最低。
   - `index`：索引扫描，扫描索引而非数据表。
   - `range`：范围扫描，查找索引中的某个范围。
   - `ref`：使用非唯一索引。
   - `eq_ref`：对每个查询行都进行唯一索引查找，通常出现在连接操作中。
   - `const`：常数查找，最优。

5. **possible_keys**：查询中可能使用的索引。

6. **key**：实际使用的索引。如果没有使用索引，这一列会显示为 NULL。

7. **key_len**：使用索引时，索引的长度。

8. **ref**：与索引匹配的列或常数。

9. **rows**：MySQL 预计要扫描的行数。这个数字越小，说明查询效率越高。

10. **Extra**：额外信息，通常提供查询优化的提示。例如，如果看到 `Using where`，意味着 MySQL 通过 WHERE 子句进行了过滤。

### 7.4 `EXPLAIN` 输出示例

假设我们有一个简单的查询：

~~~cmd
mysql> EXPLAIN SELECT * FROM users WHERE age = 51;
+----+-------------+-------+------------+------+---------------+---------------+---------+-------+------+----------+-------+
| id | select_type | table | partitions | type | possible_keys | key           | key_len | ref   | rows | filtered | Extra |
+----+-------------+-------+------------+------+---------------+---------------+---------+-------+------+----------+-------+
|  1 | SIMPLE      | users | NULL       | ref  | idx_users_age | idx_users_age | 4       | const |    1 |   100.00 | NULL  |
+----+-------------+-------+------------+------+---------------+---------------+---------+-------+------+----------+-------+
1 row in set (0.03 sec)
~~~

#### 7.4.1 各列解释：

> 1. **id**：查询的标识符。对于联合查询或子查询，这个值会有所不同，表示该查询的优先级。在简单查询中，它通常是 `1`。
> 2. **select_type**：查询类型。这里显示的是 `SIMPLE`，表示这是一个简单的查询，没有涉及到联合查询或子查询。
> 3. **table**：查询涉及的表名。在这个例子中，查询的表是 `users`。
> 4. **partitions**：涉及的分区（如果使用分区表）。这里是 `NULL`，表示没有使用分区。
> 5. **type**：连接类型，这个值告诉你 MySQL 如何访问表数据。这里的 `ref` 表示使用了索引来查找数据，并且是通过非唯一索引进行的查询。`ref` 类型的效率相对较高，但比 `eq_ref` 类型稍慢。其他常见类型包括 `ALL`（全表扫描）和 `range`（范围扫描）。
> 6. **possible_keys**：查询中可能使用的索引。这里显示 `idx_users_age`，表示可能会用到 `idx_users_age` 索引。
> 7. **key**：实际使用的索引。如果没有使用索引，则此列为 `NULL`。这里使用的是 `idx_users_age` 索引。
> 8. **key_len**：索引的长度，即 MySQL 在查询中使用索引时，索引的字节长度。这里是 `4`，表示 `idx_users_age` 索引的长度为 4 字节。
> 9. **ref**：显示与索引匹配的列或常数。这里是 `const`，表示 `age = 51` 是一个常量值，用来与 `idx_users_age` 索引匹配。
> 10. **rows**：MySQL 预计需要扫描的行数。这里是 `1`，表示 MySQL 预计只需要扫描一行数据来匹配查询条件。
> 11. **filtered**：表示查询条件的过滤比例，`100.00` 表示没有过滤掉任何行，所有扫描的行都会被选中。
> 12. **Extra**：额外的信息，通常提供查询优化的提示。这里是 `NULL`，表示没有额外的优化信息。

### 7.5 如何通过 `EXPLAIN` 优化查询

1. **避免全表扫描**：如果 `type` 字段显示为 `ALL`，说明查询进行了全表扫描，这通常是性能瓶颈的标志。此时可以考虑为查询字段添加索引，减少扫描的数据量。
2. **检查索引使用情况**：检查 `possible_keys` 和 `key` 字段，确保查询使用了合适的索引。如果查询没有使用任何索引，可以考虑为查询字段添加索引。
3. **查看行数预估**：`rows` 字段显示了 MySQL 预计扫描的行数。较大的行数通常意味着查询效率较低，需要通过优化索引或修改查询来减少扫描的行数。
4. **关注 Extra 字段**：`Extra` 字段中的提示信息（如 `Using where`、`Using index`、`Using temporary` 等）可以帮助你了解查询中的潜在性能问题。尤其是 `Using temporary` 或 `Using filesort`，这通常表示查询可能存在排序或临时表的性能瓶颈。

### 7.6 高级用法：`EXPLAIN ANALYZE`

从 MySQL 8.0.18 版本开始，`EXPLAIN` 支持 `ANALYZE` 关键字，它不仅展示查询的执行计划，还会执行查询并给出实际执行时间。这可以帮助你更加准确地评估查询性能。

~~~cmd

mysql> EXPLAIN ANALYZE SELECT * FROM users WHERE age = 51;
+-----------------------------------------------------------------------------------------------------------------------+
| EXPLAIN                                                                                                               |
+-----------------------------------------------------------------------------------------------------------------------+
| -> Index lookup on users using idx_users_age (age=51)  (cost=0.35 rows=1) (actual time=0.0296..0.0296 rows=0 loops=1)
 |
+-----------------------------------------------------------------------------------------------------------------------+
1 row in set (0.03 sec)
~~~

## 总结

`EXPLAIN` 是一个强大的工具，可以帮助开发人员了解 SQL 查询的执行计划，从而发现性能瓶颈。通过合理使用索引、优化查询语句和调整数据库结构，能够有效提高数据库的查询效率。在日常开发和性能调优过程中，使用 `EXPLAIN` 是必不可少的步骤，掌握它能让你在优化数据库查询时事半功倍。