---
title: 【Linux系列】Centos7安装Jenkins（RPM方式）
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 1309807359
tags:
  - Jenkins
categories:
  - Linux
date: 2021-12-13 14:45:31
img:
coverImg:
password:
summary:
---

## 镜像选择

1. RPM 包下载

官网下载链接速度不忍直视，可以在清华大学镜像站下载，[传送门](https://mirrors.tuna.tsinghua.edu.cn/jenkins/)

,我这里选择的是`jenkins-2.319.1-1.2.noarch.rpm`版本。

~~~bash
# 使用wget拉取包
$ wget -P /usr/local/ https://mirrors.tuna.tsinghua.edu.cn/jenkins/opensuse-stable/jenkins-2.319.1-1.2.noarch.rpm
# 安装到指定的 usr/local 位置下
$ rpm -ivh --prefix=/usr/local jenkins-2.319.1-1.2.noarch.rpm
~~~

2. 修改用户名和端口以及JDK路径配置

~~~bash
$ vim /etc/sysconfig/jenkins
JENKINS_JAVA_HOME="/usr/local/jdk1.8.0_311/bin"
JENKINS_USER="mobai"
JENKINS_PORT="8888"
~~~

3. 添加到系统服务

~~~bash
$ systemctl daemon-reload
~~~

