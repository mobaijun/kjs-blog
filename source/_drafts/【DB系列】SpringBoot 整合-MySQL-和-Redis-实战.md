---
title: 【DB系列】SpringBoot 整合 MySQL 和 Redis 实战
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 990352141
tags:
  - Redis
categories:
  - SpringBoot
date: 2021-10-21 10:09:14
img:
coverImg:
password:
summary:
---

## Redis 简介

### 什么是 Redis ？

`Redis `是目前使用的非常广泛的免费开源内存数据库，是一个高性能的 `key-value` 数据库。

`Redis `与其他 `key-value` 缓存（如 `Memcached `）相比有以下三个特点:

> 1. `Redis `支持数据的持久化，它可以将内存中的数据保存在磁盘中，重启的时候可以再次加载进行使用。
> 2. `Redis `不仅仅支持简单的 `key-value` 类型的数据，同时还提供 `list，set，zset，hash` 等数据结构的存储。
> 3. `Redis `支持数据的备份，即 `master-slave` 模式的数据备份。

Redis 优势如下：

> 1. 性能极高。`Redis `能读的速度是 `110000 次/s`，写的速度是 `81000 次/s`。
> 2. 丰富的数据类型。`Redis `支持二进制案例的 `Strings`，`Lists`，`Sets `及 `Ordered Sets` 数据类型操作。 
> 3. 原子性。`Redis `所有的操作都是原子性的，意思是要么成功执行要么失败完全不执行。单个操作是原子性的，多个操作也是，通过 `MULTI `和 `EXEC `指令抱起来。 
> 4. 丰富的特性。`Redis `还支持 `publish/subscribe`，通知，`key `过期等特性。
>
> 基础信息可以看我之前发表的那篇文章：[Redis复习笔记 | 框架师](https://www.mobaijun.com/posts/1110110442.html)

## Spring Boot 集成 Redis

------

环境说明：

1. SpringBoot 版本：2.5.5
2. Redis 版本 ： 5.X

------

### 添加依赖

在项目中添加依赖

~~~xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-redis</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
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
        <groupId>org.apache.commons</groupId>
        <artifactId>commons-pool2</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>
~~~

查看 Jar 包，在 `spring-boot-starter-data-redis` 源码依赖里面，进入 `spring-data-redis`，发现两个 `redis ` 驱动， `jedis` 和 `lettuce`  ，这说明 `Spring Boot` 已经默认包装适配了这两个 `Redis `驱动。

~~~xml
<!-- REDIS Drivers -->
<dependency>
	<groupId>redis.clients</groupId>
	<artifactId>jedis</artifactId>
	<version>${jedis}</version>
	<optional>true</optional>
</dependency>
<dependency>
	<groupId>io.lettuce</groupId>
	<artifactId>lettuce-core</artifactId>
	<version>${lettuce}</version>
	<optional>true</optional>
</dependency>
~~~

> 在 `SpringBoot 1.5.x` 版本的默认的 `Redis` 客户端是  `Jedis` 实现的，`SpringBoot 2.x` 版本中默认客户端是用 `lettuce` 实现的。

### Lettuce 与 Jedis 比较

[Lettuce](https://link.juejin.cn?target=https%3A%2F%2Flettuce.io%2Fcore%2Frelease%2Freference%2F) 和 [Jedis](https://link.juejin.cn?target=http%3A%2F%2Ftool.oschina.net%2Fuploads%2Fapidocs%2Fredis%2Fclients%2Fjedis%2FJedis.html) 的都是连接 `Redis Server` 的客户端。

> `Jedis` 在实现上是直连 `redis server`，多线程环境下非线程安全，除非使用连接池，为每个 `redis `实例增加物理连接。

------

> `Lettuce `是 一种可伸缩，线程安全，完全非阻塞的 `Redis` 客户端，多个线程可以共享一个`RedisConnection`,它利用 `Netty NIO` 框架来高效地管理多个连接，从而提供了异步和同步数据访问方式，用于构建非阻塞的反应性应用程序。

------

## Lettuce 集成 Redis 服务

> PS: `Spring Boot 2.X` 默认集成了 `Lettuce `，所以无需导入。

* application.yml 配置文件

~~~yaml
################## Redis 基础配置 #####################
spring:
  redis:
    # 数据库索引 （默认0-15个库）,选择使用 0 号库
    database: 0
    # Redis 服务器地址
    host: 127.0.0.1
    # Redis 服务器端口
    port: 6379
    # Redis 服务器密码(默认为null)没有就不写
    password:
    # 连接超时时间 单位ms（毫秒）
    timeout: 3000
    ################## Redis 线程池设置 #####################
    lettuce:
      pool:
        # 连接池最大连接数（使用负值表示没有限制） 默认 8
        max-active: 8
        # 连接池最大阻塞等待时间（使用负值表示没有限制） 默认 -1
        max-wait: -1
        # 连接池中的最大空闲连接 默认 8
        max-idle: 8
        # 连接池中的最小空闲连接 默认 0
        min-idle: 0
~~~

### 自定义 RedisTemplate

#### 探究

默认情况下的模板只能支持 `RedisTemplate<String,String>`，只能存入字符串，很多时候，我们需要自定义 `RedisTemplate `，设置序列化器，这样我们可以很方便的操作实例对象。

查看源码发现基于`API`的`Redis`缓存实现是使用`RedisTemplate`模板进行数据缓存操作的，这里打开`RedisTemplate`类，查看该类的源码信息

~~~java
// 声明了key、value的各种序列化方式，初始值为空
@SuppressWarnings("rawtypes") private @Nullable RedisSerializer keySerializer = null;
@SuppressWarnings("rawtypes") private @Nullable RedisSerializer valueSerializer = null;
@SuppressWarnings("rawtypes") private @Nullable RedisSerializer hashKeySerializer = null;
@SuppressWarnings("rawtypes") private @Nullable RedisSerializer hashValueSerializer = null;
~~~

默认序列化方式设置，设置为`JDK`序列化方式

~~~java
@Override
public void afterPropertiesSet() {
	super.afterPropertiesSet(  );
	boolean defaultUsed = false;
	if (defaultSerializer == null) {
		defaultSerializer = new JdkSerializationRedisSerializer(
				classLoader != null ? classLoader : this.getClass().getClassLoader());
	}
	if (enableDefaultSerializer) {
		if (keySerializer == null) {
			keySerializer = defaultSerializer;
			defaultUsed = true;
		}
		if (valueSerializer == null) {
			valueSerializer = defaultSerializer;
			defaultUsed = true;
		}
		if (hashKeySerializer == null) {
			hashKeySerializer = defaultSerializer;
			defaultUsed = true;
		}
		if (hashValueSerializer == null) {
			hashValueSerializer = defaultSerializer;
			defaultUsed = true;
		}
	}
	if (enableDefaultSerializer && defaultUsed) {
		Assert.notNull(defaultSerializer, "default serializer null and not all serializers initialized");
	}
	if (scriptExecutor == null) {
		this.scriptExecutor = new DefaultScriptExecutor<>(this);
	}
	initialized = true;
}
~~~

从上述`RedisTemplate`核心源码可以看出，在`RedisTemplate`内部声明了缓存数据`key、value`的各种序列化方式，且初始值都为空；在`afterPropertiesSet()`方法中，判断如果默认序列化参数`defaultSerializer`为空，将数据的默认序列化方式设置为`JdkSerializationRedisSerializer` 。

 根据上述源码信息的分析，可以得到以下两个重要的结论：

（1）使用`RedisTemplate`进行`Redis`数据缓存操作时，内部默认使用的是`JdkSerializationRedisSerializer`序列化方式，所以进行数据缓存的实体类必须实现`JDK`自带的序列化接口（例如`Serializable`）；

（2）使用`RedisTemplate`进行`Redis`数据缓存操作时，如果自定义了缓存序列化方式`defaultSerializer`，那么将使用自定义的序列化方式。

 另外，在`RedisTemplate`类源码中，看到的缓存数据`key、value`的各种序列化类型都是`RedisSerializer`。进入`RedisSerializer`源码查看`RedisSerializer`支持的序列化方式（进入该类后，使用`Ctrl+Alt+左键单击类名`查看）

![RedisSerializer源码](https://tencent.cos.mobaijun.com/article_with_pictures/image-20211021111343186.png)

 可以看出，`RedisSerializer `是一个`Redis`序列化接口，默认有`6`个实现类，这6个实现类代表了`6`种不同的数据序列化方式。其中，`JdkSerializationRedisSerializer`是JDK自带的，也是RedisTemplate内部默认使用的数据序列化方式，我们可以根据需要选择其他支持的序列化方式（例如`JSON`方式）

#### 实现(RedisTemplate序列化机制)

`Spring Boot`提供的`RedisAutoConfiguration`自动配置会生效。打开`RedisAutoConfiguration`类，查看内部源码中关于`RedisTemplate`的定义方式

~~~java
@Configuration(proxyBeanMethods = false)
@ConditionalOnClass(RedisOperations.class)
@EnableConfigurationProperties(RedisProperties.class)
@Import({ LettuceConnectionConfiguration.class, JedisConnectionConfiguration.class })
public class RedisAutoConfiguration {

	@Bean
	@ConditionalOnMissingBean(name = "redisTemplate")
	@ConditionalOnSingleCandidate(RedisConnectionFactory.class)
	public RedisTemplate<Object, Object> redisTemplate(RedisConnectionFactory redisConnectionFactory) {
		RedisTemplate<Object, Object> template = new RedisTemplate<>();
		template.setConnectionFactory(redisConnectionFactory);
		return template;
	}

	@Bean
	@ConditionalOnMissingBean
	@ConditionalOnSingleCandidate(RedisConnectionFactory.class)
	public StringRedisTemplate stringRedisTemplate(RedisConnectionFactory redisConnectionFactory) {
		StringRedisTemplate template = new StringRedisTemplate();
		template.setConnectionFactory(redisConnectionFactory);
		return template;
	}
}
~~~

从上述`RedisAutoConfiguration`核心源码中可以看出，在`Redis`自动配置类中，通过`Redis`连接工厂`RedisConnectionFactory`初始化了一个`RedisTemplate`；该类上方添加了`@ConditionalOnMissingBean`注解（顾名思义，当某个`Bean`不存在时生效），用来表明如果开发者自定义了一个名为`redisTemplate`的`Bean`，则该默认初始化的`RedisTemplate`不会生效。

 如果想要使用自定义序列化方式的`RedisTemplate`进行数据缓存操作，可以参考上述核心代码创建一个名为`redisTemplate`的`Bean`组件，并在该组件中设置对应的序列化方式即可

 接下来，在项目中创建名为`config`的包，在该包下创建一个`Redis`自定义配置类`LettuceRedisConfig`，并按照上述思路自定义名为`redisTemplate`的`Bean`组件

~~~java
package com.mobaijun.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;

import java.io.Serializable;

/**
 * Software：IntelliJ IDEA 2021.2 x64
 * Author: https://www.mobaijun.com
 * Date: 2021/10/21 10:48
 * ClassName:LettuceRedisConfig
 * 类描述： Redis Lettuce 自定义模板
 */
@Configuration
public class LettuceRedisConfig {

    @Bean
    public RedisTemplate<String, Serializable> redisTemplate(LettuceConnectionFactory factory) {
        RedisTemplate<String, Serializable> redisTemplate = new RedisTemplate<>();
        redisTemplate.setKeySerializer(new StringRedisSerializer());
        redisTemplate.setValueSerializer(new GenericJackson2JsonRedisSerializer());
        redisTemplate.setConnectionFactory(factory);
        return redisTemplate;
    }
}
~~~

> 通过`@Configuration`注解定义了一个`RedisConfig`配置类，并使用`@Bean`注解注入了一个默认名称为方法名的`redisTemplate`组件（注意，该`Bean`组件名称必须是`redisTemplate`）。在定义的`Bean`组件中，自定义了一个`RedisTemplate`，使用自定义的`GenericJackson2JsonRedisSerializer`数据序列化方式；

### 序列化实体类

~~~java
package com.mobaijun.pojo;

import lombok.Data;

import java.io.Serializable;

/**
 * Software：IntelliJ IDEA 2021.2 x64
 * Author: https://www.mobaijun.com
 * Date: 2021/10/21 11:26
 * ClassName:User
 * 类描述： 用户实体类
 */
@Data
public class User implements Serializable {
    // 用户id
    private Long id;
    // 用户名
    private String userName;
    // 性别
    private String userSex;
}
~~~

### 单元测试

~~~java
package com.mobaijun;

import com.mobaijun.pojo.User;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.redis.core.RedisTemplate;

import java.io.Serializable;

@SpringBootTest
class SpringBootRedisApplicationTests {

    @Autowired
    private RedisTemplate<String, String> redisTemplate;
    @Autowired
    private RedisTemplate<String, Serializable> serializableRedisTemplate;

    @Test
    void contextLoads() {
        redisTemplate.opsForValue().set("keyName", "mobaijun");
        System.out.println(redisTemplate.opsForValue().get("keyName"));
    }

    @Test
    public void testSerializable() {
        User user = new User();
        user.setId(1L);
        user.setUserName("墨白君");
        user.setUserSex("男");
        serializableRedisTemplate.opsForValue().set("user", user);
        User user2 = (User) serializableRedisTemplate.opsForValue().get("user");
        System.out.println("user:" + user2.getId() + "," + user2.getUserName() + "," + user2.getUserSex());
    }
}

~~~

 使用Redis客户端可视化管理工具`Redis Desktop Manager`查看缓存数据 ,这里我找到了两款软件，都还不错，按需下载：[传送门](https://www.aliyundrive.com/s/uPa8vJEW1Uc)

![客户端查看信息](https://tencent.cos.mobaijun.com/article_with_pictures/image-20211021142837587.png)

### 异常处理

* 可能出现的异常信息：

```java
Error creating bean with name 'redisTemplate' defined in class path resource 
```

或者

~~~java
Error creating bean with name 'redisConnectionFactory' defined in class path resource 
~~~

是因为`lettuce 依赖commons-pool2`，所以引入该包即可

~~~xml
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-pool2</artifactId>
</dependency>
~~~

## Jedis 集成 Redis 服务

* 导入依赖

~~~xml
<dependencies>
    <!-- Redis -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-redis</artifactId>
        <exclusions>
            <!-- 排除 lettuce 包-->
            <exclusion>
                <groupId>io.lettuce</groupId>
                <artifactId>lettuce-core</artifactId>
            </exclusion>
        </exclusions>
    </dependency>
    <!-- 导入jedis -->
    <dependency>
        <groupId>redis.clients</groupId>
        <artifactId>jedis</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
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

* 配置文件

~~~yaml
################## Redis 基础配置 #####################
spring:
  redis:
    # 数据库索引 （默认0-15个库）,选择使用 0 号库
    database: 0
    # Redis 服务器地址
    host: 127.0.0.1
    # Redis 服务器端口
    port: 6379
    # Redis 服务器密码(默认为null)没有就不写
    password:
    # 连接超时时间 单位ms（毫秒）
    timeout: 3000
    ################## Redis 线程池设置 #####################
    jedis:
      pool:
        # 连接池最大连接数（使用负值表示没有限制） 默认 8
        max-active: 8
        # 连接池最大阻塞等待时间（使用负值表示没有限制） 默认 -1
        max-wait: -1
        # 连接池中的最大空闲连接 默认 8
        max-idle: 8
        # 连接池中的最小空闲连接 默认 0
        min-idle: 0
~~~

* 配置类

~~~java
package com.mobaijun.config;


import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.RedisPassword;
import org.springframework.data.redis.connection.RedisStandaloneConfiguration;
import org.springframework.data.redis.connection.jedis.JedisClientConfiguration;
import org.springframework.data.redis.connection.jedis.JedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import redis.clients.jedis.JedisPoolConfig;

import java.io.Serializable;
import java.time.Duration;

/**
 * Software：IntelliJ IDEA 2021.2 x64
 * Author: https://www.mobaijun.com
 * Date: 2021/10/21 14:48
 * ClassName:JedisRedisConfig
 * 类描述： Jedis自定义配置类
 */
@Configuration
public class JedisRedisConfig {

    @Value("${spring.redis.database}")
    private int database;

    @Value("${spring.redis.host}")
    private String host;

    @Value("${spring.redis.port}")
    private int port;

    @Value("${spring.redis.password}")
    private String password;

    @Value("${spring.redis.timeout}")
    private int timeout;

    @Value("${spring.redis.jedis.pool.max-active}")
    private int maxActive;

    @Value("${spring.redis.jedis.pool.max-wait}")
    private long maxWaitMillis;

    @Value("${spring.redis.jedis.pool.max-idle}")
    private int maxIdle;

    @Value("${spring.redis.jedis.pool.min-idle}")
    private int minIdle;

    /**
     * 连接池配置
     */
    @Bean
    public JedisPoolConfig jedisPoolConfig() {
        JedisPoolConfig jedisPoolConfig = new JedisPoolConfig();
        // 最大连接数
        jedisPoolConfig.setMaxTotal(maxActive);
        // 当池内没有可用连接时，最大等待时间
        jedisPoolConfig.setMaxWaitMillis(maxWaitMillis);
        // 最大空闲连接数
        jedisPoolConfig.setMaxIdle(maxIdle);
        // 最小空闲连接数
        jedisPoolConfig.setMinIdle(minIdle);
        return jedisPoolConfig;
    }

    /**
     * Jedis 连接配置
     */
    @Bean
    public JedisConnectionFactory jedisConnectionFactory(JedisPoolConfig jedisPoolConfig) {
        JedisClientConfiguration jedisClientConfiguration = JedisClientConfiguration.builder().usePooling()
                .poolConfig(jedisPoolConfig).and().readTimeout(Duration.ofMillis(timeout)).build();
        RedisStandaloneConfiguration redisStandaloneConfiguration = new RedisStandaloneConfiguration();
        redisStandaloneConfiguration.setHostName(host);
        redisStandaloneConfiguration.setPort(port);
        redisStandaloneConfiguration.setDatabase(database);
        redisStandaloneConfiguration.setPassword(RedisPassword.of(password));
        return new JedisConnectionFactory(redisStandaloneConfiguration, jedisClientConfiguration);
    }

    /**
     * 缓存管理器
     */
    @Bean
    public RedisCacheManager cacheManager(RedisConnectionFactory connectionFactory) {
        return RedisCacheManager.create(connectionFactory);
    }

    /**
     * 自定义模板
     */
    @Bean
    public RedisTemplate<String, Serializable> redisTemplate(JedisConnectionFactory connectionFactory) {
        RedisTemplate<String, Serializable> redisTemplate = new RedisTemplate<>();
        redisTemplate.setKeySerializer(new StringRedisSerializer());
        redisTemplate.setValueSerializer(new GenericJackson2JsonRedisSerializer());
        redisTemplate.setConnectionFactory(jedisConnectionFactory(jedisPoolConfig()));
        return redisTemplate;
    }
}
~~~

* 单元测试

~~~java
package com.mobaijun;

import com.mobaijun.pojo.User;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.redis.core.RedisTemplate;

import java.io.Serializable;

@SpringBootTest
class SpringBootRedisJedisApplicationTests {

    @Autowired
    private RedisTemplate<String, String> redisTemplate;
    
    @Autowired
    private RedisTemplate<String, Serializable> serializableRedisTemplate;

    @Test
    void contextLoads() {
        redisTemplate.opsForValue().set("keyName", "mobaijun");
        System.out.println(redisTemplate.opsForValue().get("keyName"));
    }

    @Test
    public void testSerializable() {
        User user = new User();
        user.setId(1L);
        user.setUserName("墨白君");
        user.setUserSex("男");
        serializableRedisTemplate.opsForValue().set("user", user);
        User user2 = (User) serializableRedisTemplate.opsForValue().get("user");
        System.out.println("user:" + user2.getId() + "," + user2.getUserName() + "," + user2.getUserSex());
    }
}
~~~

## SpringBoot 集成 MySQL 和 Redis

以上测试做完后开始集成 `MySQL`

* 新建一个 `SpringBoot `项目，导入依赖，编辑配置文件

~~~xml
 <parent>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-starter-parent</artifactId>
     <version>2.5.5</version>
     <relativePath/> <!-- lookup parent from repository -->
 </parent>
 <properties>
     <java.version>1.8</java.version>
     <mybatis-plus>3.2.0</mybatis-plus>
 </properties>
 <dependencies>
     <!-- Redis -->
     <dependency>
         <groupId>org.springframework.boot</groupId>
         <artifactId>spring-boot-starter-data-redis</artifactId>
     </dependency>
     <!-- WEB依赖 -->
     <dependency>
         <groupId>org.springframework.boot</groupId>
         <artifactId>spring-boot-starter-web</artifactId>
     </dependency>
     <!-- MybatisPlus -->
     <dependency>
         <groupId>com.baomidou</groupId>
         <artifactId>mybatis-plus-boot-starter</artifactId>
         <version>${mybatis-plus}</version>
     </dependency>
     <dependency>
         <groupId>com.baomidou</groupId>
         <artifactId>mybatis-plus-generator</artifactId>
         <version>${mybatis-plus}</version>
     </dependency>
     <!-- MySQL -->
     <dependency>
         <groupId>mysql</groupId>
         <artifactId>mysql-connector-java</artifactId>
         <scope>runtime</scope>
     </dependency>
     <!-- 添加swagger3相关功能 -->
     <dependency>
         <groupId>io.springfox</groupId>
         <artifactId>springfox-boot-starter</artifactId>
         <version>3.0.0</version>
     </dependency>
     <!-- apache 工具包 -->
     <dependency>
         <groupId>org.apache.commons</groupId>
         <artifactId>commons-lang3</artifactId>
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

* 配置文件

~~~yaml
server:
  # 服务端口配置
  port: 8000
############# MySQL 配置 ############
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/zijing_monitor?autoReconnect=true&useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Hongkong
    username: root
    password: root
  ############# Redis 配置 ############
  # redis配置
  redis:
    database: 0
    host: 127.0.0.1
    port: 6379
    password:
    timeout: 10000
    lettuce:
      pool:
        # 连接池最大连接数（使用负值表示没有限制） 默认 8
        max-active: 16
        # 连接池中的最大空闲连接 默认 8
        max-idle: 8
        # 连接池最大阻塞等待时间,单位毫秒（使用负值表示没有限制） 默认 -1
        max-wait: 1000ms
        # 连接池中的最小空闲连接 默认 0
        min-idle: 0

# MybatisPlus配置
mybatis-plus:
  mapper-locations: classpath*:dao/**/*.xml
  type-aliases-package: com.mobaijun.pojo
  configuration:
    map-underscore-to-camel-case: true
    auto-mapping-behavior: full
    # 打印sql语句,调试用
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
    # 配置的缓存的全局开关
    cache-enabled: true
    # 延时加载的开关
    lazy-loading-enabled: true
    # 开启的话，延时加载一个属性时会加载该对象全部属性，否则按需加载属性
    multiple-result-sets-enabled: true
  global-config:
    db-config:
      # 删除前
      logic-delete-value: 1
      # 删除后
      logic-not-delete-value: 0
      # 0:数据库ID自增   1:用户输入id  2:全局唯一id(IdWorker)  3:全局唯一ID(uuid)
      id-type: auto
      # 表名、是否使用下划线命名（默认 true:默认数据库表下划线命名）
      table-underline: false
#########日志配置########
# 日志配置
logging:
  file:
  # 路径
    path: logs

############## swagger配置 ######################
swagger:
  enable: true
  title: 学习 SpringBoot 整合 MySQL 和 Redis
  description: SpringBoot 整合 MySQL 和 Redis
  termsOfServiceUrl: https://www.mobaijun.com/
  version: 1.0
  contact:
    name: 墨白
    url: https://www.mobaijun.com/
    # email: mobaijun8@163.com 
~~~



示例代码：[传送门](https://gitee.com/mobaijun/spring-boot-wikis/tree/devople/spring-boot-redis)

> 参考文章：[传送门](https://juejin.cn/post/6844903962504609805#heading-11)

