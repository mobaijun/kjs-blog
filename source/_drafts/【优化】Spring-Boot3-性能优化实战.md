---
title: 【优化】Spring Boot3 性能优化实战
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 55384424
tags:
  - native-image
  - graalvm
categories:
  - SpringBoot
date: 2024-11-08 17:51:28
img:
coverImg:
password:
summary:
---

## 前言

> 在最近接触的项目中，我采用了 `Spring Boot 3` 和 `Java 21` 的技术栈，重点在于性能优化。通过 `GraalVM `和 `native-image` 技术，将应用编译为原生二进制文件，从而大幅缩短启动时间并减少内存占用。下面介绍下整个操作流程。

## 环境说明

|     环境     |    版本    |                             地址                             |
| :----------: | :--------: | :----------------------------------------------------------: |
|   Windows    | 19045.5011 | [传送门](https://www.microsoft.com/en-us/software-download/windows10) |
|     Java     |   21.0.5   | [传送门](https://www.oracle.com/java/technologies/javase/jdk21-archive-downloads.html) |
|     Idea     |  2024 2.2  | [传送门](https://www.jetbrains.com/idea/download/?section=windows) |
| native-image |   Java21   | [传送门](https://www.graalvm.org/22.3/reference-manual/native-image/#install-native-image) |
|   GraalVM    |   Java21   |         [传送门](https://www.graalvm.org/downloads/)         |

## 前置条件

提前安装 `Java21 `，`GraalVM`，`native-image` 环境，并安装以下顺序配置环境变量。

1. 配置 `GraalVM` 环境变量，并将 `GraalVM` 环境变量置顶,如图：

![1731113330856.png](https://img.mobaijun.com:8888/1/2024/11/09/672eb1a84263e.png)

2. 在 `path` 变量中将 `GraalVM` 变量置顶,如图

![202411090849274.png](https://img.mobaijun.com:8888/1/2024/11/09/672eb1ae0ea43.png)

3. 验证环境变量

~~~bash
$ java -version
~~~

![image-20241109085910177](https://img.mobaijun.com:8888/1/2024/11/09/672eb3e28be7e.png)

4. 测试 `native-image`

![image-20241109092241374](https://img.mobaijun.com:8888/1/2024/11/09/672eb968b5970.png)
