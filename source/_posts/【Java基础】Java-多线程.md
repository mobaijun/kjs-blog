---
title: 【Java基础】Java-多线程
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - 多线程
categories:
  - 后端
abbrlink: 3237902709
date: 2021-01-06 18:56:42
img:
coverImg:
password:
summary:
---

## 多任务

>多任务处理是指用户可以在同一时间内运行多个应用程序,每个应用程序被称作一个任务.Linux、windows就是支持多任务的操作系统,比起单任务系统它的功能增强了许多。
>
>当多任务操作系统使用某种任务调度策略允许两个或更多进程并发共享一个处理器时，事实上处理器在某一时刻只会给一件任务提供服务。因为任务调度机制保证不同任务之间的切换速度十分迅速，因此给人多个任务同时运行的错觉。多任务系统中有3个功能单位：任务、进程和线程。
>
>> 现实生活中太多这样可以同时做多件事情的例子了,看起来是多个任务都在做,其实本质上我们的大脑在同一时间依旧只做了一件事情.

## 多线程

> 在计算机编程中，一个基本的概念就是同时对多个任务加以控制。许多程序设计问题都要求程序能够停下手头的工作，改为处理其他一些问题，再返回主进程。可以通过多种途径达到这个目的。最开始的时候，那些掌握机器低级语言的程序员编写一些“中断服务例程”，主进程的暂停是通过硬件级的中断实现的。尽管这是一种有用的方法，但编出的程序很难移植，由此造成了另一类的代价高昂问题。中断对那些实时性很强的任务来说是很有必要的。但对于其他许多问题，只要求将问题划分进入独立运行的程序片断中，使整个程序能更迅速地响应用户的请求

## 多进程

> Windows 应用程序中消息有两种送出途径；直接和排队。Windows或某些运行的应用程序可直接发布消息给窗口过程，或者，消息可送到消息列象连续不断轮询消息队列的OS中当前执行的每个进程都 事件驱动程序不是由事件的顺序来控制，而是由事件的发生来控，而事件的发生是随机的、不确定的,这就允许程序的用户用各种合理的顺序来安排程序的流程。

## Process与Thread

* 说起进程,就不得不说下程序,程序是指令和数据的有序集合,其本上没用任何运行的含义,是一个静态的概念
* 而进程则是执行程序的一次执行过程,它是一个动态的概念,是系统资源分配的单位
* 通常在一个进程中可以包含若干个线程,当然一个进程中至少有一个线程,不然没用存在的意义,线程是CPU调度和执行的单位

> 需要注意的是:很多多线程是模拟出来的,真正的多线程是指有多个CPU,即多核,如服务器,如果是模拟出来的多线程,即在一个CPU的情况下,在同一个时间点,CPU只能执行一个代码,因为切换的很快,所以就有同时执行的错觉.

## 三种多线程的创建方式

### 继承Thread类

* Thread class ========================>>>>继承Thread类

~~~java
public class ThreadTest extends Thread {
    @Override
    public void run() {
        // run方法
        for (int i = 0; i < 20; i++) {
            System.out.println("我在看代码++++++++++++");
        }
    }

    /**
     * 主线程
     *
     * @param args
     */
    public static void main(String[] args) {
        // 创建线程类
        ThreadTest test = new ThreadTest();
        // 调用start方法
        test.start();

        for (int i = 0; i < 20; i++) {
            System.out.println("我在学习多线程" + i);
        }
    }
}
~~~

![image-20200615103447585](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200615103449.png)

> 注意:线程开启不一定立即执行,由CPU调度执行

### Thread网图下载

> 注意:实现网图下载需要导入一个包
>
> ~~~xml
> <!-- https://mvnrepository.com/artifact/commons-io/commons-io -->
> <dependency>
> 	<groupId>commons-io</groupId>
> 	<artifactId>commons-io</artifactId>
> 	<version>2.6</version>
> </dependency>
> ~~~

~~~java
package com.mobai;

import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;
import java.net.URL;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/15 10:18
 * ClassName:ThreadTest
 * 类描述:多线程实现网图下载
 */
public class ThreadTest2 extends Thread {
    /**
     * 主方法
     *
     * @param args
     */
    public static void main(String[] args) {
        ThreadTest2 t1 = new ThreadTest2("https://www.mobaijun.com/medias/banner/0.jpg", "0.jpg");
        ThreadTest2 t2 = new ThreadTest2("https://www.mobaijun.com/medias/banner/1.jpg", "1.jpg");
        ThreadTest2 t3 = new ThreadTest2("https://www.mobaijun.com/medias/banner/2.jpg", "2.jpg");
        // 启动线程
        t1.start();
        t2.start();
        t3.start();
    }

    // 图片地址
    private String url;
    // 图片名称
    private String name;

    /**
     * 初始化构造方法
     *
     * @param url
     * @param name
     */
    public ThreadTest2(String url, String name) {
        this.url = url;
        this.name = name;
    }

    /**
     * run方法执行线程,执行图片下载
     */
    @Override
    public void run() {
        webDownloader downloader = new webDownloader();
        downloader.downloader(url, name);
        System.out.println("下载了文件名为" + name);
    }
}

// 下载器
class webDownloader {
    /**
     * 实现网图下载
     *
     * @param url
     * @param name
     */
    public void downloader(String url, String name) {
        try {
            /**
             * 调用工具类,创建一个url
             * FileUtils:import org.apache.commons.io.FileUtils;
             */
            FileUtils.copyURLToFile(new URL(url), new File(name));
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("IO异常,downloader方法出现异常");
        }
    }
}
~~~

### 实现Runnable接口

* Runnable接口========================>>>>实现Runnable接口

~~~java
/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/15 10:18
 * ClassName:ThreadTest
 * 类描述:多线程创建方式二:实现Runnable接口,重写Run方法
 */
public class ThreadTest3 implements Runnable {
    @Override
    public void run() {
        // run方法
        for (int i = 0; i < 200; i++) {
            System.out.println("我在看代码++++++++++++");
        }
    }

    /**
     * 主线程
     *
     * @param args
     */
    public static void main(String[] args) {
        // 创建线程类
        ThreadTest3 test3 = new ThreadTest3();
        // 调用start方法
        new Thread(test3).start();

        for (int i = 0; i < 1000; i++) {
            System.out.println("我在学习多线程" + i);
        }
    }
}
~~~

### Runnable接口网图下载

~~~java
public class RunnableTest2 implements Runnable {
    /**
     * 主方法
     *
     * @param args
     */
    public static void main(String[] args) {
        RunnableTest2 t1 = new RunnableTest2("https://www.mobaijun.com/medias/banner/0.jpg", "0.jpg");
        RunnableTest2 t2 = new RunnableTest2("https://www.mobaijun.com/medias/banner/1.jpg", "1.jpg");
        RunnableTest2 t3 = new RunnableTest2("https://www.mobaijun.com/medias/banner/2.jpg", "2.jpg");
        // 启动线程
        new Thread(t1).start();
        new Thread(t2).start();
        new Thread(t3).start();
    }

