---
title: 【随笔】java.lang.ClassNotFoundException 异常解决及思路
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 2375159405
tags:
  - 异常
categories:
  - 随笔
date: 2022-11-09 14:15:46
img:
coverImg:
password:
summary:
---

## 异常场景

> 下午的时候，启动一个老模块，发现项目无法正常启动，报错信息如下：
>
> ~~~bash
> Caused by: java.lang.NoClassDefFoundError: io/swagger/v3/core/util/ObjectMapperFactory
> 	at java.base/java.lang.ClassLoader.defineClass1(Native Method)
> 	at java.base/java.lang.ClassLoader._jr$defineClass(ClassLoader.java:1016)
> 	at java.base/java.lang.ClassLoader.defineClass(ClassLoader.java:43016)
> 	at java.base/java.security.SecureClassLoader.defineClass(SecureClassLoader.java:174)
> 	at java.base/jdk.internal.loader.BuiltinClassLoader.defineClass(BuiltinClassLoader.java:800)
> 	at java.base/jdk.internal.loader.BuiltinClassLoader.findClassOnClassPathOrNull(BuiltinClassLoader.java:698)
> 	at java.base/jdk.internal.loader.BuiltinClassLoader.loadClassOrNull(BuiltinClassLoader.java:621)
> 	at java.base/jdk.internal.loader.BuiltinClassLoader.loadClass(BuiltinClassLoader.java:579)
> 	at java.base/jdk.internal.loader.ClassLoaders$AppClassLoader.loadClass(ClassLoaders.java:178)
> 	at java.base/java.lang.ClassLoader.loadClass(ClassLoader.java:521)
> 	at java.base/java.lang.Class.getDeclaredMethods0(Native Method)
> 	at java.base/java.lang.Class.privateGetDeclaredMethods(Class.java:3166)
> 	at java.base/java.lang.Class.getDeclaredMethods(Class.java:2309)
> 	at org.springframework.util.ReflectionUtils.getDeclaredMethods(ReflectionUtils.java:467)
> 	... 21 common frames omitted
> Caused by: java.lang.ClassNotFoundException: io.swagger.v3.core.util.ObjectMapperFactory
> 	at java.base/jdk.internal.loader.BuiltinClassLoader.loadClass(BuiltinClassLoader.java:581)
> 	at java.base/jdk.internal.loader.ClassLoaders$AppClassLoader.loadClass(ClassLoaders.java:178)
> 	at java.base/java.lang.ClassLoader.loadClass(ClassLoader.java:521)
> ~~~

`java.lang.ClassNotFoundException`: 类找不到异常

> 造成异常的常见原因：
>
> 1. 所需要的支持类库放错了模块，`Spring` 容器找不到这个类。
> 2. 使用了重复的依赖，且版本不一致。导致低版本的被优先使用。
> 3. 类名错了，一般是使用 `Class.forName` 的时候，手动指定了类名的情况。

而我这个属于第一种情况，全局唯一使用 `swagger` 相关的内容为 `mybatis-plus-spring-boot-starter`

~~~xml
<dependency>
    <groupId>com.mobaijun</groupId>
    <artifactId>mybatis-plus-spring-boot-starter</artifactId>
</dependency>
~~~

而 `mybatis-plus-spring-boot-starter` 依赖了一个基础对象模块，基础对象模块使用了 swagger 相关的依赖

依赖关系图如下，大致看一下就好

![](https://tencent.cos.mobaijun.com/img/blog/【随笔】java-lang-ClassNotFoundException-异常解决及思路/0.png)

`base-model-spring-boot-starter` 排除掉了一些无效依赖导致出现这个异常，那么找到这个类所在的包并添加依赖就可以了

添加如下依赖，刷新依赖包，重新启动项目，问题解决。

~~~xml
<dependency>
    <groupId>io.swagger.parser.v3</groupId>
    <artifactId>swagger-parser</artifactId>
</dependency>
~~~

