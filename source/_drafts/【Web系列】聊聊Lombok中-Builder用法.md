---
title: 【Web系列】聊聊Lombok中@Builder用法
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 1226410415
tags:
  - Lombok
categories:
  - SpringBoot
date: 2022-01-07 10:32:33
img:
coverImg:
password:
summary:
---

## 简介

> 简述：Builder 使用创建者模式又叫建造者模式。简单来说，就是一步步创建一个对象，它对用户屏蔽了里面构建的细节，但却可以精细地控制对象的构造过程。
>
> `@Builder` 在 lombok v0.12.0 中作为实验功能引入。
>
> `@Builder`自 lombok v1.16.0 以来获得`@Singular`支持并被提升为主`lombok`包。
>
> `@Builder`with`@Singular`从 lombok v1.16.8 开始添加了一个 clear 方法。
>
> `@Builder.Default` lombok v1.16.16 中添加了功能。
>
> `@Builder(builderMethodName = "")` 从 lombok v1.18.8 开始是合法的（并且会抑制生成器方法的生成）。
>
> `@Builder(access = AccessLevel.PACKAGE)` 从 lombok v1.18.8 开始是合法的（并将生成具有指示访问级别的构建器类、构建器方法等）。
>
> 以上内容来自官网：[@Builder](https://projectlombok.org/features/Builder)

## 基础使用

`@Builder`注释为你的类生成相对略微复杂的构建器API。`@Builder`可以让你以下面显示的那样调用你的代码，来初始化你的实例对象：



```java
User mobai = User.builder()
        .name("mobai")
        .code("100010")
        .build();
```

`@Builder`可以放在类，构造函数或方法上。 虽然放在类上和放在构造函数上这两种模式是最常见的用例，但`@Builder`最容易用放在方法的用例来解释。

