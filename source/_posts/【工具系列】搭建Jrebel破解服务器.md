---
title: 【工具系列】搭建Jrebel破解服务器
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 841963446
tags:
  - JRebel
categories:
  - 工具
date: 2021-10-20 16:39:50
img:
coverImg:
password:
summary:
---

今天撸代码的时候`Jrebel`工具弹窗给我，原来的代理服务器过期了，要重新注册，刚好自己也有服务器，索性自己搭建一个代理服务器算了。

## 环境说明

* centos 7.6
* docker 20.10.9
* 代理镜像名称 qierkang/golang-reverseproxy

有兴趣的话可以将这个镜像的源码拉下来自己重新优化下，主要是有广告在里面😂

## 安装代理程序

* 安装 `Docker`

需要服务器提前安装 `docker`，安装步骤如下：

~~~bash
# 1.系统内核版本许保证3.10及以上
$ uname -r
3.10.0-957.el7.x86_64
# 2.查看系统版本
$ cat /etc/os-release
NAME="CentOS Linux"
VERSION="7 (Core)"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="7"
PRETTY_NAME="CentOS Linux 7 (Core)"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:centos:centos:7"
HOME_URL="https://www.centos.org/"
BUG_REPORT_URL="https://bugs.centos.org/"

CENTOS_MANTISBT_PROJECT="CentOS-7"
CENTOS_MANTISBT_PROJECT_VERSION="7"
REDHAT_SUPPORT_PRODUCT="centos"
REDHAT_SUPPORT_PRODUCT_VERSION="7"
# 3.需要先卸载旧的docker版本
$ yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
# 4.需要安装的包
$ sudo yum install -y yum-utils
# 5.yum 包更新到最新
$ sudo yum update
# 6.安装需要的软件包， yum-util 提供yum-config-manager功能，另外两个是devicemapper驱动依赖的
$ sudo yum install -y yum-utils device-mapper-persistent-data lvm2
# 7.设置yum源为阿里云
# https://registry.docker-cn.com
# http://hub-mirror.c.163.com
# https://docker.mirrors.ustc.edu.cn
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# 8.更新yum缓存
$ yum makecache fast
# 9.安装docker相关的包 docker-ce 社区版 ee企业版
$ sudo yum install docker-ce docker-ce-cli containerd.io
# 10.启动Docker
$ systemctl start docker
# 11.安装后查看docker版本
$ docker version  && docker -v
# 12.将 docker 添加到系统服务
$ systemctl enable docker
~~~

* 启动代理容器

~~~bash
# 下载代理镜像
$ docker pull qierkang/golang-reverseproxy
# 启动代理容器
$ docker run --restart=always -dit --name=jreber -p 8888:8888 qierkang/golang-reverseproxy
# 验证容器是否启动成功
$ docker ps
# 验证,有返回一大堆广告就是成功了
$ curl http://localhost:8888
~~~

* 开放端口号

~~~bash
# 云服务器记得去开放端口号|同步控制台安全组也需要开房端口号
$ firewall-cmd --zone=public --add-port=8088/tcp --permanent
# 重启防火墙
$ systemctl restart firewalld
# 查看已开放端口列表
$ firewall-cmd --list-ports
~~~

> PS：如果一次需要开放多个不同端口建议写个脚本去执行，不然一条条修改很麻烦😑，以前都没想到，害。。。。。。今天开放多个端口的时候就想起来，<font color="#dc143c">脚本就是为了解决那些重复性的工作</font>

* 脚本内容如下：

~~~shell
[root@mobai mobai]# cat tcp.sh 
# 端口列表
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --zone=public --add-port=8000/tcp --permanent
firewall-cmd --zone=public --add-port=8888/tcp --permanent
firewall-cmd --zone=public --add-port=9999/tcp --permanent
firewall-cmd --zone=public --add-port=9090/tcp --permanent
firewall-cmd --zone=public --add-port=8086/tcp --permanent
firewall-cmd --zone=public --add-port=8088/tcp --permanent
firewall-cmd --zone=public --add-port=6379/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=8002/tcp --permanent
firewall-cmd --zone=public --add-port=8001/tcp --permanent
firewall-cmd --zone=public --add-port=8003/tcp --permanent
firewall-cmd --zone=public --add-port=8004/tcp --permanent
# 重启防火墙
systemctl restart firewalld
# 查看开放端口列表
firewall-cmd --list-ports
~~~

看网上有说 `Linux` 有批量开放端口的命令，没验证过，不做评价。。。有知道的小伙伴可以下方留言说一下。

## 使用

* 使用说明

~~~bash
# url格式: 服务器公网ip地址:8888/GUID
$ http://127.0.0.1:8888/1782cd13-a1d1-4a14-9a91-085bb84eafd9
# guid生成地址访问下面这个链接：
$ https://www.guidgen.com/
~~~

![](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/image-20211020171939111.png)
