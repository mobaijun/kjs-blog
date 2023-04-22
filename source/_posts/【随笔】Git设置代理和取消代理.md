---
title: 【随笔】Git设置代理和取消代理
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 3938741716
tags:
  - 代理
categories:
  - 随笔
date: 2023-04-08 01:17:32
img:
coverImg:
password:
summary:
---

## 前言

很少拉取超过几个 GB 的仓库，但最近就是有这个需求，需要从 GitHub 拉取一个存放 PDF 的仓库，PDF 源文件小的有几 MB，大的有几十 MB，一个仓库大概有3GB左右，在启用全局代理的情况下，拉取速度还是很慢，保持在几十 KB 左右，换成 Git 代理来操作。

## 添加 https 和 htpp 代理

~~~bash
$ git config --global https.proxy http://127.0.0.1:1080

$ git config --global https.proxy https://127.0.0.1:1080

# 只对 github.com 生效(未测试)
$ git config --global http.https://github.com.proxy socks5://127.0.0.1:1080
~~~

### 取消代理

~~~bash
$ git config --global --unset http.proxy

$ git config --global --unset https.proxy
~~~

## 效果图

添加完代理下载这个仓库大概 3 分钟左右搞定。

![](https://tencent.cos.mobaijun.com/img/blog/【随笔】Git设置代理和取消代理/0.png)

效果还是很理想的！

### 参考地址

[git 设置和取消代理](https://gist.github.com/laispace/666dd7b27e9116faece6)
