---
title: 【工具系列】Windows包管理工具Scoop安装及使用
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 908521329
tags:
  - Scoop
categories:
  - 工具
date: 2022-03-02 20:22:20
img:
coverImg:
password:
summary:
---

## 前言

最近因为跳槽的问题，重装了操作系统，那么开发人员的痛点就是重装操作系统后安装开发环境，比如你一下子需要安装{JDK，MySQL，Redis，Nginx。。。。。}等一系列常用工具。

我们算一个步骤，从官网下载，到配置安装路径，然后自定义内容等，除去一些软件还需要配置环境变量的，平均下来一个软件安装完大概需要 3~5 分钟左右，多的话半天时间几乎都用在了开发环境的搭建，每每这样都会使我痛苦😣😣😣，我之前一直在想有没有一种一键安装各个应用程序的脚本，但是一直没找到，自己那会还没有重装系统的打算，也就没准备自己写一个脚本，离职那天晚上，突然就觉得电脑很臃肿，脑子一热就给重装了，然后就是各种环境搭建，配置等，太痛苦了，就想着有没有一种统一的 Windows 包管理工具，所以找到了 Scoop 这款 windows 包管理工具。

## 什么是 Scoop ？

Scoop 是 Windows 的命令行安装程序，是一个强大的包管理工具。可以在github上找到其项目的相关信息，[项目地址](https://github.com/ScoopInstaller/Scoop),Scoop 等一系列包管理器的诞生，第一大便利就是省去了上述繁琐的「搜索 - 下载 - 安装」的步骤，让我们能够通过「一行代码」急速安装。💪

同时，用 Scoop 来安装和管理我们的软件：

* 集搜索、下载、安装、更新软件于一体：极大的降低了安装维护一个软件的成本，我们甚至不必在软件本身的复杂菜单中寻找那个更新按钮来更新软件自己
* 将软件干干净净的安装到电脑的「用户文件夹」下：这样既不会污染路径也不会请求不必要的权限（UAC）
* 在卸载软件的时候，能够尽量清空软件在电脑上存储的任何数据和痕迹

Scoop 最适合安装那种干净、小巧、开源的软件。并且，Scoop 也极度适合为开发者配置开发环境，不过这些很多都涉及到进阶使用技巧。下面先从基础的安装方法开始介绍。

## Scoop 的安装配置

安装 Scoop 很简单，不过要先确定一些基础环境是否符合安装要求：

* Windows 版本不低于 Windows 7
* Windows 中的 PowerShell 版本不低于 PowerShell 3
* 你能 **正常、快速** 的访问 GitHub 并下载上面的资源，GitHub访问加速可以参考[【工具系列】FastGithub--GitHub加速工具 | 框架师](https://www.mobaijun.com/posts/1095309802.html)
* 你的 Windows 用户名为英文（Windows 用户环境变量中路径值不支持中文字符）

然后右键开始菜单按钮，在右键菜单中打开 PowerShell：

![](https://cdn.mobaijun.com//2022/img_1.png)

在 PowerShell 中输入下面内容，保证允许本地脚本的执行：

~~~bash
$ set-executionpolicy remotesigned -scope currentuser
~~~

然后执行下面的命令安装 Scoop：

~~~bash
$ Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
# 或者使用下面这条命令
$ iwr -useb get.scoop.sh | iex
~~~

> 这样有个问题既是安装在默认路径，在`C:\ProgramData\scoop`目录下，如何自定义安装位置呢？

~~~bash
$env:SCOOP='D:\APP\Scoop'
---------------------------
[Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')
~~~

> 上面两条指令分别输入到 PowerShell 即可，第一条指令表示配置安装 Scoop 的目标路径，第二条指令写入配置，然后在执行上面的安装命令就可以了。

配置环境变量，将 `D:\APP\Scoop\shims` 目录添加到系统 `Path` 目录下，全局调用 Scoop 指令。

~~~bash
$ scoop help
Usage: scoop <command> [<args>]

Some useful commands are:

alias       Manage scoop aliases
bucket      Manage Scoop buckets
cache       Show or clear the download cache
cat         Show content of specified manifest.
checkup     Check for potential problems
cleanup     Cleanup apps by removing old versions
config      Get or set configuration values
create      Create a custom app manifest
depends     List dependencies for an app
export      Exports (an importable) list of installed apps
help        Show help for a command
hold        Hold an app to disable updates
home        Opens the app homepage
info        Display information about an app
install     Install apps
list        List installed apps
prefix      Returns the path to the specified app
reset       Reset an app to resolve conflicts
search      Search available apps
status      Show status and check for new app versions
unhold      Unhold an app to enable updates
uninstall   Uninstall an app
update      Update apps, or Scoop itself
virustotal  Look for app's hash on virustotal.com
which       Locate a shim/executable (similar to 'which' on Linux)
~~~

这样就表明 Scoop 已经成功安装了。`scoop help` 这个命令就是 Scoop 的使用说明书，如果我们记不住某个命令怎么执行，也可以通过 `scoop help` 来唤起这个命令参考说明。

## Scoop 使用方法

Scoop 默认安装的主存储桶可能会不够用，所以需要添加一个额外的存储桶，这里的存储桶就相当于是软件商店概念，其他存储桶列表可以参考这个链接[传送门](https://rasa.github.io/scoop-directory/)，也可以通过如下命令进行搜索；

~~~bash
$ scoop bucket known
main
extras
versions
nirsoft
php
nerd-fonts
nonportable
java
games
~~~

以上官方认可的存储桶可以通过下面这个命令直接添加：

~~~bash
$ scoop bucket add <bucketname>
~~~

顺便强推 `extras` 这个存储桶，包含了大多数我们平常使用到的软件。

~~~bash
# 添额外的存储桶
$ scoop bucket add extras
~~~

### Scoop 基础语法

最基础的使用方法很简单，这里就不做赘述了，直接上命令列表：

*  搜索软件

~~~bash
$ scoop search <app>
~~~

* 安装软件

~~~bash
$ scoop install <app>
~~~

* 查看软件详细信息

~~~bash
$ scoop info <app>
~~~

*  查看已安装软件

~~~bash
$ scoop list
~~~

* 卸载软件，`-p`删除配置文件。

~~~bash
$ scoop uninstall <app>
~~~

* 更新 scoop 本体和软件列表

~~~bash
$ scoop update
~~~

* 更新指定软件

~~~bash
$ scoop update <app>
~~~

* 更新所有已安装的软件

~~~bash
$ scoop update *
~~~

* 检查 scoop 的问题并给出解决问题的建议

~~~bash
$ scoop checkup
~~~

* 查看命令列表

~~~bash
$ scoop help
~~~

* 查看命令帮助说明

~~~bash
scoop help <command>
~~~

> 🌰 举几个栗子，比如：

* 我们想要搜索一下有没有 Firefox 浏览器：

~~~bash
$ scoop search firefox
~~~

* 我们想要安装 aria2 下载器：

~~~bash
$ scoop install aria2
~~~

* 我们想要看看 Typora 的主页:

~~~bash
$ scoop home typora
~~~

就这样，十分简单！

那么现在安装软件的流程就变成了：`scoop search 软件名` - `scoop install 搜索结果中符合条件的那个`，结束。方便简洁！当然 Scoop 肯定不止这些命令可以折腾，更多的进阶命令和使用方法可以参考 [Scoop Wiki](https://github.com/lukesampson/scoop/wiki)。

### 清理安装包缓存

Scoop 会保留下载的安装包，对于卸载后又想再安装的情况，不需要重复下载。但长期累积会占用大量的磁盘空间，如果用不到就成了垃圾。这时可以使用 `scoop cache` 命令来清理。

* 显示安装包缓存

~~~bash
$ scoop cache show
~~~

* 删除指定应用的安装包缓存

~~~bash
$ scoop cache rm <app>
~~~

* 删除所有的安装包缓存

~~~bash
$ scoop cache rm *
~~~

> 如果你不希望安装和更新软件时保留安装包缓存，可以加上 `-k` 或 `--no-cache` 选项来禁用缓存：

 ~~~bash
 $ scoop install -k <app>
 ------------------------
 $ scoop update -k *
 ~~~

### 删除旧版本软件

当软件被更新后 Scoop 还会保留软件的旧版本，更新软件后可以通过 `scoop cleanup` 命令进行删除。

* 删除指定软件的旧版本

~~~bash
$ scoop cleanup <app>
~~~

* 删除所有软件的旧版本

~~~bash
$ scoop cleanup *
~~~

> 与安装软件一样，删除旧版本软件的同时也可以清理安装包缓存，同样是加上 `-k` 选项。

* 删除指定软件的旧版本并清除安装包缓存

~~~bash
$ scoop cleanup -k <app>
~~~

* 删除所有软件的旧版本并清除安装包缓存

~~~bash
$ scoop cleanup -k *
~~~

### 全局安装

全局安装就是给系统中的所有用户都安装，且环境变量是系统变量，对于需要设置系统变量的一些软件就需要全局安装，比如 Node.js、Python ，否则某些情况会出现无法找到命令的问题。

使用 `scoop install <app>` 命令加上 `-g` 或 `--global` 选项可对软件进行全局安装，全局安装需要管理员权限，所以需要提前以管理员权限运行的 Pow­er­Shell 。更简单的方式是先安装 `sudo`，然后用 `sudo` 命令来提权执行：

```bash
$ scoop install sudo
$ sudo scoop install -g <app>
```

> 达成在 Win­dows 上使用`sudo`的成就

使用 `scoop list` 命令查看已装软件时，全局安装的软件末尾会有 `*global*` 标志。

```bash
➜ scoop list
Installed apps:
  git 2.26.2.windows.1 *global*
  nodejs-lts 12.17.0 *global*
```

此外对于全局软件的更新和卸载等其它操作，都需要加上 `-g` 选项：

* 更新所有软件（且包含全局软件）

~~~bash
$ sudo scoop update -g *
~~~

* 卸载全局软件

~~~bash
$ sudo scoop uninstall -g <app>
~~~

*  卸载全局软件（并删除配置文件）

~~~bash
$ sudo scoop uninstall -gp <app>
~~~

* 删除所有全局软件的旧版本

~~~bash
$ sudo scoop cleanup -g *
~~~

* 删除所有全局软件的旧版本（并清除安装包包缓存）

~~~bash
$ sudo scoop cleanup -gk *
~~~

### 代理设置

Scoop 默认使用的是系统代理，如果你想手动指定代理，可以输入下面的命令。需要注意的是只支持 `http` 协议。

```bash
$ scoop config proxy 127.0.0.1:20080
```

> 设置完可以通过`scoop config proxy`查看。

如果你想取消代理，那么输入下面的命令，这将会恢复使用系统代理。

```bash
$ scoop config rm proxy
```

### 开启多线程下载

使用 Scoop 安装 Aria2 后，Scoop 会自动调用 Aria2 进行多线程加速下载。

```bash
$ scoop install aria2
```

使用 `scoop config` 命令可以对 Aria2 进行设置，比如 `scoop config aria2-enabled false` 可以禁止调用 Aria2 下载。以下是与 Aria2 有关的设置选项：

* `aria2-enabled`: 开启 Aria2 下载，默认`true`
* `aria2-retry-wait`: 重试等待秒数，默认`2`
* `aria2-split`: 单任务最大连接数，默认`5`
* `aria2-max-connection-per-server`: 单服务器最大连接数，默认`5` ，最大`16`
* `aria2-min-split-size`: 最小文件分片大小，默认`5M`

在这里推荐以下优化设置，单任务最大连接数设置为 `32`，单服务器最大连接数设置为 `16`，最小文件分片大小设置为 `1M`

```bash
$ scoop config aria2-split 32
$ scoop config aria2-max-connection-per-server 16
$ scoop config aria2-min-split-size 1M
```

## 常用命令总结

看到这里可能有很多小伙伴已经懵逼了，最后总结一波 Scoop 在日常使用中的常用命令：

```bash
# 更新 scoop 及软件包列表
$ scoop update
# 非全局安装（并禁止安装包缓存）
$ scoop install -k <app>
# 全局安装（并禁止安装包缓存）
$ sudo scoop install -gk <app>
# 卸载非全局软件（并删除配置文件）
$ scoop uninstall -p <app>
# 卸载全局软件（并删除配置文件）
$ sudo scoop uninstall -gp <app>
# 更新所有非全局软件（并禁止安装包缓存）
$ scoop update -k *
# 更新所有软件（并禁止安装包缓存）
$ sudo scoop update -gk *
# 删除所有旧版本非全局软件（并删除软件包缓存）
$ scoop cleanup -k *
# 删除所有旧版本软件（并删除软件包缓存）
$ sudo scoop cleanup -gk *
# 清除软件包缓存
$ scoop cache rm *
```

## 结语

Scoop 的使用方法和功能远不止上面提及的这些，但作为一个普通用户也只会用到一些基本的命令和功能。纵观全网也很少有人把基础功能都说明白，这也是在 2022 年咕鸽随便一搜一大把 Scoop 教程和笔记文章的情况下博主依然总结这样一篇更加全面教程的原因。希望这篇教程对你有所帮助。

## 参考资料

[Scoop - 最好用的 Windows 包管理器 - P3TERX ZONE](https://p3terx.com/go/aHR0cHM6Ly9zc3BhaS5jb20vcG9zdC81MjQ5Ng)

[「一行代码」搞定软件安装卸载，用 Scoop 管理你的 Windows 软件 - 少数派](https://sspai.com/post/52496)
