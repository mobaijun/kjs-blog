---
title: 【后端】实践出真知--Stream
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 3751155896
tags:
  - Stream
categories:
  - 后端
date: 2022-04-18 14:41:56
img:
coverImg:
password:
summary:
---

## 前言：

> 我感觉最近自己可能魔怔了，写代码总想追求极致的美感。

## 一、Lambda 简介

> Lambda 表达式描述了一段代码块（或者叫做匿名方法），可以将其作为参数传递给构造方法或着普通方法，以便后续执行。

~~~java
() -> System.out.println("https://www.mobaijun.com");
~~~

从左至右说明：

* () ：这个符号视为 Lambda 表达式的参数列表。
* -> ：标识这串代码为 Lambda 表达式，看到 -> 符号就表示当前代码块为 Lambda 表达式
* System.out.println("https://www.mobaijun.com")：表示要执行的代码，打印标准输出流。
