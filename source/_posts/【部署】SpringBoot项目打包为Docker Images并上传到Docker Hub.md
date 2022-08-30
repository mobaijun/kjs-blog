---
title: 【部署】SpringBoot项目打包为Docker Images并上传到Docker Hub
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 921109798
date: 2022-08-29 11:16:49
img:
coverImg:
password:
summary:
tags:
- Docker
categories:
- Linux
---

## 前言

> 写了一个推送当前地区天气信息的小程序，不想使用 `nohup java -jar` 去部署运行，就做了一个Docker Image,这里记录下。

![](https://tencent.cos.mobaijun.com/article_with_pictures/image-20220830150559517.png)

> 注意这里的推送时间（凌晨 1 点半）🤣🤣🤣

## 编写 Dockerfile 文件

内容如下：

~~~dockerfile
# syntax=docker/dockerfile:1
# https://docs.docker.com/language/java/build-images/
FROM eclipse-temurin:11-jdk-jammy

VOLUME /tmp

ADD april-weather-push-1.0.0.jar app.jar

ENTRYPOINT ["java","-Xms128m","-Xmx256m","-jar","/app.jar"]
~~~

> 参数说明：
>
> * FROM：表示基础镜像，这里选择 docker hup 推荐的 jdk
> * VOLUME：临时数据存放目录
> * ADD：把 april-weather-push-1.0.0.jar 添加到镜像中
> * ENTRYPOINT：自定义启动参数

## 编写简化操作脚本文件

* 创建一个 docker-run.sh 文件，写入如下参数

~~~sh
#!/bin/bash

# shellcheck disable=SC2046
docker rm $(docker stop april-weather-push)

# 打包
docker build -t april-weather-push:1.0.0 .

# run
docker run -dit --restart=always --name=april-weather-push  -p 8009:8080 -v /etc/localtime:/etc/localtime april-weather-push:1.0.0
~~~

> 将项目 jar 包和 Dockerfile，docker-run.sh 文件上传到服务器
>
> 使用`./docker-run.sh`执行脚本文件，会自动运行 april-weather-push 容器

---

> PS：-v /etc/localtime:/etc/localtime 挂载宿主机时间是非常必要的，因为宿主机执行的是 CST 东八区时间，容器执行的是 UTC 标准时间，比 CST 慢了 8 小时，如果你项目有定时任务之类的，会因为时差导致一些不必要的问题。

## 将容器提交到Docker Hub

> Docker Hub 是一个类似 GitHub 的 Docker 镜像管理平台。

### 1.登录你的Docker Hup 账号

> 如果没有就创建一个 Docker Hup 账号，过程非常简单，[官网传送门](https://hub.docker.com/)

### 2.创建仓库

点击 `repositories/Create repository`,创建仓库，这里仓库的概念类似 GitHub，一个项目创建一个仓库，写入仓库名称和项目简介（仓库名称最好和你上传的镜像名称保持一致，避免歧义），是否公开，如下图

![](https://tencent.cos.mobaijun.com/article_with_pictures/image-20220830144549336.png)

3. ### 服务器登录Docker Hub

> 输入 docker login，输入账号密码，成功如下图，返回 Login Succeeded。

![](https://tencent.cos.mobaijun.com/article_with_pictures/image-20220830144948030.png)

### 4.将容器 commit 成镜像

~~~bash
$ docker commit [容器id] 用户名/镜像名:[版本号]
----------------------示例----------------------------
$ docker commit 7227510800df  mobaijun/april-weather-push:1.0.0
~~~

> 这里的 tag 不指定默认就是 latest，这样 pull 的时候就可以不指定版本号了，但不推荐。

### 5.推送镜像到 Docker Hub

```bash
$ docker push 用户名/仓库名:版本号
----------------------示例----------------------------
$ docker push mobaijun/april-weather-push:1.0.0
```

### 6.Docker Hub 验证

如图：

![](https://tencent.cos.mobaijun.com/article_with_pictures/image-20220830145715539.png)

> 这样就完成了一个镜像的推送啦！这样后续在其他环境，只需要安装 Docker 环境，把仓库的镜像拉取下来，运行容器就快速部署好一个项目了。

## 其他

* docker 更新正在运行的容器内存分配

~~~bash
$ docker update -m 256M --memory-swap 256M  1475376d90f5
~~~

> 参数说明可以网上查一下

