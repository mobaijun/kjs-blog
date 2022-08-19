---
title: 【Linux系列】Ubuntu 20.04.2 LTS Server版本设置静态IP地址
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 594559550
tags:
  - Ubuntu
categories:
  - Linux
date: 2021-08-18 19:15:29
img:
coverImg:
password:
summary:
---

## 前言

今天在家打开 Xshell 时发现 Xshell 无法连接到 Ubuntu 虚拟机了，想了一下，这台虚拟机是在公司的网络环境下安装的，回家后的网络不一致，导致 IP 变了，所以才无法连接。

以前都是在 Centos 系统上面配置静态 IP 的，在 Ubuntu 上面还是第一次，所以就记录下。Ubuntu配置静态 IP 不是在 network 下配置，和 Centos 有很大区别。Ubuntu 从 17.10 版本开始，就放弃在  `/etc/network/interfaces` 里固定 IP 的配置，`interfaces` 文件不复存在，即使配置也不会生效，而是改成 `netplan` 方式 ，配置写在 `/etc/netplan/01-network-manager-all.yaml` 或者类似名称的 `yaml` 文件里

![网卡配置文件](https://tencent.cos.mobaijun.com/article_with_pictures/20210818192540.png)

##  查看网卡

```bash
$ ip addr
```

![](https://tencent.cos.mobaijun.com/article_with_pictures/20210818192721.png)

## 修改 yaml 文件

* netplan 方式的配置为 yaml 格式

```bash
$ sudo vi /etc/netplan/01-network-manager-all.yaml
```

![配置网卡](https://tencent.cos.mobaijun.com/article_with_pictures/20210818194735.png)



```yaml
# This file describes the network interfaces available on your system
# For more information, see netplan(5).
network:
  ethernets:
    ens32: # 配置的网卡的名称
     dhcp4: no # 关闭DHCP，如果需要打开DHCP则写yes
     optional: true
     addresses: [192.168.3.125/24] # 配置的静态ip地址和掩码
     gateway4: 192.168.3.1  # 网关地址
     nameservers:
       addresses: [114.114.114.114,8.8.8.8] # DNS服务器地址，多个DNS服务器地址需要用英文逗号分隔开
  version: 2
  renderer: networkd # 指定后端采用systemd-networkd或者Network Manager，可不填写则默认使用systemd-workd
```

根据自己的需要配置好之后`:wp`保存文件

## 让配置生效

* 加载配置

```bash
$ sudo netplan apply
```

* 查看网络服务状态

~~~bash
$ networkctl status
~~~

* 再 ping 一下外网的 IP ，确认是否可以访问外网。

~~~bash
$ ping 114.114.114.114
~~~

## 注意事项：

- ip 地址和 DNS 服务器地址需要用[]括起来，但是网关地址不需要
- 注意每个冒号后边都要先加一个空格
- 注意每一层前边的缩进，至少比上一层多两个空格

