---
title: 【Linux系列】Linux学习笔记
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - Centos7
categories:
  - Linux
abbrlink: 3003968415
date: 2020-06-04 17:49:06
img:
coverImg:
password:
summary:
---

### Linux介绍

* Windows的不足
  * Windows是收费的
  * 系统长时间运行，安装多了，系统越来越慢，越来越不稳定。
  * 病毒和流氓软件很多
* Linux的优势
  * Linux系统是免费，很多还是开源的。
  * 长时间运行，很稳定的
  * 几乎没有病毒和流氓软件

#### 学习Linux的好处

学会对Linux的基本操作是后端JavaEE程序员的必修课。做为一个后端JavaEE程序员，通常在Windows中开发完程序后，需要部署到一个相对比较安全，稳定的服务器中运行，这台服务器上安装的往往不是Windows操作系统，而是Linux操作系统。

windows默认安装完成软件就可以连外网，linux默认安装完软件是不可以连外网，必须防火墙放过才可以

##### linux的概述

Linux(linux is not unix)是基于Unix的开源、免费、多用户、多任务的操作系统，由于系统的稳定性和安全性。几乎成为程序代码运行的最佳系统环境。

##### linux的分类

* 按照市场的需求不同

  * 图形界面
  * 字符界面(推荐)，特点：性能最优

* 按照原生程度不同

  * 内核版，linux之父（托瓦兹）团队开发

    * 特点：免费

      ​	功能：主要解决操作系统底层，操作内存，cpu，硬盘，网卡。。。

  * 发行版（推荐使用）

    * 是第三方个人或组织在内核基础上进行二次开发（包装）
    * ​	特点：功能应用更多，偏向应用，大多数发行版都是免费的

### Linux安装

两种安装方式

* 在PC电脑上进行安装
* 使用虚拟机安装

常见虚拟机软件

* VMWare 软件,威睿公司，收费的（推荐使用，可以试用）
* VirtualBox软件，免费的，  最开始是sun公司，由于被oracle收购了，所以目前属于oracle

### windows主机连接linux虚拟机与虚拟机网卡介绍

| 命令     | 含义                        |
| -------- | --------------------------- |
| ifconfig | linux系统用于查看ip地址信息 |
| ip addr  | linux系统用于查看ip地址信息 |

在windows主机上使用dos命令ping进行拼通linux系统

~~~bash
ping www.mobaijun.com
~~~

### 使用客户端工具连接linux系统

#### 常见的客户端软件

​	SecureCRT(操作客户端命令)，SecureFx（用于传输文件）

​	XShell(操作客户端命令),XFtp（用于传输文件）

### 目录操作

#### 目录结构

> linux系统没有盘符，一切从根目录/开始，如下图

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Linux学习笔记/0.png)

> 根目录下所有子目录

![image-20200525150911453](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Linux学习笔记/1.png)

#### 常见的目录配置

|   目录   | 含义                                                         |
| :------: | ------------------------------------------------------------ |
| bin目录  | 存放着所有linux系统的命令                                    |
| root目录 | 超级管理员root用户的主目录                                   |
| home目录 | 存放所有普通用户主目录的位置                                 |
| usr目录  | （unix shared resources）资源共享目录，所有用户都可以操作的目录，以后我们安装软件就安装到这里usr/local,这样所有用户都可以使用软件 |
| etc目录  | 存储配置文件的目录，以后网卡配置文件，权限配置文件都在这里   |

#### 目录操作—切换—创建—查看

| 作用 | 改变目录/CD和目录名直接需要空格 |
| ---- | ------------------------------- |
| /    | 切换到根目录                    |
| .    | 当前目录                        |
| ..   | 上一级目录                      |
| ~    | 返回当前用户主目录              |
| -    | 返回上一次目录                  |

#### 创建目录

| mkdir 目录名称 | 创建一个目录 |
| -------------- | ------------ |
| mkdir -p       | 创建多级目录 |

~~~bash
mkdir -p /父目录名称/子目录名称
~~~

> -p，如果父目录不存在会先创建父目录再创建子目录

#### 查看目录内容

