---
title: 【工具系列】GitHub添加密钥
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - SSH
categories:
  - 工具
abbrlink: 1298567324
date: 2020-05-11 10:53:49
img:
coverImg:
password:
summary:
---

**GitHub添加密钥具体操作**

定位到你GitHub需要上传的库位置[mobaijun](https://github.com/mobaijun)/**[blog_project](https://github.com/mobaijun/blog_project)**/,添加ssh密钥,`/settings/Deploy keys/Add deploy Keys/`点击新建一个SSH密钥

将你本地的密钥上传到复制添加到GitHub即可

![](https://mobaijun.gitee.io/mobai_images.gitee.io/img/2020-5-9/5.jpg)

有些朋友可能是第一次在电脑上配置Git,那么是没有SSH密钥的,需要生成一个,如果是`第一次配置`,需要进行以下步骤

* 配置git用户名和邮箱

~~~bash
# 配置你的用户名称,和GitHub上的名称一样
$ git config --global user.name "你的用户名"
# 配置你的邮箱,和码云账户上的一样
$ git config --global user.email "你的邮箱"
# 配置好了以后你可以查看你的用户名和邮箱是否正确
# 查看用户名
$ git config user.name
# 查看邮箱
$ git config user.email
~~~

生成你的SSH密钥:一路回车,中间可以打个yes😁,ssh，简单来讲，就是一个秘钥，其中，id_rsa是你这台电脑的私人秘钥，不能给别人看的，id_rsa.pub是公共秘钥，可以随便给别人看。把这个公钥放在GitHub上，这样当你链接GitHub自己的账户时，它就会根据公钥匹配你的私钥，当能够相互匹配时，才能够顺利的通过git上传你的文件到GitHub上

~~~bash
# 本地生成你的密钥
$ ssh-keygen -t rsa -C "你的用户名"
# 这个时候它会告诉你已经生成了.ssh的文件夹。在你的电脑中找到这个文件夹。或者git bash中输入
# 查看你的密钥
$ cat ~/.ssh/id_rsa.pub
~~~

这时候直接复制显示的密钥添加到GitHub即可

确认本地上传方式是`https`还是`SSH`,ssh是正确的

~~~bash
$ git remote -v
origin  git@github.com:mobaijun8/blog_project.git (fetch)
origin  git@github.com:mobaijun8/blog_project.git (push)
~~~

