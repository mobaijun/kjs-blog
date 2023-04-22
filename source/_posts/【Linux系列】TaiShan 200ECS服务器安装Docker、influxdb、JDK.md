---
title: 【Linux系列】TaiShan 200ECS服务器安装Docker、influxdb、JDK
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 313051912
tags:
  - TaiShan 200ECS
categories:
  - Linux
date: 2021-06-08 16:41:42
img:
coverImg:
password:
summary:
---

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】TaiShan 200ECS服务器安装Docker、influxdb、JDK/0.jpg)

## 介绍

因为公司业务需要，自研平台需要适配*TaiShan 200*服务器，本来想独立安装*redis,MySQL*等软件的，但是对*aarch64*架构不太熟悉，问了对接的工作人员，说服务器支持*dcoker*，所以一些不方便安装的软件使用*Docker*来安装编译环境。

## 环境说明

* 服务器架构信息如下：

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】TaiShan 200ECS服务器安装Docker、influxdb、JDK/1.png)

* 内存信息如下

![image-20210608174250174](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】TaiShan 200ECS服务器安装Docker、influxdb、JDK/2.png)

* os版本如下

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】TaiShan 200ECS服务器安装Docker、influxdb、JDK/3.png)

这台是*Kylin Linux Advanced Server V10 for ARM*操作系统，是标准的aarch64指令集的ARM架构服务器。kylin服务器是基于redhat版本的，基本可以等同于centos，所以熟悉centos的朋友操作麒麟应该非常熟练。

由于在线安装的方式，会遇到各种包缺失等提示（ARM架构的生态目前还比不上x86的便利），所以这里选用离线安装的方式。

下载相关文件，认准aarch64标识，noarch代表全架构支持

## 安装插件

~~~bash
$ yum -y install wget vim 
~~~

## 安装Docker

### 下载软件包安装

1. 通过仓库下载指定版本的软件包

~~~bash
$ wget https://download.docker.com/linux/static/stable/aarch64/docker-20.10.7.tgz
~~~

2. 解压Docker

~~~bash
$ tar -zxvf docker-20.10.7.tgz -C /server/docker
# -C 表示解压存放的文件目录
~~~

3. 移动目录到/usr/bin目录下

~~~bash
# 移动目录
$ cp -rp docker* /usr/bin
# 为使Docker可以正常使用，还需要关闭SELinux及防火墙。
$ setenforce 0
$ systemctl stop firewalld
$ systemctl disable firewalld
$ systemctl start firewalld
$ systemctl status firewalld
~~~

> 此时只是暂时禁用SELinux，如果要长期禁用SELinux，还需要修改/etc/selinux/config文件。
>
> 将SELINUX=enforcing改为SELINUX=permissive或disabled，才能长期有效。

### 启动docker.service服务

1. 整段执行如下命令，配置docker.service文件。

~~~bash
$ cat >/usr/lib/systemd/system/docker.service <<EOF
===========================以下为写入内容==========================
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.com
After=network.target docker.socket
[Service]
Type=notify
EnvironmentFile=-/run/flannel/docker
WorkingDirectory=/usr/local/bin
# 注意这个路径，如果不对将找不到dockerd启动程序
ExecStart=/usr/bin/docker/dockerd -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock --selinux-enabled=false --log-opt max-size=1g
ExecReload=/bin/kill -s HUP $MAINPID
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes
# kill only the docker process, not all processes in the cgroup
KillMode=process
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
~~~

4. 重启服务器，使修改的配置文件生效。

~~~bash
$ reboot
~~~

5. 随后启动相关服务，输出Docker的状态

~~~bash
$ systemctl daemon-reload
$ systemctl enable docker
$ systemctl start docker
$ systemctl restart docker
$ systemctl status docker
~~~

### 验证Docker

~~~bash
$ docker -version
~~~

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】TaiShan 200ECS服务器安装Docker、influxdb、JDK/4.png)

## 安装JDK

* 下载JDK

~~~bash
$ wget https://download.oracle.com/otn/java/jdk/8u291-b10/d7fc238d0cbf4b0dac67be84580cfb4b/jdk-8u291-linux-aarch64.tar.gz?AuthParam=1623297465_7186e5be169b0e8492340a0a1a58071e
# 重命名
$  mv jdk-8u291-linux-aarch64.tar.gz\?AuthParam\=1623297465_7186e5be169b0e8492340a0a1a58071e  jdk-8u291-linux-aarch64.tar.gz
~~~

