---
title: 【后端】IntelliJ IDEA快速自动生成Junit测试类
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 3073865067
tags:
  - Junit
categories:
  - 后端
date: 2023-03-13 11:49:26
img:
coverImg:
password:
summary:
---

## 前言

> 在维护 [kjs-common](https://github.com/mobaijun/kjs-common) 项目中，我常需要编写测试用例，以方便用户理解功能和测试，在手写
> Junit 测试中，这是一个繁琐且重复的工作，了解到 IDEA 可以自动生成 Junit 测试主体时，我将此步骤记录下来。

## 配置 Junit 模板

在 idea 中定位菜单到 `File | Settings | Editor | File and Code Templates | Code`，配置生成 Junit 的默认信息，我这里配置的是注释模板，如下：

![](https://tencent.cos.mobaijun.com//xxbj_img/image-20230313115640998.png)

## 自动生成 Junit 测试用例

1. 在你需要生成测试用例的类中，摁下 `ctrl + insert` ，调起菜单栏，如下，选择 `Test `

![](https://tencent.cos.mobaijun.com//xxbj_img/image-20230313115908509.png)

2. 配置生成的方法以及包路径等参数

![](https://tencent.cos.mobaijun.com//xxbj_img/image-20230313121050758.png)

3. 生成效果如下

![](https://tencent.cos.mobaijun.com//xxbj_img/image-20230313120533848.png)

> 以上操作可减少大量重复工作，并且使开发人员更加专注于业务测试。