| ls参数 | 显示当前目录下的文件和目录                                   |
| ------ | ------------------------------------------------------------ |
| -l     | 以详细的方式显示当前目录下的文件和目录                       |
| -a     | 显示当前目录下的所有文件和目录,包含隐藏目录,.XXX开头的文件和目录是隐藏的 |

#### 目录操作搜索—重命名—复制—删除—帮助

| find               | [目录名称] [-name'查询字符串']             |
| ------------------ | ------------------------------------------ |
| 无参数             | 搜索当前目录和它的子目录所有文件和目录     |
| 目录名称           | 搜索指定目录下和他的子目录所有的文件和目录 |
| -name '查询字符串' | 指定具体查询字符串                         |
|                    | *匹配多个字符串                            |
|                    | ?匹配一个字符                              |

#### 重命名与移动

* 重命名

| move=mv                    |      |
| -------------------------- | ---- |
| mv 旧名称 新名称           |      |
| mv既可以改文件也可以改目录 |      |

* 移动

| mv 源目录 目标目录         |      |
| -------------------------- | ---- |
| mv将源目录移动到目标目录下 |      |

* 复制

| cp [参数] 源文件或目录 目标目录 将源文件或整个目录复制到目标目录下 |      |
| ------------------------------------------------------------ | ---- |
| -r recursion连同子目录下所有文件全部复制                     |      |

* 删除

| rm   | 参数 文件或目录1                        文件或目录2可以同时指定多个文件或目录 |
| ---- | ------------------------------------------------------------ |
| -r   | recursion 连同子目录一起删除,只用来删除目录                  |
| -f   | 强制删除,删除之前会确认,需要回答yes/no                       |

