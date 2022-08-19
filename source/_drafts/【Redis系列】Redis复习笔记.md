---
title: 【Redis系列】Redis复习笔记
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - Redis
categories:
  - 数据库
abbrlink: 1110110442
date: 2020-05-08 11:42:20
img:
coverImg:
password:
summary:
---

### 01.复习简介

Redis是Java开发面试必问的一项技术,所以这两天着重复习了Redis的使用以及相关概念

### 02.NOSql介绍与好处

##### 疑问

* mysql这种关系型数据库（磁盘数据库）在处理大数据量存储和大量用户并发访问获取数据方面，性能如何？

  非常慢，对磁盘操作需要使用IO流，一个字节一个字节存取操作。所有数据读取到内存中后才可以操作。

  使用内存数据库优化磁盘数据库，内存数据库就是非关系型数据库NOSQL

##### NOSql介绍

NOSql，全称 not only sql ，不仅仅是sql，泛指非关系型数据库。

##### 非关系与关系型数据库的区别

| 特点     | 关系型数据库                                                 | 非关系型数据库                                              |
| :------- | :----------------------------------------------------------- | :---------------------------------------------------------- |
| 存储介质 | 以文件的方式保存在电脑(服务器)磁盘中                         | 通常只是存储在内存中,服务器关闭数据可能会部分丢失或全部丢失 |
| 优点     | 数据可以永久保存(非硬件故障/人为删库等情况)                  | 存取速度很快                                                |
| 缺点     | 1)数据添加有校验过程<br />2)查询的速度较慢<br />3)DML的操作需要用到事务,以上这些会导致查询速度降低 | 数据不能持久化保存,可能会导致数据部分丢失或全部丢失         |

##### 为什么需要NOSql？

因为是内存操作数据，非常快，会让系统性能大大提高。（解决了3高问题，高并发，高海量，高可用）

高并发：同一个时间点并发访问量非常大。

高海量：一个人访问的数据非常大，查询一个表，表中的数据有上亿条。

高可用：服务器崩溃了，服务器需要立刻重启后数据依然可用。

##### 以后到底用关系型数据库还是非关系型数据库?

2个都用

##### 小结

* 非关系数据库的性能为什么高于关系型数据库？

  因为内存存取远远大于磁盘读写的速度

### 03.NOSql数据库产品-Redis与Redis安装

##### 非关系型数据库的产品】



java领域主要使用**redis**,web阶段使用redis.

##### redis存储数据特点

使用键值对进行存取

##### redis安装与目录介绍

1. 下载

   windows版本，https://github.com/MSOpenTech/redis/tags   微软提供的

   linux版本，官方提供的http://redis.io/download 

2. 解压完成安装

3. 介绍redis的目录结构


##### 使用redis存储数据体验步骤

1. 双击运行redis服务器端redis-server.exe

   

2. 双击运行redis客户端redis-cli.exe

3. 在客户端上进行存取数据

   

##### 小结

* redis是以什么方式存储数据的？

  键值对

* redis客户端与服务器端软件的名字是什么？

  redis-cli.exe

  redis-server.exe

* redis服务器使用的端口号是？

  6379

### 04.redis存储数据的五种数据类型结构介绍

##### 目标

redis常见可以存储5种数据类型

##### 类型介绍

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/7.jpg)

##### key的使用原则

1)        不建议key名字太长，通常不超过1024字节，如果太长会影响查询的速度。

2)        不建议太短，太短会降低可读性。

3)        一般在公司，都有统一命名规范。

见名知意，与java变量的命名规范一致

##### 小结

* redis支持常用五种数据类型都有哪些？

  string

  hash

  list
  set

  sorted set(zset)

* 以后最常用使用哪种数据类型？

  string

### 05.redis数据类型命令1—String类型

##### 操作命令语法

注意:string类型存储数据每个value限制512MB

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/8.jpg)

##### String操作命令

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/9.jpg)

##### 小结

* 以后java应用开发主要使用redis什么类型存储数据数据？

  string类型

### 06.redis数据类型命令2—hash类型

##### 操作命令语法

注意：每个hash可以存储40亿个

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/10.jpg)

##### 操作

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/11.jpg)

##### 小结

* 使用hash类型添加存储数据的语法？

  hset key field1 value1

  hmset key field1 value1 field2 value2 ...

### 07.redis数据类型命令3—list类型

##### 操作命令语法

