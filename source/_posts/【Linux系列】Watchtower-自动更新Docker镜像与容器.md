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

## 前言

在使用 Docker 部署应用的过程中，常常需要更新 Docker 镜像和容器以保证软件的稳定性和安全性。手动更新是一件比较繁琐的事情，尤其是在多个
Docker 容器上运行多个镜像的情况下。为了解决这个问题，我们可以使用 Watchtower。

## 什么是 Watchtower

Watchtower 是一个开源项目，用于自动更新运行 Docker 镜像的容器。当 Watchtower 发现镜像有更新时，它会自动拉取最新的镜像，并重新启动容器以应用更新。Watchtower
支持多种 Docker 镜像仓库，包括 Docker Hub、Quay.io、Google Container Registry 等。

## 如何使用 Watchtower

下面是使用 Watchtower 自动更新 Docker 镜像和容器的步骤：

### 安装 Watchtower

首先，我们需要在 Docker 主机上安装 Watchtower。可以使用以下命令来安装：

```bash
$ docker run -d --name watchtower -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
```

这将在后台运行一个 Watchtower 容器，并将 Docker API 的套接字映射到容器内的 `/var/run/docker.sock` 目录。

### 配置 Watchtower

接下来，我们需要配置 Watchtower 来监视 Docker 镜像并自动更新容器。可以使用以下命令来配置 Watchtower：

```bash
$ docker run -d --name watchtower -v /var/run/docker.sock:/var/run/docker.sock -e WATCHTOWER_CLEANUP=true -e WATCHTOWER_POLL_INTERVAL=3600 -e WATCHTOWER_NOTIFICATIONS=email -e WATCHTOWER_NOTIFICATION_EMAIL_FROM=example@example.com -e WATCHTOWER_NOTIFICATION_EMAIL_TO=example@example.com containrrr/watchtower
```

这将启动一个 Watchtower 容器，并设置以下环境变量：

- `WATCHTOWER_CLEANUP=true`：Watchtower 将删除旧的镜像和容器。
- `WATCHTOWER_POLL_INTERVAL=3600`：Watchtower 将每隔 1 小时检查一次 Docker 镜像是否有更新。
- `WATCHTOWER_NOTIFICATIONS=email`：Watchtower 将使用电子邮件通知新版本的镜像和更新的容器。
- `WATCHTOWER_NOTIFICATION_EMAIL_FROM=example@example.com`：设置通知邮件的发件人。
- `WATCHTOWER_NOTIFICATION_EMAIL_TO=example@example.com`：设置通知邮件的收件人。

### 运行容器

现在，我们可以使用 Docker 运行一个容器并测试 Watchtower 是否能够自动更新容器。可以使用以下命令来运行一个 Nginx 容器：

```bash
$ docker run -d --name nginx -p 80:80 nginx
```

此命令将在后台运行一个 Nginx 容器，并将容器的 80 端口映射到 Docker 主机的 80 端口。

### 测试 Watchtower

由于 Watchtower 的默认轮询间隔为 1 小时，因此可能需要等待一段时间才能看到自动更新效果。可以手动触发 Watchtower
的轮询以立即检查是否有更新。可以使用以下命令来手动触发 Watchtower：

```bash
$ docker exec -it watchtower /watchtower --debug --run-once nginx
```

此命令将在 Watchtower 容器内运行一个命令来检查 Nginx 镜像是否有更新。如果发现更新，则 Watchtower 将自动拉取最新的镜像并重新启动容器。

## 总结

Watchtower 是一个非常有用的工具，可以自动更新 Docker 镜像和容器，并确保应用程序始终运行最新的版本。在部署 Docker
应用程序时，Watchtower 是必不可少的工具之一。
