---
title: 【Linux系列】CentOS-7下安装RabbitMQ教程
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 229581796
tags:
  - RabbitMQ
categories:
  - Linux
date: 2021-11-24 10:06:09
img:
coverImg:
password:
summary:
---

## 前言

这个星期在学习 `RabbitMQ` ,所以记录下安装过程，涵盖踩坑过程，希望可以帮助到你。

* 环境说明
  1. JDK： 1.8
  2. 操作系统：CentOS -7x64
  3. Erlang-OTP （ `RabbitMQ` 依赖环境）：23.X
  4. RabbitMQ：3.9.10（最新版）

## 安装 `Erlang `环境

`Erlang `是安装 `RabbitMQ `的预备环境，其中版本对应关系可在传送门链接获取，`RabbitMQ `官网已有说明。

![image-20211124101724553](https://i.loli.net/2021/11/24/nGa25CmtEgARzY6.png)

> 在基于 `RPM ` 的发行版上， `Erlang `有三个替代来源：
>
> - `RabbitMQ `团队生产[了一个](https://github.com/rabbitmq/erlang-rpm)精简[的包](https://github.com/rabbitmq/erlang-rpm)，只提供运行 `RabbitMQ `所需的那些组件。这是推荐的选项。
> - [openSUSE](https://www.opensuse.org/)为 `openSUSE `和 `SLES`生成[Erlang 包](https://software.opensuse.org/download.html?project=devel%3Alanguages%3Aerlang%3AFactory&package=erlang)
> - [Erlang Solutions](https://www.erlang-solutions.com/resources/download.html)生成的包通常是最新的，并且涉及安装可能过多的依赖项列表

* `Erlang` 配置：[传送门](https://packagecloud.io/rabbitmq/erlang/install#bash-rpm)

~~~bash
$ curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash
#=======================以下命令为 erlang 官网安装教程，通过 yum 安装，可浓缩为上面一条命令
# https://www.erlang-solutions.com/downloads/
$ wget https://packages.erlang-solutions.com/erlang-solutions-2.0-1.noarch.rpm
$ rpm -Uvh erlang-solutions-2.0-1.noarch.rpm
~~~

* 通过 `yum` 安装 `Erlang`

~~~bash
$ yum install -y erlang
~~~

![image-20211124110453594](https://i.loli.net/2021/11/24/56NItLm4kjEFvPx.png)

> 我这里安装的版本是：`23.3.4.8-1.el7`

* 查看 `Erlang ` 版本

~~~bash
# 输入 erl 进入 erlang 控制台，ctrl + shift + c 强制退出
$ erl
# 控制台打印 Hello World
[root@mobai ~]# erl
Erlang/OTP 23 [erts-11.2.2.7] [source] [64-bit] [smp:1:1] [ds:1:1:10] [async-threads:1] [hipe]

Eshell V11.2.2.7  (abort with ^G)
1> io:format("hello world!~n").
hello world!
ok
2>
~~~

> PS：官方推荐使用只包含 `RabbitMQ` 所需插件的 `erlang `安装包，可以参考官网说明文档 :[Zero-dependency Erlang from RabbitMQ](https://www.rabbitmq.com/install-rpm.html#install-zero-dependency-rpm)

## 安装 `RabbitMQ`

* 导入两个签名密钥

~~~bash
# 主 RabbitMQ 签名密钥
$ rpm --import https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
# 现代 Erlang 存储库,如果是安装以上内容操作安装 erlang 可忽略下方命令
# $ rpm --import https://packagecloud.io/rabbitmq/erlang/gpgkey
# RabbitMQ 服务器存储库
$ rpm --import https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey
~~~

* 安装 `RabbitMQ `前置配置: [传送门](https://packagecloud.io/rabbitmq/rabbitmq-server/install#bash-rpm)

~~~bash
$ curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
~~~

* 配置 `yum `仓库

~~~shell
[root@mobai ~]# cat /etc/yum.repos.d/rabbitmq.repo
# In /etc/yum.repos.d/rabbitmq.repo

##
## Zero dependency Erlang
##

[rabbitmq_erlang]
name=rabbitmq_erlang
baseurl=https://packagecloud.io/rabbitmq/erlang/el/8/$basearch
repo_gpgcheck=1
gpgcheck=1
enabled=1
# PackageCloud's repository key and RabbitMQ package signing key
gpgkey=https://packagecloud.io/rabbitmq/erlang/gpgkey
       https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300

[rabbitmq_erlang-source]
name=rabbitmq_erlang-source
baseurl=https://packagecloud.io/rabbitmq/erlang/el/8/SRPMS
repo_gpgcheck=1
gpgcheck=0
enabled=1
# PackageCloud's repository key and RabbitMQ package signing key
gpgkey=https://packagecloud.io/rabbitmq/erlang/gpgkey
       https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300

##
## RabbitMQ server
##

[rabbitmq_server]
name=rabbitmq_server
baseurl=https://packagecloud.io/rabbitmq/rabbitmq-server/el/8/$basearch
repo_gpgcheck=1
gpgcheck=0
enabled=1
# PackageCloud's repository key and RabbitMQ package signing key
gpgkey=https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey
       https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300

[rabbitmq_server-source]
name=rabbitmq_server-source
baseurl=https://packagecloud.io/rabbitmq/rabbitmq-server/el/8/SRPMS
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
~~~

* 更新 `yum ` 包元数据

~~~bash
# 更新 yum
$ yum update -y
# 生成缓存 
$ yum -q makecache -y --disablerepo='*' --enablerepo='rabbitmq_erlang' --enablerepo='rabbitmq_server'
~~~

* 接下来从标准存储库安装依赖项：

~~~bash
$ yum install socat logrotate -y
~~~

* 最后，安装 RabbitMQ：

~~~bash
$ yum install --repo rabbitmq_erlang --repo rabbitmq_server erlang rabbitmq-server -y
~~~



~~~bash
wget https://packages.erlang-solutions.com/erlang-solutions-2.0-1.noarch.rpm

~~~

