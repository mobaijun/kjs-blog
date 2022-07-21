---
title: 【Mybatis系列】Mybatis入门（2）
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 1036371330
date: 2022-01-15 14:26:13
img:
coverImg:
password:
summary:
tags:
- Mybatis
categories:
- 后端
---

## SqlMapConfig.xml文件说明

配置文件内容以及配置顺序

~~~properties
properties:	属性
------property
settings：全局配置参数
------setting
typeAliases：类型别名
------typeAliase
------package
typeHandlers：类型处理器
objectFactory：对象工厂
plugins：插件
environments：环境集合属性对象
------environment：环境子属性对象
------transactionManager：事务管理
------dataSource：数据源
mappers：映射器
------mapper
------package
~~~

## properties(标签配置)

> 可以在标签内部配置连接数据库的信息。也可以通过属性引用外部配置文件信息。

* 在标签内部配置

~~~xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <properties>
        <property name="driver" value="com.mysql.cj.jdbc.Driver"></property>
         <property name="url" value="jdbc:mysql://127.0.0.1:3306/test?characterEncoding=utf-8"></property>
         <property name="username" value="root"></property>
         <property name="password" value="root"></property>
    </properties>
    <!--   配置环境-->
    <environments default="mysql">
        <!--配置mysql的环境-->
        <environment id="mysql">
            <!--配置事务的类型-->
            <transactionManager type="JDBC"></transactionManager>
            <!--配置连接池-->
            <dataSource type="POOLED">
                <!--配置连接数据库的4个基本信息-->
                <property name="driver" value="${driver}"/>
                <property name="url" value="${url}"/>
                <property name="username" value="${username}"/>
                <property name="password" value="${password}"/>
            </dataSource>
        </environment>
    </environments>
    <!--指定映射配置文件的位置，映射配置文件指的是每个dao独立的配置文件-->
    <mappers>
        <mapper resource="com/mobaijun/dao/mapper/UserDao.xml"/>
    </mappers>
</configuration>
~~~

通过属性引用配置文件的位置