* 解压JDK

~~~bash
$ tar -zxvf jdk-8u291-linux-aarch64.tar.gz
~~~

* 配置环境变量

~~~bash
$ vim /etc/profile
=========末尾添加以下内容============
#set java environment
JAVA_HOME=/server/jdk/jdk1.8.0_291
CLASSPATH=.:$JAVA_HOME/lib
PATH=$JAVA_HOME/bin:$PATH
export JAVA_HOME CLASSPATH PATH
~~~

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】TaiShan 200ECS服务器安装Docker、influxdb、JDK/5.png)

## 安装influxdb

1. 下载influxdb

~~~bash
wget https://dl.influxdata.com/influxdb/releases/influxdb-1.8.4_linux_arm64.tar.gz
~~~

2. 解压influxbd

~~~bash
tar -zxvf influxdb-1.8.4_linux_arm64.tar.gz
~~~

3. 修改influxdb配置

~~~bash
# 这是我的配置文件地址，你的可能有所区别
$ vim /server/influxdb/influxdb-1.8.4-1/etc/influxdb/influxdb.conf
================================================================
# Bind address to use for the RPC service for backup and restore.
# 启动地址
bind-address = "127.0.0.1:8088"
# 服务调用地址
bind-address = "127.0.0.1:8086"
~~~

4. 编辑环境变量

~~~bash
vim /etc/profile
==============================
export INFLUXD_CONFIG_PATH=/server/influxdb/influxdb-1.8.4-1/etc/influxdb/influxdb.conf
~~~

* 添加influxdb服务到启动项

~~~bash
vim /etc/systemd/system/influxdb.service
============================================
# 写入内容
[Unit]
Description=influxdb service
After=network.target
[Service]
Type=simple
Restart=on-failure
RestartSec=5s
WorkingDirectory=/server/influxdb/influxdb-1.8.4-1/usr/bin
ExecStart=/server/influxdb/influxdb-1.8.4-1/usr/bin/influxd run --config /server/influxdb/influxdb-1.8.4-1/etc/influxdb/influxdb.conf
[Install]
WantedBy=multi-user.target
~~~

* 执行启动

~~~bash
systemctl daemon-reload
systemctl enable influxdb
systemctl restart influxdb
systemctl status influxdb
~~~

## 安装MySQL和Redis

因为已经安装了*Docker*，所以就直接用Docker操作了，*docker pull下载redis镜像*，*MySQL*是没有arm架构的，这个已经在*docker hup*上面确认过了，官方提供的包都是*AMD和Linux架构*，替代品为*mysql/mysql-server*,[传送门](https://registry.hub.docker.com/r/mysql/mysql-server/tags?page=1&ordering=last_updated)

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】TaiShan 200ECS服务器安装Docker、influxdb、JDK/6.png)

1. 拉取*redis*和*MySQL*镜像

~~~bash
$ docker pull redis:latest
$ docker pull mysql/mysql-server:latest
~~~

2. 查看拉取的镜像

~~~bash
$ docker images
~~~

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】TaiShan 200ECS服务器安装Docker、influxdb、JDK/7.png)

3. 启动*MySQL*和*redis*容器

~~~bash
# 启动redis
$ docker run --restart=always  -dit --name redis -p 6379:6379 -v /server/redis/conf/redis.conf:/redis.conf -v /server/redis/data:/data redis:latest redis-server --appendonly yes
# 启动MySQL
$ docker run -itd --name mysql -p 3306:3306 -v /server/mysql/conf:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=test mysql/mysql-server
=========================================================
# --restart=always 表示随着系统启动自启动容器
# -p			   映射的端口号
# -v			   挂载目录
# -e			   初始化密码
~~~

4. 测试启动是否成功

~~~bash
$ docker ps
~~~

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】TaiShan 200ECS服务器安装Docker、influxdb、JDK/8.png)

5. 进入容器

~~~bash
$ docker exec -it 容器ID bash
~~~

6. 查看容器内部信息

~~~bash
$ docker inspect 容器ID
~~~

7. 启动或停止已有的容器

~~~bash
# 停止正在运行的容器
$ docker stop 容器ID
# 启动容器
$ docker start 容器ID
~~~

8. 万能命令

~~~bash
# 查看帮助
$ docker 参数 --help
~~~

> 以上都是基于测试环境演示，具体的根据自己环境调试即可，感谢阅读。

