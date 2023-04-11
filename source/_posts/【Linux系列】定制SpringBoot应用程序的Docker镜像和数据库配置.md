---
title: 【Linux系列】定制SpringBoot应用程序的Docker镜像和数据库配置
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 2721643765
tags:
  - Docker
categories:
  - Linux
date: 2023-04-11 22:16:49
img:
coverImg:
password:
summary:
---

## 前言

最近，我面临一个问题：我需要部署一个 Web 应用程序到 Docker 上，并且需要自定义数据源的信息。经过探索和实践，我成功地将利用 SpringBoot 开发的应用程序打包成 Docker 镜像，并且自定义了数据库的链接信息。在这里，我想分享一下我的经验，希望能对大家有所帮助。

## 一丶定义 Spring 配置文件信息



~~~yaml
spring:
  datasource:
    url: ${DATASOURCE_URL}
    username: ${DATASOURCE_USERNAME}
    password: ${DATASOURCE_PASSWORD}
~~~

上面这个配置文件是 Spring 应用程序中的一个数据库配置文件，它指定了数据源的连接 URL、用户名和密码。其中 {DATASOURCE_URL}、{DATASOURCE_USERNAME} 和 ${DATASOURCE_PASSWORD} 是占位符，它们会在程序运行时被实际的值所替代。

在容器中运行程序时，需要将这些占位符替换为实际的值，否则程序无法连接到数据库。

## 二丶编写 DockerFile

下面这个 Dockerfile 文件是构建 Docker 镜像文件所需要的配置文件。它会基于应用程序依赖的 JDK 17 Alpine 镜像进行构建，然后进行一系列的配置操作，包括设置工作目录、复制应用程序 Jar 包到容器中、设置应用程序 Jar 包的环境变量等等。

~~~dockerfile
# syntax=docker/dockerfile:1
# https://docs.docker.com/language/java/build-images/
# 设置基础镜像（基础镜像可以根据实际需要自己定义）
FROM dkrenski/jdk17-alpine:1.0

# 设置工作目录
WORKDIR /usr/local/codegen/

# 复制应用程序 Jar 包到容器中
ADD codegen.jar /usr/local/codegen/codegen.jar

# 设置应用程序 Jar 包的环境变量
ENV DATASOURCE_URL=""
ENV DATASOURCE_USERNAME=""
ENV DATASOURCE_PASSWORD=""

# 使用非交互式模式
ENV DEBIAN_FRONTEND=noninteractive

# 更新环境变量
ENV TZ=Asia/Shanghai

# 暴露应用程序端口
EXPOSE 8080

# 设置容器启动命令
CMD ["java","-Xms256m","-Xmx512m","-jar","/usr/local/codegen/codegen.jar"]
~~~

三丶打包程序为Docker Images

1. 首先使用 maven 将你的程序打成 jar 包，和 dockerfile 一起上传到 Linux 工作目录。

   比如我的是 `/usr/local/mobaijun/codegen`, 目录包含 jar 包和 dockerfile。

2. 打包为 docker images。

~~~bash
$ docker build -t mobaijun/generator:2.0.0 .
~~~

打包完毕，使用 docker images 查看镜像。

3. 测试使用

~~~bash
$ docker run --rm -p 8099:8080 -e DATASOURCE_URL=jdbc:mysql://192.168.1.10:3306/code?rewriteBatchedStatements=true\&useUnicode=true\&characterEncoding=UTF-8\&serverTimezone=Asia/Shanghai\&createDatabaseIfNotExist=true -e DATASOURCE_USERNAME=root -e DATASOURCE_PASSWORD=root mobaijun/generator:2.0.0
~~~

> 测试 Docker 镜像文件是否能够在容器中正常运行，如果出现异常就删除这个容器。
>
> 需要注意的点：docker 无法直接识别 `&` 这样的特殊符号，前面需要加上占位符 `\`。

通过以上三个步骤，我们可以自己打包一个 Docker 镜像文件，并且为其自定义数据源的信息。如果没有意外，这个镜像文件就可以成功运行，并且上传到 Docker Hub 等镜像源上供其他人使用了。