**存储特点：可以存储多个value，数可重复，有序**

添加元素语法

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/12.jpg)

操作

![1547174878543](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/13.jpg)

效果

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/14.jpg)

读取数据的语法

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/15.jpg)

效果

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/16.jpg)

删除元素

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/17.jpg)

效果

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/18.jpg)

查看列表的长度

| lien | 得到指定列表得长度 |
| ---- | ------------------ |
|      |                    |

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/19.jpg)

##### 小结

* list类型数据特点？

  链表,有序,可重复

  ![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/20.png)

### 08.redis数据类型命令4—set类型

##### 操作命令语法

存储数据特点：不可重复，无序

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/21.jpg)

效果

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/22.jpg)

##### 小结

* set类型数据特点？

  无序,不可重复

* 如果希望了解其他类型，怎么办？

  http://www.runoob.com/redis/redis-sorted-sets.html

### 09.客户端工具使用与redis通用命令

##### 客户端软件

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/20.jpg)

##### 操作命令语法

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/21.jpg)

效果

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/22.jpg)

### 10.redis持久化方式1-RDB策略

##### 疑问

* redis服务器关闭所有内存数据都会丢失吗？

  不会全部丢失，默认只会丢失一部分，因为redis有持久化机制，redis会将内存数据符合条件时进行持久化，在redis重启的时候会恢复持久化的数据，这就是内存数据不会全部丢失。

##### RDB策略介绍

rdb持久化策略就是在符合一定条件下将内存所有数据持久化到磁盘中dump.rdb文件中。RDB策略是redis默认持久化策略。

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/24.jpg)

rdb持久化内存的数据到dump.rdb文件，文件中会存储键值对数据。

rdb持久化的时候是将当时内存中所有的键值对一次性的持久化到dump.rdb

##### 案例演示-采用RDB策略持久化数据测试

- 需求

  修改rdb持久化策略方案，设置20秒内修改3个键进行持久化数据到dump.rdb文件中

- 实现步骤

  1. 修改配置文件redis.windows.conf，增加输入性配置

     ```
     save 20 3
     ```

  ![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/25.jpg)

  1. 关闭redis客户端、服务器端，重启redis服务器，注意重启时必须指明配置文件启动

     ![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/26.jpg)

  2. 启动客户端，观察redis服务器是否存储3个键值对，是否进行持久化操作

     ![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/27.jpg)

##### 注意

如果修改了配置文件redis.windows.conf，下次重启服务器端必须启动dos命令指定配置文件启动服务器。否则服务器无法识别配置文件的修改。

```shell
reids-server.exe redis.conf
```

##### 小结

- rdb策略的优点？

  持久化的频率不高，意味着redis提供给用户操作数据性能更高

- rdb策略的缺点？

  持久化的频率不高，意味着丢失数据严重，数据安全性低

### 11.redis持久化方式2-AOF策略

##### AOF策略介绍

默认没有开启的策略，它的特点持久化的频率更高了，默认每秒持久化1次。每一秒内将最新的的操作写的数据进行持久化。

需要修改配置文件redis.windows.conf进行开启AOF策略，如下操作

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/28.jpg)

开启AOF后，持久化策略有3个

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/29.jpg)

AOF默认是采用的策略是每秒持久化一次，会导致持久化文件随着时间不断增大，AOF会记录每一个key所有修改操作的过程。

##### 案例演示-采用AOF策略持久化数据测试

- 需求

  开启AOF策略进行持久化数据测试，观察其持久化数据的过程

- 实现步骤

  1. 修改配置文件redi.windows.conf,开启aof

     ![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/30.jpg)

  2. 关闭客户端、服务器端，重启服务器端并指定配置文件启动

  3. 观察持久化的数据


##### 疑问：每秒都持久化会导致日志文件过大，那么文件过大怎么办？需要开发人员做什么优化吗？

答：不需要开发人员做任何事情，redis对于aof策略有日志过大有重写机制(如下信息都在配置文件中)

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/31.jpg)

##### 小结

- AOF策略的优点?

  每秒持久化，具有更高的数据安全，如果服务器崩溃只会丢1秒内的数据

### 12.redis持久化RDB与AOF实践总结

##### 疑问

* RDB和AOF以后到底推荐使用哪一个呢？

  2个都使用

##### 官方建议

