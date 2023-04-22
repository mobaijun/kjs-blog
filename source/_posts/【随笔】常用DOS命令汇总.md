---
title: 【随笔】常用DOS命令汇总
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - CMD
categories:
  - 工具
abbrlink: 567653050
date: 2021-02-20 10:44:45
img:
coverImg:
password:
summary:
---

![dos窗口](https://tencent.cos.mobaijun.com/img/blog/【随笔】常用DOS命令汇总/0.png)

## Dos简介

> *微软磁盘操作系统，MS-DOS，英语：MicroSoft Disk Operating System的写，一个由美国微软公司发展的操作系统，运行在Intel x86个人电脑上。DOS（Disk Operating System）是一个使用得十分广泛的磁盘操作系统。 常见的DOS有两种：IBM公司的PC-DOS和微软公司的MS-DOS，它们的功能、命令用途格式都相同，我们常用的是MS-DOS。DOS的内部命令是进行操作的基础，完成了对它们的学习就跨进了DOS系统的大门。内部命令，是指在DOS启动之后，自动通过command.com文件导入内存的命令。在执行这些命令的时候，直接从内存进行调用………自从DOS在1981年问世以来，版本就不断更新，从最初的DOS1.0升级到了最新的DOS8.0（Windows ME系统），纯DOS的最高版本为DOS6.22，这以后的新版本DOS都是由Windows系统所提供的，并不单独存在。*

## Dos命令

> *DOS命令，计算机术语，是指DOS操作系统(单任务的操作系统)的命令，是一种面向磁盘的操作命令，主要包括目录操作类命令、磁盘操作类命令、文件操作类命令和其它命令。*

内部命令是随每次启动的COMMAND.COM装入并常驻内存，而外部命令是一条单独的可执行文件。在操作时要记住的是，内部命令在任何时候都可以使用。 

外部命令需要保证命令文件在当前的目录中，或在Autoexec.bat文件已经被加载了路径。

DOS的内部命令是DOS操作的基础，DOS的外部命令就是一些应用程序，这些外部命令都是以文件的形式存在，Windows系统的DOS外部命令保存在Windows主目录下的Command目录中。 

简单的说，外部命令是指在DOS目录下看的见的命令,一般是.exe或.com为扩展名,这些命令删除后就不能再用了。常用的有:format,fdisk,copy,xcopy等等。 

内部命令是指集成在DOS系统中的命令,用DIR列表是看不见的,是无法删除的!在任何目录下都可以运行执行的命令。常用的有:dir,rd,cd,md等等，用一句话概括就是内部命令是DOS 系统中自带的，使用时只要输入命令就能执行，而外部命令使用是，需要有装有外部命令的软盘或光盘，才能够使用。

* CMD外部命令 (调用其它程序来实现对对象的操作)

外部命令实际上是一个DOS应用程序，通过执行存储于外部（盘）的程序完成其功能，能够使用户的操作更加方便和深入。这些外部命令都是以文件的形式存在，Windows系统的DOS外部命令保存在Windows主目录下的"Command"目录中。

#### 外部命令

|     命令     |             用法              |          命令           |             用法             |
| :----------: | :---------------------------: | :---------------------: | :--------------------------: |
|     calc     |          启动计算器           |      diskmgmt.msc       |       磁盘管理实用程序       |
| certmgr.msc  |       证书管理实用程序        |         dvdplay         |          DVD播放器           |
|   charmap    |        启动字符映射表         |         dxdiag          |       检查DirectX信息        |
|  chkdsk.exe  |        Chkdsk磁盘检查         |        eudcedit         |           造字程序           |
|   cmd.exe    |         CMD命令提示符         |        eventvwr         |          事件查看器          |
| compmgmt.msc |        打开计算机管理         |        explorer         |        打开资源管理器        |
|   cliconfg   | SQL SERVER 客户端网络实用程序 |       fsmgmt.msc        |       共享文件夹管理器       |
|   dcomcnfg   |       打开系统组件服务        |       gpedit.msc        |            组策略            |
| devmgmt.msc  |          设备管理器           |        iexpress         |    木马捆绑工具，系统自带    |
|    logoff    |           注销命令            |       ntmsmgr.msc       |        移动存储管理器        |
| lusrmgr.msc  |         本机用户和组          |      ntmsoprq.msc       |    移动存储管理员操作请求    |
|   magnify    |        放大镜实用程序         |        odbcad32         |       ODBC数据源管理器       |
|     mmc      |          打开控制台           |           osk           |         打开屏幕键盘         |
|   mobsync    |           同步命令            |       perfmon.msc       |      计算机性能监测程序      |
| Msconfig.exe |       系统配置实用程序        |       regedit.exe       |            注册表            |
|   mspaint    |            画图板             |        regedt32         |         注册表编辑器         |
|    mstsc     |         远程桌面连接          |       rononce -p        |           15秒关机           |
|   narrator   |         屏幕“讲述人”          | regsvr32 /u zipfldr.dll |         取消ZIP支持          |
| netstat -an  |       (TC)命令检查接口        |    regsvr32 /u *.dll    |       停止dll文件运行        |
|   notepad    |          打开记事本           |        rsop.msc         |         组策略结果集         |
|   Nslookup   |         IP地址侦测器          |       secpol.msc        |         本地安全策略         |
|   ntbackup   |        系统备份和还原         |      services.msc       |         本地服务设置         |
| sfc /scannow |        windows文件保护        |         taskmgr         |          任务管理器          |
|   sfc.exe    |        系统文件检查器         |        tsshutdn         |      60秒倒计时关机命令      |
|   shrpubw    |        创建共享文件夹         |         utilman         |        辅助工具管理器        |
|   sigverif   |       文件签名验证程序        |        wiaacmgr         |      扫描仪和照相机向导      |
|    winver    |        检查Windows版本        |       wmimgmt.msc       | 打开windows管理体系结构(WMI) |
|    write     |            写字板             |         wscript         |     windows脚本宿主设置      |

#### 内部命令

|    命令     |                      用法                      |      命令      |                     用法                     |
| :---------: | :--------------------------------------------: | :------------: | :------------------------------------------: |
|    assoc    |           显示或修改文件扩展名关联。           |     attrib     |             显示或更改文件属性。             |
|    break    |          设置或清除扩展式CTRL+C检查。          |    bootcfg     |   设置boot.ini文件的属性以便控制启动加载。   |
|    cacls    |      显示或修改文件的访问控制列表(ACL)。       |      call      |        从另一个批处理程序调用这一个。        |
|     cd      |         显示当前目录的名称或将其更改。         |      chcp      |           显示或设置活动代码页数。           |
|    chdir    |         显示当前目录的名称或将其更改。         |     color      |        设置默认控制台前景和背景颜色。        |
|   chkdsk    |            检查磁盘并显示状态报告。            |      comp      |          比较两个或两套文件的内容。          |
|   chkntfs   |          显示或修改启动时间磁盘检查。          |    compact     |       显示或更改NTFS分区上文件的压缩。       |
|     cls     |                   清除屏幕。                   |    convert     |  将FAT卷转换成NTFS。您不能转换当前驱动器。   |
|     cmd     |      打开另一个Windows命令解释程序窗口。       |      copy      |       将至少一个文件复制到另一个位置。       |
|    date     |                显示或设置日期。                |      MOVE      | 将一个或多个文件从一个目录移动到另一个目录。 |
|     del     |               删除至少一个文件。               |   OPENFILES    |    显示远程用户为了文件共享而打开的文件。    |
|     dir     |         显示一个目录中的文件和子目录。         | PAGEFILECONFIG |          显示或配置页面文件的属性。          |
|  DISKCOMP   |              比较两个软盘的内容。              |      path      |       为可执行文件显示或设置搜索路径。       |
|  DISKCOPY   |       将一个软盘的内容复制到另一个软盘。       |     pause      |       停止批处理文件的处理并显示信息。       |
|  DISKPART   |            显示或配置磁盘分区属性。            |      POPD      |    还原由PUSHD保存的当前目录上一次的值。     |
|   DOSKEY    |     编辑命令行、调用Windows命令并创建宏。      |     PRINT      |              打印一个文本文件。              |
| DRIVERQUERY |        显示当前设备驱动程序状态和属性。        |     PROMPT     |            改变Windows命令提示。             |
|    echo     |       显示消息，或将命令回显打开或关上。       |     PUSHD      |       保存当前目录，然后对其进行更改。       |
|  ENDLOCAL   |         结束批文件中环境更改的本地化。         |       rd       |                  删除目录。                  |
|    ERASE    |              删除一个或多个文件。              |    RECOVER     |       从损坏的磁盘中恢复可读取的信息。       |
| EVENTQUERY  |          显示指定准则的事件日志项目。          |      rem       |     记录批处理文件或CONFIG.SYS中的注释。     |
|    exit     |        退出CMD.EXE程序(命令解释程序)。         |      ren       |                重新命名文件。                |
|     fc      | 比较两个文件或两个文件集并显示它们之间的不同。 |     rename     |                重新命名文件。                |
|    find     |     在一个或多个文件中搜索一个文字字符串。     |    REPLACE     |                  替换文件。                  |
|   FINDSTR   |            在多个文件中搜索字符串。            |     rmdir      |                  删除目录。                  |
|     for     |   为一套文件中的每个文件运行一个指定的命令。   |      set       |      显示、设置或删除Windows环境变量。       |
|   FORMAT    |        格式化磁盘，以便跟Windows使用。         |    SETLOCAL    |        开始用批文件改变环境的本地化。        |
|   FSUTIL    |           显示或配置文件系统的属性。           |       sc       |          显示或配置服务(后台处理)。          |
|    ftype    |    显示或修改用在文件扩展名关联的文件类型。    |    SCHTASKS    |   安排命令和程序在一部计算机上按计划运行。   |
|    goto     |      将Windows命令解释程序指向批处理程序       |     SHIFT      |      调整批处理文件中可替换参数的位置。      |
|  GPRESULT   |          显示机器或用户的组策略信息。          |    SHUTDOWN    |         让机器在本地或远程正确关闭。         |
|  GRAFTABL   |     启用Windows在图形模式显示扩展字符集。      |      sort      |                 将输入排序。                 |
|    help     |          提供Windows命令的帮助信息。           |     start      |       打开单独视窗运行指定程序或命令。       |
|     if      |      在批处理程序中执行有条件的处理过程。      |     subst      |            将驱动器号与路径关联。            |
|    label    |          创建、更改或删除磁盘的卷标。          |   SYSTEMINFO   |         显示机器的具体的属性和配置。         |
|     md      |                 创建一个目录。                 |    tasklist    |      显示包括服务的所有当前运行的任务。      |
|    mkdir    |                 创建一个目录。                 |    taskkill    |        终止正在运行的进程或应用程序。        |
|    mode     |                 配置系统设备。                 |      time      |             显示或设置系统时间。             |
|    more     |                 逐屏显示输出。                 |     title      |         设置CMD.EXE会话的窗口标题。          |
|    wmic     |         在交互命令外壳里显示WMI信息。          |     verify     |    告诉Windows验证文件是否正确写入磁盘。     |
|    xcopy    |               复制文件和目录树。               |      ver       |             显示Windows的版本。              |
|     vol     |             显示磁盘卷标和序列号。             |      type      |             显示文本文件的内容。             |
|    tree     |       以图形显示启动器或路径的目录结构。       |      ping      |                   网络命令                   |

#### 常用命令整理

|    命令    |                           用法                           |   命令   |                用法                |
| :--------: | :------------------------------------------------------: | :------: | :--------------------------------: |
| dir /w\|/p | 查看当前目录的简要信息，只显示目录名称。\|查看分页信息。 |    cd    |            进入指定目录            |
|    ver     |                     查看DOS系统版本                      |   exit   |                退出                |
|     md     |                         建立目录                         |   cd\    |             退回根目录             |
|    cls     |                         清空屏幕                         |    rd    |              删除目录              |
|    del     |                     删除磁盘文件（）                     |   cd..   |          退回到上一级目录          |
|    copy    |                      复制文件夹内容                      |  title   |         设置命令行显示名称         |
|    date    |                    查看或设置电脑时间                    |   ren    |             批量重命名             |
|    tree    |                  以树形结构显示当前目录                  |    sc    |           显示或配置服务           |
|   format   |               当前磁盘格式化（format A:）                | tasklist | 显示包括服务的所有当前运行的任务。 |