> 注意：千万不要rm -rf /*  会导致删除所有的文件或目录，导致系统崩溃了

* 查看帮助文档
  * 命令  --help  查看英文文档手册，使用q退出
  * man 命令     查看中文文档手册【推荐方式】，使用q退出

#### 创建文件与查看文件内容

| touch 文件1 文件2   | 创建一个或多个文件0字节大小                                  |
| ------------------- | ------------------------------------------------------------ |
| cat 文件名          | 查看文件所有内容                                             |
| more 文件名         | 查看文件所有的内容,可以分屏显示                              |
| head 文件名         | 查看文件前10行                                               |
| had -n 行数 文件名  | 查看前面指定的行数                                           |
| tail 文件名         | 查看文件后10行                                               |
| tail -n 行数 文件名 | 查看文件后指定的行数                                         |
| less 文件名         | 查看文件所有内容<br />-n 显示行号<br />PageUp 向前翻页<br />PageDown 向后翻页<br />q:退出 |

#### 编辑文件内容

![image-20200525154146121](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Linux学习笔记/2.png)

* 命令模式下命令

| 命令                           | 描述                                         |
| ------------------------------ | -------------------------------------------- |
| i                              | 在当前光标的前面插入字符                     |
| a                              | 在当前光标的后面插入字符                     |
| o                              | 在当前光标的下一行插入字符                   |
| 命令或底行模式下常用的编辑命令 |                                              |
| yy                             | 复制当前行                                   |
| p                              | 如果前面已经复制了,在当前下面复制            |
| dd                             | 删除当前行                                   |
| u                              | 撤销                                         |
| /字符串                        | 搜索文本内容<br />n:向后搜索<br />N:向前搜索 |
| wp                             | 保存并退出                                   |
| q!                             | 不保存强制退出                               |
| wp!                            | 强制保存退出(只读文件使用)                   |

#### 压缩与解压

| 拓展名称  | 分类                    |
| --------- | ----------------------- |
| .zip/.rar | Windows系统压缩包       |
| .tar      | 在Linux下的打包文件     |
| .gz       | 在Linux下的压缩文件     |
| .tar.gz   | 在Linux下的打包压缩文件 |

* 压缩文件

| tar              | 参数 压缩包名 一个或多个文件{对一个或多个文件进行打包并压缩} |
| ---------------- | ------------------------------------------------------------ |
| -c               | 创建一个打包的文件                                           |
| -v               | 显示打包的详细过程                                           |
| -z               | 压缩文件                                                     |
| -f<压缩文件名称> | 只当压缩包的文件名称,f后面跟着压缩的文件名,一般放在参数最后面 |

* 解压文件

| tar 参数 压缩文件名称 | 解压文件到当前目录 |
| --------------------- | ------------------ |
| -x                    | 解压指定的文件     |
| -v                    | 显示解压的详细过程 |
| -f<压缩文件>          | 指定要解压的文件   |
| -C                    | 解压到指定的目录下 |

#### 查看工作目录位置—查看进程—内存耗用—杀死进程

* 查看进程

| pwd  | 查看当前工作目录                       |
| ---- | -------------------------------------- |
| ps   | 显示当前用户通过终端启动的进程         |
| -a   | 显示所有用户通过终端启动的进程         |
| -u   | 显示所有用户通过终端启动的进程详细信息 |
| -x   | 显示所有用户的所有进程                 |

* 杀死进程

| kill 参数 进程号 | 通过ps可以查看到进程号 |
| ---------------- | ---------------------- |
| -9               | 强制终止进程           |

* 查看系统内存整体耗用

| top                  |
| -------------------- |
| 查看系统内存整体耗用 |

### 搜索文件内容

> grep是一种强大的文本搜索工具，它能使用字符串搜索文本，并把匹配的行和行号打印出来。

* 搜索

| grep 参数 字符串 文件名 | 搜索指定文件中字符串内容 |
| ----------------------- | ------------------------ |
| -n                      | 搜索结果中显示行号       |
| -v                      | 显示不匹配的行           |
| -i                      | 忽略大小写搜索           |

### 管道

> 管道就是“|”

* 命令

| 语法 | 命令1 \| 命令2                            |
| ---- | ----------------------------------------- |
| 解释 | 管道命令\|,必须要有两条以上的命令参与运算 |

### 关机与重启

* Linux/Windows

| Linux             | 释义             |
| ----------------- | ---------------- |
| shutdown now      | 关闭服务器       |
| -h  +参数         | 指定**时间后关机 |
| shutdown -n 16:05 | 指定时间关机     |
| shutdown -c       | 清除定时命令     |
| reboot            | 重启Linux        |
| **Windows命令**   | **释义**         |
| shutdown -s       | 立刻关机         |
| shutdown -s -t 秒 | 指定多少秒后关机 |
| shutdown -a       | 清除定时计划     |
| shutdown -r       | 系统重启         |

### 文件权限

![image-20200525160550045](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Linux学习笔记/3.png)

* 每一类用户都有3个权限
  * r：读取权限， 只读
  * w: 写入权限 ， 可以编辑文件
  * x:  执行权限， 由于某些文件是可以执行的，如有有执行权限才可以执行
* 操作权限
  * 添加权限：chmod 用户或组+权限  资源文件或目录
  * 删除权限：chmod 用户或组-权限  资源文件或目录
  * 修改权限：chmod 用户或组=权限  资源文件或目录

### crontab定时任务

| 命令           | 含义                           |
| -------------- | ------------------------------ |
| crontab -l     | 查看当前用户的定时任务列表     |
| crontab -e     | 进入编辑当前用户定时任务编辑器 |
| crontab -r     | 删除当前用户的定时任务         |
| * * * * * 命令 | 每分钟执行一次命令             |

### 服务管理—自启动服务管理

![image-20200525161016493](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Linux学习笔记/4.png)

* 服务管理的命令：systemctl start/stop/restart/status 服务名  操作服务启动/停止/重启/查看状态

* 设置服务开机启动：systemctl enable 服务名.service

* 设置服务开机不启动：systemctl disable 服务名.service

#### 网络管理1-主机名管理

* 主机名称命令

~~~bash
# 查看主机名
$ hostname
# 修改主机名称 永久修改计算机名字，需要重启或使用bash刷新
$ hostnamectl set-hostname [args]
# 刷新
$ bash
~~~

#### 网络管理2-网络服务管理

~~~bash
# 启动网络
$ systemctl start network
# 停止
$ systemctl stop network
# 重启
$ systemctl restart network
# 查看状态
$ systemctl status network
~~~

> 如果linux系统不能上网（内网和外网），需要检查网络服务

#### 网络管理3-网卡激活管理

* 关闭网卡激活实现步骤

~~~bash
# 找到网卡配置文件ens32
$ cd /etc/sysconfig/network-scripts/ # 网卡配置文件目录
# 查看目录文件
$ ls
# 修改配置文件
$ vim ifcfg-ens32
# 修改配置,关闭网卡
ONBOOT=no
# 重启网络服务
$ systemctl restart network
# 测试是否可以联网
$ ping www.mobaijun.com
# 修改配置/激活网卡 修片配置文件ifcfg-ens33,开启网卡
$ ONBOOT=yes
# 重启网络服务
$ systemctl restart network
~~~

#### 网络管理4-配置静态ip

* IP配置类型
  * **dhcp:动态IP**
  * **static:静态IP**
* 配置静态IP步骤
  * 给linux系统设置ip必须确定ip的地址、子网掩码、网关
  * **IP地址(互联网协议地址):**
    * IP地址由网络号和主机号组成
  * **子网掩码**
    * 用于标识ip地址的网络号是多少位
  * **网关**
    * 用于区别不同的网络，网关可以解决不同的网络通信，需要硬件支持路由器
  * **DNS**
    * 域名服务器，根据域名获取对应的服务器ip地址，这样才可以访问外网
* 修改网卡配置

~~~bash
# 找到网卡配置文件ens32
$ cd /etc/sysconfig/network-scripts/ # 网卡配置文件目录
# 查看目录文件
$ ls
# 修改配置文件
$ vim ifcfg-ens32
# 修改配置,切换成静态模式
BOOTPROTO=static
# 最下方添加相关内容
IPADDR=192.168.56.135
GATEWAY=192.168.123.83
NETMASK=255.255.255.0
DNS1=114.114.114.114
# 重启网络服务
$ systemctl restart network
# 测试是否可以联网
$ ping www.mobaijun.com
~~~

#### 网络管理5-克隆虚拟电脑

* **克隆步骤**
  * **关闭当前虚拟机linux系统**
  * **选择当前虚拟机/管理/克隆/**
  * **修改克隆出来的静态ip**
  * **修改计算机的名字**

#### 网络管理6-域名映射

* ##### url域名访问服务器通信原理


![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Linux学习笔记/5.png)

* 本地域名映射文件位置
* Windows系统本地域名映射位置:
  * `c:\windows\System32\drivers\etc\hosts`
* Linux系统本地域名映射位置:
  * `/etc/hosts`
* 修改本地域名映射实现步骤

~~~bash
# 编辑本地etc/hosts域名映射文件
$ vim /etc/hosts
# 添加域名映射IP的配置
192.168.123.83 www.mobaijun.com
# 保存退出
$ wq
# 测试效果
$ ping www.mobaijun.com
~~~

#### 网络管理7-查询网络进程使用端口号

常用命令

| netstat [args] | null     | 显示网络状态             |
| -------------- | -------- | ------------------------ |
| -n             | number   | 显示程序的IP地址和端口号 |
| -t             | TCP      | 只显示TCP协议链接的程序  |
| -l             | listener | 显示监听中的Socket       |
| -p             | Programs | 显示程序的名称           |
| -u             | UDP      | 查询udp协议通信的程序    |

~~~bash
# 查看端口、udp、tcp、正在监听、显示程序名的所有程序
$ netstat -nutlp
~~~

#### 防火墙管理

>* 防火墙作用
>
>是防止外界访问系统内部的程序，防火墙允许哪个软件访问外网，这个软件才可以进行网络通信

| 命令                        | 简介               |
| --------------------------- | ------------------ |
| systemctl status firewalld  | 查看状态           |
| systemctl start firewalld   | 启动防火墙         |
| systemctl stop firewalld    | 关闭防火墙         |
| systemctl enable firewalld  | 开机自启           |
| systemctl disable firewalld | 让防火墙开机不自启 |

#### SSH有密登录和免密登录

* **SSH实现免密登录步骤**

~~~bash
# 在本地生成一对公钥和私钥
$ ssh-keygen
# 将公钥发送给远程服务器,必须给出远程服务器的密码本地才接收公钥
$ ssh-copy-id address
# 查看公钥
$ cat authorized_keys
# 发送登录请求，实现免密登录
$ ssh address
~~~

### 部署项目

#### 本地软件安装命令rpm

> RedHat Package Manager(RPM)， 擅长安装本地的软件
>
> * rpm的作用
>   * 查询已安装的软件
>   * 安装软件
>   * 卸载软件

* 常用命令

| rpm [args] [包名] | 类似软件管家{添加,卸载,查询}                     |
| ----------------- | ------------------------------------------------ |
| -v                | 显示安装的详细过程                               |
| -q                | 查询某个软件是否安装                             |
| -a                | 查询所有软件                                     |
| -h                | 列出软件安装时的标记                             |
| -i <args>         | install 安装指定的软件                           |
| --nodeps          | 不验证软件相关关联性,常于-e一起使用,表示强制卸载 |

* 测试

~~~bash
# 查询所有已安装软件
$ rpm -qa
# 安装指定的软件包
$ rpm -ivh <包名>
# 强制卸载指定软件包
$ rpm -e --nodeps <包名>
~~~

#### RPM_jdk安装

~~~bash
# 查询本地是否有JDK
$ rpm -qa | grep java
# 查询是否安装JDK
$ rpm -qR jdk
# 新建soft包存放未解压的安装包
$ mkdir soft
# 将jdk软件上传到linux系统/soft目录下并解压到指定目录
$ tar -xvf jdk-8u251-linux-x64.tar.gz -C /usr/local
# 配置linux的jdk环境变量，操作一个/etc/profile环境变量配置文件
$ vim /etc/profile
# 配置环境变量
#set java environment
JAVA_HOME=/usr/local/jdk1.8.0_251
CLASSPATH=.:$JAVA_HOME/lib
PATH=$JAVA_HOME/bin:$PATH
export JAVA_HOME CLASSPATH PATH
# 重载环境变量配置文件
$ source /etc/profile
# 查看jdk环境变量是否配置成功
$ java -version
~~~

#### 更换YUM源

~~~bash
# 安装wget
$ yum install -y wget
# 下载CentOS 7的repo文件
$ wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
# 清除缓存
$ yum clean all
# 生成缓存
$ yum makecache
# 备份CentOS 7系统自带yum源配置文件
$ mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
# 打开CentOS-Base.repo文件,将文件中的所有http开头的地址更改为https
$ vim /etc/yum.repos.d/CentOS-Base.repo
# 更新YUM
$ yum update
~~~

#### mysql安装-启动-远程授权

* MySQL安装

~~~bash
# 查看CentOS是否自带的MySQL，如果已经安装需要卸载。如果没有找到，则表示没有安装
$ rpm -qa | grep mysql
# 在线获取CentOS7的mysql的rpm安装文件，直接执行如下命令：
$ wget https://repo.mysql.com//mysql80-community-release-el7-1.noarch.rpm
# 执行安装命令
$ rpm -ivh mysql80-community-release-el7-1.noarch.rpm
# 得到两个配置文件，进入/etc/yum.repos.d目录下查询
$ cd /etc/yum.repos.d 
# 编辑mysql-community.repo文件，配置资源库下载版本选择
$ vim mysql-community.repo
# 编辑需要下载的MySQL版本将`enable=0`改为`enable=1`
{
[mysql55-community]
name=MySQL 5.5 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.5-community/el/7/$basearch/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
}
# 下载安装客户端、服务器端、工具包
$ yum -y install mysql-community-client mysql-community-server mysql-community-devel
~~~

* 启动

~~~bash
# 启动MySQL
$ systemctl start mysqld
# 将mysql加到系统服务中并设置开机启动
$ systemctl enable mysqld
# 登录mysql，root用户默认没有密码
$ mysql -uroot
# 在mysql中修改自己的密码
$ set password = password('root');
# 退出
$ exit
# 重新登录
$ mysql -uroot -proot
~~~

* 设置远程连接权限、开放端口号

  > 开启mysql的远程登录权限，默认情况下mysql为安全起见，不支持远程登录mysql，所以需要设置开启，并且刷新权限缓存。远程登录mysql的权限登录mysql后输入如下命令

  ~~~bash
  # 开启mysql的远程登录权限
  $ grant all privileges on *.* to 'root'@'%' identified by 'root';
  # 刷新权限缓存
  $ flush privileges;
  ~~~

* 开放Linux的对外访问的端口3306

~~~bash
# 开放的端口永久保存到防火墙
$ firewall-cmd --zone=public --add-port=3306/tcp --permanent
# 重启防火墙
$ systemctl restart firewalld
~~~

* Navicat测试

#### tomcat安装-启动

* [下载Tomcat](https://tomcat.apache.org/download-80.cgi)

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Linux学习笔记/6.png)

~~~bash
# 将软件上传到linux系统/soft目录下并解压
$ tar -xvf apache-tomcat-8.5.55-src.tar.gz  -C /usr/local/
# 改名
$ mv apache-tomcat-8.5.55-src tomcat8
# 进入bin目录
$ cd /usr/local/apache-tomcat-8.5.55-src/bin
# 启动tomcat服务器
$ ./startup.sh
# 提示权限不够解决方案
$ chmod u+x *.sh
# 重启应用服务
$ ./startup.sh
# 开放linux系统防火墙8080端口
$ firewall-cmd --zone=public --add-port=8080/tcp --permanent
# 检查是否生效
$ firewall-cmd --zone=public --query-port=8080/tcp
# 重启防火墙
$ systemctl restart firewalld
# windows客户端使用浏览器访问linux的8080端口tomcat
$ 192.168.123.83:8080
# tomcat无法找到JAVA_HOME解决方案
# 查看环境变量是否有问题
$ echo $JAVA_HOME
$ echo $JRE_HOME
# 定位到tomcat/bin/setclasspath.sh目录下,文件开头添加环境变量
JAVA_HOME=/usr/local/jdk1.8.0_251
JRE_HOME=/usr/local/jdk1.8.0_251/jre
# 删除tomcat和日志文件
$ rm -rf /usr/local/tomcat
$ rm -rf /usr/local/logs/*.txt &
$ rm -rf /usr/local/logs/*.log &
~~~

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Linux学习笔记/7.png)

#### Redis安装-启动

~~~bash
# 添加EPEL Repository
$ yum install epel-release
# 更新yum
$ yum update
# 安装Redis
$ yum install redis
# 启动Redis
$ systemctl start redis
# 设置开启启动
$ systemctl enable redis
# 验证Redis是否安装成功 /如果返回PONG，说明Redis安装成功
$ redis-cli ping
# 设置Redis密码/打开Redis配置文件/找到# requirepass foobared，取消注释，将foobared 改成你的密码
$ vi /etc/redis.conf
# 全局查找,修改密码
$ requirepass root
# 然后重启redis服务
$ systemctl restart redis
# 使用AUTH验证登录
$ redis-cli
$ 127.0.0.1:6379> AUTH root
# 开启Redis远程连接打开Redis配置文件，找到bind 127.0.0.1，取消注释，将127.0.0.1 修改为 0.0.0.0 或 服务器的ip地址。别忘了重启 redis 服务
$ vi /etc/redis.conf
# 然后重启redis服务
$ systemctl restart redis
# 配置防火墙开放6379端口
$ firewall-cmd --permanent --zone=public --add-port=6379/tcp
$ firewall-cmd --reload
# 检查是否生效
$ iptables -L -n | grep 6379
# 远程连接
$ redis-cli -h 192.168.116.128
$ 192.168.56.2:6379> AUTH root
~~~

#### Git安装-启动

~~~bash
# 安装git
$ yum install git
# 验证版本
$ git --version
# 配置基本信息
$ git config --global user.name "mobaijun"
$ git config --global user.email "mobaijun8@163.com"
# 验证配置
$ git config --list
~~~

#### 项目发布

* 链接Linux数据库(导入数据库)
* 在IDEA中导出war包
* 将war包部署到linux里面的tomcat里面的webapps里面
* 浏览器访问

#### 解决mysql底层乱码问题

* 修改`druid.properties`配置文件，设置mysql使用utf-8解码，添加`?characterEncoding=utf8`

~~~properties
driverClassName=com.mysql.jdbc.Driver
url=jdbc:mysql://127.0.0.1:3306/linux?characterEncoding=utf8
username=root
password=root
initialSize=5
maxActive=50
maxWait=30000
minIdle=3
~~~

* **将当前项目需要重新打包，再部署到linux上tomcat的webapps里面**
* **关闭tomcat,执行shutdown.sh**
* **启动tomcat,执行startup.sh**

### 用户管理

#### 用户的管理

* 添加用户

~~~bash
# 添加用户,进入/home文件夹/创建用户和主目录
$ cd /home
# 查看
$ ll
# 创建组名
$ useradd -m mobaijun
# 查看
$ ll
# 创建用户名
$ useradd -mg mobaijun tom
# 查看
[root@mobai home]# ll
总用量 0
drwx------. 2 mobaijun mobaijun 62 5月  29 11:25 mobaijun
drwx------. 2 tom      mobaijun 62 5月  29 11:25 tom
# 查看/etc/passwd用户内容
$ cat /etc/passwd
# passwd文件用户内容
mobaijun:x:1000:1000::/home/mobaijun:/bin/bash
tom:x:1001:1000::/home/tom:/bin/bash
~~~

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Linux学习笔记/8.png)

* 给用户设置密码并切换用户

~~~bash
# 设置密码
$ passwd mobaijun
# 切换用户
$ su mobaijun
~~~

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Linux学习笔记/9.png)

* 删除用户

~~~bash
# 切换回主目录
$ su root 
# 删除用户组
$ userdel -r tom
~~~

![](https://tencent.cos.mobaijun.com/img/blog/【Linux系列】Linux学习笔记/10.png)

* 修改登录名

~~~bash
# 修改登录名称
$ usermod -1 Rose mobaijun
~~~

**总结**

* **useradd:添加用户**
* **passwd:给用户设置密码**
* **su:切换用户**
* **userdel:删除用户**
* **usermod:修改用户登录名**

#### 组与用户的管理

* 添加组

~~~bash
# 添加组
$ groupadd [组名]
# 查看组
$ cat /etc/group
~~~

* 用户添加指定组

~~~bash
# 进入主目录
$ cd /home
# 修改用户组名称
$ usermod -g [新组名] [组名]
~~~

* 用户从指定组中删除

~~~bash
# 用户从指定组中删除
$ gpasswd -d 用户 组名
# 查看
$ ll
# 查看配置文件
$ cat /etc/group
~~~

* 修改组名

~~~bash
# 修改组名
$ groupmod -n 新组名 组名
~~~

* 删除组

~~~bash
# 删除组
$ groupdel 组名
# 查看
$ cat /etc/group
~~~

**总结**

* **groupadd:添加组**
* **gpaddwd:将用户从组中删除**
* **groupmod:修改组名**
* **groupdel:删除组**

#### 给普通用户设置 sudo超级管理权限

~~~bash
# 编辑配置文件
$ vim /etc/sudoers
# 切换用户
$ su mobaijun
# 设置权限
$ sudo useradd -m 用户名
# 查看
$ cd /home
~~~

### 其他

[相关内容](https://my.oschina.net/u/3803405/blog/1791255)

~~~bash
# 列出所有可更新的软件包  
$ yum list updates 
# 列出所有已安装的软件包 
$ yum list installed 
# 列出所有已安装但不在 Yum Repository 内的软件包 
$ yum list extras 
# 搜索yum包
$ yum search PACKAGE_NAME
# 列出所有可更新的软件包信息 
$ yum info updates 
# 列出所有已安装的软件包信息 
$ yum info installed 
# .列出软件包提供哪些文件 
$ yum provides
# 更新具体的yum包
$ yum update PACKAGE_NAME
# 清除yum缓存
$ yum clean all
# 卸载yum包装
$ yum remove PACKAGE_NAME
# 取出yum包装
$ yum downloader PACKAGE_NAME
# 重新安装一个yum包
$ yum reinstall PACKAGE_NAME
# 查可以更新的软件包
$ yum check-update 
~~~
