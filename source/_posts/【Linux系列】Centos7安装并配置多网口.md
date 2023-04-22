---
title: 【Linux系列】Centos7安装并配置多网口
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 1316700149
tags:
  - 网卡配置
categories:
  - Linux
date: 2021-06-04 15:24:23
img:
coverImg:
password:
summary:
---

---

## 测试环境说明

系统版本：Centos 7 

## 准备环境

### 安装Centos7

* 新建一个虚拟向导，选择自定义并下一步

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/0.png)

* 选择虚拟机硬件兼容性，默认即可

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/1.png)

* 选择稍后安装操作系统

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/2.png)

* 选择客户机操作系统为*Linux*

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/3.png)

* 设置虚拟机名称

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/4.png)

* 设置处理器配置，按需配置即可

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/5.png)

* 虚拟机内存配置，越大越好，因为我将这台虚拟机作为主力测试机，所以参数设置和一般不太一样

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/6.png)

* 网络连接类型的选择，网络连接类型一共有桥接、NAT、仅主机和不联网四种。

1. 桥接：选择桥接模式的话虚拟机和宿主机在网络上就是平级的关系，相当于连接在同一交换机上。
2. NAT：NAT模式就是虚拟机要联网得先通过宿主机才能和外面进行通信。
3. 仅主机：虚拟机与宿主机直接连起来

> 桥接与NAT模式访问互联网过程，如下图所示

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/7.png)

* 这里选择桥接模式

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/8.png)

* IO控制器类型和磁盘类型选择默认即可

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/9.png)

* 磁盘容量

> 默认值为20GB，磁盘容量暂时分配50G即可后期可以随时增加，不要勾选【立即分配所有磁盘】，否则虚拟机会将100G直接分配给CentOS，会导致宿主机所剩硬盘容量减少。勾选将虚拟磁盘拆分成多个文件，这样可使虚拟机方便用储存设备拷贝复制。

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/10.png)

* 磁盘名称，默认即可

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/11.png)

* 自定义硬件设备
  1. 添加两个或以上网络适配器
  2. 删除不需要的打印机|USB控制器|声卡等
  3. 修改新建的网络适配器网络连接模式为桥接模式

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/12.png)

* 点击CD设置镜像位置

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/13.png)

* 点击完成，开启虚拟机

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/14.png)

* 安装操作系统

开启虚拟机后会出现以下界面

1. *Install CentOS 7 安装CentOS 7*
2. *Test this media & install CentOS 7 测试安装文件并安装CentOS 7*
3. *Troubleshooting 修复故障*

选择第一项，安装直接CentOS 7，回车，进入下面的界面

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/15.png)

* 选择安装过程中使用的语言，这里选择中文。点击继续

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/16.png)

* 首先设置时间，默认即可，联网后会自动更新

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/17.png)

* 安装环境选择基本网页服务器，基本开发环境即可

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/18.png)

* 配置网络，将三个网络全部打开

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/19.png)

* 在配置选项常规勾选可用时自动链接到这个网络，三个网卡同样的配置

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/20.png)

* 配置密码、等待安装完成

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/21.png)

## 编辑网卡配置

* 安装完成，登录系统，查看网卡配置

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/22.png)

* 查看Linux默认内核路由表

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/23.png)

* 进入网卡配置目录，查看网卡配置文件

~~~bash
$ cd /etc/sysconfig/network-scripts/
$ ls
~~~

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/24.png)

> 目录下, 有CentOS的发行及系统升级或许可能会存在网卡设备名称与之前版本不一致的情况, 这也很容易理解, 网卡设备名称在linux系统中它只是一个标志, 它并不能说明什么问题, 关键是这个设备文件的配置参数, 我当前CentOS7的网卡设备名称是

~~~bash
ifcfg-ens32 # 网卡1
ifcfg-ens33 # 网卡2
ifcfg-ens34 # 网卡3
~~~

* 查看网卡1的配置

~~~bash
$ cat ifcfg-ens32
~~~

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Centos7安装并配置多网口/25.png)

~~~perl6
TYPE=Ethernet								# 网卡类型：为以太网
PROXY_METHOD=none							# 代理方式：关闭状态
BROWSER_ONLY=no								# 只是浏览器：否
BOOTPROTO=dhcp								# 网卡的引导协议：DHCP[中文名称: 动态主机配置协议]
DEFROUTE=yes								# 默认路由：是, 不明白的可以百度关键词 `默认路由`
IPV4_FAILURE_FATAL=no						# 是不开启IPV4致命错误检测：否
IPV6INIT=yes								# IPV6是否自动初始化: 是[不会有任何影响, 现在还没用到IPV6]
IPV6_AUTOCONF=yes							# IPV6是否自动配置：是[不会有任何影响, 现在还没用到IPV6]
IPV6_DEFROUTE=yes							# IPV6是否可以为默认路由：是[不会有任何影响, 现在还没用到IPV6]
IPV6_FAILURE_FATAL=no						# 是不开启IPV6致命错误检测：否
IPV6_ADDR_GEN_MODE=stable-privacy			# IPV6地址生成模型：stable-privacy [这只一种生成IPV6的策略]
NAME=ens32								    # 网卡物理设备名称
UUID=383afe6e-ef36-4286-9511-b003e73ae84c	# 通用唯一识别码, 每一个网卡都会有, 不能重复, 否两台linux只有一台网卡可用
DEVICE=ens32								# 网卡设备名称, 必须和 `NAME` 值一样
ONBOOT=yes								    # 是否开机启动， 要想网卡开机就启动或通过 `systemctl restart network`控制网卡,必须设置为 `yes`
IPV6_PRIVACY=no								# 定义了IPv6的Privacy地址扩展,默认情况下，内核没有开启隐私地址
~~~

