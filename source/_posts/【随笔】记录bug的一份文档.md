---
title: '【随笔】记录bug的一份文档'
author: 墨白
img: 
coverImg: 
top: false
cover: false
toc: true
mathjax: false
tags:
  - BUG
categories:
  - 后端
abbrlink: 174183769
date: 2020-0-16 14:34:34
password:
summary:
---

> 本文章是记录一些自己在开发中遇到的一些bug,并会贴上原因和解决方案,欢迎参观

### DiaryServiceTest

> 异常信息:
>
> ~~~xml
> Process finished with exit code 1 Class not found: "DiaryServiceTest"Empty test suite.
> ~~~
>
> **问题描述:**
>
> 运行项目中的测试类,IDEA提示错误\
>
> **解决方案**
>
> > 删除项目`target`文件夹即可,重新运行,再次运行IDEA会重新生成target文件夹，并且不再会提示以上错误

### On branch master Your branch is up to date with 'origin/master'.

![](https://tencent.cos.mobaijun.com/article_with_pictures/20200606115752.png)

**问题描述**

> 在使用了`git config --global credential.helper store`命令后提交本地修改过的文件到远程仓库就出现了以上异常
>
> >在分支主机上您的分行是“原始/主”最新的。未暂存以提交的更改：（使用“git add<file>..”更新将提交的内容）（使用“git restore<file>..”放弃工作目录中的更改）,显示git建议我放弃工作目录的更改,反正这次也没有提交上去,那么就挨个提交三个修改过的文件吧
>

~~~bash
# 撤销提交的具体文件
$  git restore 【随笔】记录bug的一份文档.md
$  git restore 软件工程琐碎知识点.md
# 将需要提交的内容添加到暂存区
$  git add 提交MySQL复习笔记.md
# 重新commit
$  git commit -m ':wastebasket: 提交MySQL复习笔记.md'
# push
$  git push origin master
~~~

### Cause: java.sql.SQLException:

* 报错信息

~~~xml
ause: java.sql.SQLException: Field 'id' doesn't have a default value
; Field 'id' doesn't have a default value; nested exception is java.sql.SQLException: Field 'id' doesn't have a default value
~~~

* 问题描述

> 使用mybatis-plus插入一条数据的时候使用主键自增策略,但是包这个错,原因数据库表主键未设置主键自增长,必须要数据库表和mybatisplus同时设置主键自增才可以成功插入数据

* 解决方案

> 必须要数据库表和mybatisplus同时设置主键自增才可以成功插入数据

### IDEA查看源码时提示：Library source does not match the bytecode for class的问题分析

>通过Maven查看依赖的源码时，通常是Maven自动下载JAR包附属的source包，但是会出现一个问题，由于使用lombok插件会造成编写的Java文件和编译后的class上有差别，所以IDEA打开时看到的是Maven打包时用的源码，而IDEA会自动匹配与.class反编译后的源代码，造成不匹配的提示。
>
>> * 解决方法其实可以说是没有。

### Exception in thread "main" java.lang.NoClassDefFoundError: org/apache/velocity/context/Context

> 报错信息:
>
> ![](https://tencent.cos.mobaijun.com/article_with_pictures/20200609135153.png)

* 问题描述

> 在使用mybatis-plus代码生成器自动生成代码的时候报错`NoClassDefFoundError: org/apache/velocity/context/Context`,pom.xml文件当中加入velocity的依赖

* 解决方案,导入`velocity-engine-core`包即可

~~~xml
<dependency>
    <groupId>org.apache.velocity</groupId>
    <artifactId>velocity-engine-core</artifactId>
    <version>2.0</version>
</dependency>
~~~

### Lombok Requires Annotation Processing: Do you want to enable annotation processors? Enable

> * 报错信息:
>
> ~~~xml
> Lombok Requires Annotation Processing: Do you want to enable annotation processors? Enable
> ~~~
>
> * 问题描述:
>
> 启动IDEA2020.1版本,控制台日志报错,翻译:[Lombok需要注释处理：是否要启用注释处理程序？启用]这句翻译太机械化了,但是打开这个就搞定了,毕竟lombok是一个插件,没必要深究

* 解决方案

![](https://tencent.cos.mobaijun.com/article_with_pictures/20200612225923.png)

### git上传异常

> 报错信息:fatal: unable to access 'https://gitee.com/wang_lianjie/mobai_images.gitee.i

我是这么解决的:

* 输入命令`exit`退出

* 重新打开`Git bash`

* 重新`push`

* ```bash
  git push origin master
  ```

成功!!!

特此记录一下