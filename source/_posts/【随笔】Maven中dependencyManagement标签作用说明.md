---
title: 【随笔】Maven中dependencyManagement标签作用说明
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 2616135476
tags:
  - dependencyManagement
categories:
  - 随笔
date: 2022-10-10 08:44:10
img:
coverImg:
password:
summary:
---

## 前言

> 事情是这样的，最近重构了一个老项目，在重构的过程中，搭建了一个父模块来统一管理依赖包，使用maven 的 dependencyManagement 标签包裹所有依赖，子模块按需引入，尽量避免依赖传递，依赖冲突的问题。
>
> 部门负责人推荐了一个高级技术开发工程师进来，在一个通用工具类子模块使用 dependencyManagement 包裹了依赖包，如下

![](https://tencent.cos.mobaijun.com/article_with_pictures/image-20221010085146251.png)

> 看到这里我真的是又好气又好笑，因为在项目中已经对依赖进行统一管理，所以子模块只需要按需引入依赖即可，不需要其他操作，否则定义的统一依赖管理就毫无意义，并且使用了 dependencyManagement 标签后会导致当前模块的所有依赖全部失效，因为 dependencyManagement 只是声明依赖，并不会自动引入依赖。

![](https://tencent.cos.mobaijun.com/article_with_pictures/image-20221011101616508.png)

## dependencyManagement 简介

> 下面来介绍下 Maven 中 dependencyManagement 作用说明。

在Maven多模块的时候，管理依赖关系是非常重要的，各种依赖包冲突，查询问题起来非常复杂，于是就用到了 `<dependencyManagement>` ，

### 示例说明，

在父模块中：

```xml
<dependencyManagement>
    <dependencies>
        <!-- configuration ==================================================-->
        <dependency>
            <groupId>com.alibaba.nacos</groupId>
            <artifactId>nacos-client</artifactId>
            <version>${alibaba.nacos.version}</version>
        </dependency>
    </dependencies>
</dependencyManagement>
```

那么在子模块中只需要 `<groupId >` 和 `<artifactId>` 即可，如：

~~~xml
<dependencies>
	<dependency>
    	<groupId>com.alibaba.nacos</groupId>
    	<artifactId>nacos-client</artifactId>
	</dependency>
</dependencies>
~~~

## 说明：

使用 dependencyManagement 可以统一管理项目的版本号，确保应用的各个项目的依赖和版本一致，不用每个模块项目都弄一个版本号，不利于管理，当需要变更版本号的时候只需要在父类容器里更新，不需要任何一个子项目的修改；如果某个子项目需要另外一个特殊的版本号时，只需要在自己的模块 dependencies 中声明一个版本号即可。子类就会使用子类声明的版本号，不继承于父类版本号,这点可以查看 maven 就近原则。

## 与 dependencies 区别：

1. dependencies 相对于 dependencyManagement，所有声明在 dependencies 里的依赖都会自动引入，并默认被所有的子项目继承。
2. dependencyManagement 里只是声明依赖，并不自动实现引入，因此子项目需要显示的声明需要用的依赖。如果不在子项目中声明依赖，是不会从父项目中继承下来的；只有在子项目中写了该依赖项，并且没有指定具体版本，才会从父项目中继承该项，并且 version 和 scope 都读取自父 pom，另外如果子项目中指定了版本号，那么会使用子项目中指定的依赖版本。
