---
title: 【WEB系列】SpringBoot异步任务记录
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 4255110274
tags:
  - Async
categories:
  - SpringBoot
date: 2021-08-02 16:07:58
img:
coverImg:
password:
summary:
---

## 简介

> 突发奇想，就想玩一下异步任务，记得之前项目有个场景需要使用异步执行，但是异步调用没有成功，后来采用了多线程去执行，今天就系统的学习下异步执行任务。记录一下
>
> 有时候在项目中，当访问其他人的接口较慢或者做耗时任务时，不想程序一直卡在耗时任务上，想程序能够并行执行， 我们可以使用多线程来并行的处理任务，也可以使用 `spring` 提供的异步处理方式 `@Async` 。

在异步处理的方法上添加注解 `@Async` ，就会启动一个新的线程去执行。

1. `Spring` 通过任务执行器 `TaskExecutor` ，来实现多线程和并发编程，使用 `ThreadPoolTaskExecutor` 可实现一个基于线程池的 `TaskExecutor` ;

2. 异步需要在配置类上面加 `@EnableAsync`  来开启对异步任务的支持在需要异步执行的方法上面加 `@Async`  来声明这个方法是一个需要异步执行的方法;

3. 让配置类实现 `AsyncConfigurer` 接口，并重写 `getAsyncExecutor` 方法，并返回一个 `ThreasPoolTaskExecutor` ，就可以获取一个基于线程池的 `TaskExecutor` ;

4. `@Async` 用在方法上，表示这个方法是一个异步的方法，如果用在类上面，表明这个类中的所有方法都是异步的方法。

### 测试

* 新建 SpringBoot 项目，导入如下依赖

~~~xml
<!--SpringBoot版本-->
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.5.3</version>
    <relativePath/> <!-- lookup parent from repository -->
</parent>
<!--相关插件-->
<dependencies>
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

* 创建一个配置类，配置线程池参数

~~~java
package com.mobaijun.config;


import org.springframework.aop.interceptor.AsyncUncaughtExceptionHandler;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.AsyncConfigurer;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Executor;
import java.util.concurrent.ThreadPoolExecutor;

/**
 * Software：IntelliJ IDEA 2021.1.1 x64
 * Author: https://www.mobaijun.com
 * Date: 2021/8/2 11:07
 * ClassName:AsyncConfig
 * 类描述：异步配置类
 */
@Configuration
@EnableAsync // @EnableAsync：通过在配置类或者启动（Main）类上加@EnableAsync开启对异步方法的支持。
public class TaskExecutorConfig implements AsyncConfigurer {

    /**
     * 1.配置类实现AsyncConfigurer接口并重写getAsyncExcutor方法，并返回一个ThreadPoolTaskExevutor
     * 2.通过重写getAsyncExecutor方法，制定默认的任务执行由该方法产生
     * 3.这样我们就获得了一个基于线程池的TaskExecutor
     */

    /**
     * 设置ThreadPoolExecutor的核心池大小。
     */
    private static final int CORE_POOL_SIZE = 5;

    /**
     * 设置ThreadPoolExecutor的最大池大小。
     */
    private static final int MAX_POOL_SIZE = 20;

    /**
     * 设置ThreadPoolExecutor的BlockingQueue的容量。
     */
    private static final int QUEUE_CAPACITY = 10;
    /**
     * 线程前缀名称
     */
    private static final String THREAD_NAME_PREFIX = "task—";

    /**
     * 默认线程池配置执行器
     */
    @Bean
    public Executor getAsyncExecutor() {
        // 1.Spring 默认配置是核心线程数大小为1，最大线程容量大小不受限制，队列容量也不受限制。
        ThreadPoolTaskExecutor taskExecutor = new ThreadPoolTaskExecutor();
        // 2.核心线程数
        taskExecutor.setCorePoolSize(CORE_POOL_SIZE);
        // 3.最大线程数
        taskExecutor.setMaxPoolSize(MAX_POOL_SIZE);
        // 4.队列大小
        taskExecutor.setQueueCapacity(QUEUE_CAPACITY);
        // 5.线程前缀名称
        taskExecutor.setThreadNamePrefix(THREAD_NAME_PREFIX);
        // 6.当最大池已满时，此策略保证不会丢失任务请求，但是可能会影响应用程序整体性能。
        taskExecutor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        // 7.初始化线程池
        taskExecutor.initialize();
        return taskExecutor;
    }


    /**
     * 自定义任务执行器：在定义了多个任务执行器的情况下，可以使用@Async("getMineAsync")来设定
     */
    @Bean
    public Executor getMineAsync() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(CORE_POOL_SIZE - 4);
        executor.setMaxPoolSize(MAX_POOL_SIZE - 10);
        executor.setQueueCapacity(QUEUE_CAPACITY - 5);
        executor.setThreadNamePrefix(THREAD_NAME_PREFIX);
        // rejection-policy：当pool已经达到max size的时候，如何处理新任务
        // CALLER_RUNS：不在新线程中执行任务，而是有调用者所在的线程来执行
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        executor.initialize();
        return executor;
    }
}
~~~

* 编写一个伪实现类

~~~java
package com.mobaijun.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.AsyncResult;
import org.springframework.stereotype.Component;

import java.io.Serializable;
import java.util.concurrent.Future;