通常，如果你要想提供很高的数据保障性，那么建议你同时使用两种持久化方式。
如果你可以接受灾难带来的几分钟的数据丢失，那么你可以仅使用RDB。
很多用户仅使用了AOF，但是我们建议，既然RDB可以时不时的给数据做个完整的快照，并且提供更快的重启，所以最好还是也使用RDB。
因此，我们希望可以在未来（长远计划）统一AOF和RDB成一种持久化模式。

##### 常见面试题

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/32.jpg)

### 13.Jedis的使用1-基本使用

##### 疑问

* 对于关系型数据库我们都是使用jdbc操作mysql数据库存取数据，那么以后我们操作非关系型数据库是通过redis-cli客户端操作redis服务器存取数据吗？

  使用java代码来操作

##### Jedis介绍

​	点击文字下载相关代码jar包[第三方提供工具包，可以非常方便的连接并操作redis数据库服务器](https://mobaijun.lanzous.com/b015fmgwh )密码:`cmey`

##### Jedis的api方法

~~~java
import com.aicai.qa.tools.statics.config.SysConfigUtil;
import redis.clients.jedis.BinaryClient;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @version 1.0
 * @date 2020/5/8
 */
public class RedisUtil {
    private JedisPool pool = null;

    private RedisUtil() {
        if (pool == null) {
            String ip = SysConfigUtil.getSysConfigUtil("redis.properties").getString("redis.host");
            int port = SysConfigUtil.getSysConfigUtil("redis.properties").getInt("redis.port");
            String password = SysConfigUtil.getSysConfigUtil("redis.properties").getString("redis.password");
            JedisPoolConfig jedisPoolConfig = new JedisPoolConfig();
            jedisPoolConfig.setMaxTotal(SysConfigUtil.getSysConfigUtil("redis.properties").getInt("redis.maxTotal"));
            jedisPoolConfig.setMaxIdle(SysConfigUtil.getSysConfigUtil("redis.properties").getInt("redis.maxIdle"));
            jedisPoolConfig.setMaxWaitMillis(SysConfigUtil.getSysConfigUtil("redis.properties").getLong("redis.maxWaitMillis"));
            jedisPoolConfig.setTestOnBorrow(SysConfigUtil.getSysConfigUtil("redis.properties").getBoolean("redis.testOnBorrow"));
            if (password != null && !"".equals(password)) {
                // redis 设置了密码
                pool = new JedisPool(jedisPoolConfig, ip, port, 10000, password);
            } else {
                // redis 未设置密码
                pool = new JedisPool(jedisPoolConfig, ip, port, 10000);
            }
        }
    }

    /**
     * 获取指定key的值,如果key不存在返回null，如果该Key存储的不是字符串，会抛出一个错误
     *
     * @param key
     * @return
     */
    public String get(String key) {
        Jedis jedis = getJedis();
        String value = null;
        value = jedis.get(key);
        return value;
    }

    /**
     * 设置key的值为value
     *
     * @param key
     * @param value
     * @return
     */
    public String set(String key, String value) {
        Jedis jedis = getJedis();
        return jedis.set(key, value);
    }

    /**
     * 删除指定的key,也可以传入一个包含key的数组
     *
     * @param keys
     * @return
     */
    public Long del(String... keys) {
        Jedis jedis = getJedis();
        return jedis.del(keys);
    }

    /**
     * 通过key向指定的value值追加值
     *
     * @param key
     * @param str
     * @return
     */
    public Long append(String key, String str) {
        Jedis jedis = getJedis();
        return jedis.append(key, str);
    }

    /**
     * 判断key是否存在
     *
     * @param key
     * @return
     */
    public Boolean exists(String key) {
        Jedis jedis = getJedis();
        return jedis.exists(key);
    }

    /**
     * 设置key value,如果key已经存在则返回0
     *
     * @param key
     * @param value
     * @return
     */
    public Long setnx(String key, String value) {
        Jedis jedis = getJedis();
        return jedis.setnx(key, value);
    }

    /**
     * 设置key value并指定这个键值的有效期
     *
     * @param key
     * @param seconds
     * @param value
     * @return
     */
    public String setex(String key, int seconds, String value) {
        Jedis jedis = getJedis();
        return jedis.setex(key, seconds, value);
    }

    /**
     * 通过key 和offset 从指定的位置开始将原先value替换
     *
     * @param key
     * @param offset
     * @param str
     * @return
     */
    public Long setrange(String key, int offset, String str) {
        Jedis jedis = getJedis();
        return jedis.setrange(key, offset, str);
    }

    /**
     * 通过批量的key获取批量的value
     *
     * @param keys
     * @return
     */
    public List<String> mget(String... keys) {
        Jedis jedis = getJedis();
        return jedis.mget(keys);
    }

    /**
     * 批量的设置key:value,也可以一个
     *
     * @param keysValues
     * @return
     */
    public String mset(String... keysValues) {
        Jedis jedis = getJedis();
        return jedis.mset(keysValues);
    }

    /**
     * 批量的设置key:value,可以一个,如果key已经存在则会失败,操作会回滚
     *
     * @param keysValues
     * @return
     */
    public Long msetnx(String... keysValues) {
        Jedis jedis = getJedis();
        return jedis.msetnx(keysValues);
    }

    /**
     * 设置key的值,并返回一个旧值
     *
     * @param key
     * @param value
     * @return
     */
    public String getSet(String key, String value) {
        Jedis jedis = getJedis();
        return jedis.getSet(key, value);
    }

    /**
     * 通过下标 和key 获取指定下标位置的 value
     *
     * @param key
     * @param startOffset
     * @param endOffset
     * @return
     */
    public String getrange(String key, int startOffset, int endOffset) {
        Jedis jedis = getJedis();
        return jedis.getrange(key, startOffset, endOffset);
    }

    /**
     * 通过key 对value进行加值+1操作,当value不是int类型时会返回错误,当key不存在是则value为1
     *
     * @param key
     * @return
     */
    public Long incr(String key) {
        Jedis jedis = getJedis();
        return jedis.incr(key);
    }

    /**
     * 通过key给指定的value加值,如果key不存在,则这是value为该值
     *
     * @param key
     * @param integer
     * @return
     */
    public Long incrBy(String key, long integer) {
        Jedis jedis = getJedis();
        return jedis.incrBy(key, integer);
    }

    /**
     * 对key的值做减减操作,如果key不存在,则设置key为-1
     *
     * @param key
     * @return
     */
    public Long decr(String key) {
        Jedis jedis = getJedis();
        return jedis.decr(key);
    }

    /**
     * 减去指定的值
     *
     * @param key
     * @param integer
     * @return
     */
    public Long decrBy(String key, long integer) {
        Jedis jedis = getJedis();
        return jedis.decrBy(key, integer);
    }

    /**
     * 通过key获取value值的长度
     *
     * @param key
     * @return
     */
    public Long strLen(String key) {
        Jedis jedis = getJedis();
        return jedis.strlen(key);
    }

    /**
     * 通过key给field设置指定的值,如果key不存在则先创建,如果field已经存在,返回0
     *
     * @param key
     * @param field
     * @param value
     * @return
     */
    public Long hsetnx(String key, String field, String value) {
        Jedis jedis = getJedis();
        return jedis.hsetnx(key, field, value);
    }

    /**
     * 通过key给field设置指定的值,如果key不存在,则先创建
     *
     * @param key
     * @param field
     * @param value
     * @return
     */
    public Long hset(String key, String field, String value) {
        Jedis jedis = getJedis();
        return jedis.hset(key, field, value);
    }

    /**
     * 通过key同时设置 hash的多个field
     *
     * @param key
     * @param hash
     * @return
     */
    public String hmset(String key, Map<String, String> hash) {
        Jedis jedis = getJedis();
        return jedis.hmset(key, hash);
    }

    /**
     * 通过key 和 field 获取指定的 value
     *
     * @param key
     * @param failed
     * @return
     */
    public String hget(String key, String failed) {
        Jedis jedis = getJedis();
        return jedis.hget(key, failed);
    }

    /**
     * 设置key的超时时间为seconds
     *
     * @param key
     * @param seconds
     * @return
     */
    public Long expire(String key, int seconds) {
        Jedis jedis = getJedis();
        return jedis.expire(key, seconds);
    }

    /**
     * 通过key 和 fields 获取指定的value 如果没有对应的value则返回null
     *
     * @param key
     * @param fields 可以是 一个String 也可以是 String数组
     * @return
     */
    public List<String> hmget(String key, String... fields) {
        Jedis jedis = getJedis();
        return jedis.hmget(key, fields);
    }

    /**
     * 通过key给指定的field的value加上给定的值
     *
     * @param key
     * @param field
     * @param value
     * @return
     */
    public Long hincrby(String key, String field, Long value) {
        Jedis jedis = getJedis();
        return jedis.hincrBy(key, field, value);
    }

    /**
     * 通过key和field判断是否有指定的value存在
     *
     * @param key
     * @param field
     * @return
     */
    public Boolean hexists(String key, String field) {
        Jedis jedis = getJedis();
        return jedis.hexists(key, field);
    }

    /**
     * 通过key返回field的数量
     *
     * @param key
     * @return
     */
    public Long hlen(String key) {
        Jedis jedis = getJedis();
        return jedis.hlen(key);
    }

    /**
     * 通过key 删除指定的 field
     *
     * @param key
     * @param fields 可以是 一个 field 也可以是 一个数组
     * @return
     */
    public Long hdel(String key, String... fields) {
        Jedis jedis = getJedis();
        return jedis.hdel(key, fields);
    }

    /**
     * 通过key返回所有的field
     *
     * @param key
     * @return
     */
    public Set<String> hkeys(String key) {
        Jedis jedis = getJedis();
        return jedis.hkeys(key);
    }

    /**
     * 通过key返回所有和key有关的value
     *
     * @param key
     * @return
     */
    public List<String> hvals(String key) {
        Jedis jedis = getJedis();
        return jedis.hvals(key);
    }

    /**
     * 通过key获取所有的field和value
     *
     * @param key
     * @return
     */
    public Map<String, String> hgetall(String key) {
        Jedis jedis = getJedis();
        return jedis.hgetAll(key);
    }

    /**
     * 通过key向list头部添加字符串
     *
     * @param key
     * @param strs 可以是一个string 也可以是string数组
     * @return 返回list的value个数
     */
    public Long lpush(String key, String... strs) {
        Jedis jedis = getJedis();
        return jedis.lpush(key, strs);
    }

    /**
     * 通过key向list尾部添加字符串
     *
     * @param key
     * @param strs 可以是一个string 也可以是string数组
     * @return 返回list的value个数
     */
    public Long rpush(String key, String... strs) {
        Jedis jedis = getJedis();
        return jedis.rpush(key, strs);
    }

    /**
     * 通过key在list指定的位置之前或者之后 添加字符串元素
     *
     * @param key
     * @param where LIST_POSITION枚举类型
     * @param pivot list里面的value
     * @param value 添加的value
     * @return
     */
    public Long linsert(String key, BinaryClient.LIST_POSITION where,
                        String pivot, String value) {
        Jedis jedis = getJedis();
        return jedis.linsert(key, where, pivot, value);
    }

    /**
     * 通过key设置list指定下标位置的value
     * 如果下标超过list里面value的个数则报错
     *
     * @param key
     * @param index 从0开始
     * @param value
     * @return 成功返回OK
     */
    public String lset(String key, Long index, String value) {
        Jedis jedis = getJedis();
        return jedis.lset(key, index, value);
    }

    /**
     * 通过key从对应的list中删除指定的count个 和 value相同的元素
     *
     * @param key
     * @param count 当count为0时删除全部
     * @param value
     * @return 返回被删除的个数
     */
    public Long lrem(String key, long count, String value) {
        Jedis jedis = getJedis();
        return jedis.lrem(key, count, value);
    }

    /**
     * 通过key保留list中从strat下标开始到end下标结束的value值
     *
     * @param key
     * @param start
     * @param end
     * @return 成功返回OK
     */
    public String ltrim(String key, long start, long end) {
        Jedis jedis = getJedis();
        return jedis.ltrim(key, start, end);
    }

    /**
     * 通过key从list的头部删除一个value,并返回该value
     *
     * @param key
     * @return
     */
    public synchronized String lpop(String key) {

        Jedis jedis = getJedis();
        return jedis.lpop(key);
    }

    /**
     * 通过key从list尾部删除一个value,并返回该元素
     *
     * @param key
     * @return
     */
    synchronized public String rpop(String key) {
        Jedis jedis = getJedis();
        return jedis.rpop(key);
    }

    /**
     * 通过key从一个list的尾部删除一个value并添加到另一个list的头部,并返回该value
     * 如果第一个list为空或者不存在则返回null
     *
     * @param srckey
     * @param dstkey
     * @return
     */
    public String rpoplpush(String srckey, String dstkey) {
        Jedis jedis = getJedis();
        return jedis.rpoplpush(srckey, dstkey);
    }

    /**
     * 通过key获取list中指定下标位置的value
     *
     * @param key
     * @param index
     * @return 如果没有返回null
     */
    public String lindex(String key, long index) {
        Jedis jedis = getJedis();
        return jedis.lindex(key, index);
    }

    /**
     * 通过key返回list的长度
     *
     * @param key
     * @return
     */
    public Long llen(String key) {
        Jedis jedis = getJedis();
        return jedis.llen(key);
    }

    /**
     * 通过key获取list指定下标位置的value
     * 如果start 为 0 end 为 -1 则返回全部的list中的value
     *
     * @param key
     * @param start
     * @param end
     * @return
     */
    public List<String> lrange(String key, long start, long end) {
        Jedis jedis = getJedis();
        return jedis.lrange(key, start, end);
    }

    /**
     * 通过key向指定的set中添加value
     *
     * @param key
     * @param members 可以是一个String 也可以是一个String数组
     * @return 添加成功的个数
     */
    public Long sadd(String key, String... members) {
        Jedis jedis = getJedis();
        return jedis.sadd(key, members);
    }

    /**
     * 通过key删除set中对应的value值
     *
     * @param key
     * @param members 可以是一个String 也可以是一个String数组
     * @return 删除的个数
     */
    public Long srem(String key, String... members) {
        Jedis jedis = getJedis();
        return jedis.srem(key, members);
    }

    /**
     * 通过key随机删除一个set中的value并返回该值
     *
     * @param key
     * @return
     */
    public String spop(String key) {
        Jedis jedis = getJedis();
        return jedis.spop(key);
    }

    /**
     * 通过key获取set中的差集
     * 以第一个set为标准
     *
     * @param keys 可以 是一个string 则返回set中所有的value 也可以是string数组
     * @return
     */
    public Set<String> sdiff(String... keys) {
        Jedis jedis = getJedis();
        return jedis.sdiff(keys);
    }

    /**
     * 通过key获取set中的差集并存入到另一个key中
     * 以第一个set为标准
     *
     * @param dstkey 差集存入的key
     * @param keys   可以 是一个string 则返回set中所有的value 也可以是string数组
     * @return
     */
    public Long sdiffstore(String dstkey, String... keys) {
        Jedis jedis = getJedis();
        return jedis.sdiffstore(dstkey, keys);
    }

    /**
     * 通过key获取指定set中的交集
     *
     * @param keys 可以 是一个string 也可以是一个string数组
     * @return
     */
    public Set<String> sinter(String... keys) {
        Jedis jedis = getJedis();
        return jedis.sinter(keys);
    }

    /**
     * 通过key获取指定set中的交集 并将结果存入新的set中
     *
     * @param dstkey
     * @param keys   可以 是一个string 也可以是一个string数组
     * @return
     */
    public Long sinterstore(String dstkey, String... keys) {
        Jedis jedis = getJedis();
        return jedis.sinterstore(dstkey, keys);
    }

    /**
     * 通过key返回所有set的并集
     *
     * @param keys 可以 是一个string 也可以是一个string数组
     * @return
     */
    public Set<String> sunion(String... keys) {
        Jedis jedis = getJedis();
        return jedis.sunion(keys);
    }

    /**
     * 通过key返回所有set的并集,并存入到新的set中
     *
     * @param dstkey
     * @param keys   可以 是一个string 也可以是一个string数组
     * @return
     */
    public Long sunionstore(String dstkey, String... keys) {
        Jedis jedis = getJedis();
        return jedis.sunionstore(dstkey, keys);
    }

    /**
     * 通过key将set中的value移除并添加到第二个set中
     *
     * @param srckey 需要移除的
     * @param dstkey 添加的
     * @param member set中的value
     * @return
     */
    public Long smove(String srckey, String dstkey, String member) {
        Jedis jedis = getJedis();
        return jedis.smove(srckey, dstkey, member);
    }

    /**
     * 通过key获取set中value的个数
     *
     * @param key
     * @return
     */
    public Long scard(String key) {
        Jedis jedis = getJedis();
        return jedis.scard(key);
    }

    /**
     * 通过key判断value是否是set中的元素
     *
     * @param key
     * @param member
     * @return
     */
    public Boolean sismember(String key, String member) {
        Jedis jedis = getJedis();
        return jedis.sismember(key, member);
    }

    /**
     * 通过key获取set中随机的value,不删除元素
     *
     * @param key
     * @return
     */
    public String srandmember(String key) {
        Jedis jedis = getJedis();
        return jedis.srandmember(key);
    }

    /**
     * 通过key获取set中所有的value
     *
     * @param key
     * @return
     */
    public Set<String> smembers(String key) {
        Jedis jedis = getJedis();
        return jedis.smembers(key);
    }


    /**
     * 通过key向zset中添加value,score,其中score就是用来排序的
     * 如果该value已经存在则根据score更新元素
     *
     * @param key
     * @param score
     * @param member
     * @return
     */
    public Long zadd(String key, double score, String member) {
        Jedis jedis = getJedis();
        return jedis.zadd(key, score, member);
    }

    /**
     * 通过key删除在zset中指定的value
     *
     * @param key
     * @param members 可以 是一个string 也可以是一个string数组
     * @return
     */
    public Long zrem(String key, String... members) {
        Jedis jedis = getJedis();
        return jedis.zrem(key, members);
    }

    /**
     * 通过key增加该zset中value的score的值
     *
     * @param key
     * @param score
     * @param member
     * @return
     */
    public Double zincrby(String key, double score, String member) {
        Jedis jedis = getJedis();
        return jedis.zincrby(key, score, member);
    }

    /**
     * 通过key返回zset中value的排名
     * 下标从小到大排序
     *
     * @param key
     * @param member
     * @return
     */
    public Long zrank(String key, String member) {
        Jedis jedis = getJedis();
        return jedis.zrank(key, member);
    }

    /**
     * 通过key返回zset中value的排名
     * 下标从大到小排序
     *
     * @param key
     * @param member
     * @return
     */
    public Long zrevrank(String key, String member) {
        Jedis jedis = getJedis();
        return jedis.zrevrank(key, member);
    }

    /**
     * 通过key将获取score从start到end中zset的value
     * socre从大到小排序
     * 当start为0 end为-1时返回全部
     *
     * @param key
     * @param start
     * @param end
     * @return
     */
    public Set<String> zrevrange(String key, long start, long end) {
        Jedis jedis = getJedis();
        return jedis.zrevrange(key, start, end);
    }

    /**
     * 通过key返回指定score内zset中的value
     *
     * @param key
     * @param max
     * @param min
     * @return
     */
    public Set<String> zrangebyscore(String key, String max, String min) {
        Jedis jedis = getJedis();
        return jedis.zrevrangeByScore(key, max, min);
    }

    /**
     * 通过key返回指定score内zset中的value
     *
     * @param key
     * @param max
     * @param min
     * @return
     */
    public Set<String> zrangeByScore(String key, double max, double min) {
        Jedis jedis = getJedis();
        return jedis.zrevrangeByScore(key, max, min);
    }

    /**
     * 返回指定区间内zset中value的数量
     *
     * @param key
     * @param min
     * @param max
     * @return
     */
    public Long zcount(String key, String min, String max) {
        Jedis jedis = getJedis();
        return jedis.zcount(key, min, max);
    }

    /**
     * 通过key返回zset中的value个数
     *
     * @param key
     * @return
     */
    public Long zcard(String key) {
        Jedis jedis = getJedis();
        return jedis.zcard(key);
    }

    /**
     * 通过key获取zset中value的score值
     *
     * @param key
     * @param member
     * @return
     */
    public Double zscore(String key, String member) {
        Jedis jedis = getJedis();
        return jedis.zscore(key, member);
    }

    /**
     * 通过key删除给定区间内的元素
     *
     * @param key
     * @param start
     * @param end
     * @return
     */
    public Long zremrangeByRank(String key, long start, long end) {
        Jedis jedis = getJedis();
        return jedis.zremrangeByRank(key, start, end);
    }

    /**
     * 通过key删除指定score内的元素
     *
     * @param key
     * @param start
     * @param end
     * @return
     */
    public Long zremrangeByScore(String key, double start, double end) {
        Jedis jedis = getJedis();
        return jedis.zremrangeByScore(key, start, end);
    }

    /**
     * 返回满足pattern表达式的所有key
     * keys(*)
     * 返回所有的key
     *
     * @param pattern
     * @return
     */
    public Set<String> keys(String pattern) {
        Jedis jedis = getJedis();
        return jedis.keys(pattern);
    }

    /**
     * 通过key判断值得类型
     *
     * @param key
     * @return
     */
    public String type(String key) {
        Jedis jedis = getJedis();
        return jedis.type(key);
    }


    private void close(Jedis jedis) {
        if (jedis != null) {
            jedis.close();
        }
    }

    private Jedis getJedis() {
        return pool.getResource();
    }

    public static RedisUtil getRedisUtil() {
        return new RedisUtil();
    }

}
~~~

##### jedis的使用步骤

1. 导入jedis的jar包
2. 利用jedis的api方法操作redis数据库

##### jedis基本使用代码

```java
public class JedisTest01 {
	public static void main(String[] args) {
		// 1.创建连接redis对象Jedis
		Jedis jedis = new Jedis("localhost", 6379);

		// 2.写入数据到redis中
		jedis.set("name","mobai");

		// 3.读取数据
		String name = jedis.get("name");
		System.out.println("name = " + name); // name = mobai

		// 4.程序运行完毕关闭进程
		jedis.close();
	}
}
```

##### 小结

* jedis的作用是什么？

  使用java代码操作redis数据库

* jedis使用完成后注意什么？

  关闭

### 14.Jedis的使用2-使用jedis连接池优化

##### 疑问

* 每次使用Jedis操作redis服务器存储数据都需new Jedis（）连接对象，这样好不好？

  不好，应该使用连接池控制连接的数量，保证服务器的稳定性

##### 使用jedis连接池优化代码

```java
public static void main(String[] args) {
		// 1.从连接池获取jedis连接
		// 1.1创建配置对象
		JedisPoolConfig config = new JedisPoolConfig();
		// 设置最大连接数
		config.setMaxTotal(10);
		// 设置最大超时时间
		config.setMaxWaitMillis(30000);

		// 2.创建Jedis连接池对象
		JedisPool jedisPool = new JedisPool(config, "127.0.0.1", 6379);

		// 3.获取连接
		Jedis jedis = jedisPool.getResource();

		//	4.写入数据到redis中
		jedis.set("name", "mobai");

		// 5.读取数据
		String str = jedis.get("name");
		System.out.println("str = " + str);

		// 6.关闭连接
		jedis.close();
	}
```

##### 小结

* 连接池类是什么？

  JedisPool

* 一般都配置什么参数给连接池？

  最大连接数

  用户等待超时时间

  ### 15.Jedis的使用3-用工具类优化连接池操作

##### 疑问

* 每次操作redis都要new JedisPool（）连接池会造成代码冗余，并且将redis服务器地址写死在代码中不利于以后的修改，那么怎么办呢？

  使用工具类优化代码冗余

##### 代码结构

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-8/35.jpg)

