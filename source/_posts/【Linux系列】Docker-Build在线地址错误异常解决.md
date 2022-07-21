---
title: 【Linux系列】Docker-Build在线地址错误异常解决
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 1333172510
tags:
  - Docker
categories:
  - Linux
date: 2021-12-07 09:38:19
img:
coverImg:
password:
summary:
---

## 前言：

最近需要使用到一款国产时序数据库`IOTDB`,按照[官网操作文档](https://iotdb.apache.org/zh/UserGuide/V0.10.x/Server/Docker%20Image.html)指引进行安装，出现`Docker-build`在线地址异常,所以记录下。

## 系统环境

操作系统：CentOS Linux 7 (Core)

Docker : version 20.10.9

git :    version 2.30.1[`出现问题的版本是1.8.3`]

## 异常信息：

~~~bash
[root@mobai local]# docker build -t iotdb:base git://github.com/apache/incubator-iotdb#master:docker
unable to prepare context: unable to 'git clone' to temporary context directory: error initializing submodules: usage: git submodule
~~~

这个问题后来查到是由于git版本太老导致的。

[低于 2.10 的 git 不支持](https://stackoverflow.com/a/17692710/1043209)`--depth`参数。总之，升级你的 git,原文地址：[How to make shallow git submodules? - Stack Overflow](https://stackoverflow.com/questions/2144406/how-to-make-shallow-git-submodules/17692710#17692710)

* 原来安装git的命令

~~~bash
$ yum install -y git
$ git --version
=======1.8.3
~~~

* 重新安装

~~~bash
$ yum remove git
$ yum -y install https://packages.endpoint.com/rhel/7/os/x86_64/endpoint-repo-1.7-1.x86_64.rpm
$ yum install git
~~~

如上即可。
