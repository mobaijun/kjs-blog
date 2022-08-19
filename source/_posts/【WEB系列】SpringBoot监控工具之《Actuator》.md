---
title: 【WEB系列】SpringBoot监控工具之《Actuator》
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 283491354
tags:
  - Actuator
categories:
  - SpringBoot
date: 2021-08-05 09:39:53
img:
coverImg:
password:
summary:
---

## 前言

有句话怎么说呢？学的越多，不知道的就越多，现在感觉学的越来越废了😭😭😭，不学又不行，最近一直在钻研 `SpringBoot `相关的内容，准备先写一些基础的案例代码，后续研究的更加透彻，写一些有内涵的刨析文章发表出来😁，下面开始吧！

## Actuator 简介

![](https://tencent.cos.mobaijun.com/article_with_pictures/20210818103724.png)

> Definition of Actuator
>
> An actuator is a manufacturing term that refers to a mechanical device for moving or controlling something. Actuators can generate a large amount of motion from a small change.【文字来自官网】
>
> 翻译：
>
> 执行器的定义
>
> 执行器是一个制造术语，指的是用于移动或控制某物的机械装置。执行器可以从一个小的变化中产生大量的运动。

在生产环境中，往往需要对系统实际运行的情况（例如`cpu、io、disk、db`、业务功能等指标）进行监控运维。在`SpringBoot`项目中`Actuator`模块提供了众多HTTP接口端点（`Endpoint`），来提供应用程序运行时的内部状态信息。

`Actuator `模块提供了一个监控和管理生产环境的模块，可以使用`http、jmx、ssh、telnet`等来管理和监控应用。包括应用的审计（`Auditing`）、健康（`health`）状态信息、数据采集（`metrics gathering`）统计等监控运维的功能。同时，提供了可以扩展 `Actuator`端点（`Endpoint`）自定义监控指标。这些指标都是以`JSON`接口数据的方式呈现。

> <font color="#dc143c">需要注意的是，SpringBoot 1.x 和 2.x 的 Actuator 监控设置差别很大，不仅提供的 endpoint 路径不一樣，连 application.properties 的配置也不一样，此处介绍的为 SpringBoot 2.5.3 版本 ，2.X版本看官网说明还提供了跨域支持和服务器监控，比如 Redis ，influxdb，具体可以查看官网信息</font>

## 使用 Spring Boot Actuator

如果要使用 `Spring Boot Actuator` 提供的监控功能，需要先加入相关的 `maven dependency`依赖

~~~xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.5.3</version>
    <relativePath/> <!-- lookup parent from repository -->
</parent>

<!-- actuator 依赖 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
<!-- WEB 依赖 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
~~~

只要加上了这个 `maven dependency`，`SpringBoot `在运行时就会自动开启`/actuator/health`和`/actuator/info`这两个 `endpoint`，然后就可以通过这两个 `endpoint `查看当前 `SpringBoot `应用程序的运行情况，例如自动化配置信息、创建的 `Spring beans` 以及一些环境属性等。

为了保证 `actuator `暴露的监控接口的安全性，需要添加安全控制的依赖`spring-boot-start-security`依赖，访问应用监控端点时，都需要输入验证信息。

~~~xml
<dependency>
    <!--Security 依赖 -->
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
~~~

`Security `依赖，我这里选择不加，本身自己项目中也是`Shiro`用的较多，对`security`不是很熟，这里就不进行安全管理，如果添加了`security`安全管理，只需要在配置文件配置用户名和密码就可以了，如下

~~~yaml
spring:
  security:
    user:
      name: admin
      password: 123456
~~~

`Actuator `其实还提供了更加多样化的 `endpoint `，让我们监控` SpringBoot Application`，但是因为安全因素，需要在配置文件另外去配置这些 `endpoint`，详细的配置方案下面介绍。

### Actuator 提供的所有 endpoint

> 我使用的是 SpringBoot 2.5.3 版本，[Spring Boot 官方文档](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)

`Spring Boot Actuator` 的关键特性是在应用程序里提供众多 `Web `接口，通过它们了解应用程序运行时的内部状况。`Actuator `提供了 13 个接口，可以分为三大类：配置接口、度量接口和其它接口，具体如下表所示。

| HTTP 方法 | 路径            | 描述                                                         |
| :-------- | :-------------- | :----------------------------------------------------------- |
| GET       | /auditevents    | 显示应用暴露的审计事件 (比如认证进入、订单失败)              |
| GET       | /beans          | 描述应用程序上下文里全部的 Bean，以及它们的关系              |
| GET       | /conditions     | 就是 1.0 的 /autoconfig ，提供一份自动配置生效的条件情况，记录哪些自动配置条件通过了，哪些没通过 |
| GET       | /configprops    | 描述配置属性(包含默认值)如何注入Bean                         |
| GET       | /env            | 获取全部环境属性                                             |
| GET       | /env/{name}     | 根据名称获取特定的环境属性值                                 |
| GET       | /flyway         | 提供一份 Flyway 数据库迁移信息                               |
| GET       | /liquidbase     | 显示Liquibase 数据库迁移的纤细信息                           |
| GET       | /health         | 报告应用程序的健康指标，这些值由 HealthIndicator 的实现类提供 |
| GET       | /heapdump       | dump 一份应用的 JVM 堆信息                                   |
| GET       | /httptrace      | 显示HTTP足迹，最近100个HTTP request/repsponse                |
| GET       | /info           | 获取应用程序的定制信息，这些信息由info打头的属性提供         |
| GET       | /logfile        | 返回log file中的内容(如果 logging.file 或者 logging.path 被设置) |
| GET       | /loggers        | 显示和修改配置的loggers                                      |
| GET       | /metrics        | 报告各种应用程序度量信息，比如内存用量和HTTP请求计数         |
| GET       | /metrics/{name} | 报告指定名称的应用程序度量值                                 |
| GET       | /scheduledtasks | 展示应用中的定时任务信息                                     |
| GET       | /sessions       | 如果我们使用了 Spring Session 展示应用中的 HTTP sessions 信息 |
| POST      | /shutdown       | 关闭应用程序，要求endpoints.shutdown.enabled设置为true       |
| GET       | /mappings       | 描述全部的 URI路径，以及它们和控制器(包含Actuator端点)的映射关系 |
| GET       | /threaddump     | 获取线程活动的快照                                           |

### 配置文件详解

* 修改配置文件

~~~yaml
management:
  endpoints:
    web:
      exposure:
        # 这里表示开启所有的 endpoints ，（不包含shutdown）
        include: '*' # 需要注意的是这里的*号必须要添加单引号，否则报错
        # 如下写法是开启指定的 endpoints 接口
        # include: beans,mappings,loggers
        # exclude 可以用来关闭某些指定的接口，exclude 通常会和 include 一起使用，先使用 include 开启所有，然后 exclude 某个接口
        exclude: beans
      # 配置自定义 /actuator 的路径,这样写的话，原本默认的/actuator/xxx路径，都会变成/mobaijun/xxx，可以用来防止被其他人猜到
      base-path: mobaijun
      # 2.X版本提供了跨域支持，使用 Spring MVC 或 Spring WebFlux，则可以配置 Actuator 的 Web 端点以支持此类场景。
      cors:
      	# 不了解跨域的可以访问我前段时间发表的文章：https://www.mobaijun.com/posts/2298002216.html
        allowed-origins: *
        allowed-methods: *
  # 如果要开启 /actuator/shutdown,额外添加如下配置
  endpoint:
    shutdown:
      enabled: true
~~~

启动 `Spring Boot `应用程序，如在 `IDEA `中开发，可以打开 `Terminal`，开启一个终端来进行测试，这样测试有个缺陷，就是 `JSON `数据无法格式化，乱糟糟堆砌在一起，也可以在浏览器进行测试， `chrome `浏览器下载个 `JSON Viewer` 就可以很直观的查看 `JSON `数据了。

~~~bash
# 控制台前面请添加 curl 参数,如下
$ curl http://localhost:8080/actuator
~~~

* 浏览器不需要加请求指令,请求内容如下：http://localhost:8080/actuator

~~~json
{
  "_links": {
    "self": {
      "href": "http://localhost:8080/actuator",
      "templated": false
    },
    "beans": {
      "href": "http://localhost:8080/actuator/beans",
      "templated": false
    },
    "caches-cache": {
      "href": "http://localhost:8080/actuator/caches/{cache}",
      "templated": true
    },
    "caches": {
      "href": "http://localhost:8080/actuator/caches",
      "templated": false
    },
    "health": {
      "href": "http://localhost:8080/actuator/health",
      "templated": false
    },
    "health-path": {
      "href": "http://localhost:8080/actuator/health/{*path}",
      "templated": true
    },
    "info": {
      "href": "http://localhost:8080/actuator/info",
      "templated": false
    },
    "conditions": {
      "href": "http://localhost:8080/actuator/conditions",
      "templated": false
    },
    "shutdown": {
      "href": "http://localhost:8080/actuator/shutdown",
      "templated": false
    },
    "configprops": {
      "href": "http://localhost:8080/actuator/configprops",
      "templated": false
    },
    "configprops-prefix": {
      "href": "http://localhost:8080/actuator/configprops/{prefix}",
      "templated": true
    },
    "env": {
      "href": "http://localhost:8080/actuator/env",
      "templated": false
    },
    "env-toMatch": {
      "href": "http://localhost:8080/actuator/env/{toMatch}",
      "templated": true
    },
    "loggers": {
      "href": "http://localhost:8080/actuator/loggers",
      "templated": false
    },
    "loggers-name": {
      "href": "http://localhost:8080/actuator/loggers/{name}",
      "templated": true
    },
    "heapdump": {
      "href": "http://localhost:8080/actuator/heapdump",
      "templated": false
    },
    "threaddump": {
      "href": "http://localhost:8080/actuator/threaddump",
      "templated": false
    },
    "metrics": {
      "href": "http://localhost:8080/actuator/metrics",
      "templated": false
    },
    "metrics-requiredMetricName": {
      "href": "http://localhost:8080/actuator/metrics/{requiredMetricName}",
      "templated": true
    },
    "scheduledtasks": {
      "href": "http://localhost:8080/actuator/scheduledtasks",
      "templated": false
    },
    "mappings": {
      "href": "http://localhost:8080/actuator/mappings",
      "templated": false
    }
  }
}
~~~

## 常用接口详解

### health

`health `主要用来检查应用的运行状态，这是使用最高频的一个监控点。通常使用此接口提醒我们应用实例的运行状态，以及应用不”健康“的原因，比如数据库连接、磁盘空间不够等。

默认情况下 `health `的状态是开放的，添加依赖后启动项目，

```bash
# 查看应用程序的状态
$ curl http://localhost:8080/actuator/health
{"status":"UP"}
```

默认情况下，最终的 `Spring Boot` 应用的状态是由 `HealthAggregator `汇总而成的，汇总的算法是：

- 1 设置状态码顺序：`setStatusOrder(Status.DOWN, Status.OUT_OF_SERVICE, Status.UP, Status.UNKNOWN);`。
- 2 过滤掉不能识别的状态码。
- 3 如果无任何状态码，整个 `Spring Boot` 应用的状态是 `UNKNOWN`。
- 4 将所有收集到的状态码按照 `1` 中的顺序排序。
- 5 返回有序状态码序列中的第一个状态码，作为整个 `Spring Boot` 应用的状态。

health 通过合并几个健康指数检查应用的健康情况。`Spring Boot Actuato`r 有几个预定义的健康指标比如`DataSourceHealthIndicator`, `DiskSpaceHealthIndicator`, `MongoHealthIndicator`, `RedisHealthIndicator`等，它使用这些健康指标作为健康检查的一部分。

举个例子，如果你的应用使用 `Redis`，`RedisHealthindicator` 将被当作检查的一部分；如果使用 `MongoDB`，那么`MongoHealthIndicator` 将被当作检查的一部分。

可以在配置文件中关闭特定的健康检查指标，比如关闭 `redis `的健康检查：

```properties
management.health.redise.enabled=false
```

默认，所有的这些健康指标被当作健康检查的一部分。

### info

`info `就是我们自己配置在配置文件中以 `info `开头的配置信息，比如我们在示例项目中的配置是：

```yaml
info:
  app:
    name: spring-boot-actuator
    version: 1.0.0
```

访问：`http://localhost:8080/actuator/info`返回部分信息如下：

```bash
$ curl http://localhost:8080/actuator/info
{"app":{"name":"spring-boot-actuator","version":"1.0.0"}}
```

### beans

根据示例就可以看出，展示了 `bean `的别名、类型、是否单例、类的地址、依赖等信息。

访问：`http://localhost:8080/actuator/beans`返回部分信息如下：

```json
"contexts": {
    "application": {
      "beans": {
        "endpointCachingOperationInvokerAdvisor": {
          "aliases": [
            
          ],
          "scope": "singleton",
          "type": "org.springframework.boot.actuate.endpoint.invoker.cache.CachingOperationInvokerAdvisor",
          "resource": "class path resource [org/springframework/boot/actuate/autoconfigure/endpoint/EndpointAutoConfiguration.class]",
          "dependencies": [
            "org.springframework.boot.actuate.autoconfigure.endpoint.EndpointAutoConfiguration",
            "environment"
          ]
        },
        "defaultServletHandlerMapping": {
          "aliases": [
            
          ],
          "scope": "singleton",
          "type": "org.springframework.web.servlet.HandlerMapping",
          "resource": "class path resource [org/springframework/boot/autoconfigure/web/servlet/WebMvcAutoConfiguration$EnableWebMvcConfiguration.class]",
          "dependencies": [
            "org.springframework.boot.autoconfigure.web.servlet.WebMvcAutoConfiguration$EnableWebMvcConfiguration"
          ]
        }
..............................................................................
```

### conditions

`Spring Boot` 的自动配置功能非常便利，但有时候也意味着出问题比较难找出具体的原因。使用 `conditions `可以在应用运行时查看代码了某个配置在什么条件下生效，或者某个自动配置为什么没有生效。

访问：`http://localhost:8080/actuator/conditions`返回部分信息如下：

```json
"contexts": {
    "application": {
      "positiveMatches": {
        "AuditEventsEndpointAutoConfiguration": [
          {
            "condition": "OnAvailableEndpointCondition",
            "message": "@ConditionalOnAvailableEndpoint no property management.endpoint.auditevents.enabled found so using endpoint default; @ConditionalOnAvailableEndpoint marked as exposed by a 'management.endpoints.jmx.exposure' property"
          }
        ],
        "BeansEndpointAutoConfiguration": [
          {
            "condition": "OnAvailableEndpointCondition",
            "message": "@ConditionalOnAvailableEndpoint no property management.endpoint.beans.enabled found so using endpoint default; @ConditionalOnAvailableEndpoint marked as exposed by a 'management.endpoints.jmx.exposure' property"
          }
        ]
..............................................................................
```

### heapdump

返回一个 `GZip `压缩的 `JVM `堆 `dump`

访问：`http://localhost:8080/actuator/heapdump`会自动生成一个 `Jvm `的堆文件 `heapdump`，我们可以使用 `JDK `自带的 `Jvm `监控工具 `VisualVM `打开此文件查看内存快照。点击装入快照，选择自动生成的`heapdump`，如下图：

![快照内存](https://tencent.cos.mobaijun.com/article_with_pictures/image-20210805144851548.png)

### shutdown

开启接口优雅关闭` Spring Boot `应用，要使用这个功能首先需要在配置文件中开启：

```properties
management.endpoint.shutdown.enabled=true
```

配置完成之后，启动示例项目，使用 `curl `模拟 `post `请求访问 `shutdown `接口。

> `shutdown `接口默认只支持 `post `请求。

```bash
$ curl -X POST "http://localhost:8080/actuator/shutdown"
{"message":"Shutting down, bye..."}
```

此时你会发现应用已经被关闭。

### mappings

描述全部的 `URI `路径，以及它们和控制器的映射关系

访问：`http://localhost:8080/actuator/mappings`返回部分信息如下：

```json
contexts": {
    "application": {
      "mappings": {
        "dispatcherServlets": {
          "dispatcherServlet": [
            {
              "handler": "Actuator web endpoint 'health'",
              "predicate": "{GET [/actuator/health], produces [application/vnd.spring-boot.actuator.v3+json || application/vnd.spring-boot.actuator.v2+json || application/json]}",
              "details": {
                "handlerMethod": {
                  "className": "org.springframework.boot.actuate.endpoint.web.servlet.AbstractWebMvcEndpointHandlerMapping.OperationHandler",
                  "name": "handle",
                  "descriptor": "(Ljavax/servlet/http/HttpServletRequest;Ljava/util/Map;)Ljava/lang/Object;"
                },
                "requestMappingConditions": {
                  "consumes": [
                    
                  ],
                  "headers": [
                    
                  ],
                  "methods": [
                    "GET"
                  ],
                  "params": [
                    
                  ],
                  "patterns": [
                    "/actuator/health"
                  ]
..............................................................................
```

### threaddump

`threaddump `接口会生成当前线程活动的快照。这个功能非常好，方便我们在日常定位问题的时候查看线程的情况。 主要展示了线程名、线程ID、线程的状态、是否等待锁资源等信息。

访问：`http://localhost:8080/actuator/threaddump`返回部分信息如下：

```json
threads": [
    {
      "threadName": "DestroyJavaVM",
      "threadId": 38,
      "blockedTime": -1,
      "blockedCount": 0,
      "waitedTime": -1,
      "waitedCount": 0,
      "lockName": null,
      "lockOwnerId": -1,
      "lockOwnerName": null,
      "inNative": false,
      "suspended": false,
      "threadState": "RUNNABLE",
      "stackTrace": [
        
      ],
      "lockedMonitors": [
        
      ],
      "lockedSynchronizers": [
        
      ],
      "lockInfo": null
    }
..............................................................................
```

生产出现问题的时候，可以通过应用的线程快照来检测应用正在执行的任务。

## 参考文章：

[Spring Boot Actuator: Production-ready Features](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)

[SpringBoot - 監控工具 Actuator](https://kucw.github.io/blog/2020/7/spring-actuator/)

[org.yaml.snakeyaml.scanner.ScannerException: while scanning an alias in 'reader', line 5, column 18: include: * - 谱写自己的人生 - 博客园](https://www.cnblogs.com/lfyu/p/12550638.html)