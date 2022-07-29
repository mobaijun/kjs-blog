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

![](https://cdn.mobaijun.com//2022/1ZHiE78yLBdVIgD.png)

* 添加配置信息

> 填写远程 IP 和端口，我这里是 jar 包部署在服务器，所以写服务器 IP 和程序端口

![](https://cdn.mobaijun.com//2022/nLoZi7GaMjceFPt.png)

> 复制剪贴板生成的参数：-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 进入对应的 ip 的远程服务器

## 第二步、远程服务器启动 jar 包

1. 启动 jar 包有多钟方式

> 1. java -jar *.jar
> 2. nohup java -jar *.jar &
> 3. 系统服务启动，前面博客都有介绍过，不多赘述

在远程服务器中启动 jar 应用程序的时候加入复制的参数：

~~~bash
# 启动方式1
$ nohup java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 -jar xxxxxx.jar &
~~~

> 注：剪切板中的参数一定要放在-jar的前面，否则不起作用

观察输出日志，如果在前面几行中有如下日志表明远程服务器的远程断点调试端口开放成功

> `Listening for transport dt_socket at address: 5005`

此时，回到本地的 idea 应用程序，选择之前自己定义的远程断点调试配置，可以发现其只有debug按钮，点击debug按钮即可成功进行远程断点调试。在需要 debug 的地方打上断点，当远端的程序运行到这个断点时会自动停下。

> 注：此时程序的运行是以远端服务器上的代码为准的，改变本地的代码是无效的
>
> PS : 建议在排查问题的时候持续打印日志（tail -f log.txt）,可以少踩很多坑。

## 其他启动方式，参数自定义

> nohup java -Xdebug -Xrunjdwp:transport=dt_socket,address=5005,server=y,suspend=y -jar xxxxxx.jar &
>
> 
>
> ~~java -Xdebug -Xrunjdwp:transport=dt_socket,address=5005,server=y,suspend=y -cp xxxxxx.jar com.xxx.xxx~~
