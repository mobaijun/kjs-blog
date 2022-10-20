---
title: 【随笔】npm-更新所有依赖包
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 3252980443
tags:
  - npm
categories:
  - 前端
date: 2022-10-17 13:29:31
img:
coverImg:
password:
summary:
---

## 工具 npm-check-updates

> 全局安装 npm-check-updates

~~~bash
$ npm install -g npm-check-updates
~~~

## 检查可更新的包

* 在当前项目的目录下执行以下命令，查看所有存在的更新

~~~bash
$ ncu
~~~

* 也可以通过执行以下命令查看所有可用的相关命令行(命令变动或者无效时查看命令)

~~~bash
$ ncu -h
~~~

* 更新包

~~~bash
$ ncu -u
~~~

> 注意：npm-check-updates 是更新项目包，但是无法保证包之间的依赖关系，导致项目无法运行，因此更新前一定要做好备份，以方便存在问题的时候恢复
>
> 因此轻易不要执行，可以查看所有存在的更新，选择性的手动更新。
