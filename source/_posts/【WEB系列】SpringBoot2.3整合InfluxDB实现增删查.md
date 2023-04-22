---
title: 【WEB系列】SpringBoot2.3整合InfluxDB实现增删查
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - InfluxDB
categories:
  - SpringBoot
abbrlink: 1092756891
date: 2021-01-20 14:15:02
img:
coverImg:
password:
summary:
---

## 概述:

InfluxDB是一个用于存储和分析时间序列数据的开源数据库。因为公司项目需求，记录一下使用过程

主要特性有：

* 内置HTTP接口，使用方便
* 数据可以打标记，这样查询可以很灵活
* 类SQL的查询语句
* 安装管理很简单，并且读写数据很高效
* 能够实时查询，数据在写入时被索引后就能够被立即查出

在最新的[DB-ENGINES](https://db-engines.com/en/ranking/time+series+dbms)给出的时间序列数据库的排名中，InfluxDB高居第一位，可以预见，InfluxDB会越来越得到广泛的使用。相关介绍可以看我之前写的一篇关于`InfluxDB`的文章及安装操作[InfluxDB传送门](https://www.mobaijun.com/posts/2901774056.html)

## SpringBoot整合Influx

> 这里使用的是SpringBoot 2.3.5.RELEASE，本地需要安装influxdb-1.8.3-1，接下来看看如何实现的。

![项目结构](https://tencent.cos.mobaijun.com/img/blog/【WEB系列】SpringBoot2.3整合InfluxDB实现增删查/0.png)

* pom依赖

~~~xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter</artifactId>
    </dependency>
    <!--influxdb依赖-->
    <dependency>
        <groupId>org.influxdb</groupId>
        <artifactId>influxdb-java</artifactId>
    </dependency>
    <!--工具类-->
    <dependency>
        <groupId>org.nutz</groupId>
        <artifactId>nutz</artifactId>
        <version>1.r.66</version>
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

* yml配置

~~~yaml
spring:
  influx:
    # 链接地址
    url: http://localhost:8086
    # 用户名
    user: admin
    # 密码
    password: mobaijun_admin
    # 数据库名称
    database: mobaijun
~~~

* 自定义注解/标识字段

~~~java
package com.mobai.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * @Author: MoBai·杰
 * Software：IntelliJ IDEA 2020.2.3 x64
 * Date: 2021-01-20 上午 9:09
 * ClassName:Tag
 * ClassDescribe：自定义注解，标识字段
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface Tag {
}
~~~

* 实体类

~~~java
package com.mobai.model.pojo;

import com.mobai.annotation.Tag;
import lombok.Data;
import org.influxdb.annotation.Measurement;

/**
 * @Author: MoBai·杰
 * Software：IntelliJ IDEA 2020.2.3 x64
 * Date: 2021-01-20 上午 9:31
 * ClassName:Location
 * ClassDescribe： 实体类
 */
@Data
// 表名
@Measurement(name = "ZJDYBTSE")
public class Location {

    /**
     * 时间
     */
    private String time;

    /**
     * 索引
     */
    @Tag
    private String belongId;

    /**
     * 地址
     */
    private String host;

    /**
     * 列名
     */
    private String ld;

    /**
     * 列名
     */
    private String ln;

    /**
     * 列名
     */
    private String max;

    /**
     * 列名
     */
    private String name;

    /**
     * 列名
     */
    private String st;

    /**
     * 值
     */
    private String value;
}
~~~

* influx配置参数

~~~java
package com.mobai.model.property;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * @Author: MoBai·杰
 * Software：IntelliJ IDEA 2020.2.3 x64
 * Date: 2021-01-20 上午 9:31
 * ClassName:InfluxProperty
 * ClassDescribe： 数据库
 */
@Data
@Component
@ConfigurationProperties(prefix = "spring.influx")
public class InfluxProperty {
    /**
     * 数据库名
     */
    private String dataBaseName;
}
~~~

* 反射工具类

~~~java
package com.mobai.utils;

import org.nutz.lang.Lang;

import java.lang.reflect.Field;

/**
 * @Author: MoBai·杰
 * Software：IntelliJ IDEA 2020.2.3 x64
 * Date: 2021-01-20 上午 9:32
 * ClassName:ReflectUtils
 * ClassDescribe： 反射工具类
 */
public class ReflectUtils {
    /**
     * 类中获取使用了某个注解的字段
     *
     * @param object
     * @param annotation
     */
    public static String getField(Object object, Class annotation) {
        Object first = Lang.first(object);
        Class clazz = first.getClass();
        Field[] fields = clazz.getDeclaredFields();
        for (Field field : fields) {
            field.setAccessible(true);
            Boolean isAnon = field.isAnnotationPresent(annotation);
            if (isAnon) {
                return field.getName();
            }
        }
        return null;
    }
}
~~~

* InfluxDao接口

~~~java
package com.mobai.dao;

import java.util.List;

/**
 * @Author: MoBai·杰
 * Software：IntelliJ IDEA 2020.2.3 x64
 * Date: 2021-01-20 上午 9:10
 * InterfaceName:influxDao
 * InterfaceDescribe： Dao接口
 */
public interface InfluxDao {
    /**
     * 测试连接是否正常
     *
     * @return
     */
    Boolean ping();

    /**
     * 创建数据库
     * 说明：方法参数没有指定时，默认使用配置文件中数据库名
     */
    void createDataBase(String... dataBaseName);

    /**
     * 删除数据库
     * 说明：方法参数没有指定时，默认使用配置文件中数据库名
     */
    void deleteDataBase(String... dataBaseName);

    /**
     * 插入数据
     * 支持：对象,集合(集合时对应实体类必须使用@Tag注解指定一个字段)
     *
     * @param object 数据
     */
    <T> void insert(T object);

    /**
     * 查询数据
     *
     * @param sql
     * @return
     */
    <T> List<T> query(Class<T> clazz, String sql);
}
~~~

* Dao实现

~~~java
package com.mobai.dao.impl;

import com.mobai.annotation.Tag;
import com.mobai.dao.InfluxDao;
import com.mobai.model.property.InfluxProperty;
import com.mobai.utils.ReflectUtils;
import lombok.extern.slf4j.Slf4j;
import org.influxdb.InfluxDB;
import org.influxdb.InfluxDB.ConsistencyLevel;
import org.influxdb.annotation.Measurement;
import org.influxdb.dto.BatchPoints;
import org.influxdb.dto.Point;
import org.influxdb.dto.Point.Builder;
import org.influxdb.dto.Pong;
import org.influxdb.dto.Query;
import org.influxdb.dto.QueryResult;
import org.influxdb.dto.QueryResult.Result;
import org.influxdb.dto.QueryResult.Series;
import org.nutz.json.Json;
import org.nutz.lang.Lang;
import org.springframework.beans.BeanWrapperImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author: MoBai·杰
 * Software：IntelliJ IDEA 2020.2.3 x64
 * Date: 2021-01-20 上午 9:30
 * ClassName:influxDaoImpl
 * ClassDescribe： Dao实现类
 */
@Slf4j
@Component
public class InfluxDaoImpl implements InfluxDao {
    @Autowired
    private InfluxDB influxDB;

    @Autowired
    private InfluxProperty influxProperty;

    @Override
    public Boolean ping() {
        boolean isConnected = false;
        Pong pong;
        try {
            pong = influxDB.ping();
            if (pong != null) {
                isConnected = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isConnected;
    }

    @Override
    public void createDataBase(String... dataBaseName) {
        if (dataBaseName.length > 0) {
            influxDB.createDatabase(dataBaseName[0]);
            return;
        }
        if (influxProperty.getDataBaseName() == null) {
            log.error("如参数不指定数据库名,配置文件 spring.influx.dataBaseName 必须指定");
            return;
        }
        influxDB.createDatabase(influxProperty.getDataBaseName());
    }

    @Override
    public void deleteDataBase(String... dataBaseName) {
        if (dataBaseName.length > 0) {
            influxDB.deleteDatabase(dataBaseName[0]);
            return;
        }
        if (influxProperty.getDataBaseName() == null) {
            log.error("如参数不指定数据库名,配置文件 spring.influx.dataBaseName 必须指定");
            return;
        }
        influxDB.deleteDatabase(influxProperty.getDataBaseName());
    }

    @Override
    public <T> void insert(T object) {
        // 构建一个Entity
        Object first = Lang.first(object);
        Class clazz = first.getClass();
        // 表名
        Boolean isAnnot = clazz.isAnnotationPresent(Measurement.class);
        if (!isAnnot) {
            log.error("插入的数据对应实体类需要@Measurement注解");
            return;
        }
        Measurement annotation = (Measurement) clazz.getAnnotation(Measurement.class);
        // 表名
        String measurement = annotation.name();
        Field[] arrfield = clazz.getDeclaredFields();
        // 数据长度
        int size = Lang.eleSize(object);
        String tagField = ReflectUtils.getField(object, Tag.class);
        if (tagField == null) {
            log.error("插入多条数据需对应实体类字段有@Tag注解");
            return;
        }
        BatchPoints batchPoints = BatchPoints
                .database(influxProperty.getDataBaseName())
                // 一致性
                .consistency(ConsistencyLevel.ALL)
                .build();
        for (int i = 0; i < size; i++) {
            Map<String, Object> map = new HashMap<>();
            Builder builder = Point.measurement(measurement);
            for (Field field : arrfield) {
                // 私有属性需要开启
                field.setAccessible(true);
                Object result = first;
                try {
                    if (size > 1) {
                        List objects = (List) (object);
                        result = objects.get(i);
                    }
                    if (field.getName().equals(tagField)) {
                        builder.tag(tagField, field.get(result).toString());
                    } else {
                        map.put(field.getName(), field.get(result));
                    }
                } catch (IllegalAccessException e) {
                    log.error("实体转换出错");
                    e.printStackTrace();
                }
            }
            builder.fields(map);
            batchPoints.point(builder.build());
        }
        influxDB.write(batchPoints);
    }

    @Override
    public <T> List<T> query(Class<T> clazz, String sql) {
        if (influxProperty.getDataBaseName() == null) {
            log.error("查询数据时配置文件 spring.influx.dataBaseName 必须指定");
            return null;
        }
        QueryResult results = influxDB.query(new Query(sql, influxProperty.getDataBaseName()));
        if (results != null) {
            if (results.getResults() == null) {
                return null;
            }
            List<Object> list = new ArrayList<>();

            for (Result result : results.getResults()) {
                List<Series> series = result.getSeries();
                if (series == null) {
                    list.add(null);
                    continue;
                }
                for (Series serie : series) {
                    List<List<Object>> values = serie.getValues();
                    List<String> columns = serie.getColumns();
                    // 构建Bean
                    list.addAll(getQueryData(clazz, columns, values));
                }
            }
            return Json.fromJsonAsList(clazz, Json.toJson(list));
        }
        return null;
    }

    /**
     * 自动转换对应Pojo
     *
     * @param values
     * @return
     */
    public <T> List<T> getQueryData(Class<T> clazz, List<String> columns, List<List<Object>> values) {
        List results = new ArrayList<>();
        for (List<Object> list : values) {
            BeanWrapperImpl bean = null;
            Object result = null;
            try {
                result = clazz.newInstance();
                bean = new BeanWrapperImpl(result);
            } catch (InstantiationException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
            for (int i = 0; i < list.size(); i++) {
                // 字段名
                String filedName = columns.get(i);
                if (filedName.equals("Tag")) {
                    continue;
                }
                try {
                    Field field = clazz.getDeclaredField(filedName);
                } catch (NoSuchFieldException e) {
                    continue;
                }
                // 值
                Object value = list.get(i);
                bean.setPropertyValue(filedName, value);
            }
            results.add(result);
        }
        return results;
    }
}
~~~

* 测试类

~~~java
package com.mobai;

import com.mobai.dao.InfluxDao;
import com.mobai.model.pojo.Location;
import lombok.extern.slf4j.Slf4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.nutz.json.Json;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.List;
import java.util.concurrent.TimeUnit;

@Slf4j
@RunWith(SpringRunner.class)
@SpringBootTest
public class SpringbootInfluxApplicationTests {

    @Autowired
    private InfluxDao influxDao;

    /**
     * 测试数据库连接是否成功
     */
    @Test
    public void ping() {
        if (influxDao.ping()) {
            log.info("连接成功");
        } else {
            log.info("连接失败");
        }
    }

    /**
     * 创建数据库
     */
    @Test
    public void create() {
        // 默认使用配置文件中数据库
        // influxDao.createDataBase();
        // 使用指定数据库
        influxDao.createDataBase("mobaijun");
    }

    /**
     * 删除数据库
     */
    @Test
    public void delete() {
        // 默认使用配置文件中数据库
        // influxDao.deleteDataBase();
        // 使用指定数据库
        influxDao.deleteDataBase("mobaijun");
    }

    /**
     * 插入数据
     */
    @Test
    public void insert() {
        // 插入单条数据
        Location location = new Location();
        String l = String.valueOf(TimeUnit.MILLISECONDS);
        location.setTime(l);
        location.setLd("mobaijun");
        location.setHost("127.0.0.1");
        location.setLn("ln");
        location.setName("墨白");
        location.setValue("0");
        influxDao.insert(location);
    }

    /**
     * 获取数据
     */
    @Test
    public void list() {
        String sql = "SELECT * FROM \"mobaijun\" WHERE time > now() - 5m limit 100";
        List<Location> locations = influxDao.query(Location.class, sql);
        if (locations == null) {
            log.info("暂无数据");
        }
        System.out.println("数据为：" + Json.toJson(locations));
    }
}
~~~

源码地址：[传送门](https://github.com/mobaijun/spring-boot-wikis/tree/master/spring-boot-influxdb)

以上就是完整项目代码，项目使用可能有所不同，按照项目需求修改即可！如有疑问，请在下方留言，或添加博主微信！
