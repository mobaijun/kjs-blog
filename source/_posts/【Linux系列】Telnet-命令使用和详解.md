---
title: 【Linux系列】Telnet 命令使用和详解
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 1235765571
date: 2021-11-29 10:20:00
img:
coverImg:
password:
summary:
tags:
- Telnet
categories:
- Linux
---

## 前言

几乎是每天都会使用 `Telnet` ，所以就把这个命令以及参数详解记录，并做巩固。

## Telnet 简介

> `Telnet `是一款功能全面的端口测试工具，常用于网络管理和服务器调试。`Telnet `程序是基于 `TELNET` 协议的远程登录客户端程序。
>
> `Telnet `协议是 `TCP/IP` 协议族中的一员，是 `Internet` 远程登陆服务的标准协议和主要方式。它为用户提供了在本地计算机上完成远程主机工作的能力。
>
> 在终端使用者的电脑上使用 `Telnet ` 程序，用它连接到服务器。终端使用者可以在`Telnet `程序中输入命令，这些命令会在服务器上运行，就像直接在服务器的控制台上输入一样。可以在本地就能控制服务器。
>
> 要开始一个 `Telnet` 会话，必须输入用户名和密码来登录服务器。`Telnet` 是常用的远程控制`Web`服务器的方法。
>
> 但是，`Telnet `因为采用明文传送报文，安全性不好，很多Linux服务器都不开放`Telnet `服务，而改用更安全的ssh方式了。但仍然有很多别的系统可能采用了`Telnet `方式来提供远程登录，因此弄清楚`Telnet `客户端的使用方式仍是很有必要的。
>
> `Telnet `命令还可做别的用途，比如确定远程服务的状态，比如确定远程服务器的某个端口是否能访问。

## Windows 安装 Telnet

`Windows `操作系统默认未安装该功能。下面演示在 `Windows `中安装 `Telnet Client` 的方法。

### 命令行安装

以管理员的身份打开 `cmd` 窗口（`win + R`），执行下面的命令：

~~~bash
$ dism /online /Enable-Feature /FeatureName:TelnetClient
~~~

### 可视化安装

1. 打开 **控制面板** > **程序** > **启用或关闭 `Windows `功能**。
2. 勾选 **`Telnet` 客户端** 选项。

![image-20211129114305555](https://i.loli.net/2021/11/29/OqALRY1tHxzGMeJ.png)

3. 单击 **确定**，等待安装完毕。

![image-20211129114305666](https://i.loli.net/2021/11/29/FCsWQ2n1eLrf9wm.png)

## Linux 系统安装 Telnet

### Centos 7

~~~bash
# 安装 Telnet
$ yum install -y telnet*
$ yum install -y xinetd
# 设置开机启动
$ systemctl enable xinetd.service
$ systemctl enable telnet.socket
# 启动该服务
$ systemctl start telnet.socket
$ systemctl start xinetd
# 开放默认端口
$ firewall-cmd --permanent --add-port=23/tcp
$ firewall-cmd --reload
# 查看 Telnet 安装版本
$ yum list | grep telnet
~~~

### Ubuntu 20.x

~~~bash
# 安装 Telnet
$ sudo apt-get -install telnet
~~~

## 测试

~~~bash
$ telnet 127.0.0.1
~~~

然后输入账号密码登录。

## Telnet 客户端命常用命令

~~~bash
- open 使用 openhostname 可以建立到主机的 Telnet 连接。
- close 使用命令 close 命令可以关闭现有的 Telnet 连接。
- display 使用 display 命令可以查看 Telnet 客户端的当前设置。
- send 使用 send 命令可以向 Telnet 服务器发送命令。支持以下命令：
- ao 放弃输出命令。
- ayt “Are you there”命令。
- esc 发送当前的转义字符。
- ip 中断进程命令。
- synch 执行 Telnet 同步操作。
- brk 发送信号。
- quit 使用 quit 命令可以退出 Telnet 客户端。
~~~

> 上表所列命令以外的其他命令都将以字符串的形式发送至 `Telnet` 服务器。例如，`send json`将发送字符串`json`至`Telnet`服务器，这样，`Telnet`会话窗口中将出现该字符串。

## 参数说明：

命令格式：

~~~bash
$ telnet [args] [hostname]
~~~

命令功能：执行 `telnet` 指令开启终端机阶段作业，并登入远端主机。

需要甄别的是 `Telnet` 的参数 `Windows` 和 `Linux` 有些许区别，下方会注明。

`Windows` 参数释义：

~~~bash
C:\Users\mobai>telnet /?

telnet [-a][-e escape char][-f log file][-l user][-t term][host [port]]
 -a      企图自动登录。除了用当前已登陆的用户名以外，与 -l 选项相同。
 -e      跳过字符来进入 telnet 客户端提示。
 -f      客户端登录的文件名
 -l      指定远程系统上登录用的用户名。
         要求远程系统支持 TELNET ENVIRON 选项。
 -t      指定终端类型。
         支持的终端类型仅是: vt100, vt52, ansi 和 vtnt。
 host    指定要连接的远程计算机的主机名或 IP 地址。
 port    指定端口号或服务名。
~~~

`Linux` 参数释义：

~~~bash
-8 允许使用8位字符资料，包括输入与输出。
-a 尝试自动登入远端系统。
-b <主机别名> 使用别名指定远端主机名称。
-c 不读取用户专属目录里的.telnetrc文件。
-d 启动排错模式。
-e <脱离字符> 设置脱离字符。
-E 滤除脱离字符。
-f 此参数的效果和指定"-F"参数相同。
-F 使用Kerberos V5认证时，加上此参数可把本地主机的认证数据上传到远端主机。
-k <域名> 使用Kerberos认证时，加上此参数让远端主机采用指定的领域名，而非该主机的域名。
-K 不自动登入远端主机。
-l <用户名称> 指定要登入远端主机的用户名称。
-L 允许输出8位字符资料。
-n <记录文件> 指定文件记录相关信息。
-r 使用类似rlogin指令的用户界面。
-S <服务类型> 设置telnet连线所需的IP TOS信息。
-x 假设主机有支持数据加密的功能，就使用它。
-X <认证形态> 关闭指定的认证形态。
~~~

服务器无法访问可以使用 `telnet`

~~~bash
[root@mobai ~]# telnet json.im
Trying 150.109.147.28...
telnet: connect to address 150.109.147.28: Connection refused
~~~

> 这种就是端口没有打开或者`telnet`服务没有安装,需要在防火墙里面开启`23`端口访问或者安装`telnet`

```bash
[root@mobai ~]# telnet 127.0.0.1
Trying 127.0.0.1...
Connected to 127.0.0.1.
Escape character is '^]'.

Kernel 3.10.0-1160.45.1.el7.x86_64 on an x86_64
```

> 这样就是正常的, 然后按 ctrl + ],输入`quit`回车退出

### 检查域名是否可以解析

```bash
$ telnet json.imjson.im/telnet: Temporary failure in name resolution
```

- 确认本机的域名解析有关的设置是否正确（`/etc/resolv.conf`中`nameserver`的设置是否正确，如果没有，可以设置 `nameserver 114.114.114.114`）
- 确认防火墙是否放开了`UDP53`端口的访问（`DNS`使用`UDP`协议，端口`53`，使用`firewall-cmd`查看）

### 使用telnet测试端口情况

```bash
$ telnet [hostname] [port]
```

> 注意:`hostname`所在的服务器一定要安装`telnet`服务,并且开放`23`端口

## 参考链接

[Linux之telnet命令|入门笔记](https://rumenz.com/rumenbiji/linux-telnet.html)
