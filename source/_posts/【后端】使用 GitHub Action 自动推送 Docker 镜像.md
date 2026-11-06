---
title: 【后端】使用 GitHub Action 自动推送 Docker 镜像
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 2922523315
tags:
  - action
categories:
  - 后端
date: 2024-11-13 10:07:32
img:
coverImg:
password:
summary:
---

## 前言

> 在本地推送 Docker 镜像至 Docker Hub 时，经常遇到超时问题。为了避免手动操作带来的不便，决定通过 GitHub Actions
> 实现自动化工作流，轻松将 Docker 镜像推送至 Docker Hub。接下来，我将详细介绍如何配置并使用 GitHub 工作流实现这一过程。

## workflows 流程

> 先来说说 Spring Boot[项目打包](https://so.csdn.net/so/search?q=maven%20%E9%A1%B9%E7%9B%AE%E6%89%93%E5%8C%85&urw=)成
> Docker 镜像，并上传到仓库的流程

![1731464893944.png](https://tencent.cos.mobaijun.com/xxbj_img/202501241027823.png)

1. 使用 `Spring Boot` 项目: [传送门](https://github.com/mobaijun/ballcat-codegen)
2. 运行 `maven`命令 `mvn -B clean package --file pom.xml` 打包 `jar` 文件
3. 运行 `docker build` 构建 `docker` 镜像
4. 使用 `docker push` 推送 `docker` 镜像

## 配置 Docker Hub 认证

为了将镜像推送到 Docker Hub，我们需要进行 Docker Hub 的认证。以下是配置步骤：

1. 登录 Docker Hub 获取用户名和密码。
2. 将这些认证信息存储在 GitHub Secrets 中，确保安全性。

![1731464114594.png](https://tencent.cos.mobaijun.com/xxbj_img/202501241026359.png)

## 创建 GitHub Actions 工作流

1. 创建工作流目录

在项目根目录下创建 `.github/workflows` 文件夹。

2. 配置工作流文件 `docker-image.yml`

创建一个名为 `docker-image.yml` 的 GitHub Actions 配置文件，内容如下：

~~~yaml
name: docker-build-push

on:
  push:
    branches:
      # 监听推送到 master 分支
      - "master"
    # 监听以 v 开头的标签
    tags:
      - 'v*'
  pull_request:
    # 监听针对 master 分支的拉取请求
    branches:
      - "master"

jobs:
  build:
    # 使用最新的 Ubuntu 环境
    runs-on: ubuntu-latest

    env:
      # 默认为 Docker Hub，如果使用其他 Docker 注册表，可以修改
      REGISTRY: 'docker.io'
      # 使用 GitHub 仓库名作为镜像名称，格式为 <账户>/<仓库>
      # IMAGE_NAME: ${{ github.generator }}
      IMAGE_NAME: mobaijun/generator

    steps:
      # 检出代码
      - name: Checkout code
        # 检出代码，默认会检出整个仓库
        uses: actions/checkout@v3

      # 设置 JDK 11
      - name: Set up JDK 11
        # 设置 Java 版本为 11
        uses: actions/setup-java@v3
        with:
          # Java 版本设置为 11
          java-version: '11'
          # 使用 Temurin 的 JDK 发行版
          distribution: 'temurin'
          # 启用 Maven 缓存，提升构建速度
          cache: maven

      # 使用 Maven 构建项目
      - name: Build with Maven
        # 使用 Maven 清理并构建项目
        run: mvn -B clean package --file pom.xml

      # 构建 Docker 镜像
      - name: Build Docker image
        # 根据 Dockerfile 构建镜像，并标记为 latest
        run: docker build -f ./ballcat-codegen-backend/src/main/resources/docker/Dockerfile . --tag ${{ env.IMAGE_NAME }}:latest

      # 登录到 Docker Hub（或其他 Docker 注册表）
      - name: Log in to Docker Hub
        # 仅在非 PR 事件中执行登录
        if: github.event_name != 'pull_request'
        # 使用 Docker 登录动作
        uses: docker/login-action@v2
        with:
          # 使用自定义的注册表（默认为 Docker Hub）
          registry: ${{ env.REGISTRY }}
          # 从 GitHub Secrets 获取 Docker 用户名
          username: ${{ secrets.DOCKER_USERNAME }}
          # 从 GitHub Secrets 获取 Docker 密码
          password: ${{ secrets.DOCKER_PASSWORD }}

      # 提取 Docker 元数据（标签和标签）
      - name: Extract Docker metadata
        id: meta
        # 使用 Docker metadata-action 提取元数据
        uses: docker/metadata-action@v4
        with:
          # 使用定义的镜像名称
          images: ${{ env.IMAGE_NAME }}
          tags: |
            # 设置最新标签
            type=raw,value=latest,enable={{is_default_branch}}
            # 设置基于标签的标签
            type=ref,enable=true,priority=600,prefix=,suffix=,event=tag

      # 构建并推送 Docker 镜像
      - name: Build and push Docker image
        # 使用 Docker build-push-action 来构建和推送镜像
        uses: docker/build-push-action@v3
        with:
          # Docker 构建上下文为当前目录
          context: .
          # Dockerfile 路径
          file: ./ballcat-codegen-backend/src/main/resources/docker/Dockerfile
          # 如果不是 PR，推送镜像
          push: ${{ github.event_name != 'pull_request' }}
          # 使用提取的标签推送镜像
          tags: ${{ steps.meta.outputs.tags }}
          # 使用提取的标签作为镜像元数据
          labels: ${{ steps.meta.outputs.labels }}

~~~

3. 工作流触发时机

- **Push 到 `master` 分支**时自动触发工作流。
- **Push 以 `v` 开头的标签**时触发版本发布。
- **Pull request 针对 `master` 分支**时，自动触发构建和测试过程。

4. 登录 Docker Hub

在推送镜像之前，我们需要先登录到 Docker Hub。通过 GitHub Secrets 保护 Docker Hub 的认证信息，确保账号密码安全。

## 效果展示

当你成功配置并推送到 GitHub 后，每次提交或标签推送都会自动触发工作流，并将构建好的 Docker 镜像上传至 Docker
Hub。你可以通过以下图片看到最终的工作流执行结果：

![1731464385553.png](https://tencent.cos.mobaijun.com/xxbj_img/202501241027390.png)

> 通过这种自动化方式，你可以节省大量的时间和精力，同时确保 Docker 镜像的构建和推送过程完全可重复。快来体验 GitHub Actions
> 的强大功能吧！

## 参考文章

[利用GitHub Actions自动构建项目的docker镜像并发布到DockerHub | 二丫讲梵](https://wiki.eryajf.net/pages/5baf0a/#%E9%85%8D%E7%BD%AE)

[巧用Github Action 自动推送docker镜像，白piao github服务器资源，还省时又省力_github系统上传hub.docker-CSDN博客](https://blog.csdn.net/agonie201218/article/details/128287804)
