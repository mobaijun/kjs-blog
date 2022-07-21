---
title: 【工具系列】Idea 远程调试服务器 Jar 包
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 55789149
tags:
  - Remote JVM Debug
categories:
  - 工具
date: 2022-04-13 18:47:46
img:
coverImg:
password:
summary:
---

## 前言

> 经常遇到需要调试服务器 jar 包的场景，比如部署了一个 jar 包到远程服务器，突然有个接口异常，在没有自动化部署支持的情况下，需要手动在本地启动项目，调试完毕程序后重新打包，部署到服务器上面。一套操作下来，繁琐而复杂，今天来说说如何在 idea 调试远程部署的 jar。

## 第一步、添加 Remote 模块

> 找到 Edit Configurations，新增一个 Remote JVM Debug 模块

![](https://s2.loli.net/2022/04/13/1ZHiE78yLBdVIgD.png)

* 添加配置信息

> 填写远程 IP 和端口，我这里是 jar 包部署在服务器，所以写服务器 IP 和程序端口

![](https://s2.loli.net/2022/04/13/nLoZi7GaMjceFPt.png)

## 第二部、远程服务器启动 jar 包

1. 启动 jar 包有多钟方式

> 1. java -jar *.jar
> 2. nohup java -jar *.jar &
> 3. 系统服务启动，前面博客都有介绍过，不多赘述

~~~bash
# 启动方式一
$ nohup java -Xdebug -Xrunjdwp:transport=dt_socket,address=5005,server=y,suspend=y -jar xxxxxx.jar &
# 启动方式二
$ java -Xdebug -Xrunjdwp:transport=dt_socket,address=5005,server=y,suspend=y -cp xxxxxx.jar com.xxx.xxx
~~~

> 启动完成以后，在需要排查的模块打上断点，程序在运行到相关位置的时候会自动停止。
>
> > PS : 建议在排查问题的时候持续打印日志（tail -f log.txt）,可以少踩很多坑。
