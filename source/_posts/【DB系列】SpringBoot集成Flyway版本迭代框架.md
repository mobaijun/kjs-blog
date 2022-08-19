---
title: 【DB系列】SpringBoot集成Flyway版本迭代框架
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 3026103144
tags:
  - Flyway
categories:
  - SpringBoot
date: 2021-11-15 10:41:17
img:
coverImg:
password:
summary:
---

## 前言

最近项目中引入了 `Flyway` 这个管理数据库版本框架，目的是为了解决我们一直存在的数据库脚本迭代混乱这个问题😂。说来惭愧，公司一直都是手动迭代数据库版本，配置`MybatisPlus`的`init-sql`组件使用的。

一直以来感觉没什么问题，但测试人员每次部署项目测试，都需要开发人员向测试发送数据库`sql`文件，这样就造成有时候脚本文件混乱，导致一些不必要的麻烦，所以就想要使用一款可以记录`SQL`文件版本迭代的工具，刚好`Flyway`可以解决这个问题。

今天我们就来介绍在`Spring Boot`中使用`Flyway`来管理数据库版本的方法。

## Flyway简介

`Flyway`是一个简单开源数据库版本控制器（约定大于配置），主要提供`migrate、clean、info、validate、baseline、repair`等命令。它支持`SQL（PL/SQL、T-SQL）`方式和`Java`方式，支持命令行客户端等，还提供一系列的插件支持`（Maven、Gradle、SBT、ANT等`）。

