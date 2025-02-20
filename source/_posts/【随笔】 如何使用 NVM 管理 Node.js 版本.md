---
title: 【随笔】 如何使用 NVM 管理 Node 版本
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 3939706828
date: 2025-02-20 13:55:06
img:
coverImg:
password:
summary:
tags:
- nvm
categories:
- 工具
---

## 如何使用 NVM 管理 Node 版本

Node 是一种流行的 JavaScript 运行时环境，常常因为不同的项目需求，需要切换 Node 的版本。为了解决这个问题，我们可以使用 `NVM`（Node Version Manager）来方便地管理 Node 的多个版本。

## 1. 卸载现有的 Node（如果有）

在安装 `NVM` 之前，最好确保 Windows 系统中没有已安装的 Node。如果之前已经安装了 Node，需要先将其卸载。

### 卸载方法：

1. **通过控制面板**：进入控制面板，找到 Node，点击卸载。
2. **全局搜索**：如果在控制面板找不到，可以通过全局搜索 `node` 和 `npm`，然后删除相关文件和文件夹。

确保彻底卸载 Node，以免干扰 NVM 的安装。

## 2. 下载和安装 NVM

`NVM` 是一个用于管理 Node 版本的工具，它允许你在多个版本的 Node 之间切换。对于 Windows 系统，`NVM` 有专门的版本。

### 下载地址：

1. **NVM for Linux/Mac**（适用于 Linux 和 MacOS）：[NVM GitHub 仓库](https://github.com/nvm-sh/nvm)
2. **NVM for Windows**（适用于 Windows）：[NVM for Windows 1.1.9 版本](https://github.com/coreybutler/nvm-windows/releases/tag/1.1.9)
3. **NVM for Windows 其他版本**：[NVM for Windows Releases](https://github.com/coreybutler/nvm-windows/releases)

对于 Windows 用户，可以直接下载并安装第二个链接中的 1.1.9 版本，这是一个稳定的版本。

## 3. 常用 NVM 命令

cmd 使用管理员方式执行，否则无效

~~~bash
1.查看已安装的 Node 版本
$ nvm list

2.查看已安装的 Node 版本（另一个命令）
$ nvm list installed

3.查看网络上可以安装的 Node 版本
$ nvm list available

4.查看当前使用的 Node 版本
$ nvm version

5.安装最新版本的 Node
$ nvm install

6.切换到指定版本的 Node
$ nvm use <version>

7.列出所有 Node 版本
$ node nvm ls

8.显示当前使用的 Node 版本
$ nvm current

9.为 Node 版本添加别名
$ nvm alias <name> <version>

10.删除已定义的别名
$ nvm unalias <name>

11.在当前版本 Node 环境下，重新全局安装指定版本的 npm 包
$ nvm reinstall-packages <version>

12.打开 Node 控制
$ nvm on

13.关闭 Node 控制
$ nvm off

14.查看设置的代理
$ nvm proxy

15.设置或查看 Node 镜像源（默认: Index of /dist/）
$ nvm node_mirror [url]

16.设置或查看 npm 镜像源（默认: https://github.com/npm/npm/archive/）
$ nvm npm_mirror [url]

17.卸载指定版本的 Node
$ nvm uninstall <version>

18.切换到指定版本和位数的 Node
$ nvm use [version] [arch]

19.设置和查看 NVM 根路径
$ nvm root [path]
~~~

------

通过这些命令，你可以灵活地管理多个 Node 版本，实现版本的安装、切换、删除、代理设置等操作。
