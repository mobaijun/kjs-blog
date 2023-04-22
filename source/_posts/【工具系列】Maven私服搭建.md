---
title: 【工具系列】Maven私服搭建
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 3514918103
tags:
  - nexus
categories:
  - 工具
date: 2022-05-18 15:28:32
img:
coverImg:
password:
summary:
---

## 前言

> 最近在重构项目，接触到组件化开发，那么一些相关业务 jar 包自然不能上传到中央仓库，只能自己搭建私服进行管理，这里记录下踩坑步骤。

## 环境说明

* 操作系统：CentOS Linux 7 x64
* nexus 版本：3.38.1
* maven 版本：3.8.2
* Jdk 版本：1.8.0_332
* 本地操作系统版本：Windows 11 专业版 22000.613

## nexus 简介

  Nexus 是一个强大的 maven 仓库管理器,它极大的简化了本地内部仓库的维护和外部仓库的访问。它是一个简单的文件系统而不是数据库。

## nexus 作用

1. 提高下载速度

​	Nexus 作为私有库部署在局域网内部。假如多个人协同开发，开发人员 A 需要一个 log4j 的 jar 来实现系统日志功能，A 将 log4j 的坐标添加到自己模块的 pom 文件中，maven 会向公共仓库发送请求，下载 log4j 的 jar 包。下载的过程中，Nexus 也偷偷的保存了一份 log4j 在私有的仓库。那么以后再有开发人员需要 log4j 的时候，请求是直接发送到 Nexus 上请求资源的。就不需要访问外网了，否则每个人都需要访问公共 Maven 库下载资源。这样节省了流量，同时内网的网速一般也比公网快。也提高了工作效率。

1. 提高开发效率

​	多人协同开发，A 开发系统管理、B 开发考勤模块。考勤模块依赖了系统管理的员工接口，那么 B 需要手动拷贝 A 打包的 jar 到自己的工程中。当 A 改动了系统管理的接口，B 完全不知情，等出现问题了还需要联调，很麻烦！有了 Nexus A 就可以将系统管理打包发布到 Nexus 的私有仓库中，B 添加系统管理的坐标即可完成依赖，以后 A 再有改动，只要发布到 Nexus 上就可以了。减少了沟通成本。

## nexus 下载和启动

> Nexus Repository Manager 仓库管理有 2 个版本，专业版和 oss 版，oss 版是免费的，专业版是收费的，我们使用 oss 版。

* 下载地址：[Download](https://help.sonatype.com/repomanager3/product-information/download)
* 操作文档：[Installation Methods](https://help.sonatype.com/repomanager3/installation-and-upgrades/installation-methods)
* 官网下载非常慢，我已经把包上传到百度云盘，需要的自取：[7303](https://pan.baidu.com/s/1OAHE6iuyEaCPulRbdCuOWQ)

将你下载的 nexus 包上传到服务器目标安装目录并解压。

~~~bash
$ tar -zxvf nexus-3.38.1-01-unix.tar.gz
~~~

* 进入解压目录

~~~bash
drwxr-xr-x.  3 root root    73 May 18 16:05 bin # 包含nexus的启动脚本和相关配置
drwxr-xr-x.  2 root root    26 May 18 16:05 deploy # 上传
drwxr-xr-x.  7 root root   104 May 18 16:05 etc # jetty、karaf等配置文件
drwxr-xr-x.  5 root root   206 May 18 16:05 lib # java架包库
-rw-r--r--.  1 root root   651 Mar 23 04:17 NOTICE.txt
-rw-r--r--.  1 root root 17321 Mar 23 04:17 OSS-LICENSE.txt # 版权声明和法律细则
-rw-r--r--.  1 root root 41954 Mar 23 04:17 PRO-LICENSE.txt # 版权声明和法律细则
drwxr-xr-x.  3 root root  4096 May 18 16:05 public # 关于nexus应用在本地跑起来所需要的资源
drwxr-xr-x.  3 root root    59 May 18 16:05 replicator
drwxr-xr-x. 23 root root  4096 May 18 16:05 system # 应用所有的插件和组件
~~~

> 修改默认端口

* 工作目录：`/usr/local/nexus-3.38.1-01/etc/nexus-default.properties`

~~~properties
## DO NOT EDIT - CUSTOMIZATIONS BELONG IN $data-dir/etc/nexus.properties
##
# Jetty section
application-port=8010
application-host=0.0.0.0
nexus-args=${jetty.etc}/jetty.xml,${jetty.etc}/jetty-http.xml,${jetty.etc}/jetty-requestlog.xml
nexus-context-path=/

# Nexus section
nexus-edition=nexus-pro-edition
nexus-features=\
 nexus-pro-feature

nexus.hazelcast.discovery.isEnabled=true
~~~

* 启动 nexus 

非正式启动，主要是看看日志有没有异常或者中途失败查看日志比较方便，

~~~bash
$ ./nexus run
~~~

* 开放端口号

~~~bash
$ firewall-cmd --zone=public --add-port=8010/tcp --permanent
~~~

* 重启防火墙

~~~bash
$ systemctl restart firewalld
~~~

* 查看已开放端口列表

~~~bash
$ firewall-cmd --list-ports
~~~

如果没有什么意外的话，打开浏览器：[Welcome - Nexus Repository Manager](http://127.0.0.1:8010/)

> 就可以看到欢迎页了

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】Maven私服搭建/0.png)

> 停止后使用后台启动启动 nexus

```bash
$ ./nexus start
```

* 停止

```bash
$ ./nexus stop
```

* 重启查看状态重新加载配置等

~~~bash
$ ./nexus restart
$ ./nexus force-reload
$ ./nexus status
~~~

## 配置为系统服务

* 添加配置文件

~~~bash
$ vi /etc/systemd/system/nexus.service
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/usr/local/nexus-3.38.1-01/bin/nexus start
ExecStop=/usr/local/nexus-3.38.1-01/bin/nexus stop
User=root
Restart=on-abort

[Install]
WantedBy=multi-user.target
~~~

* 刷新系统服务&设置开机启动&启动服务

~~~bash
# 刷新系统服务
$ systemctl daemon-reload
# 设置开机启动
$ systemctl enable nexus.service
# 启动服务
$ systemctl start nexus.service
# 查看服务状态
$ systemctl status nexus.service
~~~

## 登录

* 登录 nexus

找到默认密码 `/usr/local/sonatype-work/nexus3/admin.password`

~~~bash
$ cat /usr/local/sonatype-work/nexus3/admin.password
~~~

登录会提示你修改默认密码。

## 配置

* 配置 nexus 仓库镜像为阿里云

> 阿里云地址：https://maven.aliyun.com/repository/central
>
> 点击设置，仓库配置，新建仓库

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】Maven私服搭建/1.png)

* 找到 maven 2 proxy（配置阿里云镜像）

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】Maven私服搭建/2.png)

> 确认后点击 🆗 ，拉到最下方，新建仓库即可，查看列表

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】Maven私服搭建/3.png)

