---
title: 【工具系列】让JavaWEB程序如MySQL服务一样自启动
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - winsw
categories:
  - 工具
abbrlink: 837744366
date: 2020-11-30 14:41:15
img:
coverImg:
password:
summary:
---

> 公司是有这么个需求，让打包后的jar包每天随着系统启动而自行启动，写脚本太麻烦，使用winsw差不多一劳永逸，而且很方便

### 概述

> WinSW is an executable binary, which can be used to wrap and manage a custom process as a Windows service. Once you download the installation package, you can rename *WinSW.exe* to any name, e.g. *MyService.exe*. 
>
> 翻译:
>
> ~~~xml
> WinSW是一个可执行的二进制文件，可用于将自定义进程包装和管理为Windows服务。下载安装包后，可以重命名WinSW.exe文件任何名字，例如。MyService.exe.
> ~~~

[官网地址:](https://github.com/winsw/winsw/releases/tag/v3.0.0-alpha.3)

![image-20200818151724948](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200818151725.png)

> <font color="red">需要注意的是</font>,上面的下载包圈错了,应该是下载第一个,然后下载xml文件
>
> [蓝奏云软件安装包](https://mobaijun.lanzous.com/b015pepqh)
>
> 密码: <font color="red">brsg</font>

[传送地址](https://github.com/winsw/winsw/releases)

![image-20200819111522762](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200819111522.png)

### 使用

> 将打包的SpringBoot项目和下载的XML文件/server.exe文件存放在一个目录下

![image-20200819111825573](https://cdn.mobaijun.com/qiniu_cdn/img/blog_images/20200819111825.png)

* 修改配置文件`ZJDYService.xml`

~~~xml
<configuration>
  <!-- 安装成windows服务后的服务名-->
  <id>ZJDY</id>
  <!-- 显示的服务名称 -->
  <name>ZJDY</name>
  <!-- 对服务的描述 -->
  <description>这是winsw生成的服务</description>
  <!-- 可执行程序。这里写java的路径（如果配置了环境变量，直接写“java就行了”）-->
  <executable>java</executable>
  <!--参数-->
  <arguments>-jar xxxx.jar</arguments>
</configuration>
~~~

### 启动

> <font color="red">当前目录下打开命令行</font>,执行如下命令

~~~bash
# 安装Windows服务
$ ZJDYService.exe install
# 卸载服务
$ ZJDYService.exe uninstall
# 启动服务
$ net start 项目名称
# 关闭服务
$ net stop 项目名称
# 重启服务
$ net restart 项目名称
# 寻找帮助
$ 项目名称 /?
# 查看版本
$ 项目名称 version
# 检查服务是否可以启动然后停止
$ 项目名称 test
# 检查服务状态
$ net status ZJDY
~~~

### 其他-配置文件详细说明

~~~xml
<!--
 这是Windows服务包装器的一个配置示例。
 此配置文件应放在WinSW.exe同目录，名称应相同。
 例如，对于myapp.exe，配置文件名应为myapp.xml。
 更多信息：https://github.com/kohsuke/winsw/blob/master/doc/xmlconfigfile.md
-->
<configuration>
  
<!-- 
SECTION: 必填项
-->
  
  <!-- 服务ID，在windows系统中必须唯一 -->
  <id>myapp</id>
  <!-- 服务显示名称，只能英文和数字 -->
  <name>MyApp Service (powered by WinSW)</name>
  <!-- 服务描述，只能英文和数字 -->
  <description>This service is a service cratead from a sample configuration</description>
  
  <!-- 启动可执行文件的路径 -->
  <executable>%BASE%\myExecutable.exe</executable>

<!--
SECTION: 安装
这些选项仅在安装时有效。修改配置后，必须重新安装服务才能生效。
-->

  <!--
    OPTION: serviceaccount
    定义运行服务的账号。
  -->
  <!--
  <serviceaccount>
    <domain>YOURDOMAIN</domain>
    <user>useraccount</user>
    <password>Pa55w0rd</password>
    <allowservicelogon>true</allowservicelogon>
  </serviceaccount>
  -->
  
  <!--
    OPTION: onfailure
    定义一系列操作，如果托管的可执行文件失败，则顺序执行这些操作。
    支持的操作：restart，reboot，none
  -->
  <!--
  <onfailure action="restart" delay="10 sec"/>
  <onfailure action="restart" delay="20 sec"/>
  <onfailure action="reboot" />
  -->
  
  <!--
    OPTION: resetfailure
    windows服务重置故障状态的时间。
    默认值 1 day
  -->
  <!--
  <resetfailure>1 hour</resetfailure>
  -->

<!--
SECTION: 执行管理配置
-->

  <!-- 
    OPTION: arguments
    传递给可执行文件的参数。
  -->
  <!--
  <arguments>-classpath c:\cygwin\home\kohsuke\ws\hello-world\out\production\hello-world test.Main</arguments>
  -->

  <!-- 
    OPTION: startarguments
    可执行文件启动参数。
    如果配置，则覆盖"arguments"
  -->
  <!--
  <startarguments></startarguments>
  -->
  
  <!--
    OPTION: workingdirectory
    如果指定，则设置可执行文件的默认工作目录。
    默认值：服务包装的可执行文件的目录
  -->
  <!--
  <workingdirectory>C:\myApp\work</workingdirectory>
-->
  
  <!--
    OPTION: priority
    所需的进程优先级。
    可设置的值：Normal, Idle, High, RealTime, BelowNormal, AboveNormal
    默认值：Normal
  -->
  <priority>Normal</priority>
  
  <!-- 
    OPTION: stoptimeout
    强制终止可执行文件之前，尝试正常关闭的等待时间。
    默认值：15 seconds
  -->
  <stoptimeout>15 sec</stoptimeout>
    
  <!--
    OPTION: stopparentprocessfirst
    如果设置为true，在停止子进程之前终止父进程。
    默认值：false
  -->
  <stopparentprocessfirst>false</stopparentprocessfirst>

  <!-- 
    OPTION: stopexecutable
    执行关闭服务的可执行文件路径。
    只有配置了"stoparguments"时，才使用此配置。如果没有则用"executable"关闭服务
  -->
  <!--
  <stopexecutable>%BASE%\stop.exe</stopexecutable>
  -->

  <!-- 
    OPTION: stoparguments
    终止服务时，传递给"stopexecutable"的附加参数
    此选项还允许通过停止可执行文件终止可执行文件
  -->
  <!--
  <stoparguments>-stop true</stoparguments>
  -->
<!-- 
SECTION: 服务管理
-->
    <!--
      OPTION: startmode
      定义服务的启动模式
      支持的模式：Automatic, Manual, Boot, System (latter ones are supported for driver services only)
      默认模式：Automatic
    -->
    <startmode>Automatic</startmode>
    
    <!--
      OPTION: delayedAutoStart
      如果在"startmode"配置了"Automatic"，则启用延迟自动启动。
      请参阅Winsw文档以获取有关支持的平台版本和限制的信息。
    -->
    <!--
        <delayedAutoStart/>
    -->
    
    <!-- 
      OPTION: depend
      在本服务启动之前启动的服务。
    -->
    <!--
    <depend>Eventlog</depend>
    <depend>W32Time</depend>
    -->
    
    <!--
      OPTION: waithint
      挂起停止操作所需的时间
      在指定的时间段过去之前，服务应该下次调用setServiceStatus函数。
      否则服务将被标记为无响应
      默认值：15 seconds
    -->
    <waithint>15 sec</waithint>
    
    <!--
      OPTION: sleeptime
      服务下次调用setServiceStatus函数之前的时间。
      不要超过"waithint"。建议间隔是"waithint"的十分之一，但不小于1秒，也不大于10秒。
      默认值：1 second
    -->
    <sleeptime>1 sec</sleeptime>
    
    <!--
      OPTION: interactive
      指示服务可以与桌面交互。
    -->
    <!--
    <interactive/>
    -->
    
<!-- 
SECTION: 日志记录 
-->

  <!--
    OPTION: logpath
    为服务包装程序生成的所有日志设置自定义日志目录。
    默认值：包含执行器的目录
  -->
  <!--
    <logpath>%BASE%\logs</logpath>
  -->
  
  <!--
    OPTION: log
    为可执行文件生成的日志定义日志记录模式。
    支持的模式：
      * append - 追加到现有日志
      * none - 不保存日志
      * reset - 启动时擦除日志
      * roll - 根据大小自动循环分割日志
      * roll-by-time - 根据日期循环分割日志
    默认模式: append
    
    每种模式都有不同的设置。https://github.com/kohsuke/winsw/blob/master/doc/loggingAndErrorReporting.md
  -->
  <log mode="append">
    <!--
    <setting1/>
    <setting2/>
  -->
  </log>
  
<!--
SECTION: 环境设置
-->
  <!--
    OPTION: env
    设置或重写环境变量。
    顶层可能配置了多个条目。
  -->
  <!--
  <env name="MY_TOOL_HOME" value="C:\etc\tools\myTool" />
  <env name="LM_LICENSE_FILE" value="host1;host2" />
  -->

  <!--
    OPTION: download
    启动前由包装器执行的下载列表。
  -->
  <!--
  <download from="http://www.google.com/" to="%BASE%\index.html" />
  
  下载并在出现错误时使服务启动失败：
  <download from="http://www.nosuchhostexists.com/" to="%BASE%\dummy.html" failOnError="true"/>

  由于连接未加密而导致基本身份验证不安全的示例：
  <download from="http://example.com/some.dat" to="%BASE%\some.dat"
            auth="basic" unsecureAuth=“true”
            username="aUser" password=“aPassw0rd" />

  通过HTTPS安全基本身份验证
  <download from="https://example.com/some.dat" to="%BASE%\some.dat"
            auth="basic" username="aUser" password="aPassw0rd" />

  当目标服务器和客户端是同一域的成员，并且客户端域属于具有信任的域时，安全身份验证：
  <download from="https://example.com/some.dat" to="%BASE%\some.dat" auth="sspi" />
  -->

<!-- 
SECTION: 其他选项
-->
  
  <!--
    OPTION: beeponshutdown
    指示服务在关闭时（如果操作系统支持）应发出嘟嘟声。
  -->
  <!--
  <beeponshutdown/> 
  -->
  
<!--
SECTION: 扩展
此配置部分允许指定自定义扩展。
更多信息请访问：https://github.com/kohsuke/winsw/blob/master/doc/extensions/extensions.md
-->
    
<!--
<extensions>
  Extension 1: id values must be unique
  <extension enabled="true" id="extension1" className="winsw.Plugins.SharedDirectoryMapper.SharedDirectoryMapper">
    <mapping>
      <map enabled="false" label="N:" uncpath="\\UNC"/>
      <map enabled="false" label="M:" uncpath="\\UNC2"/>
    </mapping>
  </extension>
  ...
</extensions>
-->
</configuration>
~~~