    // 图片地址
    private String url;
    // 图片名称
    private String name;

    /**
     * 初始化构造方法
     *
     * @param url
     * @param name
     */
    public RunnableTest2(String url, String name) {
        this.url = url;
        this.name = name;
    }

    /**
     * run方法执行线程,执行图片下载
     */
    @Override
    public void run() {
        webDownloader downloader = new webDownloader();
        downloader.downloader(url, name);
        System.out.println("下载了文件名为" + name);
    }
}

// 下载器
class webDownloader {
    /**
     * 实现网图下载
     *
     * @param url
     * @param name
     */
    public void downloader(String url, String name) {
        try {
            /**
             * 调用工具类,创建一个url
             * FileUtils:import org.apache.commons.io.FileUtils;
             */
            FileUtils.copyURLToFile(new URL(url), new File(name));
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("IO异常,downloader方法出现异常");
        }
    }
}
~~~

> 小结:
>
> * 继承Thread类
>
>   * 子类继承Thread类具备多线程能力
>   * 启动线程:子类对象.start()
>
>   > 不建议使用:避免Java单继承的缺陷
>
> * 实现Runnable接口
>
>   * 实现接口Runnable具有多线程能力
>   * 启动线程:传入目标对象 + Thread对象.start();
>
>   > 推荐使用:避免单继承局限性,灵活方便,方便同一个对象被多个线程使用

## 认识并发问题

~~~java
package com.mobai;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/15 11:34
 * ClassName:RunnableTest
 * 类描述： 实现Runnable接口搞定多线程买票
 */
public class RunnableTest implements Runnable {

    // 创建票总数
    private static Integer ticketNums = 10;

    /**
     * 执行线程
     */
    @Override
    public void run() {
        while (true) {
            // 如果票等于0就结束线程
            if (ticketNums <= 0) {
                break;
            }
            // 模拟延时
            try {
                Thread.sleep(200);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            // Thread.currentThread().getName() :获取当前线程名称
            System.out.println(Thread.currentThread().getName() + "------>>>拿到了第" + ticketNums-- + "票");
        }
    }

    /**
     * 创建主方法:
     * 多个线程操作同一个资源的时候会出现数据紊乱,
     * @param args
     */
    public static void main(String[] args) {
        RunnableTest test = new RunnableTest();
        new Thread(test, "小明").start();
        new Thread(test, "老师").start();
        new Thread(test, "黄牛党").start();
    }
}
~~~

> 注意:多个线程同时启动的时候会出现并发问题,数据紊乱,可能出现负数

## 多线程龟兔赛跑

![龟兔赛跑](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200615114639.png)

> * 首先需要定义赛道距离,然后要离终点越来越近
> * 判断比赛是否接受
> * 打印胜利者
> * 龟兔赛跑开始
> * 故事中乌龟是赢家,兔子中途睡觉了,所以要模拟兔子睡觉(延时)
> * 乌龟赢得比赛

~~~java
package com.mobai;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/15 11:51
 * ClassName:Race
 * 类描述： 模拟龟兔赛跑
 */
public class Race implements Runnable {
    /**
     * 执行程序
     *
     * @param args
     */
    public static void main(String[] args) {
        Race race = new Race();
        new Thread(race, "兔子").start();
        new Thread(race, "乌龟").start();
    }

    // 胜利者
    private static String winner;

    @Override
    public void run() {
        for (int i = 0; i <= 500; i++) {
            // 模拟兔子休息
            if (Thread.currentThread().getName().equals("兔子") && i % 10 == 0) {
                try {
                    Thread.sleep(10);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }

            // 判断比赛是否结束
            boolean flag = gameOver(i);
            if (flag) {
                // 如果flag为真,结束游戏
                break;
            }
            System.out.println(Thread.currentThread().getName() + "-------跑了" + i + "步");
        }
    }

    private boolean gameOver(int steps) {
        // 判断是否有胜利者
        if (winner != null) {
            // 存在胜利者
            return true;
        }
        {
            if (steps >= 500) {
                winner = Thread.currentThread().getName();
                System.out.println("winner is " + winner);
                return true;
            }
        }
        return false;
    }
}
~~~

## Callable接口

> Callable接口========================>>>> 实现Callable接口

* 实现Callable接口改造下载图片案例

> 实现Callable接口:
>
> * 实现Callable接口需要返回值类型
> * 重写call方法,需要抛异常
> * 创建目标对象
> * 创建执行服务:`ExecutorService ser = Executors.newFixedThreadPool(1)`
> * 提交执行:`Future<Boolean> result1 = ser.submit(t1)`
> * 获取结果:`Boolean r1 = result1.get()`
> * 关闭服务:`ser.shutdownNow();`

~~~java
package com.mobai.callable;

import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.concurrent.*;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/15 13:31
 * ClassName:TestCallable
 * 类描述：Callable的好处:
 *                  1.需要返回值
 *                  2.需要抛出异常
 */
public class TestCallable implements Callable<Boolean> {
    /**
     * 主方法
     *
     * @param args
     */
    public static void main(String[] args) throws ExecutionException, InterruptedException {
        TestCallable t1 = new TestCallable("https://www.mobaijun.com/medias/banner/0.jpg", "0.jpg");
        TestCallable t2 = new TestCallable("https://www.mobaijun.com/medias/banner/1.jpg", "1.jpg");
        TestCallable t3 = new TestCallable("https://www.mobaijun.com/medias/banner/2.jpg", "2.jpg");
        // 创建执行服务:
        ExecutorService ser = Executors.newFixedThreadPool(3);
        // 提交执行:
        Future<Boolean> r1 = ser.submit(t1);
        Future<Boolean> r2 = ser.submit(t2);
        Future<Boolean> r3 = ser.submit(t3);
        // 获取结果:
        Boolean rs1 = r1.get();
        System.out.println(rs1);
        Boolean rs2 = r2.get();
        System.out.println(rs2);
        Boolean rs3 = r3.get();
        System.out.println(rs3);
        // 关闭服务:
        ser.shutdownNow();
    }

    // 图片地址
    private String url;
    // 图片名称
    private String name;

    /**
     * 初始化构造方法
     *
     * @param url
     * @param name
     */
    public TestCallable(String url, String name) {
        this.url = url;
        this.name = name;
    }

    /**
     * run方法执行线程,执行图片下载
     */
    @Override
    public Boolean call() {
        webDownloader downloader = new webDownloader();
        downloader.downloader(url, name);
        System.out.println("下载了文件名为" + name);
        return true;
    }
}

// 下载器
class webDownloader {
    /**
     * 实现网图下载
     *
     * @param url
     * @param name
     */
    public void downloader(String url, String name) {
        try {
            /**
             * 调用工具类,创建一个url
             * FileUtils:import org.apache.commons.io.FileUtils;
             */
            FileUtils.copyURLToFile(new URL(url), new File(name));
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("IO异常,downloader方法出现异常");
        }
    }
}
~~~

## 静态代理模式

~~~java
package com.mobai;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/15 13:46
 * ClassName:weddingCompany
 * 类描述：代理模式
 */

interface Marry {
    // 结婚很开心
    void happyMarry();
}

/**
 * 结婚对象
 */
public class MoBai implements Marry {

