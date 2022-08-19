---
title: 【工具系列】Windows环境下切换JDK脚本
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 772710478
tags:
  - bat
categories:
  - 工具
date: 2022-01-24 15:27:33
img:
coverImg:
password:
summary:
---

## 前言

> 本机最近安装了好几个版本的 JDK ，需要在全局进行切换 JDK 使用，老改环境变量也挺麻烦的，还记得前辈说过的那句话，如果有一项工作让你重复，那就写个脚本搞定它。

## 我的环境

* JDK 8
* JDK 11
* JDK 16
* JDK 17
* 操作系统：Windows
* RefreshEnv：刷新环境变量的工具（Windows会报毒，忽略或加入信任即可）

> 需要在 Windows系统的 `PATH` 环境变量设置一个 `%JAVA_HOME%\bin` 环境变量，相信大家基本都有配置这个，无需多言，下面正文开始。

## 编写脚本内容

> 新建 `jdkref.bat` 文件，写入下面代码块，文件名不要太长，后面有用。

* 脚本内容：

~~~shell
@echo off
rem --- Base Config 配置JDK的安装目录 ---
:init
set JAVA_HOME_1_8=C:\Program Files\Java\jdk1.8.0_281
set JAVA_HOME_1_1=C:\Program Files\Java\jdk-11.0.12
set JAVA_HOME_1_6=C:\Program Files\Java\jdk-16.0.2
set JAVA_HOME_1_7=C:\Program Files\Java\jdk-17.0.1
rem 刷新环境变量的程序，绝对路径
set RefreshEnv=D:\IdeaProject\windows\windows-bat\Windows程序相关脚本\RefreshEnv.exe
:start

echo 当前使用的JDK 版本:
echo =============================================
java -version
echo =============================================
echo jdk版本列表:
echo  jdk8
echo  jdk11
echo  jdk16
echo  jdk17
echo =============================================
:select
set /p opt=请选择JDK版本：
if %opt%==8 (
    set TARGET_JAVA_HOME=%JAVA_HOME_1_8%
)
if %opt%==11 (
    set TARGET_JAVA_HOME=%JAVA_HOME_1_1%
)
if %opt%==16 (
    set TARGET_JAVA_HOME=%JAVA_HOME_1_6%
)
if %opt%==17 (
     set TARGET_JAVA_HOME=%JAVA_HOME_1_7%
)
echo 当前选择的Java路径:%TARGET_JAVA_HOME%

rem 删除JAVA_HOME
wmic ENVIRONMENT where "name='JAVA_HOME'" delete

rem 新建JAVA_HOME并赋值
wmic ENVIRONMENT create name="JAVA_HOME",username="<system>",VariableValue="%TARGET_JAVA_HOME%"

rem 刷新环境变量
call %RefreshEnv%

echo 请按任意键退出!
pause>nul

@echo on
~~~

* 设置脚本环境变量

![](https://tencent.cos.mobaijun.com/article_with_pictures/O2yRpwab1tPVB5i.png)

* 打开 `cmd` 命令行窗口，输入脚本名称即可调用脚本，如下

![](https://tencent.cos.mobaijun.com/article_with_pictures/L7zXaR1fwg2jHkc.png)

* 新打开一个 `cmd` 窗口，输入 `java -version` 查看是否切换成功。

![](https://tencent.cos.mobaijun.com/article_with_pictures/dMXJu5Hw2lj1i8k.png)

* 脚本源文件

> 传送门：[jdk切换脚本](https://gitee.com/mobaijun/windows-bat/blob/master/Windows%E7%A8%8B%E5%BA%8F%E7%9B%B8%E5%85%B3%E8%84%9A%E6%9C%AC/7.ToggleJdk.bat)
>
> 环境变量刷新工具：[传送门](https://gitee.com/mobaijun/windows-bat/blob/master/Windows%E7%A8%8B%E5%BA%8F%E7%9B%B8%E5%85%B3%E8%84%9A%E6%9C%AC/RefreshEnv.exe)
