---
title: 【前端系列】Node.js更换国内源
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - Node
categories:
  - 前端
abbrlink: 3059858801
date: 2021-02-02 16:30:03
img:
coverImg:
password:
summaran:
---

# 安装 Cnpm 插件

## 安装命令

~~~bash
$ npm install -g cnpm --registry=https://registry.npm.taobao.org
~~~

## 更新 Cnpm 版本

~~~bash
$ cnpm install cnpm -g
~~~

## 进行指令操作

> 进行指令操作（操作和npm 完全一致）

~~~bash
$ cnpm install --global vue-cli
~~~

> 或者利用npm配合淘宝镜像

~~~bash
$ npm install --global vue-cli --registry=https://registry.npm.taobao.org
~~~

## 验证

~~~bash
$ cnpm -v
~~~



# 更换源操作

> 重度Node.JS使用患者，无法忍受下载插件速度慢，遂记下更换源步骤，更换源很简单，三条命令

## 临时使用

~~~bash
$ npm --registry https://registry.npm.taobao.org install express
~~~

### 永久使用

~~~bash
$ npm config set registry https://registry.npm.taobao.org
~~~

## 验证

~~~bash
$ npm config get registry
~~~

