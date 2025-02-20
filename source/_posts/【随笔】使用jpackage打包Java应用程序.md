---
title: 【随笔】使用jpackage打包Java应用程序
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 3273158412
tags:
  - Jpackage
categories:
  - 工具
date: 2025-02-20 10:32:30
img:
coverImg:
password:
summary:
---

## 1. 简介

**jpackage** 是 JDK 14 引入的一个工具，旨在帮助开发者将 Java 应用程序打包成原生的可执行文件，支持 Windows、macOS 和 Linux 平台。通过 **jpackage**，你可以将 Java 应用和其所需的依赖打包在一起，并创建本地安装程序。

本文将展示如何使用 **jpackage** 将一个简单的 Java 应用程序打包成可执行文件，包括打包 Windows (`.exe`)，macOS (`.app`)，和 Linux (`.deb`) 文件的步骤。

## 2. 准备工作

### 2.1. 安装 JDK 14 或更高版本

**jpackage** 工具是从 JDK 14 开始提供的，因此你需要安装 JDK 14 或更高版本。你可以从 [Oracle 官网](https://www.oracle.com/java/technologies/downloads/#java23) 或者 OpenJDK 下载并安装。

安装完成后，通过命令行验证安装是否成功：

```bash
java -version
```

你应该看到类似以下输出，确认你安装的是 JDK 14 或更高版本：

```bash
C:\Users\mobai>java -version
java version "23.0.2" 2025-01-21
Java(TM) SE Runtime Environment (build 23.0.2+7-58)
Java HotSpot(TM) 64-Bit Server VM (build 23.0.2+7-58, mixed mode, sharing)
```

### 2.2. 安装 WiX 工具

直接执行 jpackage 命令会报错，所以需要安装 WiX

~~~bash
[18:01:09.359] 找不到 WiX 工具 (light.exe, candle.exe)
[18:01:09.359] 从 https://wixtoolset.org 下载 WiX 3.0 或更高版本，然后将其添加到 PATH。
错误：类型 [msi] 无效或不受支持
~~~

下载地址：https://github.com/wixtoolset/wix3/releases

![image-20250220105510758](https://tencent.cos.mobaijun.com/xxbj_img/image-20250220105510758.png)

### 2.3. Jpackage参数说明

~~~bash
C:\>jpackage --help
用法：jpackage <options>

示例用法:
--------------
    生成适合主机系统的应用程序包：
        对于模块化应用程序：
            jpackage -n name -p modulePath -m moduleName/className
        对于非模块化应用程序：
            jpackage -i inputDir -n name \
                --main-class className --main-jar myJar.jar
        从预构建的应用程序映像：
            jpackage -n name --app-image appImageDir
    生成应用程序映像：
        对于模块化应用程序：
            jpackage --type app-image -n name -p modulePath \
                -m moduleName/className
        对于非模块化应用程序：
            jpackage --type app-image -i inputDir -n name \
                --main-class className --main-jar myJar.jar
        要为 jlink 提供您自己的选项，请单独运行 jlink：
            jlink --output appRuntimeImage -p modulePath \
                --add-modules moduleName \
                --no-header-files [<additional jlink options>...]
            jpackage --type app-image -n name \
                -m moduleName/className --runtime-image appRuntimeImage
    生成 Java 运行时程序包：
        jpackage -n name --runtime-image <runtime-image>

一般选项：
  @<filename>
          从文件读取选项和/或模式
          可以多次使用此选项。
  --type -t <type>
          要创建的程序包的类型
          有效值为：{"app-image", "exe", "msi"}
          如果未指定此选项，则将创建与平台相关的
          默认类型。
  --app-version <version>
          应用程序和/或程序包的版本
  --copyright <copyright string>
          应用程序的版权
  --description <description string>
          应用程序的说明
  --help -h
          将用法文本输出到输出流并退出，用法文本中包含
          适用于当前平台的每个有效选项的列表和说明
  --icon <file path>
          应用程序包图标的路径
          （绝对路径或相对于当前目录的路径）
  --name -n <name>
          应用程序和/或程序包的名称
  --dest -d <destination path>
          用来放置所生成的输出文件的路径
          （绝对路径或相对于当前目录的路径）
          默认为当前的工作目录。
  --temp <directory path>
          用来创建临时文件的新目录或空白目录的路径
          （绝对路径或相对于当前目录的路径）
          如果指定，则在任务完成时将不删除临时目录，
          必须手动删除临时目录。
          如果未指定，则将创建一个临时目录，
          并在任务完成时删除该临时目录。
  --vendor <vendor string>
          应用程序的供应商
  --verbose
          启用详细的输出
  --version
          将产品版本输出到输出流并退出。

用来创建运行时映像的选项：
  --add-modules <模块名称>[,<模块名称>...]
          要添加的模块的逗号 (",") 分隔列表
          此模块列表连同主模块（如果指定）
          将作为 --add-module 参数传递到 jlink。
          如果未指定，则仅使用主模块（如果指定了 --module），
          或者使用默认的模块集（如果指定了
          --main-jar）。
          可以多次使用此选项。
  --module-path -p <module path>...
          路径的 ; 分隔列表
          每个路径要么是模块的目录，要么是
          模块化 jar 的路径。
          （每个路径可以是绝对路径，也可以是相对于当前目录的路径。）
          可以多次使用此选项。
  --jlink-options <jlink 选项>
          要传递给 jlink 的选项列表（用空格分隔）
          如果未指定，则默认为 "--strip-native-commands
          --strip-debug --no-man-pages --no-header-files"。
          可以多次使用此选项。
  --runtime-image <directory path>
          将复制到应用程序映像的预定义
          运行时映像的路径
          （绝对路径或相对于当前目录的路径）
          如果未指定 --runtime-image，jpackage 将运行 jlink 以
          使用如下选项创建运行时映像：
          --strip-debug、--no-header-files、--no-man-pages 和
          --strip-native-commands。

用来创建应用程序映像的选项：
  --input -i <directory path>
          包含要打包的文件的输入目录的路径
          （绝对路径或相对于当前目录的路径）
          输入目录中的所有文件将打包到
          应用程序映像中。
  --app-content <additional content>[,<additional content>...]
          要添加到应用程序有效负载中的文件和/或
          目录的逗号分隔路径列表。
          此选项可以多次使用。

用来创建应用程序启动程序的选项：
  --add-launcher <launcher name>=<file path>
          启动程序的名称和包含关键字-值对列表的
          属性文件的路径
          （绝对路径或相对于当前目录的路径）
          可以使用关键字 "module"、"main-jar"、"main-class"、"description"、
          "arguments"、"java-options"、"app-version"、"icon"、
          "launcher-as-service"、
          "win-console"、"win-shortcut"、"win-menu"、
          "linux-app-category" 和 "linux-shortcut"。
          这些选项将添加到原始命令行选项中或者用来覆盖
          原始命令行选项，以构建额外的替代启动程序。
          将从命令行选项构建主应用程序启动程序。
          可以使用此选项构建额外的替代启动程序，
          可以多次使用此选项来构建
          多个额外的启动程序。
  --arguments <main class arguments>
          在没有为启动程序提供命令行参数时，
          要传递到主类的命令行参数
          可以多次使用此选项。
  --java-options <java options>
          要传递到 Java 运行时的选项
          可以多次使用此选项。
  --main-class <class name>
          要执行的应用程序主类的限定名称
          只有在指定了 --main-jar 时才能使用此选项。
  --main-jar <main jar file>
          应用程序的主 JAR；包含主类
          （指定为相对于输入路径的路径）
          可以指定 --module 或 --main-jar 选项，但是不能同时指定
          两者。
  --module -m <module name>[/<main class>]
          应用程序的主模块（以及可选的主类）
          此模块必须位于模块路径中。
          如果指定了此选项，则将在 Java 运行时映像中
          链接主模块。可以指定 --module 或 --main-jar 选项，
          但是不能同时指定这两个选项。

用来创建应用程序启动程序的与平台相关的选项：
  --win-console
          为应用程序创建控制台启动程序，应当为
          需要控制台交互的应用程序指定

用来创建应用程序包的选项：
  --about-url <url>
          应用程序主页的 URL
  --app-image <directory path>
          用来构建可安装程序包的
          预定义应用程序映像的位置
          （绝对路径或相对于当前目录的路径）
  --file-associations <file path>
          包含关键字-值对列表的属性文件的路径
          （绝对路径或相对于当前目录的路径）
          可以使用关键字 "extension"、"mime-type"、"icon" 和 "description"
          来描述此关联。
          可以多次使用此选项。
  --install-dir <directory path>
          默认安装位置下面的相对子路径
  --license-file <file path>
          许可证文件的路径
          （绝对路径或相对于当前目录的路径）
  --resource-dir <directory path>
          覆盖 jpackage 资源的路径
          可以通过向该目录中添加替代资源来覆盖 jpackage 的
          图标、模板文件和其他资源。
          （绝对路径或相对于当前目录的路径）
  --runtime-image <directory path>
          要安装的预定义运行时映像的路径
          （绝对路径或相对于当前目录的路径）
          在创建运行时程序包时需要使用选项。
  --launcher-as-service
          请求创建安装程序，以将主
          应用程序启动程序注册为后台服务类型应用程序。

用来创建应用程序包的与平台相关的选项：
  --win-dir-chooser
          添加一个对话框以允许用户选择
          产品的安装目录。
  --win-help-url <url>
          用户可以从中获取更多信息或技术支持的 URL
  --win-menu
          请求为此应用程序添加开始菜单快捷方式
  --win-menu-group <menu group name>
          此应用程序所在的开始菜单组
  --win-per-user-install
          请求基于每个用户执行安装
  --win-shortcut
          请求为此应用程序添加桌面快捷方式
  --win-shortcut-prompt
          添加一个对话框以允许用户选择是否将由安装程序
          创建快捷方式。
  --win-update-url <url>
          可用应用程序更新信息的 URL
  --win-upgrade-uuid <id string>
          与此程序包的升级相关联的 UUID
~~~

## 3. 使用 Jpackage 打包

~~~bash
$ jpackage --type exe --name GithubBlog --input . --main-jar target\github-auto-blog-1.0.0.jar --main-class com.mobaijun.GithubAutoBlogApplication
~~~

------

## 4. 总结

通过 **jpackage**，你可以非常方便地将 Java 应用程序打包成平台原生的可执行文件或安装包，无论是 Windows、macOS 还是 Linux。这个工具使得 Java 应用的部署更加简便，尤其适用于分发独立的桌面应用程序。

在实际应用中，你可以根据需求设置打包的参数，例如设置 JVM 参数、应用图标、版本等，来进一步定制你的应用。
