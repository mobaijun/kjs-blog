---
title: 【工具系列】使用Fiddler对微信小程序进行抓包
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 3549539487
date: 2022-05-13 15:01:32
img:
coverImg:
password:
summary:
tags:
- fiddler
categories:
- 工具
---

## 前言

> 空闲时间一个朋友问我能不能弄个九价抢苗小程序，`GitHub` 看了一下有好几个,拉取了一个项目后，查看 Readme 文档简介说明，需要准备 `fiddler` 前置知识，对微信小程序进行抓包。在此记录一下。

* 环境说明
  * 操作系统：Windows X64 AMD 
  * fiddler 版本：v5.0.20211.51073 for .NET 4.6.1

## 安装 fiddler 和配置

* 下载地址：[Download Fiddler Web Debugging Tool for Free by Telerik](https://www.telerik.com/download/fiddler)

安装很简单，只需要一直点击 `next` 即可，懂得都懂！！！

* 配置

> 安装完成后需要配置一下工具,点击 `tools\options`,

![](https://s2.loli.net/2022/05/13/cA5Bo2UXJ6qbYDV.png)

配置 `General`

![](https://s2.loli.net/2022/05/13/kv57GAIncYup3Wf.png)

* 勾选HTTPS可以进行对SLL安全请求可以进行测试（因为小程序需要HTTPS）

![](https://s2.loli.net/2022/05/13/R1K2sCrqbQOBztL.png)

* 勾选远程链接

![](https://s2.loli.net/2022/05/13/mj4dSwcVu3ONGYk.png)

> <font color="#dc143c">配置完成后，需要重启 fiddler</font>

## 抓包

详细操作可以参考官方文档：[Main Menu Tab | Fiddler Everywhere](https://docs.telerik.com/fiddler-everywhere/user-guide/main-menu)

> Fiddler启动后会开启系统代理`http=127.0.0.1:8888;https=127.0.0.1:8888;ftp=127.0.0.1:7890`以监听网卡数据