    @Override
    public void happyMarry() {
        System.out.println("墨白要结婚了,会很开心");
    }
}

/**
 * 婚庆公司
 */
class WeddingCompany implements Marry {
    private Marry target;

    public WeddingCompany(Marry target) {
        this.target = target;
    }

    @Override
    public void happyMarry() {
        before();
        this.target.happyMarry();
        after();
    }

    // 前置方法
    private void before() {
        System.out.println("结婚之前迅速布置现场");
    }

    // 后置方法
    private void after() {
        System.out.println("结婚之后需要收尾款,痛苦");
    }

    /**
     * 主方法,启动程序
     *
     * @param args
     */
    public static void main(String[] args) {
        WeddingCompany weddingCompany = new WeddingCompany(new MoBai());
        weddingCompany.happyMarry();
    }
}
~~~

> 目标对象和代理对象都要实现同一个接口,`无接口不代理.......`

## Lambda表达式

![Lambda](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200615140344.png)

> * 希腊字母表中排序第十一位的字母，大写为Λ，英语名称为Lambda。
> * 避免匿名内部类定义过多
> * 其实质属于函数式编程概念
>
> **为什么要使用Lambda表达式**
>
> > * 避免匿名内部类定义过多
> >
> > * 可以让你的代码看起来很简洁
> >
> > * 去掉了一堆没用意义的代码,只留下核心逻辑
> >
> > * 理解Functional interface(函数式接口)式lambda表达式的关键
> >
> > * 函数式接口的定义
> >
> >   > * 任何接口,如果只有一个唯一的抽象方法,那么他就是一个函数式接口
> >   > * 对于函数式接口,可以通过lambda表达式来创建该接口的对象

* 简化内部类过多

~~~java
package com.mobai.lambda;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/15 14:11
 * ClassName:TestLambda
 * 类描述： 推导Lambda表达式
 */
public class TestLambda {

    /**
     * 4.静态内部类
     */
    static class Like2 implements ILike {
        @Override
        public void lambda() {
            System.out.println("i like lambda2");
        }
    }


    /**
     * 3.主程序
     *
     * @param args
     */
    public static void main(String[] args) {
        // 1.使用接口调用实现类
        ILike iLike = new Like();
        iLike.lambda();


        // 2.静态内部类
        iLike = new Like2();
        iLike.lambda();


        /**
         * 5.局部内部类
         */
        class Like3 implements ILike {
            @Override
            public void lambda() {
                System.out.println("i Like Lambda3");
            }
        }
        // 3.局部内部类
        iLike = new Like3();
        iLike.lambda();


        /**
         * 6.匿名内部类
         */
        iLike = new Like() {
            @Override
            public void lambda() {
                System.out.println("i Like Lambda4");
            }
        };
        iLike.lambda();

        /**
         * 使用lambda表达式简化语句
         */
        iLike = () -> {
            System.out.println("i Like Lambda5");
        };
        iLike.lambda();

    }
}

/**
 * 1.函数式接口
 * > 一个接口只有唯一一个抽象方法
 */
interface ILike {
    void lambda();
}

/**
 * 2.实现类
 */
class Like implements ILike {
    @Override
    public void lambda() {
        System.out.println("i Like Lambda1");
    }
}
~~~

* 结果

~~~vue
i Like Lambda1
i like lambda2
i Like Lambda3
i Like Lambda4
i Like Lambda5
~~~

* 简化Lambda表达式

~~~java
package com.mobai.lambda;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/15 14:11
 * ClassName:TestLambda
 * 类描述： 推导Lambda表达式
 * lambda表达式:只能有一行代码的情况下才能简化成为给一行代码,如果有多行,就用代码块包裹
 * 前提:接口必须为函数式接口(一个接口只有一个抽象方法)
 * 多个参数也可以去掉参数类型,必须加上括号(a,b,c)
 */
public class TestLambda2 {
    public static void main(String[] args) {
        /**
         *  1.lambda表达式简化
         */
        Love love = (int a) -> {
            System.out.println("i love you -->" + a);
        };
        love.love(520);

        /**
         *  2.lambda表达式简化,简化参数类型
         */
        love = (a) -> {
            System.out.println("i love you -->" + a);
        };
        love.love(520);

        /**
         * 3.lambda表达式简化,简化括号
         */
        love = a -> {
            System.out.println("i love you -->" + a);
        };
        love.love(521);

        /**
         * 4.lambda表达式简化,简化花括号
         */
        love = a -> System.out.println("i love you -->" + a);
        love.love(522);

    }
}

/**
 * 函数式接口
 */
interface Love {
    void love(int a);
}
~~~

* 结果

~~~vue
i love you -->520
i love you -->520
i love you -->521
i love you -->522
~~~

## 线程状态

### 概览

![线程状态](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200615145733.png)

> * 创建状态: 	new的时候,诞生
> * 启动线程: 	调用start()的时候
> * 就绪状态:	获取CPU资源
> * 运行状态:    等待用户输入线程/休眠等
> * 阻塞状态:    线程休眠等
> * 死亡状态:    线程自然执行完毕/外部干涉终止线程

### 详细图

![线程状态详细图](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200615150305.png)

* 线程状态常用方法

| 方法                               | 说明                                      |
| ---------------------------------- | ----------------------------------------- |
| **setPriority(int newPriority)**   | 更改线程优先级                            |
| **static void sleep(long millis)** | 在指定的毫秒数内让当前正在执行的线程休眠  |
| **void join()**                    | 等待该线程终止                            |
| **static void yield()**            | 暂停当前正在执行的线程对象,并执行其他线程 |
| **void interrupt()**               | 中断线程,不建议使用                       |
| **Boolean isAlive()**              | 测试线程是否处于活动状态                  |

### 线程停止

> * 不推荐使用JDK提供的`stop()`,`destroy()`,因为已经废弃
> * 推荐让线程自然停止
> * 建议使用标志位进行终止变量,但`flag = false`,则终止线程运行

~~~java
package com.mobai.stop;

/**
 * Software：IntelliJ IDEA 2020.1.2 x64
 * Author: MoBai·杰
 * Date: 2020/6/15 15:08
 * ClassName:TestStop
 * 类描述： 线程停止
 * 1.建议线程正常停止=========>>>利用次数,不建议死循环
 * 2.建议使用标志位=========>>>设置一个标志位(this.flag = false;)
 * 3.不要使用stop或者destroy等过时或JDK不建议使用的方法
 */
public class TestStop implements Runnable {
    // 定义一个标识位
    private static boolean flag = true;

    @Override
    public void run() {
        int i = 0;
        while (flag) {
            System.out.println("run.....==.....==.....Thread " + i++);
        }
    }

    /**
     * 设置一个公开的方法停止线程,转换标志位
     */
    public void stop() {
        this.flag = false;
    }