/**
 * Software：IntelliJ IDEA 2021.1.1 x64
 * Author: https://www.mobaijun.com
 * Date: 2021/8/2 17:00
 * ClassName:ArithmeticService
 * 类描述：操作计算 service 类：简单实现有关异步和同步两种计算方式的性能比较
 */
@Slf4j
@Component
public class ArithmeticService implements Serializable {

    /**
     * 休眠时间
     */
    public static final int DoTime = 5000;

    /**
     * 1.异步任务只需要在所需实现异步的方法上加上@Async注解， 并通过Future<E>来接受异步方法的处理结果
     * 2.通过@Async注解表明该方法是个异步方法，如果注解在类级别，则表明该类所有的方法都是异步方法
     */
    @Async
    public Future<Long> subByAsync() throws Exception {
        long start = System.currentTimeMillis();
        long sum = 0;
        Thread.sleep(DoTime);
        long end = System.currentTimeMillis();
        sum = end - start;
        log.info("\t 完成任务一");
        return new AsyncResult<>(sum);
    }

    /**
     * 仅使用异步注解的方式实现异步方法
     */
    @Async
    public void subByVoid() throws Exception {
        long start = System.currentTimeMillis();
        long sum = 0;
        Thread.sleep(DoTime);
        long end = System.currentTimeMillis();
        sum = end - start;
        log.info("\t 完成任务二   ");
        log.info("注解任务执行的时间是： " + sum + "（毫秒）");
    }

    /**
     * 使用同步计算的方式--同步调用
     */
    public long subBySync() throws Exception {
        long start = System.currentTimeMillis();
        long sum = 0;
        Thread.sleep(DoTime);
        long end = System.currentTimeMillis();
        sum = end - start;
        log.info("\t 完成任务三   ");
        return sum;
    }

    @Async("getMineAsync")
    public void doMineAsync(int i) throws Exception {
        System.out.println("------\t:" + i);
        Thread.sleep(10000);
    }
}
~~~

* web接口

~~~java
package com.mobaijun.controller;

import com.mobaijun.service.ArithmeticService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.concurrent.Future;

/**
 * Software：IntelliJ IDEA 2021.1.1 x64
 * Author: https://www.mobaijun.com
 * Date: 2021/8/2 17:06
 * ClassName:AsyncController
 * 类描述：
 */
@Slf4j
@RestController
public class AsyncController {

    @Autowired
    private ArithmeticService arithmeticService;

    @SuppressWarnings("static-access")
    @RequestMapping(value = {"/"}, method = RequestMethod.GET)
    public void index() {
        long start = System.currentTimeMillis();
        try {
            log.info("--------------------------------------------\n");
            log.info("每个任务执行的时间是：" + arithmeticService.DoTime + "（毫秒）");
            Future<Long> task = arithmeticService.subByAsync();
            arithmeticService.subByVoid();
            long sync = arithmeticService.subBySync();
            while (true) {
                if (task.isDone()) {
                    long async = task.get();
                    log.info("异步任务执行的时间是：" + async + "（毫秒）");
                    // log.info("注解任务执行的时间是： -- （毫秒）");
                    log.info("同步任务执行的时间是：" + sync + "（毫秒）");
                    break;
                }
            }
            log.info("--------------------------------------------\n");
        } catch (Exception e) {
            e.printStackTrace();
        }
        long end = System.currentTimeMillis();
        log.info("\t........请求响应时间为：" + (end - start) + "（毫秒）");
    }

    /**
     * 自定义实现线程异步
     */
    @RequestMapping(value = {"/mine", "/m*"}, method = RequestMethod.GET)
    public void mineAsync() {
        for (int i = 0; i < 100; i++) {
            try {
                arithmeticService.doMineAsync(i);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
~~~

* 接口一请求结果：http://localhost:8004/

~~~log
2021-08-02 17:23:45.047  INFO 14376 --- [nio-8004-exec-1] com.mobaijun.controller.AsyncController  : 每个任务执行的时间是：5000（毫秒）
2021-08-02 17:23:50.068  INFO 14376 --- [  thread-exec-1] com.mobaijun.service.ArithmeticService   : 	 完成任务一
2021-08-02 17:23:50.068  INFO 14376 --- [  thread-exec-2] com.mobaijun.service.ArithmeticService   : 	 完成任务二   
2021-08-02 17:23:50.068  INFO 14376 --- [nio-8004-exec-1] com.mobaijun.service.ArithmeticService   : 	 完成任务三   
2021-08-02 17:23:50.068  INFO 14376 --- [  thread-exec-2] com.mobaijun.service.ArithmeticService   : 注解任务执行的时间是： 5014（毫秒）
2021-08-02 17:23:50.068  INFO 14376 --- [nio-8004-exec-1] com.mobaijun.controller.AsyncController  : 异步任务执行的时间是：5014（毫秒）
2021-08-02 17:23:50.068  INFO 14376 --- [nio-8004-exec-1] com.mobaijun.controller.AsyncController  : 同步任务执行的时间是：5014（毫秒）
2021-08-02 17:23:50.069  INFO 14376 --- [nio-8004-exec-1] com.mobaijun.controller.AsyncController  : --------------------------------------------
~~~

* 接口二请求结果，截取部分内容：http://localhost:8004/mine

~~~log
------	:0
------	:6
------	:7
------	:8
------	:9
------	:10
------	:11
------	:12
------	:15
------	:13
------	:14
~~~