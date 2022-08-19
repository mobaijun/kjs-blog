---
title: 【工具系列】Git提交隐私内容到远程处理
author: 墨白
top: false
cover: false
toc: true
mathjax: false
abbrlink: 1088389935
date: 2022-06-13 11:31:22
img:
coverImg:
password:
summary:
tags:
- Git
categories:
- 工具
---

### 前言

> 最近加入了某个开源项目，今天早晨修复一个 bug ，提交了自己的配置文件，内容包含数据库密码等重要信息，关键居然是别人发现后告诉我的🤣，我自己记得明明排掉了那个配置文件，不晓得是不是修改 commit 的时候没注意提交上去了，反正发现的时候已经来不及抢救了。



### 如何解决？

1. 首先修改自己账户的账号密码，避免造成其他损失。
2. 删除线上的提交记录。



### 修改 MySQL 账号密码

* 修改账号密码

~~~sql
-- 将字段authentication_string置为空
UPDATE USER SET authentication_string = ''  WHERE USER = 'root';
-- 修改密码为123456
ALTER user 'root'@'localhost' IDENTIFIED BY '123456';
~~~

* 刷新权限

~~~sql
flush privileges;
~~~

> 以上操作适用于MySQL8.X版本



## 删除线上的提交记录

* 点击 idea git log ，选择提交记录

![](https://tencent.cos.mobaijun.com/article_with_pictures/image-20220819162645348.png)

* 点击 idea git \ Reset HEAD...

![](https://tencent.cos.mobaijun.com/article_with_pictures/image-20220819162709329.png)

* 需要几次回滚就写入几个 ^ 号

![](https://tencent.cos.mobaijun.com/article_with_pictures/image-20220819162732937.png)

* 重新提交内容，强制推送

~~~bash
git push origin master -f
~~~
