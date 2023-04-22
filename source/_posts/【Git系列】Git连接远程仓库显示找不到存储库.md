---
title: 【Git系列】Git连接远程仓库显示找不到存储库
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - 异常
categories:
  - 工具
abbrlink: 529462237
date: 2020-05-11 09:59:05
img:
coverImg:
password:
summary:
---

* 今天在公司上传部分代码到GitHub远程库,结果无法push,Git报错信息显示找不到存储库

~~~bash
$ git push origin master
ERROR: Repository not found.
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
~~~

> * 报错信息显示无法从远程库读取
> * 需要保证我有正确的访问权限
> * 非常无语……………这个问题折腾了差不多半个小时,最后决定还是直接clone仓库吧,然后发现我前几天很闲的时候改了GitHub用户名.......这样我本地的用户名和GitHub上的用户名是对不上的,所以我必须要修改本地的用户名
> * 忠告:建议大家在GitHub起名的时候好好取名,不然修改名称以后真的是搞死人

* **在clone的时候输入账户密码即可(公共库不需要,私有库需要)**


* **使用config --global命令查看当前用户配置信息**

~~~bash
$ git config --global -l
user.email=mobaijun8@163.com
user.name=mobaijun8
*************************
******忽略部分内容*******
*************************
core.autocrlf=false
~~~

* 修改用户名和GitHub一样

~~~bash
$ git config --global user.name 'mobaijun'
~~~

* 查看是否修改成功

~~~bash
$ git config --global user.name
mobaijun
~~~

* 重新push

~~~bash
$ git push origin master
Enumerating objects: 93, done.
Counting objects: 100% (93/93), done.
Delta compression using up to 4 threads
****************************** 忽略部分内容
   fc76ec5..7f98b21  master -> master
~~~

