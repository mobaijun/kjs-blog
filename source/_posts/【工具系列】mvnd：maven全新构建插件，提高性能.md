---
title: 【工具系列】mvnd：maven全新构建插件，提高性能
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 1982863623
tags:
  - mvnd
categories:
  - 工具
date: 2021-12-29 10:34:47
img:
coverImg:
password:
summary:
---

## 前言：

早上打包项目的时候发现打包速度很慢，耗时颇久，就在一个群里求助，如何使`maven`打包效率加快，一个群友发来一个链接，如图。

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】mvnd：maven全新构建插件，提高性能/0.png)

`Google`后发现这个工具居然是`apache maven`团队出品，并且是`maven`的一个子项目，所以使用`maven`可以无缝切换到`mvnd`。

## Mvnd 简介

`maven-mvnd`是`Apache Maven`团队借鉴了`Gradle`和`Takari`后衍生出的更快的构建工具。`mvnd`内嵌了`Maven`，也正是因为这个原因我们可以无缝地将`Maven`切换为`mvnd`（也不需要单独安装`Maven`）。

在设计上，在`mvnd`中会生成一个或多个的守护进程来服务构建请求以此来达到并行构建的效果。另外在`VM`的选择上，`mvnd`使用了`GraalVM`来代替传统的`JVM`，与之相比`GraalVM`启动速度更快，占用的内存更少。

根据文档描述，与传统的`Maven`相比`mvnd`具有以下优势：

- 运行构建的`JVM`不需要为每个构建重新启动。
- `Maven`插件类的类加载器缓存在多个构建中，插件`jars`只会被读取和解析一次。
- `JVM`中`JIT`生成的本机代码会被保留。与`Maven`相比，`JIT`编译花费的时间更少。在重复构建期间，`JIT`优化的代码立即可用。这不仅适用于来自`Maven`插件和`Maven`内核的代码，也适用于来自`JDK`本身的所有代码。

默认情况下，`mvnd`使用多个`CPU`内核并行构建模块。使用的内核数由公式`Math.max(Runtime.getRuntime().availableProcessors() - 1, 1)`给出。 如果您的源代码树不支持并行构建，请在命令行上传递`-T1`以使您的构建串行。

* 同时官方给出了`24`核机器上运行的动态图：

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】mvnd：maven全新构建插件，提高性能/1.gif)

> Github地址：[传送门](https://github.com/apache/maven-mvnd)

## 安装

* 下载地址：[传送门](https://github.com/apache/maven-mvnd/releases)

最新版本是`0.7.1`;

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】mvnd：maven全新构建插件，提高性能/2.png)

- 下载完成后解压即安装
- 修改配置文件

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】mvnd：maven全新构建插件，提高性能/3.png)

> 在解压后根目录的`conf`文件夹下找到`mvnd.properties`配置文件，配置`maven.settings`属性值为`maven`配置文件`settings.xml`的文件路径。注意：此`settings.xml`文件存放位置不受限制。

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】mvnd：maven全新构建插件，提高性能/4.png)

* 配置环境变量

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】mvnd：maven全新构建插件，提高性能/5.png)

复制`bin`目录路径，打开系统设置，最新版本win10 在`系统/关于/高级系统设置/环境变量（N）...`下配置系统环境变量

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】mvnd：maven全新构建插件，提高性能/6.png)

确认返回即可。

## 测试

* 查看环境变量是否配置成功

~~~bash
D:\>mvnd -version
mvnd native client 0.7.1-windows-amd64 (97c587c11383a67b5bd0ff8388bd94c694b91c1e)
Terminal: org.jline.terminal.impl.jansi.win.JansiWinSysTerminal
[WARN]
[WARN] Some problems were encountered while building the effective settings
[WARN] Unrecognised tag: 'url' (position: START_TAG seen ...<!-- \u914d\u7f6e JDK \u7248\u672c -->\r\n        <url>... @307:14)  @ D:\APP\apache-maven-3.8.2\conf\settings.xml, line 307, column 14
[WARN]
Apache Maven 3.8.3 (ff8e977a158738155dc465c6a97ffaf31982d739)
Maven home: D:\APP\mvnd-0.7.1-windows-amd64\mvn
Java version: 1.8.0_281, vendor: Oracle Corporation, runtime: C:\Program Files\Java\jdk1.8.0_281\jre
Default locale: zh_CN, platform encoding: GBK
OS name: "windows 10", version: "10.0", arch: "amd64", family: "windows"
~~~

* 查看帮助

~~~bash
$ mvnd --help
~~~

* mvn 打包测试

~~~bash
# mvn 打包命令
mvn clean package -Dmaven.test.skip=true

# 执行结果
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  8.405 s
[INFO] Finished at: 2021-12-29T11:18:05+08:00
[INFO] ------------------------------------------------------------------------
~~~

* mvnd 打包测试

~~~bash
# 执行打包命令
mvnd clean package -Dmaven.test.skip=true

# 执行结果
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  3.278 s (Wall Clock)
[INFO] Finished at: 2021-12-29T11:19:40+08:00
[INFO] ------------------------------------------------------------------------
~~~

> 差距很大，俺很惊喜😁😁😁。如果你有更加不错的方案，可以在下方留言区讨论，共同学习进步。
