---
title: 【工具系列】Nacos 配置MySQL数据库
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 2021021572
tags:
  - Nacos
categories:
  - 工具
date: 2022-07-14 08:52:20
img:
coverImg:
password:
summary:
---

## 前言

​	在 0.7 版本之前，在单机模式时 nacos 使用嵌入式数据库实现数据的存储，不方便观察数据存储的基本情况。0.7 版本后增加了支持 mysql 数据源能力，具体的操作步骤：

 

## nacos配置mysql

nacos 支持配置多个数据库，通过 *db.num* 和 *db.url.index*的配置来控制。nacos 配置 mysql 数据库只需如下三点即可完成：

1. 安装数据库，版本要求：5.6.5+
2. 初始化mysql数据库，数据库初始化文件：nacos-mysql.sql
3. 修改conf/application.properties文件，增加支持mysql数据源配置（目前只支持mysql），添加mysql数据源的url、用户名和密码。

~~~properties
# db mysql
spring.datasource.platform=mysql

db.num=1
db.url.0=jdbc:mysql://11.162.196.16:3306/nacos_devtest?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true
db.user=nacos_devtest
db.password=youdontknow
~~~

启动 nacos 后，打开 nacos 管理界面，在命名空间模块，创建一个开发环境配置的命名空间 develop ，如下图所示：

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】Nacos-配置MySQL数据库/0.png)

此时再查看我们的数据库表 tenant_info中已有创建的develop记录了，如下图所示：

![](https://tencent.cos.mobaijun.com/img/blog/【工具系列】Nacos-配置MySQL数据库/1.png)

#### 参考文档

nacos官方文档：https://nacos.io/zh-cn/docs/deployment.html