* 编辑网卡1配置

~~~bash
# 编辑网卡1
$ vim /etc/sysconfig/network-scripts/ifcfg-ens32
# 编辑网卡1配置
--------------------------------------------------
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
# 开启静态IP
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens32
UUID=383afe6e-ef36-4286-9511-b003e73ae84c
DEVICE=ens32
ONBOOT=yes
IPV6_PRIVACY=no
# 静态IP地址
IPADDR=192.168.10.80
# 默认网关
GATEWAY=192.168.10.1
# 子网掩码
NETMASK=255.255.255.0 
# DNS 配置
DNS1=202.96.128.86
~~~

> 需要注意的是*DNS*配置需要和系统宽带运营商一直，比如电信网络需要使用电信*DNS*配置、具体可以参考这篇博客[全国DNS服务器IP大全 - 云+社区 - 腾讯云](https://cloud.tencent.com/developer/article/1352604)

* 编辑网卡2的配置

~~~bash
# 编辑网卡2
$ vim /etc/sysconfig/network-scripts/ifcfg-ens33
# 编辑网卡2配置
--------------------------------------------------
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
# 开启静态IP
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens32
UUID=383afe6e-ef36-4286-9511-b003e73ae84c
DEVICE=ens32
ONBOOT=yes
IPV6_PRIVACY=no
# 静态IP地址
IPADDR=192.168.10.79
# 默认网关
GATEWAY=192.168.10.1
# 子网掩码
NETMASK=255.255.255.0 
# DNS 配置
DNS1=202.96.128.86
~~~

* 编辑网卡3配置

~~~bash
# 编辑网卡3
$ vim /etc/sysconfig/network-scripts/ifcfg-ens34
# 编辑网卡3配置
--------------------------------------------------
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
# 开启静态IP
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens32
UUID=383afe6e-ef36-4286-9511-b003e73ae84c
DEVICE=ens32
ONBOOT=yes
IPV6_PRIVACY=no
# 静态IP地址
IPADDR=192.168.10.78
# 默认网关
GATEWAY=192.168.10.1
# 子网掩码
NETMASK=255.255.255.0 
# DNS 配置
DNS1=202.96.128.86
~~~

* 重启网卡配置

~~~bash
$ systemctl restart network.service
~~~

> 到此多网口配置就没问题了，你也可以查看是否可以链接外部网络，以免配置有误

~~~bash
[root@localhost ~]# curl www.mobaijun.com:443
<html>
<head><title>400 The plain HTTP request was sent to HTTPS port</title></head>
<body bgcolor="white">
<center><h1>400 Bad Request</h1></center>
<center>The plain HTTP request was sent to HTTPS port</center>
<hr><center>Qnginx/1.8.9</center>
</body>
</html>
~~~

## 常用网络参数和命令

~~~bash
# DNS配置文件
$ /etc/resolv.conf
# 主机名到IP地址的映射
$ /etc/hosts
# 所有的网络接口和路由信息，网关只有最后一个有效。
$ /etc/sysconfig/network
# 每一个网络接口的配置信息
$ /etc/sysconfig/network-script/ifcfg-<interface-name>
# 设置eth32网卡IP地址192.168.10.80
$ ip addr add 192.168.10.80/24 dev eth32
# 删除eth32网卡IP地址
$ ip addr del 192.168.10.80/24 dev eth32
# 显示网卡IP信息
$ ip link show
# 设置eth32网卡IP地址192.168.0.1
$ ip addr add 192.168.10.1/24 dev eth32
# 删除eth32网卡IP地址
$ ip addr del 192.168.10.1/24 dev eth32
# 显示网络接口信息
$ ip link show
# 开启网卡
$ ip link set eth32 up
# 关闭网卡
$ ip link set eth32 down
# 开启网卡的混合模式
$ ip link set eth32 promisc on
# 关闭网卡的混个模式
$ ip link set eth32 promisc offi
 # 设置网卡队列长度
$ ip link set eth32 txqueuelen 1200
# 设置网卡最大传输单元
$ ip link set eth32 mtu 1400
# 查看路由(网关)信息
$ ip route show 或 $ ip route list 或 $ route -n
# 设置192.168.10.0网段的网关为192.168.10.254,数据走eth32接口
$ ip route add 192.168.10.0/24  via  192.168.10.254 dev eth32
# 设置默认网关为192.168.10.254
$ ip route add default via  192.168.10.254  dev eth32
# 删除192.168.10.0网段的网关
$ ip route del 192.168.10.0/24
# 删除默认路由
$ ip route del default
# 查看NDS服务器地址，使用nslookup命令
$ nslookup www.mobaijun.com
# 如果你对某个命令不熟悉，可以使用命令 --help参数，例如
$ ifconfig --help
~~~

> 每一个网卡只能使用一个配置文件，当有多个配置文件时，后面读取的配置文件信息会覆盖前面的配置信息。所以一个网卡最好只写一个配置文件。最后，欢迎下方留言讨论

