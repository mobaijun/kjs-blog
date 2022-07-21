---
title: 【工具系列】轻量级虚拟机Multipass使用教程
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 3701652676
tags:
  - Multipass
categories:
  - Linux
date: 2022-01-05 10:56:49
img:
coverImg:
password:
summary:
---

![](https://s2.loli.net/2022/01/05/GiuNOta831VpqFD.png)

## 简介

`Multipass` 是一个轻量虚拟机管理器，是由 `Ubuntu` 运营公司 `Canonical` 所推出的开源项目。运行环境支持 `Linux`、`Windows`、`macOS`。在不同的操作系统上，使用的是不同的虚拟化技术。在 `Linux` 上使用的是 `KVM`、`Window` 上使用 `Hyper-V`、`macOS` 中使用 `HyperKit` 以最小开销运行VM，支持在笔记本模拟小型云。

同时，`Multipass` 提供了一个命令行界面来启动和管理 `Linux` 实例。下载一个全新的镜像需要几秒钟的时间，并且在几分钟内就可以启动并运行 `VM`。

> Multipass官网：[传送门](https://multipass.run/)

## 下载

![](https://s2.loli.net/2022/01/05/1v5QJX8BRsFO9qt.png)

根据自己操作系统选择合适的版本进行下载，我这里是 `Windows`，就点击下载 `Windows` 版本。

安装步骤简单，一路下一步即可，安装的时候会自动配置 `Windows` 系统环境变量，如果有误可以检查一下是否正确安装。

* 验证软件版本

~~~bash
# 打开任意 Windows 命令行，键入以下命令查看版本
$ multipass --version
multipass   1.8.0+win
multipassd  1.8.0+win
~~~

## 创建 Ubuntu 虚拟机

首先，在命令行键入以下指令查找可供下载的 `Ubuntu` 镜像

> PS: 目前只支持 Ubuntu

~~~bash
$ multipass find
Image                       Aliases           Version          Description
core                        core16            20200818         Ubuntu Core 16
core18                                        20211124         Ubuntu Core 18
18.04                       bionic            20220104         Ubuntu 18.04 LTS
20.04                       focal,lts         20211129         Ubuntu 20.04 LTS
21.04                       hirsute           20211130         Ubuntu 21.04
21.10                       impish            20211209         Ubuntu 21.10
appliance:adguard-home                        20200812         Ubuntu AdGuard Home Appliance
appliance:mosquitto                           20200812         Ubuntu Mosquitto Appliance
appliance:nextcloud                           20200812         Ubuntu Nextcloud Appliance
appliance:openhab                             20200812         Ubuntu openHAB Home Appliance
appliance:plexmediaserver                     20200812         Ubuntu Plex Media Server Appliance
anbox-cloud-appliance                         latest           Anbox Cloud Appliance
minikube                                      latest           minikube is local Kubernetes
~~~

> 参数说明：
>
> * image：镜像
> * Aliases： 别名
> * version：版本
> * Description：描述

下载最新版本的 `Ubuntu` 镜像运行，第一次创建时需要下载 `Ubuntu` 镜像，网络通畅的情况下，稍等片刻即可。

~~~bash
$ multipass launch -n test01 -c 2 -m 4G -d 10G
~~~

> 自定义配置创建可以参考如下方式:
>
> * -n, --name: 名称
> * -c, --cpus: cpu核心数, 默认: 1
> * -m, --mem: 内存大小, 默认: 1G
> * -d, --disk: 硬盘大小, 默认: 5G

然后双击 `multipass`,鼠标右键点击任务栏 `open shell`

![](https://s2.loli.net/2022/01/05/vE9SIRGbKAoN2Lj.png)

会打开创建的虚拟机，

![](https://s2.loli.net/2022/01/05/gK1GCiLXP5IlHeB.png)

## 其他操作

查看正在运行的虚拟机列表：

~~~bash
$ multipass list
Name                    State             IPv4             Image
primary                 Running           172.21.230.38    Ubuntu 20.04 LTS
test01                  Running           172.21.234.209   Ubuntu 20.04 LTS
~~~

这条指令可以看到虚拟机详细信息，名称，状态，地址，镜像名称等信息。

## 外部操作虚拟机

通过 `multipass exec ` 命令在实例内执行给定的命令。第一个参数是运行命令的实例，也就是 `test01`

我们通过 `exec` 命令，就可以在外部操作刚刚创建的虚拟机，例如查看内部所处的目录，执行 `pwd` 命令

```bash
$ multipass exec test01 pwd
/home/ubuntu
```

## 查看虚拟机信息

通过 `multipass info` 命令，即可查看当前运行的虚拟机信息

```bash
$ multipass info test01
Name:           test01
State:          Running
IPv4:           172.21.230.38
Release:        Ubuntu 20.04.3 LTS
Image hash:     27cecebaf8c6 (Ubuntu 20.04 LTS)
Load:           0.00 0.00 0.00
Disk usage:     1.3G out of 4.7G
Memory usage:   372.1M out of 916.9M
Mounts:         --
```

## 进入虚拟机

通过 `multipass shell` 命令，即可进入到虚拟机内部

```bash
$ multipass shell test01
```

运行后的结果如下所示，可以看到目前虚拟机的一些系统配置信息，以及内存和磁盘的使用情况

## 挂载数据卷

`multipass` 还提供和 `Docker` 一样的挂载数据卷的功能，能够与外部宿主机的文件保持同步。

```bash
# 挂载格式
$ multipass mount 宿主机目录  实例名:虚拟机目录
```

下面，我在用户的目录下，创建一个 `data` 目录

```bash
# 创建data目录
$ mkdir data 
# 挂载
$ multipass mount D:\data  test01
```

挂载完成后，可以使用 `multipass info primary`，查看是否挂载成功

## 卸载数据卷

如果以后不需要用到挂载了，可以使用 `unmount` 命令卸载

```bash
#卸载数据卷
$ multipass umount 容器名
```

## 传输文件

除了使用上述的 `mount` 挂载卷的方式实现文件的交互，同时还可以通过 `transfer` 命令，将宿主机的文件，发送到虚拟机内部

```bash
$ multipass transfer 主机文件 容器名:容器目录
```

例如，将 `hello.txt` 发送到

```bash
$ multipass transfer hello.txt test01:/home/ubuntu/bash
```

## 删除和释放实例

使用下面的命令，可以开启、停止、删除和释放实例

```bash
# 启动实例
$ multipass start test01
# 停止实例
$ multipass stop test01
# 删除实例（删除后，还会存在）
$ multipass delete test01
# 释放实例（彻底删除）
$ multipass purge test01
```

## 容器配置自动化

为了保持开发环境和线上环境一致性 同时节省部署时间 `multipass` 给我们提供了 `--cloud-init` 选项进行容器启动初始化配置:

```bash
$ multipass launch --name ubuntu --cloud-init config.yaml
```

上面 `config.yaml` 则是容器的初始化配置文件，我们想在初始化容器的时候，自动下载安装 `Node.js`，内容如下：

```bash
# cloud-config
runcmd:
  - curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
  - sudo apt-get install -y nodejs
```

`runcmd`可以指定容器 `首次启动` 时运行的命令

> 凡是用户自定义的`cloud-init`的配置文件,必须以`#cloud-config`开头，这是`cloud-init`识别它的方式。

`yaml` 配置文件可以参考下面的文章

```bash
https://cloudinit.readthedocs.io/en/latest/topics/examples.html?highlight=lock-passwd#including-users-and-groups
```

更多关于 `multipass` 的高阶的技巧，欢迎访问 `multipass` 官方文档。