    public static void main(String[] args) {
        TestStop stop = new TestStop();
        // 启动线程
        new Thread(stop).start();
        for (int i = 0; i < 1000; i++) {
            System.out.println("main " + i);
            if (i == 900) {
                // 调用stop方法切换标志位,停止线程
                stop.stop();
                System.out.println("线程该停止了");
            }
        }
    }
}
~~~

### 线程休眠---sleep

> * sleep(时间)指定当前线程阻塞的毫秒值(1000ms = 1s)
> * sleep存在异常 INterrupdtedExcepdion
> * sleep时间达到后线程进入就绪状态
> * sleep可以模拟网络延时,倒计时等
> * 每个对象都有一个锁,sleep不会释放锁

* 模拟线程延时

~~~java
package com.mobai.stop;

import lombok.SneakyThrows;

/**
 * Software：IntelliJ IDEA 2020.1.2 x64
 * Author: MoBai·杰
 * Date: 2020/6/15 16:01
 * ClassName:TestSleep
 * 类描述：模拟网络延时,放大问题的发生性
 */
public class TestSleep implements Runnable {
    // 车票总数
    private static int ticketNums = 10;

    /**
     * 线程执行体
     * SneakyThrows:import lombok.SneakyThrows;
     * Lombok注解:大胆抛出已检查的异常，以前没有人抛出它们！
     */
    @SneakyThrows
    @Override
    public void run() {
        while (true) {
            Thread.sleep(200);
            if (ticketNums <= 0) {
                break;
            }
            System.out.println(Thread.currentThread().getName() + "===>>>拿到了第" + ticketNums-- + "票");
        }
    }

    /**
     * 主方法
     *
     * @param args
     */
    public static void main(String[] args) {
        TestSleep sleep = new TestSleep();
        new Thread(sleep, "小明").start();
        new Thread(sleep, "老师").start();
        new Thread(sleep, "黄牛").start();
    }
}
~~~

* 模拟倒计时

~~~java
package com.mobai.stop;

import lombok.SneakyThrows;

/**
 * Software：IntelliJ IDEA 2020.1.2 x64
 * Author: MoBai·杰
 * Date: 2020/6/15 16:01
 * ClassName:TestSleep
 * 类描述：模拟倒计时,放大问题的发生性
 */
public class TestSleep2 implements Runnable {

    // 倒计时时间
    private static int num = 10;

    public static void main(String[] args) {
        TestSleep2 sleep = new TestSleep2();
        new Thread(sleep).start();
    }

    // SneakyThrows扑获异常
    @SneakyThrows
    @Override
    public void run() {
        while (true) {
            // 每隔一秒暂停一次
            Thread.sleep(1000);
            // 控制台输出剩余时间
            System.out.println(num--);
            // num=0就结束线程
            if (num <= 0) {
                break;
            }

        }
    }
}
~~~

* 模拟从当前系统时间开始计时

~~~java
package com.mobai.state;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/15 21:41
 * ClassName:TestSleep
 * 类描述： 模拟计时
 */
public class TestSleep {
    // 设置从?开始计时
    private static int num = 10;

    public static void main(String[] args) throws InterruptedException {
        // 打印当前系统时间
        Date startDate = new Date(System.currentTimeMillis());
        while (true) {
            Thread.sleep(1000);
            System.out.println(new SimpleDateFormat("HH:mm:ss").format(startDate));
            // 更新当前系统时间
            startDate = new Date(System.currentTimeMillis());
        }

    }

    /**
     * 模拟倒计时
     */
    public static void tebDown() throws InterruptedException {
        while (true) {
            // 设置等待时间为1S
            Thread.sleep(1000);
            System.out.println(num--);
            // 判断num等于0结束线程
            if (num <= 0) {
                break;
            }
        }
    }
}
~~~

### 线程礼让

> * 礼让线程,让当前正在执行的线程暂停,但不阻塞
> * 将线程从运行状态转换为就绪状态
> * 让CPU重新调度,礼让不一定成功!!!!看CPU心情!!!!

~~~java
package com.mobai.state;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/15 21:53
 * ClassName:TestYield
 * 类描述： 测试礼让线程
 * > 礼让不一定成功/看CPU心情
 */
public class TestYield {
    public static void main(String[] args) {
        MyYield myYield = new MyYield();
        // 开启线程
        new Thread(myYield, "a").start();
        new Thread(myYield, "b").start();
    }
}

class MyYield implements Runnable {
    @Override
    public void run() {
        System.out.println(Thread.currentThread().getName() + "线程开始执行");
        // 开始礼让
        Thread.yield();
        System.out.println(Thread.currentThread().getName() + "线程停止执行");
    }
}
~~~

* 结果

~~~xml
a线程开始执行
b线程开始执行
a线程停止执行
b线程停止执行
~~~

### 线程强制执行-Join

> * Join合并线程,等待此线程执行完毕后,在执行其他线程(造成其它线程阻塞)
> * 可以想象成插队

* 测试join,模拟线程插队

~~~java
package com.mobai.state;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/15 22:02
 * ClassName:TestJoin
 * 类描述：测试join,模拟线程插队
 */
public class TestJoin implements Runnable {

    @Override
    public void run() {
        for (int i = 0; i < 500; i++) {
            System.out.println(" ===线程VIP来了=== ");
        }
    }

    /**
     * 主方法
     *
     * @param args
     */
    public static void main(String[] args) throws InterruptedException {
        TestJoin join = new TestJoin();
        Thread thread = new Thread();
        thread.start();

        for (int i = 0; i < 1000; i++) {
            if (i == 200) {
                // 插队
                thread.join();
            }
            System.out.println("main" + i);
        }
    }
}
~~~

### 观测线程状态

> * 线程状态:可以有已下状态
>
>   > * NEW
>   >   * 尚未启动的线程处于此状态
>   > * RUNNABLE
>   >   * 在Java虚拟机中执行的线程处于此状态
>   > * BLOCKED
>   >   * 被阻塞等待监视器锁定的线程处于此状态
>   > * WANITING
>   >   * 正在等待另一个线程执行特定动作的线程处于此状态
>   > * TIME-WAITING
>   >   * 正在等待另一个线程执行动作达到指定等待时间的线程处于此状态
>   > * TERMINATED
>   >   * 已退出的线程处于此状态
>   >
>   > > 一个线程可以在给定时间点处于一个状态,这些状态是不反应任何操做系统线程状态的虚拟机状态

~~~java
package com.mobai.state;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/15 22:16
 * ClassName:TestState
 * 类描述： 观察线程的状态
 */
public class TestState {
    public static void main(String[] args) throws InterruptedException {
        Thread thread = new Thread(() -> {
            for (int i = 0; i < 5; i++) {
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            System.out.println("///////////////");
        });

        // 观察线程状态
        Thread.State state = thread.getState();
        System.out.println("state = " + state); // NEW


        // 观察启动后
        thread.start();// 启动线程
        state = thread.getState();
        System.out.println("state = " + state);// RUN


        // 只要线程不停止,就一直输出状态
        while (state != Thread.State.TERMINATED) {
            Thread.sleep(100);
            state = thread.getState();// 更新线程状态
            System.out.println("state = " + state);// 输出状态
        }

        // 线程停止了以后不能运行了
        // Exception in thread "main" java.lang.IllegalThreadStateException
        thread.start();
    }
}
~~~

### 线程的优先级

> * Java提供一个线程调度器来监控程序中启动后进入就绪状态的所有线程,线程调度器按照优先级决定应该调度那个线程来执行
>
>   * 线程的优先级用数字表示:(范围从1~~10)
>
>     * Thread.MIN_PRIORITY = 1;
>     * Thread.MAX_PRIORITY= 10;
>     * Thread.NORM_PRIORITY = 5;
>
>   * 使用一下方法获取优先级
>
>     > * `gitPriority().setPriority(int xxx);`
>
>   > > 优先级的设定建议在state()启动之前
>   >
>   > 优先级低只是意味着获得调度的概率低,并不是优先级低就不会被调用了,这都是看CPU调度

* 线程优先级源码

~~~java
    /**
     * The minimum priority that a thread can have.
     */
    public final static int MIN_PRIORITY = 1;

