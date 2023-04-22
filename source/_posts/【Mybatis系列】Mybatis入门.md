---
title: 【Mybatis系列】Mybatis入门
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 2794875020
tags:
  - Mybatis
categories:
  - 后端
date: 2022-01-07 15:10:24
img:
coverImg:
password:
summary:
---

## 简介

![](https://tencent.cos.mobaijun.com/img/blog/【Mybatis系列】Mybatis入门/0.png)

* 什么是 Mybatis ？

MyBatis 是一款优秀的持久层框架，它支持自定义 SQL、存储过程以及高级映射。MyBatis 免除了几乎所有的 JDBC 代码以及设置参数和获取结果集的工作。MyBatis 可以通过简单的 XML 或注解来配置和映射原始类型、接口和 Java POJO（Plain Old Java Objects，普通老式 Java 对象）为数据库中的记录。

* Mybatis 历史

Mybatis 是 Apache 软件基金会下的一个开源项目， 前身是 ibatis 框架。 2010 年这个项目由 apache 软件基金会迁移到 google code 下， 改名为 Mybatis。 2013 年 11 月又迁移到了 [github](https://github.com/mybatis/mybatis-3/releases)。

* 通俗说 Mybatis 到底可以做什么？

平时我们都用 JDBC 访问数据库，除了需要自己写 SQL 之外，还必须操作 Connection, Statement, ResultSet，这些其实只是手段的辅助类。 不仅如此，访问不同的表，还会写很多相同的代码，显得繁琐和枯燥。



那么用了 Mybatis 之后，只需要自己提供 SQL 语句，其他的工作，诸如建立连接 Statement， JDBC相关异常处理等等都交给 Mybatis 去做了，那些重复性的工作 Mybatis 也给做掉了，开发者只需要关注在增删改查等操作层面上，而 Mybatis 把技术细节都封装在了我们看不见的地方。

----

## 框架原理

![](https://tencent.cos.mobaijun.com/img/blog/【Mybatis系列】Mybatis入门/1.png)

### 图说：

1、Mybatis 配置文件 SqlMapConfig.xml ：此文件作为 mybatis 的全局配置文件，定义了 mybatis 运行的基础环境信息，如数据库链接信息等。mapper.xml 文件，这些文件是 sql 映射文件，文件配置了操作数据库的 sql 语句，此文件需要在 SqlMapConfig.xml 中配置加载。

2、通过 mybatis 环境等配置信息构造 SqlSessionFactory，即会话工厂。

3、由会话工厂创建 sqlSession 即会话，操作数据库需要通过 sqlSession 进行。

4、mybatis 底层自定义了 Executor 执行器接口操作数据库，Executor 接口有两个实现，一个是基本执行器、一个是缓存执行器。

5、Mapped Statement 也是 mybatis 一个底层封装对象，它包装了 mybatis 配置信息及 sql 映射信息等。mapper.xml 文件中一个sql对应一个 Mapped Statement 对象，sql 的 id 即是 Mapped statemen t的 id。

6、Mapped Statement 对 sql 执行输入参数进行定义，包括 HashMap、基本类型、pojo，Executor 通过Mapped Statement 在执行 sql 前将输入的 java 对象映射至 sql 中，输入参数映射就是 jdbc 编程中对preparedStatement 设置参数。

7、Mapped Statement 对 sql 执行输出结果进行定义，包括 HashMap、基本类型、pojo，Executor通过 Mapped Statement 在执行 sql 后将输出结果映射至 java 对象中，输出结果映射过程相当于 jdbc 编程中对结果的解析处理过程。

## 搭建入门案例

环境说明：

1. JDK：1.8
2. mybatis：3.5.7
3. maven 工程

1、创建 maven 工程，导入依赖

~~~xml
<dependencies>
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>8.0.27</version>
    </dependency>
    <dependency>
        <groupId>org.mybatis</groupId>
        <artifactId>mybatis</artifactId>
        <version>3.4.5</version>
    </dependency>
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <version>1.18.22</version>
    </dependency>
</dependencies>
~~~

2、创建实体类

~~~java
@ToString
@Getter
@Setter
@Builder
public class User {
    Integer id;
    String account;
    String name;
    String password;
}
~~~

3、用户接口

~~~java
public interface UserDao {

    /**
     * 保存
     */
    int savaUser(@Param("user") User user);

    /**
     * 查询
     */
    List<User> findByid(@Param("id") int id);

    /**
     * 添加
     */
    int addUser(@Param("id") int id, @Param("user") User user);

    /**
     * 删除
     */
    int deleteById(@Param("id") int id);
}
~~~

4、编写配置文件

> 在 resources 文件夹中，创建Mybatis的主配置文件 SqlMapConfig.xml。它是 mybatis 核心配置文件，配置文件内容为数据源、事务管理。
>
> 配置环境：
>
> - 配置 mysql 的环境：
>   1. 配置事务的类型；
>   2. 配置连接池：配置连接数据库的4个基本信息；
>
> - 指定映射配置文件的位置：

~~~xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <!-- 数据源配置 -->
    <!--
      default: 当前环境默认数据库环境
    -->
    <environments default="mysql">
        <!-- id: 每个数据库环境的ID -->
        <environment id="mysql">
            <!--   事务管理器，事务控制
                 jdbc: 数据源事务管理器  ，类似Spring的DataSourceTransactiionManager -->
            <transactionManager type="JDBC"></transactionManager>
            <!--  type: 连接池类型
                  POOLED: 使用mybatis自带的数据源
                  UNPOOLED: 不使用数据源 -->
            <dataSource type="POOLED">
                <!--  数据库链接配置 -->
                <property name="driver" value="com.mysql.cj.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3306/test?autoReconnect=true"/>
                <property name="username" value="root"/>
                <property name="password" value="root"/>
            </dataSource>
        </environment>
    </environments>

    <mappers>
        <!--
       1、指定映射配置文件的位置，映射配置文件指的是每个dao独立的配置文件
	   2、路径必须是反斜杠
        -->
        <mapper resource="com/mobaijun/dao/mapper/UserDao.xml"/>
    </mappers>
</configuration>
~~~

5、映射文件，目录地址：`com.mobaijun.dao.mapper.*.xml`

~~~xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.mobaijun.dao.UserDao">
    <resultMap id="BaseResultMap" type="com.mobaijun.entity.User">
        <id column="id" property="id" jdbcType="INTEGER"/>
        <result column="name" property="name" jdbcType="VARCHAR"/>
        <result column="account" property="account" jdbcType="VARCHAR"/>
        <result column="password" property="password" jdbcType="VARCHAR"/>
    </resultMap>

    <sql id="Column_List">
        id,`name`,account,password
    </sql>

    <insert id="saveUser" parameterType="com.mobaijun.entity.User">
        INSERT INTO `user`(`id`, `account`, `name`, `password`)
        VALUES (#{id}, #{account}, #{name}, #{password});
    </insert>

    <delete id="deleteById">
        DELETE
        FROM user
        WHERE id = ${id}
    </delete>

    <select id="findByid" resultMap="BaseResultMap">
        SELECT
        <include refid="Column_List"/>
        FROM user WHERE id=#{id};
    </select>

    <select id="findAll" resultType="com.mobaijun.entity.User">
        SELECT
        <include refid="Column_List"/>
        FROM user
    </select>
</mapper>
~~~

* 参数说明

1. namespace：用来区别不同的类的名字  
2. id:标识映射文件中的 sql，称为statement的 id 将 sql 语句封装到 mappedStatement 对象中，所以将 id 称为 statement 的 id 
3. sql：里面为表所有字段，可自定义或添加别名。
4. parameterType: 指定输入参数的类型. 
5. resultType: 指定输出结果类型。mybatis 将 sql 查询结果的一行记录数据映射为 resultType 指定类型的对象。如果有多条数据，则分别进行映射，并把对象放到容器 List 中

~~~bash
1、#{}:一个占位符。preparedStatement向占位符中设置值，自动进行java类型和jdbc类型转换。#{}可以有效防止sql注入。 #{}可以接收简单类型值或pojo属性值。 如果parameterType传输单个简单类型值，#{}括号中可以是value或其它名称。

2、${}:表示拼接sql串，通过${}可以将parameterType 传入的内容拼接在sql中且不进行jdbc类型转换，${}可以接收简单类型值或pojo属性值，如果parameterType传输单个简单类型值，${}括号中只能是value。
~~~

6、编写测试类

> 在 test->java 目录下创建测试类 com.mobaijun.test.MybatisTest。实现业务需求，共7步。

~~~java
1. 扫描mappper配置文件`SqlMapConfig.xml`
2. 创建`SqlSessionFactoryBuilder`工厂
3. 创建`SqlSessionFactory`工厂
4. 创建`SqlSession`,包含`CRUD`方法
5. 获取Mapper接口的代理对象
6. 使用代理执行CRUD操作
7. 关闭资源
~~~

* 示例代码

~~~java
@Slf4j
@SpringBootTest
public class MybatisTest {

    /**
     * 根据id查询
     */
    @SneakyThrows
    @Test
    public void findById() {
        // 1.读取配置文件
        InputStream in = Resources.getResourceAsStream("SqlMapConfig.xml");
        // 2.创建SqlSessionFactory工厂
        SqlSessionFactory build = new SqlSessionFactoryBuilder().build(in);
        // 3.使用工厂生产SqlSession对象
        SqlSession session = build.openSession();
        // 4.执行Sql语句
        UserDao userDao = session.getMapper(UserDao.class);
        log.info("代理对象：" + userDao.getClass());
        // 5. 打印结果
        List<User> list = userDao.findByid(1);
        // 输出结果：User(id=1, account=mobai, name=墨白, password=123456)
        list.forEach(System.out::println);
        // 6.释放资源
        session.close();
        in.close();
    }

    /**
     * 删除
     */
    @SneakyThrows
    @Test
    public void deleteById() {
        // 1.读取配置文件
        InputStream in = Resources.getResourceAsStream("SqlMapConfig.xml");
        // 2.创建SqlSessionFactory工厂
        SqlSessionFactory build = new SqlSessionFactoryBuilder().build(in);
        // 3.使用工厂生产SqlSession对象
        SqlSession session = build.openSession();
        // 4.执行Sql语句
        UserDao userDao = session.getMapper(UserDao.class);
        log.info("代理对象：" + userDao.getClass());
        // 5. 执行SQL
        userDao.deleteById(1);
        // 6.释放资源
        session.close();
        in.close();
    }

    /**
     * 新增
     */
    @SneakyThrows
    @Test
    @Rollback
    public void saveUser() {
        // 1.读取配置文件
        InputStream in = Resources.getResourceAsStream("SqlMapConfig.xml");
        // 2.创建SqlSessionFactory工厂
        SqlSessionFactory build = new SqlSessionFactoryBuilder().build(in);
        // 3.使用工厂生产SqlSession对象
        SqlSession session = build.openSession();
        // 4.执行Sql语句
        UserDao userDao = session.getMapper(UserDao.class);
        User user;
        for (int i = 0; i < 100; i++) {
            user = User.builder()
                    .id(i + 1)
                    .account("mobai123")
                    .name("mobaijun")
                    .password("123456")
                    .build();
            log.info("代理对象：" + userDao.getClass());
            // 5. 执行SQL
            userDao.saveUser(user);
            // 6. 提交数据
            session.commit();
            System.out.println(user);
        }
        // 7.释放资源
        session.close();
        in.close();
    }
}
~~~

## 基于原始 Dao 实现 CRUD

需要自行实现 dao 接口和 dao 实现类，即 UserDao 和 UserDaoImpl 实现类。

原始 Dao 开发存在以下问题

* Dao方法体存在重复代码：通过SqlSessionFactory创建SqlSession，调用 SqlSession 的数据库操作方法
* 调用 sqlSession 的数据库操作方法需要指定 statement 的 id，这里存在硬编码，不得于开发维护。

持久层 Dao 接口

~~~java
@Mapper
public interface TestUserDao {

    /**
     * 通过ID查询一个用户
     */
    TestUser findUserById(@Param("id") Integer id);

    /**
     * 根据用户名模糊查询用户列表
     */
    List<TestUser> findUserByUserName(@Param("name") String name);

    /**
     * 添加用户
     */
    int insertUser(TestUser user);

    /**
     * 更新用户
     */
    void updateUserById(TestUser user);

    /**
     * 删除用户
     */
    void deleteUserById(@Param("id") Integer id);
}
~~~

实现类

~~~java
public class TestUserDaoImpl implements TestUserDao {

    private SqlSessionFactory sqlSessionFactory;

    /**
     * 通过构造方法注入
     */
    public TestUserDaoImpl(SqlSessionFactory sqlSessionFactory) {
        this.sqlSessionFactory = sqlSessionFactory;
    }

    @Override
    public TestUser findUserById(Integer id) {
        // sqlSession是线程不安全的，所以它的最佳使用范围在方法体内
        SqlSession sqlSession = sqlSessionFactory.openSession();
        TestUserDao mapper = sqlSession.getMapper(TestUserDao.class);
        TestUser user = mapper.findUserById(id);
        sqlSession.close();
        return user;
    }

    @Override
    public List<TestUser> findUserByUserName(String name) {
        SqlSession sqlSession = sqlSessionFactory.openSession();
        TestUserDao mapper = sqlSession.getMapper(TestUserDao.class);
        List<TestUser> userList = mapper.findUserByUserName(name);
        sqlSession.close();
        return userList;
    }

    @Override
    public int insertUser(TestUser user) {
        SqlSession sqlSession = sqlSessionFactory.openSession();
        TestUserDao mapper = sqlSession.getMapper(TestUserDao.class);
        int i = mapper.insertUser(user);
        sqlSession.commit();
        sqlSession.close();
        return i;
    }

    @Override
    public void updateUserById(TestUser user) {
        SqlSession sqlSession = sqlSessionFactory.openSession();
        TestUserDao mapper = sqlSession.getMapper(TestUserDao.class);
        mapper.updateUserById(user);
        sqlSession.commit();
        sqlSession.close();
    }

    @Override
    public void deleteUserById(Integer id) {
        SqlSession sqlSession = sqlSessionFactory.openSession();
        TestUserDao mapper = sqlSession.getMapper(TestUserDao.class);
        mapper.deleteUserById(id);
        sqlSession.commit();
        sqlSession.close();
    }
}
~~~

映射文件

~~~xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.mobaijun.dao.TestUserDao">
    <resultMap id="BaseResultMap" type="com.mobaijun.entity.TestUser">
        <id column="id" property="id" jdbcType="INTEGER"/>
        <result column="name" property="name" jdbcType="VARCHAR"/>
        <result column="account" property="account" jdbcType="VARCHAR"/>
        <result column="password" property="password" jdbcType="VARCHAR"/>
    </resultMap>

    <sql id="Column_List">
        id,`name`,account,password
    </sql>

    <!--  添加用户  -->
    <insert id="insertUser">
        INSERT INTO `user` (`id`, `account`, `name`, `password`)
        VALUES (#{id}, #{account}, #{name}, #{password});
    </insert>

    <!--  更新用户  -->
    <update id="updateUserById">
        UPDATE `test`.`user`
        SET `account`  = #{account},
            `name`     =#{name},
            `password` = #{password}
        WHERE `id` = #{id};
    </update>

    <!-- 根据id删除一个用户 -->
    <delete id="deleteUserById">
        delete
        from user
        where id = #{id}
    </delete>

    <!-- 通过Id查询一个用户 -->
    <select id="findUserById" resultType="com.mobaijun.entity.TestUser">
        SELECT
        <include refid="Column_List"/>
        FROM `user`
        WHERE id = #{id}
    </select>

    <!-- 根据用户名模糊查询用户列表 -->
    <select id="findUserByUserName" resultType="com.mobaijun.entity.TestUser">
        SELECT *
        FROM `user`
        WHERE name LIKE '%'#{name}'%'
    </select>

</mapper>
~~~

Mybatis 配置文件

~~~xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <!-- 数据源配置 -->
    <environments default="mysql">
        <!--  配置 MySQL 环境-->
        <environment id="mysql">
            <!--  配置事务类型 -->
            <transactionManager type="JDBC"></transactionManager>
            <!--  配置连接池 -->
            <dataSource type="POOLED">
                <!--  数据库链接配置 -->
                <property name="driver" value="com.mysql.cj.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3306/test?autoReconnect=true"/>
                <property name="username" value="root"/>
                <property name="password" value="root"/>
            </dataSource>
        </environment>
    </environments>

    <mappers>
        <!--
       1、指定映射配置文件的位置，映射配置文件指的是每个dao独立的配置文件
       2、*表示通配符，表示 mapper 目录下所有以 .xml 后缀结尾的文件
        -->
        <mapper resource="com/mobaijun/dao/mapper/UserDao.xml"/>
        <mapper resource="com/mobaijun/dao/mapper/TestUserDao.xml"/>
    </mappers>
</configuration>
~~~

源码地址：[spring-boot-mybatis](https://gitee.com/mobaijun/spring-boot-wikis/tree/devople/spring-boot-mybatis)

