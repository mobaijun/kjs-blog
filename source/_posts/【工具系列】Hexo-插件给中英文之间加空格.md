---
title: 【工具系列】Hexo 插件给中英文之间加空格
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 267676524
date: 2022-07-26 14:00:29
img:
coverImg:
password:
summary:
tags:
- hexo-filter-auto-spacing
categories:
- Hexo
---

## 前言

> 平常写博客的时候需要给中英文之间手动添加空格，虽然格式美观，但内容多了以后也觉得很麻烦，下面介绍的这款插件可以解决这个问题。

## 安装插件

~~~bash
npm install hexo-filter-auto-spacing --save
~~~



并在 hexo 根目录 _config.yml 文件中设置 auto_spacing ，设置 enable: false

~~~yaml
# hexo 中英文之间自动加空格
auto_spacing:
  enable: false
~~~



预览：



~~~bash
hexo s
~~~



大功告成

![](https://dl4.weshineapp.com/gif/20220209/19d8ae1b3d9ff0efac5269a6ba6e53b5.gif?f=micro_)