##### jedis配置文件

~~~properties
# 最大连接数
maxTotal=10
# 最大超时时间
maxWaitMillis=30000
# 服务器地址
host=localhost
# 端口号
port=6379
~~~

##### 使用工具类优化连接池操作代码

```java
public class JedisUtil {
	// 注入JedisPool
	private static JedisPool jedisPool;

	static {
		//ResourceBundle专门用于解析properties配置文件的类，只要根据类路径下面的文件名就可以解析
		ResourceBundle resourceBundle = ResourceBundle.getBundle("jedis");
		int maxTotal = Integer.parseInt(resourceBundle.getString("maxTotal"));
		int maxWaitMillis = Integer.parseInt(resourceBundle.getString("maxWaitMillis"));
		String host = resourceBundle.getString("host");
		int port = Integer.parseInt(resourceBundle.getString("port"));

		// 1.创建配置对象
		JedisPoolConfig config = new JedisPoolConfig();
		config.setMaxTotal(maxTotal);
		config.setMaxWaitMillis(maxWaitMillis);

		// 2.创建连接池对象
		jedisPool = new JedisPool(config, host, port);
	}

	/**
	 * CreateTime: 2020/5/8 14:09
	 * Return:redis.clients.jedis.Jedis
	 * MethodName:[getJedis] && Param:[[]]
	 * 方法说明: 获取连接对象
	 */
	public static Jedis getJedis() {
		return jedisPool.getResource();
	}
}
```

##### 使用工具类测试代码

```java
public static void main(String[] args) {
		// 1.从工具类获取jedis连接
		Jedis jedis = JedisUtil.getJedis();
		//2.写入数据到redis中
		jedis.set("name", "mobai");

		//3.读取数据
		String name = jedis.get("name");
		System.out.println("name=" + name);

		//4.关闭连接对象
		jedis.close();//放回连接池
	}
```

##### 小结

* 使用工具类优化连接池操作有什么好处？

  解决代码的冗余