* 官方网站：[https://flywaydb.org/](https://flywaydb.org/)

## 实现

下面我们先预设一个开发目标：

1. 假设我们需要开发一个用户管理系统，那么我们势必要设计一张用户表，并实现对用户表的增删改查操作。
2. 在任务1的功能完成之后，我们又有一个新需求，需要对用户表增加了一个字段，看看如何实现对数据库表结构的更改。

## 目标 1 的实现

### 第一步：

> 创建一个基础的`Spring Boot`项目，并在`pom.xml`中加入`Flyway、MySQL`连接和数据访问相关的必要依赖（这里选用`spring-boot-starter-jdbc`作为例子）

~~~xml
<!-- Java版本 -->
<properties>
    <java.version>1.8</java.version>
</properties>

<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <!-- flyway-core依赖 V:7.7.3 -->
    <dependency>
        <groupId>org.flywaydb</groupId>
        <artifactId>flyway-core</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-jdbc</artifactId>
    </dependency>
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <scope>runtime</scope>
    </dependency>
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <optional>true</optional>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>
~~~

* `yaml `配置文件内容

~~~yaml
spring:
  # flyway配置
  flyway:
    # 开启 flyway
    enabled: true
    # 是否禁用数据库清理
    clean-disabled: true
    # SQL 迁移的编码
    encoding: UTF-8
    # 迁移脚本的位置，默认db/migration.
    locations: classpath:db/migration
    # SQL 迁移的文件名前缀。
    sql-migration-prefix: V
    # SQL 迁移的文件名分隔符。
    sql-migration-separator: __
    # SQL 迁移的文件名后缀。
    sql-migration-suffixes: .sql
    # 是否在执行迁移时自动调用验证。
    validate-on-migrate: true
    # 迁移时发现目标schema非空，而且带有没有元数据的表时，是否自动执行基准迁移，默认false.
    baseline-on-migrate: true
    # JDBC 驱动程序的完全限定名称。 默认根据 URL 自动检测。
    driver-class-name:
    # 要迁移的数据库的 DBC url。 如果未设置，则使用主要配置的数据源。
    url: jdbc:mysql://localhost:3306/flyway?useUnicode=true&characterEncoding=utf8&serverTimezone=GMT
    # 要迁移的数据库的登录密码。
    password: root
    # 要迁移的数据库的登录用户。
    user: root

  # MySQL配置
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/flyway
    username: root
    password: root
~~~

### 第二步：

> 按`Flyway`的规范创建版本化的`SQL`脚本。

- 在工程的`src/main/resources`目录下创建`db`目录，在`db`目录下再创建`migration`目录
- 在`migration`目录下创建版本化的SQL脚本`V1__user_version.sql`

~~~sql
DROP TABLE IF EXISTS user ;
CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(20) NOT NULL COMMENT '姓名',
  `age` int(5) DEFAULT NULL COMMENT '年龄',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
~~~

### 第三步：

> 根据`User`表的结构，编写对应的实体定义

~~~java
@Data
@NoArgsConstructor
public class User {
    private Long id;
    private String name;
    private Integer age;
}
~~~

### 第四步：

> 编写用户操作接口和实现

~~~java
package com.mobaijun;

import java.sql.SQLException;
import java.util.List;

/**
 * Software：IntelliJ IDEA 2021.2 x64
 * Author: https://www.mobaijun.com
 * Date: 2021/11/15 13:43
 * InterfaceName:UserService
 * 接口描述： 用户接口
 */
public interface UserService {
    
    /**
     * 新增一个用户
     */
    int create(String name, Integer age);

    /**
     * 根据name查询用户
     */
    List<User> getByName(String name);

    /**
     * 根据name删除用户
     */
    int deleteByName(String name);

    /**
     * 获取用户总量
     */
    Integer getAllUsers() throws SQLException;

    /**
     * 删除所有用户
     */
    int deleteAllUsers();
}
~~~

### 第五步：

> 实现类编写

~~~java
package com.mobaijun;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.util.List;

/**
 * Software：IntelliJ IDEA 2021.2 x64
 * Author: https://www.mobaijun.com
 * Date: 2021/11/15 13:47
 * ClassName:UserServiceImpl
 * 类描述： 用户实现类
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    UserServiceImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public int create(String name, Integer age) {
        return jdbcTemplate.update("insert into user(name, age) values(?, ?)", name, age);
        ;
    }

    @Override
    public List<User> getByName(String name) {
        List<User> users = jdbcTemplate.query("select * from user where name = ?", (resultSet, i) -> {
            User user = new User();
            user.setId(resultSet.getLong("ID"));
            user.setName(resultSet.getString("NAME"));
            user.setAge(resultSet.getInt("AGE"));
            return user;
        }, name);
        return users;
    }

    @Override
    public int deleteByName(String name) {
        return jdbcTemplate.update("delete from user where name = ?", name);
    }

    @Override
    public Integer getAllUsers() throws SQLException {
        return jdbcTemplate.queryForObject("select count(1) from user", Integer.class);
    }

    @Override
    public int deleteAllUsers() {
        return jdbcTemplate.update("delete from user");
    }
}
~~~

### 第六步：

> 编写测试用例

~~~java
package com.mobaijun;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

@SpringBootTest
class SpringBootFlywayApplicationTests {
    
    @Autowired
    private UserService userService;

    @Test
    void contextLoads() {
        userService.deleteAllUsers();
        // 添加5个用户
        userService.create("墨白", 18);
        userService.create("李白", 100);
        userService.create("张三", 100);
        userService.create("王五", 100);
        userService.create("李四", 100);

        // 查询墨白年龄是否匹配
        List<User> userList = userService.getByName("墨白");
        Assertions.assertEquals(18, userList.get(0).getAge().intValue());

        // 查询所有用户
        Assertions.assertEquals(5, userService.getAllUsers());
        // 删除两个用户
        userService.deleteByName("王五");
        userService.deleteByName("李四");
    }
}
~~~

### 第七步：

> 运行上面编写的单元测试，验证一下效果。
>
> 不出意外，单元测试运行ok的话
>
> 连上数据库看看。此时应该多出了这两张表：

![](https://tencent.cos.mobaijun.com/article_with_pictures/image-20211115140057721.png)

- `user`表就是我们维护在`SQL`脚本中要创建的表
- `flyway_schema_history`表是`flyway`的管理表，用来记录在这个数据库上跑过的脚本，以及每个脚本的检查依据。这样每次应用启动的时候，就可以知道哪个脚本需要运行，或者哪个脚本发生了变动，运行基础可能不对，造成数据结构的混乱而阻止运行。

## 目标 2 的实现

有了上面的基础之后，我们来说说后续要做表结构的表变动该怎么操作。

---

首先，大家在开始使用`Flyway`之后，对于数据库表接口的变更就要关闭这几个途径：

1. 直接通过工具登录数据去修改表结构
2. 已经发布的sql脚本不允许修改

---

正确的表结构调整途径：在`flyway`脚本配置路径下编写新的脚本，启动程序来执行变更。这样可以获得几个很大的好处：

1. 脚本受Git版本管理控制，可以方便的找到过去的历史
2. 脚本在程序启动的时候先加载，再提供接口服务，一起完成部署步骤
3. 所有表结构的历史变迁，在管理目录中根据版本号就能很好的追溯



---

下面根据一个实际需求来具体操作下。假设我们现在想对`user`表增加一个字段：`address`，用来存储用户的通讯地址，那么我们就需要这样操作实现。

第一步：创建脚本文件`V1_1__alter_table_user.sql`，并写入增加`address`列的语句

~~~sql
ALTER TABLE `user` ADD COLUMN `address` VARCHAR(20) DEFAULT NULL;
~~~



> 对于脚本文件名的基本规则是：`版本号__描述.sql`。当然如果你有更细致的要求，那么可以做更细致的文件名规划，具体细节可以查阅文末参考资料中的官方文档获取。

第二步：再次执行单元测试，在控制台中可以看到如下日志：

```less
2021-11-15 14:03:58.193  INFO 16840 --- [           main] c.m.SpringBootFlywayApplicationTests     : Starting SpringBootFlywayApplicationTests using Java 1.8.0_281 on mobai with PID 16840 (started by mobai in D:\IdeaProject\spring-boot-wikis\spring-boot-flyway)
2021-11-15 14:03:58.201  INFO 16840 --- [           main] c.m.SpringBootFlywayApplicationTests     : No active profile set, falling back to default profiles: default
2021-11-15 14:03:59.270  INFO 16840 --- [           main] o.f.c.internal.license.VersionPrinter    : Flyway Community Edition 7.7.3 by Redgate
2021-11-15 14:04:00.337  INFO 16840 --- [           main] o.f.c.i.database.base.DatabaseType       : Database: jdbc:mysql://localhost:3306/flyway (MySQL 8.0)
2021-11-15 14:04:00.382  INFO 16840 --- [           main] o.f.core.internal.command.DbValidate     : Successfully validated 2 migrations (execution time 00:00.021s)
2021-11-15 14:04:00.393  INFO 16840 --- [           main] o.f.core.internal.command.DbMigrate      : Current version of schema `flyway`: 1
2021-11-15 14:04:00.403  INFO 16840 --- [           main] o.f.core.internal.command.DbMigrate      : Migrating schema `flyway` to version "1.1 - alter table user"
2021-11-15 14:04:00.427  INFO 16840 --- [           main] o.f.c.i.s.DefaultSqlScriptExecutor       : 0 rows affected
2021-11-15 14:04:00.445  INFO 16840 --- [           main] o.f.core.internal.command.DbMigrate      : Successfully applied 1 migration to schema `flyway`, now at version v1.1 (execution time 00:00.058s)
2021-11-15 14:04:01.241  INFO 16840 --- [           main] c.m.SpringBootFlywayApplicationTests     : Started SpringBootFlywayApplicationTests in 3.435 seconds (JVM running for 4.441)
2021-11-15 14:04:01.409  INFO 16840 --- [           main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Starting...
2021-11-15 14:04:01.448  INFO 16840 --- [           main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Start completed.
```

* 再查看一下数据库中的内容：

![](https://tencent.cos.mobaijun.com/article_with_pictures/image-20211115141020685.png)

`user`表中已经有了`Address`列

![](https://tencent.cos.mobaijun.com/article_with_pictures/image-20211115141051238.png)

`Flyway`管理表中已经有新脚本的加载记录



> <font color="#dc143c">源码地址：[传送门](https://gitee.com/mobaijun/spring-boot-wikis/tree/devople/spring-boot-flyway)</font>
>
> 欢迎留言分享下你们的数据库版本管理方式😁😁😁！

## 参考

[Documentation - Flyway by Redgate • Database Migrations Made Easy.](https://flywaydb.org/documentation/)

[Spring Boot 2.x基础教程：使用Flyway管理数据库版本 | 程序猿DD](https://blog.didispace.com/spring-boot-learning-24-3-11/)