   /**
     * The default priority that is assigned to a thread.
     */
    public final static int NORM_PRIORITY = 5;

    /**
     * The maximum priority that a thread can have.
     */
    public final static int MAX_PRIORITY = 10;
~~~

* 测试线程优先级

~~~java
package com.mobai.state;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/15 22:31
 * ClassName:TestPriority
 * 类描述： 测试线程优先级
 */
public class TestPriority {
    public static void main(String[] args) {
        System.out.println(Thread.currentThread().getName() + "==>" + Thread.currentThread().getPriority());

        MyPriority myPriority = new MyPriority();
        Thread t1 = new Thread(myPriority);
        Thread t2 = new Thread(myPriority);
        Thread t3 = new Thread(myPriority);
        Thread t4 = new Thread(myPriority);

        // 先设置优先级/在启动
        t1.start();

        t2.setPriority(1);
        t2.start();

        t3.setPriority(4);
        t3.start();

        //  public final static int MAX_PRIORITY = 10;
        t4.setPriority(Thread.MAX_PRIORITY);
        t4.start();
    }


}

class MyPriority implements Runnable {

    @Override
    public void run() {
        System.out.println(Thread.currentThread().getName() + "==>" + Thread.currentThread().getPriority());
    }
}
~~~

### 守护线程

> * 线程分为用户线程和守护线程
> * 虚拟机必须确保用户线程执行完毕
> * 虚拟机不用等待守护线程执行完毕
> * 如:后台记录操做日志,监控内存,垃圾回收等等............

* 测试守护线程

~~~java
package com.mobai.state;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/15 22:45
 * ClassName:TestDaemon
 * 类描述： 测试守护线程
 */
public class TestDaemon {
    public static void main(String[] args) {
        Dog dog = new Dog();
        MyYou you = new MyYou();

        // 创建线程
        Thread thread = new Thread(dog);
        // 默认值false/表示是用户线程,正常的线程都是用户线程
        thread.setDaemon(true);
        // Dog守护线程启动
        thread.start();
        // 用户线程启动
        new Thread(you).start();
    }
}

/**
 * 守护线程
 */
class Dog implements Runnable {
    @Override
    public void run() {
        while (true) {
            System.out.println("=========狗狗保护主人的安全==========");
        }
    }
}


/**
 * 我
 */
class MyYou implements Runnable {
    @Override
    public void run() {
        for (int i = 0; i < 36500; i++) {
            System.out.println("=========我的一生都是痛苦==========");
        }
        System.out.println("=======GoodBy!  World=======");
    }
}
~~~

### 线程同步

> * 多个线程操做同一个资源
>
> > 线程同步：即当有一个线程在对内存进行操作时，其他线程都不可以对这个内存地址进行操作，直到该线程完成操作， 其他线程才能对该内存地址进行操作，而其他线程又处于等待状态，实现线程同步的方法有很多，临界区对象就是其中一种。
> >
> > > 在一般情况下，创建一个线程是不能提高程序的执行效率的，所以要创建多个线程。但是多个线程同时运行的时候可能调用线程函数，在多个线程同时对同一个内存地址进行写入，由于CPU时间调度上的问题，写入数据会被多次的覆盖，所以就要使线程同步。
> > >
> > > * 同步就是协同步调，按预定的先后次序进行运行。如：你说完，我再说。
> > > * “同”字从字面上容易理解为一起动作
> > > * 其实不是，“同”字应是指协同、协助、互相配合。
> > >
> > > > 由于同一进程的多个线程共享同一块存储空间，在带来方便的同时,也带来了访问冲突问题，为了保证数据在方法中被访问时的正确性，在访问时加入锁机制 `synchronized `,当一个线程获得对象的排它锁，独占资源，其他线程必须等待， 使用后释放锁即可.存在以下问题：
> > > >
> > > > ♦ —个线程持有锁会导致其他所有需要此锁的线程挂起； 
> > > >
> > > > ♦ 在多线程竞争下，加锁，释放锁会导致比较多的上下文切换和调度延时，引起性能问题； 
> > > >
> > > > ♦ 如果一个优先级高的线程等待一个优先级低的线程释放锁会导致优先级倒 置，引起性能问题.

## 线程三大不安全案例

* 买票案例

~~~java
package com.mobai.syn;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/16 10:42
 * ClassName:UnsafeBuyTicket
 * 类描述：不安全的买票
 */
public class UnsafeBuyTicket {
    public static void main(String[] args) {
        BuyTicket station = new BuyTicket();

        new Thread(station, "小明").start();
        new Thread(station, "黄牛").start();
        new Thread(station, "老师").start();
    }
}

class BuyTicket implements Runnable {
    // 票
    private static int tickNumber = 10;

    // 外部停止方式
    boolean flag = true;

