---
title: 【Linux系列】Linux之cat命令高级版ccat安装使用
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 2794786039
tags:
  - cat命令
categories:
  - Linux
date: 2021-06-02 16:57:49
img:
coverImg:
password:
summary:
---

---

## 介绍

此方法对于Centos，ubuntu，及mac通用

采用下载二进制文件方式使用这个命令，系统自带的源是没有这个软件包的

### 下载ccat包

~~~bash
# -P参数是指定下载存放的位置，我存放在/usr/local目录下
$ wget https://github.com/owenthereal/ccat/releases/download/v1.1.0/linux-amd64-1.1.0.tar.gz -P /usr/local
~~~

> 其他版本可以去GitHub查看

~~~bash
# 其他版本
$ https://github.com/owenthereal/ccat
~~~

* 解压下载的ccat包

~~~bash
$ tar -zxvf linux-amd64-1.1.0.tar.gz
~~~

* 将*ccat*移动到二进制文件目录

~~~bash
# 进入目标目录
$ cd linux-amd64-1.1.0
# 移动ccat到/usr/bin/
$ mv ccat /usr/bin/ccat
~~~

* 接着给这个文件赋予可执行权限

~~~bash
$ chmod +x /usr/bin/ccat
~~~

> 之后就可以和*cat*一样执行命令了

## 其他

> 如果你觉得*ccat*比*cat*好，而且我以后不想使用*cat*了，想用*ccat*来代替*cat*，两个方法

### 别名

```bash
# 注意，我使用的是bash
$ vim ~/.bashrc
# 添加此列
$ alias cat=ccat
```

* 之后使配置文件生效

```bash
$ source ~/.bashrc
```

* 接着直接输入*cat*就相当于使用*ccat*了

### 覆盖

再者就是直接覆盖掉之前的*cat*二进制命令

```bash
$ cp -f /usr/bin/ccat /usr/bin/cat
```

![](https://tencent.cos.mobaijun.com/article_with_pictures/3.jpg)