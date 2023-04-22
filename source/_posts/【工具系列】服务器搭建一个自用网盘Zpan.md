---
title: 【工具系列】服务器搭建一个自用网盘Zpan
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 3473890439
tags:
  - Zpan
categories:
  - 工具
date: 2022-03-05 11:10:23
img:
coverImg:
password:
summary:
---

## 前言

我想要搭建一个网盘的原因仅仅是因为 U盘 我觉得不好使。

## 什么是 Zpan ？

ZPan 致力于打造一款不限速的网盘系统，因此采用客户端直连云存储的方式进行设计。

目前 ZPan 支持所有兼容 S3 协议的云存储平台，您可以选用您熟悉的平台来驱动 ZPan。

[在线体验](http://zpan.saltbo.cn/)(体验账号：demo，密码：demo)

## Zpan 特色

* 完全不受服务器带宽限制
* 支持所有兼容S3协议的云存储
* 支持文件及文件夹管理
* 支持文件及文件夹分享（未登录可访问）
* 支持文档预览及音视频播放
* 支持多用户存储空间控制
* 支持多语言

## 快速开始

### 以系统服务安装 Zpan

~~~bash
# 创建工作目录
$ mkdir ~/netdisc

# 进入工作目录
$ cd netdisc

# 安装服务
$ curl -sSf https://dl.saltbo.cn/install.sh | sh -s zpan

# 启动服务
$ systemctl start zpan

# 查看服务状态
$ systemctl status zpan

# 设置开机启动
$ systemctl enable zpan

# 查看日志
$ journalctl -xe -u zpan -f
~~~

### Docker 安装

> 推荐使用 Docker 进行安装。

~~~bash
$ docker run -dit -p 8222:8222 -v /usr/local/zpan:/etc/zpan --name zpan saltbo/zpan
~~~

### 访问

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】服务器搭建一个自用网盘Zpan/0.png)

> 第一次访问的页面需要根据你选择的数据库来配置
>
> * user：数据库用户
> * pass：数据库密码
> * localhost：修改为你数据库的IP地址
>
> 然后执行下一步即可。

### 设置存储桶

点击头像，进入管理后台，点击存储管理，创建存储

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】服务器搭建一个自用网盘Zpan/1.png)

有多个平台可供选择，根据你选择的平台填入相关参数即可使用。设置完毕以后，点击左上角图标，进入文件管理区域。

在这里可以上传，分享，下载，删除文件等操作。

> 官网文档链接：[传送门](https://zpan.space/#/)
