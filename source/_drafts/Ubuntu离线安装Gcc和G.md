---
title: Ubuntu离线安装Gcc和G++
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 1413749831
tags:
  - gcc
categories:
  - Linux
date: 2021-09-11 23:32:59
img:
coverImg:
password:
summary:
---

> 最近有个需求，在一台服务器上面去安装一个通信协议`snmp`，这个协议我不是很了解，但是安装这个协议的时候需要一个`gcc`和`make`的环境，服务器环境安装的是 `Ubuntu 20.04.2 LTS精简版`，还是离线环境，不会去自动更新一些文件。需要手动去安装 `gcc` 等编译环境。避免下次不知道怎么操作，所以记录下:

## 环境说明

* 操作系统：Ubuntu 20.04.2 LTS
* 架构：x86-64
* 权限：root
* gcc 版本：gcc version 9.3.0 (Ubuntu 9.3.0-17ubuntu1~20.04)



### 在线安装 GCC

Ubuntu在线安装 gcc 很简单，一条命令就可以搞定，如下：

~~~bash
$ sudo apt install build-essential
~~~

上面这条命令可以将`gcc`完整安装下来，安装完成可以直接使用` gcc  -v` 来验证版本

![gcc版本](https://i.loli.net/2021/09/12/b7tdKNxcqDzJ9g1.png)

* 卸载命令

~~~bash
$ sudo apt-get remove g++ gcc
~~~

## 依赖下载地址

Ubuntu官方依赖包地址：[传送门](https://ubuntu.pkgs.org/20.04/ubuntu-updates-main-amd64/)

代理地址：[传送门](https://uk.mirrors.clouvider.net/ubuntu/ubuntu/pool/main/b/binutils/)