* 配置 maven 2 仓库 (上传 jar 包的仓库)

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】Maven私服搭建/4.png)

> 说明：
>
> - 仓库名称：nexus-aliyun，类型为proxy。maven仓库有三种类型，hosted、proxy、group。hosted 代表私服本机服务器，proxy 代理外部仓库服务器，group 整合各个 hosted 和 proxy，按顺序策略获取 jar。
> - 这里选择 Version policy 为：Release。正式发布版本。正式发布版本都上传到这里来。
> - Deployment policy: 选择为 Allow Redeploy，可重复发布。代表同一个版本号的jar可以多次发布。这样就不必要设置快照仓库了，项目小改动也作为正式版本发布上去，不必要修改版本号。

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】Maven私服搭建/5.png)

## 配置项目上传 jar 到私服

* 配置本地的 maven，

> 配置 maven 的 settings.xml
>
> 注意：仓库url地址是从 nexus后台 上创建仓库后得到的

~~~xml
<!-- 在 profiles 标签里 新加 profile文件 -->
<profile>   
	<!--profile的id-->
	<id>dev</id>   
	<repositories>   
	  <repository>  
		<!--仓库id，repositories可以配置多个仓库，保证id不重复-->
		<id>nexus</id>   
		<!--仓库地址，即nexus仓库组的地址-->
		<url>http://192.168.1.3:8010/repository/luban-repo/</url>   
		<!--是否下载releases构件-->
		<releases>   
		  <enabled>true</enabled>   
		</releases>   
		<!--是否下载snapshots构件-->
		<snapshots>   
		  <enabled>true</enabled>   
		</snapshots>   
	  </repository>   
	</repositories>  
	<pluginRepositories>  
		<!-- 插件仓库，maven 的运行依赖插件，也需要从私服下载插件 -->
		<pluginRepository>  
			<!-- 插件仓库的 id 不允许重复，如果重复后边配置会覆盖前边 -->
			<id>public</id>  
			<name>Public Repositories</name>  
			<url>http://192.168.1.3:8010/repository/luban-repo/</url>  
		</pluginRepository>  
	</pluginRepositories>  
</profile>

<!-- 在 settings 标签 里启用上面配置的 profile -->
<activeProfiles>
	<activeProfile>dev</activeProfile>
</activeProfiles>
~~~

> 如果配置了没有生效，很大可能是你的IDE软件没有引用 这个maven的配置，idea默认就是用的自带的maven插件，可以直接idea maven插件里面的settings.xml或者改成你自己下载的maven。

## 上传私服的jar包

* 除了引入上面的 settings.xml 的配置，还需要加入对私服的访问权限信息

```xml
<!-- 在 servers 标签 里添加 -->
<server>
 <id>releases</id>
  <username>admin</username>
  <password>admin</password>
</server>
<server>
  <id>snapshots</id>
  <username>admin</username>
  <password>admin</password>
</server>
```

* 配置 maven 项目的 pom.xml 文件

```xml
<!-- 直接在 project 标签中配置即可 -->
<distributionManagement>
    <repository>
        <id>releases</id>
        <name>Nexus Release Repository</name>
        <url>http://192.168.1.3:8010/repository/luban-repo/</url>
    </repository>
    <snapshotRepository>
        <id>snapshots</id>
        <name>Nexus Snapshot Repository</name>
        <url>http://192.168.1.3:8010/repository/luban-repo/</url>
    </snapshotRepository>
</distributionManagement>
```

配置好后，就可以直接通过IDEA的 deploy 部署推送到私服仓库了,也可以使用命令行

~~~bash
$ mvnd celan deploy
~~~

查看 nexus 是否上传成功

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】Maven私服搭建/6.png)

> 完结撒花🌹🌹🌹🌹🌹🌹🌹🌹🌹
