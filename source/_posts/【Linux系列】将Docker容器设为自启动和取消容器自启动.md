---
title: 【Linux系列】将Docker容器设为自启动和取消容器自启动
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 3024480743
tags:
  - Docker
categories:
  - Linux
date: 2022-05-05 11:05:41
img:
coverImg:
password:
summary:
---

## 前言

> 五一小长假回来以后，公司因为物业断电导致服务器停止运行，来电后发现一些常用的服务并没有自启动，比如 `grafana`，查了下原因发现是当初部署这个容器的时候，没有添加异常停止后重新尝试启动的参数 `--restart`，下面来说下如何在不删除容器的情况下更新参数。

参数说明：

* --restart

~~~bash
--restart参数=
	no
		默认策略，在容器退出时不重启容器
	on-failure
		在容器非正常退出时（退出状态非0），才会重启容器
	on-failure:3
		在容器非正常退出时重启容器，最多重启3次
	always
		在容器退出时总是重启容器
# 开机自启
	unless-stopped
		在容器退出时总是重启容器，但是不考虑在Docker守护进程启动时就已经停止了的容器
# 一般推荐使用always参数
	--restart=always
~~~

## 更新容器参数

* 将正在运行的容器设为自启动

~~~bash
# docker update --restart=always 容器名或容器ID
$ docker update --restart=always <CONTAINER ID>
# 例如将 grafana 设为自启动
$ docker update --restart=always grafana
~~~

* 将自启动的容器取消自启动

~~~bash
# docker update --restart=no 容器名或容器ID
$ docker update --restart=no <CONTAINER ID>
# 例如取消 grafana 的自启动
$ docker update --restart=no grafana
~~~

