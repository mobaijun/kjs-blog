---
title: 【Linux系列】Watchtower - 自动更新Docker镜像与容器
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 863705360
date: 2022-12-19 09:41:50
img:
coverImg:
password:
summary:
tags:

- Watchtower
  categories:
- Linux

---

## 介绍Watchtower

Watchtower是一个Docker容器的自动更新服务。当Docker Hub上的镜像被更新时，Watchtower会检测这些变化并更新本地的Docker镜像和容器。

Watchtower具有以下特点：

- 使用简单：仅需一条命令即可启动Watchtower；
- 支持多种Docker Registry：支持Docker Hub、Amazon ECR、Google Container Registry等；
- 安全性高：支持使用TLS加密进行通信。

## 具体操作

### 安装Watchtower

安装Watchtower非常简单。首先，需要在主机上安装Docker。然后，使用以下命令下载并运行Watchtower：

~~~bash
$ docker run -d --name watchtower \
-v /var/run/docker.sock:/var/run/docker.sock \
containrrr/watchtower
~~~

在此命令中，我们使用`docker run`命令启动Watchtower容器。`--name`参数指定了容器的名称，`-v`
参数将主机上的Docker套接字映射到容器内部的Docker套接字，以便Watchtower能够监视Docker守护程序上的容器和镜像。最后，`containrrr/watchtower`
参数指定要使用的Docker镜像。

### 配置Watchtower

默认情况下，Watchtower将监视所有容器，并在发现更新时自动更新它们。但是，您可能希望更改此行为以满足您的特定需求。可以使用以下环境变量配置Watchtower：

- `WATCHTOWER_POLL_INTERVAL`：指定Watchtower轮询Docker Registry以查找镜像更新的时间间隔（单位：秒）。默认值为300秒（5分钟）。
- `WATCHTOWER_CLEANUP`：指定Watchtower是否应删除已停止容器的标志。默认值为false。
- `WATCHTOWER_INCLUDE_STOPPED`：指定Watchtower是否应考虑已停止的容器。默认值为false。
- `WATCHTOWER_LABEL_ENABLE`：指定Watchtower是否应解析具有指定标签的容器。默认值为false。
- `WATCHTOWER_LABEL_FILTER`：指定Watchtower应解析具有哪些标签的容器。默认值为空。

例如，要将Watchtower配置为每10秒轮询Docker Registry以查找更新，并在更新时自动重启受影响的容器，请使用以下命令：

```bash
$ docker run -d --name watchtower \
-e WATCHTOWER_POLL_INTERVAL=10 \
-v /var/run/docker.sock:/var/run/docker.sock \
containrrr/watchtower
```

## 总结

Watchtower是一个方便的自动化工具，可帮助您管理Docker镜像和容器。无需手动检查更新或重新启动容器，Watchtower将自动执行这些任务。同时，Watchtower也具有很高的安全性，因为它支持使用TLS加密进行通信。如果您正在使用Docker构建和管理容器化应用程序，那么Watchtower是一个必备的工具。