> resource 属性：用于指定配置文件的位置，是按照类路径的写法来写，并且必须存在于类路径下。
>
> resource="jdbc.properties"
>
> [Mybatis 官网](https://mybatis.org/mybatis-3/zh/configuration.html)

~~~xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">

<configuration>
    <properties resource="jdbc.properties">
    </properties>
    <!--   配置环境-->
    <environments default="mysql">
        <!--配置mysql的环境-->
        <environment id="mysql">
            <!--配置事务的类型-->
            <transactionManager type="JDBC"></transactionManager>
            <!--配置连接池-->
            <dataSource type="POOLED">
                <!--配置连接数据库的4个基本信息-->
                <property name="driver" value="${jdbc.driver}"/>
                <property name="url" value="${jdbc.url}"/>
                <property name="username" value="${jdbc.username}"/>
                <property name="password" value="${jdbc.password}"/>
            </dataSource>
        </environment>
    </environments>

    <!--指定映射配置文件的位置，映射配置文件指的是每个dao独立的配置文件-->
    <mappers>
        <mapper resource="com/mobaijun/dao/mapper/UserDao.xml"/>
    </mappers>
</configuration>
~~~

## typeAliases(类型别名)

> 类型别名可为 Java 类型设置一个缩写名字。 它仅用于 XML 配置，意在降低冗余的全限定类名书写。例如：

举例：

```xml-dtd
<typeAliases>
  <typeAlias alias="Author" type="com.mobaijun.blog.Author"/>
  <typeAlias alias="Blog" type="com.mobaijun.blog.Blog"/>
  <typeAlias alias="Comment" type="com.mobaijun.blog.Comment"/>
  <typeAlias alias="Post" type="com.mobaijun.blog.Post"/>
  <typeAlias alias="Section" type="com.mobaijun.blog.Section"/>
  <typeAlias alias="Tag" type="com.mobaijun.blog.Tag"/>
</typeAliases>
```

当这样配置时，`Blog` 可以用在任何使用 `com.mobaijun.blog.Blog` 的地方。

也可以指定一个包名，MyBatis 会在包名下面搜索需要的 Java Bean，比如：

```xml-dtd
<typeAliases>
  <package name="com.mobaijun.blog"/>
</typeAliases>
```

每一个在包 `com.mobaijun.blog` 中的 Java Bean，在没有注解的情况下，会使用 Bean 的首字母小写的非限定类名来作为它的别名。 比如 `com.mobaijun.blog.Author` 的别名为 `author`；若有注解，则别名为其注解值。见下面的例子：

```java
@Alias("author")
public class Author {
    ...
}
```

下面是一些为常见的 Java 类型内建的类型别名。它们都是不区分大小写的，注意，为了应对原始类型的命名重复，采取了特殊的命名风格。

| 别名       | 映射的类型 |
| :--------- | :--------- |
| _byte      | byte       |
| _long      | long       |
| _short     | short      |
| _int       | int        |
| _integer   | int        |
| _double    | double     |
| _float     | float      |
| _boolean   | boolean    |
| string     | String     |
| byte       | Byte       |
| long       | Long       |
| short      | Short      |
| int        | Integer    |
| integer    | Integer    |
| double     | Double     |
| float      | Float      |
| boolean    | Boolean    |
| date       | Date       |
| decimal    | BigDecimal |
| bigdecimal | BigDecimal |
| object     | Object     |
| map        | Map        |
| hashmap    | HashMap    |
| list       | List       |
| arraylist  | ArrayList  |
| collection | Collection |
| iterator   | Iterator   |

## mappers(映射器)

既然 MyBatis 的行为已经由上述元素配置完了，我们现在就要来定义 SQL 映射语句了。 但首先，我们需要告诉 MyBatis 到哪里去找到这些语句。 在自动查找资源方面，Java 并没有提供一个很好的解决方案，所以最好的办法是直接告诉 MyBatis 到哪里去找映射文件。 你可以使用相对于类路径的资源引用，或完全限定资源定位符（包括 `file:///` 形式的 URL），或类名和包名等。例如：

```xml
<!-- 使用相对于类路径的资源引用 -->
<mappers>
  <mapper resource="com/mobaijun/builder/AuthorMapper.xml"/>
  <mapper resource="com/mobaijun/builder/BlogMapper.xml"/>
  <mapper resource="com/mobaijun/builder/PostMapper.xml"/>
</mappers>
```

~~~xml
<!-- 使用完全限定资源定位符（URL） -->
<mappers>
  <mapper url="file:///com/mobaijun/AuthorMapper.xml"/>
  <mapper url="file:///com/mobaijun/BlogMapper.xml"/>
  <mapper url="file:///com/mobaijun/PostMapper.xml"/>
</mappers>
~~~

~~~xml
<!-- 使用映射器接口实现类的完全限定类名 -->
<mappers>
  <mapper class="com/mobaijun.builder.AuthorMapper"/>
  <mapper class="com/mobaijun.builder.BlogMapper"/>
  <mapper class="com/mobaijun.builder.PostMapper"/>
</mappers>
~~~

~~~xml
<!-- 将包内的映射器接口实现全部注册为映射器 -->
<mappers>
  <package name="com.mobaijun.builder"/>
</mappers>
~~~

> 这些配置会告诉 MyBatis 去哪里找映射文件，剩下的细节就应该是每个 SQL 映射文件了，也就是接下来我们要讨论的。更多内容请翻阅官方文档[传送门](https://mybatis.org/mybatis-3/zh/configuration.html)

## 输入映射papameterType

### 传递简单类型

> 基本类型和String我们可以直接写类型名称，也可以使用包名.类名的方式。例如：java.lang.String

### 传递pojo对象

Mybatis使用ognl表达式解析对象字段的值、#{}或${}括号中的值为pojo属性名称。

OGNL表达式：Object Graphic Navigation Language。对象 图 导航 语言

它是通过对象的取值方法来获取数据，比如user.username。在写法上把get给省略了。

比如：我们获取用户的名称

类中的写法：user.getUsername();

OGNL表达式写法：user.username;

mybatis中为什么能直接写username，而不用user呢。因为在parameterType中已经提供了属性所属的类，所以此时不需要写对象名。

### 传递pojo包装对象

开发中通过 pojo 传递查询条件 ，查询条件是综合的查询条件，不仅包括用户查询条件还包括其它的查询条件（比如将用户购买商品信息也作为查询条件），这时可以使用包装对象传递输入参数。Pojo 类中包含 pojo。
需求：根据用户名查询用户信息，查询条件放到 QueryVo 的 user 属性中。

在com.ben.domain里编写QueryVo类

```java
Copy/**
 * @ClassName: QueryVo
 * @author: benjamin
 * @version: 1.0
 * @description: 查询条件对象
 * @createTime: 2019/07/15/17:35
 */

public class QueryVo implements Serializable {
    
    private User user;

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
```

编写持久层接口

```java
Copypublic interface IUserDao {
    // 根据 QueryVo 中的条件查询用户
    List<User> findByVo(QueryVo vo);
}
```

配置映射文件

```xml
Copy<!-- 根据用户名称模糊查询，参数变成一个 QueryVo 对象了 -->
<select id="findByVo" resultType="com.ben.domain.User"
        parameterType="com.ben.domain.QueryVo">
        select * from user where username like #{user.username};
</select>
```

测试包装类作为参数

```java
Copy @Test
    public void testQueryVo(){
        QueryVo vo = new QueryVo();
        User user = new User();
        user.setUsername("%五%");
        vo.setUser(user);
        List<User> users = userdao.findByVo(vo);
        for(User u : users) {
            System.out.println(u);
        }
    }
```

## 输出映射resultType

### 输出简单类型

映射配置文件

```xml
Copy<!-- 查询总记录条数 -->
<select id="findTotal" resultType="int">
select count(*) from user;
</select>
```

接口实现类

```java
Copy// 查询总记录数
int queryUserCount();
```

测试方法

```java
Copy//查询用户总数
@Test
public void testQueryUserCount(){
    int count = userdao.queryUserCount();
    System.out.println(count);
}
```

### 输出pojo类型

resultType输出可以是一个对象。

### 输出pojo列表

resultType输出也可以是一个列表。

### 使用resultMap

背景：resultType可以指定将查询结果映射为pojo，但需要pojo的属性名和sql查询的列名一致方可映射成功。

问题：如果pojo的属性名和SQL中的列名不一致怎么办？

解决方法：如果sql查询字段名和pojo的属性名不一致，可以通过resultMap将字段名和属性名作一个对应关系 ，

resultMap实质上还需要将查询结果映射到pojo对象中。

我们以添加用户为例，

配置好映射配置文件

```xml
Copy<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.ben.dao.IUserDao">

    <select id="findAll"  resultType="com.ben.domain.User">
        select username,birthday,address,sex from user
    </select>
</mapper>
```

编写持久层接口

```java
Copypublic interface IUserDao {
    // 查询所有用户
    List<User> findAll();
}
```

编写测试文件

```java
Copy//添加用户
@Test
public void testFindAll() throws IOException {
    List<User> list = userdao.findAll();
    for (User user : list) {
        System.out.println(user);
    }
}
```

结果：

[![img](https://img2018.cnblogs.com/blog/1415026/201907/1415026-20190717224258788-1403260411.png)](https://img2018.cnblogs.com/blog/1415026/201907/1415026-20190717224258788-1403260411.png)

因为除了userName属性，其他所有属性都没对应上数据库的列名。mysql数据库在为windows下不区别大小写，因此userName是能对应到数据库中username列。在linux下严格区分大小写。

[![img](https://img2018.cnblogs.com/blog/1415026/201907/1415026-20190717224317815-200897896.png)](https://img2018.cnblogs.com/blog/1415026/201907/1415026-20190717224317815-200897896.png)

解决方法1：

编写sql语句，效率高；

```xml
Copy<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.ben.dao.IUserDao">
    <select id="findAll"  resultType="com.ben.domain.User">
            select id as userId,username as userName,birthday as userBirthday,address as userAddress,sex as userSex from user
    </select>
</mapper>
```

完美：

[![img](https://img2018.cnblogs.com/blog/1415026/201907/1415026-20190717224336912-99868070.png)](https://img2018.cnblogs.com/blog/1415026/201907/1415026-20190717224336912-99868070.png)

使用resultMap，配置查询结果的列名和实体类的属性名的对应关系。修改xml配置文件。

```xml
Copy<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.ben.dao.IUserDao">
    <!-- 配置 查询结果的列名和实体类的属性名的对应关系 -->
    <resultMap id="userMap" type="com.ben.domain.User">
        <!-- 主键字段的对应 -->
        <id property="userId" column="id"></id>
        <!--非主键字段的对应-->
        <result property="userName" column="username"></result>
        <result property="userAddress" column="address"></result>
        <result property="userSex" column="sex"></result>
        <result property="userBirthday" column="birthday"></result>
    </resultMap>
    <!-- 查询所有 -->
    <select id="findAll" resultMap="userMap">
        select * from user;
    </select>
</mapper>
```
