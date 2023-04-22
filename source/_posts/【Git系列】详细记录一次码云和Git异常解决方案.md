---
title: 【Git系列】详细记录一次码云和Git异常解决方案
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - Gitee
categories:
  - 工具
abbrlink: 3160757487
date: 2020-04-21 09:58:10
img:
coverImg:
password:
summary:
---

### 异常原因:

平时码云用的不是很多,之前做过一篇图床的教程,就把码云当作我博客的图床了,今天push的时候发现无法push了,查看了一下原因发现是因为邮箱设置和单个文件太大,mater分支有冲突,这么多问题有点尴尬,那就一个一个来解决吧

> ~~~bash
> $ git push origin master
> Enumerating objects: 26, done.
> Counting objects: 100% (26/26), done.
> Delta compression using up to 4 threads
> Compressing objects: 100% (22/22), done.
> Writing objects: 100% (23/23), 410.05 KiB | 10.00 MiB/s, done.
> Total 23 (delta 3), reused 0 (delta 0), pack-reused 0
> remote: Powered by GITEE.COM [GNK-5.0]
> remote: error: GE007: Your push would publish a private email address.
> remote: You can make your email public or disable this protection by visiting:
> remote: ************************
> remote: error: hook declined to update refs/heads/master
> To ************************
>  ! [remote rejected] master -> master (hook declined)
> error: failed to push some refs to '************************'
> ~~~
>
> 通过以上信息可以看到总共有三个错误
>
> * 第一个: **推送给一个私人邮箱**
>
> ~~~bash
> GE007: Your push would publish a private email address
> ~~~
>
> * 第二个:**拒绝更新**
>
> ~~~bash
> error: hook declined to update refs/heads/master
> ~~~
>
> * 第三个:**无法推送**
>
> ~~~bash
> failed to push some refs to
> ~~~

### 异常解决:

因为我这个是解决了邮箱问题就可以正常push了,所以我就附上邮箱解决方案,可能是我某一次设置码云个人信息的时候乱点导致邮箱设置成禁止命令行推送暴露个人邮箱,所以关闭这个选项卡即可,定位到`设置\多邮箱管理\禁止命令行推送暴露个人邮箱`关闭;

![](https://tencent.cos.mobaijun.com/img/blog/【Git系列】详细记录一次码云和Git异常解决方案/0.png)