    @Override
    public void run() {
        // 买票
        while (flag) {
            try {
                buy();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    private void buy() throws InterruptedException {
        // 判断是否有票
        if (tickNumber <= 0) {
            return;
        }
        // 模拟延时
        Thread.sleep(100);
        // 买票
        System.out.println(Thread.currentThread().getName() + "拿到" + tickNumber--);
    }
}
~~~

* 银行取款案例

~~~java
package com.mobai.syn;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/16 10:53
 * ClassName:UnsafeBank
 * 类描述： 模拟银行取钱
 * 模拟两个人去银行取钱
 */
public class UnsafeBank {
    public static void main(String[] args) {
        // 账户
        Account account = new Account(1000, "结婚基金");
        // 取现
        Drawing myYou = new Drawing(account, 500, "你");
        Drawing girlfriends = new Drawing(account, 1000, "老婆");
        // 启动线程
        myYou.start();
        girlfriends.start();

    }
}

class Account {
    // 余额
    int money;
    // 卡号
    String name;

    public Account(int money, String name) {
        this.money = money;
        this.name = name;
    }
}

// 银行:模拟取款
class Drawing extends Thread {
    // 账户
    Account account;
    // 取了多少钱
    int drawingMoney;
    // 手里有多少钱
    int nowMoney;

    public Drawing(Account account, int drawingMoney, String name) {
        super(name);
        this.account = account;
        this.drawingMoney = drawingMoney;
    }

    @Override
    public void run() {
        // 判断是否有钱
        if (account.money - drawingMoney < 0) {
            System.out.println(Thread.currentThread().getName() + "钱不够,取不了");
            return;
        }
        /// sleep()可以放大问题的发生性
        try {
            // 模拟延时
            Thread.sleep(100);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        // 卡内余额 = 账户余额 - 取出的钱
        account.money = account.money - drawingMoney;
        // 手里的钱
        nowMoney = nowMoney + drawingMoney;
        // 余额为
        System.out.println(account.name + "余额为:" + account.money);
        // 手里的钱为  this.getName() === Thread.currentThread().getName()
        System.out.println(this.getName() + "手里的钱" + nowMoney);
    }
}
~~~

* 线程不安全集合

~~~java
package com.mobai.syn;

import java.util.ArrayList;
import java.util.List;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/16 11:16
 * ClassName:UnsafeList
 * 类描述： 线程不安全的集合
 */
public class UnsafeList {
    public static void main(String[] args) {
        List<String> list = new ArrayList<String>();
        for (int i = 0; i < 10000; i++) {
            new Thread(() -> {
                list.add(Thread.currentThread().getName());
            }).start();
        }
        // 延时放大问题的发生性
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println(list.size());
    }
}
~~~

## 同步方法和同步块

> * 由于我们可以通过 private关键字来保证数据对象只能被方法访问,所以我们只需要针对方法提出一套机制,这套机制就是 synchronized关键字,它包括两种用法`synchronized方法和 synchronized块`
>
>   * 同步方法: `public synchronized void method(int args)`
>
> * synchronized方法控制对对象”的访问,每个对象对应一把锁,每个
>   synchronized方法都必须获得调用该方法的对象的锁才能执行,否则线程会阻塞方法一-旦执行,就独占该锁,直到该方法返回才释放锁,后面被阻塞的线程才能获得这个锁,继续执行
>
>   * > `缺陷:若将一个大的方法申明为 Synchronized将会影响效率`

* 同步方法

~~~java
package com.mobai.syn;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/16 10:42
 * ClassName:UnsafeBuyTicket
 * 类描述：不安全的买票
 */
public class UnsafeBuyTicket {
    public static void main(String[] args) {
        BuyTicket station = new BuyTicket();

        new Thread(station, "小明").start();
        new Thread(station, "黄牛").start();
        new Thread(station, "老师").start();
    }
}

class BuyTicket implements Runnable {
    // 票
    private static int tickNumber = 10;

    // 外部停止方式
    boolean flag = true;

    @Override
    public void run() {
        // 买票
        while (flag) {
            try {
                buy();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * synchronized:同步方法
     * @throws InterruptedException
     */
    private synchronized void buy() throws InterruptedException {
        // 判断是否有票
        if (tickNumber <= 0) {
            return;
        }
        // 模拟延时
        Thread.sleep(100);
        // 买票
        System.out.println(Thread.currentThread().getName() + "拿到" + tickNumber--);
    }
}
~~~

![image-20200616113356744](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200616113357.png)

> > 同步块
>
> * 同步块:` synchronized(obj){}`
>   * Ob称之为同步监视器
>   * obj可以是任何对象,但是推荐使用共享资源作为同步监视器
>   * 同步方法中无需指定同步监视器,因为同步方法的同步监视器就是this,就是这个对象本身,或者是class
> * 同步监视器的执行过程
>   * 第一个线程访问,锁定同步监视器,执行其中代码
>   * 第二个线程访问,发现同步监视器被锁定,无法访问
>   * 第一个线程访问完毕,解锁同步监视器
>   * 第二个线程访问,发现同步监视器没有锁,然后锁定并访问

* 同步块

~~~java
package com.mobai.syn;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/16 10:53
 * ClassName:UnsafeBank
 * 类描述： 模拟银行取钱
 * 模拟两个人去银行取钱
 */
public class UnsafeBank {
    public static void main(String[] args) {
        // 账户
        Account account = new Account(1000, "结婚基金");
        // 取现
        Drawing myYou = new Drawing(account, 500, "你");
        Drawing girlfriends = new Drawing(account, 1000, "老婆");
        // 启动线程
        myYou.start();
        girlfriends.start();

    }
}

class Account {
    // 余额
    int money;
    // 卡号
    String name;

    public Account(int money, String name) {
        this.money = money;
        this.name = name;
    }
}

// 银行:模拟取款
class Drawing extends Thread {
    // 账户
    Account account;
    // 取了多少钱
    int drawingMoney;
    // 手里有多少钱
    int nowMoney;

    public Drawing(Account account, int drawingMoney, String name) {
        super(name);
        this.account = account;
        this.drawingMoney = drawingMoney;
    }

    @Override
    public void run() {
        // synchronized:锁的对象就是共享增删改的对象
        synchronized (account) {
            // 判断是否有钱
            if (account.money - drawingMoney < 0) {
                System.out.println(Thread.currentThread().getName() + "钱不够,取不了");
                return;
            }
            /// sleep()可以放大问题的发生性
            try {
                // 模拟延时
                Thread.sleep(100);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            // 卡内余额 = 账户余额 - 取出的钱
            account.money = account.money - drawingMoney;
            // 手里的钱
            nowMoney = nowMoney + drawingMoney;
            // 余额为
            System.out.println(account.name + "余额为:" + account.money);
            // 手里的钱为  this.getName() === Thread.currentThread().getName()
            System.out.println(this.getName() + "手里的钱" + nowMoney);
        }
    }
}
~~~

* 同步代码块-线程安全的集合

~~~java
package com.mobai.syn;

import java.util.ArrayList;
import java.util.List;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/16 11:16
 * ClassName:UnsafeList
 * 类描述： 线程不安全的集合
 */
public class UnsafeList {
    public static void main(String[] args) {
        List<String> list = new ArrayList<String>();
        for (int i = 0; i < 10000; i++) {
            new Thread(() -> {
                synchronized (list) {
                    list.add(Thread.currentThread().getName());
                }
            }).start();
        }
        // 延时放大问题的发生性
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println(list.size());
    }
}
~~~

## CopyOnWriteArrayList

> 可以不使用`synchronized`,达到集合安全的目的

~~~java
package com.mobai.syn;

import java.util.concurrent.CopyOnWriteArrayList;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/16 11:51
 * ClassName:TestJUC
 * 类描述： 测试JUC线程安全的集合
 */
public class TestJUC {
    public static void main(String[] args) {
        CopyOnWriteArrayList<String> list = new CopyOnWriteArrayList<String>();
        for (int i = 0; i < 10000; i++) {
            new Thread(() -> {
                list.add(Thread.currentThread().getName());
            }).start();
        }
        // 设置延时
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        // 打印长度
        System.out.println(list.size());
    }
}
~~~

## 线程锁

### 死锁

> 多个线程各自占有一些共享资源,并且互相等待其他线程占有的资源才能运行,导致两个或多个线程都在等在对方释放资源,都停止执行的情形,造成线程堵塞,某一个同步块同时拥有两个以上对象的锁,就有可能会发生死锁的问题;

* 测试代码

~~~java
package com.mobai.syn;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/16 12:08
 * ClassName:DeadLock
 * 类描述： 死锁:多个线程互相抱着对方需要的资源,形成僵持
 */
public class DeadLock {
    public static void main(String[] args) {
        Makeup g1 = new Makeup(0, "小美");
        Makeup g2 = new Makeup(1, "小丽");
        // 启动线程
        g1.start();
        g2.start();
    }
}

// 口红
class Lipstick {

}

// 镜子
class Mirror {

}

class Makeup extends Thread {

    // 需要的资源只有一份,用static来保证只有一份
    static Lipstick lipstick = new Lipstick();
    static Mirror mirror = new Mirror();

    // 定义一个人
    // 选择
    int choice;
    // 使用此化妆品的人
    String girName;

    public Makeup(int choice, String girName) {
        this.choice = choice;
        this.girName = girName;
    }

    @Override
    public void run() {
        try {
            makeup();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    // 化妆,互相持有对方的资源,就是需要拿到对方的资源
    private void makeup() throws InterruptedException {
        if (choice == 0) {
            synchronized (lipstick) {
                System.out.println(this.girName + "获得口红的锁");
                // 设置延时
                Thread.sleep(1000);
            }// 1秒后想要获得镜子
            synchronized (mirror) {
                System.out.println(this.girName + "获得镜子的锁");
            }

        } else {
            // 获得镜子的锁
            synchronized (mirror) {
                System.out.println(this.girName + "获得镜子的锁");
                // 设置延时
                Thread.sleep(2000);
            }
            synchronized (lipstick) {
                System.out.println(this.girName + "获得口红的锁");
            }
        }
    }
}
~~~

> 产生死锁的四个必要条件
>
> > * 互斥条件:一个资源每次只能没一个进程使用;
> > * 请求与保持条件:一个进程因为请求资源而阻塞,对以获得的资源保持不放;
> > * 不剥夺条件:进程以获得的资源,在未使用完之前,不能强行剥夺;
> > * 循环等待条件:若干进程之间形成一种头尾相接的循环等待资源关系;
> >
> > > 只需要想办法破其中的任意一个或多个条件就可以避免发生死锁

### Lock(锁)

> * 从DK50开始,Java提供了更强大的线程同步机制-----通过显式定义同步锁对象来实现同步。同步锁使用Lock对象充当
> * java util. concurrent locks.Lock接口是控制多个线程对共享资源进行访问的工具。
>   锁提供了对共享资源的独占访问,每次只能有一个线程对Lock对象加锁,线程开始访问共享资源之前应先获得Lok对象
> * ReentrantLock类实现了Lock,它拥有与 synchronized相同的并发性和内存语义,在实现线程安全的控制中,比较常用的是Reentrantlock,可以显式加锁、释放锁;

* 倒计时测试代码

~~~java
package com.mobai.gaoji;

import java.util.concurrent.locks.ReentrantLock;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/16 12:41
 * ClassName:TestLock
 * 类描述：
 */
public class TestLock {
    public static void main(String[] args) {
        TestLock2 lock = new TestLock2();
        // 启动线程
        new Thread(lock).start();
        new Thread(lock).start();
        new Thread(lock).start();
    }
}

class TestLock2 implements Runnable {
    private static int number = 10;

    // 定义lock锁
    private final ReentrantLock lock = new ReentrantLock();

    @Override
    public void run() {
        while (true) {
            try {
                // 加锁
                lock.lock();
                if (number > 0) {
                    try {
                        Thread.sleep(100);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                } else {
                    break;
                }
            } finally {
                // 解锁
                lock.unlock();
            }
        }
    }
}
~~~

> > synchronized与Lock的对比
>
> * Lock是显式锁(手动开启和关闭锁,别忘记关闭锁) synchronized是隐式锁,出了作用域自动释放
> * Lock只有代码块锁, synchronized有代码块锁和方法锁
> * 使用Lock锁,JVM将花费较少的时间来调度线程,性能更好。并且具有更好的扩展性(提供更多的子类)
>
> > 优先使用顺序:
> >
> > * Lock---=>同步代码块(已经进入了方法体,分配了相应资源) ---=>同步方法(在方
> >   法体之外)

## 线程协作

### 生产消费模式

> > 线程通信
>
> * 应用场景:生产者和消费者问题
>   * 假设仓库中只能存放一件产品,生产者将生产出来的产品放入仓库,消费者将
>     仓库中产品取走消费
>   * 如果仓库中没有产品,则生产者将产品放入仓库,否则停止生产并等待,直到
>     仓库中的产品被消费者取走为止
>   * 如果仓库中放有产品,则消费者可以将产品取走消费,否则停止消费并等待
>     直到仓库中再次放入产品为止
>
> ![生产消费模式](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200616125943.png)

### 线程通信分析

> > **线程通信-分析**
>
> * 这是一个线程同步问题,生产者和消费者共享同一个资源,并且生产者和消费者之
>   间相互依赖,互为条件
>   * 对于生产者,没有生产产品之前,要通知消费者等待.而生产了产品之后,又需要马上通知消费者消费
>   * 对于消费者,在消费之后,要通知生产者已经结束消费,需要生产新的产品以供消费
>   * 在生产者消费者问题中,仅有`synchronized`是不够的
>     * `synchronized`可阻止并发更新同一个共享资源,实现了同步 
>     * `synchronized`不能用来实现不同线程之间的消息传递(通信)

* Java提供了几个方法解决线程之间的通信问题

| 方法名称           | 作用                                                         |
| ------------------ | ------------------------------------------------------------ |
| wait()             | 表示线程会一直等待,知道其他线程通知,与sleeo()不同,会释放锁   |
| wait(long timeout) | 指定等待的毫秒数                                             |
| notify()           | 唤醒一个处于等待状态的线程                                   |
| notifyAll()        | 唤醒同一个对象上所有调用wait()方法的线程,优先级别高的线程优先调度 |

> 需要注意的是:这些都是Object类的方法,都只能在同步方法或者同步代码块中使用,否则会抛出异常`lllegaMonitorStateExcepoion`

### 解决方式

> > **并发协作模型“生产者/消费者模式”-->管程法**
>
> * 生产者:负责生产数据的模块(可能是方法,对象,线程,进程)
> * 消费者:负责处理数据的模块(可能是方法,对象,线程,进程)
> * 缓冲区:消费者不能直接使用生产者的数据,他们之间有个“缓冲区
>
> > 生产者将生产好的数据放入缓冲区,消费者从缓冲区拿出数据

### 管程法

* 测试代码

~~~java
package com.mobai.gaoji;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/16 13:17
 * ClassName:TestPC
 * 类描述: 生产消费者模式-------->利用缓冲区解决:管程法
 */
public class TestPC {
    public static void main(String[] args) {
        SynContainer container = new SynContainer();
        new Productor(container).start();
        new Consumer(container).start();
    }
}

// 生产者
class Productor extends Thread {

    SynContainer container;

    public Productor(SynContainer container) {
        this.container = container;
    }

    // 生产
    @Override
    public void run() {
        for (int i = 0; i < 100; i++) {
            container.push(new Chicken(i));
            System.out.println("生产了" + i + "鸡");
        }
    }
}

// 消费者
class Consumer extends Thread {
    SynContainer container;

    public Consumer(SynContainer container) {
        this.container = container;
    }

    // 消费
    @Override
    public void run() {
        for (int i = 0; i < 100; i++) {
            System.out.println("消费了--->" + container.pop().id + "只鸡");
        }
    }
}

// 产品
class Chicken {
    // 产品编号
    int id;

    public Chicken(int id) {
        this.id = id;
    }
}

// 缓冲区
class SynContainer {
    // 需要一个容器大小
    Chicken[] chickens = new Chicken[10];

    // 容器计数器
    int count = 0;

    // 生产者放入产品
    public synchronized void push(Chicken chicken) {
        // 如果容器满了,就需要等待消费者消费
        if (count == chickens.length) {
            // 通知消费者消费,生产者等待
            try {
                this.wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        // 如果没有满,就需要我们放入产品
        chickens[count] = chicken;
        count++;
        // 可以通知消费者消费了
        this.notifyAll();
    }

    // 消费者消费产品
    public synchronized Chicken pop() {
        // 判断是否可以消费
        if (count == 0) {
            // 等待生产者生产,消费者等待
            try {
                this.wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        // 如果可以消费
        count--;
        Chicken chicken = chickens[count];
        this.notifyAll();
        // 通知生产者生产
        return chicken;
    }

}
~~~

### 信号灯法

> 并发写作模型"生产者/消费者模式"====>>>>信号灯法

~~~java
package com.mobai.gaoji;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/16 14:12
 * ClassName:TestPc2
 * 类描述： 测试生产者消费者问题2:信号灯法,标志位解决
 */
public class TestPc2 {
    public static void main(String[] args) {
        TV tv = new TV();
        // 生产者
        new Player(tv).start();
        // 消费者
        new Watcher(tv).start();
    }
}

// 生产者====>演员
class Player extends Thread {
    TV tv;

    public Player(TV tv) {
        this.tv = tv;
    }

    @Override
    public void run() {
        for (int i = 0; i < 20; i++) {
            if (i % 2 == 0) {
                this.tv.play("快乐大本营播放中");
            } else {
                this.tv.play("抖音:记录美好生活");
            }
        }
    }
}


// 消费者=====>观众
class Watcher extends Thread {
    TV tv;

    public Watcher(TV tv) {
        this.tv = tv;
    }

    @Override
    public void run() {
        for (int i = 0; i < 20; i++) {
            tv.watch();
        }
    }
}


// 产品=====>电视剧节目
class TV {
    // 演员表演,观众等待
    String voice; // 表演的节目
    boolean flag = true;

    // 生产者表演
    public synchronized void play(String voice) {
        if (!flag) {
            try {
                this.wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        System.out.println("演员表演了:" + voice);
        // 唤醒
        this.notifyAll();
        // 生产完毕通知观众观看
        this.voice = voice;
        // 取反
        this.flag = !this.flag;
    }

    // 消费者观看
    public synchronized void watch() {
        if (flag) {
            try {
                this.wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        System.out.println("观众观看了:" + voice);
        // 通知演员表演
        this.notifyAll();
        this.flag = !this.flag;
    }
}
~~~

### 线程池

> * 使用线程池
>
> > * 背景:经常创建和销毁、使用量特别大的资源,比如并发情况下的线程,对性能影响很大
> > * 思路:提前创建好多个线程,放入线程池中,使用时直接获取,使用完放回池中可以避免频繁创建销毁、实现重复利用。类似生活中的公共交通T具
> >   * 好处
> >     * 提高响应速度(减少了创建新线程的时间)
> >     * 降低资源消耗(重复利用线程池中线程,不需要每次都创建)
> >     * 便于线程管理(…)
> >       * corePoolSize:核心池的大小
> >       * maximumoolSize:最大线程数
> >       * keepAliveTime:线程没有任务时最多保持多长时间后会终止
>
> * 使用线程池
>
>   * JDK5起提供了线程地相关API: **ExecutorService和Executors**
>
>   *  **ExecutorService**:真正的线程池接口。常见子类 **ThreadPoolExecutor**
>
>   * void execute( Runnable command):执行任务/命令,没有返回值,一般用来执行Runnable
>
>     * <T> Future<T> submit( Callable<T> task):执行任务,有返回值,一般用来执行Callable
>     * **void shutdown():**关闭连接池
>
>     > **Executors:工具类、线程池的工厂类,用于创建并返回不同类型的线程池**

* 测试线程池

~~~java
package com.mobai.gaoji;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/16 13:54
 * ClassName:TestThreadPool
 * 类描述： 测试线程池
 */
public class TestThreadPool {

    public static void main(String[] args) {
        /**
         * 创建服务:创建线程池
         * newFixedThreadPool:线程池大小
         */
        ExecutorService service = Executors.newFixedThreadPool(10);

        // 执行
        service.execute(new MyThread());
        service.execute(new MyThread());
        service.execute(new MyThread());
        service.execute(new MyThread());

        // 关闭链接
        service.shutdown();
    }
}

class MyThread implements Runnable {
    @Override
    public void run() {
        System.out.println(Thread.currentThread().getName());
    }
}
~~~

## 总结

~~~java
package com.mobai.gaoji;

import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.FutureTask;

/**
 * Software：IntelliJ IDEA 2018.2.4 x64
 * Author: MoBai·杰
 * Date: 2020/6/16 14:00
 * ClassName:ThreadNew
 * 类描述： 总结
 */
public class ThreadNew {
    public static void main(String[] args) {

        // 1.继承Thread
        new MyThread1().start();
        // 2.实现Runnable接口
        new Thread(new TestRunnable()).start();
        // 3.实现Callable接口
        FutureTask<Integer> task = new FutureTask<Integer>(new TestCallable());
        new Thread(task).start();

        // 打印返回值
        try {
            Integer integer = task.get();
            System.out.println("integer = " + integer);
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
    }
}

// 继承Thread
class MyThread1 extends Thread {
    @Override
    public void run() {
        System.out.println("MyThread1");
    }
}

// 2.实现Runnable接口
class TestRunnable implements Runnable {
    @Override
    public void run() {
        System.out.println("TestRunnable");
    }
}

// 实现Callable接口
class TestCallable implements Callable<Integer> {
    @Override
    public Integer call() throws Exception {
        System.out.println("TestCallable");
        return 100;
    }
}
~~~

