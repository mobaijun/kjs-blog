---
title: 【工具系列】IDEA ctrl+alt+L 格式化快捷键无效时解决
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - IDEA
categories:
  - 工具
abbrlink: 4259780865
date: 2020-05-29 23:11:03
img:
coverImg:
password:
summary:
---

晚上写代码的时候突然发现IDEA格式化代码快捷键无效了

设置里面按照快捷键搜索 按了 ctrl+alt+L 也没反应

但是我设置的确实是默认的 ctrl+alt+L

最后终于找到了问题所在 原来是开网易云音乐的锅

![image-20200529231236414](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200529231237.png)

网易云会有一个全局的快捷键ctrl+alt+L跟idea冲突 去网易云关了就好了,蛋疼