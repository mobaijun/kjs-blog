---
title: 【WEB系列】使用StopWatch输出执行耗时
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 323943495
tags:
  - StopWatch
categories:
  - 后端
date: 2022-02-10 15:35:05
img:
coverImg:
password:
summary:
---

## 简介

有时候在做开发任务的时候需要记录某段代码块的执行时间，或者记录每个任务的执行时间。最简单的方法就是打印当前时间与执行完时间的差值，原始情况下, 我们通过`System.currentTimeMillis()` 相减计算某段代码的耗时，但是这样如果执行大量测试的话就很麻烦，并且不直观，如果想对执行的时间做进一步控制，则需要在程序中很多地方修改，目前 `spring-framework` 提供了一个 `StopWatch` 类可以做类似任务执行时间控制，也就是封装了一个对开始时间，结束时间的记录工具。

## 示例



### 统计输出总耗时

```java
package com.mobaijun;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.util.StopWatch;

@Slf4j
@SpringBootTest
class SpringBootStopWatchApplicationTests {

   /**
    * 每次统计前, start('可读标识'), 每次统计后 stop(), 最后 prettyPrint
    */
    @Test
    void contextLoads() throws InterruptedException {
        StopWatch sw = new StopWatch();
        sw.start();
        Thread.sleep(10000);
        sw.stop();
        System.out.println("sw = " + sw.getTotalTimeMillis());
    }
}
```

* 输出

~~~bash
sw = 10004
~~~

### 输出最后一个任务的耗时

```java
@Test
void test2() throws InterruptedException {
    StopWatch sw = new StopWatch();
    sw.start("A");
    Thread.sleep(10000);
    sw.stop();
    System.out.println("sw = " + sw.getLastTaskTimeMillis());
}
```

* 输出

~~~bash
sw = 10007
~~~

### 以优雅的格式打出所有任务的耗时以及占比

```java
@Test
void test3() throws InterruptedException {
    StopWatch sw = new StopWatch();
    sw.start("A");
    Thread.sleep(500);
    sw.stop();
    sw.start("B");
    Thread.sleep(300);
    sw.stop();
    sw.start("C");
    Thread.sleep(200);
    sw.stop();
    System.out.println("sw = " + sw.prettyPrint());
}
```

* 输出

~~~bash
sw = StopWatch '': running time = 1010674400 ns
---------------------------------------------
ns         %     Task name
---------------------------------------------
501484900  050%  A
301168000  030%  B
208021500  021%  C
~~~

### 序列服务输出耗时信息

```java
@Override
public long nextSeq(String name) {
    StopWatch watch = new StopWatch();
    watch.start("单序列获取总消耗");
    long sequence = generator.generateId(name);
    watch.stop();
    logger.info(watch.prettyPrint());
    return sequence;
}
```

## 其他

> 需要注意的是：一次 `start` 下面就要对应 `stop` 而不能是 `start`, 否则会报异常 `Can't start StopWatch: it's already running`

## 更多用法

> 不同的打印结果

~~~java
1. getTotalTimeSeconds()----------获取总耗时秒，同时也有获取毫秒的方法
2. prettyPrint()----------优雅的格式打印结果，表格形式
3. shortSummary()----------返回简短的总耗时描述
4. getTaskCount()----------返回统计时间任务的数量
5. getLastTaskInfo().getTaskName()----------返回最后一个任务TaskInfo对象的名称
~~~

1. 更多请查看官网[文档](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/util/StopWatch.html)

## 总结

以后统计代码执行效率建议大家都使用这个工具来进行输出，不需要在`starttime、endtime`再相减计算，用优雅的方式来完成这件事情。

## 参考链接

[使用StopWatch优雅的输出执行耗时 | 凝雨 - Yun | 快乐编程每一天 - Happy Coding Every Day](https://ningyu1.github.io/20190505/116-stop-watch.html)
